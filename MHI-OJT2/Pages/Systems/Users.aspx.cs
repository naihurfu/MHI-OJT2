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
			_selfPathName = "~" + Auth.applicationPath + "/Pages/Systems/Users.aspx";
			Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
				string role = Session["roles"].ToString().ToLower();
				if (role != "admin")
				{
					Response.Redirect(Auth._403);
				}
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
					Alert("success", "สำเร็จ", "บักทึกข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "updated")
				{
					Alert("success", "สำเร็จ", "ปรับปรุงข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "deleted")
				{
					Alert("success", "สำเร็จ", "ลบข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "change-password")
                {
					Alert("success", "สำเร็จ", "เปลี่ยนรหัสผ่านเรียบร้อย");
                }

				Session.Remove("alert");
			}
		}
		static int CheckUsernameDuplicate(string username)
        {
			try
            {
				int duplicateCount = 0;
				string tigerQuery = "SELECT PersonID FROM PNT_Person " +
					"WHERE LOWER(PersonCode) = LOWER('" + username + "')";
				using (DataTable dt = SQL.GetDataTable(tigerQuery, WebConfigurationManager.ConnectionStrings["TigerDB"].ConnectionString))
                {
					duplicateCount += dt.Rows.Count;
                }

				string mainQuery = "SELECT ID FROM SYSTEM_USERS " +
					"WHERE LOWER(USERNAME) = LOWER('" + username + "')";
				using (DataTable dt = SQL.GetDataTable(mainQuery, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString))
				{
					duplicateCount += dt.Rows.Count;
				}
				return duplicateCount;
            }
			catch (Exception ex)
            {
				Console.WriteLine(ex.Message);
				return 100;
            }
        }
		protected void Create(object sender, EventArgs e)
		{
			
			try
			{
				if (string.IsNullOrWhiteSpace(username.Value) == true) throw new Exception("กรุณากรอกชื่อผู้ใช้งานให้ถูกต้อง");

				int checkDup = CheckUsernameDuplicate(username.Value);
				if (checkDup > 0) throw new Exception("ชื่อผู้ใช้ถูกใช้งานแล้ว กรุณาลองใหม่อีกครั้ง");
				if (addPassword.Value != addConfirmPassword.Value) throw new Exception("รหัสผ่านไม่ตรงกัน กรุณาลองอีกครั้ง");

				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "INSERT INTO SYSTEM_USERS (" +
					" [USERNAME] " +
					",[PASSWORD] " +
					",[INITIAL_NAME] " +
					",[FIRST_NAME] " +
					",[LAST_NAME] " +
					",[POSITION_NAME] " +
					",[ROLES] " +
					",[IS_EDIT_MASTER] " +
					",[IS_ACTIVE]" +
					") OUTPUT INSERTED.ID VALUES (" +
					" @USERNAME " +
					",@PASSWORD " +
					",@INITIAL_NAME " +
					",@FIRST_NAME " +
					",@LAST_NAME " +
					",@POSITION_NAME " +
					",@ROLES " +
					",@IS_EDIT_MASTER " +
					",1)";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("USERNAME", SqlDbType.VarChar).Value = username.Value;
				param.AddWithValue("PASSWORD", SqlDbType.VarChar).Value = DATA.Encrypt(addPassword.Value);
				param.AddWithValue("INITIAL_NAME", SqlDbType.VarChar).Value = initialName.Value;
				param.AddWithValue("FIRST_NAME", SqlDbType.VarChar).Value = firstName.Value;
				param.AddWithValue("LAST_NAME", SqlDbType.VarChar).Value = lastName.Value;
				param.AddWithValue("POSITION_NAME", SqlDbType.VarChar).Value = positionName.Value;
				param.AddWithValue("ROLES", SqlDbType.VarChar).Value = roleName.Value;
				param.AddWithValue("IS_EDIT_MASTER", SqlDbType.Bit).Value = editMaster.Value;
				int insertedId = SQL.ExecuteAndGetInsertId(query, MainDB, param);

				Session.Add("alert", "inserted");
				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "เพิ่มผู้ใช้ระบบ";
					obj.REMARK = $"{username.Value}";
					obj.TABLE_NAME = "SYSTEM_USERS";
					obj.FK_ID = insertedId;
					Log.Create("add", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "ผิดพลาด!", ex.Message);
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
					",[IS_EDIT_MASTER]=@IS_EDIT_MASTER " +
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
				param.AddWithValue("IS_EDIT_MASTER", SqlDbType.Bit).Value = editMaster.Value;
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "updated");
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "แก้ไขข้อมูลผู้ใช้ระบบ";
					obj.REMARK = $"{username.Value}";
					obj.TABLE_NAME = "SYSTEM_USERS";
					obj.FK_ID = int.Parse(hiddenId.Value.ToString());
					Log.Create("edit", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}
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
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "ลบข้อมูลผู้ใช้";
					obj.TABLE_NAME = "SYSTEM_USERS";
					obj.FK_ID = int.Parse(hiddenId.Value.ToString());
					Log.Create("delete", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}
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
						if (DATA.Encrypt(oldPassword.Value) != dt.Rows[0]["PASSWORD"].ToString()) throw new Exception("Password is valid, Please try again.");
					}
				}

				// create where parameters
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("PASSWORD", SqlDbType.VarChar).Value = DATA.Encrypt(password.Value);

				// delete command
				string query = "UPDATE SYSTEM_USERS SET PASSWORD=@PASSWORD WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "change-password");
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "เปลี่ยนรหัสผ่าน";
					obj.TABLE_NAME = "SYSTEM_USERS";
					obj.FK_ID = int.Parse(hiddenId.Value.ToString());
					Log.Create("edit", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Failed!", ex.Message);
			}
		}
	}
}