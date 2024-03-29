﻿using MHI_OJT2.Pages.Systems;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Management
{
    public partial class Evaluation : System.Web.UI.Page
    {
        public static int _courseId = 0;
        public static int _isEvaluation = 0;
        public static int _approveId = 0;
        public static int _approveSequence = 0;
        public static string ajax = "";
        public static bool _is_exam_evaluate = false;
        public static bool _is_real_work_evaluate = false;
        protected void Page_Load(object sender, EventArgs e)
        {
			ajax = HttpContext.Current.Request.ApplicationPath == "/" ? "" : HttpContext.Current.Request.ApplicationPath;
			Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
                GetCourseIdFromSession();
                string role = Session["roles"].ToString().ToLower();
                if (role == "user")
                {
                    int personId = int.Parse(Session["userId"].ToString());
                    if (CheckIsApprover(_courseId, personId) == 0)
                    {
                        Response.Redirect(Auth.Dashboard);
                    }
                }

            }
        }
        static int CheckIsApprover(int courseId, int personId)
        {
            try
            {
                string query = $"SELECT * FROM APPROVAL WHERE COURSE_ID = {courseId} AND PERSON_ID = {personId}";
                DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
                return 1;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 0;
            }
        }
        void GetCourseIdFromSession()
        {
            try
            {
                if (Session["EVALUATE_COURSE_ID"] != null)
                {
                    int courseId = int.Parse(Session["EVALUATE_COURSE_ID"].ToString());
                    int isEvaluation = int.Parse(Session["IS_EVALUATION"].ToString());

                    int approveId = 0;
                    int approveSequence = 0;

                    if (isEvaluation == 0)
                    {
                        approveId = int.Parse(Session["EVALUATE_APPROVE_ID"].ToString());
                        approveSequence = int.Parse(Session["EVALUATE_APPROVAL_SEQUENCE"].ToString());

                    }
                    if (courseId > 0)
                    {
                        _isEvaluation = isEvaluation;
                        _courseId = courseId;

                        if (isEvaluation == 0)
                        {
                            _approveId = approveId;
                            _approveSequence = approveSequence;

                        }

                        string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                        SqlParameterCollection param = new SqlCommand().Parameters;
                        param.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
                        
                        DataTable dt = SQL.GetDataTableWithParams("SELECT * FROM COURSE_AND_EMPLOYEE WHERE COURSE_ID=@courseId", mainDb, param);

                        if (dt.Rows.Count > 0)
                        {
                            _is_exam_evaluate = (bool)dt.Rows[0]["IS_EXAM_EVALUATE"];
                            _is_real_work_evaluate = (bool)dt.Rows[0]["IS_REAL_WORK_EVALUATE"];

                            string _title = $"[{dt.Rows[0]["COURSE_NUMBER"]}] - {dt.Rows[0]["COURSE_NAME"]} No.{dt.Rows[0]["TIMES"]}";
                            title.InnerText = _title;

                            RepeatCourseTable.DataSource = dt;
                            RepeatCourseTable.DataBind();


                            if (isEvaluation == 0)
                            {
                                _approveId = approveId;
                                _approveSequence = approveSequence;

                                Session.Remove("EVALUATE_COURSE_ID");
                                Session.Remove("EVALUATE_APPROVE_ID");
                                Session.Remove("EVALUATE_APPROVAL_SEQUENCE");
                                Session.Remove("IS_EVALUATION");
                            }
                        } else
                        {
                            throw new Exception("ไม่พนักงานในหลักสูตร กรุณาตรวจสอบรายชื่อที่เข้าร่วมอบรมอีกครั้ง");
                        }
                    };
                } else
                {
                    Response.Redirect(Auth.Dashboard);
                }
            } catch(Exception ex)
            {
                Alert("error", "ERROR!", $"{ex.Message}");
            }
        }
        void Alert(string type, string title, string message)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
        }
        [WebMethod]
        public static int SaveEvaluateResults(List<Evaluated> EvaluatedList,Boolean IsDraft,string EvaluatedDate)
        {
            try
            {
                int successCount = 0;
			    string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                List<Evaluated> list = EvaluatedList;
                for (int i = 0; i < list.Count; i++)
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string queryString = "UPDATE EVALUATE SET EXAM_SCORE=@EXAM_SCORE,SCORE_1=@SCORE_1,SCORE_2=@SCORE_2,SCORE_3=@SCORE_3,SCORE_4=@SCORE_4,SCORE_5=@SCORE_5,TOTAL_SCORE=@TOTAL_SCORE,CREATED_AT=GETDATE() WHERE COURSE_ID=@COURSE_ID AND PERSON_ID=@PERSON_ID";
                        using (SqlCommand cmd = new SqlCommand(queryString, connection))
                        {
                            cmd.Parameters.AddWithValue("COURSE_ID", SqlDbType.Int).Value = _courseId;
                            cmd.Parameters.AddWithValue("PERSON_ID", SqlDbType.Int).Value = list[i].PersonID;
                            cmd.Parameters.AddWithValue("SCORE_1", SqlDbType.Float).Value = list[i].Score_1;
                            cmd.Parameters.AddWithValue("SCORE_2", SqlDbType.Float).Value = list[i].Score_2;
                            cmd.Parameters.AddWithValue("SCORE_3", SqlDbType.Float).Value = list[i].Score_3;
                            cmd.Parameters.AddWithValue("SCORE_4", SqlDbType.Float).Value = list[i].Score_4;
                            cmd.Parameters.AddWithValue("SCORE_5", SqlDbType.Float).Value = list[i].Score_5;
                            cmd.Parameters.AddWithValue("EXAM_SCORE", SqlDbType.Float).Value = list[i].Exam;
                            cmd.Parameters.AddWithValue("TOTAL_SCORE", SqlDbType.Float).Value = list[i].Total;

                            connection.Open();
                            cmd.ExecuteNonQuery();
                            connection.Close();

                            successCount++;
                        }
                    }
                }

                if (!IsDraft)
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        string queryString = "UPDATE ADJUST_COURSE SET [STATUS]=3 ";
                        bool hasEvaluatedDate = EvaluatedDate.Length > 0 && !string.IsNullOrWhiteSpace(EvaluatedDate);
                        if (hasEvaluatedDate)
                        {
                            queryString += ",EVALUATED_DATE=@EVAL_DATE";
                        }
                        queryString += " WHERE ID=@COURSE_ID";
                        using (SqlCommand cmd = new SqlCommand(queryString, connection))
                        {
                            cmd.Parameters.AddWithValue("COURSE_ID", SqlDbType.Int).Value = _courseId;

                            if (hasEvaluatedDate)
                            {
                                cmd.Parameters.AddWithValue("EVAL_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(EvaluatedDate);
                            }

                            connection.Open();
                            cmd.ExecuteNonQuery();
                            connection.Close();

                            try
                            {
                                ObjectLog obj = new ObjectLog();
                                obj.TITLE = "ประเมินผลหลักสูตร";
                                obj.REMARK = "บันทึกการประเมินผลหลักสูตร";
                                obj.TABLE_NAME = "ADJUST_COURSE";
                                obj.FK_ID = _courseId;
                                Log.Create("edit", obj);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine(ex.Message);
                            }
                        }
                    }
                }
                HttpContext.Current.Session.Add("alert", "evaluated");
                return successCount;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 0;
            }
        }
    }
    public class Evaluated
    {
        public int PersonID { get; set; }
        public float Score_1 { get; set; }
        public float Score_2 { get; set; }
        public float Score_3 { get; set; }
        public float Score_4 { get; set; }
        public float Score_5 { get; set; }
        public float Total { get; set; }
        public float Exam { get; set; }
    }
}