using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
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
    public partial class Courses : System.Web.UI.Page
	{
		string _sessionAlert = null;
		string _selfPathName = "~/Pages/Management/Courses.aspx";
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				CheckAlertSession();
				GetGridViewData();
				GetMasterOfCourse();
				GetAssessor();
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
					Alert("success", "สำเร็จ", "เพิ่มผู้ใช้เรียบร้อย");
				};

				if (_sessionAlert == "updated")
				{
					Alert("success", "สำเร็จ", "แก้ไขข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "deleted")
				{
					Alert("success", "สำเร็จ", "ลบข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "update_status")
				{
					Alert("success", "สำเร็จ", "อัพเดทสถานะเรียบร้อยแล้ว");
				}

				Session.Remove("alert");
			}
		}
		void GetGridViewData()
		{
			string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
			RepeatCourseTable.DataSource = SQL.GetDataTable("SELECT * FROM COURSE", mainDb);
			RepeatCourseTable.DataBind();
		}
		void GetAssessor()					   
		{
			string tigerDb = WebConfigurationManager.ConnectionStrings["TigerDB"].ConnectionString;
			string query = "SELECT person.PersonID, CONCAT(person.PersonCode, ' ', person.FnameT, ' ', person.LnameT) FULLNAME_TH, CONCAT(person.PersonCode, ' ', person.FnameE, ' ', person.LnameE) FULLNAME_EN, cmb.Cmb2NameT, cmb.Cmb2NameE FROM PNT_Person person JOIN PNM_Cmb2 cmb ON cmb.Cmb2ID = person.Cmb2ID ";
			query += "WHERE ResignStatus = 1 AND ChkDeletePerson = 1";
			DataTable assessorTable = SQL.GetDataTable(query, tigerDb);

			string _textField = "FULLNAME_TH";
			string _valueField = "PersonID";

			Assessor1.DataSource = assessorTable;
			Assessor1.DataTextField = _textField;
			Assessor1.DataValueField = _valueField;
			Assessor1.DataBind();
			Assessor1.Items.Insert(0, new ListItem("-", "0"));
			Assessor1.SelectedIndex = 0;

			Assessor2.DataSource = assessorTable;
			Assessor2.DataTextField = _textField;
			Assessor2.DataValueField = _valueField;
			Assessor2.DataBind();
			Assessor2.Items.Insert(0, new ListItem("-", "0"));
			Assessor2.SelectedIndex = 0;

			Assessor3.DataSource = assessorTable;
			Assessor3.DataTextField = _textField;
			Assessor3.DataValueField = _valueField;
			Assessor3.DataBind();
			Assessor3.Items.Insert(0, new ListItem("-", "0"));
			Assessor3.SelectedIndex = 0;

			Assessor4.DataSource = assessorTable;
			Assessor4.DataTextField = _textField;
			Assessor4.DataValueField = _valueField;
			Assessor4.DataBind();
			Assessor4.Items.Insert(0, new ListItem("-", "0"));
			Assessor4.SelectedIndex = 0;

			Assessor5.DataSource = assessorTable;
			Assessor5.DataTextField = _textField;
			Assessor5.DataValueField = _valueField;
			Assessor5.DataBind();
			Assessor5.Items.Insert(0, new ListItem("-", "0"));
			Assessor5.SelectedIndex = 0;

			Assessor6.DataSource = assessorTable;
			Assessor6.DataTextField = _textField;
			Assessor6.DataValueField = _valueField;
			Assessor6.DataBind();
			Assessor6.Items.Insert(0, new ListItem("-", "0"));
			Assessor6.SelectedIndex = 0;
		}
		void GetMasterOfCourse()
		{
			string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

			department.DataSource = SQL.GetDataTable("SELECT ID,DEPARTMENT_NAME FROM DEPARTMENT WHERE IS_ACTIVE=1", mainDb);
			department.DataValueField = "ID";
			department.DataTextField = "DEPARTMENT_NAME";
			department.DataBind();

			location.DataSource = SQL.GetDataTable("SELECT ID,LOCATION_NAME FROM LOCATION WHERE IS_ACTIVE=1", mainDb);
			location.DataValueField = "ID";
			location.DataTextField = "LOCATION_NAME";
			location.DataBind();

			teacher.DataSource = SQL.GetDataTable("SELECT ID,CONCAT(INITIAL_NAME, ' ', FIRST_NAME, ' ', LAST_NAME) AS FULLNAME FROM TEACHER WHERE IS_ACTIVE=1", mainDb);
			teacher.DataValueField = "ID";
			teacher.DataTextField = "FULLNAME";
			teacher.DataBind();

			trainingPlan.DataSource = SQL.GetDataTable("SELECT ID,CONCAT('[', IIF(LEN(REF_DOCUMENT) > 0, REF_DOCUMENT, '-'), '] - ', PLAN_NAME) AS NAME FROM TRAINING_PLAN", mainDb);
			trainingPlan.DataValueField = "ID";
			trainingPlan.DataTextField = "NAME";
			trainingPlan.DataBind();
			trainingPlan.Items.Insert(0, new ListItem("-", "-"));
			trainingPlan.SelectedIndex = 0;
		}
		protected void btnInserted_Click(object sender, EventArgs e)
		{
			try
			{
				string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				SqlParameterCollection param = new SqlCommand().Parameters;

				string query = "INSERT INTO ADJUST_COURSE([COURSE_NUMBER],[TIMES],[COURSE_NAME],[START_DATE],[END_DATE],[START_TIME],[END_TIME],[TOTAL_HOURS],[DEPARTMENT_ID],[LOCATION_ID],[TEACHER_ID],[DETAIL],[OBJECTIVE],[ASSESSOR1_ID],[ASSESSOR2_ID],[ASSESSOR3_ID],[ASSESSOR4_ID],[ASSESSOR5_ID],[ASSESSOR6_ID],[STATUS],[CREATED_BY]) OUTPUT INSERTED.ID VALUES(@COURSE_NUMBER,@TIMES,@COURSE_NAME,@START_DATE,@END_DATE,@START_TIME,@END_TIME,@TOTAL_HOURS,@DEPARTMENT_ID,@LOCATION_ID,@TEACHER_ID,@DETAIL,@OBJECTIVE,@ASSESSOR1_ID,@ASSESSOR2_ID,@ASSESSOR3_ID,@ASSESSOR4_ID,@ASSESSOR5_ID,@ASSESSOR6_ID,@STATUS,@CREATED_BY)";
				param.AddWithValue("COURSE_NUMBER", SqlDbType.VarChar).Value = courseNumber.Value;
				param.AddWithValue("TIMES", SqlDbType.Int).Value = times.Value;
				param.AddWithValue("COURSE_NAME", SqlDbType.VarChar).Value = courseName.Value;
				param.AddWithValue("START_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(startDate.Value);
				param.AddWithValue("END_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(endDate.Value);
				param.AddWithValue("START_TIME", SqlDbType.VarChar).Value = startTime.Value;
				param.AddWithValue("END_TIME", SqlDbType.VarChar).Value = endTime.Value;
				param.AddWithValue("TOTAL_HOURS", SqlDbType.Int).Value = totalHours.Value;
				param.AddWithValue("DEPARTMENT_ID", SqlDbType.Int).Value = department.Value;
				param.AddWithValue("LOCATION_ID", SqlDbType.Int).Value = location.Value;
				param.AddWithValue("TEACHER_ID", SqlDbType.Int).Value = teacher.Value;
				param.AddWithValue("DETAIL", SqlDbType.VarChar).Value = detail.Value;
				param.AddWithValue("OBJECTIVE", SqlDbType.VarChar).Value = objective.Value;
				param.AddWithValue("ASSESSOR1_ID", SqlDbType.Int).Value = Assessor1.Value;
				param.AddWithValue("ASSESSOR2_ID", SqlDbType.Int).Value = Assessor2.Value;
				param.AddWithValue("ASSESSOR3_ID", SqlDbType.Int).Value = Assessor3.Value;
				param.AddWithValue("ASSESSOR4_ID", SqlDbType.Int).Value = Assessor4.Value;
				param.AddWithValue("ASSESSOR5_ID", SqlDbType.Int).Value = Assessor5.Value;
				param.AddWithValue("ASSESSOR6_ID", SqlDbType.Int).Value = Assessor6.Value;
				param.AddWithValue("STATUS", SqlDbType.Int).Value = 1;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];


				if (checkPlan.Checked == true && checkNotPlan.Checked == false)
				{
					int insertedId;
					insertedId = SQL.ExecuteAndGetInsertId(query, mainDb, param);

					if (insertedId == 0) throw new Exception("Something went wrong!");

					SqlParameterCollection paramPlanAndCourse = new SqlCommand().Parameters;
					paramPlanAndCourse.AddWithValue("PLAN_ID", SqlDbType.Int).Value = trainingPlan.Value;
					paramPlanAndCourse.AddWithValue("COURSE_ID", SqlDbType.Int).Value = insertedId;
					paramPlanAndCourse.AddWithValue("CREATED_BY", SqlDbType.Int).Value = 1;
					SQL.ExecuteWithParams("INSERT INTO PLAN_AND_COURSE([PLAN_ID],[COURSE_ID],[CREATED_BY]) VALUES(@PLAN_ID,@COURSE_ID,@CREATED_BY)", mainDb, paramPlanAndCourse);

					Session.Add("alert", "inserted");
					Response.Redirect(_selfPathName);
				}
				else if (checkPlan.Checked == false && checkNotPlan.Checked == true)
				{
					SQL.ExecuteWithParams(query, mainDb, param);

					Session.Add("alert", "inserted");
					Response.Redirect(_selfPathName);
				}
				else
				{
					throw new Exception("Training plan error, Please try agin.");
				}


			}
			catch (Exception ex)
			{
				Alert("error", "Error!", $"{ex.Message}");
			}
		}
		[WebMethod]
		public static string InsertEmployee(int courseId, int personId)
		{
			string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
			try
			{
				using (SqlConnection connection = new SqlConnection(connectionString))
				{
					string queryString = "INSERT INTO EVALUATE(COURSE_ID,PERSON_ID,SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,TOTAL_SCORE,IS_EVALUATED) VALUES(@courseId,@personId,0,0,0,0,0,0,0)";
					using (SqlCommand cmd = new SqlCommand(queryString, connection))
					{
						cmd.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
						cmd.Parameters.AddWithValue("personId", SqlDbType.Int).Value = personId;

						connection.Open();
						cmd.ExecuteNonQuery();
						connection.Close();
						return $"PersonID : {personId} AND CourseID : {courseId} has been inserted.";
					}
				}
			}
			catch (Exception ex)
			{
				return $"{ex.Message}";
			}
		}
		[WebMethod]
		public static string DeleteEmployeeInCourse(int courseId)
		{
			try
			{
				string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				SqlConnection con = new SqlConnection(connectionString);
				SqlCommand command = new SqlCommand("DELETE FROM EVALUATE WHERE COURSE_ID=@courseId", con);
				command.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
				con.Open();
				command.ExecuteNonQuery();
				con.Close();
				return $"courseId : {courseId} is Removed";
			}
			catch (Exception ex)
			{
				return $"{ex.Message}";
			}
		}
		[WebMethod]
		public static string SaveCourseWithoutDraft(int courseId)
		{
			try
			{
				string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				SqlConnection con = new SqlConnection(connectionString);
				SqlCommand command = new SqlCommand("UPDATE ADJUST_COURSE SET [STATUS]=2 WHERE ID=@courseId", con);
				command.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
				con.Open();
				command.ExecuteNonQuery();
				con.Close();

				HttpContext.Current.Session["alert"] = "update_status";

				return $"courseId : {courseId} is updated";
			}
			catch (Exception ex)
			{
				return $"{ex.Message}";
			}
		}
		[WebMethod]
		public static string GetEmployeeList(int courseId)
		{
			string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

			SqlConnection con = new SqlConnection(connectionString);
			SqlCommand command = new SqlCommand("SELECT TOP 50 p.PersonID, CONCAT(p.PersonCode, ' ', p.FnameT, ' ', p.LnameT) fullName, IIF(e.PERSON_ID = p.PersonID, 1, 0) as selected FROM Cyberhrm_PCT.dbo.PNT_Person p LEFT JOIN TEST_DB.dbo.EVALUATE e ON e.PERSON_ID = p.PersonID AND e.COURSE_ID = @courseId", con);
			con.Open();
			command.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
			command.CommandType = CommandType.Text;
			SqlDataAdapter da = new SqlDataAdapter();
			da.SelectCommand = command;
			con.Close();
			DataTable dt = new DataTable();
			da.Fill(dt);

			return DATA.DataTableToJSONWithJSONNet(dt);
		}
		void Alert(string type, string title, string message)
		{
			Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
		}
		protected void RepleaterItemCommand(object sender, RepeaterCommandEventArgs e)
		{
			switch (e.CommandName)
			{
				case "EXPORT_REPORT_MANAGE_COURSE":

					int courseId = int.Parse(e.CommandArgument.ToString());
					string exportName = "unname report";

					SqlParameterCollection param = new SqlCommand().Parameters;
					param.AddWithValue("ID", SqlDbType.Int).Value = courseId;
					DataTable dt = SQL.GetDataTableWithParams("SELECT * FROM COURSE WHERE COURSE_ID=@ID", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);

					if (dt.Rows.Count > 0)
					{
						string courseName = dt.Rows[0]["COURSE_NAME"].ToString();
						string times = dt.Rows[0]["TIMES"].ToString();

						exportName = $"รายงานประเมินผล {courseName} ครั้งที่ {times}";
					}

					ReportDocument rpt = new ReportDocument();
					ExportFormatType expType = ExportFormatType.PortableDocFormat;

					rpt.Load(Server.MapPath($"~/Reports/rpt_Manage_Course.rpt"));
					rpt.RecordSelectionFormula = "{COURSE_AND_EMPLOYEE.COURSE_ID}=" + courseId;

					rpt.SetDatabaseLogon("Project1", "Tigersoft1998$");
					rpt.ExportToHttpResponse(expType, Response, true, exportName);
					break;
			}
		}
		[WebMethod]
		public static string GetCourseDetailById(int courseId)
		{
			try
			{
				string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				using (SqlConnection connection = new SqlConnection(connectionString))
				{
					string queryString = "SELECT (SELECT PLAN_ID FROM PLAN_AND_COURSE WHERE COURSE_ID=@courseId) AS PLAN_ID,*  FROM ADJUST_COURSE  WHERE ID=@courseId";
					using (SqlCommand cmd = new SqlCommand(queryString, connection))
					{
						cmd.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = courseId;

						connection.Open();
						cmd.CommandType = CommandType.Text;
						SqlDataAdapter da = new SqlDataAdapter();
						da.SelectCommand = cmd;
						connection.Close();

						DataTable dt = new DataTable();
						da.Fill(dt);

						return DATA.DataTableToJSONWithJSONNet(dt);
					}
				}
			}
			catch (Exception ex)
			{
				return $"{ex.Message}";
			}
		}

		protected void btnEdit_Click(object sender, EventArgs e)
		{
			try
			{
				string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				SqlParameterCollection param = new SqlCommand().Parameters;

				string query = "INSERT INTO ADJUST_COURSE([COURSE_NUMBER],[TIMES],[COURSE_NAME],[START_DATE],[END_DATE],[START_TIME],[END_TIME],[TOTAL_HOURS],[DEPARTMENT_ID],[LOCATION_ID],[TEACHER_ID],[DETAIL],[OBJECTIVE],[ASSESSOR1_ID],[ASSESSOR2_ID],[ASSESSOR3_ID],[ASSESSOR4_ID],[ASSESSOR5_ID],[ASSESSOR6_ID],[STATUS],[CREATED_BY]) OUTPUT INSERTED.ID VALUES(@COURSE_NUMBER,@TIMES,@COURSE_NAME,@START_DATE,@END_DATE,@START_TIME,@END_TIME,@TOTAL_HOURS,@DEPARTMENT_ID,@LOCATION_ID,@TEACHER_ID,@DETAIL,@OBJECTIVE,@ASSESSOR1_ID,@ASSESSOR2_ID,@ASSESSOR3_ID,@ASSESSOR4_ID,@ASSESSOR5_ID,@ASSESSOR6_ID,@STATUS,@CREATED_BY)";
				param.AddWithValue("COURSE_NUMBER", SqlDbType.VarChar).Value = courseNumber.Value;
				param.AddWithValue("TIMES", SqlDbType.Int).Value = times.Value;
				param.AddWithValue("COURSE_NAME", SqlDbType.VarChar).Value = courseName.Value;
				param.AddWithValue("START_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(startDate.Value);
				param.AddWithValue("END_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(endDate.Value);
				param.AddWithValue("START_TIME", SqlDbType.VarChar).Value = startTime.Value;
				param.AddWithValue("END_TIME", SqlDbType.VarChar).Value = endTime.Value;
				param.AddWithValue("TOTAL_HOURS", SqlDbType.Int).Value = totalHours.Value;
				param.AddWithValue("DEPARTMENT_ID", SqlDbType.Int).Value = department.Value;
				param.AddWithValue("LOCATION_ID", SqlDbType.Int).Value = location.Value;
				param.AddWithValue("TEACHER_ID", SqlDbType.Int).Value = teacher.Value;
				param.AddWithValue("DETAIL", SqlDbType.VarChar).Value = detail.Value;
				param.AddWithValue("OBJECTIVE", SqlDbType.VarChar).Value = objective.Value;
				param.AddWithValue("ASSESSOR1_ID", SqlDbType.Int).Value = Assessor1.Value;
				param.AddWithValue("ASSESSOR2_ID", SqlDbType.Int).Value = Assessor2.Value;
				param.AddWithValue("ASSESSOR3_ID", SqlDbType.Int).Value = Assessor3.Value;
				param.AddWithValue("ASSESSOR4_ID", SqlDbType.Int).Value = Assessor4.Value;
				param.AddWithValue("ASSESSOR5_ID", SqlDbType.Int).Value = Assessor5.Value;
				param.AddWithValue("ASSESSOR6_ID", SqlDbType.Int).Value = Assessor6.Value;
				param.AddWithValue("STATUS", SqlDbType.Int).Value = 1;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];

			}
			catch (Exception ex)
			{
				Alert("error", "Error!", $"{ex.Message}");
			}
		}

        protected void btnScanBarcode_ServerClick(object sender, EventArgs e)
        {
			int courseId = int.Parse(hiddenCourseId_AddEmployeeModal.Value);
			Response.Redirect($"~/Pages/Management/scan-barcode.aspx?queryId={courseId}");
			Response.End();
		}
    }
}