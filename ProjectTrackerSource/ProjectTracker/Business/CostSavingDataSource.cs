using System;
using System.Data;
using System.Web;
using System.Collections.Generic;
using System.ComponentModel;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;

namespace ProjectTracker.Business
{
    /// <summary>
    /// Class to control the cost savings of a project in the user's session
    /// </summary>
    public class CostSavingDataSource
    {

        /// <summary>
        /// Clears the session when the list of cost savings needs to be cleared
        /// </summary>
        public static void ClearSession(HttpContext old_Context)
        {
            //HttpContext.Current.Session.Abandon();
            old_Context.Session.Abandon();
            HttpContext context = HttpContext.Current;
            context.Session["actualCostSavingId"] = 1;
            context.Session["CostSavingList"] = new List<CostSaving>();
            context.Session["CostSavingListLoaded"] = false;
            context.Session["HasChanged"] = false;
        }

        /// <summary>
        /// Controls the id counter to the cost saving list
        /// </summary>
        public bool HasChanged
        {
            get
            {
                if (HttpContext.Current.Session["HasChanged"] == null)
                {
                    HttpContext.Current.Session.Remove("HasChanged");
                    HttpContext.Current.Session["HasChanged"] = false;
                }
                return (bool)HttpContext.Current.Session["HasChanged"];
            }
            set
            {
                HttpContext.Current.Session.Remove("HasChanged");
                HttpContext.Current.Session["HasChanged"] = value;
            }
        }

        /// <summary>
        /// Controls the id counter to the cost saving list
        /// </summary>
        private int actualCostSavingId
        {
            get
            {
                if (HttpContext.Current.Session["actualCostSavingId"] == null)
                {
                    HttpContext.Current.Session.Remove("actualCostSavingId");
                    HttpContext.Current.Session["actualCostSavingId"] = 1;
                }
                return (int)HttpContext.Current.Session["actualCostSavingId"];
            }
            set
            {
                HttpContext.Current.Session.Remove("actualCostSavingId");
                HttpContext.Current.Session["actualCostSavingId"] = value;
            }
        }

        /// <summary>
        /// The cost saving list itself
        /// </summary>
        private List<CostSaving> costSavingList
        {
            get
            {
                if (HttpContext.Current.Session["CostSavingList"] == null)
                {
                    HttpContext.Current.Session.Remove("CostSavingList");
                    HttpContext.Current.Session["CostSavingList"] = new List<CostSaving>();
                }
                return (List<CostSaving>)HttpContext.Current.Session["CostSavingList"];
            }
            set
            {
                HttpContext.Current.Session.Remove("CostSavingList");
                HttpContext.Current.Session["CostSavingList"] = value;
            }
        }

        /// <summary>
        /// Indicates if the list was already loaded from database
        /// </summary>
        private bool costSavingListLoaded
        {
            get
            {
                if (HttpContext.Current.Session["CostSavingListLoaded"] == null)
                {
                    HttpContext.Current.Session.Remove("CostSavingListLoaded");
                    HttpContext.Current.Session["CostSavingListLoaded"] = false;
                }
                return (bool)HttpContext.Current.Session["CostSavingListLoaded"];
            }
            set
            {
                HttpContext.Current.Session.Remove("CostSavingListLoaded");
                HttpContext.Current.Session["CostSavingListLoaded"] = value;
            }
        }

        /// <summary>
        /// Inserts a new cost saving into the list
        /// </summary>
        /// <param name="costSaving">The cost saving to be added</param>
        /// <returns>The added cost saving</returns>
        public CostSaving InsertCostSaving(CostSaving costSaving)
        {
            costSavingList.Add(costSaving);
            if (costSaving.CostSavingId == 0)
            {
                costSaving.CostSavingId = actualCostSavingId++;
            }
            for (int i = 0; i < costSavingList.Count; i++)
            {
                if (costSavingList[i].CostSavingId == -1)
                {
                    costSavingList.RemoveAt(i);
                    break;
                }
            }
            return costSaving;
        }

        /// <summary>
        /// Deletes a cost saving from the list
        /// </summary>
        /// <param name="cs">The cost saving to be deleted</param>
        [DataObjectMethod(DataObjectMethodType.Delete, true)]
        public void DeleteCostSaving(CostSaving cs)
        {
            int CostSavingId = 0;
            if (cs != null)
            {
                CostSavingId = cs.CostSavingId;
            }
            for (int i = 0; i < costSavingList.Count; i++)
            {
                CostSaving costSaving = costSavingList[i];
                if (costSaving.CostSavingId == CostSavingId)
                {
                    costSavingList.RemoveAt(i--);
                    break;
                }
            }
        }

        /// <summary>
        /// Updates a cost saving in the list
        /// </summary>
        /// <param name="costSaving">The cost saving to be deleted</param>
        public void UpdateCostSaving(CostSaving costSaving)
        {
            DeleteCostSaving(costSaving);
            costSavingList.Add(costSaving);
            for (int i = 0; i < costSavingList.Count - 1; i++)
            {
                for (int j = i + 1; j < costSavingList.Count; j++)
                {
                    CostSaving cs1 = costSavingList[i];
                    CostSaving cs2 = costSavingList[j];
                    if (cs1.CostSavingId > cs2.CostSavingId)
                    {
                        costSavingList[i] = cs2;
                        costSavingList[j] = cs1;
                    }
                }
            }
        }

        /// <summary>
        /// Get the list of cost savings in the user's session
        /// </summary>
        /// <returns>The list of cost savings</returns>
        public List<CostSaving> GetAllCostSaving()
        {
            if (costSavingList == null || costSavingList.Count == 0)
            {
                CostSaving emptyCostSaving = new CostSaving(-1, 0, 0, 0, DateTime.Now, 0, null, null);
                emptyCostSaving.AutomationSaving = "";
                emptyCostSaving.AutomationSavingId = 0;
                costSavingList.Add(emptyCostSaving);
            }
            return costSavingList;
        }



        /// <summary>
        /// Loads the cost savings list from database when necessary
        /// </summary>
        /// <param name="ProjectId">The id of the project that the list belongs to</param>
        /// <returns>The list of cost savings</returns>
        public List<CostSaving> GetAllCostSaving(int ProjectId)
        {
            //costSavingList.Clear();//Added by Guoxin Liu 2012-08-23
            if (!costSavingListLoaded) //Commented by Guoxin Liu 2012-08-23
            //if (true)
            {
                ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
                //List<CostSaving> temp = new List<CostSaving>();
                CostSavingTableAdapter costSavingTableAdapter = new CostSavingTableAdapter();
                ProjectTracker.DAO.dtsProjectTracker.CostSavingDataTable costSavingDataTable = costSavingTableAdapter.GetData(ProjectId);
                foreach (ProjectTracker.DAO.dtsProjectTracker.CostSavingRow row in costSavingDataTable.Rows)
                {
                    CostSaving costSaving = new CostSaving();
                    costSaving.CostSavingId = row.PO_CODIGO;
                    costSaving.Date = row.PN_SAVINGDATE;
                    costSaving.ProjectId = row.PJ_CODIGO;
                    costSaving.SavingAmount = row.PN_SAVINGAMOUNT;
                    costSaving.SavingCategory = row.PN_DESCRIPTION;
                    costSaving.SavingCategoryId = row.PN_CODIGO;
                    costSaving.SavingType = row.PV_DESCRIPTION;
                    costSaving.SavingTypeId = row.PV_CODIGO;
                    string sql = "select A.AUTOMATION_SAVING_CODIGO, B.AutomationSaving from TB_PT_PO_COSTSAVING A left join tblAutomationSavings B on Isnull(A.AUTOMATION_SAVING_CODIGO,0) = B.ID where A.PO_CODIGO = {0}";
                    sql = string.Format(sql, row.PO_CODIGO.ToString());
                    DataSet ds = instance.Query(sql, null);
                    int automationSavingID = 0;
                    string automationSaving = "Select One Option";
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow dr = ds.Tables[0].Rows[0];
                        if (dr["AUTOMATION_SAVING_CODIGO"].ToString() != "")
                        {
                            automationSavingID = System.Convert.ToInt32(dr["AUTOMATION_SAVING_CODIGO"].ToString());
                            automationSaving = dr["AutomationSaving"].ToString();
                        }
                    }
                    if (automationSaving == "") automationSaving = "Select One Option";
                    costSaving.AutomationSavingId = automationSavingID;
                    costSaving.AutomationSaving = automationSaving;
                    costSavingList.Add(costSaving);
                    //temp.Add(costSaving);
                }

                //if (temp == null || temp.Count == 0)
                //{
                //    CostSaving emptyCostSaving = new CostSaving(-1, 0, 0, 0, DateTime.Now, 0, null, null);
                //    temp.Add(emptyCostSaving);
                //}

                //return temp;

                costSavingListLoaded = true;
            }
            return GetAllCostSaving();
        }

        public List<CostSaving> GetAllCostSavingForReport(int ProjectId)
        {
            costSavingList.Clear();//Added by Guoxin Liu 2012-08-23
            //if (!costSavingListLoaded) //Commented by Guoxin Liu 2012-08-23
            if (true)
            {
                List<CostSaving> temp = new List<CostSaving>();
                CostSavingTableAdapter costSavingTableAdapter = new CostSavingTableAdapter();
                ProjectTracker.DAO.dtsProjectTracker.CostSavingDataTable costSavingDataTable = costSavingTableAdapter.GetData(ProjectId);
                foreach (ProjectTracker.DAO.dtsProjectTracker.CostSavingRow row in costSavingDataTable.Rows)
                {
                    CostSaving costSaving = new CostSaving();
                    costSaving.CostSavingId = row.PO_CODIGO;
                    costSaving.Date = row.PN_SAVINGDATE;
                    costSaving.ProjectId = row.PJ_CODIGO;
                    costSaving.SavingAmount = row.PN_SAVINGAMOUNT;
                    costSaving.SavingCategory = row.PN_DESCRIPTION;
                    costSaving.SavingCategoryId = row.PN_CODIGO;
                    costSaving.SavingType = row.PV_DESCRIPTION;
                    costSaving.SavingTypeId = row.PV_CODIGO;
                    //costSavingList.Add(costSaving);
                    temp.Add(costSaving);
                }

                if (temp == null || temp.Count == 0)
                {
                    CostSaving emptyCostSaving = new CostSaving(-1, 0, 0, 0, DateTime.Now, 0, null, null);
                    temp.Add(emptyCostSaving);
                }

                return temp;
            }
        }

        /// <summary>
        /// Saves the list into the database
        /// </summary>
        /// <param name="projectId">The id of the project that owns the list</param>
        public void PersistCostSavingList(int projectId)
        {
            if (HasChanged)
            {
                ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
                CostSavingTableAdapter costSavingTableAdapter = new CostSavingTableAdapter();
                costSavingTableAdapter.DeleteByProject(projectId);
                foreach (CostSaving costSaving in costSavingList)
                {
                    if (costSaving.CostSavingId != -1)
                    {
                        costSavingTableAdapter.InsertCostSaving(projectId, costSaving.SavingTypeId, costSaving.SavingCategoryId, costSaving.SavingAmount, costSaving.Date);
                        string sql = "select Max(PO_CODIGO) from TB_PT_PO_COSTSAVING";
                        object obj = instance.GetSingle(sql, null);
                        int pOCodigo = System.Convert.ToInt32(obj);
                        sql = string.Format("update TB_PT_PO_COSTSAVING set AUTOMATION_SAVING_CODIGO = {0} where PO_CODIGO = {1}", costSaving.AutomationSavingId.ToString(), pOCodigo.ToString());
                        //sql = string.Format(sql, costSaving.AutomationSavingId.ToString(), pOCodigo.ToString());
                        instance.ExecuteSQL(sql, null);
                    }
                }
                if (costSavingList.Count > 0) // upon insert, formview clears all controls except gridview. So we clear list bounded to the grid
                {
                    costSavingList.Clear();
                }
            }
        }

    }

    /// <summary>
    /// Class to hold all the informations of one cost saving
    /// </summary>
    [Serializable]
    public class CostSaving
    {

        private int costSavingId;
        private int projectId;
        private int savingTypeId;
        private int savingCategoryId;
        private DateTime date;
        private decimal savingAmount;
        private string savingType;
        private string savingCategory;
        private string dateString;
        private int automationSavingId;
        private string automationSaving;

        public string DateString
        {
            get
            {
                if (String.IsNullOrEmpty(dateString))
                {
                    dateString = String.Format("{0:d}", date);
                }
                return dateString;
            }
            set
            { 
                dateString = value;
                if (!String.IsNullOrEmpty(dateString))
                {
                    DateTime.TryParse(dateString, out date);
                }
            }
        }

        public int CostSavingId
        {
            get { return costSavingId; }
            set { costSavingId = value; }
        }

        public int ProjectId
        {
            get { return projectId; }
            set { projectId = value; }
        }

        public int SavingTypeId
        {
            get { return savingTypeId; }
            set { savingTypeId = value; }
        }

        public int SavingCategoryId
        {
            get { return savingCategoryId; }
            set { savingCategoryId = value; }
        }

        public DateTime Date
        {
            get { return date; }
            set { date = value; }
        }

        public decimal SavingAmount
        {
            get { return savingAmount; }
            set { savingAmount = value; }
        }

        public int AutomationSavingId
        {
            get { return automationSavingId; }
            set { automationSavingId = value; }
        }

        public string AutomationSaving
        {
            get { return automationSaving; }
            set { automationSaving = value; }
        }

        public string SavingType
        {
            get { return savingType; }
            set { savingType = value; }
        }

        public string SavingCategory
        {
            get { return savingCategory; }
            set { savingCategory = value; }
        }

        public CostSaving()
        {
        }

        public CostSaving(int costSavingId, int projectId, int savingTypeId, int savingCategoryId, DateTime date, decimal savingAmount, string savingType, string savingCategory)
            : this()
        {
            this.costSavingId = costSavingId;
            this.projectId = projectId;
            this.savingTypeId = savingTypeId;
            //this.savingCategoryId = savingCategoryId;
            this.date = date;
            this.savingAmount = savingAmount;
            this.savingType = savingType;
            this.savingCategoryId = savingCategoryId;
            this.savingCategory = savingCategory;

            //if (this.savingTypeId = 3)
            //{
            //    this.savingCategoryId = 10;
            //    this.savingCategory = "Revenue";
            //}
            //else
            //{
            //    this.savingCategoryId = savingCategoryId;
            //    this.savingCategory = savingCategory;
            //}
            
        }

    }

}
