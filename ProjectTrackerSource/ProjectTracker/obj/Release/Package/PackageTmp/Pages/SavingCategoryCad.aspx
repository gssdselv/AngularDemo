<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="SavingCategoryCad.aspx.cs" Inherits="ProjectTracker.Pages.SavingCategoryCad" Title="Untitled Page" %>

<%@ Register Src="~/Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="text-align:center">        
    <asp:Label ID="Label5" runat="server" SkinID="Title" Text="<%$ Resources:Default, TITLE_SAVING_CATEGORY %>"></asp:Label>
    <br />
    <br />
    <uc1:MessagePanel ID="MessagePanel1" runat="server" />
    <br />
    <asp:DetailsView ID="dvSavingCategory" runat="server" AutoGenerateRows="False"
        DataSourceID="obsSavingCategory">
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
            <asp:TemplateField HeaderText="PN_CODIGO" InsertVisible="False" SortExpression="PN_CODIGO">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PN_DESCRIPTION" SortExpression="PN_DESCRIPTION">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox2"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThDescription" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
             <asp:TemplateField HeaderText="PN_ABBREVIATION" SortExpression="PN_ABBREVIATION">
               <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" MaxLength="10" Text='<%# Bind("Abbreviation") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBox3"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox4" runat="server" MaxLength="10" Text='<%# Bind("Abbreviation") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="TextBox4"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThAbbreviation" runat="server" Text="<%$ Resources:Default, ABBREVIATION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Eval("Abbreviation") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PN_TAG" SortExpression="PN_TAG">
               <EditItemTemplate>
                    <asp:TextBox ID="TextBox5" runat="server" MaxLength="50" Text='<%# Bind("Tag") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="TextBox5"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox6" runat="server" MaxLength="50" Text='<%# Bind("Tag") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TextBox6"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThTag" runat="server" Text="<%$ Resources:Default, TAG %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Eval("Tag") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CommandField ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Delete.jpg"
                EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Insert.jpg" NewImageUrl="~/Images/New.jpg"
                ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" UpdateImageUrl="~/Images/Save.jpg">
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:CommandField>
        </Fields>
        <EmptyDataRowStyle BackColor="Transparent" />
    </asp:DetailsView>
    &nbsp;
    <br />
    <table class="FormView">
        <tr>
            <td class="Header" style="height: 20px; text-align: left">
                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, FILTER %>"></asp:Label></td>
            <td style="height: 20px; text-align: left">
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:ImageButton ID="ImageButton2"
                    runat="server" ImageUrl="~/Images/btn_find.gif" /></td>
        </tr>
    </table>
    <br />
    <asp:GridView ID="gvSavingCategory" runat="server" AllowPaging="True" AllowSorting="False"
        AutoGenerateColumns="False" DataKeyNames="Code,Description" DataSourceID="obsSavingCategory"
        OnSelectedIndexChanged="gvSavingCategory_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemStyle HorizontalAlign="Center" Width="80px" />
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                        Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PN_DESCRIPTION" SortExpression="PN_DESCRIPTION">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("Description") %>'></asp:TextBox>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
               <asp:TemplateField HeaderText="PN_ABBREVIATION" SortExpression="PN_ABBREVIATION">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("Abbreviation") %>'></asp:TextBox>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, ABBREVIATION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Eval("Abbreviation") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PN_TAG" SortExpression="PN_TAG">
                <ItemStyle HorizontalAlign="Center" Width="50px" />
                <HeaderTemplate>
                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Default, TAG %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label7" runat="server" Text='<%# Eval("Tag") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <PagerStyle HorizontalAlign="Right" />
    </asp:GridView>
    <asp:ObjectDataSource ID="obsSavingCategory" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OnDeleted="obsSavingCategory_Deleted" OnInserted="obsSavingCategory_Inserted" OnInserting="obsSavingCategory_Inserting"
        OnUpdated="obsSavingCategory_Updated" OnUpdating="obsSavingCategory_Updating" SelectMethod="GetDataByDescription"
        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SavingCategoryTableAdapter"
        UpdateMethod="Update" OldValuesParameterFormatString="original_{0}">
        <DeleteParameters>
            <asp:ControlParameter ControlID="gvSavingCategory" Name="Code" PropertyName="SelectedValue"
                Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
            <asp:ControlParameter ControlID="gvSavingCategory" Name="Code" PropertyName="SelectedValue"
                Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="Description" PropertyName="Text"
                Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    </div>
</asp:Content>
