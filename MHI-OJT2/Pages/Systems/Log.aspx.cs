using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace MHI_OJT2.Pages.Systems
{
    public partial class Log : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Auth.CheckLoggedIn();
            if (!IsPostBack)
            {
                string role = Session["roles"].ToString().ToLower();
                if (role != "admin")
                {
                    Response.Redirect(Auth._403);
                }
                GetAllLog();
            }
        }
        void GetAllLog()
        {
            RepeatTable.DataSource = SQL.GetDataTable("SELECT * FROM VIEW_SYSTEM_LOG ORDER BY CREATED_AT DESC", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
            RepeatTable.DataBind();
        }
        public static void Create(string actionType, ObjectLog _ObjectLog)
        {
            int userId = int.Parse(HttpContext.Current.Session["userId"].ToString());
            string role = HttpContext.Current.Session["roles"].ToString().ToLower();
            string detail = String.Empty;

            _ObjectLog.IS_USER = role == "user" ? 1 : 0;
            _ObjectLog.CREATED_BY = userId;

            if (string.IsNullOrWhiteSpace(_ObjectLog.REMARK))
            {
                _ObjectLog.REMARK = "-";
            }

            if (string.IsNullOrWhiteSpace(_ObjectLog.OLD_VALUE))
            {
                _ObjectLog.OLD_VALUE = "-";
            }

            if (string.IsNullOrWhiteSpace(_ObjectLog.NEW_VALUE))
            {
                _ObjectLog.NEW_VALUE = "-";
            }

            if (string.IsNullOrWhiteSpace(_ObjectLog.TABLE_NAME))
            {
                _ObjectLog.TABLE_NAME = "-";
                _ObjectLog.FK_ID = 0;

            }
            else
            {
                detail = GetNameOrDetail(_ObjectLog.TABLE_NAME, _ObjectLog.FK_ID);

            }

            switch (actionType.ToLower())
            {
                case "add":
                    _ObjectLog.ACTION_TYPE = "เพิ่มข้อมูล";

                    InsertLog(_ObjectLog);
                    break;

                case "edit":
                    _ObjectLog.ACTION_TYPE = "แก้ไขข้อมูล";
                    InsertLog(_ObjectLog);
                    break;

                case "delete":
                    _ObjectLog.ACTION_TYPE = "ลบข้อมูล";
                    _ObjectLog.REMARK = detail;

                    InsertLog(_ObjectLog);
                    break;

                case "print":
                    _ObjectLog.ACTION_TYPE = "พิมพ์รายงาน";
                    InsertLog(_ObjectLog);
                    break;
            }
        }

        public static void InsertLog(ObjectLog _ObjectLog)
        {
            try
            {
                string query = "INSERT INTO SYSTEM_LOG ( " +
                 "[ACTION_TYPE] ," +
                 "[TITLE] ," +
                 "[OLD_VALUE] ," +
                 "[NEW_VALUE] ," +
                 "[REMARK] ," +
                 "[CREATED_BY] ," +
                 "[IS_USER] ," +
                 "[TABLE_NAME] ," +
                 "[FK_ID]) " +
                 "VALUES ( " +
                 "@ACTION_TYPE ," +
                 "@TITLE ," +
                 "@OLD_VALUE ," +
                 "@NEW_VALUE ," +
                 "@REMARK ," +
                 "@CREATED_BY ," +
                 "@IS_USER ," +
                 "@TABLE_NAME ," +
                 "@FK_ID )";
               
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("ACTION_TYPE", SqlDbType.VarChar).Value = _ObjectLog.ACTION_TYPE;
                param.AddWithValue("TITLE", SqlDbType.VarChar).Value = _ObjectLog.TITLE;
                param.AddWithValue("OLD_VALUE", SqlDbType.VarChar).Value = _ObjectLog.OLD_VALUE;
                param.AddWithValue("NEW_VALUE", SqlDbType.VarChar).Value = _ObjectLog.NEW_VALUE;
                param.AddWithValue("REMARK", SqlDbType.VarChar).Value = _ObjectLog.REMARK;
                param.AddWithValue("CREATED_BY", SqlDbType.Int).Value = _ObjectLog.CREATED_BY;
                param.AddWithValue("IS_USER", SqlDbType.Int).Value = _ObjectLog.IS_USER;
                param.AddWithValue("TABLE_NAME", SqlDbType.Int).Value = _ObjectLog.TABLE_NAME;
                param.AddWithValue("FK_ID", SqlDbType.Int).Value = _ObjectLog.FK_ID;

                SQL.ExecuteWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
        public static string GetNameOrDetail(string tableName,int id)
        {
            try
            {
                string query = BuildQueryByTableName(tableName, id);
                DataTable dt = SQL.GetDataTable(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);

                return dt.Rows[0][0].ToString();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return "";
            }
        }
        public static string BuildQueryByTableName(string tableName, int id)
        {
            string results = String.Empty;
            switch (tableName.ToUpper())
            {
                case "ADJUST_COURSE":
                    results = $"SELECT COURSE_NAME FROM ADJUST_COURSE WHERE ID={id}";
                    break;

                case "APPROVAL":
                    results = "COURSE_NAME";
                    break;
            }
            return results;
        }
    }

    public class ObjectLog
    {   
        public string ACTION_TYPE { get; set; }
        public string TITLE { get; set; }
        public string OLD_VALUE { get; set; }
        public string NEW_VALUE { get; set; }
        public string REMARK { get; set; }
        public int CREATED_BY { get; set; }
        public int IS_USER { get; set; }
        public string TABLE_NAME { get; set; }
        public int FK_ID { get; set; }
    }
}