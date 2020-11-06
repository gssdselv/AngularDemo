<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SnapShot.aspx.cs" Inherits="ProjectTracker.Pages.SnapShot" MasterPageFile="~/Pages/MasterPage.Master"%>

<asp:Content ContentPlaceHolderID="MainContent" ID="ParentContent" EnableViewState="true" runat="server">

<iframe src="../dashboard/dashboard.htm" height="580" width="1065" frameborder="0" scrolling="no"></iframe>

      <!--<div id="Welcome" style="text-align:center;background: #F1F1F1 url(../Images/picMainBack.jpg);height:400px">
        <p style="text-align:center; padding: 7px;"><asp:Label runat="server" Text="<%$ Resources:Default, WELCOME %>" ID="lblWelcome" /> <asp:Label ID="lblUser" runat="server" Text="Label"></asp:Label></p>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br /><asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="sqlDSSummary" DataKeyNames="PS_DESCRICAO,PS_CODIGO" OnRowDataBound="GridView1_RowDataBound" Width="400px">
            <Columns>
                <asp:BoundField DataField="PS_DESCRICAO" HeaderText="<%$ Resources:Default, DESCRIPTION %>" SortExpression="PS_DESCRICAO" />                
                <asp:HyperLinkField DataNavigateUrlFields="PS_CODIGO" DataNavigateUrlFormatString="ProjectCad.aspx?Projects=Y&amp;StatusCode={0}"
                    DataTextField="YOUR_PROJECTS" HeaderText="<%$ Resources:Default, YOUR_PROJECTS %>" />
                <asp:HyperLinkField DataNavigateUrlFields="PS_CODIGO" DataNavigateUrlFormatString="ProjectCad.aspx?Projects=P&amp;StatusCode={0}"
                    DataTextField="ALL_PROJECTS" HeaderText="<%$ Resources:Default, ALL_PROJECTS %>" />
            </Columns>
            <SelectedRowStyle BackColor="#F9FAFB" />
            <RowStyle HorizontalAlign="Center"  BorderWidth="0px" />
            <HeaderStyle HorizontalAlign="Center" BackColor="#C9C7C7" BorderWidth="0px" />
            <PagerStyle BorderWidth="0px" />
            <AlternatingRowStyle BorderWidth="0px" />
        </asp:GridView>
        <br />
        <asp:SqlDataSource ID="sqlDSSummary" runat="server" ConnectionString="<%$ ConnectionStrings:d_PTConnectionString %>"
            SelectCommand="SP_FIT_PT_SUMMARY" SelectCommandType="StoredProcedure" OnSelecting="sqlDSSummary_Selecting">
            <SelectParameters>
                <asp:Parameter Name="USER" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        &nbsp;<br />
        <br />
        <br />
    </div>-->
</asp:Content>
