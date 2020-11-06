using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MasterDataDO;
using MasterDataDAL;

namespace MasterDataBLL
{
    public class MasterDataBC
    {
        public int GetAllData(string spName, out List<MasterData> lstMstData)
        {
            lstMstData = null;
            int result = MasterDataDAC.GetAllData(spName, out lstMstData);
            return result;
        }
    }
}
