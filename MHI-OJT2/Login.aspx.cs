﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
        private void AssignSessionValue(DataTable userData, Boolean isUser)
        {
            HttpContext.Current.Session["loggedIn"] = true;
            HttpContext.Current.Session["userId"] = userData.Rows[0]["ID"];
            HttpContext.Current.Session["username"] = userData.Rows[0]["USERNAME"];
            HttpContext.Current.Session["firstName"] = userData.Rows[0]["FIRST_NAME"];
            HttpContext.Current.Session["lastName"] = userData.Rows[0]["LAST_NAME"];
            HttpContext.Current.Session["roles"] = userData.Rows[0]["ROLES"];

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
        static DataTable FindInTigerSoftDatabase(string username)
        {
            string TigerDB = WebConfigurationManager.ConnectionStrings["TigerDB"].ConnectionString;

            DataTable dt = new DataTable();
            SqlParameterCollection param = new SqlCommand().Parameters;
            param.AddWithValue("@username", SqlDbType.VarChar).Value = username;
            string queryString = "SELECT person.PersonID ID";
            queryString += ",person.PersonCode USERNAME";
            queryString += ",usr.Pws [password]";
            queryString += ",person.FnameT FIRST_NAME";
            queryString += ",person.LnameT LAST_NAME";
            queryString += ",'user' ROLES ";
            queryString += ",position.PositionNameT positionNameTH ";
            queryString += ",position.PositionNameE positionNameEN ";
            queryString += "FROM PNT_Person person ";
            queryString += "JOIN ADM_UserPws as usr ON person.PersonID = usr.PersonID ";
            queryString += "JOIN PNM_Position position ON person.PositionID = position.PositionID ";
            queryString += "WHERE person.PersonCode = @username ";
            // where resign and delete person
            queryString += "AND person.ResignStatus = 1 AND person.ChkDeletePerson = 1";

            dt = SQL.GetDataTableWithParams(queryString, TigerDB, param);
            return dt;
        }
        static DataTable FindInMainDatabase(string username)
        {
            string MainDB = WebConfigurationManager.ConnectionStrings["MainDB"].ConnectionString;

            DataTable dt = new DataTable();
            SqlParameterCollection param = new SqlCommand().Parameters;
            param.AddWithValue("USERNAME", SqlDbType.VarChar).Value = username;
            string queryString = "SELECT * FROM SYSTEM_USERS WHERE USERNAME=@USERNAME AND IS_ACTIVE = 1";
            dt = SQL.GetDataTableWithParams(queryString, MainDB, param);
            return dt;
        }
        private void Alert(string type, string title, string message)
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "SweetAlert", $"sweetAlert('{type}','{title}','{message}')", true);
        }
    }
}