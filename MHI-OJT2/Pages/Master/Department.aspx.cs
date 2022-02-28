using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Master
{
    public partial class Department : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
              if (!IsPostBack)
            {
                GetDepartment();
            }
        }

        void GetDepartment()
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

            RepeatDepartmentTable.DataSource = SQL.GetDataTable("SELECT dep.ID, dep.DEPARTMENT_NAME, sec.SECTION_NAME, dep.IS_ACTIVE FROM DEPARTMENT dep JOIN SECTION sec ON dep.SECTION_ID=sec.ID", MainDB);
            RepeatDepartmentTable.DataBind();
        }
    }
}