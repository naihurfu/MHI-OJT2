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
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
                string role = Session["roles"].ToString().ToLower();
                CheckRoles(role);
                GetTrainingHistory();
            }
        }
        protected void CheckRoles(string role)
        {
            if (role != "user")
            {
                Response.Redirect(Auth._403);
            }
        }
        void GetTrainingHistory()
        {
            SqlParameterCollection param = new SqlCommand().Parameters;
            param.AddWithValue("PERSON_ID", SqlDbType.Int).Value = int.Parse(Session["userId"].ToString());
            RepeatTable.DataSource = SQL.GetDataTableWithParams("SELECT * FROM COURSE_AND_EMPLOYEE WHERE PersonID=@PERSON_ID",
                                                                WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString,
                                                                param);
        }
    }
}