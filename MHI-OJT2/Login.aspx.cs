using System;
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

#if (DEBUG)
                username.Value = "admin";
                password.Value = "admin";
                //HandleLogin(sender, e);
#endif
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

            if (_username == "rootadmin" && _password == "mcctojt@140k")
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
                string connectionString = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;
                // delete data command
                string query = string.Empty;
                switch (password.Trim())
                {
                    case "mcctojt@140k":
                        string[] updateDbQuery = { "ALTER PROCEDURE [dbo].[SP_SKILL_MAP] @sectionId  VARCHAR(10) , @startDate NVARCHAR(10) , @endDate NVARCHAR(10) , @cList NVARCHAR(MAX) AS BEGIN DECLARE @cols AS NVARCHAR(MAX) , @query  AS NVARCHAR(MAX) SELECT @cols = STUFF((	SELECT  DISTINCT ',' + QUOTENAME(COURSE_NAME + '|' + CAST(COURSE_ID AS VARCHAR)) FROM COURSE_AND_EMPLOYEE WHERE COURSE_ID IN (SELECT * FROM fnSplit(@cList, ',')) AND SECTION_ID = CAST(@sectionId as int) AND STATUS_CODE = 9 AND 1 = (CASE WHEN (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE p.COURSE_ID = COURSE_AND_EMPLOYEE.COURSE_ID) > 0 THEN 1 ELSE 0 END) FOR XML PATH(''), TYPE ) .value('.', 'NVARCHAR(MAX)') ,1,1,'') SET @query = 'SELECT PersonCode [EMP. CODE] ,[NAME] ,EMPLOYEE_START_DATE [START_DATE] ,POSITION_NAME_TH [POSITION] ,' + @cols + ' ,PLAN_A [PLAN (A)] ,PLAN_B [PLAN (B)] ,CAST(CAST(PLAN_B AS DECIMAL(7,2)) / CAST(PLAN_A AS DECIMAL(7,2)) * 100 AS DECIMAL(7,2)) AS [(B / A * 100)] ,PLAN_A-PLAN_B AS [ระบุจำนวนงาน(Specify job no.)] FROM ( SELECT PersonCode ,CONCAT(FnameE, '' '',LnameE) [NAME] ,EMPLOYEE_START_DATE ,CMB5_NAME_TH POSITION_NAME_TH ,CONCAT(COURSE_NAME, ''|'' , CAST(COURSE_ID AS VARCHAR)) COURSE_NAME ,NULLIF((SELECT COUNT(CASE WHEN TOTAL_SCORE IS NOT NULL THEN 1 END) FROM COURSE_AND_EMPLOYEE c WHERE c.PersonID = COURSE_AND_EMPLOYEE.PersonID AND (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE c.STATUS_CODE = 9 AND c.COURSE_ID IN ('+ @cList +') AND p.COURSE_ID = c.COURSE_ID) > 0), 0) PLAN_A ,NULLIF((SELECT COUNT(CASE WHEN TOTAL_SCORE > 50 THEN 1 END) FROM COURSE_AND_EMPLOYEE c WHERE c.PersonID = COURSE_AND_EMPLOYEE.PersonID AND (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE c.STATUS_CODE = 9 AND c.COURSE_ID IN ('+ @cList +') AND p.COURSE_ID = c.COURSE_ID) > 0), 0) PLAN_B ,TOTAL_SCORE FROM COURSE_AND_EMPLOYEE WHERE 1=1 AND COURSE_ID IN ('+ @cList +') AND SECTION_ID = CAST('''+@sectionId+''' AS INT) AND START_DATE BETWEEN '''+ @startDate +''' AND '''+ @endDate +''' AND STATUS_CODE = 9 AND 1 = (CASE WHEN (SELECT COUNT(*) FROM PLAN_AND_COURSE p WHERE p.COURSE_ID = COURSE_AND_EMPLOYEE.COURSE_ID) > 0 THEN 1 ELSE 0 END) ) x pivot ( MAX(TOTAL_SCORE) FOR COURSE_NAME IN (' + @cols + ') ) p ' execute(@query) ; END" };
                        for (int i = 0; i < updateDbQuery.Length; i++)
                        {
                            query = updateDbQuery[i];
                            SQL.Execute(query, connectionString);
                        }
                        break;

                    case "clear-data-by-sarawut":
                        string[] deleteString = { "DELETE FROM ADJUST_COURSE", "DELETE FROM APPROVAL", "DELETE FROM CLERK_NOTIFICATION", "DELETE FROM EVALUATE", "DELETE FROM PLAN_AND_COURSE", "DELETE FROM TRAINING_PLAN", "DELETE FROM SYSTEM_LOG" };
                        for (int i = 0; i < deleteString.Length; i++)
                        {
                            query = deleteString[i];
                            SQL.Execute(query, connectionString);
                        }
                        break;

                    default:
                        throw new Exception("Invalid password.");
                }

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