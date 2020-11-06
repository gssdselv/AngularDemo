using System;
using System.Web;
using System.Web.Security;
using Fit.Base;
using System.Security.Principal;
using ProjectTracker.Common;
using log4net;
using log4net.Repository.Hierarchy;

namespace ProjectTracker
{
    public partial class _Default : BasePage
    {
        private ILog _log;

        protected void Page_Load(object sender, EventArgs e)
        {
            _log = LogManager.GetLogger(typeof(Logger));
            log4net.Config.XmlConfigurator.Configure();
            //test
            // Fazer login do usuário
            //string userName = Request.ServerVariables["LOGON_USER"];
            string userName = string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name;
            userName = userName.Substring(userName.IndexOf("\\") + 1);
            _log.Info("userName:" + userName);
            // Apenas fazer login caso não haja um usuário autenticado
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                if (Membership.ValidateUser(userName, null))
                {
                    // O usuário é válido
                    FormsAuthentication.Authenticate(userName, null);
                    FormsAuthentication.RedirectFromLoginPage(userName, false);

                    if (Request.QueryString["returnUrl"] != null)
                        Response.Redirect(Request.QueryString["returnUrl"].ToString() + "?r =" + CheckmarxHelper.CryptoRandomString());
                    else
                        Response.Redirect("Pages/Snapshot.aspx?r=" + CheckmarxHelper.CryptoRandomString());
                }
                else
                {
                    // Redirecionar para página de erro
                    Response.Redirect("Pages/ErrorPage.aspx?Error=" + HttpContext.GetGlobalResourceObject("Default", "NOT_ACCESS").ToString() + "&r =" + CheckmarxHelper.CryptoRandomString());
                }
            }
            else
            {
                // Redireciona para a página de Snapshot
                Response.Redirect("Pages/Snapshot.aspx?r=" + CheckmarxHelper.CryptoRandomString());
            }
        }
    }


}
