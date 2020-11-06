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
using FIT.SCO.Common;
using ProjectTracker.Business;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using System.Collections.Generic;
using ProjectTracker.Common;
using System.Data.SqlClient;
using System.Security.Principal;

namespace ProjectTracker.Pages
{
    public partial class ProjectReport : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int? regionCode = null;
                int? savingCategoryCode = null;
                Project project = new Project();

                if (Request.QueryString["SavingCategoryTag"] != null)
                {
                    savingCategoryCode = project.GetSavingCategoryCodeByTag(Request.QueryString["SavingCategoryTag"].ToString());
                }
                if (Request.QueryString["RegionTag"] != null)
                {
                    regionCode = project.GetRegionCodeByTag(Request.QueryString["RegionTag"].ToString());
                }
                if (Request.QueryString["type"] != null && Request.QueryString["type"].ToString() == "ppt")
                {
                    rblReportType.SelectedValue = "4";
                }

                BindCombos(regionCode, savingCategoryCode);
            }
        }

        private void BindCombos(int? regionCode, int? savingCategoryCode)
        {
            StatusTableAdapter statusTableAdapter = new StatusTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.StatusDataTable statusTable = statusTableAdapter.GetDataByDescription("%");
            lstStatus.DataSource = statusTable;
            lstStatus.DataTextField = "PS_DESCRICAO";
            lstStatus.DataValueField = "PS_CODIGO";
            lstStatus.DataBind();
            Utility.AddEmptyItem(lstStatus, "0", "All");

            BindResponsibleListBox();

            LocationTableAdapter locationTableAdapter = new LocationTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.LocationDataTable locationTable = locationTableAdapter.GetDataByDescription("%");
            lstLocation.DataSource = locationTable;
            lstLocation.DataTextField = "Description";
            lstLocation.DataValueField = "Code";
            lstLocation.DataBind();
            Utility.AddEmptyItem(lstLocation, "0", "All");

            string[] usernames = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernames[usernames.Length - 1];
            UserRegionsTableAdapter userRegionsTableAdapter = new UserRegionsTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.UserRegionsDataTable userRegionsTable = userRegionsTableAdapter.GetDataByUsername(username);
            lstRegion.DataSource = userRegionsTable;
            lstRegion.DataTextField = "RegionDescription";
            lstRegion.DataValueField = "RegionCode";
            lstRegion.DataBind();
            Utility.AddEmptyItem(lstRegion, "0", "All");

            if (regionCode.HasValue)
                lstRegion.SelectedValue = regionCode.Value.ToString();

            CustomerTableAdapter customerTableAdapter = new CustomerTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.CustomerDataTable customerTable = customerTableAdapter.GetDataByDescription("%");
            lstCustomer.DataSource = customerTable;
            lstCustomer.DataTextField = "Description";
            lstCustomer.DataValueField = "Code";
            lstCustomer.DataBind();
            Utility.AddEmptyItem(lstCustomer, "0", "All");

            SegmentTableAdapter segmentTableAdapter = new SegmentTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.SegmentDataTable segmentTable = segmentTableAdapter.GetDataByDrop();
            ddlSegment.DataSource = segmentTable;
            ddlSegment.DataTextField = "Description";
            ddlSegment.DataValueField = "Code";
            ddlSegment.DataBind();
            Utility.AddEmptyItem(ddlSegment, "0", "All");

            SavingCategoryTableAdapter savingCategoryTableAdapter = new SavingCategoryTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.SavingCategoryDataTable savingCategoryTable = savingCategoryTableAdapter.GetData();
            lstSavingCategory.DataSource = savingCategoryTable;
            lstSavingCategory.DataTextField = "Description";
            lstSavingCategory.DataValueField = "Code";
            lstSavingCategory.DataBind();
            Utility.AddEmptyItem(lstSavingCategory, "0", "All");

            if (savingCategoryCode.HasValue)
                lstSavingCategory.SelectedValue = savingCategoryCode.Value.ToString();
        }

        private void BindResponsibleListBox()
        {
            ResponsibleTableAdapter responsibleTableAdapter = new ResponsibleTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.ResponsibleDataTable responsibleTable = responsibleTableAdapter.GetDataByUsername("%");
            
            lstResponsiblesAvailable.DataSource = responsibleTable;
            lstResponsiblesAvailable.DataTextField = "Name";
            lstResponsiblesAvailable.DataValueField = "Username";
            lstResponsiblesAvailable.DataBind();
            //ConfigureListBoxToInsert();

            DataSet ds = Group.GetGroups();
            lstGroupsAvailable.DataSource = ds;
            lstGroupsAvailable.DataTextField = "GroupName";
            lstGroupsAvailable.DataValueField = "ID";
            lstGroupsAvailable.DataBind();
        }

        //private void ConfigureListBoxToInsert()
        //{
        //    return;

        //    if (lstResponsiblesToInsert.Items.Count == 0)
        //    {
        //        if (lstResponsiblesToInsert.Items.FindByValue("%") == null)
        //            Utility.AddEmptyItem(lstResponsiblesToInsert, "%", "All");

        //        lstResponsiblesToInsert.Enabled = false;
        //        btnMoveResponsibleL.Enabled = false;
        //    }
        //    else
        //    {
        //        ListItem itemToRemove = lstResponsiblesToInsert.Items.FindByValue("%");
        //        if (itemToRemove != null)
        //            lstResponsiblesToInsert.Items.Remove(itemToRemove);

        //        lstResponsiblesToInsert.Enabled = true;
        //        btnMoveResponsibleL.Enabled = true;
        //    }
        //}

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            string status = CheckmarxHelper.EscapeReflectedXss(lstStatus.SelectedValue);
            string responsible = GetSelectedResponsibles();
            string location = CheckmarxHelper.EscapeReflectedXss(lstLocation.SelectedValue);
            string customer = CheckmarxHelper.EscapeReflectedXss(lstCustomer.SelectedValue);
            string region = CheckmarxHelper.EscapeReflectedXss(lstRegion.SelectedValue);
            string segment = CheckmarxHelper.EscapeReflectedXss(ddlSegment.SelectedValue);
            string startDate = ddcStartDate.SelectedDateText;
            string endDate = ddcEndDate.SelectedDateText;
            string savingCategory = CheckmarxHelper.EscapeReflectedXss(lstSavingCategory.SelectedValue);
            string revenueCostSaving = CheckmarxHelper.EscapeReflectedXss(drpRevenueCostSaving.SelectedValue);

            this.rvProjects.ServerUrl = ConfigurationManager.AppSettings["ServerUrl"].ToString();

            // Set the report path...
            string reportPath = "/{0}/{1}";

            // Verify what command is...
            string reportName = "ListOfProjects";
            bool isReport = true;
            switch (rblReportType.SelectedValue)
            {
                case "0":
                    reportName = "ListOfProjects";
                    break;
                case "1":
                    reportName = "ProjectsSummarizedByMonth";
                    break;
                case "2":
                    reportName = "ProjectsSummarizedByTrimester";
                    break;
                case "3":
                    reportName = "SavingCharts";
                    break;
                case "4":
                    isReport = false;
                    reportPath = "ExportToPowerPoint.aspx";
                    break;
            }

            if (isReport)
            {
                reportPath = String.Format(reportPath, ConfigurationManager.AppSettings["ReportPath"].ToString(), reportName);
                reportPath += "&";
            }
            else 
            {
                reportPath += "?";
            }
            reportPath += "{0}&{1}&{2}&{3}&{4}&{5}&{6}&{7}&{8}&{9}&{10}&{11}";

            // Treatment of Year to Query
            string actualDate = "%";

            //if (ddlYear.SelectedValue == "%")
            //    actualDate = "%";
            //else
            //    actualDate = Convert.ToDateTime("01/01/" + ddlYear.SelectedValue).ToString("yyyy-MM-dd");

            string[] usernames = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernames[usernames.Length - 1];
             
            reportPath = String.Format(reportPath, "Region=" + region,
                                                    "Customer=" + customer,
                                                    "Location=" + location,
                                                    "Responsible=" + responsible,
                                                    "Status=" + status,
                                                    "Actual_Date=" + actualDate,
                                                    "StartWeek=" + startDate,
                                                    "EndWeek=" + endDate,
                                                    "Segment=" + segment,
                                                    "UserName=" + username,
                                                    "SavingCategory=" + savingCategory,
                                                    "RevenueCostSaving=" + revenueCostSaving);
            if (isReport)
            {
                this.rvProjects.ReportPath = reportPath;

                lstCustomer.SelectedIndex = 0;
                lstLocation.SelectedIndex = 0;
                ResetResponsiblesListBox();
                lstStatus.SelectedIndex = 0;
                lstSavingCategory.SelectedIndex = 0;

                mvReports.ActiveViewIndex++;
            }
            else
            {
                ClientScript.RegisterClientScriptBlock(typeof(ProjectReport), "openPowerPointCreator", String.Format(@"window.open('{0}');", reportPath), true);
            }
        }

        private string GetSelectedResponsibles()
        {
            string result = string.Empty;

            foreach (ListItem item in lstResponsiblesToInsert.Items)
            {
                if (result.Length > 0) result += ",";
                result += CheckmarxHelper.EscapeReflectedXss(item.Value);
            }

            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
            string sGroupColumn = string.Empty;
            foreach (ListItem item in lstGroupsToInsert.Items)
            {
                //string sql = "select * from tblGroup_Rel_User where GroupID = {0} and Isnull(Deleted,'0') = '0'";
                string sql = "select * from tblGroup_Rel_User where GroupID = @GrpID and Isnull(Deleted,'0') = '0'";
                //sql = string.Format(sql, item.Value);
                SqlParameter[] parameters =
                {
                    new SqlParameter("@GrpID",item.Value)
                };
                DataSet ds = instance.Query(sql, parameters);

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    if (result.Length > 0) result += ",";
                    result += CheckmarxHelper.EscapeReflectedXss(dr["PU_USUARIO"].ToString());
                }
            }

            if (result == string.Empty) result = "%";

            return result;
        }

        private void ResetResponsiblesListBox()
        {
            lstResponsiblesAvailable.Items.Clear();
            lstResponsiblesToInsert.Items.Clear();
            BindResponsibleListBox();
        }

        protected void lnkBack_Back(object sender, EventArgs e)
        {
            mvReports.ActiveViewIndex--;
        }

        protected void btnMoveResponsibleR_Click(object sender, ImageClickEventArgs e)
        {
            if (lstResponsiblesAvailable.Items.Count == 0) return;

            MoveItem(lstResponsiblesAvailable, lstResponsiblesToInsert);

            //ConfigureListBoxToInsert();
            Utility.OrderListBox(lstResponsiblesToInsert);

            if (lstResponsiblesToInsert.Items.Count > 0)
                lstResponsiblesToInsert.SelectedIndex = 0;

            if (lstResponsiblesAvailable.Items.Count > 0)
                lstResponsiblesAvailable.SelectedIndex = 0;
        }

        protected void btnMoveResponsibleL_Click(object sender, ImageClickEventArgs e)
        {
            if (lstResponsiblesToInsert.Items.Count == 0 ||
                lstResponsiblesToInsert.SelectedItem.Value == "%") return;

            MoveItem(lstResponsiblesToInsert, lstResponsiblesAvailable);

            //ConfigureListBoxToInsert();
            Utility.OrderListBox(lstResponsiblesAvailable);

            if (lstResponsiblesToInsert.Items.Count > 0)
                lstResponsiblesToInsert.SelectedIndex = 0;

            if (lstResponsiblesAvailable.Items.Count > 0)
                lstResponsiblesAvailable.SelectedIndex = 0;
        }

        protected void btnMoveGroupR_Click(object sender, ImageClickEventArgs e)
        {
            this.MoveItem(this.lstGroupsAvailable, this.lstGroupsToInsert);
        }

        protected void btnMoveGroupL_Click(object sender, ImageClickEventArgs e)
        {
            this.MoveItem(this.lstGroupsToInsert, this.lstGroupsAvailable);
        }

        private void MoveItem(ListControl origin, ListControl target)
        {
            List<ListItem> selectedItems = new List<ListItem>();

            foreach (ListItem item in origin.Items)
            {
                if (item.Selected)
                    selectedItems.Add(new ListItem(item.Text, item.Value));
            }

            foreach (ListItem item in selectedItems)
            {
                origin.Items.Remove(item);
                target.Items.Add(item);
            }

            Utility.OrderListBox(origin);
            Utility.OrderListBox(target);
        }
    }
}
