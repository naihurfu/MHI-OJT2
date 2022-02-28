using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Master
{
    public partial class Location : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GetLocation();
            }
        }
        void GetLocation()
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

            RepeatTable.DataSource = SQL.GetDataTable("SELECT * FROM LOCATION", MainDB);
            RepeatTable.DataBind();
        }
    }
}