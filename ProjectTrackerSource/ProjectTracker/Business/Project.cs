using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.UI.WebControls;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System.Data.SqlClient;
using ProjectTracker.DAO;
using System.Security.Principal;

namespace ProjectTracker.Business
{
    public class Project
    {

        public static Database db = DatabaseFactory.CreateDatabase("d_PTConnectionString");
        private ProjectsTableAdapter tbAdptProject = new ProjectsTableAdapter();        
        private ProjectTracker.DAO.dtsProjectTracker.ProjectsDataTable tb = new ProjectTracker.DAO.dtsProjectTracker.ProjectsDataTable();
        
        /// <summary>
        /// Import Project verifing if exists responsible registered.
        /// </summary>
        /// <param name="category">Category Description</param>
        /// <param name="description">Project Description</param>
        /// <param name="usernameResponsible">Responsible Username</param>
        /// <param name="nameResponsible">Responsible Name</param>
        /// <param name="emailResponsible">Responsible Email</param>
        /// <param name="customer">Customer Description</param>
        /// <param name="location">Location Description</param>
        /// <param name="openDate">Open Date</param>
        /// <param name="commitDate">Commit Date</param>
        /// <param name="closed">Close Date</param>
        /// <param name="OCDH">O/C/D/H</param>
        /// <param name="costSaving">Cost Saving</param>
        /// <param name="remarks">Remarks</param>
        public bool Import(string category, string description, string usernameResponsible, string nameResponsible, string emailResponsible,
            string customer, string location, DateTime openDate, DateTime? commitDate, DateTime? closed, char OCDH, double? costSaving, string remarks)
        {
            //Import Project
            return Import(category, description, usernameResponsible, customer, location, openDate, commitDate, closed, OCDH, costSaving, remarks);
        }

        /// <summary>
        /// Import Project verifing if exists responsible registered.
        /// </summary>
        /// <param name="category">Category Description</param>
        /// <param name="description">Project Description</param>
        /// <param name="usernameResponsible">Responsible Username</param>
        /// <param name="customer">Customer Description</param>
        /// <param name="location">Location Description</param>
        /// <param name="openDate">Open Date</param>
        /// <param name="commitDate">Commit Date</param>
        /// <param name="closed">Close Date</param>
        /// <param name="OCDH">O/C/D/H</param>
        /// <param name="costSaving">Cost Saving</param>
        /// <param name="remarks">Remarks</param>
        public bool Import(string category, string description, string usernameResponsible,
            string customer, string location, DateTime openDate, DateTime? commitDate, DateTime? closed, char OCDH, double? costSaving, string remarks)
        {
            Database db = DatabaseFactory.CreateDatabase("d_PTConnectionString");
            DbCommand dbc = db.GetStoredProcCommand("SP_FIT_PT_IMPORT_PROJECTS");

            db.AddInParameter(dbc, "@CATEGORY", DbType.String, category);
            db.AddInParameter(dbc, "@DESCRIPTION", DbType.String, description);
            db.AddInParameter(dbc, "@RESPONSIBLE", DbType.String, usernameResponsible);
            db.AddInParameter(dbc, "@CUSTOMER", DbType.String, customer);
            db.AddInParameter(dbc, "@LOCATION", DbType.String, location);
            db.AddInParameter(dbc, "@OPEN_DATE", DbType.DateTime, openDate);

            if (commitDate != null)
                db.AddInParameter(dbc, "@COMMIT_DATE", DbType.DateTime, commitDate);
            else
                db.AddInParameter(dbc, "@COMMIT_DATE", DbType.DateTime, DBNull.Value);

            if (closed != null)
                db.AddInParameter(dbc, "@CLOSED_DATE", DbType.DateTime, closed);
            else
                db.AddInParameter(dbc, "@CLOSED_DATE", DbType.DateTime, DBNull.Value);

            db.AddInParameter(dbc, "@STATUS", DbType.Decimal, 10.00);
            db.AddInParameter(dbc, "@OCDH", DbType.String, OCDH);


            if (costSaving != null)
                db.AddInParameter(dbc, "@COST_SAVING", DbType.Decimal, Convert.ToDecimal(costSaving));
            else
                db.AddInParameter(dbc, "@COST_SAVING", DbType.String, DBNull.Value);

            if (!String.IsNullOrEmpty(remarks.Trim()))
                db.AddInParameter(dbc, "@REMARKS", DbType.String, remarks);
            else
                db.AddInParameter(dbc, "@REMARKS", DbType.String, DBNull.Value);

            string username = string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name; 
            string[] partUsername = username.Split('\\');
            if (partUsername.Length > 1)
                username = partUsername[partUsername.Length - 1];
            db.AddInParameter(dbc, "@CREATER", DbType.String, username);

            object result = db.ExecuteScalar(dbc);
            if (result != null && Convert.ToInt32(result) == 1)
                return true;
            return false;
        }



        /// <summary>
        /// Get Projects
        /// </summary>
        /// <param name="filter">Filter to query</param>
        /// <param name="user">User that will get projects</param>
        /// <returns>Table with result.</returns>
        public static ProjectTracker.DAO.dtsProjectTracker.SP_FIT_PT_VIEW_PROJECTSDataTable getProjects(int filter, string user)
        {
            ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SP_FIT_PT_VIEW_PROJECTSTableAdapter tbAdpt = new SP_FIT_PT_VIEW_PROJECTSTableAdapter();
            return tbAdpt.GetData(filter, user);
        }

        /// <summary>
        /// Get All Co-Responsibles to insert.
        /// </summary>
        /// <param name="list">ListBox with item that user desired add in project</param>
        /// <param name="tb">DataTable with old co-responsibles</param>
        /// <returns>Co-Responsibles to insert</returns>
        public static ArrayList GetCoResponsibleToInsert(ListBox list, ProjectTracker.DAO.dtsProjectTracker.ResponsiblesProjectsDataTable tb)
        {
            ArrayList hash = new ArrayList();

            DataView dv = new DataView((DataTable)tb);

            foreach (ListItem item in list.Items)
            {
                dv.RowFilter = string.Format("PU_USUARIO='{0}'", item.Value.Replace("'", ""));
                if (dv.Count == 0)
                {
                    hash.Add(item.Value);
                }
            }
            return hash;
        }

        /// <summary>
        /// Import Project verifing if exists responsible registered.
        /// </summary>
        /// <param name="usernameResponsible">Responsible Username</param>
        /// <param name="usernameResponsible">Code Project</param>        
        public void UpdateResponsible(string responsible, int code, ProjectsTableAdapter tbAdpt)
        {
            
            try
            {
                tbAdpt.UpdateResponsible(responsible, code);
            }
            catch (Exception)
            {
            }
        }

        /// <summary>
        /// Get All Co-Responsibles to remove.
        /// </summary>
        /// <param name="list">ListBox with item that user desired add in project</param>
        /// <param name="tb">DataTable with old co-responsibles</param>
        /// <returns>Co-Responsibles to remove</returns>
        public static ArrayList GetCoResponsibleToDelete(ListBox list, ProjectTracker.DAO.dtsProjectTracker.ResponsiblesProjectsDataTable tb)
        {
            ArrayList hash = new ArrayList();

            DataTable tb2 = ((DataTable)tb);

            foreach (DataRow dtr in tb2.Rows)
            {
                string usuario = dtr["PU_USUARIO"].ToString();
                if (list.Items.FindByValue(usuario) == null)
                {
                    hash.Add(usuario);
                }
            }
            return hash;
        }

        /// <summary>
        /// Get Summary List.
        /// </summary>
        /// <param name="currentUser">User that will get summary</param>
        /// <returns>Return Summary List.</returns>
        public static List<Summary> getSummary(string currentUser)
        {
            //Set query that used to get summary
            string sql = "SP_FIT_PT_SUMMARY";

            //Create a commant based in the query above
            DbCommand dbc = db.GetStoredProcCommand(sql);

            //Add Parameter to command
            db.AddInParameter(dbc, "@USER", DbType.String, currentUser);

            List<Summary> listSum = new List<Summary>();

            IDataReader dbReader = db.ExecuteReader(dbc);

            //Add all register in a list
            if (dbReader.Read())
            {
                Summary sum = new Summary();

                sum.YourOpended = dbReader.GetInt32(0);
                sum.YourClosed = dbReader.GetInt32(1);
                sum.YourPending = dbReader.GetInt32(2);
                sum.AllOpended = dbReader.GetInt32(3);
                sum.AllClosed = dbReader.GetInt32(4);
                sum.AllPending = dbReader.GetInt32(5);

                listSum.Add(sum);
            }

            return listSum;
        }

        

        public ProjectVO GetProjectById(int projectId)
        {
            ListOfProjectsTableAdapter listOfProjectsTableAdapter = new ListOfProjectsTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.ListOfProjectsDataTable tb = listOfProjectsTableAdapter.GetProjectById(projectId);
            
            ProjectVO project = new ProjectVO();
            foreach (ProjectTracker.DAO.dtsProjectTracker.ListOfProjectsRow row in tb.Rows)
            {
                project = new ProjectVO(row);
                break;
            }

            return project;
        }

        public DataTable GetProjectByDescription(string description, string username, string categoryCode, string statusCode, string customerCode, string locationCode, string projectCode, string regionCode, string savingCategoryCode, string userViewrs, string sort, bool isGuestUser, string revenueCostSaving, string startDate, string endDate, int currentPage, out int TotalCount)
        {
            int pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["PageViewCount"]);
            int startRowNumber = ((currentPage - 1) * pageSize) + 1;

            string temp = savingCategoryCode;
            savingCategoryCode = "%";

            if (string.IsNullOrEmpty(regionCode))
            {
                regionCode = "%";
            }

            SqlParameter parTotalCount = new SqlParameter("@TotalCount", SqlDbType.Int);
            parTotalCount.Direction = ParameterDirection.Output;
            SqlParameter[] parameters =
            {    
              new SqlParameter("@Description", SqlDbType.VarChar, 170) { Value = description },
              new SqlParameter("@Username", SqlDbType.VarChar, 8) { Value = username },
              new SqlParameter("@CategoryCode", SqlDbType.VarChar, 50) { Value = categoryCode },
              new SqlParameter("@StatusCode", SqlDbType.VarChar, 50) { Value = statusCode },
              new SqlParameter("@CustomerCode", SqlDbType.VarChar, 50) { Value = customerCode },
              new SqlParameter("@LocationCode", SqlDbType.VarChar, 50) { Value = locationCode },
              new SqlParameter("@ProjectCode", SqlDbType.VarChar, 50) { Value = projectCode },
              new SqlParameter("@RegionCode", SqlDbType.VarChar, 50) { Value = regionCode },
              new SqlParameter("@UserViewrs", SqlDbType.VarChar, 50) { Value = userViewrs },
              new SqlParameter("@SavingCategoryCode", SqlDbType.VarChar, 50) { Value = savingCategoryCode },
              new SqlParameter("@isGuestUser", SqlDbType.VarChar, 5) { Value = isGuestUser },
              new SqlParameter("@StartDate", SqlDbType.DateTime) { Value = Convert.ToDateTime(startDate) },
              new SqlParameter("@EndDate", SqlDbType.DateTime) { Value = Convert.ToDateTime(endDate) },
              new SqlParameter("@StartIndex", SqlDbType.Int) { Value = startRowNumber },
              new SqlParameter("@PageSize", SqlDbType.Int) { Value = pageSize },
              parTotalCount 
            };
            SQLDBHelper dbHelp = new SQLDBHelper();
            DataSet dstProject = dbHelp.QueryBySP("GetProjectsByCriteria", parameters);
            TotalCount = Convert.ToInt32(parTotalCount.Value);
            tb.Merge(dstProject.Tables[0], true, MissingSchemaAction.Ignore);
            savingCategoryCode = temp;

            if (sort != "%")
            {
                tb.DefaultView.Sort = sort;
            }

            DataTable dt = tb.DefaultView.ToTable();
            DataTable dtNew = dt.Clone();
            dtNew.Rows.Clear();
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["d_PTConnectionString"].ToString()))
            {
                conn.Open();
                foreach (DataRow dr in dt.Rows)
                {
                    bool shouldImport = false;
                    string sql = string.Empty;
                    //string sParamSavCatCode = string.Empty;
                    //string sParamCode = string.Empty;
                    switch (revenueCostSaving)
                    {
                        case "%":
                            if (savingCategoryCode != "%")
                            { 
                                sql = "select 1 from TB_PT_PO_COSTSAVING inner join TB_PT_PV_SAVINGTYPE on TB_PT_PO_COSTSAVING.PV_CODIGO=TB_PT_PV_SAVINGTYPE.PV_CODIGO where ((TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION='Revenue' or TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION='Planned Savings') or (TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION<>'Revenue' and TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION<>'Planned Savings' and TB_PT_PO_COSTSAVING.PN_CODIGO=@ParamSavCatCode)) and TB_PT_PO_COSTSAVING.PJ_CODIGO=@ParamCode";
                            }
                            else
                            {
                                shouldImport = true;
                            }
                            break;
                        case "1":
                            if (savingCategoryCode != "%")
                            {
                                sql = "select 1 from TB_PT_PO_COSTSAVING inner join TB_PT_PV_SAVINGTYPE on TB_PT_PO_COSTSAVING.PV_CODIGO=TB_PT_PV_SAVINGTYPE.PV_CODIGO where (1=0 or (TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION<>'Revenue' and TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION<>'Planned Savings' and TB_PT_PO_COSTSAVING.PN_CODIGO=@ParamSavCatCode)) and TB_PT_PO_COSTSAVING.PJ_CODIGO=@ParamCode";
                            }
                            else
                            { 
                                sql = "select 1 from TB_PT_PO_COSTSAVING inner join TB_PT_PV_SAVINGTYPE on TB_PT_PO_COSTSAVING.PV_CODIGO=TB_PT_PV_SAVINGTYPE.PV_CODIGO where (1=0 or (TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION<>'Revenue' and TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION<>'Planned Savings' and 1=1)) and TB_PT_PO_COSTSAVING.PJ_CODIGO=@ParamCode";
                            }
                            break;
                        case "2":
                            {
                                sql = "select 1 from TB_PT_PO_COSTSAVING inner join TB_PT_PV_SAVINGTYPE on TB_PT_PO_COSTSAVING.PV_CODIGO=TB_PT_PV_SAVINGTYPE.PV_CODIGO where (1=0 or (TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION='Revenue' and 1=1)) and TB_PT_PO_COSTSAVING.PJ_CODIGO=@ParamCode";
                            }                            
                            break;
                        case "3":
                            { 
                                sql = "select 1 from TB_PT_PO_COSTSAVING inner join TB_PT_PV_SAVINGTYPE on TB_PT_PO_COSTSAVING.PV_CODIGO=TB_PT_PV_SAVINGTYPE.PV_CODIGO where (1=0 or (TB_PT_PV_SAVINGTYPE.PV_DESCRIPTION='Planned Savings' and 1=1)) and TB_PT_PO_COSTSAVING.PJ_CODIGO=@ParamCode";
                            }
                            break;
                    }
                    if (!shouldImport)
                    {
                        SqlCommand cmd = new SqlCommand(sql, conn);
                        if (savingCategoryCode != "%")
                        {
                            cmd.Parameters.AddWithValue("@ParamSavCatCode", savingCategoryCode);
                            cmd.Parameters.AddWithValue("@ParamCode", dr["Code"].ToString());
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@ParamCode", dr["Code"].ToString());
                        }
                        object obj = cmd.ExecuteScalar();
                        int cnt = 0;
                        if (!(Equals(obj, null) || Equals(obj, DBNull.Value)))
                        {
                            cnt = Convert.ToInt32(obj);
                        }
                        if (cnt > 0) shouldImport = true;
                    }
                    
                    if (shouldImport)
                    {
                        dtNew.ImportRow(dr);
                    }

                }
                conn.Close();
                conn.Dispose();
            }
            return dtNew;
        }

        

        public List<ProjectVO> GetListOfProjects(int? regionCode, int? customerCode, int? locationCode, string responsible, int? statusCode, string actualDate, DateTime? startWeek, DateTime? endWeek, int? segmentCode, string username, int? savingCategoryCode, int? revenueCostSaving)
        {
            ListOfProjectsTableAdapter listOfProjectsTableAdapter = new ListOfProjectsTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.ListOfProjectsDataTable tb = listOfProjectsTableAdapter.GetData(regionCode, customerCode, locationCode, responsible, statusCode, actualDate, startWeek, endWeek, segmentCode, username, savingCategoryCode, revenueCostSaving);
            List<ProjectVO> projectList = new List<ProjectVO>();

            foreach (ProjectTracker.DAO.dtsProjectTracker.ListOfProjectsRow row in tb.Rows)
            {
                projectList.Add(new ProjectVO(row));
            }

            return projectList;
        }

        public List<GroupedCostSavingVO> GetGroupedCostSavingByProject(int projectId)
        {
            GroupedCostSavingTableAdapter groupedCostSavingTableAdapter = new GroupedCostSavingTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.GroupedCostSavingDataTable groupedCostSavingDataTable = groupedCostSavingTableAdapter.GetData(projectId);
            List<GroupedCostSavingVO> groupedCostSavingList = new List<GroupedCostSavingVO>();
            foreach (ProjectTracker.DAO.dtsProjectTracker.GroupedCostSavingRow row in groupedCostSavingDataTable.Rows)
            {
                groupedCostSavingList.Add(new GroupedCostSavingVO(row));
            }
            return groupedCostSavingList;
        }

        public List<SavingCategoryVO> GetAllSavingCategory()
        {
            SavingCategoryTableAdapter savingCategoryTableAdapter = new SavingCategoryTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.SavingCategoryDataTable dt = savingCategoryTableAdapter.GetData();
            List<SavingCategoryVO> savingCategoryList = new List<SavingCategoryVO>();
            foreach (ProjectTracker.DAO.dtsProjectTracker.SavingCategoryRow row in dt.Rows)
            {
                savingCategoryList.Add(new SavingCategoryVO(row));
            }
            return savingCategoryList;
        }

        public void UpdateQuery(int CategoryCode, string Description, string Username, int CustomerCode, int LocationCode, System.DateTime OpenDate, System.Nullable<System.DateTime> CommitDate, System.Nullable<System.DateTime> ClosedDate, int StatusCode, System.Nullable<decimal> CostSaving, string Remarks, System.Nullable<int> SegmentCode, System.Nullable<int> RegionCode, string eRoom, string siteLead, decimal? PercentageCompletion, int Code)
        {
            object a = tbAdptProject.UpdateQuery(CategoryCode, Description, Username, CustomerCode, LocationCode, OpenDate, CommitDate, ClosedDate, StatusCode, CostSaving, Remarks, SegmentCode, RegionCode, eRoom, siteLead,PercentageCompletion, Code);

        }

        public void Delete(int projectCode)
        {
            tbAdptProject.DeleteQuery(projectCode);
        }

        public int? GetRegionCodeByTag(string tag)
        {
            RegionsTableAdapter regionsTableAdapter = new RegionsTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.RegionsDataTable dt = regionsTableAdapter.GetDataByTag(tag);
            if (dt != null && dt.Rows != null && dt.Rows.Count > 0)
            {
                return (dt.Rows[0] as ProjectTracker.DAO.dtsProjectTracker.RegionsRow).Code;
            }
            return null;
        }

        public int? GetSavingCategoryCodeByTag(string tag)
        {
            SavingCategoryTableAdapter savingCategoryTableAdapter = new SavingCategoryTableAdapter();
            ProjectTracker.DAO.dtsProjectTracker.SavingCategoryDataTable dt = savingCategoryTableAdapter.GetDataByTag(tag);
            if (dt != null && dt.Rows != null && dt.Rows.Count > 0)
            {
                return (dt.Rows[0] as ProjectTracker.DAO.dtsProjectTracker.SavingCategoryRow).Code;
            }
            return null;
        }

    }

    public class GroupedCostSavingVO
    {

        #region Fields

        private string description;
        private decimal totalValue;

        #endregion

        #region Properties

        public decimal TotalValue
        {
            get { return totalValue; }
            set { totalValue = value; }
        }

        public string Description
        {
            get { return description; }
            set { description = value; }
        }

        #endregion

        public GroupedCostSavingVO() { }

        public GroupedCostSavingVO(ProjectTracker.DAO.dtsProjectTracker.GroupedCostSavingRow row)
        {
            description = row.Description;
            totalValue = row.TotalValue;
        }

    }

    public class SavingCategoryVO
    {

        #region Fields

        private string abbreviation;
        private int code;
        private string description;

        #endregion

        #region Properties

        public string Abbreviation
        {
            get { return abbreviation; }
            set { abbreviation = value; }
        }

        public int Code
        {
            get { return code; }
            set { code = value; }
        }

        public string Description
        {
            get { return description; }
            set { description = value; }
        }

        #endregion

        public SavingCategoryVO() { }

        public SavingCategoryVO(ProjectTracker.DAO.dtsProjectTracker.SavingCategoryRow row)
        {
            abbreviation = row.Abbreviation;
            code = row.Code;
            description = row.Description;
        }
    }

    public class ProjectVO
    {

        #region Fields

        private string categoryDescription;
        private int code;
        private DateTime commitDate;
        private string customerName;
        private string description;
        private string locationDescription;
        private decimal percentageCompletion;
        private string regionDescription;
        private string remarks;
        private string responsible;
        private string segmentDescription;
        private string statusDescription;        
        private List<GroupedCostSavingVO> groupedCostSavingList;
        private List<CostSaving> costSavingList;
        private DateTime openDate;
        private DateTime closeDate;
        private string engrReportNo;
        private int categoryCode;  
        private string autoCategory;     
        private string autotype;
        private decimal prjCost;       
        private int payback;        
        private int hcBefore;       
        private int hcAfter;        
        private decimal roi; 
        private int prodLife;       
        private decimal reUse;
        private string reportURL;
        private List<SavingCategoryVO> savingCategoryList;
        private string prjStage;
        private int statusCode;
        private int regionCode;
        // Automation enhancmement
        private decimal expectedIRR;
        private string closeReason;        
        private string otherRemarks;
        private string capexApprd;
        private string poIssued;
        private string prjNumber;
        private string flexPaid;
        private string customerPaid;
        private string summaryLink;
        private string roiLink;
        private string videoLink;
        private string siteLead;
        private string coOwner;
        //Automation enhancmement - End
        private DateTime capexAppvdDate;
        private string bestPracticeComment;
        private string bestPractice;

        #endregion

        #region Properties

        public string CategoryDescription
        {
            get { return categoryDescription; }
            set { categoryDescription = value; }
        }

        public int Code
        {
            get { return code; }
            set { code = value; }
        }

        public DateTime CommitDate
        {
            get { return commitDate; }
            set { commitDate = value; }
        }

        public string CustomerName
        {
            get { return customerName; }
            set { customerName = value; }
        }

        public string Description
        {
            get { return description; }
            set { description = value; }
        }

        public string LocationDescription
        {
            get { return locationDescription; }
            set { locationDescription = value; }
        }

        public decimal PercentageCompletion
        {
            get { return percentageCompletion; }
            set { percentageCompletion = value; }
        }

        public string RegionDescription
        {
            get { return regionDescription; }
            set { regionDescription = value; }
        }

        public string Remarks
        {
            get { return remarks; }
            set { remarks = value; }
        }

        public string Responsible
        {
            get { return responsible; }
            set { responsible = value; }
        }

        public string SegmentDescription
        {
            get { return segmentDescription; }
            set { segmentDescription = value; }
        }

        public string StatusDescription
        {
            get { return statusDescription; }
            set { statusDescription = value; }
        }

        public List<GroupedCostSavingVO> GroupedCostSavingList
        {
            get { return groupedCostSavingList; }
            set { groupedCostSavingList = value; }
        }

        public List<CostSaving> CostSavingList
        {
            get { return costSavingList; }
            set { costSavingList = value; }
        }

        public DateTime OpenDate
        {
            get { return openDate; }
            set { openDate = value; }
        }

        public DateTime CloseDate
        {
            get { return closeDate; }
            set { closeDate = value; }
        }

        public string EngrReportNo
        {
            get { return engrReportNo; }
            set { engrReportNo = value; }
        }
        
        public int CATEGORY_CODE
        {
           get { return categoryCode; }
            set { categoryCode = value; }
        }

        public string AUTO_CATEGORY
        {
            get { return autoCategory; }
            set { autoCategory = value; }
        }
        public string AUTO_TYPE
        {
            get { return autotype; }
            set { autotype = value; }
        }
        public decimal PROJECT_COST
        {
              get { return prjCost; }
            set { prjCost = value; }
        }
        public int PAYBACK
        {
              get { return payback; }
            set { payback = value; }
        }
        public int HEADCOUNT_BEFORE
        {
              get { return hcBefore; }
            set { hcBefore = value; }
        }
        public int HEADCOUNT_AFTER
        {
              get { return hcAfter; }
            set { hcAfter = value; }
        }
        public decimal ROI
        {
              get { return roi; }
            set { roi = value; }
        }

        public int PRODUCT_LIFE
        {
             get { return prodLife; }
            set { prodLife = value; }
        }
        public decimal REUSE
        {
              get { return reUse; }
            set { reUse = value; }
        }

        public string ReportURL
        {
            get { return reportURL; }
            set { reportURL = value; }
        }

        public List<SavingCategoryVO> SavingCategoryList
        {
            get { return savingCategoryList; }
            set { savingCategoryList = value; }
        }

        public string ProjectStage
        {
            get { return prjStage; }
            set { prjStage = value; }
        }

        public int StatusCode
        {
            get { return statusCode; }
            set { code = value; }
        }

        public int RegionCode
        {
            get { return regionCode; }
            set { code = value; }
        }
        // Newly added
        public decimal ExpectedIRR
        {
            get { return expectedIRR; }
            set { expectedIRR = value; }
        }
     
        public string CloseReason
        {
            get { return closeReason; }
            set { closeReason = value; }
        }
        
        public string OtherRemarks
        {
            get { return otherRemarks; }
            set { otherRemarks = value; }
        }

        public string CapexApprd
        {
            get { return capexApprd; }
            set { capexApprd = value; }
        }

        public string POIssued
        {
            get { return poIssued; }
            set { poIssued = value; }
        }

        public string PrjNumber
        {
            get { return prjNumber; }
            set { prjNumber = value; }
        }

        public string FlexPaid
        {
            get { return flexPaid; }
            set { flexPaid = value; }
        }

        public string CustomerPaid
        {
            get { return customerPaid; }
            set { customerPaid = value; }
        }

        public string SummaryLink
        {
            get { return summaryLink; }
            set { summaryLink = value; }
        }
        public string ROILink
        {
            get { return roiLink; }
            set { roiLink = value; }
        }
        public string VideoLink
        {
            get { return videoLink; }
            set { videoLink = value; }
        }
        public string SiteLead
        {
            get { return siteLead; }
            set { siteLead = value; }
        }

        public string CoOwner
        {
            get { return coOwner; }
            set { coOwner = value; }
        }
        // End Newly Added columns
        public DateTime CapexAppvdDate
        {
            get { return capexAppvdDate; }
            set { capexAppvdDate = value; }
        }

        public string BestPracticeComment
        {
            get { return bestPracticeComment; }
            set { bestPracticeComment = value; }
        }

        public string BestPractice
        {
            get { return bestPractice; }
            set { bestPractice = value; }
        }


        #endregion

        public ProjectVO() { }

        public ProjectVO(ProjectTracker.DAO.dtsProjectTracker.ListOfProjectsRow row)
        {            
            categoryDescription = row.CATEGORY;
            code = row.CODE;
            commitDate = !row.IsCOMMIT_DATENull() ? row.COMMIT_DATE : DateTime.MinValue;                     
            customerName = row.CUSTOMER;
            description = row.DESCRIPTION;
            locationDescription = row.LOCATION;
            percentageCompletion = !row.IsPROGRESSNull()? row.PROGRESS:0;
            regionDescription = !row.IsREGIONNull()? row.REGION : string.Empty;
            remarks = !row.IsREMARKSNull() ? row.REMARKS : string.Empty;                   
            responsible = row.RESPONSIBLE_NAME;  
            segmentDescription =!row.IsSEGMENTNull()? row.SEGMENT:string.Empty;           
            statusDescription = row.STATUS;
            openDate = row.OPEN_DATE; 
            closeDate =!row.IsCLOSED_DATENull()? row.CLOSED_DATE:DateTime.MinValue;
            engrReportNo = !row.IsENG_REPORT_NUMNull()?row.ENG_REPORT_NUM:string.Empty;           
            categoryCode = row.CATEGORY_CODE;
            autoCategory = !row.IsAUTO_CATEGORYNull()?row.AUTO_CATEGORY:string.Empty;
            autotype =!row.IsAUTO_TYPENull()? row.AUTO_TYPE:string.Empty;
            statusCode = row.STATUSCODE;
            regionCode = row.REGIONCODE;


            if (!row.IsPROJECT_COSTNull())
            {
                prjCost = row.PROJECT_COST;
            }
            else
            {
                prjCost = 0;
            }
            if (!row.IsPAYBACKNull())
            {
                payback = row.PAYBACK;
            }
            else
            {
                payback = 0;
            }
            if (!row.IsHEADCOUNT_BEFORENull())
            {
                hcBefore = row.HEADCOUNT_BEFORE;
            }
            else
            {
                hcBefore = 0;
            }
            if (!row.IsHEADCOUNT_AFTERNull())
            {
                hcAfter = row.HEADCOUNT_AFTER;
            }
            else
            {
                hcAfter = 0;
            }
            if (!row.IsROINull())
            {
                roi = row.ROI;
            }
            else
            {
                roi = 0;
            }
            if (!row.IsPRODUCT_LIFENull())
            {
                prodLife = row.PRODUCT_LIFE;
            }
            else
            {
                prodLife = 0;
            }
            if (!row.IsREUSENull())
            {
                reUse = row.REUSE;
            }
            else
            {
                reUse = 0;
            }
            if (!row.IsENG_LINKNull())
            {
                reportURL = row.ENG_LINK;
            }
            else
            {
                reportURL = string.Empty;
            }
            if (!row.IsSTAGENull())
            {
                prjStage = row.STAGE;
            }
            else
            {
                prjStage = string.Empty;
            }
            
            //Automation Enhancement
            expectedIRR = !row.IsEXPECTEDIRRNull() ? row.EXPECTEDIRR : 0;
            closeReason = !row.IsCLOSEREASONNull() ? row.CLOSEREASON : string.Empty;            
            otherRemarks = !row.IsOTHERREMARKSNull() ? row.OTHERREMARKS : string.Empty;
            capexApprd = !row.IsCAPEXAPPVDNull() ? (!string.IsNullOrEmpty(row.CAPEXAPPVD.Trim()) ? (row.CAPEXAPPVD.Equals("Y") ? "Yes" : "No") : string.Empty) : string.Empty;
            poIssued = !row.IsPOISSUEDNull() ? (!string.IsNullOrEmpty(row.POISSUED.Trim()) ? (row.POISSUED.Equals("Y") ? "Yes" : "No") : string.Empty) : string.Empty;
            prjNumber = !row.IsPRJNUMBERNull() ? row.PRJNUMBER : string.Empty;
            flexPaid = !row.IsFLEXPAIDNull() ? (!string.IsNullOrEmpty(row.FLEXPAID.Trim()) ? (row.FLEXPAID.Equals("F") ? "Flex" : "Customer") : string.Empty) : string.Empty;          
            summaryLink = !row.IsSUMMARYLINKNull() ? row.SUMMARYLINK : string.Empty;
            roiLink = !row.IsROILINKNull() ? row.ROILINK : string.Empty;
            videoLink = !row.IsVIDEOLINKNull() ? row.VIDEOLINK : string.Empty;
            siteLead = !row.IsSITELEADNull() ? row.SITELEAD : string.Empty;
            coOwner = !row.IsCOOWNERNull() ? row.COOWNER : string.Empty;
            //Automation Enhancement - End
            capexAppvdDate = !row.IsCAPEXAPPROVEDDATENull() ? row.CAPEXAPPROVEDDATE : DateTime.MinValue;
            bestPracticeComment = !row.IsBESTPRACTICECOMMENTNull() ? row.BESTPRACTICECOMMENT : string.Empty;
            bestPractice = !row.IsBESTPRACTICENull() ? row.BESTPRACTICE : string.Empty;
        }
    }

    public class Summary
    {
        private int yourClosed;

        /// <summary>
        /// Gets or sets your closed.
        /// </summary>
        /// <value>Your closed.</value>
        public int YourClosed
        {
            get { return yourClosed; }
            set { yourClosed = value; }
        }
        private int yourOpended;

        /// <summary>
        /// Gets or sets your opended.
        /// </summary>
        /// <value>Your opended.</value>
        public int YourOpended
        {
            get { return yourOpended; }
            set { yourOpended = value; }
        }
        private int yourPending;

        /// <summary>
        /// Gets or sets your pending.
        /// </summary>
        /// <value>Your pending.</value>
        public int YourPending
        {
            get { return yourPending; }
            set { yourPending = value; }
        }
        private int allClosed;

        /// <summary>
        /// Gets or sets all closed.
        /// </summary>
        /// <value>All closed.</value>
        public int AllClosed
        {
            get { return allClosed; }
            set { allClosed = value; }
        }
        private int allOpended;

        /// <summary>
        /// Gets or sets all opended.
        /// </summary>
        /// <value>All opended.</value>
        public int AllOpended
        {
            get { return allOpended; }
            set { allOpended = value; }
        }
        private int allPending;

        /// <summary>
        /// Gets or sets all pending.
        /// </summary>
        /// <value>All pending.</value>
        public int AllPending
        {
            get { return allPending; }
            set { allPending = value; }
        }

        

    }
}
