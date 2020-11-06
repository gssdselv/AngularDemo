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
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using FIT.SCO.Common;

namespace ProjectTracker.Pages
{
    public partial class EmailExceptionsCad : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void dvEmailExceptions_ModeChanged(object sender, EventArgs e)
        {

        }

        protected void gvEmailExceptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvEmailExceptions.PageIndex = gvEmailExceptions.PageIndex * gvEmailExceptions.PageSize + gvEmailExceptions.SelectedIndex;
        }

        protected void ddlUsernameInsert_SelectedIndexChanged(object sender, EventArgs e)
        {
            SetEmailToLabel();
        }

        protected void ddlUsernameInsert_DataBound(object sender, EventArgs e)
        {
            DropDownList drpResponsibles = (DropDownList)sender;

            if (dvEmailExceptions.CurrentMode == DetailsViewMode.Insert ||
                dvEmailExceptions.CurrentMode == DetailsViewMode.Edit)
            {
                Utility.OrderListBox(drpResponsibles);
                Utility.AddEmptyItem(drpResponsibles);
                drpResponsibles.SelectedIndex = 0;
            }
        }

        private void SetEmailToLabel()
        {
            if (dvEmailExceptions.CurrentMode == DetailsViewMode.Insert ||
                dvEmailExceptions.CurrentMode == DetailsViewMode.Edit)
            {
                Label lblEmailValue = (Label)dvEmailExceptions.FindControl("lblEmailValue");
                DropDownList ddlUsernameInsert = (DropDownList)dvEmailExceptions.FindControl("ddlUsernameInsert");

                if (ddlUsernameInsert.SelectedIndex == 0)
                {
                    lblEmailValue.Text = string.Empty;
                }
                else
                {
                    UsersTableAdapter adapter = new UsersTableAdapter();
                    DataTable usersTable = adapter.GetDataByOption(ddlUsernameInsert.SelectedValue, 0);
                    lblEmailValue.Text = usersTable.Rows[0]["Email"].ToString();
                }
            }
        }

        protected void obsEmailExceptions_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "RECORD_RELATION_DELETE").ToString());
                e.ExceptionHandled = true;
            }
            else
            {
                MessagePanel1.ShowDeleteSucessMessage();
            }
        }

        protected void obsEmailExceptions_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowInsertSucessMessage();
            }
        }

        protected void obsEmailExceptions_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            if (e.InputParameters["Username"] == null ||
                string.IsNullOrEmpty(e.InputParameters["Username"].ToString()))
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "USER_INVALID").ToString());
                e.Cancel = true;
                return;
            }

            EmailExceptionsTableAdapter adapter = new EmailExceptionsTableAdapter();
            object quantity = adapter.GetQuantityByUserName(e.InputParameters["Username"].ToString());

            if (quantity == null || Convert.ToInt32(quantity) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_EMAIL").ToString());
                e.Cancel = true;
                return;
            }

            IDictionary paramsFromPage = e.InputParameters;
            string username = e.InputParameters[1].ToString();
            paramsFromPage.Clear();
            paramsFromPage.Add("PU_USUARIO", username);
        }

        protected void obsEmailExceptions_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
        }

        protected void obsEmailExceptions_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            EmailExceptionsTableAdapter adapter = new EmailExceptionsTableAdapter();
            object quantity = adapter.GetQuantityByUserName(e.InputParameters["Username"].ToString());

            if (quantity == null || Convert.ToInt32(quantity) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_EMAIL").ToString());
                e.Cancel = true;
                return;
            }

            IDictionary paramsFromPage = e.InputParameters;
            string username = e.InputParameters[1].ToString();
            paramsFromPage.Clear();
            paramsFromPage.Add("Original_PU_USUARIO", username);
        }

        protected void dvEmailExceptions_DataBound(object sender, EventArgs e)
        {
            SetEmailToLabel();
        }

        protected void obsEmailExceptions_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            IDictionary paramsFromPage = e.InputParameters;
            string username = e.InputParameters[1].ToString();
            paramsFromPage.Clear();
            paramsFromPage.Add("Original_PU_USUARIO", username);
        }
    }
}
