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
    public partial class Training_plans : System.Web.UI.Page
    {
        string _sessionAlert = null;
        string _selfPathName = "~/Pages/Management/Training-plans.aspx";
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();

            if (!IsPostBack)
            {
                string role = Session["roles"].ToString().ToLower();
                int userId = int.Parse(Session["userId"].ToString());
                if (role == "user")
                {
                    Response.Redirect(Auth._403);
                }

                GetMasterData(userId, role);
                CheckAlertSession();
            }
        }
        void CheckAlertSession()
        {
            _sessionAlert = null;
            if (Session["alert"] != null)
            {
                _sessionAlert = Session["alert"] as string;

                if (_sessionAlert == "inserted")
                {
                    Alert("success", "Done!", "Successfully data added.");
                };

                if (_sessionAlert == "updated")
                {
                    Alert("success", "Updated!", "Successfully updated data.");
                }

                if (_sessionAlert == "deleted")
                {
                    Alert("success", "Deleted!", "The data has been deleted.");
                }
                Session.Remove("alert");
            }
        }
        void GetMasterData(int userId, string role)
        {
            // get connection string from web.config file
            string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

            department.DataSource = SQL.GetDataTable("SELECT ID,DEPARTMENT_NAME FROM DEPARTMENT WHERE IS_ACTIVE=1", mainDb);
            department.DataValueField = "ID";
            department.DataTextField = "DEPARTMENT_NAME";
            department.DataBind();
            department.Items.Insert(0, new ListItem("-", "0"));
            department.SelectedIndex = 0;

            string query = "SELECT " +
                "p.* ," +
                "d.DEPARTMENT_NAME " +
                "FROM TRAINING_PLAN p " +
                "JOIN DEPARTMENT d ON d.ID = p.DEPARTMENT_ID ";

            if (role == "clerk")
            {
                query += $"WHERE p.CREATED_BY = {userId}";
            }
            RepeatTrainingPlanTable.DataSource = SQL.GetDataTable(query, mainDb);
            RepeatTrainingPlanTable.DataBind();
        }
        void Alert(string type, string title, string message)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
        }
        protected void btnInserted_Click(object sender, EventArgs e)
        {
            try
            {
                // get connection string from web.config file
                string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

                // query string builder
                string query = "INSERT INTO [TRAINING_PLAN] (" +
                    "[DEPARTMENT_ID] " +
                    ",[PLAN_NAME] " +
                    ",[REF_DOCUMENT] " +
                    ",[HOURS] " +
                    ",[FREQUENCY] " +
                    ",[SM_MG] " +
                    ",[SAM_AM] " +
                    ",[SEG_SV] " +
                    ",[EG_ST] " +
                    ",[FM] " +
                    ",[LD_SEP_EP] " +
                    ",[OP] " +
                    ",[PLAN_DATE] " +
                    ",[TRAINER]" +
                    ",[CREATED_BY]" +
                    ") VALUES(" +
                    "@DEPARTMENT_ID" +
                    ",@PLAN_NAME" +
                    ",@REF_DOCUMENT" +
                    ",@HOURS" +
                    ",@FREQUENCY" +
                    ",@SM_MG" +
                    ",@SAM_AM" +
                    ",@SEG_SV" +
                    ",@EG_ST" +
                    ",@FM" +
                    ",@LD_SEP_EP" +
                    ",@OP" +
                    ",@PLAN_DATE" +
                    ",@TRAINER" +
                    ",@CREATED_BY)";

                // new parameter collection
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("DEPARTMENT_ID", SqlDbType.Int).Value = department.Value;
                param.AddWithValue("PLAN_NAME", SqlDbType.VarChar).Value = planName.Value;
                param.AddWithValue("REF_DOCUMENT", SqlDbType.VarChar).Value = refDocument.Value;
                param.AddWithValue("HOURS", SqlDbType.Int).Value = hours.Value;
                param.AddWithValue("FREQUENCY", SqlDbType.VarChar).Value = frequency.Value;
                param.AddWithValue("SM_MG", SqlDbType.Bit).Value = SM_MG.Checked;
                param.AddWithValue("SAM_AM", SqlDbType.Bit).Value = SAM_AM.Checked;
                param.AddWithValue("SEG_SV", SqlDbType.Bit).Value = SEG_SV.Checked;
                param.AddWithValue("EG_ST", SqlDbType.Bit).Value = EG_ST.Checked;
                param.AddWithValue("FM", SqlDbType.Bit).Value = FM.Checked;
                param.AddWithValue("LD_SEP_EP", SqlDbType.Bit).Value = LD_SEP_EP.Checked;
                param.AddWithValue("OP", SqlDbType.Bit).Value = OP.Checked;
                param.AddWithValue("PLAN_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(date.Value);
                param.AddWithValue("TRAINER", SqlDbType.VarChar).Value = trainer.Value;
                param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];

                // execute query
                SQL.ExecuteWithParams(query, mainDb, param);

                // create session for alert
                Session.Add("alert", "inserted");

                // refresh page
                Response.Redirect(_selfPathName);
            }
            catch (Exception ex)
            {
                Alert("error", "Error!", $"{ex.Message}");
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            try
            {
                // get connection string from web.config file
                string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

                // query string builder
                string query = "UPDATE [TRAINING_PLAN] SET " +
                    "[DEPARTMENT_ID]=@DEPARTMENT_ID" +
                    ",[PLAN_NAME]=@PLAN_NAME" +
                    ",[REF_DOCUMENT]=@REF_DOCUMENT" +
                    ",[HOURS]=@HOURS" +
                    ",[FREQUENCY]=@FREQUENCY" +
                    ",[SM_MG]=@SM_MG" +
                    ",[SAM_AM]=@SAM_AM" +
                    ",[SEG_SV]=@SEG_SV" +
                    ",[EG_ST]=@EG_ST" +
                    ",[FM]=@FM" +
                    ",[LD_SEP_EP]=@LD_SEP_EP" +
                    ",[OP]=@OP" +
                    ",[PLAN_DATE]=@PLAN_DATE" +
                    ",[TRAINER]=@TRAINER" +
                    ",[CREATED_BY]=@CREATED_BY " +
                    "WHERE ID=@ID";

                // new parameter collection
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("DEPARTMENT_ID", SqlDbType.Int).Value = department.Value;
                param.AddWithValue("PLAN_NAME", SqlDbType.VarChar).Value = planName.Value;
                param.AddWithValue("REF_DOCUMENT", SqlDbType.VarChar).Value = refDocument.Value;
                param.AddWithValue("HOURS", SqlDbType.Int).Value = hours.Value;
                param.AddWithValue("FREQUENCY", SqlDbType.VarChar).Value = frequency.Value;
                param.AddWithValue("SM_MG", SqlDbType.Bit).Value = SM_MG.Checked;
                param.AddWithValue("SAM_AM", SqlDbType.Bit).Value = SAM_AM.Checked;
                param.AddWithValue("SEG_SV", SqlDbType.Bit).Value = SEG_SV.Checked;
                param.AddWithValue("EG_ST", SqlDbType.Bit).Value = EG_ST.Checked;
                param.AddWithValue("FM", SqlDbType.Bit).Value = FM.Checked;
                param.AddWithValue("LD_SEP_EP", SqlDbType.Bit).Value = LD_SEP_EP.Checked;
                param.AddWithValue("OP", SqlDbType.Bit).Value = OP.Checked;
                param.AddWithValue("PLAN_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(date.Value);
                param.AddWithValue("TRAINER", SqlDbType.VarChar).Value = trainer.Value;
                param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
                param.AddWithValue("ID", SqlDbType.Int).Value = hiddenIdAddModal.Value;

                // execute query
                SQL.ExecuteWithParams(query, mainDb, param);

                // add alert session
                Session.Add("alert", "updated");

                // refresh page
                Response.Redirect(_selfPathName);
            }
            catch (Exception ex)
            {
                Alert("error", "Error!", $"{ex.Message}");
            }
        }
        [WebMethod]
        public static string DeletePlan(int planId)
        {
            try
            {
                string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

                // check use data
                int usedRowCount = 0;

                SqlConnection usedConnection = new SqlConnection(connectionString);
                SqlCommand usedCommand = new SqlCommand("SELECT ID FROM PLAN_AND_COURSE WHERE PLAN_ID = @planId", usedConnection);
                usedConnection.Open();
                usedCommand.Parameters.AddWithValue("planId", SqlDbType.Int).Value = planId;
                usedCommand.CommandType = CommandType.Text;
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = usedCommand;
                usedConnection.Close();

                DataTable dt = new DataTable();
                da.Fill(dt);
                usedRowCount = dt.Rows.Count;

                // throw exeption if data is used
                if (usedRowCount > 0) return "USED";

                // delete data command
                SqlConnection deleteConnection = new SqlConnection(connectionString);
                SqlCommand deleteCommand = new SqlCommand("DELETE FROM TRAINING_PLAN WHERE ID=@planId", deleteConnection);
                deleteCommand.Parameters.AddWithValue("planId", SqlDbType.Int).Value = planId;
                deleteConnection.Open();
                deleteCommand.ExecuteNonQuery();
                deleteConnection.Close();

                // deleted
                HttpContext.Current.Session["alert"] = "deleted";
                return "SUCCESS";
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return "ERROR";
            }
        }
    }
}