using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Fit.Base;
using ProjectTracker.Common;

namespace ProjectTracker.Pages
{
    public partial class ErrorPage : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
                lblError.Text = CheckmarxHelper.EscapeReflectedXss(Request.QueryString["Error"].ToString());
        }
    }
}
