using ProjectDataBLL;

namespace ProjectTrackerWCFService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "CreateProject" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select CreateProject.svc or CreateProject.svc.cs at the Solution Explorer and start debugging.
    public class CreateProject : ICreateProject
    {
        public int InsertProjectData(ProjectDataDO.ProjectData prjData, out int nProjectOID)
        {
            ProjectDataBC bcPrjDataBC = new ProjectDataBLL.ProjectDataBC();
            int lnResult = 0;
            lnResult = bcPrjDataBC.InsertProject("SP_FIT_PT_INSERT_PROJECT_EXTSYSTEM", prjData, out nProjectOID);
            return lnResult;
        }
    }
}
