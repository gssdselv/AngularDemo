using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

namespace ProjectTracker.Business
{
   
        public class Attchement
        {

            #region Attributes
            
            private FileStream fileStream;
            private string filename;
            private string url;
            private int projectCode;
            private OperationAttachement operation;
            
            #endregion
            
            #region Properties
            
            public string Filename
            {
                get { return filename; }
                set { filename = value; }
            }
            public string Url
            {
                get { return url; }
                set { url = value; }
            }
            public int ProjectCode
            {
                get { return projectCode; }
                set { projectCode = value; }
            }
            public FileStream FileStream
            {
                get { return fileStream; }
                set { fileStream = value; }
            }
            #endregion

            #region Constructor

            public Attchement(string filename, string url, int projectCode, FileStream fileStream,OperationAttachement operation)
            {
                this.fileStream = fileStream;
                this.filename = filename;
                this.url = url;
                this.projectCode = projectCode;
                this.operation = operation;
            }

            public void SaveFile()
            {
                try
                {
                    FileStream fileStream = new FileStream(url, FileMode.OpenOrCreate);
                    
                }
                catch (PathTooLongException ex)
                {
                    throw new PathTooLongException("O nome especificado para o arquivo é maior do que o permitido", ex);
                }
                catch (IOException ex)
                {
                    throw ex;
                }
            }

            /// <summary>
            /// Get Content(array Bytes) at a file
            /// </summary>
            /// <param name="url">Path to the file</param>
            /// <returns>File Content</returns>
            public static byte[] GetContentFile(string url)
            {
                MemoryStream memoryStream = new MemoryStream();
                byte[] content = null;
                if (!File.Exists(url))
                    throw new FileNotFoundException("O arquivo " + url + " não foi encontrado");

                FileStream fileStream = new FileStream(url, FileMode.Open);

                try
                {
                    content = new byte[fileStream.Length];
                    fileStream.Read(content, 0,Convert.ToInt32(fileStream.Length));
                }
                catch (IOException ex)
                {
                    throw new IOException("Um erro desconhecido aconteceu ao tentar ler o arquivo " + url + ".", ex);
                }
                finally
                {
                    if(fileStream != null)
                        fileStream.Close();
                }

                return content;
            }

            #endregion
        }

    public enum OperationAttachement
    { Added, Removed, Unchaged, Changed }
}
