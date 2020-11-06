using System;
using System.Data.Common;
using System.Linq;
using LogInformation;
using ProjectDataDO;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System.Data;

namespace ProjectDataDAL
{
    public static class ProjectDataDAC
    {
        public static int InsertProjectData(string spName, ProjectData lstPrjData, out int nProjectOID)
        {
            int lnResult = 0;
            nProjectOID = 0;
            Database db = DatabaseFactory.CreateDatabase("d_PTConnectionString");
            using (DbCommand cmd = db.GetStoredProcCommand(spName))
            {
                try
                {
                    db.AddInParameter(cmd, "@CategoryCode", DbType.Int32, lstPrjData.ncategoryOID);
                    db.AddInParameter(cmd, "@Description", DbType.String, lstPrjData.sDescription);
                    db.AddInParameter(cmd, "@Username", DbType.String, lstPrjData.sUserID);
                    db.AddInParameter(cmd, "@CustomerName", DbType.String, lstPrjData.sCustomer);
                    db.AddInParameter(cmd, "@LocationName", DbType.String, lstPrjData.sLocation);
                    db.AddInParameter(cmd, "@OpenDate", DbType.DateTime, lstPrjData.dtOpenDate);
                    db.AddInParameter(cmd, "@CommitDate", DbType.DateTime, lstPrjData.dtCommitDate);
                    db.AddInParameter(cmd, "@StatusCode", DbType.Int32, lstPrjData.nStatusOID);
                    db.AddInParameter(cmd, "@SegmentName", DbType.String, lstPrjData.sSegment);
                    db.AddInParameter(cmd, "@RegionCode", DbType.Int32, lstPrjData.nRegionOID);
                    db.AddInParameter(cmd, "@BULead", DbType.String, lstPrjData.sSiteLead);
                    db.AddInParameter(cmd, "@PercentCompletion", DbType.Decimal, lstPrjData.dProgressValue);
                    db.AddOutParameter(cmd, "@ProjectOID", DbType.Int32, 4);
                    db.ExecuteNonQuery(cmd);
                    nProjectOID = int.Parse(db.GetParameterValue(cmd, "@ProjectOID").ToString());
                }
                catch (Exception ex)
                {
                    lnResult = -1;
                    string sMsg = string.Format("{0}{1}StackTrace: {2}{1}", ex.Message, Environment.NewLine, ex.StackTrace);
                    LogInfo.LogException(sMsg);
                }
                return lnResult;
            }
        }

    }
}
