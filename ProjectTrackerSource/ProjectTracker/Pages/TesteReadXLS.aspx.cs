using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Fit.Base;
using ProjectTracker.Business;
using System.Globalization;

namespace ProjectTracker.Pages
{
    public partial class TesteReadXLS : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
            #region List of Responsibles

            Hashtable hsTb = new Hashtable();
            hsTb.Add("Dason Cheung", "sjcdcheu");
            hsTb.Add("David Santiago Ramirez", "gdldaram");
            hsTb.Add("Jin Parker", "BLDJParker");
            hsTb.Add("Jorge Valle", "GDLJVall");
            hsTb.Add("Juan Coronado", "gdljumen");
            hsTb.Add("Nestor Martinez", "GDLnmart");
            hsTb.Add("Omar Garcia", "GDLomgar");


            hsTb.Add("Dason", "sjcdcheu");
            hsTb.Add("David", "gdldaram");
            hsTb.Add("Jin", "BLDJParker");
            hsTb.Add("Jim", "BLDJParker");
            hsTb.Add("Jorge", "GDLJVall");
            hsTb.Add("Juan", "gdljumen");
            hsTb.Add("Nestor", "GDLnmart");
            hsTb.Add("Omar", "GDLomgar");
            hsTb.Add("Murad", "sjcmkurw");



            #endregion
            ProjectTracker.Business.User u = new ProjectTracker.Business.User();
            ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ProjectsTableAdapter project = new ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ProjectsTableAdapter();
            DataTable tb = Library.Excel.GetData(ConfigurationManager.ConnectionStrings["connExcel"].ConnectionString, "DATA");
            Project ptojectsBU = new Project();


            foreach (DataRow dtRow in tb.Rows)
            {
                //string responsibles                
                string[] responsibles = dtRow[3].ToString().Split('/');

                string[] partsName = responsibles[0].Split(' ');

                string firstName = partsName[0];
                string description = dtRow[2].ToString();
                string lastName = "%";

                ProjectTracker.DAO.dtsProjectTracker.ProjectsDataTable tbDatabase = new ProjectTracker.DAO.dtsProjectTracker.ProjectsDataTable();
                project.FillByDescription(tbDatabase, description, "%", "%", "%", "%", "%", "%");

                if (tbDatabase.Rows.Count < 1 || firstName!="Jin")
                    continue;
                

                int code = Convert.ToInt32(tbDatabase.Rows[0]["Code"]);
                
                ////string username = "";
                ////ADUserSelect user = u.GetUser(firstName, lastName);
                ////if (user == null)
                ////{

                ////    if (hsTb.Contains(firstName))
                ////    {
                ////        username = hsTb[firstName].ToString();
                ////    }
                ////    else
                ////    {
                ////        username = "";
                ////    }


                ////}
                ////else
                ////    username = user.UserName;

                //string strCostSaving = dtRow[11].ToString();
                //double? costSaving = null;
                //if (!String.IsNullOrEmpty(strCostSaving.Trim()) && strCostSaving.Trim() != "N/A" && strCostSaving.Trim() != "NA" && strCostSaving.Trim() != "TBD" && strCostSaving.Trim() != "TDB")
                //{
                //    try
                //    {
                //        if (strCostSaving[0] == '0')
                //        {
                //            strCostSaving = "0";
                //        }

                //        if(strCostSaving.IndexOf('$') != -1)
                //            strCostSaving = strCostSaving.Remove(strCostSaving.IndexOf('$')).Trim();

                //        NumberFormatInfo numberFormat = new NumberFormatInfo();
                //        numberFormat.NumberDecimalSeparator = ",";
                //        costSaving = Convert.ToDouble(strCostSaving, numberFormat);

                //        project.UpdateCostSaving(new Decimal?(Convert.ToDecimal(costSaving)), code);

                //    }
                //    catch (Exception ex)
                //    { }
                //}
                //else if (strCostSaving.Trim() == "N/A" || strCostSaving.Trim() == "NA" || strCostSaving.Trim() == "TBD" || strCostSaving.Trim() == "TDB")
                //{
                //    costSaving = 0;
                //    project.UpdateCostSaving(new Decimal?(Convert.ToDecimal(costSaving)), code);
                //}



                
                //projects.Import(category, description, responsible, customer, location, openDate, commitDate, closedDate, ocdh[0], costSaving, remarks);
                //if (username != "")
                ptojectsBU.UpdateResponsible(firstName, code, project);
                //else
                //    username = "";

                //Find responsibles
                //string firstName = dtRow[3].ToString();
                //string lastName;

                

                //string username = "saosfava";
                //if (hsTb.ContainsKey(firstName))
                //{
                //    username = hsTb[firstName].ToString();
                //}


                //ProjectTracker.Business.Project projects = new ProjectTracker.Business.Project();

                ////Get values
                //string category = dtRow[1].ToString();
                //string description = dtRow[2].ToString();
                //string responsible = username;
                //string customer = dtRow[4].ToString();
                //string location = dtRow[5].ToString();

                //DateTime openDate;
                //try
                //{
                //    openDate = Convert.ToDateTime(dtRow[6].ToString());
                //}
                //catch (Exception ex)
                //{
                //    openDate = new DateTime(2007, 1, 1);
                //}

                //DateTime? commitDate = null;
                //if (!String.IsNullOrEmpty(dtRow[7].ToString()))
                //    commitDate = Convert.ToDateTime(dtRow[7].ToString());

                //DateTime? closedDate = null;
                //if (!String.IsNullOrEmpty(dtRow[8].ToString()))
                //{
                //    try
                //    {
                //        closedDate = Convert.ToDateTime(dtRow[8].ToString());
                //    }
                //    catch (Exception ex)
                //    {
                //        closedDate = new DateTime(2007, 1, 1);
                //    }
                //}



                //string ocdh = dtRow[10].ToString();

                //string strCostSaving = dtRow[11].ToString();
                //double? costSaving = null;
                //if (!String.IsNullOrEmpty(strCostSaving.Trim()) && strCostSaving.Trim() != "N/A" && strCostSaving.Trim() != "NA")
                //{
                //    try
                //    {
                //        strCostSaving = strCostSaving.Remove(strCostSaving.IndexOf('$')).Trim();
                //        NumberFormatInfo numberFormat = new NumberFormatInfo();
                //        numberFormat.NumberDecimalSeparator = ",";
                //        costSaving = Convert.ToDouble(strCostSaving, numberFormat);
                //    }
                //    catch (Exception ex)
                //    { }
                //}

                //string remarks = dtRow[12].ToString();
                //if (ocdh == "")
                //    ocdh = "C";

                

            }
                
            */

        }
    }
}
