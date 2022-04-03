﻿using MHI_OJT2.Pages.Systems;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Reports
{
    public partial class Skill_map_report : Page
    {
        public static string role = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();
            if(!IsPostBack)
            {
                string _role = Session["roles"].ToString().ToLower();
                role = _role;
                if (role == "user")
                {
                    Response.Redirect("~/Pages/Error/403.aspx");
                }

                GetSectionName();
            }
        }
        protected void GetSectionName()
        {
            // for admin
            string query = "SELECT SECTION_NAME FROM SECTION WHERE IS_ACTIVE = 1";
            
            // for clerk
            if (role == "clerk")
            {
                query = "SELECT DISTINCT SECTION_NAME FROM COURSE WHERE CREATED_BY = " + int.Parse(Session["userId"].ToString());
            }
            DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);

            if (dt.Rows.Count <= 0)
            {
                Session.Add("alert", "skill-map-not-found");
                Response.Redirect("~/Default.aspx");
            }

            section.DataSource = dt;
            section.DataTextField = "SECTION_NAME";
            section.DataValueField = "SECTION_NAME";
            section.DataBind();
        }

        public static string DateToSQLDateString(string d)
        {
            string[] split = d.Split('/');
            string day = split[0];
            string month = split[1];
            int year = int.Parse(split[2]);
            if (year > 2100)
            {
                year = year - 543;
            }

            string result = $"{year}-{month}-{day}";
            return result;
        }

        [WebMethod]
        public static string GetReportData(string sectionName, string startDate, string endDate)
        {
            string query = $"EXEC SP_SKILL_MAP '{sectionName}', '{DateToSQLDateString(startDate)}', '{DateToSQLDateString(endDate)}'";
            DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);

            // logging
            try
            {
                ObjectLog obj = new ObjectLog();
                obj.TITLE = "SKILL MAP";
                obj.REMARK = $"ฝ่าย->{sectionName} // ช่วงวันที่ {startDate} ถึง {endDate}";
                Log.Create("print", obj);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            return DATA.DataTableToJSONWithJSONNet(dt);
        }
        [WebMethod]
        public static string GetDepartmentName(string courseName)
        {
            string result = "NULL";
            string query = "SELECT " +
                "DEP.DEPARTMENT_NAME " +
                "FROM ADJUST_COURSE ADJ " +
                "JOIN DEPARTMENT DEP ON DEP.ID = ADJ.DEPARTMENT_ID " +
                $"WHERE COURSE_NAME = '{courseName}'";
            DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
            if (dt.Rows.Count > 0)
            {
                result = dt.Rows[0]["DEPARTMENT_NAME"].ToString().ToUpper();
            }
            return result;
        }
    }
}