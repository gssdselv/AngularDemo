using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace ProjectTracker.Business
{
    public class Group
    {
        public static DataSet GetGroups()
        {
            string sql = "select * from tblGroups where isnull(Deleted,'0') = '0' order by GroupName";
            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
            DataSet ds = instance.Query(sql, null);

            return ds;
        }

        public static DataSet GetProjectsForGroup(string groupName, string status)
        {
            string sp = "";

            if (status == "Open")
            {
                sp = "dbo.sp_FIT_LIST_OF_PROJECTS_For_ShareNet_Open";
            }
            else
            {
                sp = "dbo.sp_FIT_LIST_OF_PROJECTS_For_ShareNet_Closed";
            }

            if (status == "Open") status = "21";
            if (status == "Closed") status = "20";

            int statusID = System.Convert.ToInt32(status);

            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
            string responsibles = string.Empty;

            string sql = "select A.* from tblGroup_Rel_User A inner join tblGroups B on A.GroupID = B.ID where B.GroupName = '{0}' and Isnull(A.Deleted,'0') = '0'";
            sql = string.Format(sql, groupName);

            DataSet ds = instance.Query(sql, null);

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (responsibles.Length > 0) responsibles += ",";
                responsibles += dr["PU_USUARIO"].ToString();
            }

            List<SqlParameter> listParam = new List<SqlParameter>();

            listParam.Add(new SqlParameter("@Region", System.Convert.ToInt32(0)));
            listParam.Add(new SqlParameter("@Customer", System.Convert.ToInt32(0)));
            listParam.Add(new SqlParameter("@Location", System.Convert.ToInt32(0)));
            listParam.Add(new SqlParameter("@Responsible", responsibles));
            listParam.Add(new SqlParameter("@Status", statusID));
            listParam.Add(new SqlParameter("@Actual_Date", "%"));
            listParam.Add(new SqlParameter("@StartWeek", DateTime.Parse("2002-01-01")));
            listParam.Add(new SqlParameter("@EndWeek", DateTime.Now));
            listParam.Add(new SqlParameter("@Segment", System.Convert.ToInt32(0)));
            listParam.Add(new SqlParameter("@UserName", "dmnguoxl"));
            listParam.Add(new SqlParameter("@SavingCategory", System.Convert.ToInt32(0)));
            listParam.Add(new SqlParameter("@RvCs", System.Convert.ToInt32(0)));

            ds = instance.QueryBySP(sp, listParam.ToArray());

            return ds;
        }

        public static void EmptyDelete(Int64 ID)
        {

        }

        public static void EmptyDelete()
        {

        }
    }
}