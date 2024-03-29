﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
//using CrystalDecisions.CrystalReports.Engine;
//using CrystalDecisions.Shared;
using MHI_OJT2.Pages.Management;
using MHI_OJT2.Pages.Systems;

namespace MHI_OJT2
{
    public partial class Auth : MasterPage
    {
		public static string applicationPath = "";

        string _sessionAlert = null;
		public static string _403 = "";
		public static string Dashboard = "";
		static string _firstName = String.Empty;
		static string _lastName = String.Empty;
		static string _positionName = String.Empty;
		public static string sessionProfileName = String.Empty;
		public int notificationCount = 0;
		public int clerkNoticationCount = 0;

		protected void Page_Load(object sender, EventArgs e)
			{
				Thread.CurrentThread.CurrentCulture = new CultureInfo( "en-US" );
			applicationPath = HttpContext.Current.Request.ApplicationPath == "/" ? "" : HttpContext.Current.Request.ApplicationPath;
				Dashboard = "~" + applicationPath + "/Default.aspx";
				_403 = "~" + applicationPath + "/Pages/Error/403.aspx";

				CheckLoggedIn();
				CheckAlertSession();
				if (!IsPostBack)
				{
					if (Request.Cookies["alert"] != null)
					{
						string cookieValue = Request.Cookies["alert"].Value;
						if (cookieValue == "approved" || cookieValue == "rejected")
						{
							Alert("success", "สำเร็จ!", "บันทึกข้อมูลการอนุมัติเรียบร้อยแล้ว");
						}

						if (cookieValue == "status_updated")
						{
							Alert("success", "สำเร็จ!", "บันทึกข้อมูลเรียบร้อยแล้ว");
						}
						ClearCookie("alert");
					}

					int userId = int.Parse(Session["userId"].ToString());
					string role = Session["roles"].ToString().ToLower();
					if (role == "user")
					{
						GetNotification(userId);
					}  else
					{
						// clerk and admin
						GetClerkNotification(userId);
					}
				}
		}
		public void	ClearCookie(string name)
        {
			HttpCookie cookie = HttpContext.Current.Request.Cookies[name];
			HttpContext.Current.Response.Cookies.Remove(name);
			cookie.Expires = DateTime.Now.AddDays(-10);
			cookie.Value = null;
			HttpContext.Current.Response.SetCookie(cookie);
		}
		void CheckAlertSession()
		{
			_sessionAlert = null;
			if (Session["alert"] != null)
			{
				_sessionAlert = Session["alert"] as string;

				if (_sessionAlert == "approved")
				{
					Alert("success", "สำเร็จ!", "บันทึกข้อมูลการอนุมัติเรียบร้อยแล้ว");
				};

				Session.Remove("alert");
			}
		}
		void Alert(string type, string title, string message)
	{
		Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
	}
		void GetNotification(int userId)
		{
				
			DataTable dt = SQL.GetDataTable($"EXEC SP_APPROVAL_LIST {userId}, 10", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
			notificationCount = dt.Rows.Count;
			
			RepeatNotification.DataSource = dt;
			RepeatNotification.DataBind();
		}
		void GetClerkNotification(int userId)
		{
			string query = $"SELECT * FROM VIEW_CLERK_NOTIFICATION WHERE USER_ID = {userId} AND [READ]=0";
			DataTable ClerkDataTable = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
			if (ClerkDataTable.Rows.Count > 0)
            {
				clerkNoticationCount = ClerkDataTable.Rows.Count;

				DataTable dt = ClerkDataTable.Rows.Cast<System.Data.DataRow>().Take(10).CopyToDataTable();
				ClerkNotificationRepleter.DataSource = dt;
				ClerkNotificationRepleter.DataBind();
			}
		}
		public static int CheckLoggedIn()
		{
			try
			{
				_firstName = (string)HttpContext.Current.Session["firstName"];
				_lastName = (string)HttpContext.Current.Session["lastName"];
				_positionName = (string)HttpContext.Current.Session["positionName"];

				if (String.IsNullOrEmpty(_firstName) && String.IsNullOrEmpty(_lastName) && String.IsNullOrEmpty(_positionName)) throw new Exception("Session is empty.");

				string fullName = $"{_firstName} {_lastName}";
				BindSession(fullName, _positionName);
				return 1;
			}
			catch (Exception ex)
			{
				HttpContext.Current.Response.Redirect("~" + applicationPath + "/Login.aspx");
				Console.WriteLine(ex.Message);
				return 0;
			}
		}
		public static int BindSession(string fullName, string positionName)
		{
			sessionProfileName = fullName;
			return 1;
		}
		protected void Logout(object sender, EventArgs e)
		{
			Session.Abandon();
			Session.RemoveAll();
			Response.Redirect("~" + applicationPath + "/Login.aspx");
		}
		protected void DownloadReportTrainingEvaluationOJT(object sender, EventArgs e)
		{
			if ( downloadReportId.Value.ToString() != "" || !string.IsNullOrEmpty(downloadReportId.Value.ToString()) )
            {
                try
                {
					//int courseId = int.Parse(downloadReportId.Value.ToString());
					//string exportName = "unname report";

					//SqlParameterCollection param = new SqlCommand().Parameters;
					//param.AddWithValue("ID", SqlDbType.Int).Value = courseId;
					//DataTable dt = SQL.GetDataTableWithParams("SELECT COURSE_NAME,TIMES FROM COURSE WHERE COURSE_ID=@ID", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);

					//if (dt.Rows.Count > 0)
					//{
					//	string courseName = dt.Rows[0]["COURSE_NAME"].ToString();
					//	string times = dt.Rows[0]["TIMES"].ToString();

					//	exportName = $"รายงานประเมินผล {DATA.MakeValidFileName(courseName)} ครั้งที่ {times}";
					//}

					//ReportDocument rpt = new ReportDocument();
					//ExportFormatType expType = ExportFormatType.PortableDocFormat;

					//rpt.Load(filename: Server.MapPath($"~/Reports/rpt_Manage_Course.rpt"));
					//rpt.RecordSelectionFormula = "{COURSE_AND_EMPLOYEE.COURSE_ID}=" + courseId;

					//// set parameters
					//rpt.SetParameterValue("PIC_PATH", Server.MapPath("~"));
					//rpt.SetParameterValue("IS_Signed", 0);

					//rpt.SetParameterValue("Commander", "");
					//rpt.SetParameterValue("Commander_position", "");
					//rpt.SetParameterValue("Commander_date", "");

					//rpt.SetParameterValue("Ass", "");
					//rpt.SetParameterValue("Ass_position", "");
					//rpt.SetParameterValue("ASS_Date", "");

					//rpt.SetParameterValue("Section_Manager", "");
					//rpt.SetParameterValue("Section_Manager_position", "");
					//rpt.SetParameterValue("Section_Manager_Date", "");

					//rpt.SetDatabaseLogon(SQL.user, SQL.pass);

					//// logging
					//try
					//{
					//	ObjectLog obj = new ObjectLog();
					//	obj.TITLE = exportName;
					//	Log.Create("print", obj);
					//}
					//catch (Exception ex)
					//{
					//	Console.WriteLine(ex.Message);
					//}

					//rpt.ExportToHttpResponse(expType, Response, true, exportName);
					//downloadReportId.Value = "0";
				} catch (Exception ex)
                {
					//DownloadReportTrainingEvaluationOJT
					ErrorHandleNotify.LineNotify(new FileInfo(this.Request.Url.LocalPath).Name.ToString(), "DownloadReportTrainingEvaluationOJT", ex.Message);
				}
			}
			

		}
    }
}