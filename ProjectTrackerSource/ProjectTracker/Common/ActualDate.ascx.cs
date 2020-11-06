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

namespace ProjectTracker.Common
{
    public partial class ActualDate : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            TextBox1.Text = DateTime.Now.ToShortDateString();
            TextBox1.Enabled = false;
        }

        public string Text
        {
            get { return TextBox1.Text; }
            set { TextBox1.Text = value; }
        }

        public bool Enable
        {
            get { return TextBox1.Enabled; }
            set { TextBox1.Enabled = value; }
        }
    }
}