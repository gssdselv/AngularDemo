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
using Fit.Base;
using ProjectTracker.DAO.dtsProjectTrackerTableAdapters;
namespace ProjectTracker.Pages
{
    public partial class StatusCad : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            dvStatus.PageIndex = gvStatus.PageSize * gvStatus.PageIndex + gvStatus.SelectedIndex;
        }

        protected void obsStatus_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            StatusTableAdapter statusTbAdpt = new StatusTableAdapter();
            object qtd = statusTbAdpt.QuantityDescription(e.InputParameters["PS_DESCRICAO"].ToString(), "%");

            if (qtd == null || Convert.ToInt32(qtd) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }



        }

        protected void obsCategory_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowInsertSucessMessage();
            }
        }

        protected void obsCategory_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception != null)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "RECORD_RELATION_DELETE").ToString());
                e.ExceptionHandled = true;
            }
            else
            {
                MessagePanel1.ShowDeleteSucessMessage();
            }
        }

        protected void obsCategory_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            if (e.Exception == null)
            {
                MessagePanel1.ShowUpdateSucessMessage();
            }
        }

        protected void obsStatus_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            StatusTableAdapter statusTbAdpt = new StatusTableAdapter();
            object qtd = statusTbAdpt.QuantityDescription(e.InputParameters["PS_DESCRICAO"].ToString(), gvStatus.SelectedDataKey[1].ToString());

            if (qtd == null || Convert.ToInt32(qtd) > 0)
            {
                MessagePanel1.ShowErrorMessage(HttpContext.GetGlobalResourceObject("Default", "ALREADY_EXISTS_THIS_DESCRIPTION").ToString());
                e.Cancel = true;
            }
        }


    }
}
