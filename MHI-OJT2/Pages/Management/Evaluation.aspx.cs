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
        protected void Page_Load(object sender, EventArgs e)
        {
           if (!IsPostBack)
            {
                GetCourseIdFromSession();
            }
        }
        void GetCourseIdFromSession()
        {
            try
            {
                if (Session["EVALUATE_COURSE_ID"] != null)
                {
                    int courseId = int.Parse(Session["EVALUATE_COURSE_ID"].ToString());
                    if (courseId > 0)
                    {
                        _courseId = courseId;

                        string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                        SqlParameterCollection param = new SqlCommand().Parameters;
                        param.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
                        
                        DataTable dt = SQL.GetDataTableWithParams("SELECT * FROM COURSE_AND_EMPLOYEE WHERE COURSE_ID=@courseId", mainDb, param);

                        if (dt.Rows.Count > 0)
                        {
                            string _title = $"[{dt.Rows[0]["COURSE_NUMBER"]}] - {dt.Rows[0]["COURSE_NAME"]} No.{dt.Rows[0]["TIMES"]}";
                            title.InnerText = _title;

                            RepeatCourseTable.DataSource = dt;
                            RepeatCourseTable.DataBind();

                            Session.Remove("EVALUATE_COURSE_ID");
                        } else
                        {
                            throw new Exception("Not found employee in training course, Please choose employee into training course.");
                        }
                    };
                } else
                {
                    Response.Redirect("~/Pages/Management/Courses.aspx");
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
        public static int SaveEvaluateResults(List<Evaluated> EvaluatedList,Boolean IsDraft)
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
                        string queryString = "UPDATE EVALUATE SET SCORE_1=@SCORE_1,SCORE_2=@SCORE_2,SCORE_3=@SCORE_3,SCORE_4=@SCORE_4,SCORE_5=@SCORE_5,TOTAL_SCORE=@TOTAL_SCORE,CREATED_AT=GETDATE() WHERE COURSE_ID=@COURSE_ID AND PERSON_ID=@PERSON_ID";
                        using (SqlCommand cmd = new SqlCommand(queryString, connection))
                        {
                            cmd.Parameters.AddWithValue("COURSE_ID", SqlDbType.Int).Value = _courseId;
                            cmd.Parameters.AddWithValue("PERSON_ID", SqlDbType.Int).Value = list[i].PersonID;
                            cmd.Parameters.AddWithValue("SCORE_1", SqlDbType.Int).Value = list[i].Score_1;
                            cmd.Parameters.AddWithValue("SCORE_2", SqlDbType.Int).Value = list[i].Score_2;
                            cmd.Parameters.AddWithValue("SCORE_3", SqlDbType.Int).Value = list[i].Score_3;
                            cmd.Parameters.AddWithValue("SCORE_4", SqlDbType.Int).Value = list[i].Score_4;
                            cmd.Parameters.AddWithValue("SCORE_5", SqlDbType.Int).Value = list[i].Score_5;
                            cmd.Parameters.AddWithValue("TOTAL_SCORE", SqlDbType.Int).Value = list[i].Total;

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
                        string queryString = "UPDATE ADJUST_COURSE SET [STATUS]=3, EVALUATED_DATE=GETDATE()  WHERE ID=@COURSE_ID";
                        using (SqlCommand cmd = new SqlCommand(queryString, connection))
                        {
                            cmd.Parameters.AddWithValue("COURSE_ID", SqlDbType.Int).Value = _courseId;

                            connection.Open();
                            cmd.ExecuteNonQuery();
                            connection.Close();
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
        public int Score_1 { get; set; }
        public int Score_2 { get; set; }
        public int Score_3 { get; set; }
        public int Score_4 { get; set; }
        public int Score_5 { get; set; }
        public int Total { get; set; }
    }
}