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
using System.Drawing;
using System.Security.Principal;

namespace ProjectTracker.Pages
{
    public partial class ViewProjects : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["Status"] !=null)
            {
                //Declare variables to filter
                string filter = "", user = "";

                //find specific item to change value this item
                ListItem item = RadioButtonList1.Items.FindByText("Your Projects");
                string[] users = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split(new string[] { "\\" }, StringSplitOptions.None);

                if (item != null)
                {
                    users = User.Identity.Name.Split(new string[] { "\\" }, StringSplitOptions.None);
                    if (user.Length > 1)
                    {
                        item.Value = users[1];
                        user = users[1];
                    }
                    else
                    {
                        item.Value = users[0];
                        user = users[0];
                    }
                }
                


                ////Verify if exists QueryString to projects
                //if (Request.QueryString["Status"] != null && Request.QueryString["Status"] == "A")
                //{
                //    user = "%";
                //    RadioButtonList1.SelectedValue = "%";
                //}
                //else
                //{
                //    RadioButtonList1.SelectedValue = user;
                //}

            //    //FillGridView
            //    FillGrid(filter, user);
            //}
            //else
            //{

            }
        }


        /// <summary>
        /// Fill GridView by filter and user
        /// </summary>
        /// <param name="filter">Filter used to fill.</param>
        /// <param name="user">User used to fill.</param>
        private void FillGrid(int filter, string user)
        {
            ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SP_FIT_PT_VIEW_PROJECTSTableAdapter tbAdpt = new ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SP_FIT_PT_VIEW_PROJECTSTableAdapter();

            ProjectTracker.DAO.dtsProjectTracker.SP_FIT_PT_VIEW_PROJECTSDataTable tb = tbAdpt.GetData(filter, user);
            gvViewProjects.DataSource = tb;
            gvViewProjects.DataBind();
            frmProjects.DataSource = tb;
            frmProjects.DataBind();
        }

        protected void gvViewProjects_SelectedIndexChanged(object sender, EventArgs e)
        {
            frmProjects.PageIndex = gvViewProjects.PageIndex * gvViewProjects.PageSize + gvViewProjects.SelectedIndex;
            //FillGrid(lstStatus.SelectedValue, RadioButtonList1.SelectedValue);
        }

        protected void gvViewProjects_PageIndexChanged(object sender, EventArgs e)
        {
            //frmProjects.PageIndex = gvViewProjects.PageIndex * gvViewProjects.PageSize;
            //FillGrid(lstStatus.SelectedValue, RadioButtonList1.SelectedValue);
            //gvViewProjects.SelectedIndex = 0;
        }


        protected void gvViewProjects_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvViewProjects.PageIndex =  e.NewPageIndex;
        }

        protected void lstStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvViewProjects.PageIndex = 0;
            //FillGrid(lstStatus.SelectedValue, RadioButtonList1.SelectedValue);
        }

        protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            sqlDSProjects.DataBind();
            gvViewProjects.DataBind();
            frmProjects.DataBind();
        }

        protected void gvProjects_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row != null && (e.Row.RowType == DataControlRowType.DataRow))
            {
                int status = Convert.ToInt32(((System.Data.DataRowView)(e.Row.DataItem)).DataView.Table.Rows[gvViewProjects.PageIndex * gvViewProjects.PageSize + e.Row.RowIndex].ItemArray[9]);


                //Verify status project
                if (status == 11)
                {
                    //TBD
                    e.Row.BackColor = Color.FromName("#CCE6FF");
                }
                else if (status == 12)
                {
                    //In-Progress
                    e.Row.BackColor = Color.FromName("#FFFFA8");
                }
                else if (status == 13)
                {
                    //OnGoing
                    e.Row.BackColor = Color.FromName("#CDFFCC");
                }
                else if (status == 14)
                {
                    //On-Hold
                    e.Row.BackColor = Color.FromName("#D9D9D9");
                }
                else if (status == 15)
                {
                    //Dropped
                    e.Row.BackColor = Color.FromName("#FFD9B3");
                }



            }
        }
               

        protected void sqlDSProjects_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            string user = "";

            //find specific item to change value this item
            ListItem item = RadioButtonList1.Items.FindByText("Your Projects");
            string[] users = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split(new string[] { "\\" }, StringSplitOptions.None);

            if (item != null)
            {
                users = User.Identity.Name.Split(new string[] { "\\" }, StringSplitOptions.None);
                if (user.Length > 1)
                {
                    item.Value = users[1];
                    user = users[1];
                }
                else
                {
                    item.Value = users[0];
                    user = users[0];
                }
            }


            if (!IsPostBack)
            {
                string optionUser = Request.QueryString["Projects"];
                if (Request.QueryString["Projects"] != null && optionUser == "P")
                {
                    user = "%";
                    RadioButtonList1.SelectedValue = "%";
                }
                else
                {
                    RadioButtonList1.SelectedValue = user;
                }

                string status = "%";
                if (Request.QueryString["Status"] != null)
                    status = Request.QueryString["Status"];
                
                
                e.Command.Parameters["@USER"].Value = user;
                e.Command.Parameters["@STATUS"].Value = status;

            }
            else
            {
                if (RadioButtonList1.SelectedValue == "%")
                    user = "%";

                e.Command.Parameters["@USER"].Value = user;

            }
                
        }

        protected void lstStatus_DataBound(object sender, EventArgs e)
        {
            //Verify if exists QueryString to status
            if (Request.QueryString["Status"] != null)
            {
                ListItem item1 = lstStatus.Items.FindByValue(Request.QueryString["Status"]);
                if (item1 != null)
                    item1.Selected = true;

            }
        }
    }
}
