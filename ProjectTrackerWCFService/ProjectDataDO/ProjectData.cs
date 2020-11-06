using System;
using System.Linq;

namespace ProjectDataDO
{
    public class ProjectData
    {
        public int nRegionOID { get; set; }
        public int ncategoryOID { get; set;}
        public string sLocation { get; set; }
        public string sDescription { get; set; }
        public string sUserID { get; set; }
        public string sSiteLead { get; set; }
        public string sCustomer { get; set; }
        public string sSegment { get; set; }
        public int nStatusOID { get; set; }
        public DateTime dtOpenDate { get; set; }
        public Nullable<DateTime> dtCommitDate { get; set; }
        public Nullable<DateTime> dtClosedDate { get; set; }
        public decimal dProgressValue { get; set; }
    }
}
