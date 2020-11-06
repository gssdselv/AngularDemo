<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ResponsibleCad.aspx.cs" Inherits="ProjectTracker.Pages.ResponsibleCad" %>

<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons"
    TagPrefix="uc2" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc3" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc4" %>

<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    
    <div style="text-align: center"  class="spacing_title">

    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, TITLE_RESPONSIBLES %>" SkinID="Title"/>
        <br />
        <br />
        <uc1:MessagePanel ID="MessagePanel1" runat="server" />
    </div>
    <br />
    <asp:DetailsView ID="dvUsers" runat="server" AutoGenerateRows="False" DataSourceID="obsResponsible">
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
            <asp:TemplateField HeaderText="Username" SortExpression="Username">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                </EditItemTemplate>
                <InsertItemTemplate>
                    &nbsp;<asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="ObjectDataSource1"
                        DataTextField="Name" DataValueField="Username" OnDataBound="DropDownList2_DataBound" SelectedValue='<%# Bind("Username") %>'>
                    </asp:DropDownList>&nbsp;
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="DropDownList2"
                        ErrorMessage="*"></asp:RequiredFieldValidator>
                    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="Delete"
                        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataToDropResponsible"
                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UsersTableAdapter"
                        UpdateMethod="Update">
                        <DeleteParameters>
                            <asp:Parameter Name="Username" Type="String" />
                        </DeleteParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:Parameter Name="Name" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="LanguageCode" Type="String" />
                            <asp:Parameter Name="IsAdmin" Type="Boolean" />
                            <asp:Parameter Name="Username" Type="String" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Username" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:Parameter Name="Name" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="LanguageCode" Type="String" />
                            <asp:Parameter Name="IsAdmin" Type="Boolean" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Default, NAME %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active" SortExpression="Active">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Enabled="false" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Delete.jpg" EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Insert.jpg" NewImageUrl="~/Images/New.jpg" UpdateImageUrl="~/Images/Save.jpg">
                <ItemStyle HorizontalAlign="Center"  Wrap="False"/>
            </asp:CommandField>
        </Fields>
        <EmptyDataRowStyle BackColor="Transparent" />
    </asp:DetailsView>
    <br />
    <table class="FormView">
        <tr>
            <td class="Header" style="height: 20px;text-align:left">
                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, FILTER %>"></asp:Label></td>
            <td style="height: 20px; text-align: left">
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:ImageButton ID="ImageButton2"
                    runat="server" ImageUrl="~/Images/btn_find.gif" /></td>
        </tr>
    </table>
    <br />
    <br />
    <asp:GridView ID="gvUsers" runat="server" AllowPaging="True"
        AutoGenerateColumns="False" DataSourceID="obsResponsible" OnSelectedIndexChanged="gvUsers_SelectedIndexChanged" DataKeyNames="Username">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemStyle HorizontalAlign="Center" Width="80px" />
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                        Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Username" SortExpression="Username">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Username") %>'></asp:TextBox>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, NAME %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active" SortExpression="Active">
                <ItemStyle HorizontalAlign="Center" Width="50px" />
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Enabled="false" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />
    <asp:ObjectDataSource ID="obsResponsible" runat="server" DeleteMethod="Delete" InsertMethod="Insert" SelectMethod="GetDataByUsername"
        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter"
        UpdateMethod="Update" OnDeleted="obsDataSource_Deleted" OnInserted="obsDataSource_Inserted" OnUpdated="obsDataSource_Updated">
        <DeleteParameters>
            <asp:ControlParameter ControlID="gvUsers" Name="Username" PropertyName="SelectedValue"
                Type="String" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:ControlParameter ControlID="gvUsers" Name="Username" PropertyName="SelectedValue"
                Type="String" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="Username" PropertyName="Text"
                Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
