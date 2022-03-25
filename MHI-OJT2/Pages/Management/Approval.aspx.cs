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
    public partial class Approval : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();

            if (!IsPostBack)
            {
                if ((string)Session["roles"] == "user")
                {
                    int userId = int.Parse(Session["userId"].ToString());
                    DataTable dt = SQL.GetDataTable($"SELECT ID FROM APPROVAL WHERE PERSON_ID = {userId}", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
                    if (dt.Rows.Count < 1)
                    {
                        Response.Redirect(Auth._403);
                    }
                    RepeatTable.DataSource = GetApproveList(userId);
                    RepeatTable.DataBind();
                }
            }
        }
        public static DataTable GetApproveList(int userId)
        {
            return SQL.GetDataTable($"EXEC SP_APPROVAL_LIST {userId}", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
        }
        [WebMethod]
        public static string ShowScore(ApproveResult _ApproveResult)
        {
            try
            {
                HttpContext.Current.Session.Add("EVALUATE_COURSE_ID", _ApproveResult.COURSE_ID);
                HttpContext.Current.Session.Add("EVALUATE_APPROVE_ID", _ApproveResult.APPROVE_ID);
                HttpContext.Current.Session.Add("EVALUATE_APPROVAL_SEQUENCE", _ApproveResult.APPROVAL_SEQUENCE);
                HttpContext.Current.Session.Add("IS_EVALUATION", 0);
                return "OK";
            }               
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return "ERROR";
            }
        }
        [WebMethod]
        public static string HandleApprove(ApproveResult _ApproveResult)
        {
            HttpCookie approveCookie = new HttpCookie("alert");
            approveCookie.Expires = DateTime.Now.AddSeconds(5);
            if (_ApproveResult.IS_APPROVE == 0)
            {
                RejectApprovalUpdate(_ApproveResult.COURSE_ID);
                SetCourseApproveNotify(_ApproveResult.COURSE_ID, false);
                approveCookie.Value = "rejected";
                return "REJECTED";
            }

			string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);
            
            using (SqlCommand command = new SqlCommand("UPDATE APPROVAL SET APPROVAL_RESULT=@IS_APPROVE,IS_APPROVED=1,ACTION_DATE=GETDATE() WHERE ID=@APPROVE_ID", connection))
            {
                command.Parameters.AddWithValue("APPROVE_ID", SqlDbType.Int).Value = _ApproveResult.APPROVE_ID;
                command.Parameters.AddWithValue("IS_APPROVE", SqlDbType.Bit).Value = _ApproveResult.IS_APPROVE;

                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();

                string query = "UPDATE ADJUST_COURSE " +
                    "SET [STATUS]=(SELECT [STATUS] FROM ADJUST_COURSE WHERE ID = " + _ApproveResult.COURSE_ID + ")+1 " +
                    "WHERE ID=" + _ApproveResult.COURSE_ID;
                using (SqlCommand update = new SqlCommand(query, connection))
                {
                    connection.Open();
                    update.ExecuteNonQuery();
                    connection.Close();
                }
            }

            // check if last approval
            using(SqlCommand command = new SqlCommand("SELECT * FROM APPROVAL WHERE COURSE_ID=@COURSE_ID", connection))
            {
                command.Parameters.AddWithValue("COURSE_ID", SqlDbType.Int).Value = _ApproveResult.COURSE_ID;

                connection.Open();
                command.CommandType = CommandType.Text;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = command;
                connection.Close();

                DataTable dt = new DataTable();
                da.Fill(dt);
                    
                if (dt.Rows.Count == _ApproveResult.APPROVAL_SEQUENCE)
                {
                    SetCourseApproved(_ApproveResult.COURSE_ID);
                    SetCourseApproveNotify(_ApproveResult.COURSE_ID, true);
                }
            }

            approveCookie.Value = "approved";
            HttpContext.Current.Response.Cookies.Add(approveCookie);
            return "APPROVED";
        }
        public static int SetCourseApproveNotify(int courseId, Boolean isApproved)
        {
            try
            {
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("COURSE_ID", SqlDbType.Int).Value = courseId;
                param.AddWithValue("IS_APPROVED", SqlDbType.Bit).Value = isApproved;
                string query = "INSERT INTO CLERK_NOTIFICATION(COURSE_ID,APPROVE_RESULT) VALUES(@COURSE_ID,@IS_APPROVED)";
                SQL.ExecuteWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
                return 1;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 0;
            }
        }
        public static int SetCourseApproved(int courseId)
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("COURSE_ID", SqlDbType.Int).Value = courseId;
                SQL.ExecuteWithParams("UPDATE ADJUST_COURSE SET STATUS=9 WHERE ID=@COURSE_ID", connectionString, param);
                SQL.ExecuteWithParams("UPDATE TRAINING_PLAN " +
                    "SET ACTUAL_DATE=(SELECT START_DATE FROM ADJUST_COURSE WHERE ID=@COURSE_ID) " +
                    "WHERE ID=(SELECT PLAN_ID FROM PLAN_AND_COURSE WHERE COURSE_ID = @COURSE_ID)", connectionString, param);
                return 1;

            } catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 0;
            }
        }

        public static int RejectApprovalUpdate(int courseId)
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("COURSE_ID", SqlDbType.Int).Value = courseId;
                SQL.ExecuteWithParams("UPDATE ADJUST_COURSE SET STATUS=10 WHERE ID=@COURSE_ID", connectionString, param);
                SQL.ExecuteWithParams("UPDATE APPROVAL SET APPROVAL_RESULT=0,IS_APPROVED=1,ACTION_DATE=GETDATE() WHERE COURSE_ID=@COURSE_ID AND IS_APPROVED=0", connectionString, param);

                return 1;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 0;
            }
        }
    }
    public class ApproveResult
    {
        public int APPROVE_ID { get; set; }
        public int COURSE_ID { get; set; }
        public int IS_APPROVE { get; set; }
        public int APPROVAL_SEQUENCE { get; set; }
    }
}