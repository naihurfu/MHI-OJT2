using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace MHI_OJT2
{
    public class SQL
    {
        public static string user = "sa";
        public static string pass = "tiger";
        public static SqlConnection connection;

        public static DataTable GetDataTable(string queryString, string connectionString)
        {
            using (connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand(queryString, connection))
                {
                    cmd.CommandType = CommandType.Text;
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = cmd;

                    connection.Close();
                    using (DataTable dt = new DataTable())
                    {
                        da.Fill(dt);
                        return dt;
                    }
                }
            }
        }
        public static DataSet GetDataSet(string queryString, string connectionString)
        {
            using (connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand(queryString, connection))
                {
                    cmd.CommandType = CommandType.Text;
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        da.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            da.Fill(ds, "ds");
                            return ds;
                        }
                    }
                }
            }
        }
        public static DataTable GetDataTableWithParams(string queryString, string connectionString, SqlParameterCollection parameters)
        {
            using (connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand cmd = new SqlCommand(queryString, connection))
                {
                    foreach (SqlParameter param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.ParameterName, param.SqlDbType).Value = param.Value;
                    }
                    cmd.CommandType = CommandType.Text;
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        da.SelectCommand = cmd;
                        connection.Close();
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
        }
        public static int Execute(string queryString, string connectionString)
        {
            int i;
            using (connection = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(queryString, connection))
                {
                    connection.Open();
                    i = cmd.ExecuteNonQuery();
                    connection.Close();
                    return i;
                }
            }

        }
        public static int ExecuteWithParams(string queryString, string connectionString, SqlParameterCollection parameters)
        {
            int i;
            using (connection = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(queryString, connection))
                {
                    foreach (SqlParameter param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.ParameterName, param.SqlDbType).Value = param.Value;
                    }
                    connection.Open();
                    i = cmd.ExecuteNonQuery();
                    connection.Close();
                    return i;
                }
            }

        }
        public static int ExecuteAndGetInsertId(string queryString, string connectionString, SqlParameterCollection parameters)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                Int32 newID;
                using (var cmd = new SqlCommand(queryString, connection))
                {
                    foreach (SqlParameter param in parameters)
                    {
                        cmd.Parameters.AddWithValue(param.ParameterName, param.SqlDbType).Value = param.Value;
                    }
                    connection.Open();
                    newID = (Int32)cmd.ExecuteScalar();
                    connection.Close();
                    return newID;
                }
            }
        }
    }
}