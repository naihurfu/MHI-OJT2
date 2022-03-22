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
            section.DataSource = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
            section.DataTextField = "SECTION_NAME";
            section.DataValueField = "SECTION_NAME";
            section.DataBind();
        }

        [WebMethod]
        public static string GetReportData(string sectionName, string startDate, string endDate)
        {
            string query = $"EXEC SKILL_MAP_FOR_ADMIN '{sectionName}'";

            if (role == "clerk")
            {
                query = $"EXEC SKILL_MAP_FOR_CLERK '{sectionName}', '{DATA.DateTimeToSQL(startDate)}', '{DATA.DateTimeToSQL(endDate)}'";
            }

            DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
            return DATA.DataTableToJSONWithJSONNet(dt);
        }
    }
}