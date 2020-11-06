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
    public partial class SavingCategoryCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvSavingCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvSavingCategory.PageIndex = gvSavingCategory.PageIndex * gvSavingCategory.PageSize + gvSavingCategory.SelectedIndex;
        }

        protected void obsSavingCategory_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            SegmentTableAdapter savingCategoryTbAdpt = new SegmentTableAdapter();
            object quantity = savingCategoryTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), "%");

            if (quantity == null || Convert.ToInt32(quantity) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }


        protected void obsSavingCategory_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowInsertSucessMessage();
            }
        }

        protected void obsSavingCategory_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
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

        protected void obsSavingCategory_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
        }

        protected void obsSavingCategory_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            SegmentTableAdapter savingCategoryTbAdpt = new SegmentTableAdapter();
            object quantity = savingCategoryTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), gvSavingCategory.SelectedDataKey[1].ToString());

            if (quantity == null || Convert.ToInt32(quantity) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }
    }
}
