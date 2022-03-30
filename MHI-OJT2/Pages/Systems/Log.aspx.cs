﻿using System;
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
            RepeatTable.DataSource = SQL.GetDataTable("SELECT * FROM VIEW_SYSTEM_LOG", WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString);
            RepeatTable.DataBind();
        }

        public void Create(string actionType, ObjectLog _ObjectLog)
        {
            int userId = int.Parse(Session["userId"].ToString());
            _ObjectLog.CREATED_BY = userId;

            if (string.IsNullOrWhiteSpace(_ObjectLog.REMARK))
            {
                _ObjectLog.REMARK = "-";
            }

            switch (actionType.ToLower())
            {
                case "add":
                    _ObjectLog.ACTION_TYPE = "เพิ่มข้อมูล";
                    _ObjectLog.OLD_VALUE = "-";

                    InsertLog(_ObjectLog);
                    break;

                case "edit":
                    _ObjectLog.ACTION_TYPE = "แก้ไขข้อมูล";

                    InsertLog(_ObjectLog);
                    break;

                case "delete":
                    _ObjectLog.ACTION_TYPE = "ลบข้อมูล";
                    _ObjectLog.OLD_VALUE = "-";

                    InsertLog(_ObjectLog);
                    break;

                case "print":
                    _ObjectLog.ACTION_TYPE = "ดาวน์โหลดรายงาน";
                    _ObjectLog.OLD_VALUE = "-";
                    _ObjectLog.NEW_VALUE = "-";
                    break;
            }
        }

        protected void InsertLog(ObjectLog _ObjectLog)
        {
            try
            {
                string query = "INSERT INTO SYSTEM_LOG ( " +
                 "[ACTION_TYPE] ," +
                 "[TITLE] ," +
                 "[OLD_VALUE] ," +
                 "[NEW_VALUE] ," +
                 "[REMARK] ," +
                 "[CREATED_BY] ) " +
                 "VALUES ( " +
                 "@ACTION_TYPE ," +
                 "@TITLE ," +
                 "@OLD_VALUE ," +
                 "@NEW_VALUE ," +
                 "@REMARK ," +
                 "@CREATED_BY )";
               
                SqlParameterCollection param = new SqlCommand().Parameters;
                param.AddWithValue("ACTION_TYPE", SqlDbType.VarChar).Value = _ObjectLog.ACTION_TYPE;
                param.AddWithValue("TITLE", SqlDbType.VarChar).Value = _ObjectLog.TITLE;
                param.AddWithValue("OLD_VALUE", SqlDbType.VarChar).Value = _ObjectLog.OLD_VALUE;
                param.AddWithValue("NEW_VALUE", SqlDbType.VarChar).Value = _ObjectLog.NEW_VALUE;
                param.AddWithValue("REMARK", SqlDbType.VarChar).Value = _ObjectLog.REMARK;
                param.AddWithValue("CREATED_BY", SqlDbType.VarChar).Value = _ObjectLog.CREATED_BY;

                SQL.ExecuteWithParams(query, WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString, param);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
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
    }
}