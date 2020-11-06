using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace ProjectTrackerWCFService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IProjectTrackerDataService" in both code and config file together.
    [ServiceContract]
    public interface IProjectTrackerDataService
    {
        [OperationContract]
        List<MasterDataDetail> GetAllCustomerList();

        [OperationContract]
        List<MasterDataDetail> GetAllSegmentList();

        [OperationContract]
        List<MasterDataDetail> GetAllCatergoryList();
    }

    [DataContract]
    public class MasterDataDetail
    {
        int nID;
        string sDisplayName = string.Empty;

        [DataMember]
        public int ID
        {
            get { return nID; }
            set { nID = value; }
        }

        [DataMember]
        public string Name
        {
            get { return sDisplayName; }
            set { sDisplayName = value; }
        }
    }
}
