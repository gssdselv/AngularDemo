using System.Collections.Generic;
using System;
using PowerPoint = Microsoft.Office.Interop.PowerPoint;
using ProjectTracker.Business;
using System.IO;
using System.Configuration;

namespace ProjectTracker.PPTHelper
{
    public class ProjectPowerPointCreator
    {
        #region Attributes        
        private string templateAutopath;
        private string templateManualPath;
        private string tempFolder;
        private PowerPoint.Application app = null;
        private PowerPoint.Presentation presentation = null;
        private List<SavingCategoryVO> savingCategories = null;
        private List<string> lstSaveCat = null;
        private List<string> lstUniqueSaveCat = null;
        private const string CONST_URL = "http://intranet.flextronics.com";
        #endregion        

        public ProjectPowerPointCreator(string templateAuto, string templateManual, List<SavingCategoryVO> savingCategories, string tempFolder)
        {

            this.templateAutopath = templateAuto;
            this.savingCategories = savingCategories;
            this.tempFolder = tempFolder;
            this.templateManualPath = templateManual;
            

            if (!File.Exists(templateAutopath))
                throw new Exception(string.Format("Template was not found - {0}", templateAutopath));
        }

        public byte[] ExportToPowerPoint(List<ProjectVO> projects, string fileName)
        {
            string filePath = Path.Combine(tempFolder, Path.ChangeExtension(fileName, "ppt"));
            int currentSlide = 0;
            string[] codesToEnable = ConfigurationManager.AppSettings["AUTOMATIONCATEGORY"].Split(',');            
            try
            {
                CreatePptApplication();
                // get the presentations for this new application
                PowerPoint.Presentations presentations = app.Presentations;
                int posCat = -1;
                int projectIndex = 0;               
                for (int i = 0; i < projects.Count; i++)
                {
                    if (currentSlide == 0)
                    {
                        currentSlide = 2;
                        posCat = Array.IndexOf(codesToEnable, projects[i].CATEGORY_CODE.ToString());
                        if (posCat > -1)
                        {
                            presentation = presentations.Open(this.templateAutopath,
                            Microsoft.Office.Core.MsoTriState.msoFalse, Microsoft.Office.Core.MsoTriState.msoTrue, Microsoft.Office.Core.MsoTriState.msoFalse);
                        }
                        else
                        {
                            presentation = presentations.Open(this.templateManualPath,
                            Microsoft.Office.Core.MsoTriState.msoFalse, Microsoft.Office.Core.MsoTriState.msoTrue, Microsoft.Office.Core.MsoTriState.msoFalse);
                        }
                    }
                    projectIndex++;
                    FillProjectDetails(presentation.Slides[currentSlide], projects[i]);
                    currentSlide = currentSlide + 1;
                    FillRemarks(presentation.Slides[currentSlide], projects[i]);
                    if (projectIndex < projects.Count)
                    {
                        posCat = Array.IndexOf(codesToEnable, projects[i + 1].CATEGORY_CODE.ToString());
                        if (posCat > -1)
                        {
                            presentation.Slides.InsertFromFile(this.templateAutopath, currentSlide++, 2, 3);
                        }                        
                        else
                        {
                            presentation.Slides.InsertFromFile(this.templateManualPath, currentSlide++, 2, 3);
                        }
                    }
                }

                presentation.SaveAs(filePath, PowerPoint.PpSaveAsFileType.ppSaveAsPresentation, Microsoft.Office.Core.MsoTriState.msoTrue);
            }
            catch (Exception ex)
            {              
                throw new Exception(string.Format("Could not load projects - {0}{1}{2}", ex.Message, ex.StackTrace,currentSlide));
            }
            finally
            {
                if (presentation != null)
                {
                    presentation.Close();
                    System.Runtime.InteropServices.Marshal.ReleaseComObject(presentation);
                    presentation = null;
                }
                if (app != null)
                {
                    app.Quit();
                    System.Runtime.InteropServices.Marshal.ReleaseComObject(app);
                    app = null;
                }
                GC.Collect();
            }

            if (File.Exists(filePath))
            {
                FileStream fileStream = new FileStream(filePath, FileMode.Open);
                byte[] fileByteArray = new byte[fileStream.Length];
                fileStream.Read(fileByteArray, 0, fileByteArray.Length);
                fileStream.Close();
                fileStream.Dispose();
                File.Delete(filePath);
                return fileByteArray;
            }

            return null;

        }

        private void FillRemarks(PowerPoint.Slide slide, ProjectVO project)
        {
            string costSavings = "";
            foreach (GroupedCostSavingVO costSaving in project.GroupedCostSavingList)
            {
                costSavings += string.Format(" {0} - {1}\r", costSaving.Description, costSaving.TotalValue.ToString("c"));
            }

            for (int i = 1; i <= slide.Shapes.Count; i++)
            {
                if (slide.Shapes[i].HasTextFrame == Microsoft.Office.Core.MsoTriState.msoTrue)
                {
                    switch (slide.Shapes[i].TextFrame.TextRange.Text.Trim())
                    {
                        case "":
                            break;
                        case "#REGION# – #DESCRIPTION#":
                            string sTitle = string.Empty;
                            sTitle = string.Concat(string.Format("{0} - ", project.RegionDescription), project.Description);
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#REGION# – #DESCRIPTION#", sTitle);
                            break;
                        //case "#DESCRIPTION#":
                        //    slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#DESCRIPTION#", project.Description);
                        //    break;
                        case "#OWNER#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#OWNER#", project.Responsible);
                            break;
                        case "#LOCATIONS#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#LOCATIONS#", project.LocationDescription);
                            break;
                        case "#REPORT#":
                            if (project.ReportURL.StartsWith(CONST_URL, StringComparison.Ordinal))
                            {
                                slide.Shapes[i].TextFrame.TextRange.ActionSettings[PowerPoint.PpMouseActivation.ppMouseClick].Hyperlink.Address = project.ReportURL;
                                slide.Shapes[i].TextFrame.TextRange.ActionSettings[PowerPoint.PpMouseActivation.ppMouseClick].Hyperlink.TextToDisplay = project.EngrReportNo;
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#REPORT#", "N/A");
                            }                            
                            break;
                        case "#REMARKS#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#REMARKS#", project.Remarks);
                            break;

                        case "#PAIDBY#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PAIDBY#", project.FlexPaid);
                            break;
                        case "#CAPEX#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CAPEX#", project.CapexApprd);
                            break;
                        case "#CAPEXDATE#":
                            if (!project.CapexAppvdDate.Equals(DateTime.MinValue))
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CAPEXDATE#", project.CapexAppvdDate.ToString("MM/dd/yyyy"));
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CAPEXDATE#", string.Empty);
                            }
                            break;
                        case "#PO#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PO#", project.POIssued);
                            break;
                        case "#PRJNO#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PRJNO#", project.PrjNumber);
                            break;
                        case "#IRR#":
                            if (project.ExpectedIRR > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#IRR#", project.ExpectedIRR.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#IRR#", string.Empty);
                            }                            
                            break;
                        case "#COSTSAVINGS#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COSTSAVINGS#", costSavings);
                            break;
                        case "#COST#":
                            if (project.PROJECT_COST > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COST#", project.PROJECT_COST.ToString("c"));
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COST#", string.Empty);
                            }
                            break;
                        case "#PAYBACK#":
                            if (project.PAYBACK > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PAYBACK#", project.PAYBACK.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PAYBACK#", string.Empty);
                            }
                            break;
                        case "#HCBEFORE#":
                            if (project.HEADCOUNT_BEFORE > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCBEFORE#", project.HEADCOUNT_BEFORE.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCBEFORE#", string.Empty);
                            }
                            break;
                        case "#HCAFTER#":
                            if (project.HEADCOUNT_AFTER > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCAFTER#", project.HEADCOUNT_AFTER.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCAFTER#", string.Empty);
                            }
                            break;
                        case "#HCREDUCE#":
                            if (project.HEADCOUNT_BEFORE > 0 && project.HEADCOUNT_AFTER > 0)
                            {
                                if (project.HEADCOUNT_BEFORE >= project.HEADCOUNT_AFTER)
                                {
                                    slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCREDUCE#", (project.HEADCOUNT_BEFORE - project.HEADCOUNT_AFTER).ToString());
                                }
                                else
                                {
                                    slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCREDUCE#", "0");
                                }
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#HCAFTER#", string.Empty);
                            }
                            break;
                        case "#ROI#":
                            if (project.ROI > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#ROI#", project.ROI.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#ROI#", string.Empty);
                            }
                            break;
                        case "#PRODLIFE#":
                            if (project.PRODUCT_LIFE > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PRODLIFE#", project.PRODUCT_LIFE.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PRODLIFE#", string.Empty);
                            }
                            break;
                        case "#USE#":
                            if (project.REUSE > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#USE#", project.REUSE.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#USE#", string.Empty);
                            }
                            break;  
                    }                   
                }
            }
        }

        private void FillProjectDetails(PowerPoint.Slide slide, ProjectVO project)
        {
            string costSavings = "";            
            string strSaveCategory = string.Empty;           

            foreach (GroupedCostSavingVO costSaving in project.GroupedCostSavingList)
            {
                costSavings += string.Format(" {0} - {1}\r", costSaving.Description, costSaving.TotalValue.ToString("c"));
            }

            if (costSavings.Length > 0)
            {
                lstSaveCat = project.CostSavingList.ConvertAll(e => e.SavingCategory);
                Dictionary<string, bool> dicSavCat = new Dictionary<string, bool>();

                foreach (string s in lstSaveCat)
                {
                    dicSavCat[s] = true;
                }
                lstUniqueSaveCat = new List<string>(dicSavCat.Keys);

                foreach (string strSaving in lstUniqueSaveCat)
                {
                    strSaveCategory += string.Format("{0}\r", strSaving);
                }
            }            
                    
            PowerPoint.Shape chartPicture = null;
            
            for (int i = 1; i <= slide.Shapes.Count; i++)
            {
                if (slide.Shapes[i].HasTextFrame == Microsoft.Office.Core.MsoTriState.msoTrue)
                {
                    switch (slide.Shapes[i].TextFrame.TextRange.Text.Trim())
                    {
                        case "":
                            break;
                        //case "#REGION# –":
                        //    slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#REGION#", project.RegionDescription);
                        //    break;
                        case "#REGION# – #DESCRIPTION#":
                            string sTitle = string.Empty;
                            sTitle = string.Concat(string.Format("{0} - ", project.RegionDescription), project.Description);
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#REGION# – #DESCRIPTION#", sTitle);
                            break;
                        case "#OWNER#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#OWNER#", project.Responsible);
                            break;
                        case "#AEGOWN#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#AEGOWN#", project.CoOwner);
                            slide.Shapes[i].TextFrame.WordWrap = Microsoft.Office.Core.MsoTriState.msoTrue;
                            break;
                        case "#LEAD#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#LEAD#", project.SiteLead);
                            break;
                        case "#LOCATIONS#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#LOCATIONS#", project.LocationDescription);
                            break;
                        case "#DESCRIPTION#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#DESCRIPTION#", project.Description);
                            break;
                        case "#CATEGORY#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CATEGORY#", project.CategoryDescription);
                            break;
                        case "#CUSTOMER#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CUSTOMER#", project.CustomerName);
                            break;
                        case "#STATUS#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#STATUS#", project.StatusDescription);
                            break;
                        case "#COMMITDATE#":
                            if (!project.CommitDate.Equals(DateTime.MinValue))
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COMMITDATE#", project.CommitDate.ToString("MM/dd/yyyy"));
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COMMITDATE#", string.Empty);
                            }
                            break;
                        case "#SEGMENT#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#SEGMENT#", project.SegmentDescription);
                            break;
                        case "#COSTSAVINGS#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COSTSAVINGS#", costSavings);
                            break;
                        case "#OPENDATE#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#OPENDATE#", project.OpenDate.ToString("MM/dd/yyyy"));
                            break;
                        case "#CLOSEDATE#":
                            if (!project.CloseDate.Equals(DateTime.MinValue))
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CLOSEDATE#", project.CloseDate.ToString("MM/dd/yyyy"));
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#CLOSEDATE#", string.Empty);
                            }
                            break;
                        case "#AUTOTYPE#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#AUTOTYPE#", project.AUTO_TYPE);
                            break;
                        case "#AUTOCATEGORY#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#AUTOCATEGORY#", project.AUTO_CATEGORY);
                            break;
                        case "#COST#":
                            if (project.PROJECT_COST > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COST#", project.PROJECT_COST.ToString("c"));
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#COST#", string.Empty);
                            }
                            break;
                        
                        case "#REPORT#":
                            if (project.ReportURL.StartsWith(CONST_URL, StringComparison.Ordinal))
                            {
                                slide.Shapes[i].TextFrame.TextRange.ActionSettings[PowerPoint.PpMouseActivation.ppMouseClick].Hyperlink.Address = project.ReportURL;
                                slide.Shapes[i].TextFrame.TextRange.ActionSettings[PowerPoint.PpMouseActivation.ppMouseClick].Hyperlink.TextToDisplay = project.EngrReportNo;                                
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#REPORT#", "N/A");
                            }
                            break;
                        case "#STAGE#":
                            slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#STAGE#", project.ProjectStage);
                            break;
                        case "#PRJCODE#":
                            if (project.Code > 0)
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PRJCODE#", project.Code.ToString());
                            }
                            else
                            {
                                slide.Shapes[i].TextFrame.TextRange.Text = slide.Shapes[i].TextFrame.TextRange.Text.Replace("#PRJCODE#", string.Empty);
                            }
                            break;
                    }
                }
                else if (slide.Shapes[i].Type == Microsoft.Office.Core.MsoShapeType.msoGroup)
                {
                    slide.Shapes[i].GroupItems[2].TextFrame.TextRange.Text = slide.Shapes[i].GroupItems[2].TextFrame.TextRange.Text.Replace("#SAVINGCATEGORY#", strSaveCategory.Trim());

                    if (strSaveCategory.Length > 0)
                    {
                        float currentTop = 0;
                        float left = 0;
                        float width = 0;
                        float height = 0;

                        for (int j = 0; j < this.lstUniqueSaveCat.Count; j++)
                        {
                            PowerPoint.Shape shape = null;
                            if (j == 0)
                            {
                                shape = slide.Shapes[i].GroupItems[1];
                                currentTop = slide.Shapes[i].GroupItems[1].Top;
                                left = slide.Shapes[i].GroupItems[1].Left;
                                width = slide.Shapes[i].GroupItems[1].Width;
                                height = slide.Shapes[i].GroupItems[1].Height;
                                
                            }
                            else
                            {
                                currentTop = currentTop + 18;
                                shape = slide.Shapes.AddShape(Microsoft.Office.Core.MsoAutoShapeType.msoShapeRectangle, left, currentTop, width, height);
                            }                           
                            shape.SetShapesDefaultProperties();  
                        }
                    }
                    else
                    {                        
                        slide.Shapes[i].GroupItems[1].Visible = Microsoft.Office.Core.MsoTriState.msoFalse;
                    }
                }
                else if (slide.Shapes[i].Type == Microsoft.Office.Core.MsoShapeType.msoPicture)
                {
                    chartPicture = slide.Shapes[i];
                }
            }            
            if (chartPicture != null)
            {
                List<Object> objectList = new List<object>();
                objectList.Add(chartPicture.Name);               
                int totalSize = 414;
                int chartHeight = Convert.ToInt32((decimal)273 * (project.PercentageCompletion / (decimal)100));                
                PowerPoint.Shape chartFilling = slide.Shapes.AddShape(Microsoft.Office.Core.MsoAutoShapeType.msoShapeRectangle, 883, totalSize - chartHeight, 17, chartHeight);
                chartFilling.Fill.ForeColor.RGB = GetRgb(255, 0, 0);
                chartFilling.Fill.BackColor.RGB = GetRgb(255, 0, 0);                                
                chartFilling.Line.ForeColor.RGB = GetRgb(255, 0, 0);                
                
                objectList.Add(chartFilling.Name);
                if (chartHeight > 4)
                {                    
                    PowerPoint.Shape chartFillingShadow = slide.Shapes.AddShape(Microsoft.Office.Core.MsoAutoShapeType.msoShapeRectangle, 886, totalSize - chartHeight + 2, 1, chartHeight - 4);
                    chartFillingShadow.Fill.ForeColor.RGB = GetRgb(255, 255, 255);
                    chartFillingShadow.Line.ForeColor.RGB = GetRgb(255, 255, 255);
                    objectList.Add(chartFillingShadow.Name);
                }
            }
        }

        private int GetRgb(int red, int green, int blue)
        {
            return ((red) + (256 * green) + (65536 * blue));
        }


        private void CreatePptApplication()
        {
            try
            {
                app = new PowerPoint.Application();
                app.Visible = Microsoft.Office.Core.MsoTriState.msoCTrue;
            }
            catch (Exception ex)
            {
                throw new Exception(string.Format("Could not create Power Point application - {0}", ex.Message));
            }
        }
    }
}
