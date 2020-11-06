using ProjectDataDO;
using System;
using System.Linq;
using ProjectDataDAL;

namespace ProjectDataBLL
{
    public class ProjectDataBC
    {
        public int InsertProject(string spName, ProjectData prjData, out int nProjectOID)
        {
            int result = ProjectDataDAC.InsertProjectData(spName, prjData, out nProjectOID);
            return result;
        }
    }
}
