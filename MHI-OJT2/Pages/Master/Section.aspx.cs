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
    public partial class Section : System.Web.UI.Page
    {
		string _sessionAlert;
		string _selfPathName = "~/Pages/Master/Section.aspx";
		protected void Page_Load(object sender, EventArgs e)
        {
			_selfPathName = "~" + Auth.applicationPath + "/Pages/Master/Section.aspx";
			Auth.CheckLoggedIn();
              if (!IsPostBack)
				{
				int havePermisstion = int.Parse(Session["isEditMaster"].ToString());
				if (havePermisstion == 0)
				{
					Response.Redirect(Auth._403);
				}
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
				string query = "INSERT INTO SECTION ( " +
					"[SECTION_NAME] " +
					",[IS_ACTIVE]  " +
					",[CREATED_BY] " +
					") OUTPUT INSERTED.ID VALUES ( " +
					"@SECTION_NAME " +
					",1 " +
					",@CREATED_BY )";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("SECTION_NAME", SqlDbType.VarChar).Value = sectionName.Value;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				int insertedId = SQL.ExecuteAndGetInsertId(query, MainDB, param);

				Session.Add("alert", "inserted");

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "เพิ่มฝ่าย";
					obj.REMARK = sectionName.Value;
					obj.TABLE_NAME = "SECTION";
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

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "แก้ไขฝ่าย";
					obj.REMARK = sectionName.Value;
					obj.TABLE_NAME = "SECTION";
					obj.FK_ID = int.Parse(hiddenId.Value.ToString()) ;
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

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "ลบฝ่าย";
					obj.TABLE_NAME = "SECTION";
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
				Alert("error", "Failed!", $"{ex.Message}");
			}
		}
	}
}