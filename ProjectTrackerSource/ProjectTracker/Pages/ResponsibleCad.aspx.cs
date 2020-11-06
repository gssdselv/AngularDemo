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
using FIT.SCO.Common;
using Fit.Base;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;

namespace ProjectTracker.Pages
{
    public partial class ResponsibleCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvUsers.PageIndex = gvUsers.PageSize * gvUsers.PageIndex + gvUsers.SelectedIndex;
        }

        protected void DropDownList2_DataBound(object sender, EventArgs e)
        {
            if (((DropDownList)sender).Items.Count == 0)
                ((DropDownList)sender).Enabled = false;
            else
                ((DropDownList)sender).Enabled = true;

            Utility.AddEmptyItem((DropDownList)sender);
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
                //e.ExceptionHandled = true;
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
    }
}
