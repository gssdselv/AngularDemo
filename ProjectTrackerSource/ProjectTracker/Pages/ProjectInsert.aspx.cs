using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FIT.SCO.Common;
using Fit.Base;
using Library.Email;
using ProjectTracker.Business;
using ProjectTracker.Common;
using ProjectTracker.DAO;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using System.Security.Principal;

namespace ProjectTracker.Pages
{
    public partial class ProjectInsert : BasePage
    {
        private string[] toAdresses = new string[1];
        private string[] fromAdress = new string[2];
        private ADUserSelect createrName;
        private ADUserSelect responsibleName;
        private string description = "";
        private bool cancelSendMail = true;
        public string[] PageCallOuts = new string[23];

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verify if user is responsible...
                // Get the username...
                string username = GetUsername();
                // If not, redirect to ProjectTracker.aspx
                ResponsibleTableAdapter taResponsible = new ResponsibleTableAdapter();
                if (Convert.ToInt32(taResponsible.UserExist(username)) <= 0)
                {
                    Response.Redirect("ProjectCad.aspx?r=" + CheckmarxHelper.CryptoRandomString());
                }
                // Add user name to session..
                Session.Remove("UsernameProjectInsert");
                Session["UsernameProjectInsert"] = username;

                hfCostSavingAlertValue.Value = ConfigurationManager.AppSettings["CostSavingAlertValue"];
                HttpContext old_Context = HttpContext.Current;
                CostSavingDataSource.ClearSession(old_Context);
                //CostSavingDataSource.ClearSession();
            }
        }

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

        protected void drpAutoStage_DataBound(object sender, EventArgs e)
        {
            DropDownList drpAutoStage = (DropDownList)sender;
            Utility.AddEmptyItem(drpAutoStage);
        }

        protected void drpCategories_DataBound(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            Utility.AddEmptyItem(ddl);
            if (ddl.DataSourceID.Equals("obsCategories"))
            {
                ddl.Items.FindByText("Automation").Selected = true; // Default Catrgory - Automation
                ddl.Enabled = false;
                drpCategoriesOnChange();
            }
        }
        private void drpCategoriesOnChange()
        {
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            AjaxControlToolkit.TextBoxWatermarkExtender twPrjDesc = (AjaxControlToolkit.TextBoxWatermarkExtender)FormView1.FindControl("twPrjDesc");
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            GridView grdCostSavings = FormView1.FindControl("grdCostSavings") as GridView;
            string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
            int pos = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
            if (pos > -1)
            {
                tbodyAutomation.Visible = true;
                grdCostSavings.Columns[0].Visible = true;
                twPrjDesc.Enabled = true;
            }
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

        protected void drpAutomationSaving_DataBound(object sender, EventArgs e)
        {
            
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
            Utility.AddEmptyItem(drpCustomers, "", HttpContext.GetGlobalResourceObject("Default", "ALL").ToString());
        }

        protected void obsDataSource_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            object id = e.ReturnValue;
            string automationHeadEmail = string.Empty;
            UpdateEngReportInfor(id.ToString(), hdfEngLink.Value, hdfEngIP.Value, hdfrbBestPractice.Value, hdftxtBestPractice.Value);

            //Update of Automation fields
            DropDownList drpCategories = (DropDownList)FormView1.FindControl("drpCategories");
            if (drpCategories.SelectedItem != null)
            {
                string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');
                int pos = Array.IndexOf(codesToEnable, drpCategories.SelectedItem.Value);
                if (pos > -1)
                {
                    UpdateAutomationTDInfor(System.Convert.ToInt32(id));
                    //automationHeadEmail = ConfigurationManager.AppSettings["AutomationHeadEmail"].ToString();
                    DropDownList drpRegion = FormView1.FindControl("drpRegion") as DropDownList;
                    if (drpRegion != null)
                    {
                        ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
                        string sRegionValue = string.Empty;
                        //string sql = string.Format("SELECT PRE_AUTOMATION_EMAIL from TB_PT_PRE_REGIONS WHERE PRE_CODIGO = '{0}'", sRegionValue);
                        string sql = "SELECT PRE_AUTOMATION_EMAIL from TB_PT_PRE_REGIONS WHERE PRE_CODIGO = @RegionValue";
                        SqlParameter[] parameters =
                            { //new SqlParameter(sRegionValue, drpRegion.SelectedValue) };
                                new SqlParameter("@RegionValue", Convert.ToInt32(drpRegion.SelectedValue)) };
                        object objGetAutomationHeadEmail = instance.GetSingle(sql, parameters);
                        automationHeadEmail = objGetAutomationHeadEmail.ToString();
                    }
                }
            }

            if (e.Exception != null)
            {
                return;
            }

            CostSavingDataSource costSavingDataSource = new CostSavingDataSource();
            costSavingDataSource.PersistCostSavingList(Convert.ToInt32(id));

            #region Add Other Locations

            ArrayList array = Session["GridOthersLocations"] as ArrayList;
            ProjectLocationTableAdapter tbAdptProjectLocations = new ProjectLocationTableAdapter();
            for (int y = 0; y < array.Count; y++)
            {
                tbAdptProjectLocations.Insert(Convert.ToInt32(id), Convert.ToInt32(array[y]));
            }

            #endregion
            
            #region send Email to notify operation and add Co-Responsibles

            //Get Id of the project created
            
            //Add All Co-Responsible
            ArrayList arr = (ArrayList)Session["GridOthersResponsibles"];
            string[] toCoResponsibles = new string[arr.Count + 2];
            toCoResponsibles[0] = toAdresses[0];
            toCoResponsibles[1] = ConfigurationManager.AppSettings["ReceiversClosedEmail"].ToString();
            //string conditionalReceiver = ConfigurationManager.AppSettings["ConditionalReceiversClosedEmail"];
            //bool includeConditional = CheckIncludeConditional(GetUsername());            
            ProjectTracker.Business.User u = new ProjectTracker.Business.User();
            
            #region Insert Co-Responsibles and Get yours emails to send a notify
            
            ResponsiblesProjectsTableAdapter respTbAdpt = new ResponsiblesProjectsTableAdapter();
            for (int i = 0; i < arr.Count; i++)
            {
                respTbAdpt.InsertQuery(Convert.ToInt32(id), arr[i].ToString());
                
                #region Get Co-Responsibles Email

                //Get User at Ad
                ADUserSelect userADFrom = u.GetUser(arr[i].ToString());
                
                if (userADFrom != null)
                {
                    string emailAddress = userADFrom.Email;
                    toCoResponsibles[i + 2] = emailAddress;
                }
                
                #endregion
            }
            Session.Remove("GridOthersResponsibles");
            
            #endregion
            
            //Initialize objects to get Co-Responsibles emails 
            //Capture responsible username to send email
            
            #region Notify sucess message about insert operation
            
            if (e.Exception == null)
            {
                //MessagePanel1.ShowInsertSucessMessage(); Commented by Guoxin 2011-06-09
                MessagePanel1.ShowInsertProjectSucessMessage(System.Convert.ToInt32(id)); //Added by Guoxin 2011-06-09
               
                if (cancelSendMail == false)
                {
                    string message = "";
                    string subject = "";
                    
                    #region Prepare Message
                    
                    message = String.Format(ConfigurationManager.AppSettings["MessageEmailProject"].ToString(), createrName.FullName, description, responsibleName.FullName, id.ToString());
                    subject = "New Project - Project Tracker.";
                    
                    #endregion
                    
                    Email email = new Email();
                    
                    #region SendEmail
                    
                    if (Convert.ToBoolean(ConfigurationManager.AppSettings["ActiveSendEmail"]))
                    {
                        string managerMail = GetMailManager();
                        string[] cc =
                                     !string.IsNullOrEmpty(automationHeadEmail) ? new string[] { fromAdress[0], fromAdress[1], managerMail, automationHeadEmail } :
                                      new string[] { fromAdress[0], fromAdress[1], managerMail };
                        //string[] cc =
                        //             includeConditional ? new string[] { fromAdress[0], fromAdress[1], managerMail, conditionalReceiver } :
                        //              new string[] { fromAdress[0], fromAdress[1], managerMail };
                        
                        email.SendEmail(message, subject, fromAdress[0], toCoResponsibles, cc);
                    }
                    
                    #endregion
                }
            }
            
            #endregion
            
            #endregion
        }
        
        private void UpdateEngReportInfor(string id, string engLink, string engIP, string bpOption, string bpComment)
        {
            //string sql = string.Format("update TB_PT_PJ_PROJECTS set PJ_ENG_LINK = '{0}', PJ_ENG_IP = {1}, PJ_BEST_PRACTICE = '{2}', PJ_BEST_PRACTICE_COMMENT = '{3}' where PJ_CODIGO = {4}", engLink, engIP, bpOption, bpComment, id);
            string sql = "update TB_PT_PJ_PROJECTS set PJ_ENG_LINK = @engLink, PJ_ENG_IP = @engIP, PJ_BEST_PRACTICE = @bpOption, PJ_BEST_PRACTICE_COMMENT = @bpComment where PJ_CODIGO = @id";
            SqlParameter[] sqlparam =
            {
                new SqlParameter("@engLink", engLink),
                new SqlParameter("@engIP", engIP),
                new SqlParameter("@bpOption", bpOption),
                new SqlParameter("@bpComment", bpComment),
                new SqlParameter("@id", id),
            };
            //sql = string.Format(sql, engLink, engIP.ToString(), id.ToString());
            SQLDBHelper instance = new SQLDBHelper();
            instance.ExecuteSQL(sql, sqlparam);
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
            catch (Exception)
            {
            }
        }
        
        private bool CheckIncludeConditional(string username)
        {
            EmailExceptionsTableAdapter adapter = new EmailExceptionsTableAdapter();
            object quantity = adapter.GetQuantityByUserName(username);
            
            return (quantity == null || Convert.ToInt32(quantity) == 0);
        }
        
        protected void obsProjects_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            ArrayList arr = new ArrayList();
            Hashtable hash = new Hashtable();
            
            ListBox list = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            
            foreach (ListItem item in list.Items)
            {
                if (!hash.ContainsKey(item.Value))
                {
                    arr.Add(item.Value);
                    hash.Add(item.Value, item.Value);
                }
            }
            
            // Email to region responsible - MM - 05/22/2007
            
            // Get the region dropdownlist...
            DropDownList drpRegion = FormView1.FindControl("drpRegion") as DropDownList;
            // If control exist...
            if (drpRegion != null)
            {
                fromAdress[1] = string.Empty;
                // Create a table adapter instance and get the email to the current region...
                RegionsTableAdapter taRegion = new RegionsTableAdapter();
                string regionEmail = taRegion.GetRegionEmail(Convert.ToInt32(drpRegion.SelectedValue));
                // Verify if you get a valid e-mail address...
                if (regionEmail != null && regionEmail != String.Empty)
                {
                    // TODO: Remove this BAD FIX.
                    // Add in the last from adresses adress..BAD FIX MM 05/22/2007
                    fromAdress[1] = regionEmail;
                }                
            }
            //Session["GridOthersResponsibles"] = null;
            Session.Remove("GridOthersResponsibles");
            Session["GridOthersResponsibles"] = arr;
            ArrayList arr1 = new ArrayList();
            Hashtable hash1 = new Hashtable();
            ListBox list1 = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            foreach (ListItem item in list1.Items)
            {
                if (!hash1.ContainsKey(item.Value))
                {
                    arr1.Add(item.Value);
                    hash1.Add(item.Value, item.Value);
                }
            }
            //Session["GridOthersLocations"] = null;
            Session.Remove("GridOthersLocations");
            Session["GridOthersLocations"] = arr1;
            
            ProjectsTableAdapter projectsTbAdpt = new ProjectsTableAdapter();
            object qtd = projectsTbAdpt.QuantityDescription(e.InputParameters["Description"].ToString(), "%");
            
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
            
            TextBox txtRemarks = (TextBox)FormView1.FindControl("txtRemarks");
            e.InputParameters["Remarks"] = txtRemarks.Text;
            
            // Automation Enhancement
            TextBox txtBULead = (TextBox)FormView1.FindControl("txtBULead");
            e.InputParameters["BULead"] = txtBULead.Text;
            // Automation Enhancement - End
            
            // Retrieve values...
            DropDownCalendar cld = FormView1.FindControl("ddcOpenDate") as DropDownCalendar;
            if (cld != null && !String.IsNullOrEmpty(cld.SelectedDateText))
            {
                e.InputParameters["OpenDate"] = cld.SelectedDate;
            }
            cld = FormView1.FindControl("ddcCommitDate") as DropDownCalendar;
            if (cld != null && !String.IsNullOrEmpty(cld.SelectedDateText))
            {
                e.InputParameters["CommitDate"] = cld.SelectedDate;
            }
            cld = FormView1.FindControl("ddcClosedDate") as DropDownCalendar;
            if (cld != null && !String.IsNullOrEmpty(cld.SelectedDateText))
            {
                e.InputParameters["ClosedDate"] = cld.SelectedDate;
            }
            
            TextBox txtPercentCompletion = FormView1.FindControl("txtPercentCompletion") as TextBox;
            e.InputParameters["PercentCompletion"] = txtPercentCompletion.Text;
            
            TextBox txtEngReportLink = FormView1.FindControl("txtEngReportLink") as TextBox;
            RadioButton rdoIPYes = FormView1.FindControl("rdoIPYes") as RadioButton;
            RadioButton rdoIPNo = FormView1.FindControl("rdoIPNo") as RadioButton;
            hdfEngIP.Value = rdoIPYes.Checked ? "1" : rdoIPNo.Checked ? "0" : "-1";
            hdfEngLink.Value = CheckmarxHelper.EscapeReflectedXss(txtEngReportLink.Text.Trim());
            RadioButtonList rblBestPractice = FormView1.FindControl("rblBestPractice") as RadioButtonList;
            TextBox txtBPComment = FormView1.FindControl("txtBPComment") as TextBox;
            hdfrbBestPractice.Value = CheckmarxHelper.EscapeReflectedXss(rblBestPractice.SelectedValue);
            hdftxtBestPractice.Value = hdfrbBestPractice.Value.Equals("Y") ? CheckmarxHelper.EscapeReflectedXss(txtBPComment.Text) : string.Empty;
        }
        
        private void SetValuesBasedOnStage(string sStatus)
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
            hdfHoldReason.Value = "";
            hdfVideoLink.Value = "";
            hdfROILink.Value = "";
            hdfSummaryLink.Value = "";
            hdfCloseReason.Value = "";
            hdfCloseRemarks.Value = "";
            
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;
            SetAutomationLevelStageControls();
            if (drpAutoStage.SelectedValue.Equals("Define") || drpAutoStage.SelectedValue.Equals("Eval"))
            {
                SetAutomationOpenDefineControls();
                if (sStatus == "20")
                {
                    SetCloseInfoControls();
                }
            }
            else if ((drpAutoStage.SelectedValue.Equals("Develop") || drpAutoStage.SelectedValue.Equals("Deploy")))
            {
                SetAutomationOpenDefineControls();
                SettbodyOpenDevelopControls();
                SettbodyPaidbyInfoControls();
                if (sStatus == "20")
                {
                    if (drpAutoStage.SelectedValue.Equals("Develop"))
                    {
                        SetCloseInfoControls();
                    }
                    else
                    {
                        SetCloseDeployControls();
                    }
                }
            }           
        }

        private void SetAutomationLevelStageControls()
        {
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            DropDownList drpAutoLevel = tbodyAutomation.FindControl("drpAutoLevel") as DropDownList;
            DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;
            DropDownList drpAutomationType = tbodyAutomation.FindControl("drpAutomationType") as DropDownList;
            hdfAutoLevel.Value = CheckmarxHelper.EscapeReflectedXss(drpAutoLevel.SelectedValue);
            hdfAutoStage.Value = CheckmarxHelper.EscapeReflectedXss(drpAutoStage.SelectedValue);
            hdfAutoType.Value = CheckmarxHelper.EscapeReflectedXss(drpAutomationType.SelectedValue);
        }
        
        private void SetAutomationOpenDefineControls()
        {
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            //DropDownList drpAutomationType = tbodyAutomation.FindControl("drpAutomationType") as DropDownList;
            TextBox txtAutomationProjectCost = tbodyAutomation.FindControl("txtAutomationProjectCost") as TextBox;
            TextBox txtReuse = tbodyAutomation.FindControl("txtReuse") as TextBox;
            TextBox txtPlannedPaybackinMonths = tbodyAutomation.FindControl("txtPlannedPaybackinMonths") as TextBox;
            TextBox txtEstimatedProductLifeinMonths = tbodyAutomation.FindControl("txtEstimatedProductLifeinMonths") as TextBox;
            TextBox txtHeadcountBeforeAutomation = tbodyAutomation.FindControl("txtHeadcountBeforeAutomation") as TextBox;
            TextBox txtHeadcountAfterAutomation = tbodyAutomation.FindControl("txtHeadcountAfterAutomation") as TextBox;
            TextBox txtEstimatedROIafterendoflife = tbodyAutomation.FindControl("txtEstimatedROIafterendoflife") as TextBox;
            TextBox txtExpectedIrr = tbodyAutomation.FindControl("txtExpectedIRR") as TextBox;
            TextBox txtHoldReason = tbodyAutomation.FindControl("txtHoldReason") as TextBox;

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
        
        private void SettbodyOpenDevelopControls()
        {
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            if (tbodyOpenDevelop != null)
            {
                RadioButtonList rblPOIssued = tbodyOpenDevelop.FindControl("rblPOIssued") as RadioButtonList;
                TextBox txtCapexAppvdDate = FormView1.FindControl("ddcCapexAppvdDate") as TextBox;
                Control tdLblPOAppvdDate = FormView1.FindControl("tdlblPoAppvdDate");
                Control tdPOAppvdDate = FormView1.FindControl("tdPoAppvdDate");
                hdfPOIssued.Value = CheckmarxHelper.EscapeReflectedXss(rblPOIssued.SelectedValue);
                hdfCapexAppdDate.Value = hdfPOIssued.Value.Equals("Y") ? CheckmarxHelper.EscapeReflectedXss(txtCapexAppvdDate.Text) : string.Empty;
            }
        }
        
        private void SettbodyPaidbyInfoControls()
        {
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            if (tbodyPaidbyInfo != null)
            {
                RadioButtonList rblPaidFlex = tbodyPaidbyInfo.FindControl("rblPaidFlex") as RadioButtonList;
                TextBox txtPrjNumber = tbodyPaidbyInfo.FindControl("txtPrjNumber") as TextBox;
                hdfFlexPaid.Value = CheckmarxHelper.EscapeReflectedXss(rblPaidFlex.SelectedValue);               
                hdfPrjNumber.Value = CheckmarxHelper.EscapeReflectedXss(txtPrjNumber.Text);
            }
        }
        
        private void SetCloseInfoControls()
        {
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            if (tbodyCloseInfo != null)
            {
                DropDownList drpCloseInfo = tbodyCloseInfo.FindControl("drpCloseInfo") as DropDownList;
                hdfCloseReason.Value = CheckmarxHelper.EscapeReflectedXss(drpCloseInfo.SelectedValue);
                if (drpCloseInfo.SelectedValue.Equals("OTH"))
                {
                    TextBox txtCloseOther = tbodyCloseInfo.FindControl("txtCloseOther") as TextBox;
                    hdfCloseRemarks.Value = CheckmarxHelper.EscapeReflectedXss(txtCloseOther.Text);
                }
            }
        }
        
        private void SetCloseDeployControls()
        {
            Control tbodyCloseDeployOther = FormView1.FindControl("tbodyCloseDeployOther");
            if (tbodyCloseDeployOther != null)
            {
                TextBox txtOnePageSummary = tbodyCloseDeployOther.FindControl("txtOnePageSummary") as TextBox;
                TextBox txtReturnInvest = tbodyCloseDeployOther.FindControl("txtReturnInvest") as TextBox;
                TextBox txtVideoLink = tbodyCloseDeployOther.FindControl("txtVideoLink") as TextBox;
                hdfSummaryLink.Value = CheckmarxHelper.EscapeReflectedXss(txtOnePageSummary.Text);
                hdfVideoLink.Value = CheckmarxHelper.EscapeReflectedXss(txtVideoLink.Text);
                hdfROILink.Value = CheckmarxHelper.EscapeReflectedXss(txtReturnInvest.Text);
            }
        }
        
        protected void imgBtnAddOtherResp_Click(object sender, ImageClickEventArgs e)
        {
            RequiredFieldValidator rqd = (RequiredFieldValidator)FormView1.FindControl("rqdOtherResp");
            rqd.Validate();
            if (!rqd.IsValid)
            {
                return;
            }            
            Control ctrl = FormView1.FindControl("drpOtherResponsibles");            
            DropDownList drpOtherResponsibles = (DropDownList)ctrl;            
            ListBox list = (ListBox)FormView1.FindControl("lstResponsiblesAdded");            
            OtherResponsible responsible = new OtherResponsible();
            drpOtherResponsibles.SelectedItem.Enabled = false;
            responsible.CodeUsername = drpOtherResponsibles.SelectedValue;
            list.Items.Add(new ListItem(drpOtherResponsibles.SelectedItem.Text, drpOtherResponsibles.SelectedItem.Value));
        }
        
        /// <summary>
        /// Fill GridView with Other Reponsibles will be cadastred
        /// </summary>
        /// <param name="arrayResponsibles">Array with Responsibles</param>
        public void FillGridResponsibles(ArrayList arrayResponsibles)
        {
            GridView gvOthersResponsibles = (GridView)FormView1.FindControl("gvOtherResponsibles");
            gvOthersResponsibles.DataSource = arrayResponsibles;
            gvOthersResponsibles.DataBind();
        }
        
        protected void gvOtherResponsibles_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            ListBox list = (ListBox)FormView1.FindControl("lstResponsiblesAdded");
            DropDownList drp = (DropDownList)FormView1.FindControl("drpOtherResponsibles");
            
            string username = list.SelectedValue;
            
            ListItem item = drp.Items.FindByValue(username);
            if (item != null)
            {
                item.Enabled = true;
            }
        }
        
        protected void drpOtherResponsibles_DataBound(object sender, EventArgs e)
        {
            Utility.AddEmptyItem((DropDownList)sender);
        }
        
        protected void ImageButton3_Click(object sender, ImageClickEventArgs e)
        {
            ListBox list = (ListBox)FormView1.FindControl("lstResponsiblesAdded");
            DropDownList drp = (DropDownList)FormView1.FindControl("drpOtherResponsibles");
            
            if (list.SelectedIndex < 0)
            {
                return;
            }
            string username = list.SelectedValue;
            
            ListItem item = drp.Items.FindByValue(username);
            if (item != null)
            {
                item.Enabled = true;
                list.Items.RemoveAt(list.SelectedIndex);
                list.SelectedIndex = -1;
            }
        }
        
        protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
        {
            ListBox list = (ListBox)FormView1.FindControl("lstResponsiblesAdded");
            ArrayList arr = new ArrayList();
            string sResponsible = string.Empty;
            Hashtable hash = new Hashtable();
            foreach (ListItem item in list.Items)
            {
                if (!hash.ContainsKey(item.Value))
                {                    
                    sResponsible = CheckmarxHelper.EscapeReflectedXss(item.Value);
                    if (!string.IsNullOrEmpty(sResponsible))
                    {
                        arr.Add(sResponsible);
                        hash.Add(sResponsible, item.Text);
                    }
                }
            }
            Session.Remove("GridOthersResponsibles");
            Session["GridOthersResponsibles"] = arr;
            //Session.Add("GridOthersResponsibles", arr);
        }
        
        protected void FormView1_DataBound(object sender, EventArgs e)
        {            
            string[] usernameDomain = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernameDomain[usernameDomain.Length - 1];
            string name = ProjectTracker.Business.User.Name(username);
            Label lblUsername = FormView1.FindControl("lblUsername") as Label;
            lblUsername.Text = name;
        }
        
        protected void btnMoveCoRespL_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoRespsAvaiable = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListBox lstCoRespsToInsert = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            DropDownList drpResponsible = (DropDownList)FormView1.FindControl("drpResponsibles");
            ListItem itemToTransf = new ListItem(lstCoRespsToInsert.SelectedItem.Text, lstCoRespsToInsert.SelectedItem.Value);
            if (itemToTransf.Value != drpResponsible.SelectedValue)
            {
                lstCoRespsToInsert.Items.Remove(lstCoRespsToInsert.SelectedItem);
                lstCoRespsAvaiable.Items.Add(itemToTransf);
            }
            
            Utility.OrderListBox(lstCoRespsAvaiable);
            
            if (lstCoRespsToInsert.Items.Count > 0)
            {
                lstCoRespsToInsert.SelectedIndex = -1;
            }
            
            if (lstCoRespsAvaiable.Items.Count > 0)
            {
                lstCoRespsAvaiable.SelectedIndex = -1;
            }
        }
        
        protected void btnMoveCoRespR_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoRespsAvaiable = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListBox lstCoRespsToInsert = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            DropDownList drpResponsible = (DropDownList)FormView1.FindControl("drpResponsibles");
            
            ListItem itemToTransf = new ListItem(lstCoRespsAvaiable.SelectedItem.Text, lstCoRespsAvaiable.SelectedItem.Value);
            
            if (itemToTransf.Value != drpResponsible.SelectedValue)
            {
                lstCoRespsAvaiable.Items.Remove(lstCoRespsAvaiable.SelectedItem);
                lstCoRespsToInsert.Items.Add(itemToTransf);
                
                Utility.OrderListBox(lstCoRespsToInsert);
            }
            
            if (lstCoRespsToInsert.Items.Count > 0)
            {
                lstCoRespsToInsert.SelectedIndex = -1;
            }
            
            if (lstCoRespsAvaiable.Items.Count > 0)
            {
                lstCoRespsAvaiable.SelectedIndex = -1;
            }
        }
        
        protected void drpResponsibles_SelectedIndexChanged(object sender, EventArgs e)
        {
            ListBox lstCoRespsAvaiable = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            ListBox lstCoRespsToInsert = (ListBox)FormView1.FindControl("lstCoRespsToInsert");
            
            string responsibleCode = ((DropDownList)sender).SelectedValue;

            #region Disable Co-Responsible equal that Responsible of this project
            
            ListBox list = (ListBox)FormView1.FindControl("lstCoRespsAvaiable");
            
            foreach (ListItem item in list.Items)
            {
                item.Enabled = true;
            }
            ListItem item1 = FindByValue(list, responsibleCode);
            if (item1 != null)
            {
                item1.Enabled = false;
            }
            
            ListBox list1 = (ListBox)FormView1.FindControl("lstCoRespsToInsert");            
            ListItem item3 = FindByValue(list1, responsibleCode);
            if (item3 != null)
            {
                list1.Items.Remove(item3);
                list.Items.Add(new ListItem(item3.Text, item3.Value));
                item3.Enabled = false;
                Utility.OrderListBox(list, item3.Value);
            }
            
            #endregion
            
            if (lstCoRespsToInsert.Items.Count > 0)
            {
                lstCoRespsToInsert.SelectedIndex = -1;
            }
            
            if (lstCoRespsAvaiable.Items.Count > 0)
            {
                lstCoRespsAvaiable.SelectedIndex = -1;
            }           
        }
        
        protected void drpStatus_DataBound(object sender, EventArgs e)
        {
            DropDownList drpCategories = (DropDownList)sender;
            Utility.AddEmptyItem(drpCategories);
        }        
       
        protected void FormView1_ItemInserting1(object sender, FormViewInsertEventArgs e)
        {
            // Get the logged user and split the name...
            string username = GetUsername();
            // if it exist, add his value...
            if (username != null && username != String.Empty)
            {
                //e.Values.Add("Username", username);
                e.Values["Username"] = username;
            }            
            DropDownList drpRegions = FormView1.FindControl("drpRegion") as DropDownList;           
            e.Values["RegionCode"] = drpRegions.SelectedValue;
            DropDownList drpStatus = FormView1.FindControl("drpStatusCode") as DropDownList;            
            e.Values["StatusCode"] = drpStatus.SelectedValue;
            DropDownList drpSegment = FormView1.FindControl("drpSegment") as DropDownList;           
            e.Values["SegmentCode"] = drpSegment.SelectedValue;            
            if (e.Values["CostSaving"] != null)
            {
                if (e.Values["CostSaving"].ToString() == "N/A")
                {
                    e.Values["CostSaving"] = 0;
                }
            }
            else
            {
                e.Values["CostSaving"] = 0;
            }
        }
        
        protected void drpStatusCode_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpStatusCode = (DropDownList)FormView1.FindControl("drpStatusCode");
            DropDownList drpAutoStage = FormView1.FindControl("drpAutoStage") as DropDownList;
            RegularExpressionValidator revInvalidClosedProgressValue = (RegularExpressionValidator)FormView1.FindControl("revInvalidClosedProgressValue");
            RegularExpressionValidator revInvalidNotClosedProgressValue = (RegularExpressionValidator)FormView1.FindControl("revInvalidNotClosedProgressValue");
            
            if (drpStatusCode.SelectedValue.Equals("20")) //closed
            {
                revInvalidClosedProgressValue.Enabled = true;
                revInvalidNotClosedProgressValue.Enabled = false;
            }
            else
            {
                revInvalidClosedProgressValue.Enabled = false;
                revInvalidNotClosedProgressValue.Enabled = true;
            }
            
            #region Get at Web.Config the status codes permitted when the project is closed
            
            DropDownList drpStatus = (DropDownList)sender;
            DropDownCalendar ddcClosedDate = FormView1.FindControl("ddcClosedDate") as DropDownCalendar;
            Control tbodyBestPractice = FormView1.FindControl("tbodyBestPractice");
            RadioButtonList rblBestPractice = FormView1.FindControl("rblBestPractice") as RadioButtonList;
            TextBox txtBPComment = FormView1.FindControl("txtBPComment") as TextBox;
            Control tdBPComment = FormView1.FindControl("tdBPComment");
            rblBestPractice.ClearSelection();
            txtBPComment.Text = string.Empty;
            string[] codeStatusWhenPjClosed = ConfigurationManager.AppSettings["StatusAfterClosed"].Split(',');
            int pos = Array.IndexOf(codeStatusWhenPjClosed, drpStatus.SelectedValue);
            if (pos > -1)
            {
                ddcClosedDate.Enabled = true;
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
                ddcClosedDate.Enabled = false;
                ddcClosedDate.SelectedDateText = "";
                Label lblClosedDateRequired = FormView1.FindControl("lblCloseDateRequired") as Label;
                Label lblEngRepNumRequired = FormView1.FindControl("lblEngRepNumRequired") as Label;
                Label lblrfvEngReportLink = FormView1.FindControl("lblrfvEngReportLink") as Label;
                Label lblRfvOnePageLink = FormView1.FindControl("lblRfvOnePageLink") as Label;
                Label lblRfvRoiLink = FormView1.FindControl("lblRfvROILink") as Label;
                Label lblrfvVideoLnk = FormView1.FindControl("lblrfvVideoLnk") as Label;
                Label lblrfvBestPractice = FormView1.FindControl("lblrfvBestPractice") as Label;

                lblClosedDateRequired.Text = "&nbsp;&nbsp;";
                lblEngRepNumRequired.Text = "&nbsp;&nbsp;";
                lblrfvEngReportLink.Text = "&nbsp;&nbsp;";
                Label lblrfvIP = FormView1.FindControl("lblrfvIP") as Label;
                lblrfvIP.Text = "&nbsp;&nbsp;";
                lblRfvOnePageLink.Text = "&nbsp;&nbsp;";
                lblRfvRoiLink.Text = "&nbsp;&nbsp;";
                lblrfvVideoLnk.Text = "&nbsp;&nbsp;";
                lblrfvBestPractice.Text = "&nbsp;&nbsp;";
                ((System.Web.UI.HtmlControls.HtmlControl)(tbodyBestPractice)).Style.Add("display", "none");
            }
            #endregion
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
                    drpAutoStage.SelectedValue = drpAutoStage.Items[nDeployStageIndex].Value;
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
            //drpCategories_SelectedIndexChanged(drpCategories, null); 
        }
        
        protected void drpAutoLevel_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpAutoLevel = (DropDownList)FormView1.FindControl("drpAutoLevel");
            EnableAutomationType(drpAutoLevel.SelectedValue);
            Control tbodyAutomation = FormView1.FindControl("tbodyAutomation");
            DropDownList drpAutoStage = tbodyAutomation.FindControl("drpAutoStage") as DropDownList;
            drpAutoStage.SelectedIndex = 0;
            drpAutoStage.Enabled = true;
            drpAutoStage_SelectedIndexChanged(drpAutoStage, null);
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
            CleartbodyAutomationControls();
            drpCategoriesOnChange();
        }
        
        protected void btnMoveToInsertLoc_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoLocationsAvaiable = (ListBox)FormView1.FindControl("lstCoLocationsAvaiable");
            ListBox lstCoLocationsToInsert = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            DropDownList drpLocations = (DropDownList)FormView1.FindControl("drpLocations");
            if (lstCoLocationsAvaiable.SelectedItem != null)
            {
                ListItem itemToTransf = new ListItem(lstCoLocationsAvaiable.SelectedItem.Text, lstCoLocationsAvaiable.SelectedItem.Value);
                if (drpLocations.SelectedValue != itemToTransf.Value)
                {
                    lstCoLocationsAvaiable.Items.Remove(lstCoLocationsAvaiable.SelectedItem);
                    lstCoLocationsToInsert.Items.Add(itemToTransf);
                }
            }

            Utility.OrderListBox(lstCoLocationsToInsert);
            
            if (lstCoLocationsToInsert.Items.Count > 0)
            {
                lstCoLocationsToInsert.SelectedIndex = -1;
            }
            
            if (lstCoLocationsAvaiable.Items.Count > 0)
            {
                lstCoLocationsAvaiable.SelectedIndex = -1;
            }
        }
        
        protected void btnRemoveLocationProject_Click(object sender, ImageClickEventArgs e)
        {
            ListBox lstCoLocationsAvaiable = (ListBox)FormView1.FindControl("lstCoLocationsAvaiable");
            ListBox lstCoLocationsToInsert = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            
            ListItem itemToTransf = new ListItem(lstCoLocationsToInsert.SelectedItem.Text, lstCoLocationsToInsert.SelectedItem.Value);
            lstCoLocationsToInsert.Items.Remove(lstCoLocationsToInsert.SelectedItem);
            lstCoLocationsAvaiable.Items.Add(itemToTransf);

            Utility.OrderListBox(lstCoLocationsAvaiable);
            
            if (lstCoLocationsToInsert.Items.Count > 0)
            {
                lstCoLocationsToInsert.SelectedIndex = -1;
            }
            
            if (lstCoLocationsAvaiable.Items.Count > 0)
            {
                lstCoLocationsAvaiable.SelectedIndex = -1;
            }
        }
        
        protected void drpLocations_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList drpLocations = (sender as DropDownList);
            
            //Get Lists Box to  find item selected as Location
            ListBox lstCoLocationsAvaiable = (ListBox)FormView1.FindControl("lstCoLocationsAvaiable");
            ListBox lstCoLocationsToInsert = (ListBox)FormView1.FindControl("lstCoLocationsToInsert");
            //UpdatePanel updCoLocations = (FormView1.FindControl("updCoLocations") as UpdatePanel);
            
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
                ListItem itemToTransf = new ListItem(lstCoLocationsToInsert.SelectedItem.Text, lstCoLocationsToInsert.SelectedItem.Value);
                lstCoLocationsToInsert.Items.Remove(lstCoLocationsToInsert.SelectedItem);
                lstCoLocationsAvaiable.Items.Add(itemToTransf);

                ArrayList array1 = new ArrayList();
                int i = 0; 
                for (i = 0; i < lstCoLocationsAvaiable.Items.Count; i++)
                {
                    array1.Add(string.Format("{0};{1}", lstCoLocationsAvaiable.Items[i].Text, lstCoLocationsAvaiable.Items[i].Value));
                }
                
                array1.Sort();
                lstCoLocationsAvaiable.Items.Clear();
                for (i = 0; i < array1.Count; i++)
                {
                    string[] value = array1[i].ToString().Split(';');
                    
                    ListItem itemToAdd = new ListItem(value[0], value[1]);
                    lstCoLocationsAvaiable.Items.Add(itemToAdd);
                    if (itemToAdd.Value == drpLocations.SelectedValue)
                    {
                        itemToAdd.Enabled = false;
                    }
                }
            }
            
            if (lstCoLocationsToInsert.Items.Count > 0)
            {
                lstCoLocationsToInsert.SelectedIndex = -1;
            }
            
            if (lstCoLocationsAvaiable.Items.Count > 0)
            {
                lstCoLocationsAvaiable.SelectedIndex = -1;
            }
            if (itemAvaiable != null)
            {
                itemAvaiable.Enabled = false;
            }
        }
        
        protected void drpRegion_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Clear the selected co-responsibles...
            ListBox lstSelectedValues = FormView1.FindControl("lstCoRespsToInsert") as ListBox;
            // If found the control, clear it...
            if (lstSelectedValues != null)
            {
                lstSelectedValues.Items.Clear();
            }
        }
        
        protected void drpResponsible_DataBound(object sender, EventArgs e)
        {
            DropDownList drpResponsibles = (DropDownList)sender;
            DropDownList drpRegion = FormView1.FindControl("drpRegion") as DropDownList;
            
            string[] usernameDomain = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernameDomain[usernameDomain.Length - 1];
            Utility.AddEmptyItem(drpResponsibles);
            string sResponsibleUser = FindByValue(drpResponsibles, username);
            if (!string.IsNullOrEmpty(sResponsibleUser))
            {
                drpResponsibles.SelectedValue = sResponsibleUser; //item.Value;
            }
            else if (drpRegion.SelectedIndex != 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "YOU_ARENT_RESPONSIBLE").ToString());
                drpResponsibles.SelectedIndex = 0;
            }
        }
        
        private string FindByValue(DropDownList ddl, string value)
        {
            foreach (ListItem item in ddl.Items)
            {
                if (string.Compare(value, item.Value, true) == 0)
                {
                    return CheckmarxHelper.EscapeReflectedXss(item.Value);
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
        
        protected void obsRegion_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            string[] usernameDomain = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernameDomain[usernameDomain.Length - 1];
            
            e.InputParameters["PU_USUARIO"] = username;
        }
        
        protected void lstCoRespsAvaiable_DataBound(object sender, EventArgs e)
        {
            ListBox listBox = sender as ListBox;
            string[] usernameDomain = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name).Split('\\');
            string username = usernameDomain[usernameDomain.Length - 1];
            
            ListItem item = FindByValue(listBox, username);
            if (item != null)
            {
                listBox.Items.Remove(item);
            }
        }
        
        /// <summary>
        /// Get value of manager mail
        /// </summary>
        /// <returns>Manager mail</returns>
        private string GetMailManager()
        {
            if (!object.Equals(ConfigurationManager.AppSettings["TestMode"], null))
            {
                if (ConfigurationManager.AppSettings["TestMode"].ToString() == "1")
                {
                    return ConfigurationManager.AppSettings["TestModeEmailAddress"].ToString();
                }
            }
            
            User usr = new User();
            string manager = "";
            string mailManager = "";
            
            ADUserSelect currentUser = usr.GetUser(GetUsername());
            
            ////Get Manager Mail
            manager = currentUser.Manager.Substring(currentUser.Manager.IndexOf("CN"), currentUser.Manager.IndexOf(","));
            mailManager = usr.GetMailManager(manager);
            
            return mailManager;
        }
        
        protected void grdCostSavings_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            Page.Validate("UpdateCostSavingGroup");
            if (Page.IsValid)
            {
                GridView grd = (GridView)FormView1.FindControl("grdCostSavings");
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
        
        protected void btnAdd_Click(object sender, EventArgs e)
        {
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
                //GridView grd = (GridView)FormView1.FindControl("grdCostSavings");
                DropDownList drpFooterdrpAutomationSaving = (DropDownList)grd.FooterRow.FindControl("drpFooterdrpAutomationSaving");
                DropDownList ddlSavingType = (DropDownList)grd.FooterRow.FindControl("drpFooterSavingType");
                DropDownList ddlSavingCategory = (DropDownList)grd.FooterRow.FindControl("drpFooterSavingCategory");
                DropDownCalendar ddcDate = (DropDownCalendar)grd.FooterRow.FindControl("ddcFooterDate");
                TextBox txtSavingAmount = (TextBox)grd.FooterRow.FindControl("txtFooterSavingAmount");
                CostSaving cs = new CostSaving(0, 0, Convert.ToInt32(ddlSavingType.SelectedItem.Value), Convert.ToInt32(ddlSavingCategory.SelectedItem.Value), ddcDate.SelectedDate, Convert.ToDecimal(txtSavingAmount.Text), ddlSavingType.SelectedItem.Text, ddlSavingCategory.SelectedItem.Text);
                CostSavingDataSource csds = new CostSavingDataSource();
                
                string automationSaving = "";
                int automationSavingID = 0;
                
                if (drpFooterdrpAutomationSaving.SelectedItem != null)
                {
                    if (drpFooterdrpAutomationSaving.SelectedItem.Value != "")
                    {
                        automationSaving = drpFooterdrpAutomationSaving.SelectedItem.Text;
                        automationSavingID = System.Convert.ToInt32(drpFooterdrpAutomationSaving.SelectedItem.Value);
                    }
                }                
                cs.AutomationSaving = automationSaving;
                cs.AutomationSavingId = automationSavingID;
                
                csds.InsertCostSaving(cs);
                grd.DataBind();
                ddlSavingCategory.SelectedIndex = -1;
                ddlSavingType.SelectedIndex = -1;                
                ddcDate.SelectedDateText = null;
                txtSavingAmount.Text = "";
                csds.HasChanged = true;
            }
        }
        
        protected void grdCostSavings_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.DataItem != null && e.Row.DataItem is CostSaving)
            {
                CostSaving costSaving = (CostSaving)e.Row.DataItem;
                if (costSaving.CostSavingId == -1)
                {
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
            bool isAutomationProject = grdCostSavings.Columns[0].Visible;
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

            if (drpAutoStage.SelectedValue.Equals("Define") || drpAutoStage.SelectedValue.Equals("Eval") || drpAutoStage.SelectedValue.Equals("Develop") || drpAutomationSaving.SelectedValue.Equals("9")) //Automation Planned Savings ID
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
            ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
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
        
        protected void drpCloseInfo_DataBound(object sender, EventArgs e)
        {
            DropDownList drpCloseInfo = (DropDownList)sender;
            Utility.AddEmptyItem(drpCloseInfo);            
        }
        
        protected void drpAutoStage_SelectedIndexChanged(object sender, EventArgs e)
        { 
            // New Enhancement changes - Begin
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
                if (drpStatus.SelectedValue.Equals("20") && string.IsNullOrEmpty(txtPrjNumber.Text) && !enable && rblPaidFlex.SelectedValue.Equals("F"))
                {
                    enable = true; // Unfreeze develop stage controls if status is closed and stage is deploy without entering develop stage details.
                }                
                rblPOIssued.Enabled = enable;
                rblPaidFlex.Enabled = enable;
                txtPrjNumber.Enabled = enable;
                txtCapexAppvdDate.Enabled = enable;
            }
        }

        private void HideAutomationControls()
        {
            Control tbodyAutomationType = FormView1.FindControl("tbodyAutomationType");
            Control tbodyOtherAutomation = FormView1.FindControl("tbodyOtherAutomation");
            Control tbodyCloseInfo = FormView1.FindControl("tbodyCloseInfo");
            Control tbodyOpenDevelop = FormView1.FindControl("tbodyOpenDevelop");
            Control tbodyPaidbyInfo = FormView1.FindControl("tbodyPaidbyInfo");
            Control tbodyCloseDeployOther = FormView1.FindControl("tbodyCloseDeployOther");
            Control tdLblPOAppvdDate = FormView1.FindControl("tdlblPoAppvdDate");
            Control tdPOAppvdDate = FormView1.FindControl("tdPoAppvdDate");
            RequiredFieldValidator rfvPrjNumber = tbodyPaidbyInfo.FindControl("rfvPrjNumber") as RequiredFieldValidator; 

            tbodyAutomationType.Visible = false;
            tbodyOtherAutomation.Visible = false;
            tbodyCloseInfo.Visible = false;
            ((System.Web.UI.HtmlControls.HtmlControl)(tbodyOpenDevelop)).Style.Add("display", "none");
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
                RadioButtonList rblPOIssued = tbodyOpenDevelop.FindControl("rblPOIssued") as RadioButtonList;
                TextBox txtCapexAppvdDate = FormView1.FindControl("ddcCapexAppvdDate") as TextBox;
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
            DropDownList drpAutomationType = tbodyAutomation.FindControl("drpAutomationType") as DropDownList;
            TextBox txtHoldReason = tbodyAutomation.FindControl("txtHoldReason") as TextBox;

            hdfReuse.Value = txtReuse.Text = string.Empty;
            hdfProjCost.Value = txtAutomationProjectCost.Text = string.Empty;
            hdfPlannedPaybackinMonths.Value = txtPlannedPaybackinMonths.Text = string.Empty;
            hdfEstimatedProductLifeinMonths.Value = txtEstimatedProductLifeinMonths.Text = string.Empty;
            hdfHeadcountBeforeAutomation.Value = txtHeadcountBeforeAutomation.Text = string.Empty;
            hdfHeadcountAfterAutomation.Value = txtHeadcountAfterAutomation.Text = string.Empty;
            hdfEstimatedROIafterendoflife.Value = txtEstimatedROIafterendoflife.Text = string.Empty;
            hdfExpectedIRR.Value = txtExpectedIrr.Text = string.Empty;
            drpAutomationType.SelectedValue = "";
            hdfHoldReason.Value = txtHoldReason.Text = string.Empty;
        }
        
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
    }

    public class OtherResponsible
    {
        #region Attributes

        private string codeUsername;

        #endregion

        #region Properties

        public string CodeUsername
        {
            get { return codeUsername; }
            set { codeUsername = value; }
        }

        #endregion
    }
}