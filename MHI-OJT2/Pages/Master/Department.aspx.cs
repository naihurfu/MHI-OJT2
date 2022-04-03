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
    public partial class Department : System.Web.UI.Page
    {
		string _sessionAlert;
		string _selfPathName = "~/Pages/Master/Department.aspx";
		protected void Page_Load(object sender, EventArgs e)
        {
			Auth.CheckLoggedIn();
              if (!IsPostBack)
            {
				int havePermisstion = int.Parse(Session["isEditMaster"].ToString());
				if (havePermisstion == 0)
				{
					Response.Redirect(Auth._403);
				}

				CheckAlertSession();
				GetDepartment();
            }
        }
        void GetDepartment()
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
            string query = "SELECT dep.* " +
                ",sec.SECTION_NAME " +
                ",CONCAT(usr.INITIAL_NAME,usr.FIRST_NAME, ' ',usr.LAST_NAME) CREATED_NAME " +
                "FROM DEPARTMENT dep " +
                "JOIN SECTION sec ON sec.ID=dep.SECTION_ID " +
                "JOIN SYSTEM_USERS usr ON usr.ID=dep.CREATED_BY";
            RepeatDepartmentTable.DataSource = SQL.GetDataTable(query, MainDB);
            RepeatDepartmentTable.DataBind();

			sectionName.DataSource = SQL.GetDataTable("SELECT ID,SECTION_NAME FROM SECTION WHERE IS_ACTIVE=1", MainDB);
			sectionName.DataValueField = "ID";
			sectionName.DataTextField = "SECTION_NAME";
			sectionName.DataBind();
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
				string query = "INSERT INTO DEPARTMENT ( " +
					"[SECTION_ID] " +
					",[DEPARTMENT_NAME] " +
					",[IS_ACTIVE] " +
					",[CREATED_BY] " +
					") OUTPUT INSERTED.ID VALUES ( " +
					"@SECTION_ID " +
					",@DEPARTMENT_NAME " +
					",1 " +
					",@CREATED_BY )";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("SECTION_ID", SqlDbType.Int).Value = sectionName.Value;
				param.AddWithValue("DEPARTMENT_NAME", SqlDbType.VarChar).Value = departmentName.Value;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				int insertedId = SQL.ExecuteAndGetInsertId(query, MainDB, param);

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "เพิ่มแผนก";
					obj.REMARK = departmentName.Value;
					obj.TABLE_NAME = "DEPARTMENT";
					obj.FK_ID = insertedId;
					Log.Create("add", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}

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
				string query = "UPDATE DEPARTMENT SET " +
					"[SECTION_ID]=@SECTION_ID " +
					",[DEPARTMENT_NAME]=@DEPARTMENT_NAME " +
					",[IS_ACTIVE]=@IS_ACTIVE  " +
					",[CREATED_BY]=@CREATED_BY " +
					"WHERE ID=@ID";
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = hiddenId.Value;
				param.AddWithValue("SECTION_ID", SqlDbType.Int).Value = sectionName.Value;
				param.AddWithValue("DEPARTMENT_NAME", SqlDbType.VarChar).Value = departmentName.Value;
				param.AddWithValue("IS_ACTIVE", SqlDbType.Bit).Value = active.Checked;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "updated");

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "แก้ไขข้อมูลแผนก";
					obj.REMARK = departmentName.Value;
					obj.TABLE_NAME = "DEPARTMENT";
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
				using (DataTable dt = SQL.GetDataTableWithParams("SELECT ID FROM ADJUST_COURSE WHERE DEPARTMENT_ID=@ID", MainDB, param))
                {
					if (dt.Rows.Count > 0) throw new Exception("Cannot be deleted, data is already in use.");
				}

				// check used training plan
				using (DataTable dt = SQL.GetDataTableWithParams("SELECT ID FROM TRAINING_PLAN WHERE DEPARTMENT_ID=@ID", MainDB, param))
				{
					if (dt.Rows.Count > 0) throw new Exception("Cannot be deleted, data is already in use.");
				}

				// delete command
				string query = "DELETE FROM DEPARTMENT WHERE ID=@ID";
				SQL.ExecuteWithParams(query, MainDB, param);

				Session.Add("alert", "deleted");

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "ลบแผนก";
					obj.TABLE_NAME = "DEPARTMENT";
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
	}
}