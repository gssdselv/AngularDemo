<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="RegionCad.aspx.cs" Inherits="ProjectTracker.RegionCad" %>

<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="text-align:center;">
    <asp:Label ID="Label5" runat="server" SkinID="Title" Text="<%$ Resources:Default, REGION_CODE %>"></asp:Label>
    <br />
        <uc1:MessagePanel ID="MessagePanel1" runat="server" />
    
    <br />
    </div>
    <asp:DetailsView ID="dvRegion" runat="server" AutoGenerateRows="False" DataSourceID="obsRegions" DataKeyNames="Code">
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
            <asp:TemplateField HeaderText="Code" InsertVisible="False" SortExpression="Code">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Code") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Description" SortExpression="Description">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active" SortExpression="Active">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Enabled="false" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="User" SortExpression="User">
                <EditItemTemplate>
                    <asp:TextBox ID="txtUsername" runat="server" Text='<%# Bind("User") %>' Width="74px"></asp:TextBox>&nbsp;<asp:ImageButton
                        ID="btnGetInfo" runat="server" ImageUrl="~/Images/btn_16x16_find.jpg" OnClick="btnGetInfo_Click" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUsername"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>&nbsp;
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtUsername" runat="server" Text='<%# Bind("User") %>' Width="74px"></asp:TextBox>&nbsp;<asp:ImageButton
                        ID="btnGetInfo" runat="server" ImageUrl="~/Images/btn_16x16_find.jpg" OnClick="btnGetInfo_Click" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUsername"
                        ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("User") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Email" SortExpression="Email">
                <EditItemTemplate>
                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("Email") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Remove.jpg"
                EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Save.jpg" NewImageUrl="~/Images/New.jpg"
                ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" UpdateImageUrl="~/Images/Save.jpg" />
        </Fields>
        <EmptyDataRowStyle BackColor="Transparent" />
    </asp:DetailsView>
    &nbsp;
    <br />
    <br />
    <asp:GridView ID="gvRegions" runat="server" AllowPaging="True"
        AutoGenerateColumns="False" DataKeyNames="Code,User" DataSourceID="obsRegions"
        OnSelectedIndexChanged="gvRegion_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkSelect" runat="server" CommandName="Select">Select</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Code" HeaderText="Code" InsertVisible="False" ReadOnly="True"
                SortExpression="Code" />
            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
            <asp:CheckBoxField DataField="Active" HeaderText="Active" SortExpression="Active" />
            <asp:BoundField DataField="User" HeaderText="User" SortExpression="User" />
            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
        </Columns>
        <PagerStyle HorizontalAlign="Right" />
    </asp:GridView>
    <asp:ObjectDataSource ID="obsRegions" runat="server" DeleteMethod="Delete" InsertMethod="Insert" OnDeleted="obsRegions_Deleted"
        OnInserted="obsRegions_Inserted" OnUpdated="obsRegions_Updated" SelectMethod="GetData"
        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.RegionsTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Code" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Code" Type="Int32" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="User" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="User" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
