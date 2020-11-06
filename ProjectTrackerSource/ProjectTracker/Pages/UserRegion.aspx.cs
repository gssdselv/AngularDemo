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
using FIT.SCO.Common;
using ProjectTracker.Common;

namespace ProjectTracker.Pages
{
    public partial class UserRegion : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {            
            if (Request.QueryString["username"] != null)
            {
                lblUsername.Text = CheckmarxHelper.EscapeReflectedXss(Request.QueryString["username"].ToString());
                lblName.Text = Business.User.Name(CheckmarxHelper.EscapeReflectedXss(lblUsername.Text));
            }
        }

        

        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            //Verify if user selected a region and username exists
            if (!String.IsNullOrEmpty(drpRegion.SelectedValue) && !String.IsNullOrEmpty(lblUsername.Text))
            {
                //Initialize a Use
                UserRegionsTableAdapter tbAdptUserRegions = new UserRegionsTableAdapter();

                string username = lblUsername.Text;
                int regionCode = Convert.ToInt32(drpRegion.SelectedValue);

                try
                {
                    //try insert a region at a region
                    tbAdptUserRegions.Insert(username, regionCode);

                    //Poulate Grid
                    obsRegionsInUser.Select();
                    gvUsersInRegion.DataBind();

                    //Remove Region of the DropDown
                    ListItem item = drpRegion.Items.FindByValue(regionCode.ToString());
                    if (item != null)
                    {
                        drpRegion.Items.Remove(item);
                    }

                    updPnlGvUserInRegions.Update();
                }
                catch (Exception ex)
                {
                    //Erro: Erro ao tentar adicionar um usuário a uma região
                }

            }

        }

        protected void gvUsersInRegion_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            obsRegions.Select();
            drpRegion.DataBind();

            updDropInsert.Update();
        }

        protected void gvUsersInRegion_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            
        }

        protected void drpRegion_DataBound(object sender, EventArgs e)
        {
            Utility.AddEmptyItem((DropDownList)sender);
        }

     
    }
}
