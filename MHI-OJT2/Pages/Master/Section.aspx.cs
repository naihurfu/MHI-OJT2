using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Master
{
    public partial class Section : System.Web.UI.Page
    {
		string _sessionAlert;
		string _selfPathName = "~/Pages/Master/Section.aspx";
		protected void Page_Load(object sender, EventArgs e)
        {
              if (!IsPostBack)
            {
				GetSection();
				CheckAlertSession();
			}
        }
        void GetSection()
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
			string query = "SELECT sec.*" +
				",CONCAT(usr.INITIAL_NAME,usr.FIRST_NAME, ' ',usr.LAST_NAME) CREATED_NAME " +
				"FROM [SECTION] sec " +
				"JOIN SYSTEM_USERS usr ON usr.ID = sec.CREATED_BY";
            RepeatTable.DataSource = SQL.GetDataTable(query, MainDB);
            RepeatTable.DataBind();
        }
		void Alert(string type, string title, string message)
		{
			Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
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
				}

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
		protected void Create(object sender, EventArgs e)
        {
			try
            {
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "INSERT INTO SECTION ( " +
					"[SECTION_NAME] " +
					",[IS_ACTIVE]  " +
					",[CREATED_BY] " +
					") VALUES ( " +
					"@SECTION_NAME " +
					",1 " +
					",@CREATED_BY )";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("SECTION_NAME", SqlDbType.VarChar).Value = sectionName.Value;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "inserted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
            {
				Alert("error", "Error!", $"{ex.Message}");
            }
		}
		protected void Update(object sender, EventArgs e)
		{
			try
			{
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "UPDATE SECTION SET " +
					"[SECTION_NAME]=@SECTION_NAME " +
					",[IS_ACTIVE]=@IS_ACTIVE  " +
					",[CREATED_BY]=@CREATED_BY " +
					"WHERE ID=@ID";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("SECTION_NAME", SqlDbType.VarChar).Value = sectionName.Value;
				param.AddWithValue("IS_ACTIVE", SqlDbType.Bit).Value = active.Checked;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "updated");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Error!", $"{ex.Message}");
			}
		}
		protected void Delete(object sender, EventArgs e)
		{
			try
			{
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				// check used command
				string selectQuery = "SELECT ID FROM DEPARTMENT WHERE SECTION_ID=@ID";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				DataTable dt = SQL.GetDataTableWithParams(selectQuery, MainDB, param);
				if (dt.Rows.Count > 0) throw new Exception("Cannot be deleted, data is already in use.");

				// delete command
				string query = "DELETE FROM SECTION WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "deleted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", $"{ex.Message}");
			}
		}
	}
}