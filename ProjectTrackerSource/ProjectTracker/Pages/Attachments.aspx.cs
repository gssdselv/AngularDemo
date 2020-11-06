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
using System.IO;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;

namespace ProjectTracker.Pages
{
    public partial class Attachments : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void CarregaGrid()
        {
        }

        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            // Request the max file size in bytes and the max file count from web.config settings... MM
            long maxFileSize = Convert.ToInt64(ConfigurationManager.AppSettings["MaxAttachFileSize"]);
            int maxFileCount = Convert.ToInt32(ConfigurationManager.AppSettings["MaxAttachFileCount"]);
            // Verify if information are correct... MM
            if (fuAttechement.FileContent.Length >= maxFileSize)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "EXPECTED_SIZE_MAX").ToString());
                obsAttachements.Select();
                gvAtteChement.DataBind();
                return;
            }
            if(gvAtteChement.Rows.Count >= maxFileCount)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "FILE_COUNT_EXCEEDED").ToString());
                obsAttachements.Select();
                gvAtteChement.DataBind();
                return;
            }
            string fileName = fuAttechement.FileName.Replace("..", "").Replace("\\","");
            
            //string path = ConfigurationSettings.AppSettings["PathAttachementProjects"].ToString() + "\\"+ Request.QueryString["ProjectCode"].ToString();
            string path = Server.MapPath(ConfigurationSettings.AppSettings["PathAttachementProjects"].ToString()) + "\\" + Request.QueryString["ProjectCode"].ToString().Replace("..", "").Replace("\\", "");

            #region Add File at Server
            	
            if (fuAttechement.FileBytes == null || fuAttechement.FileBytes.Length == 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default","INVALID_FILE").ToString());
                obsAttachements.Select();
                gvAtteChement.DataBind();
                return;
            }

            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            if (File.Exists(path+"\\"+fileName))
                File.Delete(path+"\\"+fileName);
            FileStream fileStream = null;

            try
            {
                fileStream = new FileStream(path+"\\"+fileName, FileMode.Create);
                fileStream.Write(fuAttechement.FileBytes, 0, Convert.ToInt32(fuAttechement.FileBytes.Length - 1));
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (fileStream != null)
                    fileStream.Close();
            }

            
            #endregion
            
            #region Add Address at DataBase

            try
            {
                ProjectAttchementTableAdapter tbAdpt = new ProjectAttchementTableAdapter();
                tbAdpt.Insert(Convert.ToInt32(Request.QueryString["ProjectCode"]), path + "\\" + fileName);
            }
            catch (Exception ex)
            { }

            #endregion
            obsAttachements.Select();
            gvAtteChement.DataBind();
        }

        protected void gvAtteChement_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int projectCode = Convert.ToInt32(gvAtteChement.DataKeys[e.RowIndex][0]);
            string url = gvAtteChement.DataKeys[e.RowIndex][1].ToString();
            
            if(File.Exists(url))
                File.Delete(url);
            ProjectAttchementTableAdapter tbAdpt = new ProjectAttchementTableAdapter();
            tbAdpt.Delete(projectCode, url);
            e.Cancel = true;
            obsAttachements.Select();
            gvAtteChement.DataBind();
        }

        protected void gvAtteChement_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string[] path = (e.Row.Cells[0].FindControl("lblFileName") as Label).Text.Split('\\');
                e.Row.Cells[0].Text = path[path.Length - 1];
            }
        }

        protected void gvAtteChement_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
            
        }

        protected void gvAtteChement_SelectedIndexChanged(object sender, EventArgs e)
        {
            string path = gvAtteChement.SelectedDataKey[1].ToString() ;
            string[] arrPath = path.Split('\\');
            string filename = arrPath[arrPath.Length-1];

            FileStream fileStream = new FileStream(path, FileMode.Open);
            Response.Clear();
            Response.AddHeader("Strict-Transport-Security", "max-age=31536000"); //checkmarx
            Response.AddHeader("Content-Disposition", "attachment; filename=" + filename);
            Response.AddHeader("Content-Length", fileStream.Length.ToString());
            Response.ContentType = "application/x-download";

            byte[] content = new byte[fileStream.Length];
            fileStream.Read(content, 0, Convert.ToInt32(fileStream.Length));
            fileStream.Close();
            Response.BinaryWrite(content);


            Response.End(); 
            
        }

        protected void gvAtteChement_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            
            
        }
    }

    
}
