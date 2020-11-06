using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using FIT.SCO.Common;
using Fit.Base;
using Library.Email;
using ProjectTracker.Business;
using ProjectTracker.DAO;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using ProjectTracker.Common;
using System.Security.Principal;

namespace ProjectTracker.Pages
{
    public partial class ProjectCad : BasePage
    {
        private string[] toAdresses = new string[1];
        private string[] fromAdress = new string[1];
        private ADUserSelect createrName;
        private ADUserSelect responsibleName;
        private string description = "";
        private string projectID = "";
        private bool cancelSendMail = true;
        private string sort = "%";
        private string managerMail = "";
        private Project project = new Project();
        private DateTime minDate = DateTime.MinValue;
        private DateTime maxDate = DateTime.MaxValue;
        private const string SDateFormat = "MM/dd/yyyy";

        protected void Page_PreRender(object sender, EventArgs e)
        {
            //Enhancement
            if (mvViewers.ActiveViewIndex == 0)
            {
                //gvProjects.DataBind();
                gvProjects.Sort("Code", SortDirection.Descending);
                DisplayMessage(gvProjects.Rows.Count > 0);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            #region Load Culture
            
            // String com o nome do usuário
            string userName = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name);
            //string userName = "europe\\altjkais";
            string selectedLanguage;
            
            // Caso não seja um usuário válido, aplicar como cultura
            // padrão a culture do Browser
            
            if (!string.IsNullOrEmpty(userName))
            {
                // Search a language for UserName
                MembershipUser user = Membership.GetUser(userName);
                selectedLanguage = ((BaseMembershipUser)user).Language;
                
                UICulture = selectedLanguage;
                Culture = selectedLanguage;
                
                Thread.CurrentThread.CurrentCulture =
                    CultureInfo.CreateSpecificCulture(selectedLanguage);
                Thread.CurrentThread.CurrentUICulture = new
                CultureInfo(selectedLanguage);
            }
            
            #endregion Load Culture
            
            string[] userDomani = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = userDomani[userDomani.Length - 1];
            
            if (!IsPostBack)
            {
                FromYearTxt.Text = DateTime.Today.AddMonths(-3).ToString(SDateFormat);
                ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                hdfDateChanged.Value = "false";
                if (Request.QueryString["StatusCode"] != null)
                {
                    obsStatusS.Select();
                    drpStatusCodeS.DataBind();
                    drpStatusCodeS.SelectedValue = CheckmarxHelper.EscapeReflectedXss(Request.QueryString["StatusCode"].ToString());
                }
                
                if (Request.QueryString["Projects"] != null && Request.QueryString["Projects"] == "Y")
                {
                    obsResponsiblesS.Select();
                    drpResponsiblesS.DataBind();
                    string sResponsibleUser = CheckmarxHelper.EscapeReflectedXss(FindByValue(drpResponsiblesS, username));
                    if (!string.IsNullOrEmpty(sResponsibleUser))
                    {
                        drpResponsiblesS.SelectedValue = sResponsibleUser; //item.Value;
                    }
                }
                
                if (Request.QueryString["Category"] != null)
                {
                    obsCategoriesS.Select();
                    drpCategoriesS.DataBind();
                    drpCategoriesS.SelectedValue = CheckmarxHelper.EscapeReflectedXss(Request.QueryString["Category"].ToString());
                }
               
                if (Request.QueryString["SavingCategoryTag"] != null)
                {
                    int? savingCategoryCode = project.GetSavingCategoryCodeByTag(Request.QueryString["SavingCategoryTag"].ToString());
                    if (savingCategoryCode != null)
                    {
                        obsSavingCategory.Select();
                        drpSavingCategoryS.DataBind();
                        drpSavingCategoryS.SelectedValue = savingCategoryCode.Value.ToString();
                    }
                }
                if (Request.QueryString["RegionTag"] != null)
                {
                    int? regionCode = project.GetRegionCodeByTag(Request.QueryString["RegionTag"].ToString());
                    if (regionCode != null)
                    {
                        obsRegionS.Select();
                        drpRegionS.DataBind();
                        drpRegionS.SelectedValue = regionCode.Value.ToString();
                    }
                }

                //gvProjects.Sort("Code", SortDirection.Descending);
                
                hfCostSavingAlertValue.Value = ConfigurationManager.AppSettings["CostSavingAlertValue"];
                HttpContext old_Context = HttpContext.Current;
                CostSavingDataSource.ClearSession(old_Context);
            }
            
            if (FormView1.CurrentMode == FormViewMode.Edit)
            {
                if (FormView1.PageCount != 0)
                {
                    TextBox txtClosedDate = FormView1.FindControl("ddcClosedDate") as TextBox;
                    RadioButtonList rblBestPractice = FormView1.FindControl("rblBestPractice") as RadioButtonList;
                    TextBox txtBPComment = FormView1.FindControl("txtBPComment") as TextBox;
                    Control tdBPComment = FormView1.FindControl("tdBPComment");

                    if (txtClosedDate != null)
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "teste", string.Format("<script type='text/javascript'>ChangeColor('{0}');</script>", txtClosedDate.ClientID));
                    }
                    if (rblBestPractice != null && rblBestPractice.SelectedValue.Equals("Y"))
                    {
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdBPComment)).Style.Add("display", "block");
                    }
                    else
                    {
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdBPComment)).Style.Add("display", "none");
                    }
                }
            }
            
            if (!IsPostBack)
            {
                if (!object.Equals(Request.QueryString["projectID"], null))
                {
                    hdfReqProjID.Value = CheckmarxHelper.EscapeReflectedXss(Request.QueryString["projectID"].ToString());
                    txtProjectCode.Text = CheckmarxHelper.EscapeReflectedXss(Request.QueryString["projectID"].ToString());
                    Project project = new Project();
                    List<ProjectVO> projectList = null;
                    projectList = new List<ProjectVO>();
                    projectList.Add(project.GetProjectById(Convert.ToInt32(Request.QueryString["projectID"])));
                    foreach (ProjectVO projectVO in projectList)
                    {
                        hdfStatusID.Value = projectVO.StatusCode.ToString();
                        hdfRegionID.Value = projectVO.RegionCode.ToString();
                        
                        if (hdfStatusID.Value.Equals("20"))
                        {
                            FromYearTxt.Text = projectVO.CloseDate.ToString(SDateFormat);
                            ToYearTxt.Text = projectVO.CloseDate.ToString(SDateFormat);
                        }
                    }
                    obsProjects.DataBind();
                    gvProjects.DataBind();
                }
            }
            //DisplayMessage(gvProjects.Rows.Count > 0); -- commented for performance
        }
        
        private DataSet GetDS(ObjectDataSource ods)
        {
            var ds = new DataSet();
            var dv = (DataView)ods.Select();
            if (dv != null && dv.Count > 0)
            {
                var dt = dv.ToTable();
                ds.Tables.Add(dt);
            }
            return ds;
        }
        
        protected void mvViewers_ActiveViewChanged(object sender, EventArgs e)
        {
            if (FormView1.CurrentMode == FormViewMode.Edit &&
                mvViewers.ActiveViewIndex == 1)
            {
                UpdatePanel updResp = (UpdatePanel)FormView1.FindControl("updResp");
                DropDownList drpResponsibles = (DropDownList)FormView1.FindControl("drpResponsibles");
                Label lblResponsible = (Label)FormView1.FindControl("lblUsername");
                
                string owner = drpResponsibles.SelectedValue;
                string username = GetUsername().ToLower();
                bool isAdmin = Roles.IsUserInRole(username, "ADM");
                bool canChangeOwner =
                    (
                     isAdmin ||
                     username.Equals(owner));
                
                updResp.Visible = canChangeOwner;
                lblResponsible.Visible = !canChangeOwner;
                drpResponsibles.Enabled = canChangeOwner;
            }
        }
        
        private void InitProjectDetail(DataRow dr)
        {
        }
        
        protected void drpCategories_DataBound(object sender, EventArgs e)
        {
            DropDownList drpCategories = (DropDownList)sender;
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1)
            {
                Utility.AddEmptyItem(drpCategories);
                int statusCode = Convert.ToInt32(gvProjects.SelectedDataKey[6]);
                ListItem item = drpCategories.Items.FindByValue(statusCode.ToString());
                if (item != null)
                {
                    drpCategories.SelectedValue = CheckmarxHelper.EscapeReflectedXss(item.Value);
                }
                else
                {
                    drpCategories.SelectedIndex = 0;
                }
            }
            else
            {
                Utility.AddEmptyItem(drpCategories, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
            }
        }
        
        protected void gvProjects_SelectedIndexChanged(object sender, EventArgs e)
        {
            FormView1.PageIndex = gvProjects.SelectedRow.DataItemIndex;
            mvViewers.ActiveViewIndex = 1;
        }
        
        /// <summary>
        /// Adiciona um item default, verifica se o item a ser selecionado em modo update existe, se existir seleciona-o caso contrário
        /// seleciona o item default.
        /// </summary>
        /// <param name="sender">Controle a ser inserido um item default</param>
        /// <param name="e"></param>
        protected void drpCustomers_DataBound(object sender, EventArgs e)
        {
            //Add Item with empty value
            DropDownList drpCustomers = (DropDownList)sender;
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1)
            {
                Utility.AddEmptyItem(drpCustomers);
                int customerCode = Convert.ToInt32(gvProjects.SelectedDataKey[3]);
                ListItem item = drpCustomers.Items.FindByValue(customerCode.ToString());
                if (item != null)
                {
                    drpCustomers.SelectedValue = CheckmarxHelper.EscapeReflectedXss(item.Value);
                }
                else
                {
                    drpCustomers.SelectedIndex = 0;
                }
            }
            else
            {
                Utility.AddEmptyItem(drpCustomers, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
            }
        }
        
        protected void obsDataSource_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            object id = e.ReturnValue;
            string managerMail = "";
            //Notify sucess message about insert operation
            if (e.Exception == null)
            {
                CostSavingDataSource costSavingDataSource = new CostSavingDataSource();
                costSavingDataSource.PersistCostSavingList(Convert.ToInt32(id));
                
                MessagePanel1.ShowInsertSucessMessage();
                
                if (cancelSendMail == false)
                {
                    string message = String.Format(ConfigurationManager.AppSettings["MessageEmailProject"].ToString(), createrName.FullName, description, responsibleName.FullName, id.ToString());
                    
                    string subject = "New Project - Project Tracker.";
                    
                    //Get manager mail
                    managerMail = GetMailManager();
                    //string[] to = new string[] { toAdresses[0], managerMail };
                    string[] from = new string[] { fromAdress[0], managerMail };//, managerMail
                    
                    Email email = new Email();
                    //email.SendEmail(message, subject, fromAdress[0], toAdresses, fromAdress);
                    email.SendEmail(message, subject, fromAdress[0], toAdresses, from);
                }
            }
        }
        
        protected void obsDataSource_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            object id = (vwGrid.FindControl("gvProjects") as GridView).SelectedValue;
            //Notify sucess message about delete operation
            if (e.Exception != null)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "RECORD_RELATION_DELETE").ToString());
                e.ExceptionHandled = true;
            }
            else
            {
                MessagePanel1.ShowDeleteSucessMessage();
                // Send email to responsibles on project delete... MM - 05/23/2007
                    SendDeletedEmail();
                    gvProjects.Sort("Code", SortDirection.Descending);
            }
            // Remove the session created..
            Session.Remove("DeletingEmailParameters");
        }
        
        protected void obsDataSource_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            object id = (vwGrid.FindControl("gvProjects") as GridView).SelectedValue;
            
            CostSavingDataSource costSavingDataSource = new CostSavingDataSource();
            costSavingDataSource.PersistCostSavingList(Convert.ToInt32(id));
            
            //Notify sucess message about update operation
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
            
            mvViewers.ActiveViewIndex = 0;
            
            #region Add Sub-Locations related with this project
            
            ProjectLocationTableAdapter tbAdptProjectLocation = new ProjectLocationTableAdapter();
            
            int projectCode = Convert.ToInt32(gvProjects.SelectedDataKey[0]);
            ArrayList arrSubLocations = Session["SubLocations"] as ArrayList;
            
            for (int i = 0; i < arrSubLocations.Count; i++)
            {
                int locationCode = Convert.ToInt32(arrSubLocations[i]);
                tbAdptProjectLocation.Insert(projectCode, locationCode);
            }
            Session.Remove("SubLocations");
            
            #endregion Add Sub-Locations related with this project
        }
        
        protected void obsProjects_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            ProjectsTableAdapter projectsTbAdpt = new ProjectsTableAdapter();
            object qtd = projectsTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(),
                "%");
            
            //Verify if alredy exists description cadastred
            if (qtd == null || Convert.ToInt32(qtd) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
            cancelSendMail = false;
            //Split Identity Name to get username
            string username = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name);
            if (username.Split('\\').Length > 1)
            {
                username = username.Split('\\')[username.Split('\\').Length - 1];
            }

            e.InputParameters["Creater"] = username;
            
            //Capture responsible username to send email
            ProjectTracker.Business.User u = new ProjectTracker.Business.User();
            ADUserSelect userADFrom = u.GetUser(username);
            createrName = userADFrom;
            
            if (ConfigurationManager.AppSettings["DefaultEmail"] != null && ConfigurationManager.AppSettings["DefaultEmail"] != "")
            {
                fromAdress[0] = ConfigurationManager.AppSettings["DefaultEmail"].ToString();
            }
            else
            {
                if (userADFrom != null)
                {
                    fromAdress[0] = userADFrom.Email;
                }
                else
                {
                    cancelSendMail = true;
                    return;
                }
            }
            
            //Capture project tracker creater to send email
            string toUsername = e.InputParameters["Username"].ToString();
            
            ADUserSelect userADTo = u.GetUser(toUsername);
            responsibleName = userADTo;
            if (userADTo == null)
            {
                cancelSendMail = true;
                return;
            }
            toAdresses[0] = userADTo.Email;
            
            //Capture Description project
            description = e.InputParameters["Description"].ToString();
        }
        
        protected void obsProjects_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            //Verify if already had this description cadastred
            ProjectsTableAdapter projectsTbAdpt = new ProjectsTableAdapter();
            object qtd = projectsTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(),
                gvProjects.SelectedDataKey[5].ToString());
            
            if (qtd == null || Convert.ToInt32(qtd) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }

            ListBox lstCoResps = (ListBox)FormView1.FindControl("lstCoRespsToInsert");

            SaveCoResponsibles(lstCoResps, Convert.ToInt32(gvProjects.SelectedDataKey[0]));
            
            string username = ((DropDownList)FormView1.FindControl("drpResponsibles")).SelectedValue;
            e.InputParameters["Username"] = username;
            string customer = ((DropDownList)FormView1.FindControl("drpCustomers")).SelectedValue;
            e.InputParameters["CustomerCode"] = customer;
            string status = ((DropDownList)FormView1.FindControl("drpStatusCode")).SelectedValue;
            e.InputParameters["StatusCode"] = status;
            string location = ((DropDownList)FormView1.FindControl("drpLocations")).SelectedValue;
            e.InputParameters["LocationCode"] = location;
            string category = ((DropDownList)FormView1.FindControl("drpCategories")).SelectedValue;
            e.InputParameters["CategoryCode"] = category;
            string region = ((DropDownList)FormView1.FindControl("drpRegion")).SelectedValue;
            e.InputParameters["RegionCode"] = region;
            string segment = ((DropDownList)FormView1.FindControl("drpSegment")).SelectedValue;
            e.InputParameters["SegmentCode"] = segment;
            

            // Retrieve values...
            //DropDownCalendar cld = FormView1.FindControl("ddcCommitDate") as DropDownCalendar;
            TextBox cld = FormView1.FindControl("ddcCommitDate") as TextBox;
            if (cld != null && !String.IsNullOrEmpty(cld.Text))
            {
                e.InputParameters["CommitDate"] = cld.Text;
            }
        }
        
        protected void gvProjects_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row != null && (e.Row.RowType == DataControlRowType.DataRow))
            {
                /*string statusCode = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "StatusCode"));
                if (!String.IsNullOrEmpty(statusCode))
                {*/
                int status = Convert.ToInt32(((System.Data.DataRowView)(e.Row.DataItem)).DataView.Table.Rows[gvProjects.PageIndex * gvProjects.PageSize + e.Row.RowIndex].ItemArray[9]);
                //int status = Convert.ToInt32(statusCode);
                
                //Verify status project
                if (status == 22)
                {
                    //TBD
                    //e.Row.BackColor = Color.FromName("#CCE6FF");
                    e.Row.BackColor = Color.FromName("#B3E1C2");
                }
                else if (status == 21)
                {
                    //In-Progress
                    //e.Row.BackColor = Color.FromName("#FFFFA8");
                    e.Row.BackColor = Color.FromName("#E3E3B5");
                }
                else if (status == 23)
                {
                    //On-Hold
                    //e.Row.BackColor = Color.FromName("#D9D9D9");
                    e.Row.BackColor = Color.FromName("#FFE788");
                }
                else if (status == 20)
                {
                    //Dropped
                    //e.Row.BackColor = Color.FromName("#FFD9B3");
                    e.Row.BackColor = Color.FromName("#B3C2F0");
                }
                //}

                string lblDescription = CheckmarxHelper.EscapeReflectedXss(e.Row.Cells[2].Text);
                
                if (lblDescription.Length >= 60)
                {
                    lblDescription = string.Format("{0}...", lblDescription.Substring(0, 60));
                }
                
                // Adicionada esta linha para voltar a exibir 3 pontinhos no final
                // da descrição - Elton Souza 05/18/2007
                e.Row.Cells[2].Text = lblDescription;
                
                if (e.Row.FindControl("aURL") != null)
                {
                    //string eRoom = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "eRoom"));
                    if ((((System.Data.DataRowView)(e.Row.DataItem)).DataView.Table.Rows[gvProjects.PageIndex * gvProjects.PageSize + e.Row.RowIndex]["eRoom"] != null) &&
                        (!string.IsNullOrEmpty(((System.Data.DataRowView)(e.Row.DataItem)).DataView.Table.Rows[gvProjects.PageIndex * gvProjects.PageSize + e.Row.RowIndex]["eRoom"].ToString())) &&
                        (IsValidUrl(((System.Data.DataRowView)(e.Row.DataItem)).DataView.Table.Rows[gvProjects.PageIndex * gvProjects.PageSize + e.Row.RowIndex]["eRoom"].ToString())))
                    //if(!String.IsNullOrEmpty(eRoom) && IsValidUrl(eRoom))
                    {
                        ((HtmlAnchor)e.Row.FindControl("aURL")).HRef = ((System.Data.DataRowView)(e.Row.DataItem)).DataView.Table.Rows[gvProjects.PageIndex * gvProjects.PageSize + e.Row.RowIndex]["eRoom"].ToString();
                        //((HtmlAnchor)e.Row.FindControl("aURL")).HRef = eRoom;
                        ((HtmlAnchor)e.Row.FindControl("aURL")).Visible = true;
                    }
                    else
                    {
                        ((HtmlAnchor)e.Row.FindControl("aURL")).HRef = string.Empty;
                        ((HtmlAnchor)e.Row.FindControl("aURL")).Visible = false;
                    }
                }
                
                if (!object.Equals(Request.QueryString["projectID"], null))
                {
                    if (gvProjects.DataKeys[e.Row.RowIndex]["Code"].ToString() == Request.QueryString["projectID"].ToString())
                    {
                        ImageButton btn = e.Row.FindControl("btnEditProject") as ImageButton;
                        hdfEditBtnID.Value = btn.ClientID;
                    }
                }
                
                Label lblEngReportLink = e.Row.FindControl("lblEngReportLink") as Label;
                Label lblIP = e.Row.FindControl("lblIP") as Label;


                DataSet ds = GetProjectByID(Convert.ToInt32(gvProjects.DataKeys[e.Row.RowIndex]["Code"]));
                 
                 
                //string sql = string.Format("select top 1 * from TB_PT_PJ_PROJECTS where PJ_CODIGO = {0}", gvProjects.DataKeys[e.Row.RowIndex]["Code"].ToString());
                
                //DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
                //DataSet ds = instance.Query(sql, null);

                string ip = string.Empty;
                
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    lblEngReportLink.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_ENG_LINK"].ToString());
                    
                    int engIP = System.Convert.ToInt32(dr["PJ_ENG_IP"].ToString());
                    if (engIP == 1)
                    {
                        ip = "Yes";
                    }
                    if (engIP == 0)
                    {
                        ip = "No";
                    }
                }
                
                lblIP.Text = string.Format("Can a patent or IP(Intellectual Property) be generated from this project? {0}", ip);
            }
        }
  
        private DataSet GetProjectByID(int projectID)
        {
                SqlParameter[] parameters =
                    {
                        new SqlParameter("@ProjectCode", SqlDbType.Int) { Value = projectID },
                    };
                 SQLDBHelper dbHelp = new SQLDBHelper();                
                return  dbHelp.QueryBySP("GetProjectByID", parameters);
        }
        
        private void SetBtnID()
        {
            gvProjects.DataBind();
            foreach (GridViewRow row in gvProjects.Rows)
            {
                string projectID = Request.QueryString["projectID"].ToString();
                if (gvProjects.DataKeys[row.RowIndex][0].ToString() == projectID)
                {
                    ImageButton btn = row.FindControl("btnEditProject") as ImageButton;
                    hdfEditBtnID.Value = btn.ClientID;
                }
            }
        }
        
        protected void drpStatus_DataBound(object sender, EventArgs e)
        {
            //Add Item with empty value
            DropDownList drpStatus = (DropDownList)sender;
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1)
            {
                Utility.AddEmptyItem(drpStatus);

                int statusCode = Convert.ToInt32(gvProjects.SelectedDataKey[1]);
                
                ListItem item = drpStatus.Items.FindByValue(statusCode.ToString());
                if (item != null)
                {
                    drpStatus.SelectedValue = CheckmarxHelper.EscapeReflectedXss(item.Value);
                }
                else
                {
                    drpStatus.SelectedIndex = 0;
                }
                drpStatusCode_SelectedIndexChanged(sender, e);
            }
            else
            {
                Utility.AddEmptyItem(drpStatus);
            }
        }
        
        protected void drpLocation_DataBound(object sender, EventArgs e)
        {
            //Add Item with empty value
            DropDownList drpLocations = (DropDownList)sender;
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1)
            {
                Utility.AddEmptyItem(drpLocations);

                int locationCode = Convert.ToInt32(gvProjects.SelectedDataKey[4]);
                
                ListItem item = drpLocations.Items.FindByValue(locationCode.ToString());
                if (item != null)
                {
                    drpLocations.SelectedValue = CheckmarxHelper.EscapeReflectedXss(item.Value);
                }
                else
                {
                    drpLocations.SelectedIndex = 0;
                }
            }
            else
            {
                Utility.AddEmptyItem(drpLocations, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
            }
        }
        
        protected void drpResponsibles_DataBound(object sender, EventArgs e)
        {
            if (gvProjects.Visible == false && mvViewers.ActiveViewIndex == 0)
            { 
                drpStatusCodeS.SelectedIndex = 0;
                gvProjects.Visible = true;
            }
            
            //Add Item with empty value
            DropDownList drpResponsibles = (DropDownList)sender;
            
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1)
            {
                Utility.AddEmptyItem(drpResponsibles);

                string responsibleCode = gvProjects.SelectedDataKey[2].ToString().ToLower();

                #region Disable Co-Responsible equal that Responsible of this project
                
                ListBox list = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");               
                ListItem item = FindByValue(list, responsibleCode);
                if (item != null)
                {
                    item.Enabled = false;
                }

                #endregion Disable Co-Responsible equal that Responsible of this project
                
                string sResponsibleUser = CheckmarxHelper.EscapeReflectedXss(FindByValue(drpResponsibles, responsibleCode));
                if (!string.IsNullOrEmpty(sResponsibleUser))
                {
                    drpResponsibles.SelectedValue = sResponsibleUser;
                }                
                else
                {
                    ProjectTracker.DAO.dtsProjectTracker.ResponsibleDataTable tb = new ProjectTracker.DAO.dtsProjectTracker.ResponsibleDataTable();
                    
                    ResponsibleTableAdapter tbAdpt = new ResponsibleTableAdapter();
                    tbAdpt.FillByUsername2(tb, responsibleCode);
                    
                    if (tb.Rows.Count > 0)
                    {
                        if (CanSelectResponsible())
                        {
                            ListItem itemToAdd =
                                new ListItem(
                                    tb.Rows[0]["Name"].ToString(),
                                    tb.Rows[0]["Username"].ToString().ToLower());
                            drpResponsibles.Items.Add(itemToAdd);
                            Utility.OrderListBox(drpResponsibles);
                            drpResponsibles.SelectedValue = responsibleCode;
                        }
                    }
                }
            }
            else
            {
                Utility.AddEmptyItem(drpResponsibles, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
            }
        }
        
        private bool CanSelectResponsible()
        {
            return true;
        }
        
        protected void obsProjects_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            string[] usernames = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernames[usernames.Length - 1];
            e.InputParameters["UserViewrs"] = username;           
            e.InputParameters["IsGuestUser"] = (User.IsInRole("GUEST"));           
            e.InputParameters["CurrentPage"] = !string.IsNullOrEmpty(hdfCurrentPage.Value) ? Convert.ToInt32(hdfCurrentPage.Value) : 1;
            if (ViewState["SortData"] != null)
            {
                e.InputParameters["sort"] = ViewState["SortData"].ToString();
            }
            if (!string.IsNullOrEmpty(FromYearTxt.Text))
            {
                e.InputParameters["StartDate"] = FromYearTxt.Text;
                e.InputParameters["EndDate"] = ToYearTxt.Text;
            }            
            if (!string.IsNullOrEmpty(hdfReqProjID.Value)) // this is check if ProjectID is passed from email link.
            {
                e.InputParameters["StatusCode"] = hdfStatusID.Value;
                e.InputParameters["RegionCode"] = hdfRegionID.Value;
            }
        }

        protected void obsProjects_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        { 
            ICollection valueCollection = e.OutputParameters.Values;
            int[] returnOutputValue = new int[1];
            valueCollection.CopyTo(returnOutputValue, 0);
            int totalRowCount = Convert.ToInt32(returnOutputValue[0]);
            int currentPageVal = !string.IsNullOrEmpty(hdfCurrentPage.Value) ? Convert.ToInt32(hdfCurrentPage.Value) : 1;
            GeneratePager(totalRowCount, Convert.ToInt32(ConfigurationManager.AppSettings["PageViewCount"]), currentPageVal);
        }

        private void bindGrid(int currentpage)
        { 
            hdfCurrentPage.Value = currentpage.ToString();
            gvProjects.Sort("Code", SortDirection.Descending);
        }

        protected void dlPager_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "PageNo")
            {
                bindGrid(Convert.ToInt32(e.CommandArgument));
            }
        }

        public void GeneratePager(int totalRowCount, int pageSize, int currentPage)
        {
            int totalLinkInPage = 5;
            int totalPageCount = (int)Math.Ceiling((decimal)totalRowCount / pageSize);

            int startPageLink = Math.Max(currentPage - (int)Math.Floor((decimal)totalLinkInPage / 2), 1);
            int lastPageLink = Math.Min(startPageLink + totalLinkInPage - 1, totalPageCount);

            if ((startPageLink + totalLinkInPage - 1) > totalPageCount)
            {
                lastPageLink = Math.Min(currentPage + (int)Math.Floor((decimal)totalLinkInPage / 2), totalPageCount);
                startPageLink = Math.Max(lastPageLink - totalLinkInPage + 1, 1);
            }

            List<ListItem> pageLinkContainer = new List<ListItem>();

            if (startPageLink != 1)
                pageLinkContainer.Add(new ListItem("First", "1", currentPage != 1));
            for (int i = startPageLink; i <= lastPageLink; i++)
            {
                pageLinkContainer.Add(new ListItem(i.ToString(), i.ToString(), currentPage != i));
            }
            if (lastPageLink != totalPageCount)
                pageLinkContainer.Add(new ListItem("Last", totalPageCount.ToString(), currentPage != totalPageCount));

            dlPager.DataSource = pageLinkContainer;
            dlPager.DataBind();
        }
        
        protected void imgPrevious_Click(object sender, ImageClickEventArgs e)
        {
            mvViewers.ActiveViewIndex = 0;
        }
        
        protected void dropFilter(object sender, EventArgs e)
        {
            if (((System.Web.UI.WebControls.DataBoundControl)((DropDownList)sender)).DataSourceID.Equals("obsStatusS"))
            {
                if (string.IsNullOrEmpty(hdfReqProjID.Value))
                {
                    drpStatusCodeS.SelectedValue = "21"; // Open status by Default
                }
                else
                {
                    drpStatusCodeS.SelectedValue = CheckmarxHelper.EscapeReflectedXss(hdfStatusID.Value); // Status of the Project Code(Clicked from Mail)
                }
            }
            else if (((System.Web.UI.WebControls.DataBoundControl)((DropDownList)sender)).DataSourceID.Equals("obsRegionS"))
            {
                if (string.IsNullOrEmpty(hdfReqProjID.Value))
                {
                    drpRegionS.SelectedValue = GetUserDefaultRegion(); //User Default Region
                }
                else if (!string.IsNullOrEmpty(hdfReqProjID.Value))
                {
                    drpRegionS.SelectedValue = CheckmarxHelper.EscapeReflectedXss(hdfRegionID.Value); //Region of the Project Code(Clicked from Mail)
                }
                else
                {
                    Utility.AddEmptyItem(drpRegionS, "", HttpContext.GetGlobalResourceObject("Default", "No Region").ToString());
                }
            }
            else if (((System.Web.UI.WebControls.DataBoundControl)((DropDownList)sender)).DataSourceID.Equals("obsPeriodS"))
            {
                if (string.IsNullOrEmpty(hdfReqProjID.Value))
                {
                    ddlPeriod.SelectedValue = "1"; // Default Period - Last Quarter
                }
                else
                {
                    ddlPeriod.SelectedValue = "4"; // Period Custom - clicked from email
                }
            }
            else
            {
                Utility.AddEmptyItem((DropDownList)sender, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
            }
            
            DisplayMessage(gvProjects.Rows.Count > 0);
        }
        
        private string GetUserDefaultRegion()
        {
            string[] userDomani = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = userDomani[userDomani.Length - 1];
            string sResponsibleUser = (!string.IsNullOrEmpty(drpResponsiblesS.SelectedValue)) ? CheckmarxHelper.EscapeReflectedXss(FindByValue(drpResponsiblesS, username)) : username;    //! string.IsNullOrEmpty(FindByValue(drpResponsiblesS, username)) ? ;
            string sRegionCode;
            string sql = "SELECT PRE_CODIGO FROM TB_PT_PUR_USERS_REGIONS WHERE PU_USUARIO = @ResponsibleUser";
            //string sql = string.Format("SELECT PRE_CODIGO FROM TB_PT_PUR_USERS_REGIONS WHERE PU_USUARIO = '{0}'", sResponsibleColumn);
            SQLDBHelper instance = new DAO.SQLDBHelper();
            SqlParameter[] parameter =
            {
                new SqlParameter ("@ResponsibleUser",sResponsibleUser)
            };
            DataSet ds = instance.Query(sql, parameter);
            if (ds.Tables[0].Rows.Count > 0)
            {
                sRegionCode = ds.Tables[0].Rows[0][0].ToString();
            }
            else
            {
                sRegionCode = string.Empty;
            }
            return sRegionCode;
        }
        
        private string FindByValue(DropDownList ddl, string value)
        {
            foreach (ListItem item in ddl.Items)
            {
                if (string.Compare(value, item.Value, true) == 0)
                {
                    return item.Value;
                }
            }
            return string.Empty;
        }
        
        private ListItem FindByValue(ListBox lbUser, string value)
        {
            foreach (ListItem item in lbUser.Items)
            {
                if (string.Compare(value, item.Value, true) == 0)
                {
                    return item;
                }
            }
            return null;
        }
        
        protected void btnMoveCoRespR_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoResponsibleAvaiable = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListBox lstCoResponsibleToInsert = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            
            ListItem itemToTransf = new ListItem(lstCoResponsibleAvaiable.SelectedItem.Text, lstCoResponsibleAvaiable.SelectedItem.Value);
            lstCoResponsibleAvaiable.Items.Remove(lstCoResponsibleAvaiable.SelectedItem);
            lstCoResponsibleToInsert.Items.Add(itemToTransf);

            Utility.OrderListBox(lstCoResponsibleToInsert);
            
            if (lstCoResponsibleToInsert.Items.Count > 0)
            {
                lstCoResponsibleToInsert.SelectedIndex = 0;
            }
            
            if (lstCoResponsibleAvaiable.Items.Count > 0)
            {
                lstCoResponsibleAvaiable.SelectedIndex = 0;
            }
        }
        
        protected void btnMoveCoRespL_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoResponsibleAvaiable = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListBox lstCoResponsibleToInsert = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            DropDownList drpResponsible = (DropDownList)FormView1.FindControl("drpResponsibles");
            UpdatePanel updDropResponsible = FormView1.FindControl("updResp") as UpdatePanel;

            ListItem itemToTransf = new ListItem(lstCoResponsibleToInsert.SelectedItem.Text, lstCoResponsibleToInsert.SelectedItem.Value);
            
            lstCoResponsibleToInsert.Items.Remove(lstCoResponsibleToInsert.SelectedItem);
            lstCoResponsibleAvaiable.Items.Add(itemToTransf);
            
            if (drpResponsible.SelectedItem != null)
            {
                Utility.OrderListBox(lstCoResponsibleAvaiable, drpResponsible.SelectedValue);
            }
            else
            {
                Utility.OrderListBox(lstCoResponsibleAvaiable);
            }
            
            if (lstCoResponsibleToInsert.Items.Count > 0)
            {
                lstCoResponsibleToInsert.SelectedIndex = 0;
            }
            
            if (lstCoResponsibleAvaiable.Items.Count > 0)
            {
                lstCoResponsibleAvaiable.SelectedIndex = 0;
            }
            
            updDropResponsible.Update();
        }
        
        protected void drpStatusCode_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpStatus = (DropDownList)sender;
            DropDownList drpStatusCode = (DropDownList)FormView1.FindControl("drpStatusCode");
            DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
            RegularExpressionValidator revInvalidClosedProgressValue = (RegularExpressionValidator)FormView1.FindControl("revInvalidClosedProgressValue");
            RegularExpressionValidator revInvalidNotClosedProgressValue = (RegularExpressionValidator)FormView1.FindControl("revInvalidNotClosedProgressValue");
            
            if (drpStatusCode.SelectedItem.Text == "Closed")
            {
                revInvalidClosedProgressValue.Enabled = true;
                revInvalidNotClosedProgressValue.Enabled = false;
            }
            else
            {
                revInvalidClosedProgressValue.Enabled = false;
                revInvalidNotClosedProgressValue.Enabled = true;
            }
            
            if (drpStatus.SelectedItem != null)
            {
                hdfStatus.Value = CheckmarxHelper.EscapeReflectedXss(drpStatus.SelectedValue);
                TextBox txtPercentCompletion = FormView1.FindControl("txtPercentCompletion") as TextBox;
                txtPercentCompletion.Text = drpStatus.SelectedValue == "20" ? "100" : string.Empty; // 20 - closed status
                int nDefineStageIndex = drpAutoStage.Items.IndexOf(drpAutoStage.Items.FindByValue("Develop"));
                drpAutoStage.Items[nDefineStageIndex].Enabled = !drpStatus.SelectedValue.Equals("20");
                if (drpStatus.SelectedValue.Equals("20"))
                {
                    int nDeployStageIndex = drpAutoStage.Items.IndexOf(drpAutoStage.Items.FindByValue("Deploy"));
                    drpAutoStage.SelectedValue =  drpAutoStage.Items[nDeployStageIndex].Value;
                }
            }
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
            int posCat = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
            if (posCat > -1)
            {
                Panel pnlHoldReason = FormView1.FindControl("pnlHoldReason") as Panel;
                pnlHoldReason.Visible = (drpStatus.SelectedValue.Equals("22") || drpStatus.SelectedValue.Equals("23"));
                if (!pnlHoldReason.Visible)
                {
                    Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
                    TextBox txtHoldReason = tbodyAutomation.FindControl("txtHoldReason") as TextBox;
                    hdfHoldReason.Value = txtHoldReason.Text = string.Empty;
                }
                drpAutoStage_SelectedIndexChanged(drpAutoStage, null);
            }

            #region Get at Web.Config the status codes permitted when the project is closed
            Control tbodyBestPractice = FormView1.FindControl("tbodyBestPractice");
            RadioButtonList rblBestPractice = FormView1.FindControl("rblBestPractice") as RadioButtonList;
            TextBox txtBPComment = FormView1.FindControl("txtBPComment") as TextBox;
            Control tdBPComment = FormView1.FindControl("tdBPComment");
            TextBox txtCloseDate = FormView1.FindControl("ddcClosedDate") as TextBox;
            rblBestPractice.ClearSelection();
            txtBPComment.Text = string.Empty;
            string[] codeStatusWhenPjClosed = ConfigurationManager.AppSettings["StatusAfterClosed"].Split(',');
            int pos = Array.IndexOf(codeStatusWhenPjClosed, drpStatus.SelectedValue);
            if (pos > -1)
            {
                txtCloseDate.Enabled = true;
                Label lblClosedDateRequired = FormView1.FindControl("lblCloseDateRequired") as Label;
                Label lblEngRepNumRequired = FormView1.FindControl("lblEngRepNumRequired") as Label;
                Label lblrfvEngReportLink = FormView1.FindControl("lblrfvEngReportLink") as Label;
                Label lblrfvIP = FormView1.FindControl("lblrfvIP") as Label;
                Label lblRfvOnePageLink = FormView1.FindControl("lblRfvOnePageLink") as Label;
                Label lblRfvRoiLink = FormView1.FindControl("lblRfvROILink") as Label;
                Label lblrfvVideoLnk = FormView1.FindControl("lblrfvVideoLnk") as Label;
                Label lblrfvBestPractice = FormView1.FindControl("lblrfvBestPractice") as Label;

                lblClosedDateRequired.Text = "*";
                lblEngRepNumRequired.Text = "*";
                lblrfvEngReportLink.Text = "*";
                lblrfvIP.Text = "*";                
                lblRfvOnePageLink.Text = "*";
                lblRfvRoiLink.Text = "*";
                lblrfvVideoLnk.Text = "*";
                lblrfvBestPractice.Text = "*";
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyBestPractice)).Style.Add("display", "block");
            }
            else
            {
                txtCloseDate.Enabled = false;
                txtCloseDate.Text = string.Empty;
                Label lblClosedDateRequired = FormView1.FindControl("lblCloseDateRequired") as Label;
                Label lblEngRepNumRequired = FormView1.FindControl("lblEngRepNumRequired") as Label;
                Label lblrfvEngReportLink = FormView1.FindControl("lblrfvEngReportLink") as Label;
                Label lblrfvIP = FormView1.FindControl("lblrfvIP") as Label;
                Label lblRfvOnePageLink = FormView1.FindControl("lblRfvOnePageLink") as Label;
                Label lblRfvRoiLink = FormView1.FindControl("lblRfvROILink") as Label;
                Label lblrfvVideoLnk = FormView1.FindControl("lblrfvVideoLnk") as Label;
                Label lblrfvBestPractice = FormView1.FindControl("lblrfvBestPractice") as Label;

                lblClosedDateRequired.Text = "&nbsp;&nbsp;";
                lblEngRepNumRequired.Text = "&nbsp;&nbsp;";
                lblrfvEngReportLink.Text = "&nbsp;&nbsp;";
                lblrfvIP.Text = "&nbsp;&nbsp;";
                lblRfvOnePageLink.Text = "&nbsp;&nbsp;";
                lblRfvRoiLink.Text = "&nbsp;&nbsp;";
                lblrfvVideoLnk.Text = "&nbsp;&nbsp;";
                lblrfvBestPractice.Text = "&nbsp;&nbsp;";
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyBestPractice)).Style.Add("display", "none");



            }

            #endregion Get at Web.Config the status codes permitted when the project is closed
        }

        private void EnableAutomationType(string autoLevelselcted)
        {
            DropDownList drpAutoLevel = (DropDownList)FormView1.FindControl("drpAutoLevel");
            DropDownList drpAutomationType = (DropDownList)FormView1.FindControl("drpAutomationType");
            Control tbodyAutomationType = FormView1.FindControl("tbodyAutomationType");
            DropDownList drpAutoStage = tbodyAutomationType.FindControl("drpAutoStage") as DropDownList;
            drpAutoStage.Enabled = true;
            drpAutomationType.Items[1].Enabled = true;
            drpAutomationType.Items[2].Enabled = true;
            //drpAutomationType.Items[3].Enabled = true;
            //drpAutomationType.Items[4].Enabled = true;
            //drpAutomationType.Items[5].Enabled = true;
            //drpAutomationType.Items[6].Enabled = true;
            //drpAutomationType.Items[7].Enabled = true;
            //if (drpAutoLevel.SelectedItem != null)
            //{
            //    if (autoLevelselcted == "NA")
            //    {
            //        drpAutomationType.Items[1].Enabled = false;
            //        drpAutomationType.Items[2].Enabled = false;
            //        HideAutomationControls();
            //        drpAutoStage.Enabled = false;
            //    }
            //    else
            //    {
            //        drpAutomationType.Items[3].Enabled = false;
            //        drpAutomationType.Items[4].Enabled = false;
            //        drpAutomationType.Items[5].Enabled = false;
            //        drpAutomationType.Items[6].Enabled = false;
            //        drpAutomationType.Items[7].Enabled = false;
            //    }
            //}
        }
        
        protected void drpAutoLevel_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpAutoLevel = (DropDownList)FormView1.FindControl("drpAutoLevel");
            EnableAutomationType(drpAutoLevel.SelectedValue);
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;
            //if (drpAutoLevel.SelectedValue.Equals("NA"))
            //{
            //    drpAutoStage.SelectedValue = "N/A";
            //    drpAutoStage.Enabled = false;
            //}
            //else
            //{
                drpAutoStage.SelectedIndex = 0;
                drpAutoStage.Enabled = true;
            //}
            drpAutoStage_SelectedIndexChanged(drpAutoStage, null);
        }
        
        protected void drpCategories_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            AjaxControlToolkit.TextBoxWatermarkExtender twPrjDesc = (AjaxControlToolkit.TextBoxWatermarkExtender)FormView1.FindControl("twPrjDesc");
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            GridView grdCostSavings = FormView1.FindControl("grdCostSavings") as GridView;
            tbodyAutomation.Visible = false;            
            grdCostSavings.Columns[0].Visible = false;
            twPrjDesc.Enabled = false;
            HideAutomationControls();
            string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
            int pos = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
            if (pos > -1)
            {
                tbodyAutomation.Visible = true;
                grdCostSavings.Columns[0].Visible = true;
                twPrjDesc.Enabled = true;
            }
        }
        
        protected void FormView1_DataBound(object sender, EventArgs e)
        {
            if (mvViewers.ActiveViewIndex == 1)
            {
                FormView frmVw = (FormView)sender;
                string[] codeStatusWhenPjClosed = ConfigurationManager.AppSettings["StatusAfterClosed"].Split(',');
                DropDownList drpStatus = (DropDownList)((frmVw).FindControl("drpStatusCode"));
                int pos = Array.IndexOf(codeStatusWhenPjClosed, drpStatus.SelectedValue);
                //DropDownCalendar ddcClosedDate = FormView1.FindControl("ddcClosedDate") as DropDownCalendar;
                //ddcClosedDate.Enabled = pos > -1;
                TextBox txtCloseDate = FormView1.FindControl("ddcClosedDate") as TextBox;
                txtCloseDate.Enabled = pos > -1;
                
                if ((frmVw).FindControl("txtCostSaving") != null)
                {
                    TextBox txtCostSaving = (TextBox)((frmVw).FindControl("txtCostSaving"));
                    if (txtCostSaving.Text.Trim() == "0")
                    {
                        txtCostSaving.Text = "N/A";
                    }
                }
                
                TextBox txtPercentCompletion = frmVw.FindControl("txtPercentCompletion") as TextBox;
                drpStatus.Attributes.Add("onchange", string.Format("changeStatus('{0}','{1}')", drpStatus.ClientID, txtPercentCompletion.ClientID));
                int projectID = Convert.ToInt32(gvProjects.SelectedDataKey[0]);
                
                TextBox txtBULead = FormView1.FindControl("txtBULead") as TextBox;
                TextBox txtEngReportLink = FormView1.FindControl("txtEngReportLink") as TextBox;
                RadioButton rdoIPYes = FormView1.FindControl("rdoIPYes") as RadioButton;
                RadioButton rdoIPNo = FormView1.FindControl("rdoIPNo") as RadioButton;
                TextBox hdfrfvIP = FormView1.FindControl("hdfrfvIP") as TextBox;

                RadioButtonList rblBestPractice = FormView1.FindControl("rblBestPractice") as RadioButtonList;
                TextBox txtBPComment = FormView1.FindControl("txtBPComment") as TextBox;
                Control tdBPComment = FormView1.FindControl("tdBPComment");

                DataSet ds = GetProjectByID(projectID);
                
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    txtBULead.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_SITEBULEAD"].ToString());
                    txtEngReportLink.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_ENG_LINK"].ToString());
                    
                    int engIP = System.Convert.ToInt32(CheckmarxHelper.EscapeReflectedXss(dr["PJ_ENG_IP"].ToString()));
                    rdoIPYes.Checked = false;
                    rdoIPNo.Checked = false;
                    if (engIP == 1)
                    {
                        rdoIPYes.Checked = true;
                        hdfrfvIP.Text = "Y";
                    }
                    if (engIP == 0)
                    {
                        rdoIPNo.Checked = true;
                        hdfrfvIP.Text = "Y";
                    }
                    rblBestPractice.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_BEST_PRACTICE"].ToString());
                    if (rblBestPractice.SelectedValue.Equals("Y"))
                    {
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdBPComment)).Style.Add("display", "block");
                        txtBPComment.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_BEST_PRACTICE_COMMENT"].ToString());
                    }
                    else
                    {
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdBPComment)).Style.Add("display", "none");
                    }                    
                }
                
                DropDownList drpCategories = (DropDownList)frmVw.FindControl("drpCategories");
                Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
                tbodyAutomation.Visible = false;
                GridView grdCostSavings = FormView1.FindControl("grdCostSavings") as GridView;
                grdCostSavings.Columns[0].Visible = false;
                
                if (drpCategories.SelectedItem != null)
                {
                    string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
                    int position = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
                    if (position > -1)
                    {
                        grdCostSavings.Columns[0].Visible = true;
                        tbodyAutomation.Visible = true;
                        
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            DataRow dr = ds.Tables[0].Rows[0];
                            SetValuesBasedOnStage(drpStatus.SelectedValue, dr);
                        }
                    }
                }
            }
        }
        
        public void SaveCoResponsibles(ListBox result, int projectCode)
        {
            ResponsiblesProjectsTableAdapter tbApt = new ResponsiblesProjectsTableAdapter();
            
            ProjectTracker.DAO.dtsProjectTracker.ResponsiblesProjectsDataTable tb =
                tbApt.GetDataByProjectCode(projectCode);
            
            ArrayList itemsToDelete = Project.GetCoResponsibleToDelete(result, tb);
            ArrayList itemsToInsert = Project.GetCoResponsibleToInsert(result, tb);
            
            foreach (string userCode in itemsToDelete.ToArray(typeof(string)))
            {
                tbApt.DeleteQuery(projectCode, userCode);
            }
            
            foreach (string userCode in itemsToInsert.ToArray(typeof(string)))
            {
                tbApt.InsertQuery(projectCode, userCode);
            }
        }
        
        protected void drpResponsibles_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpResponsible = (sender as DropDownList);
            UpdatePanel updCoResp = FormView1.FindControl("updCoResp") as UpdatePanel;
            
            //Get Lists Box to  find item selected as Location
            ListBox lstCoResponsibleAvaiable = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListBox lstCoResponsibleToInsert = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            
            //Enable all items
            foreach (ListItem itemToEnable in lstCoResponsibleAvaiable.Items)
            {
                itemToEnable.Enabled = true;
            }
            
            //Find Item at lists
            ListItem item = lstCoResponsibleToInsert.Items.FindByValue(drpResponsible.SelectedValue);
            ListItem itemAvaiable = lstCoResponsibleAvaiable.Items.FindByValue(drpResponsible.SelectedValue);
            
            //
            if (item != null)
            {
                lstCoResponsibleToInsert.Items.Remove(item);
                lstCoResponsibleAvaiable.Items.Add(item);

                Utility.OrderListBox(lstCoResponsibleAvaiable, drpResponsible.SelectedValue);
                
                if (lstCoResponsibleToInsert.Items.Count > 0)
                {
                    lstCoResponsibleToInsert.SelectedIndex = 0;
                }
                
                if (lstCoResponsibleAvaiable.Items.Count > 0)
                {
                    lstCoResponsibleAvaiable.SelectedIndex = 0;
                }
            }
            
            if (itemAvaiable != null)
            {
                itemAvaiable.Enabled = false;
            }
            
            updCoResp.Update();
        }
        
        protected void lstCoRespsAvaiable_DataBound(object sender, EventArgs e)
        {
            string responsibleCode = "";
            if (mvViewers.ActiveViewIndex == 1)
            {
                responsibleCode = gvProjects.SelectedDataKey["Username"].ToString();
            }

            #region Disable Co-Responsible equal that Responsible of this project
            
            ListBox list = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListItem item = list.Items.FindByValue(responsibleCode);
            if (item != null)
            {
                item.Enabled = false;
            }

            #endregion Disable Co-Responsible equal that Responsible of this project
            
            list.Style.Add("border-width", "1px");
        }
        
        protected void vwForm_Activate(object sender, EventArgs e)
        {
            HttpContext old_Context = HttpContext.Current;
            CostSavingDataSource.ClearSession(old_Context);
            //CostSavingDataSource.ClearSession();
            obsProjects.Select();
            gvProjects.DataBind();
            FormView1.DataBind();
            FormView1.ChangeMode(FormViewMode.Edit);
        }
        
        protected void obsProjects_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
        {  
            object code = e.InputParameters["Code"];
            // Save the region email parameters...
            object regionCode = e.InputParameters["RegionCode"];
            object responsible = e.InputParameters["Username"];
            object description = e.InputParameters["Description"];
            string sEmailParam = String.Format("{0};{1};{2};{3}", code, regionCode, responsible, description);
            Session.Remove("DeletingEmailParameters");
            // Add in the session variable..
            //Session.Add("DeletingEmailParameters", String.Format("{0};{1};{2};{3}", code, regionCode, responsible, description));
            Session["DeletingEmailParameters"] = sEmailParam;
            e.InputParameters.Clear();
            
            // Mudei aqui pq não estava apagando e a bixa do desenvolvedor
            // estava com frescurinha, falando q tinha dores pelo corpo
            // (não vou nem citar o local) - Elton Souza 05-18-2007
            e.InputParameters.Add("projectCode", code);
        }
        
        private int row = -1;
        private bool canDelete = true;
        
        protected void gvProjects_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            gvProjects.SelectedIndex = e.RowIndex;
        }
        
        protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            DropDownList drpRegion = FormView1.FindControl("drpRegion") as DropDownList;
            DropDownList drpResp = FormView1.FindControl("drpResponsibles") as DropDownList;
            DropDownList drpLocation = FormView1.FindControl("drpLocations") as DropDownList;
            DropDownList drpStatus = FormView1.FindControl("drpStatusCode") as DropDownList;           
            TextBox txtCloseDate = FormView1.FindControl("ddcClosedDate") as TextBox;
            e.NewValues["ClosedDate"] = txtCloseDate.Text;            
            e.NewValues["RegionCode"] = drpRegion.SelectedValue;
            e.NewValues["Username"] = drpResp.SelectedValue;
            e.NewValues["LocationCode"] = drpLocation.SelectedValue;
            e.NewValues["StatusCode"] = drpStatus.SelectedValue;
            hdfStatus.Value = CheckmarxHelper.EscapeReflectedXss(drpStatus.SelectedValue);
            TextBox txtBULead = (TextBox)FormView1.FindControl("txtBULead");
            e.NewValues["SiteLead"] = txtBULead.Text;

            #region Delete All Sub-Locations relationshiped with this project to insert the new after
            
            ProjectLocationTableAdapter tbAdpt = new ProjectLocationTableAdapter();
            tbAdpt.DeleteLocationsOfTheProject(Convert.ToInt32(gvProjects.SelectedDataKey[0]));

            #endregion Delete All Sub-Locations relationshiped with this project to insert the new after

            #region Insert Sub-Locations at a Session to insert

            ArrayList arrSubLocations = new ArrayList();

            ListBox lstCoLocationsToInsert = (FormView1.FindControl("lstCoLocationsToInsert") as ListBox);
            string objLocation = string.Empty;
            foreach (ListItem item in lstCoLocationsToInsert.Items)
            {
                objLocation = CheckmarxHelper.EscapeReflectedXss(item.Value);
                if (!string.IsNullOrEmpty(objLocation))
                    arrSubLocations.Add(objLocation);
            }
            Session.Remove("SubLocations");
            Session["SubLocations"] = arrSubLocations;
            //Session.Add("SubLocations", arrSubLocations);

            #endregion Insert Sub-Locations at a Session to insert
            
            TextBox txtEngReportLink = FormView1.FindControl("txtEngReportLink") as TextBox;
            RadioButton rdoIPYes = FormView1.FindControl("rdoIPYes") as RadioButton;
            RadioButton rdoIPNo = FormView1.FindControl("rdoIPNo") as RadioButton;           
            hdfEngIP.Value = rdoIPYes.Checked ? "1" : rdoIPNo.Checked ? "0" : "-1";
            hdfEngLink.Value = CheckmarxHelper.EscapeReflectedXss(txtEngReportLink.Text.Trim());

            RadioButtonList rblBestPractice = FormView1.FindControl("rblBestPractice") as RadioButtonList;
            TextBox txtBPComment = FormView1.FindControl("txtBPComment") as TextBox;
            hdfrbBestPractice.Value = CheckmarxHelper.EscapeReflectedXss(rblBestPractice.SelectedValue);
            hdftxtBestPractice.Value = hdfrbBestPractice.Value.Equals("Y") ? CheckmarxHelper.EscapeReflectedXss(txtBPComment.Text) : string.Empty;

            hdfCreator.Value = CheckmarxHelper.EscapeReflectedXss(drpResp.SelectedValue);
            hdfProjectID.Value = gvProjects.SelectedDataKey[0].ToString();
            
            ProjectTracker.Business.User u = new ProjectTracker.Business.User();
            ADUserSelect adu1 = u.GetUser(CheckmarxHelper.EscapeLdapSearchFilter(drpResp.SelectedValue));
            
            string toEmail = string.Empty;
            string ccEmail = string.Empty;
            
            Hashtable hash = new Hashtable();
            ListBox list = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            
            if (adu1 != null)
            {
                hdfFromEmail.Value = adu1.Email;
                toEmail = adu1.Email;
            }
            
            if (toEmail != string.Empty)
            {
                toEmail += ",";
            }

            toEmail += ConfigurationManager.AppSettings["ReceiversClosedEmail"].ToString();
            
            foreach (ListItem item in list.Items)
            {
                if (!hash.ContainsKey(item.Value))
                {
                    ADUserSelect aduTemp = u.GetUser(CheckmarxHelper.EscapeLdapSearchFilter(item.Value));
                    
                    if (aduTemp != null)
                    {
                        toEmail += ",";
                        toEmail += aduTemp.Email;
                        
                        hash.Add(item.Value, item.Value);
                    }
                }
            }

            hdfToEmail.Value = toEmail;
            
            if (adu1 != null)
            {
                ccEmail = adu1.Email;
            }
            
            if (ccEmail != string.Empty)
            {
                ccEmail += ",";
            }

            ccEmail += ConfigurationManager.AppSettings["ReceiversClosedEmail"].ToString();

            string testMode = "0";
            
            if (!object.Equals(ConfigurationManager.AppSettings["TestMode"], null))
            {
                if (ConfigurationManager.AppSettings["TestMode"].ToString() == "1")
                {
                    testMode = "1";
                }
            }
            
            if (testMode == "0")
            {
                if (adu1 != null)
                {
                    try
                    {
                        string manager = adu1.Manager.Substring(adu1.Manager.IndexOf("CN"), adu1.Manager.IndexOf(","));
                        string managerEmail = u.GetMailManager(manager);
                        
                        ccEmail += ",";
                        ccEmail += managerEmail;
                    }
                    catch
                    {
                    }
                }
            }

            hdfCCEmail.Value = ccEmail;

            TextBox textBox2 = FormView1.FindControl("TextBox2") as TextBox;

            hdfProjDesc.Value = CheckmarxHelper.EscapeReflectedXss(textBox2.Text.Trim());

            hdfResp.Value = CheckmarxHelper.EscapeReflectedXss(drpResp.SelectedItem.Text);
            
            if (drpStatus.SelectedItem.Text == "Closed")
            {
                hdfIsClosed.Value = "Y";
            }
            else
            {
                hdfIsClosed.Value = "N";
            }
        }
        
        private void UpdateAutomationTDInfor(int id)
        {
            SetValuesBasedOnStage(hdfStatus.Value);
            DateTime? dtCapexAppvdDate = null;
            if (hdfCapexAppdDate.Value != string.Empty)
            {
                dtCapexAppvdDate = Convert.ToDateTime(hdfCapexAppdDate.Value);
            }
            
            
            SqlParameter[] parameters =
            {
                new SqlParameter("@ProjectID", SqlDbType.Int) { Value = id },
                new SqlParameter("@ProjectCost", SqlDbType.Decimal,18) { Precision = 18, Scale = 4, Value = hdfProjCost.Value },
                new SqlParameter("@AutoLevel", SqlDbType.VarChar, 150) { Value = hdfAutoLevel.Value },
                new SqlParameter("@AutoType", SqlDbType.VarChar, 150) { Value = hdfAutoType.Value },
                new SqlParameter("@ReUseValue", SqlDbType.Decimal,5) { Precision = 5, Scale = 2, Value = hdfReuse.Value },
                new SqlParameter("@PlannedPayBack", SqlDbType.Int) { Value = hdfPlannedPaybackinMonths.Value },
                new SqlParameter("@EstProductLife", SqlDbType.Int) { Value = hdfEstimatedProductLifeinMonths.Value },
                new SqlParameter("@HCBeforeAutomation", SqlDbType.Int) { Value = hdfHeadcountBeforeAutomation.Value },
                new SqlParameter("@HCAfterAutomation", SqlDbType.Int) { Value = hdfHeadcountAfterAutomation.Value },
                new SqlParameter("@EstimatedROI", SqlDbType.Decimal,5) { Precision = 5, Scale = 2, Value = hdfEstimatedROIafterendoflife.Value },
                new SqlParameter("@AutoStage", SqlDbType.VarChar, 150) { Value = hdfAutoStage.Value },
                new SqlParameter("@ExpectedIRR", SqlDbType.Decimal, 5) { Precision = 5, Scale = 2, Value = hdfExpectedIRR.Value },
                new SqlParameter("@CapexApproved", SqlDbType.Char, 1) { Value = hdfCapexAppd.Value },
                new SqlParameter("@POIssued", SqlDbType.Char, 1) { Value = hdfPOIssued.Value },
                new SqlParameter("@PrjNumber", SqlDbType.VarChar,10) { Value = hdfPrjNumber.Value },
                new SqlParameter("@FlexPaid", SqlDbType.Char,1) { Value = hdfFlexPaid.Value },
                new SqlParameter("@HoldReason", SqlDbType.VarChar,150) { Value = hdfHoldReason.Value },
                new SqlParameter("@SummaryLink", SqlDbType.VarChar, 150) { Value = hdfSummaryLink.Value },
                new SqlParameter("@ROIlink", SqlDbType.VarChar, 150) { Value = hdfROILink.Value },
                new SqlParameter("@VideoLink", SqlDbType.VarChar, 150) { Value = hdfVideoLink.Value },
                new SqlParameter("@CloseReason", SqlDbType.Char, 3) { Value = hdfCloseReason.Value },
                new SqlParameter("@OtherRemarks", SqlDbType.VarChar, 150) { Value = hdfCloseRemarks.Value },                
                new SqlParameter("@CapexAppvdDate", SqlDbType.DateTime) { Value = (object)dtCapexAppvdDate ?? DBNull.Value },
            };
            SQLDBHelper dbHelp = new SQLDBHelper();
            try
            {
                dbHelp.ExecuteSQLBySP("SP_PT_UPDATE_AUTOMATION_PROJECT", parameters);
            }
            catch (Exception ex)
            {
            }
        }
        
        private void SetValuesBasedOnStage(string sStatus, DataRow dr = null)
        {
            hdfProjCost.Value = "0";
            hdfAutoStage.Value = "";
            hdfAutoLevel.Value = "";
            hdfAutoType.Value = "";
            hdfReuse.Value = "0";
            hdfPlannedPaybackinMonths.Value = "0";
            hdfEstimatedProductLifeinMonths.Value = "0";
            hdfHeadcountBeforeAutomation.Value = "0";
            hdfHeadcountAfterAutomation.Value = "0";
            hdfEstimatedROIafterendoflife.Value = "0";
            hdfExpectedIRR.Value = "0";
            hdfCapexAppd.Value = "";
            //new
            hdfCapexAppdDate.Value = "";

            hdfPOIssued.Value = "";
            hdfPrjNumber.Value = "";
            hdfFlexPaid.Value = "";            
            hdfVideoLink.Value = "";
            hdfROILink.Value = "";
            hdfSummaryLink.Value = "";
            hdfCloseReason.Value = "";
            hdfCloseRemarks.Value = "";
            
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;            
            SetAutomationLevelStageControls(dr);
            if (drpAutoStage.SelectedValue.Equals("Define") || drpAutoStage.SelectedValue.Equals("Eval"))
            {
                SetAutomationOpenDefineControls(dr);
                if (sStatus == "20")
                {
                    SetCloseInfoControls(dr);
                }
            }
            else if ((drpAutoStage.SelectedValue.Equals("Develop") || drpAutoStage.SelectedValue.Equals("Deploy")))
            {
                SetAutomationOpenDefineControls(dr);
                SettbodyOpenDevelopControls(dr);
                SettbodyPaidbyInfoControls(dr);
                
                if (sStatus == "20")
                {
                    if (drpAutoStage.SelectedValue.Equals("Develop"))
                    {
                        SetCloseInfoControls(dr);
                    }
                    else
                    {
                        SetCloseDeployControls(dr);
                    }
                }                
            }
        }

        private void SetAutomationLevelStageControls(DataRow dr = null)
        {
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            DropDownList drpAutoLevel = tbodyAutomation.FindControl("drpAutoLevel") as DropDownList;
            DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;
            DropDownList drpAutomationType = tbodyAutomation.FindControl("drpAutomationType") as DropDownList;            
            if (dr == null)
            {
                hdfAutoLevel.Value = CheckmarxHelper.EscapeReflectedXss(drpAutoLevel.SelectedValue);
                hdfAutoStage.Value = CheckmarxHelper.EscapeReflectedXss(drpAutoStage.SelectedValue);
                hdfAutoType.Value = CheckmarxHelper.EscapeReflectedXss(drpAutomationType.SelectedValue);
            }
            else
            {
                drpAutoStage.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_AUTO_STAGE"].ToString());
                drpAutoLevel.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_AUTO_LEVEL"].ToString());
                EnableAutomationType(drpAutoLevel.SelectedValue);               
                drpAutomationType.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_AUTO_TYPE"].ToString());
                drpAutoStage_SelectedIndexChanged(drpAutoStage, null);
            }
        }
        
        private void SetAutomationOpenDefineControls(DataRow dr = null)
        {
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            TextBox txtAutomationProjectCost = tbodyAutomation.FindControl("txtAutomationProjectCost") as TextBox;            
            //DropDownList drpAutomationType = tbodyAutomation.FindControl("drpAutomationType") as DropDownList;
            TextBox txtReuse = tbodyAutomation.FindControl("txtReuse") as TextBox;
            TextBox txtPlannedPaybackinMonths = tbodyAutomation.FindControl("txtPlannedPaybackinMonths") as TextBox;
            TextBox txtEstimatedProductLifeinMonths = tbodyAutomation.FindControl("txtEstimatedProductLifeinMonths") as TextBox;
            TextBox txtHeadcountBeforeAutomation = tbodyAutomation.FindControl("txtHeadcountBeforeAutomation") as TextBox;
            TextBox txtHeadcountAfterAutomation = tbodyAutomation.FindControl("txtHeadcountAfterAutomation") as TextBox;
            TextBox txtHeadcountReduction = tbodyAutomation.FindControl("txtHeadcountReduction") as TextBox;            
            TextBox txtEstimatedROIafterendoflife = tbodyAutomation.FindControl("txtEstimatedROIafterendoflife") as TextBox;
            TextBox txtExpectedIrr = tbodyAutomation.FindControl("txtExpectedIRR") as TextBox;
            TextBox txtHoldReason = tbodyAutomation.FindControl("txtHoldReason") as TextBox;
            if (dr == null)
            {
                hdfProjCost.Value = txtAutomationProjectCost.Text == string.Empty ? "0" : CheckmarxHelper.EscapeReflectedXss(txtAutomationProjectCost.Text);                
                //hdfAutoType.Value = drpAutomationType.SelectedValue;
                hdfReuse.Value = txtReuse.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtReuse.Text);
                hdfPlannedPaybackinMonths.Value = txtPlannedPaybackinMonths.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtPlannedPaybackinMonths.Text);
                hdfEstimatedProductLifeinMonths.Value = txtEstimatedProductLifeinMonths.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtEstimatedProductLifeinMonths.Text);
                hdfHeadcountBeforeAutomation.Value = txtHeadcountBeforeAutomation.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtHeadcountBeforeAutomation.Text);
                hdfHeadcountAfterAutomation.Value = txtHeadcountAfterAutomation.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtHeadcountAfterAutomation.Text);
                hdfEstimatedROIafterendoflife.Value = txtEstimatedROIafterendoflife.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtEstimatedROIafterendoflife.Text);
                hdfExpectedIRR.Value = txtExpectedIrr.Text == "" ? "0" : CheckmarxHelper.EscapeReflectedXss(txtExpectedIrr.Text);
                hdfHoldReason.Value = txtHoldReason.Text == string.Empty ? string.Empty : CheckmarxHelper.EscapeReflectedXss(txtHoldReason.Text);
            }
            else
            {
                txtPlannedPaybackinMonths.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_PLANNED_PAYBACK_IN_MONTHS"].ToString());
                //txtAutomationProjectCost.Text = double.Parse(dr["PJ_COST"].ToString()).ToString("N0");
                if (!string.IsNullOrEmpty(CheckmarxHelper.EscapeReflectedXss(dr["PJ_COST"].ToString())))
                {
                    txtAutomationProjectCost.Text = double.Parse(CheckmarxHelper.EscapeReflectedXss(dr["PJ_COST"].ToString())).ToString("N0");
                }
                else
                {
                    txtAutomationProjectCost.Text = "";
                }
                txtEstimatedProductLifeinMonths.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_ESTIMATED_PRODUCT_LIFE_IN_MONTHS"].ToString());
                txtHeadcountBeforeAutomation.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_HEADCOUNT_BEFORE_AUTOMATION"].ToString());
                txtHeadcountAfterAutomation.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_HEADCOUNT_AFTER_AUTOMATION"].ToString());
                if (!string.IsNullOrEmpty(txtHeadcountBeforeAutomation.Text) && !string.IsNullOrEmpty(txtHeadcountAfterAutomation.Text))
                {
                    int nHeadCountBefore = Convert.ToInt32(txtHeadcountBeforeAutomation.Text);
                    int nHeadCountAfter = Convert.ToInt32(txtHeadcountAfterAutomation.Text);
                    txtHeadcountReduction.Text = ((nHeadCountBefore >= nHeadCountAfter) ? (nHeadCountBefore - nHeadCountAfter) : 0).ToString();                    
                }
                if (!string.IsNullOrEmpty(CheckmarxHelper.EscapeReflectedXss(dr["PJ_ESTIMATED_ROI_AFTER_END_OF_LIFE"].ToString())))
                {
                    txtEstimatedROIafterendoflife.Text = double.Parse(CheckmarxHelper.EscapeReflectedXss(dr["PJ_ESTIMATED_ROI_AFTER_END_OF_LIFE"].ToString())).ToString("N0");
                }
                else
                {
                    txtEstimatedROIafterendoflife.Text = "";
                }
                if (!string.IsNullOrEmpty(CheckmarxHelper.EscapeReflectedXss(dr["PJ_IRRPERCENT"].ToString())))
                {
                    txtExpectedIrr.Text = double.Parse(CheckmarxHelper.EscapeReflectedXss(dr["PJ_IRRPERCENT"].ToString())).ToString("N0");
                }
                else
                {
                    txtExpectedIrr.Text = "";
                }
                //txtExpectedIrr.Text = double.Parse(dr["PJ_IRRPERCENT"].ToString()).ToString("N0");
                if (!string.IsNullOrEmpty(CheckmarxHelper.EscapeReflectedXss(dr["PJ_REUSE"].ToString())))
                {
                    txtReuse.Text = double.Parse(CheckmarxHelper.EscapeReflectedXss(dr["PJ_REUSE"].ToString())).ToString("N0");
                }
                else
                {
                    txtReuse.Text = "";
                }
                //txtReuse.Text = double.Parse(dr["PJ_REUSE"].ToString()).ToString("N0");
                txtHoldReason.Text = (CheckmarxHelper.EscapeReflectedXss(dr["PJ_HOLDREASON"].ToString()));
            }
        }
        
        private void SettbodyOpenDevelopControls(DataRow dr = null)
        {
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            if (tbodyOpenDevelop != null)
            {
                //RadioButtonList rblCapexAppd = tbodyOpenDevelop.FindControl("rblCapexAppd") as RadioButtonList;
                RadioButtonList rblPOIssued = tbodyOpenDevelop.FindControl("rblPOIssued") as RadioButtonList;
                TextBox txtCapexAppvdDate = FormView1.FindControl("ddcCapexAppvdDate") as TextBox;
                //Control tbodyCapexAppvdDate = FormView1.FindControl("tbodyCapexAppvdDate");
                Control tdLblPOAppvdDate = FormView1.FindControl("tdlblPoAppvdDate");
                Control tdPOAppvdDate = FormView1.FindControl("tdPoAppvdDate");
                if (dr == null)
                {
                    //hdfCapexAppd.Value = rblCapexAppd.SelectedValue;
                    //new
                    hdfPOIssued.Value = CheckmarxHelper.EscapeReflectedXss(rblPOIssued.SelectedValue);
                    hdfCapexAppdDate.Value = hdfPOIssued.Value.Equals("Y") ? CheckmarxHelper.EscapeReflectedXss(txtCapexAppvdDate.Text) : string.Empty;
                }
                else
                {
                    //rblCapexAppd.SelectedValue = dr["PJ_CAPEXAPPROVED"].ToString();
                    rblPOIssued.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_POISSUED"].ToString());
                    //new
                    if (rblPOIssued.SelectedValue.Equals("Y"))
                    {
                        //((System.Web.UI.HtmlControls.HtmlControl)(tbodyCapexAppvdDate)).Style.Add("display", "block");
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdLblPOAppvdDate)).Style.Add("display", "block");
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdPOAppvdDate)).Style.Add("display", "block");
                    }
                    else
                    {
                        //((System.Web.UI.HtmlControls.HtmlControl)(tbodyCapexAppvdDate)).Style.Add("display", "none");
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdLblPOAppvdDate)).Style.Add("display", "none");
                        ((System.Web.UI.HtmlControls.HtmlControl)(tdPOAppvdDate)).Style.Add("display", "none");
                    }
                    txtCapexAppvdDate.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_CAPEX_APPVD_DATE"].ToString());
                }
            }
        }
        
        private void SettbodyPaidbyInfoControls(DataRow dr = null)
        { 
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            if (tbodyPaidbyInfo != null)
            {
                RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
                TextBox txtPrjNumber = tbodyPaidbyInfo.FindControl("txtPrjNumber") as TextBox;
                if (dr == null)
                {
                    hdfFlexPaid.Value = CheckmarxHelper.EscapeReflectedXss(rblPaidFlex.SelectedValue);
                    hdfPrjNumber.Value = CheckmarxHelper.EscapeReflectedXss(txtPrjNumber.Text);
                }
                else
                {
                    rblPaidFlex.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_FLEXPAID"].ToString());
                    txtPrjNumber.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_PRJNUMBER"].ToString());
                    txtPrjNumber.Enabled = (rblPaidFlex.SelectedValue.Equals("F"));
                }
            }
        }
        
        private void SetCloseInfoControls(DataRow dr = null)
        {
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            if (tbodyCloseInfo != null)
            {
                DropDownList drpCloseInfo = tbodyCloseInfo.FindControl("drpCloseInfo") as DropDownList;
                if (dr == null)
                {
                    hdfCloseReason.Value = CheckmarxHelper.EscapeReflectedXss(drpCloseInfo.SelectedValue);
                }
                else
                {
                    drpCloseInfo.SelectedValue = CheckmarxHelper.EscapeReflectedXss(dr["PJ_CLOSEREASON"].ToString());
                }
                if (drpCloseInfo.SelectedValue.Equals("OTH"))
                {
                    TextBox txtCloseOther = tbodyCloseInfo.FindControl("txtCloseOther") as TextBox;
                    if (dr == null)
                    {
                        hdfCloseRemarks.Value = CheckmarxHelper.EscapeReflectedXss(txtCloseOther.Text);
                    }
                    else
                    {
                        txtCloseOther.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_OTHERREMARKS"].ToString());
                    }
                }
            }
        }
        
        private void SetCloseDeployControls(DataRow dr = null)
        {
            Control tbodyCloseDeployOther = FormView1.FindControl("tbodyCloseDeployOther");
            if (tbodyCloseDeployOther != null)
            {
                TextBox txtOnePageSummary = tbodyCloseDeployOther.FindControl("txtOnePageSummary") as TextBox;
                TextBox txtReturnInvest = tbodyCloseDeployOther.FindControl("txtReturnInvest") as TextBox;
                TextBox txtVideoLink = tbodyCloseDeployOther.FindControl("txtVideoLink") as TextBox;
                if (dr == null)
                {
                    hdfSummaryLink.Value = CheckmarxHelper.EscapeReflectedXss(txtOnePageSummary.Text);
                    hdfVideoLink.Value = CheckmarxHelper.EscapeReflectedXss(txtVideoLink.Text);
                    hdfROILink.Value = CheckmarxHelper.EscapeReflectedXss(txtReturnInvest.Text);
                }
                else
                {
                    txtOnePageSummary.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_SUMMARYLINK"].ToString());
                    txtVideoLink.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_ROILINK"].ToString());
                    txtReturnInvest.Text = CheckmarxHelper.EscapeReflectedXss(dr["PJ_VIDEOLINK"].ToString());
                }
            }
        }
        
        protected void drpRegion_DataBound(object sender, EventArgs e)
        {
            //Add Item with empty value
            DropDownList drpRegion = (DropDownList)sender;
            Utility.AddEmptyItem(drpRegion);
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1 && gvProjects.SelectedDataKey[7] != DBNull.Value)
            {
                int regionCode = Convert.ToInt32(gvProjects.SelectedDataKey[7]);
                ListItem item = drpRegion.Items.FindByValue(regionCode.ToString());
                if (item != null)
                {
                    drpRegion.SelectedValue = CheckmarxHelper.EscapeReflectedXss(item.Value);
                }
                else
                {
                    drpRegion.SelectedIndex = 0;
                }
            }
        }
        
        protected void vwGrid_Activate(object sender, EventArgs e)
        {
            //Enhancement
            bool isGuestUser = User.IsInRole("GUEST");
            obsProjects.SelectParameters["StatusCode"].DefaultValue = "21";
            obsProjects.SelectParameters["RegionCode"].DefaultValue = GetUserDefaultRegion();
            obsProjects.SelectParameters["UserViewrs"].DefaultValue = GetUsername();
            obsProjects.SelectParameters["IsGuestUser"].DefaultValue = isGuestUser.ToString();
            obsProjects.SelectParameters["StartDate"].DefaultValue = DateTime.Now.ToShortDateString();
            obsProjects.SelectParameters["EndDate"].DefaultValue = DateTime.Now.ToShortDateString();
            obsProjects.DataBind();
            if (drpStatusCodeS.SelectedIndex > -1 && drpRegionS.SelectedIndex > -1)
            {
                lblMsg.Text = string.Format("Criteria selected: Status={0} Region: {1}", CheckmarxHelper.EscapeReflectedXss(drpStatusCodeS.SelectedItem.Text), CheckmarxHelper.EscapeReflectedXss(drpRegionS.SelectedItem.Text));
            }
        }
        
        protected void btnMoveToInsertLoc_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoLocationsAvaiable = (ListBox)FormView1.FindControl("lstCoLocationsAvaiable");
            ListBox lstCoLocationsToInsert = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            
            ListItem itemToTransf = new ListItem(lstCoLocationsAvaiable.SelectedItem.Text, lstCoLocationsAvaiable.SelectedItem.Value);
            lstCoLocationsAvaiable.Items.Remove(lstCoLocationsAvaiable.SelectedItem);
            lstCoLocationsToInsert.Items.Add(itemToTransf);

            Utility.OrderListBox(lstCoLocationsToInsert);
            
            if (lstCoLocationsToInsert.Items.Count > 0)
            {
                lstCoLocationsToInsert.SelectedIndex = 0;
            }
            
            if (lstCoLocationsAvaiable.Items.Count > 0)
            {
                lstCoLocationsAvaiable.SelectedIndex = 0;
            }
        }
        
        protected void btnRemoveLocationProject_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoLocationsAvaiable = (ListBox)FormView1.FindControl("lstCoLocationsAvaiable");
            ListBox lstCoLocationsToInsert = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            DropDownList drpLocations = (DropDownList)FormView1.FindControl("drpLocations");
            UpdatePanel updDropLocation = FormView1.FindControl("updDropLocation") as UpdatePanel;

            ListItem itemToTransf = new ListItem(lstCoLocationsToInsert.SelectedItem.Text, lstCoLocationsToInsert.SelectedItem.Value);
            
            ListItem itemDownLocations = drpLocations.Items.FindByValue(lstCoLocationsToInsert.SelectedValue);
            if (itemDownLocations == null)
            {
                itemDownLocations = new ListItem(itemToTransf.Text, itemToTransf.Value);
                itemDownLocations.Enabled = true;
                drpLocations.Items.Add(itemDownLocations);
                Utility.OrderListBox(drpLocations);
            }
            
            lstCoLocationsToInsert.Items.Remove(lstCoLocationsToInsert.SelectedItem);
            lstCoLocationsAvaiable.Items.Add(itemToTransf);
            
            if (lstCoLocationsToInsert.Items.Count > 0)
            {
                lstCoLocationsToInsert.SelectedIndex = 0;
            }
            
            if (lstCoLocationsAvaiable.Items.Count > 0)
            {
                lstCoLocationsAvaiable.SelectedIndex = 0;
            }
            
            updDropLocation.Update();
        }
        
        protected void drpLocations_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpLocations = (sender as DropDownList);
            UpdatePanel updLstLocations = FormView1.FindControl("updLstLocations") as UpdatePanel;
            
            //Get Lists Box to  find item selected as Location
            ListBox lstCoLocationsAvaiable = (ListBox)FormView1.FindControl("lstCoLocationsAvaiable");
            ListBox lstCoLocationsToInsert = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            
            //Enable all items
            foreach (ListItem itemToEnable in lstCoLocationsAvaiable.Items)
            {
                itemToEnable.Enabled = true;
            }
            
            //Find Item at lists
            ListItem item = lstCoLocationsToInsert.Items.FindByValue(drpLocations.SelectedValue);
            ListItem itemAvaiable = lstCoLocationsAvaiable.Items.FindByValue(drpLocations.SelectedValue);
            
            //
            if (item != null)
            {
                ListItem itemToTransf = new ListItem(item.Text, item.Value);
                lstCoLocationsToInsert.Items.Remove(lstCoLocationsToInsert.SelectedItem);
                lstCoLocationsAvaiable.Items.Add(itemToTransf);

                Utility.OrderListBox(lstCoLocationsAvaiable, drpLocations.SelectedValue);
                
                if (lstCoLocationsToInsert.Items.Count > 0)
                {
                    lstCoLocationsToInsert.SelectedIndex = 0;
                }
                
                if (lstCoLocationsAvaiable.Items.Count > 0)
                {
                    lstCoLocationsAvaiable.SelectedIndex = 0;
                }
            }
            
            if (itemAvaiable != null)
            {
                itemAvaiable.Enabled = false;
            }
            
            updLstLocations.Update();
        }
        
        protected void drpRegion_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdatePanel updResp = (FormView1.FindControl("updResp") as UpdatePanel);
            updResp.Update();
        }
        
        protected void gvProjects_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortExpression = e.SortExpression;
            
            if (e.SortDirection == SortDirection.Descending)
            {
                sortExpression += " DESC";
            }
            
            if (ViewState["SortData"] == null)
            {
                ViewState["SortData"] = sortExpression;
            }
            else
            {
                ViewState.Add("SortData", sortExpression);
            }
            
            ChangeSortSymbol(gvProjects.HeaderRow, e.SortDirection, e.SortExpression);
        }
        
        /// <summary>
        /// Change the sort symbol into the header row.
        /// </summary>
        /// <param name="headerRow">The header row.</param>
        private void ChangeSortSymbol(GridViewRow headerRow, SortDirection direction, string sortExpression)
        {
            for (int i = 0; i < gvProjects.Columns.Count; i++)
            {
                DataControlField f = gvProjects.Columns[i];
                // Create a regex to remove the existing unicode char...
                Regex r = new Regex(@"\u25bc|\u25b2");
                f.HeaderText = r.Replace(f.HeaderText, "");
                // If has the current sort expression...
                if (f.SortExpression != null && f.SortExpression == sortExpression)
                {
                    if (direction == SortDirection.Ascending)
                    {
                        f.HeaderText += "\u25b2";
                    }
                    else
                    {
                        f.HeaderText += "\u25bc";
                    }
                }
            }
        }
        
        protected void obsRegion_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            string[] usernameDomain = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\'); 
            string username = usernameDomain[usernameDomain.Length - 1];
            
            e.InputParameters["PU_USUARIO"] = username;
        }
        
        protected void obsRegionS_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            string[] usernameDomain = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernameDomain[usernameDomain.Length - 1];
            
            e.InputParameters["PU_USUARIO"] = username;
        }
        
        /// <summary>
        /// Send an e-mail to the project, region and system responsible.
        /// </summary>
        private void SendDeletedEmail()
        {
            string managerMail = "";
            // Get the flag indicating if must send email..
            bool flag = Convert.ToBoolean(ConfigurationManager.AppSettings["ActiveDeleteSendEmail"]);
            if (flag)
            {
                // Get values from session...
                string[] values = Session["DeletingEmailParameters"].ToString().Split(';'); // Session format: code;regionCode;responsible;description
                // Get the region code responsible...
                int regionCode = Convert.ToInt32(values[1]);
                string regionEmail = new RegionsTableAdapter().GetRegionEmail(regionCode);
                string systemEmail = ConfigurationManager.AppSettings["ReceiversClosedEmail"];
                
                // Load the current user e-mail, and the responsible e-mail...
                User usr = new User();                
                ADUserSelect responsibleUser = usr.GetUser(values[2]);
                ADUserSelect currentUser = usr.GetUser(GetUsername());                
                //Get Manager Mail
                managerMail = GetMailManager();
                
                // Create the e-mail..
                Email deleteNotification = new Email();
                //commented by Kumar on 2-Jan-2017
                //string body = String.Format("Project: {0}\r\nProject Description: {1}", values[0], values[3]);
                ////string subject = String.Format("The project {0} was deleted by {1}", values[0], responsibleUser.FirstName + " " + responsibleUser.LastName);
                //string subject = String.Format("{0} {1}", currentUser.FirstName, currentUser.LastName);
                //End Comment Kumar 
                //Added By Kumar on 02-Jan-2017
                string body = String.Format(ConfigurationManager.AppSettings["MessageEmailDeleteProject"].ToString(), currentUser.FirstName + " " + currentUser.LastName, values[3], responsibleUser.FirstName + " " + responsibleUser.LastName);
                string subject = "Deleted Project - Project Tracker";
                // Set the receivers...

                string responseMail = string.Empty;
                if (responsibleUser != null)
                {
                    responseMail = responsibleUser.Email;
                }
                else
                {
                    responseMail = currentUser.Email;
                }
                //Get the Co Responsible for the Project
                Hashtable hash = new Hashtable();
                ListBox list = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
                foreach (ListItem item in list.Items)
                {
                    if (!hash.ContainsKey(item.Value))
                    {
                        ADUserSelect aduTemp = usr.GetUser(CheckmarxHelper.EscapeLdapSearchFilter(item.Value));

                        if (aduTemp != null)
                        {
                            responseMail += ";";
                            responseMail += aduTemp.Email;
                            hash.Add(item.Value, item.Value);
                        }
                    }
                }
                
                string[] to = new string[] { responseMail };
                string[] cc = new string[] { systemEmail, managerMail };
                //includeConditional ?
                //    new string[] { regionEmail, systemEmail, managerMail, conditionalReceiver } :
                //Commented by Kumar on 02-Jan-2017
                    //new string[] { regionEmail, systemEmail, managerMail };
                // End Comment
                // Send email..
                deleteNotification.SendEmail(body, subject, currentUser.Email, to, cc);
            }
        }
        
        private bool CheckIncludeConditional(string username)
        {
            EmailExceptionsTableAdapter adapter = new EmailExceptionsTableAdapter();
            object quantity = adapter.GetQuantityByUserName(username);
            
            return (quantity == null || Convert.ToInt32(quantity) == 0);
        }
        
        /// <summary>
        /// Get value of manager mail
        /// </summary>
        /// <returns>Manager mail</returns>
        private string GetMailManager()
        {
            User usr = new User();
            string manager = "";
            string mailManager = "";

            ADUserSelect currentUser = usr.GetUser(GetUsername());
            if (currentUser.Manager != null)
            {
                ////Get Manager Mail
                manager = currentUser.Manager.Substring(currentUser.Manager.IndexOf("CN"), currentUser.Manager.IndexOf(","));
                mailManager = usr.GetMailManager(manager);
            }
            
            return mailManager;
        }
        
        /// <summary>
        /// Get the current username, splitting his domain.
        /// </summary>
        /// <returns>The uername.</returns>
        private string GetUsername()
        {
            string username = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name);
            // Split username...
            string[] values = username.Split('\\');
            // If there are valid data..
            if (values.Length > 1)
            {
                return values[values.Length - 1];
            }
            return username;
        }
        
        public bool IsValidUrl(string url)
        {
            return Regex.IsMatch(url, @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\w\d:#@%/;$()~_?\+-=\\\.&]*)");
        }
        
        protected void drpSavingCategory_DataBound(object sender, EventArgs e)
        {
            DropDownList drpSavingCategory = (DropDownList)sender;
            Utility.AddEmptyItem(drpSavingCategory);
        }
        
        protected void drpSavingType_DataBound(object sender, EventArgs e)
        {
            DropDownList drpSavingType = (DropDownList)sender;
            Utility.AddEmptyItem(drpSavingType);
        }
        
        protected void grdCostSavings_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridView grd = (GridView)FormView1.FindControl("grdCostSavings");
            Page.Validate("UpdateCostSavingGroup");
            if (Page.IsValid)
            {                
                if (grd.Columns[0].Visible)
                {
                    DropDownList drpAutomationSaving = (DropDownList)grd.Rows[e.RowIndex].FindControl("drpAutomationSaving");
                    if (e.NewValues.Contains("AutomationSaving"))
                    {
                        e.NewValues.Remove("AutomationSaving");
                    }
                    if (drpAutomationSaving.SelectedItem != null)
                    {
                        e.NewValues["AutomationSaving"] = drpAutomationSaving.SelectedItem.Text;
                    }
                }
                DropDownList drpSavingType = (DropDownList)grd.Rows[e.RowIndex].FindControl("drpSavingType");
                if (e.NewValues.Contains("SavingType"))
                {
                    e.NewValues.Remove("SavingType");
                }
                if (drpSavingType.SelectedItem != null)
                {  
                    e.NewValues["SavingType"] = drpSavingType.SelectedItem.Text;
                }
                DropDownList drpSavingCategory = (DropDownList)grd.Rows[e.RowIndex].FindControl("drpSavingCategory");
                if (e.NewValues.Contains("SavingCategory"))
                {
                    e.NewValues.Remove("SavingCategory");
                }
                if (drpSavingCategory.SelectedItem != null)
                { 
                    e.NewValues["SavingCategory"] = drpSavingCategory.SelectedItem.Text;
                }
                if (e.NewValues.Contains("Date"))
                {
                    e.NewValues.Remove("Date");
                }                
                e.NewValues["Date"] = Convert.ToDateTime(e.NewValues["DateString"]);
            }
        }
        
        protected void grdCostSavings_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            CostSavingDataSource costSavingDataSource = new CostSavingDataSource();
            costSavingDataSource.HasChanged = true;
        }
        
        protected void grdCostSavings_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            CostSavingDataSource costSavingDataSource = new CostSavingDataSource();
            costSavingDataSource.HasChanged = true;
        }
        
        protected void odsSavings_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
        }
        
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            ValidationSummary vsInsertCostSaving = (ValidationSummary)FormView1.FindControl("vsInsertCostSaving");
            if (vsInsertCostSaving != null)
            {
                vsInsertCostSaving.Enabled = true;
            }
            GridView grd = (GridView)FormView1.FindControl("grdCostSavings");
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
            int posCat = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
            if (posCat > -1)
            {
                RequiredFieldValidator rfvAutomationSaving = null;
                rfvAutomationSaving = (RequiredFieldValidator)grd.FooterRow.FindControl("rfvFooterdrpAutomationSaving");
                rfvAutomationSaving.Enabled = true;
                RequiredFieldValidator rfvSavingType = null;
                rfvSavingType = (RequiredFieldValidator)grd.FooterRow.FindControl("rfvFooterSavingType");
                rfvSavingType.Enabled = true;
                RequiredFieldValidator rfvSavingCategory = null;
                rfvSavingCategory = (RequiredFieldValidator)grd.FooterRow.FindControl("rfvFooterSavingCategory");
                rfvSavingCategory.Enabled = true;
            }
            Page.Validate("InsertCostSavingGroup");
            if (Page.IsValid)
            {                
                DropDownList drpFooterdrpAutomationSaving = (DropDownList)grd.FooterRow.FindControl("drpFooterdrpAutomationSaving");
                DropDownList ddlSavingType = (DropDownList)grd.FooterRow.FindControl("drpFooterSavingType");
                DropDownList ddlSavingCategory = (DropDownList)grd.FooterRow.FindControl("drpFooterSavingCategory");
                //DropDownCalendar ddcDate = (DropDownCalendar)grd.FooterRow.FindControl("ddcFooterDate");
                TextBox txtddcFooterDate = (TextBox)grd.FooterRow.FindControl("ddcFooterDate");
                TextBox txtSavingAmount = (TextBox)grd.FooterRow.FindControl("txtFooterSavingAmount");
                CostSaving cs = new CostSaving(0, 0, Convert.ToInt32(ddlSavingType.SelectedItem.Value), Convert.ToInt32(ddlSavingCategory.SelectedItem.Value), Convert.ToDateTime(txtddcFooterDate.Text), Convert.ToDecimal(txtSavingAmount.Text), CheckmarxHelper.EscapeReflectedXss(ddlSavingType.SelectedItem.Text), CheckmarxHelper.EscapeReflectedXss(ddlSavingCategory.SelectedItem.Text));//checmarx
                CostSavingDataSource csds = new CostSavingDataSource();
                
                string automationSaving = "Select One Option";
                int automationSavingID = 0;
                
                if (drpFooterdrpAutomationSaving.SelectedItem != null)
                {
                    if (drpFooterdrpAutomationSaving.SelectedItem.Value != "")
                    {
                        automationSaving = CheckmarxHelper.EscapeReflectedXss(drpFooterdrpAutomationSaving.SelectedItem.Text);
                        automationSavingID = System.Convert.ToInt32(drpFooterdrpAutomationSaving.SelectedItem.Value);
                    }
                }
                
                if (automationSaving == "")
                {
                    automationSaving = "Select One Option";
                }
                
                cs.AutomationSaving = automationSaving;
                cs.AutomationSavingId = automationSavingID;
                
                csds.InsertCostSaving(cs);
                csds.HasChanged = true;
                grd.DataBind();                
                ddlSavingCategory.SelectedIndex = -1;
                ddlSavingType.SelectedIndex = -1;               
                txtddcFooterDate.Text = string.Empty;
                txtSavingAmount.Text = "";
            }
        }

        protected void grdCostSavings_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.DataItem != null && e.Row.DataItem is CostSaving)
            {
                CostSaving costSaving = (CostSaving)e.Row.DataItem;
                if (costSaving.CostSavingId == -1)
                {
                    Label lblSavingType = (Label)e.Row.FindControl("lblSavingType");
                    lblSavingType.Visible = false;
                    Label lblSavingCategory = (Label)e.Row.FindControl("lblSavingCategory");
                    lblSavingCategory.Visible = false;
                    Label dateLabel = (Label)e.Row.FindControl("lblDate");
                    dateLabel.Visible = false;
                    Label savingAmountLabel = (Label)e.Row.FindControl("lblSavingAmount");
                    savingAmountLabel.Visible = false;
                    ImageButton editButton = (ImageButton)e.Row.FindControl("btnEdit");
                    editButton.Visible = false;
                    ImageButton deleteButton = (ImageButton)e.Row.FindControl("btnDelete");
                    deleteButton.Visible = false;
                }
            }

            if (e.Row.RowState == (DataControlRowState.Edit | DataControlRowState.Selected) || e.Row.RowType == DataControlRowType.Footer)
            {
                TextBox txtSavingAmount = null;
                ImageButton btnUpdate = null;
                bool doValidation = false;
                if (e.Row.RowType == DataControlRowType.Footer)
                {
                    txtSavingAmount = (TextBox)e.Row.FindControl("txtFooterSavingAmount");
                    btnUpdate = (ImageButton)e.Row.FindControl("btnAdd");
                    doValidation = true;
                }
                else
                {  
                    txtSavingAmount = (TextBox)e.Row.FindControl("txtSavingAmount");
                    btnUpdate = (ImageButton)e.Row.FindControl("btnUpdate");
                    doValidation = false;
                }
                if (txtSavingAmount != null && btnUpdate != null)
                {
                    btnUpdate.OnClientClick = string.Format("return VerifyCostSavingValue('{0}','{1}')", txtSavingAmount.ClientID, doValidation);
                }
            }
            GridViewRow row = e.Row;
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            DropDownList drpAutomationSaving = row.FindControl("drpAutomationSaving") as DropDownList;
            DropDownList ddlSavingType = row.FindControl("drpSavingType") as DropDownList;
            DropDownList ddlSavingCategory = row.FindControl("drpSavingCategory") as DropDownList;
            string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
            int pos = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
            if (pos > -1)
            {
                if (!object.Equals(drpAutomationSaving, null))
                {
                    drpAutomationSaving.Enabled = false;
                    ddlSavingType.Enabled = false;
                    ddlSavingCategory.Enabled = false;
                    drpAutomationSaving_SelectedIndexChanged(drpAutomationSaving, null);
                }
            }
            else
            {
                if (!object.Equals(ddlSavingType, null))
                {
                    bool enabled = true;
                    enabled = ddlSavingType.SelectedValue.Equals("3") ? false : true; //Saving Type Revenue ID (3)
                    InitCategoryItems(ddlSavingCategory, ddlSavingType.SelectedValue);
                    ddlSavingCategory.Enabled = enabled;
                }
            }
        }
        
        protected void odsSavings_Selected(object sender, ObjectDataSourceStatusEventArgs e)
        {
            GridView grdCostSavings = FormView1.FindControl("grdCostSavings") as GridView;
            bool isAutomationProject =  grdCostSavings.Columns[0].Visible;
            Label lblTotalSavings = (Label)FormView1.FindControl("lblTotalSavings");
            decimal total = 0;
            decimal dPlannedSav = 0;
            decimal dActualSav = 0;
            if (e.ReturnValue != null && e.ReturnValue is List<CostSaving>)
            {
                foreach (CostSaving costSaving in (e.ReturnValue as List<CostSaving>))
                {
                    if (costSaving.CostSavingId != -1)
                    {
                        total += costSaving.SavingAmount;
                    }
                    if (isAutomationProject)
                    {
                        if (costSaving.SavingTypeId == 4)
                        {
                            dPlannedSav += costSaving.SavingAmount;
                        }
                        else
                        {
                            dActualSav += costSaving.SavingAmount;
                        }
                    }
                }
            }
            lblTotalSavings.Text = String.Format("{0:c}", total);
            hfAutoPlannedSaving.Value = dPlannedSav.ToString();
            hfAutoActualSaving.Value = dActualSav.ToString();
        }
        
        protected void lbGetAll_Click(object sender, EventArgs e)
        {
            txtProjectCode.Text = "";
            txtDescription.Text = "";
            //drpResponsiblesS.SelectedIndex = -1;
            drpCategoriesS.SelectedIndex = -1;
            drpStatusCodeS.SelectedIndex = -1;
            drpLocationsS.SelectedIndex = -1;
            drpCustomersS.SelectedIndex = -1;
            drpRegionS.SelectedIndex = -1;
            drpSavingCategoryS.SelectedIndex = -1;
            drpRevenueCostSaving.SelectedIndex = -1;
        }

        protected void drpSavingType_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlSavingType = sender as DropDownList;
            GridViewRow row = ddlSavingType.NamingContainer as GridViewRow;
            DropDownList ddlSavingCategory = null;
            RequiredFieldValidator rfv = null;
            RequiredFieldValidator rfvDate = null;
            RequiredFieldValidator rfvSavingAmount = null;
            RegularExpressionValidator revSavingAmt = null;
            RequiredFieldValidator rfvSavingType = null;

            bool footer = true;
            if (ddlSavingType.ID == "drpSavingType")
            {
                footer = false;
                ddlSavingCategory = row.FindControl("drpSavingCategory") as DropDownList;
                rfvSavingType = row.FindControl("rfvSavingType") as RequiredFieldValidator;
                rfv = row.FindControl("rfvSavingCategory") as RequiredFieldValidator;
                rfvDate = row.FindControl("rfvDate") as RequiredFieldValidator;
                rfvSavingAmount = row.FindControl("rfvSavingAmount") as RequiredFieldValidator;
                revSavingAmt = row.FindControl("revSavingAmt") as RegularExpressionValidator;
            }
            else
            {
                footer = true;
                ddlSavingCategory = row.FindControl("drpFooterSavingCategory") as DropDownList;
                rfvSavingType = row.FindControl("rfvFooterSavingType") as RequiredFieldValidator;
                rfv = row.FindControl("rfvFooterSavingCategory") as RequiredFieldValidator;
                rfvDate = row.FindControl("rfvFooterDate") as RequiredFieldValidator;
                rfvSavingAmount = row.FindControl("rfvFooterSavingAmount") as RequiredFieldValidator;
                revSavingAmt = row.FindControl("revFootSavAmt") as RegularExpressionValidator;
            }
            if (!object.Equals(ddlSavingType.SelectedItem, null))
            {
                if (ddlSavingType.SelectedValue.Equals("3") || ddlSavingType.SelectedValue.Equals("4")) // saving type revenue ID (3) and Planned Saving ID (4)
                {
                    ddlSavingCategory.Enabled = false;
                    rfv.Enabled = false;
                }
                else
                {
                    ddlSavingCategory.Enabled = !string.IsNullOrEmpty(ddlSavingType.SelectedValue);
                    if (footer)
                    {
                        rfvSavingType.Enabled = !string.IsNullOrEmpty(ddlSavingType.SelectedValue);//false;
                        rfv.Enabled = !string.IsNullOrEmpty(ddlSavingType.SelectedValue); //false 
                    }
                    else
                    {
                        rfvSavingType.Enabled = (string.IsNullOrEmpty(ddlSavingType.SelectedValue));
                        rfv.Enabled = true;
                    }
                }
                rfvDate.Enabled = true;
                rfvSavingAmount.Enabled = true;
                revSavingAmt.Enabled = true;
            }
            InitCategoryItems(ddlSavingCategory, ddlSavingType.SelectedValue);
        }

        protected void drpAutomationSaving_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpStatusCode = FormView1.FindControl("drpStatusCode") as DropDownList;
            DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
            DropDownList drpAutomationSaving = sender as DropDownList;
            GridViewRow row = drpAutomationSaving.NamingContainer as GridViewRow;
            DropDownList ddlSavingType = null;
            DropDownList ddlSavingCategory = null;
            RequiredFieldValidator rfvSavingType = null;
            RequiredFieldValidator rfvSavingCategory = null;
            RequiredFieldValidator rfvDate = null;
            RequiredFieldValidator rfvSavingAmount = null;
            RegularExpressionValidator revSavingAmt = null;
            RequiredFieldValidator rfvAutomationSaving = null;

            bool enabled = true;
            bool footer = true;
            bool isCloseDeployFlex = drpStatusCode.SelectedValue.Equals("20") && drpAutoStage.SelectedValue.Equals("Deploy") && rblPaidFlex.SelectedValue.Equals("F");
            bool isCloseDeployCust = drpStatusCode.SelectedValue.Equals("20") && drpAutoStage.SelectedValue.Equals("Deploy") && rblPaidFlex.SelectedValue.Equals("C");

            if (drpAutomationSaving.ID == "drpAutomationSaving")
            {
                footer = false;
                ddlSavingType = row.FindControl("drpSavingType") as DropDownList;
                rfvAutomationSaving = row.FindControl("rfvAutomationSaving") as RequiredFieldValidator;
                ddlSavingCategory = row.FindControl("drpSavingCategory") as DropDownList;
                rfvSavingType = row.FindControl("rfvSavingType") as RequiredFieldValidator;
                rfvSavingCategory = row.FindControl("rfvSavingCategory") as RequiredFieldValidator;
                rfvDate = row.FindControl("rfvDate") as RequiredFieldValidator;
                rfvSavingAmount = row.FindControl("rfvSavingAmount") as RequiredFieldValidator;
                revSavingAmt = row.FindControl("revSavingAmt") as RegularExpressionValidator;
            }
            else
            {
                footer = true;
                ddlSavingType = row.FindControl("drpFooterSavingType") as DropDownList;
                ddlSavingCategory = row.FindControl("drpFooterSavingCategory") as DropDownList;
                rfvAutomationSaving = row.FindControl("rfvFooterdrpAutomationSaving") as RequiredFieldValidator;
                rfvSavingType = row.FindControl("rfvFooterSavingType") as RequiredFieldValidator;
                rfvSavingCategory = row.FindControl("rfvFooterSavingCategory") as RequiredFieldValidator;
                rfvDate = row.FindControl("rfvFooterDate") as RequiredFieldValidator;
                rfvSavingAmount = row.FindControl("rfvFooterSavingAmount") as RequiredFieldValidator;
                revSavingAmt = row.FindControl("revFootSavAmt") as RegularExpressionValidator;
            }
            if (isCloseDeployFlex)
            {
              InitTypeItems(ddlSavingType, "CLOSEDEPLOYPAIDBYFLEX");
            }
            else if (isCloseDeployCust)
            {
              InitTypeItems(ddlSavingType, "CLOSEDEPLOYPAIDBYCUST");
            }
            else
            {
                InitTypeItems(ddlSavingType, "");
            }

            if (drpAutoStage.SelectedValue.Equals("Define") || drpAutoStage.SelectedValue.Equals("Eval") || drpAutoStage.SelectedValue.Equals("Develop") || drpAutomationSaving.SelectedValue.Equals("9"))
            {
                enabled = footer ? !(drpAutomationSaving.SelectedValue.Equals("0")) : true;
                ddlSavingType.SelectedValue = drpAutomationSaving.SelectedValue.Equals("0") ? "" : "4"; //Saving Type planned saving ID 
                ddlSavingType.Enabled = false; // In this stage only Planned saving applicable
                rfvSavingType.Enabled = enabled;
                ddlSavingCategory.Enabled = false; // In this stage only Planned saving applicable
                rfvSavingCategory.Enabled = enabled;
                rfvDate.Enabled = enabled;
                rfvSavingAmount.Enabled = enabled;
                revSavingAmt.Enabled = enabled;
            }
            else
            {
                enabled = footer ? !(drpAutomationSaving.SelectedValue.Equals("0")) : true;
                rfvAutomationSaving.Enabled = enabled;
                rfvSavingType.Enabled = enabled;
                rfvSavingCategory.Enabled = enabled;
                rfvDate.Enabled = enabled;
                rfvSavingAmount.Enabled = enabled;
                revSavingAmt.Enabled = enabled;
                if ((drpAutomationSaving.SelectedValue.Equals("0")))
                {
                    ddlSavingType.Enabled = false;
                    ddlSavingType.SelectedValue = "";
                    ddlSavingCategory.Enabled = false;
                    ddlSavingCategory.SelectedValue = "";
                }
                else
                {
                    ddlSavingType.Enabled = true;
                    ddlSavingCategory.Enabled = !string.IsNullOrEmpty(ddlSavingType.SelectedValue);
                }
            }
            InitCategoryItems(ddlSavingCategory, ddlSavingType.SelectedValue);
        }
        private void InitTypeItems(DropDownList ddlSavingType, string cStatus)
        {
            string sql;
            if (cStatus.Equals("CLOSEDEPLOYPAIDBYFLEX"))
            {
                sql = "select PV_CODIGO as code, PV_ABBREVIATION as Abbreviation, PV_DESCRIPTION as Description from TB_PT_PV_SAVINGTYPE where PV_CODIGO = 2"; //enable only Hard Savings
            }
            else if (cStatus.Equals("CLOSEDEPLOYPAIDBYCUST"))
            {
                sql = "select PV_CODIGO as code, PV_ABBREVIATION as Abbreviation, PV_DESCRIPTION as Description from TB_PT_PV_SAVINGTYPE where PV_CODIGO = 4"; //enable only Planned Savings
            }
            else
            {
                sql = "select PV_CODIGO as code, PV_ABBREVIATION as Abbreviation, PV_DESCRIPTION as Description from TB_PT_PV_SAVINGTYPE";
            }
            SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
            DataSet ds = instance.Query(sql, null);
            ddlSavingType.Items.Clear();
            ddlSavingType.Items.Add(new ListItem("Select One Option", ""));
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ddlSavingType.Items.Add(new ListItem(dr["Description"].ToString(), dr["code"].ToString()));
            }
        }

        private void InitCategoryItems(DropDownList ddlSavingCategory, string sSavingTypeID)
        {
            string currSavCatValue = CheckmarxHelper.EscapeReflectedXss(ddlSavingCategory.SelectedValue);
            string sql = "select PN_CODIGO as code, PN_ABBREVIATION as Abbreviation, PN_DESCRIPTION as Description, PN_TAG as Tag from TB_PT_PN_SAVINGCATEGORY";
            ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
            DataSet ds = instance.Query(sql, null);
            ddlSavingCategory.Items.Clear();
            ddlSavingCategory.Items.Add(new ListItem("Select One Option", ""));
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ddlSavingCategory.Items.Add(new ListItem(dr["Description"].ToString(), dr["code"].ToString()));
            }
            switch (sSavingTypeID)
            {
                case "4": // Planned Saving ID
                    ddlSavingCategory.SelectedValue = "11"; // Planned Saving ID
                    break;
                case "3": // revenue  ID
                    ddlSavingCategory.SelectedValue = "10"; // revenue  ID
                    break;
                default:
                    int nRevenueIndex = ddlSavingCategory.Items.IndexOf(ddlSavingCategory.Items.FindByValue("10"));
                    int nPlanSavIndex = ddlSavingCategory.Items.IndexOf(ddlSavingCategory.Items.FindByValue("11"));
                    ddlSavingCategory.Items[nRevenueIndex].Enabled = false;
                    ddlSavingCategory.Items[nPlanSavIndex].Enabled = false;
                    ddlSavingCategory.SelectedValue = currSavCatValue;
                    break;
            }
                         
        }
        
        protected void FormView1_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
        { 
            UpdateEngReportInfor(hdfProjectID.Value, hdfEngLink.Value, hdfEngIP.Value, hdfrbBestPractice.Value, hdftxtBestPractice.Value);
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            if (drpCategories.SelectedItem != null)
            {
                string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
                int pos = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
                if (pos > -1)
                {
                    UpdateAutomationTDInfor(System.Convert.ToInt32(hdfProjectID.Value));
                    //hdfCCEmail.Value += string.Format(",{0}", ConfigurationManager.AppSettings["AutomationHeadEmail"].ToString());
                    DropDownList drpRegion = FormView1.FindControl("drpRegion") as DropDownList;
                    if (drpRegion != null)
                    {
                        SQLDBHelper instance = new SQLDBHelper();
                        string sRegionValue = string.Empty;
                        //string sql = string.Format("SELECT PRE_AUTOMATION_EMAIL from TB_PT_PRE_REGIONS WHERE PRE_CODIGO = '{0}'", sRegionValue);
                        string sql = "SELECT PRE_AUTOMATION_EMAIL from TB_PT_PRE_REGIONS WHERE PRE_CODIGO = @RegionValue";
                        //SqlParameter[] parameters = new SqlParameter[0];
                        SqlParameter[] parameters =
                            {
                            //new SqlParameter("@RegionValue", CheckmarxHelper.EscapeReflectedXss(drpRegion.SelectedValue)) };
                                new SqlParameter("@RegionValue", Convert.ToInt32(drpRegion.SelectedValue)) };
                        object objGetAutomationHeadEmail = instance.GetSingle(sql, parameters);
                        hdfCCEmail.Value += string.Format(",{0}", objGetAutomationHeadEmail.ToString());
                    }
                }
            }

            string creator = hdfCreator.Value;

            UpdateCreator(System.Convert.ToInt32(hdfProjectID.Value), creator);
            
            if (Convert.ToBoolean(ConfigurationManager.AppSettings["ActiveSendEmail"]))
            {
                if (hdfIsClosed.Value == "Y")
                {
                    string message = String.Format(ConfigurationManager.AppSettings["MessageEmailProjectClose"].ToString(), hdfResp.Value, hdfProjDesc.Value, hdfResp.Value, System.Convert.ToInt32(hdfProjectID.Value).ToString());
                    string subject = "Close Project - Project Tracker.";
                    
                    Email email = new Email();
                    email.SendEmail(message, subject, hdfFromEmail.Value, hdfToEmail.Value.Split(','), hdfCCEmail.Value.Split(','));
                }
            }
        }
        
        private void UpdateEngReportInfor(string id, string engLink, string engIP, string bpOption, string bpComment)
        {
            //string sql = string.Format("update TB_PT_PJ_PROJECTS set PJ_ENG_LINK = '{0}', PJ_ENG_IP = {1}, PJ_BEST_PRACTICE = '{2}', PJ_BEST_PRACTICE_COMMENT = '{3}' where PJ_CODIGO = {4}", engLink, engIP, bpOption, bpComment, id);
            //SqlParameter[] sqlparam =
            //{
            //    new SqlParameter(engLink, engLink),
            //    new SqlParameter(engIP, engIP),
            //    new SqlParameter(bpOption, bpOption),
            //    new SqlParameter(bpComment, bpComment),
            //    new SqlParameter(id, id),
            //};
            string sql = "update TB_PT_PJ_PROJECTS set PJ_ENG_LINK = @engLink, PJ_ENG_IP = @engIP, PJ_BEST_PRACTICE = @bpOption, PJ_BEST_PRACTICE_COMMENT = @bpComment where PJ_CODIGO = @id";
            SqlParameter[] sqlparam =
            {
                new SqlParameter("@engLink", engLink),
                new SqlParameter("@engIP", engIP),
                new SqlParameter("@bpOption", bpOption),
                new SqlParameter("@bpComment", bpComment),
                new SqlParameter("@id", id),
            };
            ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
            instance.ExecuteSQL(sql, sqlparam);
        }
        
        private void UpdateCreator(int id, string creator)
        {
            //string sql = string.Format("update TB_PT_PJ_PROJECTS set PU_CRIADOR = '{0}' where PJ_CODIGO = {1}", creator, id.ToString());
            //string sCreatorID = string.Empty;
            string sql = "update TB_PT_PJ_PROJECTS set PU_CRIADOR = @creator where PJ_CODIGO = @sCreatorID";
            //sql = string.Format(sql, creator, id.ToString());
            SqlParameter[] parameter = {
                new SqlParameter ("@creator", creator),
                new SqlParameter ("@sCreatorID", id.ToString())
            };
            ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
            instance.ExecuteSQL(sql, parameter);
        }
        
        private void ddcStartDate_DayRenderClicked(object sender, DayRenderEventArgs e)
        {
            if ((e.Day.Date < minDate) || (e.Day.Date > maxDate))
            {
                e.Day.IsSelectable = false;
            }
        }
        
        protected void drpStatusCodeS_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (drpStatusCodeS.SelectedValue == "20")
            {
                tdClose.Visible = true;
                ddlPeriod.SelectedValue = "1"; // last quarter by default
                FromYearTxt.Text = DateTime.Today.AddMonths(-3).ToString(SDateFormat);
                ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
            }
            else
            {
                tdClose.Visible = false;
                FromYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
            }
        }
        
        protected void ddlPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (drpStatusCodeS.SelectedValue == "20") // Closed Option
            {
                int nPeriodSelected = Convert.ToInt32(ddlPeriod.SelectedValue);
                switch (nPeriodSelected)
                {
                    case 1:// last quarter
                        FromYearTxt.Text = DateTime.Today.AddMonths(-3).ToString(SDateFormat);
                        ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                        break;
                    case 2: // last 1 month
                        FromYearTxt.Text = DateTime.Today.AddMonths(-1).ToString(SDateFormat);
                        ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                        break;
                    case 3: // last 1 week
                        FromYearTxt.Text = DateTime.Today.AddDays(-7).ToString(SDateFormat);
                        ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                        break;
                    case 4: //custom
                        if (hdfDateChanged.Value == "false")
                        {
                            FromYearTxt.Text = DateTime.Today.AddMonths(-6).ToString(SDateFormat);
                            ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                        }
                        hdfDateChanged.Value = "false"; // to ensure we get the 3 months defined date from today, if the period value custom has been changed
                        break;
                    default:
                        FromYearTxt.Text = DateTime.Today.AddMonths(-3).ToString(SDateFormat);
                        ToYearTxt.Text = DateTime.Today.ToString(SDateFormat);
                        break;
                }
            }
        }
        
        private void DisplayMessage(bool isRecordAvailable)
        {
            StringBuilder sMsgText = new StringBuilder();
            if (drpStatusCodeS.SelectedIndex > -1 && drpRegionS.SelectedIndex > -1)
            {
                string sDisplayMsg = isRecordAvailable ? "Showing records for filter" : "No records available for filter";

                sMsgText.AppendFormat(" <b> {0} </b> : Status= <b>{1}</b>; Region= <b>{2}</b>;", sDisplayMsg, CheckmarxHelper.EscapeReflectedXss(drpStatusCodeS.SelectedItem.Text), CheckmarxHelper.EscapeReflectedXss(drpRegionS.SelectedItem.Text));
                
                if (!string.IsNullOrEmpty(txtDescription.Text))
                {
                    sMsgText.AppendFormat(" Description = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(txtDescription.Text));
                }
                if (!string.IsNullOrEmpty(txtProjectCode.Text))
                {
                    sMsgText.AppendFormat(" Code = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(txtProjectCode.Text));
                }
                if (drpResponsiblesS.SelectedIndex > 0)
                {
                    sMsgText.AppendFormat(" Responsible = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(drpResponsiblesS.SelectedItem.Text));
                }
                if (drpCategoriesS.SelectedIndex > 0)
                {
                    sMsgText.AppendFormat(" Category = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(drpCategoriesS.SelectedItem.Text));
                }
                if (drpLocationsS.SelectedIndex > 0)
                {
                    sMsgText.AppendFormat(" Location = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(drpLocationsS.SelectedItem.Text));
                }
                if (drpCustomersS.SelectedIndex > 0)
                {
                    sMsgText.AppendFormat(" Customer = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(drpCustomersS.SelectedItem.Text));
                }
                if (drpRevenueCostSaving.SelectedIndex > 0)
                {
                    sMsgText.AppendFormat(" Revenue/CostSaving = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(drpRevenueCostSaving.SelectedItem.Text));
                }
                if (drpSavingCategoryS.SelectedIndex > 0)
                {
                    sMsgText.AppendFormat(" Saving Category = <b> {0} </b>;", CheckmarxHelper.EscapeReflectedXss(drpSavingCategoryS.SelectedItem.Text));
                }
                if (drpStatusCodeS.SelectedIndex > -1 && drpStatusCodeS.SelectedValue == "20" && ddlPeriod.SelectedIndex > -1)
                {
                    sMsgText.AppendFormat(" Period=<b> {0} </b>; From Date= <b> {1} </b>; To Date= <b> {2} </b>;", CheckmarxHelper.EscapeReflectedXss(ddlPeriod.SelectedItem.Text), CheckmarxHelper.EscapeReflectedXss(FromYearTxt.Text), CheckmarxHelper.EscapeReflectedXss(ToYearTxt.Text));
                }
                if (isRecordAvailable)
                {
                    sMsgText.AppendLine(" <b><font color=\"red\">[Note: Search result includes Co-Responsible Projects, if available]</font></b> ");
                }
                lblMsg.Text = sMsgText.ToString();
            }
        }
        
        protected void drpAutoStage_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpAutoLevel = (DropDownList)FormView1.FindControl("drpAutoLevel");
            DropDownList drpStatusCode = FormView1.FindControl("drpStatusCode") as DropDownList;
            DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
            Control tbodyAutomationType = FormView1.FindControl("tbodyAutomationType");
            Control tbodyOtherAutomation = FormView1.FindControl("tbodyOtherAutomation");
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            Control tbodyCloseDeployOther = FormView1.FindControl("tbodyCloseDeployOther");
            Control tdLblPOAppvdDate = FormView1.FindControl("tdlblPoAppvdDate");
            Control tdPOAppvdDate = FormView1.FindControl("tdPoAppvdDate");

            tbodyAutomationType.Visible = true;
            
            if (drpAutoStage.SelectedValue.Equals("Define") || drpAutoStage.SelectedValue.Equals("Eval")) 
            {                    
                tbodyOtherAutomation.Visible = true;
                tbodyCloseInfo.Visible = false;
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyOpenDevelop)).Style.Add("display", "none");
                ((System.Web.UI.HtmlControls.HtmlControl)(tdLblPOAppvdDate)).Style.Add("display", "none");
                ((System.Web.UI.HtmlControls.HtmlControl)(tdPOAppvdDate)).Style.Add("display", "none");
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyPaidbyInfo)).Style.Add("display", "none");
                tbodyCloseDeployOther.Visible = false;
                if (drpStatusCode.SelectedValue == "21" || drpStatusCode.SelectedValue == "20")
                {
                    tbodyCloseInfo.Visible = drpStatusCode.SelectedValue == "20";
                    CleartbodyOpenDevelopControls();
                    CleartbodyPaidbyInfoControls();
                    ClearCloseInfoControls();
                    ClearCloseDeployControls();
                }                   
            }
            else if ((drpAutoStage.SelectedValue.Equals("Develop") || drpAutoStage.SelectedValue.Equals("Deploy")))
            {                    
                tbodyOtherAutomation.Visible = true;
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyOpenDevelop)).Style.Add("display", "block");
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyPaidbyInfo)).Style.Add("display", "block");
                tbodyCloseInfo.Visible = false;
                tbodyCloseDeployOther.Visible = false;
                if ((drpStatusCode.SelectedValue == "21"))
                {
                    ChangeFooterAutomationSaving(drpAutoStage.SelectedValue, drpStatusCode.SelectedValue); // Change Footer dropdown in cost saving grid 
                    ClearCloseInfoControls();
                    if (drpAutoStage.SelectedValue.Equals("Deploy"))
                    {
                        ClearCloseDeployControls();
                    }
                }
                else if (drpStatusCode.SelectedValue == "20")
                {
                    ClearCloseInfoControls();
                    if (drpAutoStage.SelectedValue.Equals("Develop"))
                    {
                        tbodyCloseInfo.Visible = true;
                        ClearCloseDeployControls();
                    }
                    else
                    {
                        ChangeFooterAutomationSaving(drpAutoStage.SelectedValue, drpStatusCode.SelectedValue); // Change Footer dropdown in cost saving grid 
                        tbodyCloseInfo.Visible = false;
                        tbodyCloseDeployOther.Visible = true;
                    }
                }                    
            }     
            EnableDevelopStageControls(!drpAutoStage.SelectedValue.Equals("Deploy"));
        }

        private void ChangeFooterAutomationSaving(string sAutoStage, string sStatus)
        {
            DataSet ds;
            GridView grd = (GridView)FormView1.FindControl("grdCostSavings");
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
            DropDownList drpFooterdrpAutomationSaving = (DropDownList)grd.FooterRow.FindControl("drpFooterdrpAutomationSaving");
            DropDownList ddlSavingType = (DropDownList)grd.FooterRow.FindControl("drpFooterSavingType");
            DropDownList ddlSavingCategory = (DropDownList)grd.FooterRow.FindControl("drpFooterSavingCategory");
            drpFooterdrpAutomationSaving.Items.Clear();
            AutomationSaving aSaving = new AutomationSaving();
            if (sAutoStage.Equals("Deploy") && sStatus.Equals("20"))
            {
                ds = (rblPaidFlex.SelectedValue == "C") ? aSaving.GetFooterData("CLOSEDEPLOYPAIDBYCUST") : aSaving.GetFooterData("CLOSEDEPLOYPAIDBYFLEX");
            }
            else
            {
                ds = aSaving.GetFooterData("");
            }            
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                drpFooterdrpAutomationSaving.Items.Add(new ListItem(dr["AutomationSaving"].ToString(), dr["ID"].ToString()));
            }
            drpFooterdrpAutomationSaving.SelectedIndex = 0;
            drpAutomationSaving_SelectedIndexChanged(drpFooterdrpAutomationSaving, null);
        }
        
        private void HideAutomationControls()
        {
            Control tbodyAutomationType = FormView1.FindControl("tbodyAutomationType");
            Control tbodyOtherAutomation = FormView1.FindControl("tbodyOtherAutomation");
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            Control tbodyCloseDeployOther = FormView1.FindControl("tbodyCloseDeployOther");
            //Control tbodyCapexAppvdDate = FormView1.FindControl("tbodyCapexAppvdDate");
            Control tdLblPOAppvdDate = FormView1.FindControl("tdlblPoAppvdDate");
            Control tdPOAppvdDate = FormView1.FindControl("tdPoAppvdDate");
            RequiredFieldValidator rfvPrjNumber = tbodyPaidbyInfo.FindControl("rfvPrjNumber") as RequiredFieldValidator;
            
            tbodyAutomationType.Visible = false;
            tbodyOtherAutomation.Visible = false;
            tbodyCloseInfo.Visible = false;
            ((System.Web.UI.HtmlControls.HtmlControl)(tbodyOpenDevelop)).Style.Add("display", "none");
            //((System.Web.UI.HtmlControls.HtmlControl)(tbodyCapexAppvdDate)).Style.Add("display", "none");
            ((System.Web.UI.HtmlControls.HtmlControl)(tdLblPOAppvdDate)).Style.Add("display", "none");
            ((System.Web.UI.HtmlControls.HtmlControl)(tdPOAppvdDate)).Style.Add("display", "none");
            ((System.Web.UI.HtmlControls.HtmlControl)(tbodyPaidbyInfo)).Style.Add("display", "none");
            tbodyCloseDeployOther.Visible = false;
            rfvPrjNumber.Enabled = false;
            //CleartbodyAutomationControls();
            ClearAutomationControls();
            CleartbodyOpenDevelopControls();
            CleartbodyPaidbyInfoControls();
            ClearCloseInfoControls();
            ClearCloseDeployControls();
        }
        
        private void CleartbodyAutomationControls()
        {
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            if (tbodyAutomation != null)
            {
                DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;
                DropDownList drpAutoLevel = tbodyAutomation.FindControl("drpAutoLevel") as DropDownList;
                drpAutoLevel.SelectedValue = "";
                drpAutoStage.SelectedValue = "";
                EnableAutomationType(drpAutoLevel.SelectedValue);
            }
        }
        
        private void CleartbodyOpenDevelopControls()
        {
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            if (tbodyOpenDevelop != null)
            {
                //RadioButtonList rblCapexAppd = tbodyOpenDevelop.FindControl("rblCapexAppd") as RadioButtonList;
                RadioButtonList rblPOIssued = tbodyOpenDevelop.FindControl("rblPOIssued") as RadioButtonList;
                TextBox txtCapexAppvdDate = FormView1.FindControl("ddcCapexAppvdDate") as TextBox;
                //rblCapexAppd.SelectedIndex = -1;
                rblPOIssued.SelectedIndex = -1;
                txtCapexAppvdDate.Text = string.Empty;
            }
        }
        
        private void CleartbodyPaidbyInfoControls()
        {
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            if (tbodyPaidbyInfo != null)
            {
                RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
                TextBox txtPrjNumber = tbodyPaidbyInfo.FindControl("txtPrjNumber") as TextBox;
                rblPaidFlex.SelectedIndex = -1;
                txtPrjNumber.Text = string.Empty;
            }
        }
        
        private void ClearCloseInfoControls()
        {
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            if (tbodyCloseInfo != null)
            {
                DropDownList drpCloseInfo = tbodyCloseInfo.FindControl("drpCloseInfo") as DropDownList;
                
                if (drpCloseInfo.SelectedValue.Equals("OTH"))
                {
                    drpCloseInfo.SelectedIndex = 0;
                    TextBox txtCloseOther = tbodyCloseInfo.FindControl("txtCloseOther") as TextBox;
                    txtCloseOther.Text = string.Empty;
                    txtCloseOther.Visible = false;
                }
                else
                {
                    drpCloseInfo.SelectedIndex = 0;
                }
            }
        }
        
        private void ClearCloseDeployControls()
        {
            Control tbodyCloseDeployOther = FormView1.FindControl("tbodyCloseDeployOther");
            if (tbodyCloseDeployOther != null)
            {
                TextBox txtOnePageSummary = tbodyCloseDeployOther.FindControl("txtOnePageSummary") as TextBox;
                TextBox txtReturnInvest = tbodyCloseDeployOther.FindControl("txtReturnInvest") as TextBox;
                TextBox txtVideoLink = tbodyCloseDeployOther.FindControl("txtVideoLink") as TextBox;
                txtOnePageSummary.Text = string.Empty;
                txtReturnInvest.Text = string.Empty;
                txtVideoLink.Text = string.Empty;
            }
        }
        
        private void ClearAutomationControls()
        {
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            TextBox txtReuse = tbodyAutomation.FindControl("txtReuse") as TextBox;
            TextBox txtAutomationProjectCost = tbodyAutomation.FindControl("txtAutomationProjectCost") as TextBox;
            TextBox txtPlannedPaybackinMonths = tbodyAutomation.FindControl("txtPlannedPaybackinMonths") as TextBox;
            TextBox txtEstimatedProductLifeinMonths = tbodyAutomation.FindControl("txtEstimatedProductLifeinMonths") as TextBox;
            TextBox txtHeadcountBeforeAutomation = tbodyAutomation.FindControl("txtHeadcountBeforeAutomation") as TextBox;
            TextBox txtHeadcountAfterAutomation = tbodyAutomation.FindControl("txtHeadcountAfterAutomation") as TextBox;
            TextBox txtEstimatedROIafterendoflife = tbodyAutomation.FindControl("txtEstimatedROIafterendoflife") as TextBox;
            TextBox txtExpectedIrr = tbodyAutomation.FindControl("txtExpectedIRR") as TextBox;
            //DropDownList drpAutomationType = tbodyAutomation.FindControl("drpAutomationType") as DropDownList;
            TextBox txtHoldReason = tbodyAutomation.FindControl("txtHoldReason") as TextBox;
            
            hdfReuse.Value = txtReuse.Text = string.Empty;
            hdfProjCost.Value = txtAutomationProjectCost.Text = string.Empty;
            hdfPlannedPaybackinMonths.Value = txtPlannedPaybackinMonths.Text = string.Empty;
            hdfEstimatedProductLifeinMonths.Value = txtEstimatedProductLifeinMonths.Text = string.Empty;
            hdfHeadcountBeforeAutomation.Value = txtHeadcountBeforeAutomation.Text = string.Empty;
            hdfHeadcountAfterAutomation.Value = txtHeadcountAfterAutomation.Text = string.Empty;
            hdfEstimatedROIafterendoflife.Value = txtEstimatedROIafterendoflife.Text = string.Empty;
            hdfExpectedIRR.Value = txtExpectedIrr.Text = string.Empty;
            //drpAutomationType.SelectedValue = "";
            hdfHoldReason.Value = txtHoldReason.Text = string.Empty;
        }
        
        //private bool CheckIfValid()
        //{
        //    DropDownList drpAutoLevel = (DropDownList)FormView1.FindControl("drpAutoLevel");
        //    DropDownList drpStatusCode = FormView1.FindControl("drpStatusCode") as DropDownList;
        //    DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
        //    if (drpAutoLevel.SelectedItem != null && drpStatusCode.SelectedItem != null && drpAutoStage.SelectedItem != null &&
        //        (drpAutoLevel.SelectedValue != string.Empty && drpAutoLevel.SelectedValue != "NA") &&
        //        (drpStatusCode.SelectedValue != string.Empty) &&
        //        (drpAutoStage.SelectedValue != string.Empty && drpAutoStage.SelectedValue != "N/A")
        //    )
        //    {
        //        return true;
        //    }
        //    return false;
        //}
        
        protected void drpCloseInfo_SelectedIndexChanged(object sender, EventArgs e)
        {
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            Control tdCloseOther = tbodyCloseInfo.FindControl("tdCloseOther");
            DropDownList drpCloseInfo = (DropDownList)FormView1.FindControl("drpCloseInfo");
            RequiredFieldValidator rfvCloseOther = tbodyCloseInfo.FindControl("rfvCloseOther") as RequiredFieldValidator;
            TextBox txtCloseOther = tbodyCloseInfo.FindControl("txtCloseOther") as TextBox;
            rfvCloseOther.Enabled = false;
            txtCloseOther.Visible = false;
            tdCloseOther.Visible = false;
            if (drpCloseInfo.SelectedItem != null && drpCloseInfo.SelectedItem.Value.Equals("OTH"))
            {
                tdCloseOther.Visible = true;
                txtCloseOther.Visible = true;
                txtCloseOther.Text = string.Empty;
            }
        }
        
        protected void drpCloseInfo_DataBound(object sender, EventArgs e)
        {
            DropDownList drpCloseInfo = (DropDownList)sender;
            Utility.AddEmptyItem(drpCloseInfo);
        }

        private void EnableDevelopStageControls(bool enable)
        {
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            DropDownList drpStatus = FormView1.FindControl("drpStatusCode") as DropDownList;   
            if (tbodyOpenDevelop != null)
            {  
                RadioButtonList rblPOIssued = tbodyOpenDevelop.FindControl("rblPOIssued") as RadioButtonList;
                
                RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
                TextBox txtPrjNumber = tbodyPaidbyInfo.FindControl("txtPrjNumber") as TextBox;
                TextBox txtCapexAppvdDate = FormView1.FindControl("ddcCapexAppvdDate") as TextBox;

                if (drpStatus.SelectedValue.Equals("20") && string.IsNullOrEmpty(txtPrjNumber.Text) && !enable)
                {
                    enable = true;
                }
                rblPOIssued.Enabled = enable;
                rblPaidFlex.Enabled = enable;
                txtPrjNumber.Enabled = enable;
                txtCapexAppvdDate.Enabled = enable;
            }
        }

        protected void odsAutomationSavingFooter_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            DropDownList drpStatusCode = FormView1.FindControl("drpStatusCode") as DropDownList;
            DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
            bool isCloseDeployFlex = drpStatusCode.SelectedValue.Equals("20") && drpAutoStage.SelectedValue.Equals("Deploy") && rblPaidFlex.SelectedValue.Equals("F");
            bool isCloseDeployCustomer = drpStatusCode.SelectedValue.Equals("20") && drpAutoStage.SelectedValue.Equals("Deploy") && rblPaidFlex.SelectedValue.Equals("C");
            if (isCloseDeployFlex)
            {
                e.InputParameters["cStatus"] = "CLOSEDEPLOYPAIDBYFLEX";
            }
            else if (isCloseDeployCustomer)
            {
                e.InputParameters["cStatus"] = "CLOSEDEPLOYPAIDBYCUST";
            }
            else
            {
                e.InputParameters["cStatus"] = "";
            }
        }

        protected void rblPaidFlex_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpStatusCode = FormView1.FindControl("drpStatusCode") as DropDownList;
            DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            Control tdLblPOAppvdDate = FormView1.FindControl("tdlblPoAppvdDate");
            Control tdPOAppvdDate = FormView1.FindControl("tdPoAppvdDate");
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
            RadioButtonList rblPOIssued = tbodyOpenDevelop.FindControl("rblPOIssued") as RadioButtonList;
            TextBox txtPrjNumber = tbodyPaidbyInfo.FindControl("txtPrjNumber") as TextBox;
            if (rblPaidFlex.SelectedValue.Equals("C"))
            {
                txtPrjNumber.Enabled = false;
                txtPrjNumber.Text = string.Empty;
            }
            else
            {
                txtPrjNumber.Enabled = true;
            }
            
            if (drpAutoStage.SelectedValue.Equals("Deploy") && drpStatusCode.SelectedValue.Equals("20"))
            {
                ChangeFooterAutomationSaving(drpAutoStage.SelectedValue, drpStatusCode.SelectedValue);
            }
            if (rblPOIssued.SelectedValue.Equals("Y"))
            {
                ((System.Web.UI.HtmlControls.HtmlControl)(tdLblPOAppvdDate)).Style.Add("display", "block");
                ((System.Web.UI.HtmlControls.HtmlControl)(tdPOAppvdDate)).Style.Add("display", "block");
            }
            else
            {
                ((System.Web.UI.HtmlControls.HtmlControl)(tdLblPOAppvdDate)).Style.Add("display", "none");
                ((System.Web.UI.HtmlControls.HtmlControl)(tdPOAppvdDate)).Style.Add("display", "none");
            }
        }

        protected void drpSegment_DataBound(object sender, EventArgs e)
        {
            //Add Item with empty value
            DropDownList drpSegment = (DropDownList)sender;
            if (FormView1.CurrentMode == FormViewMode.Edit && mvViewers.ActiveViewIndex == 1)
            {                
                int segmentCode = Convert.ToInt32(gvProjects.SelectedDataKey[8]);
                string segmentDesc = gvProjects.SelectedDataKey[9].ToString();
                int statusCode = Convert.ToInt32(gvProjects.SelectedDataKey[1]);
                Utility.AddEmptyItem(drpSegment);
                ListItem item = drpSegment.Items.FindByValue(segmentCode.ToString());
                if (item != null)
                {   
                    drpSegment.SelectedValue = CheckmarxHelper.EscapeReflectedXss(item.Value);
                    drpSegment.Enabled = true;
                }
                else
                {
                    if (statusCode == 20 || statusCode == 22 || statusCode == 23)
                    {
                        int count = drpSegment.Items.Count;
                        if (count > 0)
                        {
                            ListItem li = new ListItem(segmentDesc, segmentCode.ToString());
                            drpSegment.Items.Insert(count, li);
                            drpSegment.SelectedIndex = count;
                        }
                        drpSegment.Enabled = false;
                    }
                    else
                    {
                        //Utility.AddEmptyItem(drpSegment);
                        drpSegment.SelectedIndex = 0;
                        drpSegment.Enabled = true;
                    }
                    
                }
            }
            else
            {
                Utility.AddEmptyItem(drpSegment, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
            }
        }
    }
}