﻿using CrystalDecisions.CrystalReports.Engine;
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
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages
{
    public partial class Training_profile : Page
    {
        public static string roles = String.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
                txtYearSearch.Value = DateTime.Now.Year.ToString();
                string role = Session["roles"].ToString().ToLower();
                roles = role;
                GetTrainingHistory(role);
                GetSection(role);
                GetCourse(role);
            }
        }
        protected void GetSection(string role)
        {
            if (role != "user")
            {
                string query = "SELECT DISTINCT DEPARTMENT_ID,DEPARTMENT_NAME FROM COURSE_AND_EMPLOYEE ";
            
                if (role == "clerk")
                {
                    query += "WHERE CREATED_ID = " + Session["userId"];
                }
            
                section.DataSource = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
                section.DataTextField = "DEPARTMENT_NAME";
                section.DataValueField = "DEPARTMENT_ID";
                section.DataBind();
                section.Items.Insert(0, new ListItem("ทั้งหมด", "0"));
                section.SelectedIndex = 0;
            }
        }
        protected void GetCourse(string role)
        {
            if (role != "user")
            {
                string query = "SELECT DISTINCT COURSE_ID,COURSE_NAME FROM COURSE_AND_EMPLOYEE ";

                if (role == "clerk")
                {
                    query += "WHERE CREATED_ID = " + Session["userId"];
                }

                course.DataSource = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
                course.DataTextField = "COURSE_NAME";
                course.DataValueField = "COURSE_ID";
                course.DataBind();
                course.Items.Insert(0, new ListItem("ทั้งหมด", "0"));
                course.SelectedIndex = 0;
            }
        }
        void GetTrainingHistory(string role)
        {
            SqlParameterCollection param = new SqlCommand().Parameters;
            string query = "SELECT * FROM COURSE_AND_EMPLOYEE WHERE 1=1 ";

            if (role == "user")
            {
                param.AddWithValue("ID", SqlDbType.Int).Value = int.Parse(Session["userId"].ToString());
                query += " AND PersonID=@ID ";
            }

            if (role == "clerk")
            {
                param.AddWithValue("ID", SqlDbType.Int).Value = int.Parse(Session["userId"].ToString());
                query += " AND CREATED_ID=@ID ";
            
            }

            query += " AND YEAR(START_DATE) = " + txtYearSearch.Value.ToString();


            RepeatTable.DataSource = SQL.GetDataTableWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
            RepeatTable.DataBind();
        }
        protected void ExportReportTrainingProfile(object sender, EventArgs e)
        {
           try
            {
                ReportDocument rpt = new ReportDocument();
                ExportFormatType expType = ExportFormatType.PortableDocFormat;
                int id = int.Parse(Session["userId"].ToString());
                string exportName = "TRAINING PROFILE REPORT";
                string reportName = "~/Reports/Training_Profile_Clerk.rpt";

                if (roles == "user")
                {
                    reportName = "~/Reports/Training_Profile_Emp.rpt";
                }

                rpt.Load(Server.MapPath(reportName));

                string[] sDate = startDate.Value.Split('/');
                string[] eDate = endDate.Value.Split('/');
                string formula = "{COURSE_AND_EMPLOYEE.START_DATE} >= Date (" + sDate[2] + ", " + sDate[1] + ", " + sDate[0] + ") " +
                    "AND {COURSE_AND_EMPLOYEE.START_DATE} <= Date (" + eDate[2] + ", " + eDate[1] + ", " + eDate[0] + ") ";

                if (roles == "user")
                {
                    formula += " AND " +
                        "{COURSE_AND_EMPLOYEE.PersonID} = " + id + " ";
                }

                if (roles == "clerk")
                {
                    formula += " AND " +
                            "{COURSE_AND_EMPLOYEE.CREATED_ID} = " + id + " ";
                }

                if (roles == "clerk" || roles == "admin")
                {
                    int _section = int.Parse(section.Value.ToString());
                    string _employeeStartId = employeeIdStart.Value;
                    string _employeeEndId = employeeIdEnd.Value;
                    int _course = int.Parse(course.Value.ToString());

                    // ระบุฝ่าย
                    if (_section != 0)
                    {
                        formula += " AND " +
                            "{COURSE_AND_EMPLOYEE.DEPARTMENT_ID} = " + _section + " ";

                    }

                    // ระบุรหัสพนักงาน
                    if (_employeeStartId.Length > 0 && _employeeEndId.Length > 0)
                    {
                        int minId = SelectPersonIDForReport(_employeeStartId);
                        int maxId = SelectPersonIDForReport(_employeeEndId);
                        formula += " AND " +
                             "({COURSE_AND_EMPLOYEE.PersonID} >= " + minId + " " +
                             " AND " +
                             "{COURSE_AND_EMPLOYEE.PersonID} <= " + maxId + " )";
                    }


                    // ระบุครอส
                    if (_course != 0)
                    {
                        formula += " AND " +
                             "{COURSE_AND_EMPLOYEE.COURSE_ID} = " + _course + " ";
                    }
                }

                rpt.RecordSelectionFormula = formula;
                rpt.SetDatabaseLogon(SQL.user, SQL.pass);

                // logging
                try
                {
                    ObjectLog obj = new ObjectLog();
                    obj.TITLE = exportName;
                    obj.REMARK = $"ช่วงวันที่ {startDate.Value.ToString()} ถึง {endDate.Value.ToString()}";
                    Log.Create("print", obj);
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
                rpt.ExportToHttpResponse(expType, Response, true, exportName);

            } catch (Exception ex)
            {
                ErrorHandleNotify.LineNotify(new FileInfo(this.Request.Url.LocalPath).Name.ToString(), "ExportReportTrainingProfile", ex.Message);
            }
        }
        static int SelectPersonIDForReport(string PersonCode)
        {
           try
            {
                int id = 0;
                string query = $"SELECT PersonID FROM PNT_Person WHERE PersonCode = '{PersonCode}'";
                DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["TigerDB"].ConnectionString);
                if (dt.Rows.Count > 0)
                {
                    id = int.Parse(dt.Rows[0][0].ToString());
                }
                return id;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 0;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            GetTrainingHistory(Session["roles"].ToString().ToLower());
        }
    }
}