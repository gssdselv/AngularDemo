using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using ProjectDataDO;

namespace ProjectTrackerWCFService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "ICreateProject" in both code and config file together.
    [ServiceContract]
    public interface ICreateProject
    {
        [OperationContract]
        int InsertProjectData(ProjectDataDO.ProjectData prjData, out int nProjectOID);
    }

    [DataContract]
    public class ProjectData
    {
        [DataMember]
        public int nRegionOID { get; set; }
        [DataMember]
        public int ncategoryOID { get; set; }
        [DataMember]
        public string sLocation { get; set; }
        [DataMember]
        public string sDescription { get; set; }
        [DataMember]
        public string sUserID { get; set; }
        [DataMember]
        public string sSiteLead { get; set; }
        [DataMember]
        public string sCustomer { get; set; }
        [DataMember]
        public string sSegment { get; set; }
        [DataMember]
        public int nStatusOID { get; set; }
        [DataMember]
        public DateTime dtOpenDate { get; set; }
        [DataMember]
        public DateTime dtCommitDate { get; set; }
        [DataMember]
        public DateTime dtClosedDate { get; set; }
        [DataMember]
        public decimal dProgressValue { get; set; }
    }
}
