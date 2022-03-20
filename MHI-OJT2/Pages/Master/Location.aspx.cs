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
    public partial class Location : System.Web.UI.Page
    {
        string _sessionAlert;
        string _selfPathName = "~/Pages/Master/Location.aspx";
        protected void Page_Load(object sender, EventArgs e)
        {
			Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
				string role = Session["roles"].ToString().ToLower();
				if (role == "user")
				{
					Response.Redirect(Auth._403);
				}
				CheckAlertSession();
                GetLocation();
            }
        }
        void GetLocation()
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
			string query = "SELECT loc.*" +
				",CONCAT(usr.INITIAL_NAME,usr.FIRST_NAME, ' ',usr.LAST_NAME) CREATED_NAME  " +
				"FROM [LOCATION] loc " +
				"JOIN SYSTEM_USERS usr ON usr.ID=loc.CREATED_BY";
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
				string query = "INSERT INTO LOCATION (" +
					" [LOCATION_NAME] " +
					",[IS_ACTIVE] " +
					",[CREATED_BY] " +
					") VALUES (" +
					" @LOCATION_NAME " +
					",1 " +
					",@CREATED_BY )";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("LOCATION_NAME", SqlDbType.VarChar).Value = locationName.Value;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "inserted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", DATA.RemoveSpecialCharacters(ex.Message));
			}
		}
		protected void Update(object sender, EventArgs e)
		{
			try
			{
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "UPDATE LOCATION SET" +
					" [LOCATION_NAME]=@LOCATION_NAME " +
					",[IS_ACTIVE]=@IS_ACTIVE " +
					",[CREATED_BY]=@CREATED_BY" +
					" WHERE ID=@ID";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("LOCATION_NAME", SqlDbType.VarChar).Value = locationName.Value;
				param.AddWithValue("IS_ACTIVE", SqlDbType.Bit).Value = active.Checked;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "updated");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", DATA.RemoveSpecialCharacters(ex.Message));
			}
		}
		protected void Delete(object sender, EventArgs e)
		{
			try
			{
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

				// create where parameters
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;

				// check used adjust course
				using (DataTable dt = SQL.GetDataTableWithParams("SELECT ID FROM ADJUST_COURSE WHERE LOCATION_ID=@ID", MainDB, param))
				{
					if (dt.Rows.Count > 0) throw new Exception("Cannot be deleted, data is already in use.");
				}

				// delete command
				string query = "DELETE FROM LOCATION WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "deleted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", DATA.RemoveSpecialCharacters(ex.Message));
			}
		}
	}
}