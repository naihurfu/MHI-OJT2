﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2
{
    public partial class Default : System.Web.UI.Page
    {
		public static int allCourseCount = 0;
		public static int trainedThisYear = 0;
		public static int waitingForEvaluation = 0;
		public static int waitingForApproval = 0;
		public static int statusTableRowCount = 0;
		protected void Page_Load(object sender, EventArgs e)
        {
			Auth.CheckLoggedIn();
			int userId = int.Parse(Session["userId"].ToString());
			string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

			if (!IsPostBack) {
				GetCourseTable(userId, connectionString);
				GetCountCard(userId, connectionString);
			}
        }
		protected void GetCountCard(int userId, string connectionString)
        {
			allCourseCount = 0;
			trainedThisYear = 0;
			waitingForEvaluation = 0;
			waitingForApproval = 0;

			string query = string.Empty;
			string role = Session["roles"].ToString().ToLower();
			if (role == "user")
            {
				query = $"EXECUTE SP_DASHBOARD_CARD_USER {userId}";
			}

			if (role == "clerk")
            {
				query = $"SELECT " +
					$" COUNT(CASE WHEN CREATED_BY = {userId} THEN 1 END) AS ALL_COURSE_COUNT " +
					$",COUNT(CASE WHEN CREATED_BY = {userId} AND YEAR(START_DATE) = YEAR(GETDATE()) THEN 1 END) AS TRAINED_THIS_YEAR " +
					$",COUNT(CASE WHEN CREATED_BY = {userId} AND [STATUS] = 2 THEN 1 END) AS WAITING_FOR_EVALUATION " +
					$",COUNT(CASE WHEN CREATED_BY = {userId} AND ([STATUS] > 2 AND [STATUS] <= 8 ) THEN 1 END) AS WAITING_FOR_APPROVAL " +
					$" FROM ADJUST_COURSE WHERE CREATED_BY = {userId}";
			}

			if (role == "admin")
            {
				query = "SELECT " +
					" COUNT(*) AS ALL_COURSE_COUNT " +
					",COUNT(CASE WHEN YEAR(START_DATE) = YEAR(GETDATE()) THEN 1 END) AS TRAINED_THIS_YEAR " +
					",COUNT(CASE WHEN [STATUS] = 2 THEN 1 END) AS WAITING_FOR_EVALUATION " +
					",COUNT(CASE WHEN  ([STATUS] > 2 AND [STATUS] <= 8 ) THEN 1 END) AS WAITING_FOR_APPROVAL " +
					"FROM ADJUST_COURSE";
            }

			DataTable dt = SQL.GetDataTable(query, connectionString);
			if (dt.Rows.Count > 0)
            {
				allCourseCount = int.Parse(dt.Rows[0]["ALL_COURSE_COUNT"].ToString());
				trainedThisYear = int.Parse(dt.Rows[0]["TRAINED_THIS_YEAR"].ToString());
				waitingForEvaluation = int.Parse(dt.Rows[0]["WAITING_FOR_EVALUATION"].ToString());
				waitingForApproval = int.Parse(dt.Rows[0]["WAITING_FOR_APPROVAL"].ToString());
            }
		}
		protected void GetCourseTable(int userId, string connectionString)
        {
			try
            {
				string query = string.Empty;

				if (Session["roles"].ToString().ToLower() == "user")
                {
					query = $"SELECT " +
					" v.COURSE_NAME " +
					",v.TIMES " +
					",v.START_DATE " +
					",v.STATUS_CODE " +
					",v.STATUS_TEXT " +
					" FROM VIEW_ADJUST_COURSE v " +
					"JOIN EVALUATE e ON e.COURSE_ID = v.COURSE_ID " +
					$"WHERE YEAR(START_DATE) = YEAR(GETDATE()) AND e.PERSON_ID = {userId} " +
					"ORDER BY START_DATE DESC";
                }
				
				if (Session["roles"].ToString().ToLower() == "clerk")
                {
					query = $"SELECT DISTINCT" +
					" v.COURSE_NAME " +
					",v.TIMES " +
					",v.START_DATE " +
					",v.STATUS_CODE " +
					",v.STATUS_TEXT " +
					" FROM VIEW_ADJUST_COURSE v " +
					"JOIN EVALUATE e ON e.COURSE_ID = v.COURSE_ID " +
					$"WHERE YEAR(START_DATE) = YEAR(GETDATE()) AND v.CREATED_BY = {userId} " +
					$"ORDER BY START_DATE DESC";
				}

				if (Session["roles"].ToString().ToLower() == "admin")
				{
					query = $"SELECT DISTINCT" +
					" v.COURSE_NAME " +
					",v.TIMES " +
					",v.START_DATE " +
					",v.STATUS_CODE " +
					",v.STATUS_TEXT " +
					" FROM VIEW_ADJUST_COURSE v " +
					"JOIN EVALUATE e ON e.COURSE_ID = v.COURSE_ID " +
					$"WHERE YEAR(START_DATE) = YEAR(GETDATE()) " +
					$"ORDER BY START_DATE DESC";
				}

				DataTable dt = SQL.GetDataTable(query, connectionString);
				statusTableRowCount = dt.Rows.Count;
				statusTableRepeater.DataSource = dt;
				statusTableRepeater.DataBind();
			}	catch (Exception ex)
            {
				Console.WriteLine(ex.Message);
            }
        }
		[WebMethod]
		public static string MarkNotifyAsRead(int rowId)
		{
			try
			{
				using (SqlConnection con = new SqlConnection(WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString))
				{
					string query = $"UPDATE CLERK_NOTIFICATION SET [READ]=1 WHERE ID={rowId}";
					SqlCommand command = new SqlCommand(query, con);
					con.Open();
					command.ExecuteNonQuery();
					con.Close();
					return "OK";
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				return "ERROR";
			}
		}
		[WebMethod]
		public static string GetChart(int PersonID, string Roles)
        {
			try
            {

				string query = string.Empty;
				SqlConnection con = new SqlConnection(WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
				
				if (Roles == "admin")
                {
					query = "SELECT COURSE_NAME labels " +
						",COUNT(*) datas " +
						"FROM EVALUATE " +
						"INNER JOIN ADJUST_COURSE ON ADJUST_COURSE.ID = EVALUATE.COURSE_ID " +
						"WHERE YEAR(ADJUST_COURSE.START_DATE) = YEAR(GETDATE()) " +
						"GROUP BY COURSE_NAME";

				}  else if (Roles == "clerk")
                {
					query = "SELECT COURSE_NAME labels " +
						",COUNT(*) datas " +
						"FROM EVALUATE " +
						"INNER JOIN ADJUST_COURSE ON ADJUST_COURSE.ID = EVALUATE.COURSE_ID " +
						"WHERE YEAR(ADJUST_COURSE.START_DATE) = YEAR(GETDATE()) " +
						"AND CREATED_BY = @ID " +
						"GROUP BY COURSE_NAME";

				}
				else
				{
					query = "SELECT " +
					" TOTAL_SCORE datas " +
					",COURSE_NAME labels " +
					"FROM EVALUATE " +
					"INNER JOIN ADJUST_COURSE ON ADJUST_COURSE.ID = EVALUATE.COURSE_ID " +
					"WHERE YEAR(ADJUST_COURSE.START_DATE) = YEAR(GETDATE()) " +
					"AND EVALUATE.PERSON_ID = @ID ";
				}

				SqlCommand command = new SqlCommand(query, con);
				con.Open();
				command.Parameters.AddWithValue("ID", SqlDbType.Int).Value = PersonID;
				command.CommandType = CommandType.Text;
				SqlDataAdapter da = new SqlDataAdapter();
				da.SelectCommand = command;
				con.Close();

				DataTable dt = new DataTable();
				da.Fill(dt);

				return DATA.DataTableToJSONWithJSONNet(dt);
            }
			catch (Exception ex)
            {
				Console.WriteLine(ex.Message);
				return "{ error : '"+ ex.Message + "'}";
            }
        }
	}
}