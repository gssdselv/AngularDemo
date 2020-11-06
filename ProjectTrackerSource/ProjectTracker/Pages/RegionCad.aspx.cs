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
using ProjectTracker.Business;
using Fit.Base;
using ProjectTracker.Common;

namespace ProjectTracker
{
    public partial class RegionCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        /*
        protected void DropDownList1_DataBound(object sender, EventArgs e)
        {
            //DropDownList drp = (DropDownList)sender;
            
            //Utility.AddEmptyItem(drp);

            if (dvRegion.CurrentMode == DetailsViewMode.Edit && gvRegions.SelectedDataKey["User"] != null)
            {
                
                ListItem item = drp.Items.FindByValue(gvRegions.SelectedDataKey["User"].ToString());
                if (item != null)
                    drp.SelectedValue = item.Value;
            }
        }
        */
         
        protected void obsRegions_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                MessagePanel1.ShowDeleteErrorMessage();
                e.ExceptionHandled = true;
            }
            else
                MessagePanel1.ShowDeleteSucessMessage();
        }

        protected void obsRegions_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                MessagePanel1.ShowInsertErrorMessage();
                e.ExceptionHandled = true;
            }
            else
                MessagePanel1.ShowInsertSucessMessage();
        }

        protected void obsRegions_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                MessagePanel1.ShowUpdateErrorMessage();
                e.ExceptionHandled = true;
            }
            else
                MessagePanel1.ShowUpdateSucessMessage();
        }

        protected void gvRegion_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvRegion.ChangeMode(DetailsViewMode.ReadOnly);
            dvRegion.PageIndex = gvRegions.SelectedIndex + gvRegions.PageIndex * gvRegions.PageSize;
        }

        protected void btnGetInfo_Click(object sender, ImageClickEventArgs e)
        {
            TextBox txtUser = dvRegion.FindControl("txtUsername") as TextBox;
            TextBox txtEmail = dvRegion.FindControl("txtEmail") as TextBox;
            // Get the user e-mail...
            if (txtUser != null && txtEmail != null)
            {
                User userInfoRetriever = new User();
                ADUserSelect userInfo = userInfoRetriever.GetUser(CheckmarxHelper.EscapeLdapSearchFilter(txtUser.Text));
                // Set the e-mail...
                txtEmail.Text = userInfo.Email;
            }
        }

        
    }
}
