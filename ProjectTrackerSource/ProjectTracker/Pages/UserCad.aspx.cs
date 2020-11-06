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
using ProjectTracker.Business;
using ProjectTracker.Common;

namespace ProjectTracker.Pages
{
    public partial class UserCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void gvUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            //Link GridView with Datails View
            dvUsers.PageIndex = gvUsers.PageSize * gvUsers.PageIndex + gvUsers.SelectedIndex;
           
        }

        

        protected void dvUsers_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            //Verify if user exists or if user is valid
            if (!ProjectTracker.Business.User.IsUserValid(e.Values["Username"].ToString()))
            {
                e.Cancel = true;
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "USER_INVALID").ToString());
            }
            else 
            if(ProjectTracker.Business.User.Exists(e.Values["Username"].ToString()))
            {
                e.Cancel = true;
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "USER_ALREADY_EXISTS").ToString());
            }

             
        }

        protected void DropDownList1_DataBound(object sender, EventArgs e)
        {
            if (((DropDownList)sender).Items.Count == 0)
                ((DropDownList)sender).Enabled = false;
            else
                ((DropDownList)sender).Enabled = true;

            Utility.AddEmptyItem((DropDownList)sender);
        }

        protected void obsCategory_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            //Verify if not happen error
            if (e.Exception == null)
            {
                MessagePanel1.ShowInsertSucessMessage();
            }
        }

        protected void obsCategory_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            //Verify if happen error
            if (e.Exception != null)
            {
                //Show message case of ther error
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "RECORD_RELATION_DELETE").ToString());
                e.ExceptionHandled = true;
            }
            else
            {
                // Show sucess message
                MessagePanel1.ShowDeleteSucessMessage();
            }
        }

        protected void obsCategory_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            //Verify if not happen error
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            //Find controls that will manipulated
            Control ctrlUsername = dvUsers.FindControl("txtUsername");
            Control ctrlName = dvUsers.FindControl("txtName");
            Control ctrlEmail = dvUsers.FindControl("txtEmail");

            if (ctrlName != null && ctrlUsername != null && ctrlEmail != null)
            {
                //Cast Control to TextBox
                TextBox txtUsername = (TextBox)ctrlUsername;
                TextBox txtName = (TextBox)ctrlName;
                TextBox txtEmail = (TextBox)ctrlEmail;

                //Get Username typed
                string username = CheckmarxHelper.EscapeLdapSearchFilter(txtUsername.Text);

                //Initialize class that find name and email by username
                ProjectTracker.Business.User users = new ProjectTracker.Business.User();
                ADUserSelect userSelect = users.GetUser(username);

                if (userSelect != null)
                {
                    //get email finded
                    string userEmail = userSelect.Email;

                    //get username finded
                    string userName = userSelect.FullName;

                    txtName.Text = userName;
                    txtEmail.Text = userEmail;
                }

            }



        }

        protected void gvUsers_Sorting(object sender, GridViewSortEventArgs e)
        {            
            //obsUsers.SortParameterName = e.SortExpression;
            //updDetailsView.Update();
        }

        

        protected void gvUsers_DataBound(object sender, EventArgs e)
        {
            #region Add Attribute at hplnkAddRegion to open a pop up

            foreach (GridViewRow gvRow in gvUsers.Rows)
            {
                string username = gvUsers.DataKeys[gvRow.RowIndex][0].ToString();

                string script = String.Format("OpenPageInsertRegion('{0}')", username);

                HyperLink hplnkAddRegion = gvRow.Cells[8].FindControl("hplnkAddRegion") as HyperLink;
                hplnkAddRegion.NavigateUrl = "#";
                hplnkAddRegion.Attributes.Add("OnClick", script);
            }

            #endregion
        }

    }
}
