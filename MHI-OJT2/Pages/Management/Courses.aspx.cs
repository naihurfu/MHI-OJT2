using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using MHI_OJT2.Pages.Systems;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
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
		string _selfPathName = "";
		public static string ajax = "";
		protected void Page_Load(object sender, EventArgs e)
		{
			ajax = HttpContext.Current.Request.ApplicationPath == "/" ? "" : HttpContext.Current.Request.ApplicationPath;
			_selfPathName = "~" + Auth.applicationPath + "/Pages/Management/Courses.aspx";

			Auth.CheckLoggedIn();
			string role = Session["roles"].ToString().ToLower();
			if (!IsPostBack)
			{
				if (role == "user")
				{
					Response.Redirect(Auth._403);
				}

				CheckAlertSession();
				GetGridViewData();
				GetMasterOfCourse(role);
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
					Alert("success", "สำเร็จ", "บักทึกข้อมูลเรียบร้อย");
				};

				if (_sessionAlert == "updated")
				{
					Alert("success", "สำเร็จ", "ปรับปรุงข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "deleted")
				{
					Alert("success", "สำเร็จ", "ลบข้อมูลเรียบร้อย");
				}

				if (_sessionAlert == "update_status")
				{
					Alert("success", "สำเร็จ", "ปรับปรุงสถานะเรียบร้อย");
				}

				if (_sessionAlert == "employee_inserted")
                {
					Alert("success", "สำเร็จ", "บันทึกพนักงานเข้าหลักสูตรเรียบร้อย");

				}

				if (_sessionAlert == "evaluated")
				{
					Alert("success", "สำเร็จ", "บันทึกการประเมินผลเรียบร้อย");

				}

				Session.Remove("alert");
			}
		}
		void GetGridViewData()
		{
			string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
			string query = "SELECT * FROM VIEW_ADJUST_COURSE ";
			if (Session["roles"].ToString().ToUpper() != "ADMIN")
            {
				query += "WHERE CREATED_BY = " + int.Parse(Session["userId"].ToString());
            }

			query += " ORDER BY COURSE_ID ;";
			RepeatCourseTable.DataSource = SQL.GetDataTable(query, mainDb);
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
		void GetMasterOfCourse(string role)
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


			string query = "SELECT ID," +
				"CONCAT('[', IIF(LEN(REF_DOCUMENT) > 0, REF_DOCUMENT, '-'), '] - ', PLAN_NAME) AS NAME " +
				"FROM TRAINING_PLAN " +
				"WHERE ID NOT IN (SELECT PLAN_ID FROM PLAN_AND_COURSE) ";

			if (role == "clerk")
            {
				query += "AND CREATED_BY = " + (int)Session["userId"];
            }

			trainingPlan.DataSource = SQL.GetDataTable(query, mainDb);
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
				bool hasFile = false;
				string filePath = "";
				string fileName = "";
				string extension = "";
				Byte[] bytes = new Byte[64];
				BinaryReader br;
				Stream fs;

				if (fileUpload.PostedFile.ContentLength > 0)
                {
					filePath = fileUpload.PostedFile.FileName;
					fileName = Path.GetFileName(filePath);
					extension = Path.GetExtension(fileName);

					if (extension != ".pdf") throw new Exception("อัพโหลดได้เฉพาะ .pdf เท่านั้น ");

					fs = fileUpload.PostedFile.InputStream;
					br = new BinaryReader(fs);
					bytes = br.ReadBytes((Int32)fs.Length);
					hasFile = true;
                }

				string query = "INSERT INTO ADJUST_COURSE([COURSE_NUMBER]," +
					"[TIMES]," +
					"[COURSE_NAME]," +
					"[START_DATE]," +
					"[END_DATE]," +
					"[START_TIME]," +
					"[END_TIME]," +
					"[TOTAL_HOURS]," +
					"[DEPARTMENT_ID]," +
					"[LOCATION_ID]," +
					"[TEACHER_ID]," +
					"[DETAIL]," +
					"[OBJECTIVE]," +
					"[ASSESSOR1_ID]," +
					"[ASSESSOR2_ID]," +
					"[ASSESSOR3_ID]," +
					"[ASSESSOR4_ID]," +
					"[ASSESSOR5_ID]," +
					"[ASSESSOR6_ID]," +
					"[STATUS]," +
					"[CREATED_BY]," +
					"[IS_EXAM_EVALUATE]," +
					"[IS_REAL_WORK_EVALUATE], " +
					"[IS_OTHER_EVALUATE]," +
					"[OTHER_EVALUATE_REMARK]";

				if (hasFile == true)
				{
					query += ",[FILE_UPLOAD]";
				}
				query += ") ";

				query += "OUTPUT INSERTED.ID " +
				"VALUES(" +
				"@COURSE_NUMBER," +
				"@TIMES," +
				"@COURSE_NAME," +
				"@START_DATE," +
				"@END_DATE," +
				"@START_TIME," +
				"@END_TIME," +
				"@TOTAL_HOURS," +
				"@DEPARTMENT_ID," +
				"@LOCATION_ID," +
				"@TEACHER_ID," +
				"@DETAIL," +
				"@OBJECTIVE," +
				"@ASSESSOR1_ID," +
				"@ASSESSOR2_ID," +
				"@ASSESSOR3_ID," +
				"@ASSESSOR4_ID," +
				"@ASSESSOR5_ID," +
				"@ASSESSOR6_ID," +
				"@STATUS," +
				"@CREATED_BY," +
				"@IS_EXAM_EVALUATE," +
				"@IS_REAL_WORK_EVALUATE," +
				"@IS_OTHER_EVALUATE," +
				"@OTHER_EVALUATE_REMARK";
				if (hasFile == true)
				{
					query += ",@FILE_UPLOAD";
				}
				query += ")";

				param.AddWithValue("COURSE_NUMBER", SqlDbType.VarChar).Value = courseNumber.Value;
				param.AddWithValue("TIMES", SqlDbType.Int).Value = times.Value;
				param.AddWithValue("COURSE_NAME", SqlDbType.VarChar).Value = courseName.Value.ToString().Replace("'", "");
				param.AddWithValue("START_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(startDate.Value);
				param.AddWithValue("END_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(endDate.Value);
				param.AddWithValue("START_TIME", SqlDbType.VarChar).Value = startTime.Value;
				param.AddWithValue("END_TIME", SqlDbType.VarChar).Value = endTime.Value;
				param.AddWithValue("TOTAL_HOURS", SqlDbType.Int).Value = totalHours.Value;
				param.AddWithValue("DEPARTMENT_ID", SqlDbType.Int).Value = department.Value;
				param.AddWithValue("LOCATION_ID", SqlDbType.Int).Value = location.Value;
				param.AddWithValue("TEACHER_ID", SqlDbType.Int).Value = teacher.Value;
				param.AddWithValue("DETAIL", SqlDbType.VarChar).Value = detail.Value.ToString().Replace("'", "");
				param.AddWithValue("OBJECTIVE", SqlDbType.VarChar).Value = objective.Value.ToString().Replace("'", "");
				param.AddWithValue("ASSESSOR1_ID", SqlDbType.Int).Value = Assessor1.Value;
				param.AddWithValue("ASSESSOR2_ID", SqlDbType.Int).Value = Assessor2.Value;
				param.AddWithValue("ASSESSOR3_ID", SqlDbType.Int).Value = Assessor3.Value;
				param.AddWithValue("ASSESSOR4_ID", SqlDbType.Int).Value = Assessor4.Value;
				param.AddWithValue("ASSESSOR5_ID", SqlDbType.Int).Value = Assessor5.Value;
				param.AddWithValue("ASSESSOR6_ID", SqlDbType.Int).Value = Assessor6.Value;
				param.AddWithValue("STATUS", SqlDbType.Int).Value = 1;
				param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				param.AddWithValue("IS_EXAM_EVALUATE", SqlDbType.Bit).Value = examEvaluate.Checked == true ? 1 : 0;
				param.AddWithValue("IS_REAL_WORK_EVALUATE", SqlDbType.Bit).Value = realWorkEvaluate.Checked == true ? 1 : 0;
				param.AddWithValue("IS_OTHER_EVALUATE", SqlDbType.Bit).Value = otherEvaluate.Checked == true ? 1 : 0;
				param.AddWithValue("OTHER_EVALUATE_REMARK", SqlDbType.VarChar).Value = otherEvaluateRemark.Value;

				if (hasFile == true)
                {
					param.AddWithValue("FILE_UPLOAD", SqlDbType.VarBinary).Value = bytes;
                }

				int insertedId = SQL.ExecuteAndGetInsertId(query, mainDb, param);
				CreateApproval(insertedId, int.Parse(Assessor1.Value), 1);
				CreateApproval(insertedId, int.Parse(Assessor2.Value), 2);
				CreateApproval(insertedId, int.Parse(Assessor3.Value), 3);
				CreateApproval(insertedId, int.Parse(Assessor4.Value), 4);
				CreateApproval(insertedId, int.Parse(Assessor5.Value), 5);
				CreateApproval(insertedId, int.Parse(Assessor6.Value), 6);

				if (checkPlan.Checked == true && checkNotPlan.Checked == false)
				{
					if (insertedId == 0) throw new Exception("Something went wrong!");

					SqlParameterCollection paramPlanAndCourse = new SqlCommand().Parameters;
					paramPlanAndCourse.AddWithValue("PLAN_ID", SqlDbType.Int).Value = trainingPlan.Value;
					paramPlanAndCourse.AddWithValue("COURSE_ID", SqlDbType.Int).Value = insertedId;
					paramPlanAndCourse.AddWithValue("CREATED_BY", SqlDbType.Int).Value = 1;
					SQL.ExecuteWithParams("INSERT INTO PLAN_AND_COURSE([PLAN_ID],[COURSE_ID],[CREATED_BY]) VALUES(@PLAN_ID,@COURSE_ID,@CREATED_BY)", mainDb, paramPlanAndCourse);
				}

				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "เพิ่มหลักสูตร";
					obj.REMARK = courseName.Value;
					obj.TABLE_NAME = "ADJUST_COURSE";
					obj.FK_ID = insertedId;
					Log.Create("add", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}

				if (hasFile == true)
				{
					try
					{
						ObjectLog obj = new ObjectLog();
						obj.TITLE = "อัปโหลดไฟล์";
						obj.REMARK = courseName.Value;
						obj.TABLE_NAME = "ADJUST_COURSE";
						obj.FK_ID = int.Parse(hiddenId.Value.ToString());
						Log.Create("edit", obj);
					}
					catch (Exception ex)
					{
						Console.WriteLine(ex.Message);
					}
				}

				Session.Add("alert", "inserted");
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Error!", $"{ex.Message}");
			}
		}
		void CreateApproval(int courseId, int personId, int seq) {
			if (personId != 0)
			{
				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("COURSE_ID", SqlDbType.Int).Value = courseId;
				param.AddWithValue("PERSON_ID", SqlDbType.Int).Value = personId;
				param.AddWithValue("APPROVAL_SEQUENCE", SqlDbType.Int).Value = seq;
				string query = "INSERT INTO APPROVAL(COURSE_ID,PERSON_ID,APPROVAL_SEQUENCE) VALUES(@COURSE_ID,@PERSON_ID,@APPROVAL_SEQUENCE)";
				SQL.ExecuteWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
			}
		}
		[WebMethod]
		public static int InsertEmployee(List<EmployeeIntoCourse> EmployeeSelectedList, int CourseId, Boolean IsDraft)
		{
			try
			{
				string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

				// clear employee in course before insert
				SqlConnection deleteConnection = new SqlConnection(connectionString);
				SqlCommand deleteCommand = new SqlCommand("DELETE FROM EVALUATE WHERE COURSE_ID=@courseId", deleteConnection);
				deleteCommand.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = CourseId;
				deleteConnection.Open();
				deleteCommand.ExecuteNonQuery();
				deleteConnection.Close();

				int successCount = 0;
				using (SqlConnection connection = new SqlConnection(connectionString))
				{
					string queryString = "INSERT INTO EVALUATE(COURSE_ID,PERSON_ID,SCORE_1,SCORE_2,SCORE_3,SCORE_4,SCORE_5,TOTAL_SCORE,IS_EVALUATED,EXAM_SCORE) VALUES(@courseId,@personId,0,0,0,0,0,0,0,0)";

					List<EmployeeIntoCourse> list = EmployeeSelectedList;
					for (int i = 0; i < list.Count; i++)
                    {
						using (SqlCommand cmd = new SqlCommand(queryString, connection))
						{
							cmd.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = list[i].CourseID;
							cmd.Parameters.AddWithValue("personId", SqlDbType.Int).Value = list[i].PersonID;

							connection.Open();
							cmd.ExecuteNonQuery();
							connection.Close();
						}
						successCount++;
					}


					// update status if IsDraft != true
					if (IsDraft != true)
                    {
						SqlConnection updateConnection = new SqlConnection(connectionString);
						SqlCommand updateCommand = new SqlCommand("UPDATE ADJUST_COURSE SET [STATUS]=2 WHERE ID=@courseId", updateConnection);
						updateCommand.Parameters.AddWithValue("courseId", SqlDbType.Int).Value = CourseId;
						updateConnection.Open();
						updateCommand.ExecuteNonQuery();
						updateConnection.Close();

						try
						{
							ObjectLog obj = new ObjectLog();
							obj.TITLE = "อัพเดทสถานะหลักสูตร";
							obj.REMARK = "อัพเดทสถานะหลักสูตร เลือกพนักงาน --> รอผู้อนุมัติ";
							obj.TABLE_NAME = "ADJUST_COURSE";
							obj.FK_ID = CourseId;
							Log.Create("edit", obj);
						}
						catch (Exception ex)
						{
							Console.WriteLine(ex.Message);
						}
					}

					HttpContext.Current.Session.Add("alert", "employee_inserted");
					return successCount;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				return 0;
			}
		}
		[WebMethod]
		public static string GetEmployeeList(int courseId)
		{
			string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

			DataTable dt = SQL.GetDataTable($"EXEC GET_TIGER_EMPLOYEE {courseId}", connectionString);
			return DATA.DataTableToJSONWithJSONNet(dt);
		}
		void Alert(string type, string title, string message)
		{
			Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
		}
		protected void ExportReportEvaluationOJT(object sender, EventArgs e)
        {
			try
            {

				int courseId = int.Parse(EXPORT_REPORT_COURSE_ID.Value.ToString());
				string exportName = "unname report";

				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = courseId;
				DataTable dt = SQL.GetDataTableWithParams("SELECT COURSE_NAME,TIMES FROM COURSE WHERE COURSE_ID=@ID", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);

				if (dt.Rows.Count > 0)
				{
					string courseName = dt.Rows[0]["COURSE_NAME"].ToString();
					string times = dt.Rows[0]["TIMES"].ToString();

					exportName = $"รายงานประเมินผล {DATA.MakeValidFileName(courseName)} ครั้งที่ {times}";
				}

				ReportDocument rpt = new ReportDocument();
				ExportFormatType expType = ExportFormatType.PortableDocFormat;

				rpt.Load(Server.MapPath("~/Reports/rpt_Manage_Course.rpt"));															
				rpt.RecordSelectionFormula = "{COURSE_AND_EMPLOYEE.COURSE_ID}=" + courseId;

				// set parameters
                rpt.SetParameterValue("PIC_PATH", Server.MapPath("~"));
                rpt.SetParameterValue("IS_Signed", isSigned.Checked == true ? 1 : 0);

                rpt.SetParameterValue("Commander", commanderName.Value);
                rpt.SetParameterValue("Commander_position", commanderPositionName.Value);
                rpt.SetParameterValue("Commander_date", commanderDate.Value);

                rpt.SetParameterValue("Ass", assessorName.Value);
                rpt.SetParameterValue("Ass_position", assessorPositionName.Value);
                rpt.SetParameterValue("ASS_Date", assessorDate.Value);

                rpt.SetParameterValue("Section_Manager", sectionManagerName.Value);
                rpt.SetParameterValue("Section_Manager_position", sectionManagerPositionName.Value);
                rpt.SetParameterValue("Section_Manager_Date", sectionManagerDate.Value);

                rpt.SetDatabaseLogon(SQL.user, SQL.pass);

				// logging
				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = exportName;
					Log.Create("print", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}

				rpt.ExportToHttpResponse(expType, Response, true, exportName);
			}	
			catch (Exception ex)
            {
				Console.WriteLine(ex.Message);
				Alert("error", "Error!", DATA.RemoveSpecialCharacters(ex.Message));
				ErrorHandleNotify.LineNotify(new FileInfo(this.Request.Url.LocalPath).Name.ToString(), "ExportReportEvaluationOJT", ex.Message);
			}
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

						exportName = $"รายงานประเมินผล {DATA.MakeValidFileName(courseName)} ครั้งที่ {times}";
					}

					ReportDocument rpt = new ReportDocument();
					ExportFormatType expType = ExportFormatType.PortableDocFormat;

					rpt.Load(Server.MapPath($"~/Reports/rpt_Manage_Course1.rpt"));
					rpt.RecordSelectionFormula = "{COURSE_AND_EMPLOYEE.COURSE_ID}=" + courseId;

					// set parameters
					rpt.SetParameterValue("PIC_PATH", Server.MapPath("~"));
					rpt.SetParameterValue("IS_Signed", isSigned.Checked == true ? 1 : 0);

					rpt.SetParameterValue("Commander", commanderName.Value);
					rpt.SetParameterValue("Commander_position", commanderPositionName.Value);
					rpt.SetParameterValue("Commander_date", commanderDate.Value);

					rpt.SetParameterValue("Ass", assessorName.Value);
					rpt.SetParameterValue("Ass_position", assessorPositionName.Value);
					rpt.SetParameterValue("ASS_Date", assessorDate.Value);

					rpt.SetParameterValue("Section_Manager", sectionManagerName.Value);
					rpt.SetParameterValue("Section_Manager_position", sectionManagerPositionName.Value);
					rpt.SetParameterValue("Section_Manager_Date", sectionManagerDate.Value);

					rpt.SetDatabaseLogon(SQL.user, SQL.pass);

					// logging
					try
					{
						ObjectLog obj = new ObjectLog();
						obj.TITLE = exportName;
						Log.Create("print", obj);
					}
					catch (Exception ex)
					{
						Console.WriteLine(ex.Message);
					}

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
					string queryString = "SELECT (SELECT PLAN_ID FROM PLAN_AND_COURSE WHERE COURSE_ID=@courseId) AS PLAN_ID,(SELECT ID FROM PLAN_AND_COURSE WHERE COURSE_ID=@courseId) AS PLAN_AND_COURSE_ID,*  FROM ADJUST_COURSE  WHERE ID=@courseId";
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
		[WebMethod]
		public static string GetApprovalList(int courseId)
		{
			try
			{
				using (SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString))
				{
					string queryString = "SELECT * FROM APPROVAL_LIST WHERE COURSE_ID=@ID";
					using (SqlCommand cmd = new SqlCommand(queryString, connection))
					{
						cmd.Parameters.AddWithValue("ID", SqlDbType.Int).Value = courseId;

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
		[WebMethod]
		public static string CreateSessionToEvaluate(int courseId)
		{
			try
			{
				string query = "SELECT " +
					"ISNULL ([IS_EXAM_EVALUATE], 0) [IS_EXAM_EVALUATE] ," +
					"ISNULL ([IS_REAL_WORK_EVALUATE], 0) [IS_REAL_WORK_EVALUATE] ," +
					"ISNULL ([IS_OTHER_EVALUATE], 0) [IS_OTHER_EVALUATE] " +
					"FROM [VIEW_ADJUST_COURSE] " +
					$"WHERE ID = {courseId}";
				DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);

				if (dt.Rows.Count > 0 )
                {
					bool exam = bool.Parse(dt.Rows[0]["IS_EXAM_EVALUATE"].ToString());
					bool realWork = bool.Parse(dt.Rows[0]["IS_REAL_WORK_EVALUATE"].ToString());
					bool other = bool.Parse(dt.Rows[0]["IS_OTHER_EVALUATE"].ToString());

					if (exam == false && realWork == false && other == true)
                    {
						return "OTHER";
                    }
				}

				HttpContext.Current.Session.Add("EVALUATE_COURSE_ID", courseId);
				HttpContext.Current.Session.Add("IS_EVALUATION", 1);

				return "SUCCESS";
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				return "FAILED";
			}
		}
		protected void btnEdit_Click(object sender, EventArgs e)
		{
			try
			{
				string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
				SqlParameterCollection updateAdjustCourseParamCollection = new SqlCommand().Parameters;
				bool hasFile = false;
				string filePath = "";
				string fileName = "";
				string extension = "";
				Byte[] bytes = new Byte[64];
				BinaryReader br;
				Stream fs;

				if (fileUpload.PostedFile.ContentLength > 0)
				{
					filePath = fileUpload.PostedFile.FileName;
					fileName = Path.GetFileName(filePath);
					extension = Path.GetExtension(fileName);

					if (extension != ".pdf") throw new Exception("อัพโหลดได้เฉพาะ .pdf เท่านั้น ");

					fs = fileUpload.PostedFile.InputStream;
					br = new BinaryReader(fs);
					bytes = br.ReadBytes((Int32)fs.Length);
					hasFile = true;
				}

				string queryUpdateAdjustCourse = "UPDATE [ADJUST_COURSE] SET " +
					"[COURSE_NUMBER]=@COURSE_NUMBER " +
					",[TIMES]=@TIMES " +
					",[COURSE_NAME]=@COURSE_NAME " +
					",[START_DATE]=@START_DATE " +
					",[END_DATE]=@END_DATE " +
					",[START_TIME]=@START_TIME " +
					",[END_TIME]=@END_TIME " +
					",[TOTAL_HOURS]=@TOTAL_HOURS " +
					",[DEPARTMENT_ID]=@DEPARTMENT_ID " +
					",[LOCATION_ID]=@LOCATION_ID " +
					",[TEACHER_ID]=@TEACHER_ID " +
					",[DETAIL]=@DETAIL " +
					",[OBJECTIVE]=@OBJECTIVE " +
					",[ASSESSOR1_ID]=@ASSESSOR1_ID " +
					",[ASSESSOR2_ID]=@ASSESSOR2_ID " +
					",[ASSESSOR3_ID]=@ASSESSOR3_ID " +
					",[ASSESSOR4_ID]=@ASSESSOR4_ID " +
					",[ASSESSOR5_ID]=@ASSESSOR5_ID " +
					",[ASSESSOR6_ID]=@ASSESSOR6_ID " +
					",[CREATED_BY]=@CREATED_BY" +
					",[IS_EXAM_EVALUATE]=@IS_EXAM_EVALUATE" +
					",[IS_REAL_WORK_EVALUATE]=@IS_REAL_WORK_EVALUATE " +
					",[IS_OTHER_EVALUATE]=@IS_OTHER_EVALUATE " +
					",[OTHER_EVALUATE_REMARK]=@OTHER_EVALUATE_REMARK";
				if (hasFile == true)
                {
					queryUpdateAdjustCourse += ",[FILE_UPLOAD]=@FILE_UPLOAD ";

				}
				queryUpdateAdjustCourse += " WHERE ID=@courseId";
				updateAdjustCourseParamCollection.AddWithValue("COURSE_NUMBER", SqlDbType.VarChar).Value = courseNumber.Value;
				updateAdjustCourseParamCollection.AddWithValue("TIMES", SqlDbType.Int).Value = times.Value;
				updateAdjustCourseParamCollection.AddWithValue("COURSE_NAME", SqlDbType.VarChar).Value = courseName.Value;
				updateAdjustCourseParamCollection.AddWithValue("START_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(startDate.Value);
				updateAdjustCourseParamCollection.AddWithValue("END_DATE", SqlDbType.Date).Value = DATA.DateTimeToSQL(endDate.Value);
				updateAdjustCourseParamCollection.AddWithValue("START_TIME", SqlDbType.VarChar).Value = startTime.Value;
				updateAdjustCourseParamCollection.AddWithValue("END_TIME", SqlDbType.VarChar).Value = endTime.Value;
				updateAdjustCourseParamCollection.AddWithValue("TOTAL_HOURS", SqlDbType.Int).Value = totalHours.Value;
				updateAdjustCourseParamCollection.AddWithValue("DEPARTMENT_ID", SqlDbType.Int).Value = department.Value;
				updateAdjustCourseParamCollection.AddWithValue("LOCATION_ID", SqlDbType.Int).Value = location.Value;
				updateAdjustCourseParamCollection.AddWithValue("TEACHER_ID", SqlDbType.Int).Value = teacher.Value;
				updateAdjustCourseParamCollection.AddWithValue("DETAIL", SqlDbType.VarChar).Value = detail.Value;
				updateAdjustCourseParamCollection.AddWithValue("OBJECTIVE", SqlDbType.VarChar).Value = objective.Value;
				updateAdjustCourseParamCollection.AddWithValue("ASSESSOR1_ID", SqlDbType.Int).Value = Assessor1.Value;
				updateAdjustCourseParamCollection.AddWithValue("ASSESSOR2_ID", SqlDbType.Int).Value = Assessor2.Value;
				updateAdjustCourseParamCollection.AddWithValue("ASSESSOR3_ID", SqlDbType.Int).Value = Assessor3.Value;
				updateAdjustCourseParamCollection.AddWithValue("ASSESSOR4_ID", SqlDbType.Int).Value = Assessor4.Value;
				updateAdjustCourseParamCollection.AddWithValue("ASSESSOR5_ID", SqlDbType.Int).Value = Assessor5.Value;
				updateAdjustCourseParamCollection.AddWithValue("ASSESSOR6_ID", SqlDbType.Int).Value = Assessor6.Value;
				updateAdjustCourseParamCollection.AddWithValue("CREATED_BY", SqlDbType.Int).Value = Session["userId"];
				updateAdjustCourseParamCollection.AddWithValue("courseId", SqlDbType.Int).Value = hiddenId.Value;
				updateAdjustCourseParamCollection.AddWithValue("IS_EXAM_EVALUATE", SqlDbType.Bit).Value = examEvaluate.Checked == true ? 1 : 0;
				updateAdjustCourseParamCollection.AddWithValue("IS_REAL_WORK_EVALUATE", SqlDbType.Bit).Value = realWorkEvaluate.Checked == true ? 1 : 0;
				updateAdjustCourseParamCollection.AddWithValue("IS_OTHER_EVALUATE", SqlDbType.Bit).Value = otherEvaluate.Checked == true ? 1 : 0;
				updateAdjustCourseParamCollection.AddWithValue("OTHER_EVALUATE_REMARK", SqlDbType.VarChar).Value = otherEvaluateRemark.Value;
				if (hasFile == true)
				{
					updateAdjustCourseParamCollection.AddWithValue("FILE_UPLOAD", SqlDbType.VarBinary).Value = bytes;
                }
				SQL.ExecuteWithParams(queryUpdateAdjustCourse, mainDb, updateAdjustCourseParamCollection);


				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "แก้ไขหลักสูตร";
					obj.REMARK = courseName.Value;
					obj.TABLE_NAME = "ADJUST_COURSE";
					obj.FK_ID = int.Parse(hiddenId.Value.ToString());
					Log.Create("edit", obj);
				}
				catch (Exception ex)
				{
					Console.WriteLine(ex.Message);
				}

				if (hasFile == true)
                {
					try
					{
						ObjectLog obj = new ObjectLog();
						obj.TITLE = "อัปโหลดไฟล์";
						obj.REMARK = courseName.Value;
						obj.TABLE_NAME = "ADJUST_COURSE";
						obj.FK_ID = int.Parse(hiddenId.Value.ToString());
						Log.Create("edit", obj);
					}
					catch (Exception ex)
					{
						Console.WriteLine(ex.Message);
					}
				}

				Session["alert"] = "updated";
				Response.Redirect(_selfPathName);
			}
			catch (Exception ex)
			{
				Alert("error", "Error!", $"{ex.Message}");
			}
		}
        protected void btnDelete_ServerClick(object sender, EventArgs e)
        {
			 try
			{
				string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("ID", SqlDbType.Int).Value = int.Parse(hiddenId.Value.ToString());

				SQL.ExecuteWithParams("EXECUTE SP_DELETE_COURSE @ID", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);

				try
				{
					ObjectLog obj = new ObjectLog();
					obj.TITLE = "ลบหลักสูตร";
					obj.TABLE_NAME = "ADJUST_COURSE";
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
				Console.WriteLine(ex.Message);
				Alert("error", "Failed!", "A network error was encountered, Please try again.");
			}
		}
		protected void DownloadPDFDocument(object sender, EventArgs e)
        {
			try
			{
				if (string.IsNullOrEmpty(downloadFileId.Value)) throw new Exception("Not Found!");
				int id = int.Parse(downloadFileId.Value);

				SqlParameterCollection param = new SqlCommand().Parameters;
				param.AddWithValue("rowId", SqlDbType.Int).Value = id;
				DataTable dt = SQL.GetDataTableWithParams("SELECT COURSE_NAME,FILE_UPLOAD FROM ADJUST_COURSE WHERE ID=@rowId", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);

				if (dt.Rows.Count > 0)
				{
					Response.Clear();
					Response.Buffer = true;
					Response.ContentType = "application/pdf";
					Response.AddHeader("content-disposition", "attachment;filename="+ "เอกสารหลักสูตร " + dt.Rows[0]["COURSE_NAME"].ToString() + ".pdf");
					Response.Charset = "";
					Response.Cache.SetCacheability(HttpCacheability.NoCache);
					Response.BinaryWrite((byte[])dt.Rows[0]["FILE_UPLOAD"]);
					Response.End();

				}
				else
				{
					Alert("error", "ล้มเหลว!", "ไม่พบไฟล์ กรุณาลองใหม่อีกครั้ง");
				}
			}
			catch (Exception ex)
			{
				Alert("error", "Error!", $"{ex.Message}");
			}
		}

		[WebMethod]
		public static string UpdateStatusWithOther(int courseId)
        {
			try
            {
				using (SqlConnection connection = new SqlConnection(WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString))
				{
					string queryString = "UPDATE ADJUST_COURSE SET [STATUS]=3, EVALUATED_DATE=GETDATE()  WHERE ID=@COURSE_ID";
					using (SqlCommand cmd = new SqlCommand(queryString, connection))
					{
						cmd.Parameters.AddWithValue("COURSE_ID", SqlDbType.Int).Value = courseId;

						connection.Open();
						cmd.ExecuteNonQuery();
						connection.Close();

						try
						{
							ObjectLog obj = new ObjectLog();
							obj.TITLE = "ยืนยันการปรับสถานะหลักสูตร";
							obj.REMARK = "-";
							obj.TABLE_NAME = "ADJUST_COURSE";
							obj.FK_ID = courseId;
							Log.Create("edit", obj);
						}
						catch (Exception ex)
						{
							Console.WriteLine(ex.Message);
						}

						HttpCookie cookie = new HttpCookie("alert");
						cookie.Expires = DateTime.Now.AddSeconds(20);
						cookie.Value = "status_updated";
						HttpContext.Current.Response.Cookies.Add(cookie);

						return "OK";
					}
				}   
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				return "ERROR";
			}
		}
		[WebMethod]
		public static string GetPlanDateByCourseId(int courseId)
        {
			try
            {
				string query = $"SELECT * FROM VIEW_PLAN WHERE ID = {courseId}";
				DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
				if (dt.Rows.Count > 0)
                {
					return DATA.DataTableToJSONWithJSONNet(dt);
                }
				return "NOTHING";
			}
			catch (Exception ex)
            {
				Console.WriteLine(ex.Message);
				return "ERROR";
            }

		}
    }
    public class EmployeeIntoCourse
    {
        public int PersonID { get; set; }
        public int CourseID { get; set; }
    }
	public class ExportReportParameter
    {
        public int COURSE_ID { get; set; }
        public string COMMANDER_NAME { get; set; }
        public string COMMANDER_DATE { get; set; }
        public string SECTION_MANAGER_NAME { get; set; }
        public string SECTION_MANAGER_DATE { get; set; }
        public string TRAINING_OFFICER_NAME { get; set; }
        public string TRAINING_OFFICER_DATE { get; set; }
    }
}