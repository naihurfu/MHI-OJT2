using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;

namespace MHI_OJT2
{
    public class ErrorHandleNotify
    {
        public static string token = "AFhtMf99a4MctItES6WZZCLzuQTOEGf1IUoWl7X6qAI";

        public static void LineNotify(string pages, string function,string _message)
        {
            try
            {
                string message = System.Web.HttpUtility.UrlEncode(_message, Encoding.UTF8);
                var request = (HttpWebRequest)WebRequest.Create("https://notify-api.line.me/api/notify");
                var postData = $"message=\n page : {pages} \n function : {function} \n msg : {message}";
                var data = Encoding.UTF8.GetBytes(postData);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;
                request.Headers.Add("Authorization", "Bearer " + token);
                var stream = request.GetRequestStream();
                stream.Write(data, 0, data.Length);
                var response = (HttpWebResponse)request.GetResponse();
                var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
    }
}