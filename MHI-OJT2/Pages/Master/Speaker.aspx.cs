using MHI_OJT2.Pages.Systems;
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
    public partial class Speaker : System.Web.UI.Page
    {
		string _sessionAlert;
		string _selfPathName = "";
		protected void Page_Load(object sender, EventArgs e)
        {
			_selfPathName = "~" + Auth.applicationPath + "/Pages/Master/Speaker.aspx";
			Auth.CheckLoggedIn();
             if (!IsPostBack)
            {
				int havePermisstion = int.Parse(Session["isEditMaster"].ToString());
				if (havePermisstion == 0)
				{
					Response.Redirect(Auth._403);
				}
				CheckAlertSession();
				GetSpeaker();
            }
        }
        void GetSpeaker()
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
            string query = "SELECT teac.*" +
                ",CONCAT(usr.INITIAL_NAME,usr.FIRST_NAME, ' ',usr.LAST_NAME) CREATED_NAME " +
                "FROM TEACHER teac " +
                "JOIN SYSTEM_USERS usr ON usr.ID = teac.CREATED_BY " +
				"ORDER BY teac.ID";
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

				Session.Remove("alert");
			}
		}
		protected void Create(object sender, EventArgs e)
		{
			try
			{
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "INSERT INTO TEACHER (" +
					" [INITIAL_NAME] " +
					",[FIRST_NAME] " +
					",[LAST_NAME] " +
					",[IS_ACTIVE] " +
					",[CREATED_BY] " +
					") OUTPUT INSERTED.ID VALUES (" +
					" @INITIAL_NAME " +
					",@FIRST_NAME " +
					",@LAST_NAME " +
					",1 " +
					",@CREATED_BY )";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("INITIAL_NAME", SqlDbType.VarChar).Value = initial.Value;
				param.AddWithValue("FIRST_NAME", SqlDbType.VarChar).Value = firstName.Value;
				param.AddWithValue("LAST_NAME", SqlDbType.VarChar).Value = lastName.Value;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				int insertedId = SQL.ExecuteAndGetInsertId(query, MainDB, param);

				Session.Add("alert", "inserted");

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "เพิ่มวิทยากร";
					obj.REMARK = $"{initial.Value}{firstName.Value} {lastName.Value}";
					obj.TABLE_NAME = "SPEAKER";
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
				Alert("error", "Failed!", DATA.RemoveSpecialCharacters(ex.Message));
			}
		}
		protected void Update(object sender, EventArgs e)
		{
			try
			{
				string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				string query = "UPDATE TEACHER SET" +
					" [INITIAL_NAME]=@INITIAL_NAME " +
					",[FIRST_NAME]=@FIRST_NAME " +
					",[LAST_NAME]=@LAST_NAME " +
					",[IS_ACTIVE]=@IS_ACTIVE " +
					",[CREATED_BY]=@CREATED_BY" +
					" WHERE ID=@ID";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("INITIAL_NAME", SqlDbType.VarChar).Value = initial.Value;
				param.AddWithValue("FIRST_NAME", SqlDbType.VarChar).Value = firstName.Value;
				param.AddWithValue("LAST_NAME", SqlDbType.VarChar).Value = lastName.Value;
				param.AddWithValue("IS_ACTIVE", SqlDbType.Bit).Value = active.Checked;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "updated");

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "แก้ไขข้อมูลวิทยากร";
					obj.REMARK = $"{initial.Value}{firstName.Value} {lastName.Value}";
					obj.TABLE_NAME = "SPEAKER";
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

				// check used adjust course
				using (DataTable dt = SQL.GetDataTableWithParams("SELECT ID FROM ADJUST_COURSE WHERE TEACHER_ID=@ID", MainDB, param))
				{
					if (dt.Rows.Count > 0) throw new Exception("Cannot be deleted, data is already in use.");
				}

				// delete command
				string query = "DELETE FROM TEACHER WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "ลบวิทยากร";
					obj.TABLE_NAME = "SPEAKER";
					obj.FK_ID = int.Parse(hiddenId.Value.ToString());
					Log.Create("delete", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}

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