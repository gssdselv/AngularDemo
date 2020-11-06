<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="CustomerCad.aspx.cs" Inherits="ProjectTracker.Pages.CustomerCad" %>


<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons"
    TagPrefix="uc2" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc3" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc4" %>

<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div style="text-align:center"  class="spacing_title">
        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, TITLE_CUSTOMER %>" SkinID="Title"/>
        <br />
        <br />
        <uc1:MessagePanel ID="MessagePanel1" runat="server" />
    </div>
    <br />
    <asp:DetailsView ID="dvCustomer" runat="server" AutoGenerateRows="False" DataSourceID="obsCustomer">
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
            <asp:TemplateField HeaderText="PS_CODIGO" InsertVisible="False" SortExpression="PS_CODIGO">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_DESCRICAO" SortExpression="PS_DESCRICAO">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox1"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThDescription" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_ATIVO" SortExpression="PS_ATIVO">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="lblThAtivo" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Eval("Active") %>' Enabled="False" />
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
            <td class="Header" style="height: 20px;text-align:left;">
                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, FILTER %>"></asp:Label></td>
           <td style="height: 20px; text-align: left">
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:ImageButton ID="ImageButton2"
                    runat="server" ImageUrl="~/Images/btn_find.gif" /></td>
        </tr>
    </table>
    <br />
    <asp:GridView ID="gvCustomer" runat="server" AllowPaging="True" AllowSorting="False"
        AutoGenerateColumns="False" DataKeyNames="Code,Description" DataSourceID="obsCustomer" OnSelectedIndexChanged="gvCustomer_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemStyle HorizontalAlign="Center" Width="80px" />
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                        Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_DESCRICAO" SortExpression="PS_DESCRICAO">
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
            <asp:TemplateField HeaderText="PS_ATIVO" SortExpression="PS_ATIVO">
                <ItemStyle HorizontalAlign="Center" Width="50px" />
                <HeaderTemplate>
                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Eval("Active") %>' Enabled="False" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource ID="obsCustomer" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByDescription"
        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CustomerTableAdapter"
        UpdateMethod="Update" OnInserting="obsCustomer_Inserting" OnDeleted="obsDataSource_Deleted" OnInserted="obsDataSource_Inserted" OnUpdated="obsDataSource_Updated" OnUpdating="obsCustomer_Updating">
        <DeleteParameters>
            <asp:ControlParameter ControlID="gvCustomer" Name="Original_PC_CODIGO" PropertyName="SelectedValue"
                Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:ControlParameter ControlID="gvCustomer" Name="Original_PC_CODIGO" PropertyName="SelectedValue"
                Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="Description" PropertyName="Text"
                Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
