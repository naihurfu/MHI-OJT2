using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2.Pages.Management
{
    public partial class Evaluation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           if (!IsPostBack)
            {
                GetCourseIdFromSession();
            }
        }
        void GetCourseIdFromSession()
        {
            try
            {
                if (Session["EVALUATE_COURSE_ID"] != null)
                {
                    int courseId = int.Parse(Session["EVALUATE_COURSE_ID"].ToString());
                    if (courseId > 0)
                    {
                        string mainDb = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                        SqlParameterCollection param = new SqlCommand().Parameters;
                        param.AddWithValue("courseId", SqlDbType.Int).Value = courseId;
                        
                        DataTable dt = SQL.GetDataTableWithParams("SELECT * FROM COURSE_AND_EMPLOYEE WHERE COURSE_ID=@courseId", mainDb, param);

                        if (dt.Rows.Count > 0)
                        {
                            string _title = $"[{dt.Rows[0]["COURSE_NUMBER"]}] - {dt.Rows[0]["COURSE_NAME"]} No.{dt.Rows[0]["TIMES"]}";
                            title.InnerText = _title;

                            RepeatCourseTable.DataSource = dt;
                            RepeatCourseTable.DataBind();

                            //Session.Remove("EVALUATE_COURSE_ID");
                        } else
                        {
                            throw new Exception("Not found employee in training course, Please choose employee into training course.");
                        }
                    };
                } else
                {
                    Response.Redirect("~/Pages/Management/Courses.aspx");
                }
            } catch(Exception ex)
            {
                Alert("error", "ERROR!", $"{ex.Message}");
            }
        }
        void Alert(string type, string title, string message)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
        }
    }
}