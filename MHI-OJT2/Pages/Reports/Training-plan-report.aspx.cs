using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Reports
{
    public partial class Training_plan_report : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
                string role = Session["roles"].ToString().ToLower();
                if (role == "user")
                {
                    Response.Redirect("~/Pages/Error/403.aspx");
                }
            }
        }
    }
}