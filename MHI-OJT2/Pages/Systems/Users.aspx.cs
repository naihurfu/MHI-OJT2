using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Systems
{
    public partial class Users : System.Web.UI.Page
    {
        string _sessionAlert;
        string _selfPathName = "~/Pages/Systems/Users.aspx";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckAlertSession();
                GetUsers();
            }
        }
		void GetUsers()
		{
			string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
			string query = "SELECT  * FROM SYSTEM_USERS WHERE IS_ACTIVE=1";
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
		static int CheckUsernameDuplicate(string username)
        {
			try
            {
				int duplicateCount = 0;
				using (DataTable dt = SQL.GetDataTable("SELECT ID FROM PNT_Person WHERE PersonCode = '" + username + "'", WebConfigurationManager.ConnectionStrings["TigerDB"].ConnectionString))
                {
					duplicateCount += dt.Rows.Count;
                }
				
				using (DataTable dt = SQL.GetDataTable("SELECT ID FROM SYSTEM_USERS WHERE USERNAME = '" + username + "'", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString))
				{
					duplicateCount += dt.Rows.Count;
				}
				return duplicateCount;
            }
			catch (Exception ex)
            {
				Console.WriteLine(ex.Message);
				return 0;
            }
        }
		protected void Create(object sender, EventArgs e)
		{
			try
			{
				if (3 == 3)
                {
					if (CheckUsernameDuplicate("") > 0) throw new Exception("Username is already in use.");
				}

				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "INSERT INTO SYSTEM_USERS (" +
					" [USERNAME] " +
					",[PASSWORD] " +
					",[INITIAL_NAME] " +
					",[FIRST_NAME] " +
					",[LAST_NAME] " +
					",[POSITION_NAME] " +
					",[ROLES] " +
					",[IS_ACTIVE]" +
					") VALUES (" +
					" @USERNAME " +
					",@PASSWORD " +
					",@INITIAL_NAME " +
					",@FIRST_NAME " +
					",@LAST_NAME " +
					",@POSITION_NAME " +
					",@ROLES " +
					",1)";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("USERNAME", SqlDbType.VarChar).Value = username.Value;
				param.AddWithValue("PASSWORD", SqlDbType.VarChar).Value = DATA.Encrypt(password.Value);
				param.AddWithValue("INITIAL_NAME", SqlDbType.VarChar).Value = initialName.Value;
				param.AddWithValue("FIRST_NAME", SqlDbType.VarChar).Value = firstName.Value;
				param.AddWithValue("LAST_NAME", SqlDbType.VarChar).Value = lastName.Value;
				param.AddWithValue("POSITION_NAME", SqlDbType.VarChar).Value = positionName.Value;
				param.AddWithValue("ROLES", SqlDbType.VarChar).Value = roleName.Value;
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
				string query = "UPDATE SYSTEM_USERS SET" +
					" [USERNAME]=@USERNAME " +
					",[INITIAL_NAME]=@INITIAL_NAME " +
					",[FIRST_NAME]=@FIRST_NAME " +
					",[LAST_NAME]=@LAST_NAME " +
					",[POSITION_NAME]=@POSITION_NAME " +
					",[ROLES]=@ROLES " +
					",[CREATED_AT]=GETDATE() " +
					"WHERE ID=@ID";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("USERNAME", SqlDbType.VarChar).Value = username.Value;
				param.AddWithValue("INITIAL_NAME", SqlDbType.VarChar).Value = initialName.Value;
				param.AddWithValue("FIRST_NAME", SqlDbType.VarChar).Value = firstName.Value;
				param.AddWithValue("LAST_NAME", SqlDbType.VarChar).Value = lastName.Value;
				param.AddWithValue("POSITION_NAME", SqlDbType.VarChar).Value = positionName.Value;
				param.AddWithValue("ROLES", SqlDbType.VarChar).Value = roleName.Value;
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

				// delete command
				string query = "UPDATE SYSTEM_USERS SET IS_ACTIVE=0 WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "deleted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", DATA.RemoveSpecialCharacters(ex.Message));
			}
		}
		protected void ChangePassword(object sender, EventArgs e)
		{
			try
			{
				if (password.Value != confirmPassword.Value) throw new Exception("Password is not match, Please try again.");

				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				using (DataTable dt = SQL.GetDataTable("SELECT PASSWORD FROM SYSTEM_USERS WHERE ID=" + hiddenId.Value, MainDB))
                {
					if( dt.Rows.Count > 0)
                    {
						if (DATA.Encrypt(oldPassword.Value) != dt.Rows[0]["PASSWORD"].ToString()) throw new Exception("Old password is not match, Please try again.");
					}
				}

				// create where parameters
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("PASSWORD", SqlDbType.VarChar).Value = DATA.Encrypt(password.Value);

				// delete command
				string query = "UPDATE SYSTEM_USERS SET PASSWORD=@PASSWORD WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "deleted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", ex.Message);
			}
		}
	}
}