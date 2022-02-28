using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MHI_OJT2
{
    public partial class Auth : System.Web.UI.MasterPage
    {
			string _firstName = String.Empty;
			string _lastName = String.Empty;
			string _positionName = String.Empty;
			protected void Page_Load(object sender, EventArgs e)
			{
				if (!IsPostBack)
				{
					CheckLoggedIn();
				}
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
    }
}