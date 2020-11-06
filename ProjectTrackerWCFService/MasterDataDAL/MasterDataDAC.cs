using System;
using System.Collections.Generic;
using System.Linq;
using MasterDataDO;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System.Data.Common;
using System.Data;
using LogInformation;

namespace MasterDataDAL
{
    public static class MasterDataDAC
    {
        public static int GetAllData(string spName, out List<MasterData> lstMstData)
        {
            int lnResult = 0;
            lstMstData = new List<MasterData>();
            Database db = DatabaseFactory.CreateDatabase("d_PTConnectionString");
            using (DbCommand cmd = db.GetStoredProcCommand(spName))
            {
                try
                {
                    using (IDataReader dr = db.ExecuteReader(cmd))
                    {
                        if (dr.Read())
                        {
                            int nIDOrd = dr.GetOrdinal("ID");
                            int nDisplayNameOrd = dr.GetOrdinal("DisplayName");
                            do
                            {
                                MasterData oMstData = new MasterData();
                                oMstData.ID = !dr.IsDBNull(nIDOrd) ? dr.GetInt32(nIDOrd) : -1;
                                oMstData.Name = !dr.IsDBNull(nDisplayNameOrd) ? dr.GetString(nDisplayNameOrd) : null;
                                lstMstData.Add(oMstData);
                            }
                            while (dr.Read());
                        }
                    }
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
