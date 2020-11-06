using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Globalization;
using System.Threading;
using Fit.Common;
using System.Security.Principal;

namespace Fit.Base
{
    public abstract class BasePage : Page
    {
        #region Attributes
        protected MessagePanel MessagePanel1;

        #endregion

        #region Methods


        #endregion

        public BasePage()
        {
            Title = "Engineering Project Tracker - " + ConfigurationManager.AppSettings["ApplicationVersion"];
            // String com o nome do usu�rio
            string userName =  string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name;
            userName = userName.Substring(userName.IndexOf("\\") + 1);
            string selectedLanguage;

            // Caso n�o seja um usu�rio v�lido, aplicar como cultura
            // padr�o a culture do Browser

            if (!string.IsNullOrEmpty(userName))
            {
                // Search a language for UserName
                             

                MembershipUser user = Membership.GetUser(userName);
                selectedLanguage = ((BaseMembershipUser)user).Language;

                UICulture = selectedLanguage;
                Culture = selectedLanguage;

                

                Thread.CurrentThread.CurrentCulture =
                    CultureInfo.CreateSpecificCulture(selectedLanguage);
                Thread.CurrentThread.CurrentUICulture = new
                    CultureInfo(selectedLanguage);
            }           


        }
        
    }
}
