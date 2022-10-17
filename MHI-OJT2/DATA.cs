using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;

namespace MHI_OJT2
{
	public class DATA
	{
		public static string hashKey = "MHI-OJT-TRAINING";
		public static string Decrypt(string text)
		{
			byte[] data = Convert.FromBase64String(text);
			using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider())
			{
				byte[] keys = md5.ComputeHash(UTF8Encoding.UTF8.GetBytes(hashKey));
				using (TripleDESCryptoServiceProvider tripleDes = new TripleDESCryptoServiceProvider() { Key = keys, Mode = CipherMode.ECB, Padding = PaddingMode.PKCS7 })
				{
					ICryptoTransform transform = tripleDes.CreateDecryptor();
					byte[] results = transform.TransformFinalBlock(data, 0, data.Length);
					return UTF8Encoding.UTF8.GetString(results);
				}
			}
		}
		public static string Encrypt(string text)
		{
			byte[] data = UTF8Encoding.UTF8.GetBytes(text);
			using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider())
			{
				byte[] keys = md5.ComputeHash(UTF8Encoding.UTF8.GetBytes(hashKey));
				using (TripleDESCryptoServiceProvider tripleDes = new TripleDESCryptoServiceProvider() { Key = keys, Mode = CipherMode.ECB, Padding = PaddingMode.PKCS7 })
				{
					ICryptoTransform transform = tripleDes.CreateEncryptor();
					byte[] results = transform.TransformFinalBlock(data, 0, data.Length);
					return Convert.ToBase64String(results);
				}
			}
		}
		public static string DataTableToJSONWithStringBuilder(DataTable table)
		{
			var JSONString = new StringBuilder();
			if (table.Rows.Count > 0)
			{
				JSONString.Append("[");
				for (int i = 0; i < table.Rows.Count; i++)
				{
					JSONString.Append("{");
					for (int j = 0; j < table.Columns.Count; j++)
					{
						if (j < table.Columns.Count - 1)
						{
							JSONString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\",");
						}
						else if (j == table.Columns.Count - 1)
						{
							JSONString.Append("\"" + table.Columns[j].ColumnName.ToString() + "\":" + "\"" + table.Rows[i][j].ToString() + "\"");
						}
					}
					if (i == table.Rows.Count - 1)
					{
						JSONString.Append("}");
					}
					else
					{
						JSONString.Append("},");
					}
				}
				JSONString.Append("]");
			}
			return JSONString.ToString();
		}
		public static string DataTableToJSONWithJavaScriptSerializer(DataTable table)
		{
			JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
			List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
			Dictionary<string, object> childRow;
			foreach (DataRow row in table.Rows)
			{
				childRow = new Dictionary<string, object>();
				foreach (DataColumn col in table.Columns)
				{
					childRow.Add(col.ColumnName, row[col]);
				}
				parentRow.Add(childRow);
			}
			return jsSerializer.Serialize(parentRow);
		}
		public static string DataTableToJSONWithJSONNet(DataTable table)
		{
			string JSONString = string.Empty;
			JSONString = JsonConvert.SerializeObject(table);
			return JSONString;
		}
		public static DateTime DateTimeToSQL(string dateTime)
		{
			string[] split = dateTime.Split('/');
			string day = split[0];
			string month = split[1];
			int year = int.Parse(split[2]);
			if (year > 2100)
			{
				year = year - 543;
			}

			string result = $"{year}-{month}-{day}";
			DateTime dt = DateTime.ParseExact(result, "yyyy-MM-dd", CultureInfo.InvariantCulture);
			return dt;
		}
		public static string RemoveSpecialCharacters(string str, string replace = "")
		{
			return Regex.Replace(str, @"^[a-zA-Z0-9]\+(\+)+$", replace);
		}

		public static bool HasSpecialCharacters(string val)
        {
			if (Regex.IsMatch(val, @"^[a-zA-Z0-9]\+(\+)+$")) {
				return true;
			}

			return false;
		}

		public static string MakeValidFileName( string name )
		{
			string invalidChars = Regex.Escape(new string(System.IO.Path.GetInvalidFileNameChars()));
			string invalidReStr = string.Format(@"[{0}]+", invalidChars);
			string replace = Regex.Replace(name, invalidReStr, "_").Replace(";", "").Replace(",", "");
			return replace;
		}
	}
}