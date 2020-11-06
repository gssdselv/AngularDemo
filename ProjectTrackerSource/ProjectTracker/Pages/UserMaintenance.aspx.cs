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
using ProjectTracker.Business;
using ProjectTracker.DAO;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using Fit.Base;
using ProjectTracker.Common;

namespace ProjectTracker.Pages
{
    public partial class UserMaintenance : BasePage
    {

        #region Fields

        private bool isResponsible;
        private string username;

        #endregion

        #region Page Events

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        #endregion

        #region GridView Events

        protected void gvUsers_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvUsers.PageIndex = gvUsers.SelectedIndex + gvUsers.PageSize * gvUsers.PageIndex;
        }

        #endregion

        #region Button Events

        /// <summary>
        /// The event fired when button is clicked.
        /// </summary>
        /// <param name="sender">The button that raises the event.</param>
        /// <param name="e">The arguments.</param>
        protected void btnFindUserInfo_Click(object sender, ImageClickEventArgs e)
        {
            // Find controls inside details view...
            TextBox txtName = dvUsers.FindControl("txtName") as TextBox;
            TextBox txtEmail = dvUsers.FindControl("txtEmail") as TextBox;
            TextBox txtUsername = dvUsers.FindControl("txtUsername") as TextBox;
            // Verify if controls exist...
            if (txtName != null && txtUsername != null && txtEmail != null)
            {
                // Find user information..
                ADUserSelect user = new ProjectTracker.Business.User().GetUser(CheckmarxHelper.EscapeLdapSearchFilter(txtUsername.Text));
                // If some information was found..
                if (user != null)
                {
                    txtName.Text = user.FullName;
                    txtEmail.Text = user.Email;
                }
            }
        }

        #endregion

        #region DetailsView Events

        /// <summary>
        /// The event fired when a item is being inserted into DetailsView.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The insert arguments.</param>
        protected void dvUsers_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            // Verify if user exists or is valid
            if (!ProjectTracker.Business.User.IsUserValid(e.Values["Username"].ToString()))
            {
                e.Cancel = true;
                MessagePanel.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "USER_INVALID").ToString());
                return;
            }
            if (ProjectTracker.Business.User.Exists(e.Values["Username"].ToString()))
            {
                e.Cancel = true;
                MessagePanel.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "USER_ALREADY_EXISTS").ToString());
                return;
            }
            // Retrieve values...
            isResponsible = (bool)e.Values["IsResponsible"];
            username = e.Values["Username"].ToString();
            // Remove unused values..
            e.Values.Remove("IsResponsible");
        }

        /// <summary>
        /// The event fired after the item is inserted.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The insert arguments.</param>
        protected void dvUsers_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                // Get controls..
                ListBox lst = dvUsers.FindControl("lstRegions") as ListBox;
                try
                {
                    SetUserResponsible();
                    SetUserRegions(lst);
                }
                finally
                {
                    username = null;
                    isResponsible = false;
                }
                MessagePanel.ShowInsertSucessMessage();
            }
        }

        /// <summary>
        /// The event fired when the DetailsView is data bounded.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The arguments.</param>
        protected void dvUsers_DataBound(object sender, EventArgs e)
        {
            if (dvUsers.CurrentMode != DetailsViewMode.Insert)
            {
                // Get controls..
                ListBox lst = dvUsers.FindControl("lstRegions") as ListBox;
                // Select control values...
                ShowUserRegions(lst);
            }
        }

        /// <summary>
        /// The event fired when the DetailsView record is being deleted.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The delete arguments.</param>
        protected void dvUsers_ItemDeleting(object sender, DetailsViewDeleteEventArgs e)
        {
            // Delete nested regions and responsible...
            UserRegionsTableAdapter taUserRegion = new UserRegionsTableAdapter();
            ResponsibleTableAdapter taResponsible = new ResponsibleTableAdapter();
            // Deleting data...
            try
            {
                taUserRegion.DeleteUserRegions(e.Keys["Username"].ToString());
                taResponsible.Delete(e.Keys["Username"].ToString());
            }
            catch
            {
                e.Cancel = true;
            }
        }

        /// <summary>
        /// The event fired when the DetailsView record is deleted.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The delete arguments.</param>
        protected void dvUsers_ItemDeleted(object sender, DetailsViewDeletedEventArgs e)
        {
            // Verify if some error has ocurred...
            if (e.Exception != null)
            {
                // Show error message..
                MessagePanel.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "RECORD_RELATION_DELETE").ToString());
                e.ExceptionHandled = true;
            }
            else
            {
                // Show success message
                MessagePanel.ShowDeleteSucessMessage();
            }
        }

        /// <summary>
        /// The event fired when the DetailsView record is being updated.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The update arguments.</param>
        protected void dvUsers_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
        {
            // Retrieve values...
            isResponsible = (bool)e.NewValues["IsResponsible"];
            username = dvUsers.DataKey.Value.ToString();
            // Remove unused values..
            e.NewValues.Remove("IsResponsible");
        }

        /// <summary>
        /// The event fired when the DetailsView record is updated.
        /// </summary>
        /// <param name="sender">The DetailsView that raises the event.</param>
        /// <param name="e">The update arguments.</param>
        protected void dvUsers_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
        {
            if (e.Exception == null)
            {
                // Get controls..
                ListBox lst = dvUsers.FindControl("lstRegions") as ListBox;
                try
                {
                    SetUserResponsible();
                    SetUserRegions(lst);
                }
                finally
                {
                    username = null;
                    isResponsible = false;
                }
                MessagePanel.ShowInsertSucessMessage();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Set the selected regions into the listbox.
        /// </summary>
        /// <param name="lst">The ListBox control to select items.</param>
        private void ShowUserRegions(ListBox lst)
        {
            if (lst != null)
            {
                // Create the table adapter...
                UserRegionsTableAdapter ta = new UserRegionsTableAdapter();
                // Load user regions...
                dtsProjectTracker.UserRegionsDataTable table = ta.GetDataByUsername(dvUsers.DataKey.Value.ToString());
                // Verify wich regions are selected..
                foreach (dtsProjectTracker.UserRegionsRow row in table.Rows)
                {
                    ListItem item = lst.Items.FindByValue(row.RegionCode.ToString());
                    // If found the item..
                    if (item != null)
                    {
                        item.Selected = true;
                    }
                }
            }
        }

        /// <summary>
        /// Set the selected regions into database.
        /// </summary>
        /// <param name="lst">The ListBox control to select items.</param>
        private void SetUserRegions(ListBox lst)
        {
            if (lst != null && username != null)
            {
                // Create the table adapter...
                UserRegionsTableAdapter ta = new UserRegionsTableAdapter();
                // Load user regions...
                dtsProjectTracker.UserRegionsDataTable table = ta.GetDataByUsername(username);
                // Verify wich regions are selected..
                foreach (ListItem li in lst.Items)
                {
                    DataRow[] rows = table.Select("RegionCode=" + li.Value);
                    // Verify if row exist and is selected..
                    if (rows.Length > 0)
                    {
                        if (!li.Selected)
                        {
                            ta.Delete(username, Convert.ToInt32(li.Value));
                        }
                    }
                    else
                    {
                        if (li.Selected)
                        {
                            ta.Insert(username, Convert.ToInt32(li.Value));
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Set the the checkbox to indicate if user is responsible.
        /// </summary>
        private void SetUserResponsible()
        {
            if (username != null)
            {
                ResponsibleTableAdapter ta = new ResponsibleTableAdapter();
                // Create the table adapter...
                object obj = ta.UserExist(username);
                // Insert or delete record...
                if (Convert.ToInt32(obj) > 0)
                {
                    ta.Update(isResponsible, username);
                }
                else
                {
                    if (isResponsible)
                    {
                        ta.Insert(username, isResponsible);
                    }
                }
            }
        }

        #endregion

    }
}
