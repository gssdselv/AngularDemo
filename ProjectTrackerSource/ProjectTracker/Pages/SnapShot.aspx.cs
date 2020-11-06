using System;
using System.Web.UI.WebControls;
using Fit.Base;
using System.Drawing;
using System.Web;
using System.Security.Principal;

namespace ProjectTracker.Pages
{
    public partial class SnapShot : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string username = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name);
                if (username.Split('\\').Length > 1)
                    username = username.Split('\\')[username.Split('\\').Length - 1];
                lblUser.Text = Business.User.Name(username);

                if (!string.IsNullOrEmpty(username))
                {
                    //Start :  added security for Session Fixation
                    string guid = Guid.NewGuid().ToString();
                    Session["AuthToken"] = guid;
                    Response.Cookies.Add(new HttpCookie("AuthToken", guid));
                    //end Session Fixation
                }
            }
        }        

        /// <summary>
        /// Event accessed when 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void sqlDSSummary_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {
            string username = (string.IsNullOrEmpty(HttpContext.Current.User.Identity.Name) ? WindowsIdentity.GetCurrent().Name : HttpContext.Current.User.Identity.Name);
            if (username.Split('\\').Length > 1)
                username = username.Split('\\')[username.Split('\\').Length - 1];

            e.Command.Parameters["@USER"].Value = username;

        }



        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row != null && (e.Row.RowType == DataControlRowType.DataRow))
            {
                int status = Convert.ToInt32(GridView1.DataKeys[e.Row.DataItemIndex][1].ToString());


                //Verify status project
                if (status == 22)
                {
                    //TBD
                    e.Row.BackColor = Color.FromName("#B3E1C2");
                }
                else if (status == 21)
                {
                    //In-Progress
                    e.Row.BackColor = Color.FromName("#E3E3B5");
                }
                else if (status == 23)
                {
                    //On-Hold
                    e.Row.BackColor = Color.FromName("#FFE788");
                }
                else if (status == 20)
                {
                    //Dropped
                    e.Row.BackColor = Color.FromName("#B3C2F0");
                }
            }
        }
    }
}
