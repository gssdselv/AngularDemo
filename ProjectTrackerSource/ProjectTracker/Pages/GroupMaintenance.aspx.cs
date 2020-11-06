using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FIT.SCO.Common;
using System.Data;
using System.Data.SqlClient;
using ProjectTracker.Common;

namespace ProjectTracker.Pages
{
    public partial class GroupMaintenance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.hdfID.Value = "0";
            }
        }

        private void MoveItem(ListControl origin, ListControl target)
        {
            List<ListItem> selectedItems = new List<ListItem>();

            foreach (ListItem item in origin.Items)
            {
                if (item.Selected)
                    selectedItems.Add(new ListItem(item.Text, item.Value));
            }

            foreach (ListItem item in selectedItems)
            {
                origin.Items.Remove(item);
                target.Items.Add(item);
            }

            Utility.OrderListBox(origin);
            Utility.OrderListBox(target);
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.MessagePanel.Message = "";
            this.MessagePanel.Visible = false;
            int index = GridView1.SelectedRow.RowIndex;
            int id = System.Convert.ToInt32(GridView1.DataKeys[index]["ID"].ToString());
            this.hdfID.Value = id.ToString();
            this.txtGroup.Text = HttpUtility.HtmlDecode(GridView1.DataKeys[index]["GroupName"].ToString());

            string sql = "select A.PU_USUARIO, A.PU_NAME from dbo.TB_PT_PU_USERS A where A.PU_ATIVO = '1' and A.PU_USUARIO not in (select B.PU_USUARIO from dbo.tblGroup_Rel_User B where B.GroupID = {0} and Isnull(B.Deleted,'0') = '0') order by A.PU_NAME";
            sql = string.Format(sql, id);

            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
            DataSet ds = instance.Query(sql, null);

            this.lstResponsiblesAvailable.DataSource = ds;
            this.lstResponsiblesAvailable.DataTextField = "PU_NAME";
            this.lstResponsiblesAvailable.DataValueField = "PU_USUARIO";
            this.lstResponsiblesAvailable.DataBind();

            sql = "select A.PU_USUARIO, A.PU_NAME from dbo.TB_PT_PU_USERS A where A.PU_ATIVO = '1' and A.PU_USUARIO in (select B.PU_USUARIO from dbo.tblGroup_Rel_User B where B.GroupID = {0} and Isnull(B.Deleted,'0') = '0') order by A.PU_NAME";
            sql = string.Format(sql, id);

            ds = instance.Query(sql, null);

            this.lstResponsiblesToInsert.DataSource = ds;
            this.lstResponsiblesToInsert.DataTextField = "PU_NAME";
            this.lstResponsiblesToInsert.DataValueField = "PU_USUARIO";
            this.lstResponsiblesToInsert.DataBind();
        }

        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            this.MessagePanel.Message = "";
            this.MessagePanel.Visible = false;
            this.hdfID.Value = "0";
            this.txtGroup.Text = "";

            string sql = "select A.PU_USUARIO, A.PU_NAME from dbo.TB_PT_PU_USERS A where A.PU_ATIVO = '1' order by A.PU_NAME";
            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();

            DataSet ds = instance.Query(sql, null);
            this.lstResponsiblesAvailable.DataSource = ds;
            this.lstResponsiblesAvailable.DataTextField = "PU_NAME";
            this.lstResponsiblesAvailable.DataValueField = "PU_USUARIO";
            this.lstResponsiblesAvailable.DataBind();

            this.lstResponsiblesToInsert.Items.Clear();
        }

        protected void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (this.txtGroup.Text == "")
            {
                this.MessagePanel.Message = "Please fill in Group.";
                this.MessagePanel.Visible = true;
                this.MessagePanel.ShowErrorMessage(this.MessagePanel.Message);
                return;
            }

            string sql = string.Empty;
            this.MessagePanel.Message = "";
            this.MessagePanel.Visible = false;
            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
            DataSet ds = null;
            //string sGroupColumn = string.Empty;
            if (this.hdfID.Value == "0")
            {
                //sql = "select 1 from dbo.tblGroups A where A.GroupName = '{0}' and Isnull(A.Deleted,'0') = '0'";
                //sql = string.Format(sql, this.txtGroup.Text);
                sql = "select 1 from dbo.tblGroups A where A.GroupName = @GrpName and Isnull(A.Deleted,'0') = '0'";
                //sql = string.Format(sql, sGroupColumn);
                SqlParameter[] parameters =
                {
                    new SqlParameter("@GrpName", CheckmarxHelper.EscapeReflectedXss(this.txtGroup.Text))
                };
                ds = instance.Query(sql, parameters);

                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.MessagePanel.Message = "This group has existed.";
                    this.MessagePanel.Visible = true;
                    this.MessagePanel.ShowErrorMessage(this.MessagePanel.Message);
                    return;
                }
                //string sGroupTxtParam = string.Empty;
                //sql = "insert into dbo.tblGroups (GroupName) values ('{0}'); select @@identity";
                sql = "insert into dbo.tblGroups (GroupName) values (@GroupTxtParam); select @@identity";
                SqlParameter[] parameter =
                            { new SqlParameter("@GroupTxtParam", CheckmarxHelper.EscapeReflectedXss(this.txtGroup.Text)) };
                //sql = string.Format(sql, this.txtGroup.Text);
                this.hdfID.Value = instance.GetSingle(sql, parameter).ToString();
            }
            else
            {
                //sql = "update dbo.tblGroups set GroupName = '{0}' where ID = {1}";
                sql = "update dbo.tblGroups set GroupName = @GrpName where ID = @ID";
                SqlParameter[] parameter = {
                new SqlParameter ("@GrpName", this.txtGroup.Text),
                new SqlParameter ("@ID", this.hdfID.Value)
            };
                //sql = string.Format(sql, this.txtGroup.Text, this.hdfID.Value);
                instance.ExecuteSQL(sql, parameter);
            }

            List<DAO.CommandInfo> cmdList = new List<DAO.CommandInfo>();
            string users = string.Empty;            
            for (int i = 0; i <= this.lstResponsiblesToInsert.Items.Count - 1; i++)
            {
                if (users != string.Empty) users += ",";
                users += "'" + this.lstResponsiblesToInsert.Items[i].Value + "'";

                sql = "EXEC dbo.sp_Save_Group_Rel_User @ID, @LstVal";
                //sql = string.Format(sql, sHiddIDVal, sListValue);
                //sql = string.Format(sql, this.hdfID.Value, this.lstResponsiblesToInsert.Items[i].Value);
                SqlParameter[] sqlparam =
                {
                    new SqlParameter("@ID", this.hdfID.Value),
                    new SqlParameter("@LstVal", this.lstResponsiblesToInsert.Items[i].Value)
                };
                cmdList.Add(new DAO.CommandInfo(sql, sqlparam));
            }

            instance.ExecuteSqlTran(cmdList);
            //if (users != string.Empty)
            //{
            //    sql = "update dbo.tblGroup_Rel_User set Deleted = '1' where GroupID = {0} and PU_USUARIO not in ({1})";
            //    sql = string.Format(sql, this.hdfID.Value, users);                

            //}
            //else
            //{
            //    sql = "update dbo.tblGroup_Rel_User set Deleted = '1' where GroupID = {0}";
            //    sql = string.Format(sql, this.hdfID.Value);                
            //}
            //instance.ExecuteSQL(sql, null);
            if (!string.IsNullOrEmpty(users))
            {
                sql = "update dbo.tblGroup_Rel_User set Deleted = '1' where GroupID = @GrpID and PU_USUARIO not in ({0})";
                sql = string.Format(sql, users);
                SqlParameter[] parameter =
                {
                    new SqlParameter("@GrpID",this.hdfID.Value),
                    //new SqlParameter("@UsrList",users)
                };
                instance.ExecuteSQL(sql, parameter);
            }
            else
            {
                sql = "update dbo.tblGroup_Rel_User set Deleted = '1' where GroupID = @GrpID";
                //sql = string.Format(sql, sGroupID);
                SqlParameter[] parameter =
                {
                    new SqlParameter("@GrpID",this.hdfID.Value)
                };
                instance.ExecuteSQL(sql, parameter);
            }

            this.MessagePanel.Message = "Save successfully.";
            this.MessagePanel.Visible = true;
            this.MessagePanel.ShowErrorMessage(this.MessagePanel.Message);
            this.ObjectDataSource1.DataBind();
            this.GridView1.DataBind();
        }

        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            if (this.hdfID.Value == "0")
            {
                this.MessagePanel.Message = "Please select a Group.";
                this.MessagePanel.Visible = true;
                this.MessagePanel.ShowErrorMessage(this.MessagePanel.Message);
                return;
            }
            string sParamHidenID = string.Empty;
            //string sql = "update dbo.tblGroups set Deleted = '1' where ID = " + this.hdfID.Value.ToString();
            string sql = "update dbo.tblGroups set Deleted = '1' where ID = @ID";
            SqlParameter[] parameter =
            {
                new SqlParameter("@ID",this.hdfID.Value.ToString())
            };
            DAO.SQLDBHelper instance = new DAO.SQLDBHelper();
            instance.ExecuteSQL(sql, parameter);
            this.hdfID.Value = "0";
            this.txtGroup.Text = "";
            this.lstResponsiblesToInsert.Items.Clear();
            this.lstResponsiblesAvailable.Items.Clear();
            this.MessagePanel.Message = "Delete successfully";
            this.MessagePanel.Visible = true;
            this.MessagePanel.ShowErrorMessage(this.MessagePanel.Message);
            this.ObjectDataSource1.DataBind();
            this.GridView1.DataBind();
        }

        protected void btnMoveResponsibleR_Click(object sender, ImageClickEventArgs e)
        {
            this.MoveItem(this.lstResponsiblesAvailable, this.lstResponsiblesToInsert);
        }

        protected void btnMoveResponsibleL_Click(object sender, ImageClickEventArgs e)
        {
            this.MoveItem(this.lstResponsiblesToInsert, this.lstResponsiblesAvailable);
        }
    }
}