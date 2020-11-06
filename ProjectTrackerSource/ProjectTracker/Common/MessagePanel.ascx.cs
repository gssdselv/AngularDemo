using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Drawing;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Fit.Common
{
    public partial class MessagePanel : System.Web.UI.UserControl
    {
        // Colors of FIT Template
        private const int errorRgbColor = 0x78FF0000;
        private const int sucessRgbColor = 0x7803244F;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /// <summary>
        /// Show a personalized Error Message
        /// </summary>
        /// <param name="message">Error Message</param>
        public void ShowErrorMessage(string message)
        {
            // Set the Error Message
            lblMessage.Text = message;

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(errorRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(errorRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Show a personalized Sucess Message
        /// </summary>
        /// <param name="message">Sucess Message</param>
        public void ShowSucessMessage(string message)
        {
            // Set the Error Message
            lblMessage.Text = message;

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.Visible = true;
        }

        //
        // Deprecatted
        //
        
        /// <summary>
        /// Show a personalized Insert Sucess Message
        /// </summary>
        public void ShowInsertSucessMessage()
        {
            // Set the Error Message
            lblMessage.Text = HttpContext.GetGlobalResourceObject("Default","INSERTED_SUCESS").ToString();

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.Visible = true;
        }

        public void ShowInsertProjectSucessMessage(int projectID)
        {
            // Set the Error Message
            lblMessage.Text = "Project " + projectID.ToString() + " Inserted Successfully";

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Show a personalized Insert Sucess Message
        /// </summary>
        public void ShowInsertErrorMessage()
        {
            // Set the Error Message
            lblMessage.Text = HttpContext.GetGlobalResourceObject("Default", "INSERTED_ERROR").ToString();

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(errorRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(errorRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Show a personalized Update Sucess Message
        /// </summary>
        public void ShowUpdateSucessMessage()
        {
            // Set the Error Message
            lblMessage.Text = HttpContext.GetGlobalResourceObject("Default", "UPDATED_SUCESS").ToString();

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Show a personalized Update Error Message
        /// </summary>
        public void ShowUpdateErrorMessage()
        {
            // Set the Error Message

            lblMessage.Text = HttpContext.GetGlobalResourceObject("Default", "UPDATED_ERROR").ToString();

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(errorRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(errorRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Show a personalized Delete Sucess Message
        /// </summary>
        public void ShowDeleteSucessMessage()
        {
            // Set the Error Message
            lblMessage.Text = HttpContext.GetGlobalResourceObject("Default", "DELETED_SUCESS").ToString();

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(sucessRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Show a personalized Delete Error Message
        /// </summary>
        public void ShowDeleteErrorMessage()
        {
            // Set the Error Message
            lblMessage.Text = HttpContext.GetGlobalResourceObject("Default", "DELETED_ERROR").ToString();

            // Configure de style of text and set de panel visible
            lblMessage.ForeColor = Color.FromArgb(errorRgbColor);
            pnlMessage.BorderColor = Color.FromArgb(errorRgbColor);
            pnlMessage.Visible = true;
        }

        /// <summary>
        /// Get Message.
        /// </summary>
        public string Message
        {
            get { return lblMessage.Text; }
            set { lblMessage.Text = value; }
        }
    }
}