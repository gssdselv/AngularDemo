using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjectTracker.Pages
{
    public partial class ProjectsForShareNet : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HyperLink hylProjectTitle = e.Row.FindControl("hylProjectTitle") as HyperLink;
                Image imgStatus = e.Row.FindControl("imgStatus") as Image;
                Image imgIP = e.Row.FindControl("imgIP") as Image;

                hylProjectTitle.Text = this.GridView1.DataKeys[e.Row.RowIndex]["DESCRIPTION"].ToString();

                if (this.GridView1.DataKeys[e.Row.RowIndex]["ENG_LINK"].ToString().ToLower().Contains("http:"))
                {
                    hylProjectTitle.NavigateUrl = this.GridView1.DataKeys[e.Row.RowIndex]["ENG_LINK"].ToString();
                }

                if (this.GridView1.DataKeys[e.Row.RowIndex]["STATUS"].ToString() == "Closed")
                {
                    imgStatus.ImageUrl = "~/Images/status-green.gif";
                }

                if (this.GridView1.DataKeys[e.Row.RowIndex]["STATUS"].ToString() == "Open")
                {
                    imgStatus.ImageUrl = "~/Images/status-yellow.gif";
                }

                if (this.GridView1.DataKeys[e.Row.RowIndex]["STATUS"].ToString() == "Hold")
                {
                    imgStatus.ImageUrl = "~/Images/status-blue.gif";
                }

                if (this.GridView1.DataKeys[e.Row.RowIndex]["ENG_IP"].ToString() == "1")
                {
                    imgIP.ImageUrl = "~/Images/checkYes.png";
                }
                else
                {
                    imgIP.ImageUrl = "~/Images/checkNo.png";
                }
            }
        }
    }
}