using System;
using System.Configuration;
using System.Collections;
using System.Data;
using System.Globalization;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Fit.SisCoM.Pages
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //// Label com o nome do usuário
            //string userName = Request.ServerVariables["LOGON_USER"];
            //userName = userName.Substring(userName.IndexOf("\\") + 1);

            //lblUserName.Text = userName.ToLower(); // Label com o nome do usuário
        }



    }
}
