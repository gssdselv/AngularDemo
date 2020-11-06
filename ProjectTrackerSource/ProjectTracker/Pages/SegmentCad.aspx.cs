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
using Fit.Base;

namespace ProjectTracker.Pages
{
    public partial class SegmentCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvCategory.PageIndex = gvCategory.PageIndex * gvCategory.PageSize + gvCategory.SelectedIndex;
        }

        protected void obsCategory_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            SegmentTableAdapter categoryTbAdpt = new SegmentTableAdapter();
            object quantity = categoryTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), "%");

            if (quantity == null || Convert.ToInt32(quantity) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }


        protected void obsCategory_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowInsertSucessMessage();
            }
        }

        protected void obsCategory_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
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

        protected void obsCategory_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
        }

        protected void obsCategory_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            SegmentTableAdapter categoryTbAdpt = new SegmentTableAdapter();
            object quantity = categoryTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), gvCategory.SelectedDataKey[1].ToString());

            if (quantity == null || Convert.ToInt32(quantity) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }
    }
}
