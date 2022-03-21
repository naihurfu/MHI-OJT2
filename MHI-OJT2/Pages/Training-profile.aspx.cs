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
    }
}