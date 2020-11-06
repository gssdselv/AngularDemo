<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="LanguageCad.aspx.cs" Inherits="ProjectTracker.Pages.LanguageCad" %>

<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc4" %>

<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons" TagPrefix="uc1" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc2" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <br />
    <div style="text-align:center;">
        <uc4:MessagePanel ID="MessagePanel1" runat="server" />
    </div>
    <br />
    <asp:DetailsView ID="dvLanguage" runat="server" AutoGenerateRows="False" DataKeyNames="Code"
        DataSourceID="obsLanguage">
        <EmptyDataTemplate>
            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="New"
                Text="<%$ Resources:Default, NEW_ITEM %>"></asp:LinkButton>
        </EmptyDataTemplate>
        <Fields>
            <asp:TemplateField HeaderText="Code" SortExpression="Code">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="7" Text='<%# Bind("Code") %>'></asp:TextBox>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Description" SortExpression="Description">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
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
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Delete.jpg" EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Insert.jpg" NewImageUrl="~/Images/New.jpg" UpdateImageUrl="~/Images/Save.jpg">
                <ItemStyle HorizontalAlign="Center"  Wrap="False"/>
            </asp:CommandField>
        </Fields>
    </asp:DetailsView>
    <br />
    <Table class="FormView">
        <tr>
            <td class="Header" style="height: 20px;text-align:left">
                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, FILTER %>"></asp:Label></td>
            <td style="height: 20px;text-align:left">
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:Button ID="Button1"
                    runat="server" Text="Ok" /></td>
        </tr>
    </Table>
    <br />
    <asp:GridView ID="gvLanguage" runat="server" AllowPaging="True" AllowSorting="False"
        AutoGenerateColumns="False" DataKeyNames="Code" DataSourceID="obsLanguage" OnSelectedIndexChanged="gvLanguage_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkSelect" runat="server" CausesValidation="False" CommandName="Select"
                        Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_CODIGO" InsertVisible="False" SortExpression="PS_CODIGO">
                <EditItemTemplate>
                    <asp:Label ID="lblCode1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblCode" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_DESCRICAO" SortExpression="PS_DESCRICAO">
                <EditItemTemplate>
                    <asp:TextBox ID="txtDescription1" runat="server" Text='<%# Eval("Description") %>'></asp:TextBox>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblHEaderDescription" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblDescription" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_ATIVO" SortExpression="PS_ATIVO">
                <HeaderTemplate>
                    <asp:Label ID="lblHeaderActive" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="chkActive" runat="server" Checked='<%# Eval("Active") %>' Enabled="False" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource ID="obsLanguage" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        SelectMethod="GetDataByDescription" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.LanguageTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:ControlParameter ControlID="gvLanguage" Name="Code" PropertyName="SelectedValue"
                Type="String" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:ControlParameter ControlID="gvLanguage" Name="Code" PropertyName="SelectedValue"
                Type="String" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="Description" PropertyName="Text" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
