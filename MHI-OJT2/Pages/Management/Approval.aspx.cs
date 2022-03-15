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
        string _sessionAlert = String.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckAlertSession();
                if ((string)Session["roles"] == "user")
                {
                    RepeatTable.DataSource = GetApproveList(int.Parse(Session["userId"].ToString()));
                    RepeatTable.DataBind();
                }
            }
        }
        void CheckAlertSession()
        {
            _sessionAlert = null;
            if (Session["alert"] != null)
            {
                _sessionAlert = Session["alert"] as string;

                if (_sessionAlert == "approved")
                {
                    Alert("success", "Done!", "Successfully data added.");
                };

                Session.Remove("alert");
            }
        }
        void Alert(string type, string title, string message)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
        }
        public static DataTable GetApproveList(int userId)
        {
            string query = "SELECT * FROM ( " +
                "SELECT ADJ.ID " +
                ",COURSE_NUMBER " +
                ",COURSE_NAME " +
                ",DEPARTMENT_NAME " +
                ",[STATUS] " +
                ",(SELECT SUM(CAST(ISNULL(APPROVAL_RESULT,0) AS INT)) FROM APPROVAL WHERE COURSE_ID = ADJ.ID) COUNT_APPROVED_RESULT " +
                ",(SELECT APPROVAL_SEQUENCE FROM APPROVAL WHERE COURSE_ID = ADJ.ID AND PERSON_ID = @USER_ID) APPROVAL_SEQUENCE " +
                ",(SELECT ID FROM APPROVAL WHERE COURSE_ID = ADJ.ID AND PERSON_ID = @USER_ID) APPROVAL_ID " +
                "FROM ADJUST_COURSE ADJ " +
                "JOIN DEPARTMENT DEP ON DEP.ID = ADJ.DEPARTMENT_ID " +
                "WHERE [STATUS] >= 3" +
                "AND (ASSESSOR1_ID = @USER_ID " +
                "OR ASSESSOR2_ID = @USER_ID " +
                "OR ASSESSOR3_ID = @USER_ID " +
                "OR ASSESSOR4_ID = @USER_ID " +
                "OR ASSESSOR5_ID = @USER_ID " +
                "OR ASSESSOR6_ID = @USER_ID) " +
                ") DATA " +
                "WHERE COUNT_APPROVED_RESULT+1 = APPROVAL_SEQUENCE ";
            SqlParameterCollection param = new SqlCommand().Parameters;
            param.AddWithValue("USER_ID", SqlDbType.Int).Value = userId;
            return SQL.GetDataTableWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
        }
        [WebMethod]
        public static string HandleApprove(ApproveResult _ApproveResult)
        {
            if (_ApproveResult.IS_APPROVE == 0)
            {
                RejectApprovalUpdate(_ApproveResult.COURSE_ID);
                HttpContext.Current.Session.Add("alert", "approved");
                return "REJECTED";
            }

			string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
            SqlConnection connection = new SqlConnection(connectionString);
            
            using (SqlCommand command = new SqlCommand("UPDATE APPROVAL SET APPROVAL_RESULT=@IS_APPROVE,IS_APPROVED=1 WHERE ID=@APPROVE_ID", connection))
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
                    LastOfApprovalUpdate(_ApproveResult.COURSE_ID);
                }
            }


            HttpContext.Current.Session.Add("alert", "approved");
            return "APPROVED";
        }
        public static int LastOfApprovalUpdate(int courseId)
        {
            try
            {
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("COURSE_ID", SqlDbType.Int).Value = courseId;
                SQL.ExecuteWithParams("UPDATE ADJUST_COURSE SET STATUS=9 WHERE ID=@COURSE_ID", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
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
                SQL.ExecuteWithParams("UPDATE APPROVAL SET APPROVAL_RESULT=0,IS_APPROVED=1 WHERE COURSE_ID=@COURSE_ID AND IS_APPROVED=0", connectionString, param);

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