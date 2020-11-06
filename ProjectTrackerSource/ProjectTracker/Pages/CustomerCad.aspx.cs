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
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;

namespace ProjectTracker.Pages
{
    public partial class CustomerCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvCustomer_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvCustomer.PageIndex = gvCustomer.PageSize * gvCustomer.PageIndex + gvCustomer.SelectedIndex;
        }

        protected void obsCustomer_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            CustomerTableAdapter customerTbAdpt = new CustomerTableAdapter();
            object qtd = customerTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), "%");

            if (qtd == null || Convert.ToInt32(qtd) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }

        protected void obsDataSource_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowInsertSucessMessage();
            }
        }

        protected void obsDataSource_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
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

        protected void obsDataSource_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
        }

        protected void obsCustomer_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            CustomerTableAdapter customerTbAdpt = new CustomerTableAdapter();
            object qtd = customerTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), gvCustomer.SelectedDataKey[1].ToString());

            if (qtd == null || Convert.ToInt32(qtd) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }
    }
}
