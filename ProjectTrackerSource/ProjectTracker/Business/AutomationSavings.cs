using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace ProjectTracker.Business
{
    public class AutomationSaving
    {
        
        public DataSet GetData()
        {
            string sql = "select 'Select One Option' as AutomationSaving, 0 as ID union select AutomationSaving, ID from tblAutomationSavings order by ID";
            ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
            DataSet ds = instance.Query(sql, null);
            return ds;
        }

        public DataSet GetFooterData(string cStatus = "")
        {
            string sql;
            if (cStatus != null && cStatus.Equals("CLOSEDEPLOYPAIDBYFLEX"))
            {
                sql = "select 'Select One Option' as AutomationSaving, 0 as ID union select AutomationSaving, ID from tblAutomationSavings Where ID <> 9 order by ID";
            }
            else if (cStatus != null && cStatus.Equals("CLOSEDEPLOYPAIDBYCUST"))
            {
                sql = "select 'Select One Option' as AutomationSaving, 0 as ID union select AutomationSaving, ID from tblAutomationSavings Where ID = 9 order by ID";
            }
            else
            {
                sql = "select 'Select One Option' as AutomationSaving, 0 as ID union select AutomationSaving, ID from tblAutomationSavings order by ID";
            }            
            ProjectTracker.DAO.SQLDBHelper instance = new ProjectTracker.DAO.SQLDBHelper();
            DataSet ds = instance.Query(sql, null);
            return ds;
        }
    }
}