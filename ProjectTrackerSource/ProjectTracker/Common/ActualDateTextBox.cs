using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjectTracker.Common
{
    [DefaultProperty("Text")]
    [ToolboxData("<{0}:ActualDateTextBox runat=server></{0}:ActualDateTextBox>")]
    public class ActualDateTextBox : TextBox
    {
        
        public ActualDateTextBox()
        {
            base.Text = DateTime.Now.ToString().Split(' ')[0];
            ReadOnly = true;
        }

        [Bindable(true)]
        [Category("Appearance")]
        [DefaultValue("")]
        [Localizable(true)]
        public override string Text
        {
            get
            {
                String s = CheckmarxHelper.EscapeReflectedXss((String)ViewState["Text"]);
                return ((s == null) ? String.Empty : s);
            }

            set
            {
                ViewState["Text"] = value;
            }
        }

        protected override void RenderContents(HtmlTextWriter output)
        {
            output.Write(Text);
        }
    }
}
