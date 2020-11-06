using System;
using System.Configuration;
using System.Web;
using System.Web.UI;
using ProjectTracker.Business;
using System.IO;
using System.Collections.Generic;
using ProjectTracker.PPTHelper;
using System.Security.Principal;

namespace ProjectTracker.Pages
{

    public partial class ExportToPowerPoint : System.Web.UI.Page
    {

        private struct PowerPointParameters
        {

            #region Fields

            private int projectId;
            private int regionCode;
            private int customerCode;
            private int locationCode;
            private string responsible;
            private int statusCode;
            private string actualDate;
            private DateTime startWeek;
            private DateTime endWeek;
            private int segmentCode;
            private string username;
            private int savingCategoryCode;
            private int revenueCostSaving;

            #endregion

            #region Properties

            public int ProjectId
            {
                get { return projectId; }
                set { projectId = value; }
            }

            public int RegionCode
            {
                get { return regionCode; }
                set { regionCode = value; }
            }

            public int CustomerCode
            {
                get { return customerCode; }
                set { customerCode = value; }
            }

            public int LocationCode
            {
                get { return locationCode; }
                set { locationCode = value; }
            }

            public string Responsible
            {
                get
                {
                    if (String.IsNullOrEmpty(responsible))
                        responsible = "%";
                    return responsible;
                }
                set { responsible = value; }
            }

            public int StatusCode
            {
                get { return statusCode; }
                set { statusCode = value; }
            }

            public string ActualDate
            {
                get
                {
                    if (String.IsNullOrEmpty(actualDate))
                        actualDate = "%";
                    return actualDate;
                }
                set { actualDate = value; }
            }

            public DateTime StartWeek
            {
                get { return startWeek; }
                set { startWeek = value; }
            }

            public DateTime EndWeek
            {
                get { return endWeek; }
                set { endWeek = value; }
            }

            public int SegmentCode
            {
                get { return segmentCode; }
                set { segmentCode = value; }
            }

            public string Username
            {
                get
                {
                    if (String.IsNullOrEmpty(username))
                        username = "%"; 
                    return username;
                }
                set { username = value; }
            }

            public int SavingCategoryCode
            {
                get { return savingCategoryCode; }
                set { savingCategoryCode = value; }
            }

            public int RevenueCostSaving
            {
                get { return revenueCostSaving; }
                set { revenueCostSaving = value; }
            }

            #endregion

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            PowerPointParameters parameters = GetParameters();
            List<ProjectVO> projectList = LoadFromDatabase(parameters);

            if (projectList.Count == 0)
            {
                Page.ClientScript.RegisterClientScriptBlock(typeof(Page), "onLoad", string.Format("alert('{0}');", Resources.Default.NOPROJECTS), true);
                return;
            }            
            string fileName = Guid.NewGuid().ToString();
            Project project = new Project();
            byte[] powerPointByteArray = CreatePowerPoint(projectList, fileName, project.GetAllSavingCategory());
            DownloadPowerPoint(powerPointByteArray, fileName);
        }

        private PowerPointParameters GetParameters()
        {
            PowerPointParameters parameters = new PowerPointParameters();
            parameters.ActualDate = Convert.ToString(Request.QueryString["Actual_Date"]);
            parameters.Username = Convert.ToString(Request.QueryString["UserName"]);
            //If it has project Id we don't need to get others filters
            if (Request.QueryString["ProjectId"] != null)
            {
                parameters.ProjectId = Convert.ToInt32(Request.QueryString["ProjectId"]);
                return parameters;
            }
            if (Request.QueryString["Customer"] != null)
            {
                parameters.CustomerCode = Convert.ToInt32(Request.QueryString["Customer"]);
            }
            if (Request.QueryString["EndWeek"] != null)
            {
                parameters.EndWeek = Convert.ToDateTime(Request.QueryString["EndWeek"]);
            }
            if (Request.QueryString["Location"] != null)
            {
                parameters.LocationCode = Convert.ToInt32(Request.QueryString["Location"]);
            }
            if (Request.QueryString["Region"] != null)
            {
                parameters.RegionCode = Convert.ToInt32(Request.QueryString["Region"]);
            }
            if (Request.QueryString["Responsible"] != null)
            {
                parameters.Responsible = Convert.ToString(Request.QueryString["Responsible"]);
            }
            if (Request.QueryString["SavingCategory"] != null)
            {
                parameters.SavingCategoryCode = Convert.ToInt32(Request.QueryString["SavingCategory"]);
            }
            if (Request.QueryString["Segment"] != null)
            {
                parameters.SegmentCode = Convert.ToInt32(Request.QueryString["Segment"]);
            }
            if (Request.QueryString["StartWeek"] != null)
            {
                parameters.StartWeek = Convert.ToDateTime(Request.QueryString["StartWeek"]);
            }
            if (Request.QueryString["Status"] != null)
            {
                parameters.StatusCode = Convert.ToInt32(Request.QueryString["Status"]);
            }
            if (Request.QueryString["RevenueCostSaving"] != null)
            {
                parameters.RevenueCostSaving = Convert.ToInt32(Request.QueryString["RevenueCostSaving"]);
            }
            return parameters;
        }

        /// <summary>
        /// Get the current username, splitting his domain.
        /// </summary>
        /// <returns>The uername.</returns>
        private string GetUsername()
        {
            string username = string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name;
            // Split username...
            string[] values = username.Split('\\');
            // If there are valid data..
            if (values.Length > 1)
                return values[values.Length - 1];
            return username;
        }

        private List<ProjectVO> LoadFromDatabase(PowerPointParameters parameters)
        {
            Project project = new Project();

            List<ProjectVO> projectList = null;
            if (parameters.ProjectId > 0)
            {
                projectList = new List<ProjectVO>();
                projectList.Add(project.GetProjectById(parameters.ProjectId));
            }
            else
            {
                projectList = project.GetListOfProjects(parameters.RegionCode, parameters.CustomerCode, parameters.LocationCode, parameters.Responsible, parameters.StatusCode, parameters.ActualDate, parameters.StartWeek, parameters.EndWeek, parameters.SegmentCode, parameters.Username, parameters.SavingCategoryCode, parameters.RevenueCostSaving );
            }
            foreach (ProjectVO projectVO in projectList)
            {
                projectVO.GroupedCostSavingList = project.GetGroupedCostSavingByProject(projectVO.Code);
                CostSavingDataSource costSavingDataSource = new CostSavingDataSource(); //Added by Guoxin Liu 2012-08-23                
                projectVO.CostSavingList = costSavingDataSource.GetAllCostSavingForReport(projectVO.Code);
            }
            return projectList;
        }

        private byte[] CreatePowerPoint(List<ProjectVO> projectList, string fileName, List<SavingCategoryVO> savingCategoryList)
        {
            string templateManualPath = "";
            string templateAutoPath = "";            
            string tempFolder = "";
            if (ConfigurationManager.AppSettings["PPTTempFolder"] != null)
            {
                tempFolder = ConfigurationManager.AppSettings["PPTTempFolder"].ToString();
            }
            else
            {
                throw new Exception("PPTTempDirectory is not configured");
            }

            if (ConfigurationManager.AppSettings["AutoPPTemplate"] != null)
            {
                templateAutoPath = ConfigurationManager.AppSettings["AutoPPTemplate"].ToString();
                templateManualPath = ConfigurationManager.AppSettings["ManualPPTemplate"].ToString();
            }
            else
            {
            throw new Exception("PPTTemplate is not configured");
            }

            ProjectPowerPointCreator pptCreator = new ProjectPowerPointCreator(templateAutoPath, templateManualPath, savingCategoryList, tempFolder);
            return pptCreator.ExportToPowerPoint(projectList, fileName);
        }

        private void DownloadPowerPoint(byte[] powerPointByteArray, string fileName)
        {
            if (powerPointByteArray != null)
            {
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.ContentType = "application/vnd.ms-powerpoint";
                Response.AddHeader("Strict-Transport-Security", "max-age=31536000"); //checkmarx
                Response.AddHeader("content-disposition", String.Format("attachment;filename={0}", Path.ChangeExtension(fileName, "ppt")));
                Response.BinaryWrite(powerPointByteArray);
                Response.End();
            }
        }

    }
}
