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
    public partial class LocationCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvLocation_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvLocation.PageIndex = gvLocation.PageSize * gvLocation.PageIndex + gvLocation.SelectedIndex;
            
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

        protected void obsLocation_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            LocationTableAdapter LocationtbAdp = new LocationTableAdapter();
            object countDescriptions = LocationtbAdp.QuantityDescription(e.InputParameters["Description"].ToString(),
                gvLocation.SelectedDataKey[1].ToString());

            if (countDescriptions == null || Convert.ToInt32(countDescriptions) >= 1)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }

        protected void obsLocation_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            LocationTableAdapter LocationtbAdp = new LocationTableAdapter();
            object countDescriptions = LocationtbAdp.QuantityDescription(e.InputParameters["Description"].ToString(), "%");

            if (countDescriptions == null || Convert.ToInt32(countDescriptions)>=1)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }
    }
}
