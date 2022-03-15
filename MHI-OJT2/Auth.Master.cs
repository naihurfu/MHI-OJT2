using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MHI_OJT2.Pages.Management;

namespace MHI_OJT2
{
    public partial class Auth : System.Web.UI.MasterPage
    {
		string _firstName = String.Empty;
		string _lastName = String.Empty;
		string _positionName = String.Empty;
		public int notificationCount = 0;
		protected void Page_Load(object sender, EventArgs e)
			{
				if (!IsPostBack)
				{
					CheckLoggedIn();
					CheckPermissionAndRedirect();
					if ((string)Session["roles"] == "user")
					{
						GetNotification();
					}
				}
			}
			void GetNotification()
			{
			DataTable dt = Approval.GetApproveList(int.Parse(Session["userId"].ToString()));
			notificationCount = dt.Rows.Count;
			
			RepeatNotification.DataSource = dt;
			RepeatNotification.DataBind();
			}
			void CheckLoggedIn()
			{
				try
				{
					_firstName = (string)Session["firstName"];
					_lastName = (string)Session["lastName"];
					_positionName = (string)Session["positionName"];

					if (String.IsNullOrEmpty(_firstName) && String.IsNullOrEmpty(_lastName) && String.IsNullOrEmpty(_positionName)) throw new Exception("Session is empty.");

					string fullName = $"{_firstName} {_lastName}";
					BindSession(fullName, _positionName);
				}
				catch (Exception ex)
				{
					Response.Redirect("~/Login.aspx");
					Console.WriteLine(ex.Message);
				}
			}
			void BindSession(string fullName, string positionName)
			{
				sessionProfileName.InnerText = fullName;
				sessionProfileName.DataBind();

			}
			protected void Logout(object sender, EventArgs e)
			{
				Session.Abandon();
				Session.RemoveAll();
				Response.Redirect("~/login.aspx");
			}
			protected void CheckPermissionAndRedirect()
			{
				string currentPath = String.Empty;
				_ = HttpContext.Current.Request.Url.AbsolutePath;
				
		}
    }
}