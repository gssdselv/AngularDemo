using System;
using System.Collections.Generic;
using System.Linq;
using MasterDataBLL;
using MasterDataDO;

namespace ProjectTrackerWCFService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "ProjectTrackerDataService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select ProjectTrackerDataService.svc or ProjectTrackerDataService.svc.cs at the Solution Explorer and start debugging.
    public class ProjectTrackerDataService : IProjectTrackerDataService
    {
        public List<MasterDataDetail> GetAllCustomerList()
        {
            return GetAllData("Customer");
        }
        public List<MasterDataDetail> GetAllSegmentList()
        {
            return GetAllData("Segment");
        }

        public List<MasterDataDetail> GetAllCatergoryList()
        {
            return GetAllData("Category");
        }

        public List<MasterDataDetail> GetAllData(string sMasterDataType)
        {
            string spName = string.Empty;
            if (sMasterDataType.Equals("Customer"))
            {
                spName = "SP_GETALLCUSTOMER";
            }
            else if (sMasterDataType.Equals("Segment"))
            {
                spName = "SP_GETALLSEGMENTS";
            }
            else
            {
                spName = "SP_GETALLCATEGORY";
            }
            List<MasterDataDetail> lstMstData = new List<MasterDataDetail>();
            MasterDataBC mDBc = new MasterDataBC();
            List<MasterData> lstMaster = new List<MasterData>();
            int lnResult = 0;
            lnResult = mDBc.GetAllData(spName, out lstMaster);
            if (lnResult > -1)
            {
                foreach (var data in lstMaster)
                {
                    MasterDataDetail oMD = new MasterDataDetail();
                    oMD.ID = data.ID;
                    oMD.Name = data.Name;
                    lstMstData.Add(oMD);
                }
            }
            else
            {
                return null;
            }
            return lstMstData;
        }
    }
}
