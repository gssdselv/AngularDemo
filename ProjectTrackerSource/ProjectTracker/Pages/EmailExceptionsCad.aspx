<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="EmailExceptionsCad.aspx.cs" Inherits="ProjectTracker.Pages.EmailExceptionsCad" Title="Untitled Page" %>

<%@ Register Src="~/Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="text-align:center">        
    <asp:Label ID="Label5" runat="server" SkinID="Title" Text="<%$ Resources:Default, TITLE_EMAIL_EXCEPTIONS %>"></asp:Label>
    <br />
    <br />
    <uc1:MessagePanel ID="MessagePanel1" runat="server" />
    <br />
    <asp:DetailsView ID="dvEmailExceptions" runat="server" AutoGenerateRows="False"
        DataSourceID="obsEmailExceptions" DataKeyNames="Username" OnDataBound="dvEmailExceptions_DataBound">
        <EmptyDataTemplate>
            <table class="FormView">
                <tr>
                    <td class="Footer">
                        <asp:Label ID="Label33" runat="server" Text="<%$ Resources:Default, INSERT_NEW_PROJECT&#9; %>"></asp:Label></td>
                </tr>
                <tr>
                    <td class="Footer" style="height: 20px">
                        <asp:ImageButton ID="ImageButton1" runat="server" CommandName="New" ImageUrl="~/Images/Add.jpg" /></td>
                </tr>
            </table>
        </EmptyDataTemplate>
        <Fields>
            <asp:TemplateField HeaderText="Name" SortExpression="Name">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="ddlUsernameInsert" runat="server"
                        DataSourceID="obsUsers" DataTextField="Name" DataValueField="Username" SelectedValue='<%# Bind("Username") %>'
                        Width="203px" AutoPostBack="true" OnSelectedIndexChanged="ddlUsernameInsert_SelectedIndexChanged" OnDataBound="ddlUsernameInsert_DataBound" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThUsername" runat="server" Text="<%$ Resources:Default, NAME %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Email" SortExpression="Email" >
                <EditItemTemplate>
                    <asp:Label ID="lblEmailValue" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThEmail" runat="server" Text="<%$ Resources:Default, EMAIL %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblEmailValue" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Delete.jpg"
                EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Insert.jpg" NewImageUrl="~/Images/New.jpg"
                ShowDeleteButton="True" ShowInsertButton="True" UpdateImageUrl="~/Images/Save.jpg" />
        </Fields>
        <EmptyDataRowStyle BackColor="Transparent" />
    </asp:DetailsView>
    &nbsp;
    <br />
    <table class="FormView">
        <tr>
            <td class="Header" style="height: 20px; text-align: left">
                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, NAME %>"></asp:Label></td>
            <td style="height: 20px; text-align: left">
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:ImageButton ID="ImageButton2"
                    runat="server" ImageUrl="~/Images/btn_find.gif" /></td>
        </tr>
    </table>
    <br />
    <asp:GridView ID="gvEmailExceptions" runat="server" AllowPaging="True"
        AutoGenerateColumns="False" DataKeyNames="Username" DataSourceID="obsEmailExceptions"
        OnSelectedIndexChanged="gvEmailExceptions_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemStyle HorizontalAlign="Center" Width="80px" />
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                        Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Name" SortExpression="Name">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Default, NAME %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Username" SortExpression="Username">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Username") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Email" SortExpression="Email">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Email") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Default, EMAIL %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
        </Columns>
        <PagerStyle HorizontalAlign="Right" />
    </asp:GridView>
    <asp:ObjectDataSource ID="obsEmailExceptions" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OnDeleted="obsEmailExceptions_Deleted" OnInserted="obsEmailExceptions_Inserted" OnInserting="obsEmailExceptions_Inserting"
        OnUpdated="obsEmailExceptions_Updated" OnUpdating="obsEmailExceptions_Updating" SelectMethod="GetDataByName"
        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.EmailExceptionsTableAdapter"
        UpdateMethod="Update" OldValuesParameterFormatString="original_{0}" OnDeleting="obsEmailExceptions_Deleting">
        <DeleteParameters>
            <asp:ControlParameter
                ControlID="gvEmailExceptions"
                Name="PU_USUARIO"
                PropertyName="SelectedValue"
                Type="String" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:ControlParameter
                ControlID="gvEmailExceptions"
                Name="PU_USUARIO"
                PropertyName="SelectedValue"
                Type="String" />
        </UpdateParameters>
        <InsertParameters>
            <asp:ControlParameter
                ControlID="gvEmailExceptions"
                Name="PU_USUARIO"
                PropertyName="SelectedValue"
                Type="String" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="Name" PropertyName="Text"
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="obsUsers" runat="server"
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UsersTableAdapter">
        </asp:ObjectDataSource>
    </div>
</asp:Content>
