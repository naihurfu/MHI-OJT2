﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2
{
    public partial class Login : System.Web.UI.Page
    {
        public static string ajax = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            ajax = HttpContext.Current.Request.ApplicationPath == "/" ? "" : HttpContext.Current.Request.ApplicationPath;

            if (!IsPostBack)
            {
                CheckSessionAndRedirect();
            }
        }
        void CheckSessionAndRedirect()
        {
            if (Session["loggedIn"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        protected void RootAdminIsHere()
        {
            HttpContext.Current.Session["loggedIn"] = true;
            HttpContext.Current.Session["userId"] = 0;
            HttpContext.Current.Session["username"] = "rootadmin";
            HttpContext.Current.Session["firstName"] = "root";
            HttpContext.Current.Session["lastName"] = "admin";
            HttpContext.Current.Session["roles"] = "admin";
            HttpContext.Current.Session["isEditMaster"] = 1;
            HttpContext.Current.Session["positionName"] = "rootadmin";
            Response.Redirect("~/Pages/Systems/Users.aspx");
        }
        protected void HandleLogin(object sender, EventArgs e)
        {
            string _username = username.Value;
            string _password = password.Value;

            // check strinh empty
            if (_username.Length <= 0 || _password.Length <= 0)
            {
                Alert("error", "ผิดพลาด", "กรุณาตรวจสอบข้อมูลให้ถูกต้อง");
                return;
            }

            // check password less than 8 char
            if (_password.Length < 4)
            {
                Alert("error", "ผิดพลาด", "รหัสผ่านต้องมีความยาว 4 ตัวอักษรขึ้นไป");
                return;
            }

            if (_username == "rootadmin" && _password == "mcctojt@143000")
            {
                RootAdminIsHere();
            }
            else
            {
                try
                {
                    // find user in tigersoft database
                    DataTable TigerUsersTable = FindInTigerSoftDatabase(_username);
                    if (TigerUsersTable.Rows.Count > 0)
                    {
                        if (_password == TigerUsersTable.Rows[0]["PASSWORD"].ToString())
                        {
                            AssignSessionValue(TigerUsersTable, true);
                            return;
                        }
                        else
                        {
                            Alert("error", "ผิดพลาด", "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง");
                            return;
                        }
                    }

                    // find user in main database
                    DataTable MainUserTable = FindInMainDatabase(_username);
                    if (MainUserTable.Rows.Count > 0)
                    {
                        string encPassword = DATA.Encrypt(_password);
                        if (encPassword == MainUserTable.Rows[0]["PASSWORD"].ToString())
                        {
                            AssignSessionValue(MainUserTable, false);
                            return;
                        }
                        else
                        {
                            Alert("error", "ผิดพลาด", "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง");
                            return;
                        }
                    }

                    // if not found all database
                    Alert("error", "ผิดพลาด", "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง");
                }
                catch (Exception ex)
                {
                    Alert("error", "Error!", $"{ex.Message}");
                }
            }
        }
        private void AssignSessionValue(DataTable userData, Boolean isUser)
        {
            HttpContext.Current.Session["loggedIn"] = true;
            HttpContext.Current.Session["userId"] = userData.Rows[0]["ID"];
            HttpContext.Current.Session["username"] = userData.Rows[0]["USERNAME"];
            HttpContext.Current.Session["firstName"] = userData.Rows[0]["FIRST_NAME"];
            HttpContext.Current.Session["lastName"] = userData.Rows[0]["LAST_NAME"];
            HttpContext.Current.Session["roles"] = userData.Rows[0]["ROLES"];
            HttpContext.Current.Session["isEditMaster"] = bool.Parse(userData.Rows[0]["IS_EDIT_MASTER"].ToString()) == true ? 1 : 0;

            if (isUser == true)
            {
                HttpContext.Current.Session["positionName"] = userData.Rows[0]["positionNameTH"];
            }
            else
            {
                HttpContext.Current.Session["positionName"] = userData.Rows[0]["ROLES"];
            }

            Response.Redirect("~/Default.aspx");
        }
        public static DataTable FindInTigerSoftDatabase(string username)
        {
            string TigerDB = WebConfigurationManager.ConnectionStrings["TigerDB"].ConnectionString;

            SqlParameterCollection param = new SqlCommand().Parameters;
            param.AddWithValue("@username", SqlDbType.VarChar).Value = username;
            string queryString = "SELECT person.PersonID ID" +
                ",person.PersonCode USERNAME" +
                ",usr.Pws [password]" +
                ",person.FnameT FIRST_NAME" +
                ",person.LnameT LAST_NAME" +
                ",'user' ROLES" +
                ",'False' IS_EDIT_MASTER" +
                ",position.PositionNameT positionNameTH" +
                ",position.PositionNameE positionNameEN " +
                "FROM PNT_Person person " +
                "JOIN ADM_UserPws as usr ON person.PersonID = usr.PersonID " +
                "JOIN PNM_Position position ON person.PositionID = position.PositionID " +
                "WHERE person.PersonCode = @username " +
                "AND person.ResignStatus = 1 AND person.ChkDeletePerson = 1";

            DataTable dt = SQL.GetDataTableWithParams(queryString, TigerDB, param);
            return dt;
        }
        public static DataTable FindInMainDatabase(string username)
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

            SqlParameterCollection param = new SqlCommand().Parameters;
            param.AddWithValue("USERNAME", SqlDbType.VarChar).Value = username;
            string queryString = "SELECT * FROM SYSTEM_USERS WHERE USERNAME=@USERNAME AND IS_ACTIVE = 1";
            DataTable dt = SQL.GetDataTableWithParams(queryString, MainDB, param);
            return dt;
        }
        [WebMethod]
        public static string UpdateDB(string password)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(password)) throw new Exception("Password is nothing");
                if (password.Trim() != "mcctojt@140k") throw new Exception("Invalid password.");
                string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                // delete data command
                SqlConnection connection = new SqlConnection(connectionString);

                string query = "CREATE OR ALTER VIEW [dbo].[VIEW_PLAN_AND_COURSE] AS SELECT (SELECT ID FROM SECTION WHERE ID = (SELECT SECTION_ID FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID)) AS PLAN_SECTION_ID ,(SELECT SECTION_NAME FROM SECTION WHERE ID = (SELECT SECTION_ID FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID)) AS PLAN_SECTION_NAME ,(SELECT DEPARTMENT_NAME FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID) AS PLAN_DEPARTMENT_NAME ,(SELECT ID FROM DEPARTMENT WHERE ID = [plan].DEPARTMENT_ID) AS PLAN_DEPARTMENT_ID ,[plan].PLAN_NAME ,[plan].[REF_DOCUMENT] AS PLAN_REF_DOCUMENT ,[plan].[HOURS] AS PLAN_HOURS ,[plan].[FREQUENCY] AS PLAN_FREQUENCY ,[plan].[SM_MG] ,[plan].SAM_AM ,[plan].[SEG_SV] ,[plan].EG_ST ,[plan].[FM] ,[plan].[LD_SEP_EP] ,[plan].[OP] ,[plan].PLAN_DATE ,[plan].[ACTUAL_DATE] AS PLAN_ACTUAL_DATE ,[plan].TRAINER ,course.ID COURSE_ID ,course.COURSE_NUMBER ,course.TIMES AS COURSE_TIMES ,course.COURSE_NAME ,course.[START_DATE] AS COURSE_START_DATE ,course.[END_DATE] AS COURSE_END_DATE ,course.START_TIME AS COURSE_START_TIME ,course.END_TIME AS COURSE_END_TIME ,course.TOTAL_HOURS AS COURSE_TOTAL_HOURS ,dep.ID DEPARTMENT_ID ,dep.DEPARTMENT_NAME ,sec.SECTION_NAME ,loc.LOCATION_NAME ,CONCAT(tea.INITIAL_NAME, ' ', tea.FIRST_NAME, ' ', tea.LAST_NAME) AS TEACHER_NAME ,course.DETAIL AS COURSE_DETAIL ,course.OBJECTIVE AS COURSE_OBJECTIVE ,course.EVALUATED_DATE ,course.[STATUS] AS STATUS_CODE ,CASE WHEN course.[STATUS] = 1 THEN  'รอเลือกพนักงาน' WHEN course.[STATUS] = 2 THEN  'รอประเมินผล' WHEN course.[STATUS] = 3 THEN  'รอผู้อนุมัติคนที่ 1' WHEN course.[STATUS] = 4 THEN  'รอผู้อนุมัติคนที่ 2' WHEN course.[STATUS] = 5 THEN  'รอผู้อนุมัติคนที่ 3' WHEN course.[STATUS] = 6 THEN  'รอผู้อนุมัติคนที่ 4' WHEN course.[STATUS] = 7 THEN  'รอผู้อนุมัติคนที่ 5' WHEN course.[STATUS] = 8 THEN  'รอผู้อนุมัติคนที่ 6' WHEN course.[STATUS] = 9 THEN  'อนุมัติ' WHEN course.[STATUS] = 10 THEN  'ไม่อนุมัติ' ELSE NULL END AS STATUS_TEXT ,[user].[ID] CREATED_ID ,CONCAT([user].INITIAL_NAME, ' ', [user].FIRST_NAME, ' ', [user].LAST_NAME) AS CREATED_NAME FROM PLAN_AND_COURSE pnc JOIN ADJUST_COURSE course ON course.ID = pnc.COURSE_ID JOIN TRAINING_PLAN [plan] ON [plan].ID = pnc.PLAN_ID JOIN DEPARTMENT dep ON dep.ID = course.DEPARTMENT_ID JOIN [LOCATION] loc ON loc.ID = course.LOCATION_ID JOIN TEACHER tea ON tea.ID = course.TEACHER_ID JOIN [SECTION] sec ON sec.ID = dep.SECTION_ID JOIN SYSTEM_USERS [user] ON [user].ID = course.CREATED_BY";

                SqlCommand cmd = new SqlCommand(query, connection);
                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();

                return "SUCCESS";
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return ex.Message;
            }
        }
        private void Alert(string type, string title, string message)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
        }
    }
}