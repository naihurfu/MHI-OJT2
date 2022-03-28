using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
                string query = "SELECT DISTINCT SECTION_NAME,SECTION_ID FROM COURSE_AND_EMPLOYEE ";
            
                if (role == "clerk")
                {
                    query += "WHERE CREATED_ID = " + Session["userId"];
                }
            
                section.DataSource = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
                section.DataTextField = "SECTION_NAME";
                section.DataValueField = "SECTION_ID";
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
            string query = "SELECT * FROM COURSE_AND_EMPLOYEE ";

            if (role == "user")
            {
                param.AddWithValue("ID", SqlDbType.Int).Value = int.Parse(Session["userId"].ToString());
                query += "WHERE PersonID=@ID";
            }

            if (role == "clerk")
            {
                param.AddWithValue("ID", SqlDbType.Int).Value = int.Parse(Session["userId"].ToString());
                query += "WHERE CREATED_ID=@ID";
            
            }


            RepeatTable.DataSource = SQL.GetDataTableWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
            RepeatTable.DataBind();
        }
        protected void ExportReportTrainingProfile(object sender, EventArgs e)
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

            rpt.Load(filename: Server.MapPath(reportName));

            string formula = "cDate(ToText(cDate({COURSE_AND_EMPLOYEE.START_DATE}),'dd/MM/yyyy')) >= " +
            $"cDate(ToText(cDate('{startDate.Value}'),'dd/MM/yyyy')) " +
            "AND cDate(ToText(cDate({COURSE_AND_EMPLOYEE.START_DATE}),'dd/MM/yyyy')) <= " +
            $"cDate(ToText(cDate('{endDate.Value}'),'dd/MM/yyyy'))";

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
                        "{COURSE_AND_EMPLOYEE.SECTION_ID} = " + _section + " ";

                }

                // ระบุรหัสพนักงาน
                if (_employeeStartId.Length > 0 && _employeeEndId.Length > 0)
                {
                    int minId = SelectPersonIDForReport(_employeeStartId);
                    int maxId = SelectPersonIDForReport(_employeeEndId);
                    formula += " AND " +
                         "({COURSE_AND_EMPLOYEE.PersonID} >= '" + minId + "' " +
                         " AND " +
                         "{COURSE_AND_EMPLOYEE.PersonID} <= '" + maxId + "' )";
                }


                // ระบุครอส
                if (_course != 0)
                {
                    formula += " AND " +
                         "{COURSE_AND_EMPLOYEE.COURSE_ID} = " + _course + " ";
                }
            }

            rpt.RecordSelectionFormula = formula;
            rpt.SetDatabaseLogon("Project1", "Tigersoft1998$");
            rpt.ExportToHttpResponse(expType, Response, true, exportName);
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
    }
}