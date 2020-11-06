<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="CategoryCad.aspx.cs" Inherits="ProjectTracker.Pages.CategoryCad" %>

<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons"
    TagPrefix="uc2" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc3" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc4" %>


<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<asp:Content id="Content1" ContentPlaceHolderid="MainContent" runat="server">

    <div style="text-align:center;"  class="spacing_title">
        <asp:Label id="Label5" runat="server" Text="<%$ Resources:Default, TITLE_CATEGORY %>" Skinid="Title"/>
        <br />
        <br />
        <uc1:MessagePanel id="MessagePanel1" runat="server" />
    </div>
    <br />    
    <asp:DetailsView id="dvCategory" runat="server" AutoGenerateRows="False" DataSourceid="obsCategory" AllowPaging="False">
        <EmptyDataTemplate>
            <table class="FormView">
                <tr>
                    <td class="Footer">
                        <asp:Label id="Label33" runat="server" Text="<%$ Resources:Default, INSERT_NEW_PROJECT&#9; %>"></asp:Label></td>
                </tr>
                <tr>
                    <td class="Footer" style="height: 20px">
                        <asp:ImageButton id="ImageButton1" runat="server" CommandName="New" ImageUrl="~/Images/Add.jpg" /></td>
                </tr>
            </table>
        </EmptyDataTemplate>
        <Fields>
            <asp:TemplateField HeaderText="PS_CODIGO" InsertVisible="False" SortExpression="PS_CODIGO">
                <EditItemTemplate>
                    <asp:Label id="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label id="lblThCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label id="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_DESCRICAO" SortExpression="PS_DESCRICAO">
                <EditItemTemplate>
                    <asp:TextBox id="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox id="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                    <asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox1"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label id="lblThDescription" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label id="Label2" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_ATIVO" SortExpression="PS_ATIVO">
                <EditItemTemplate>
                    <asp:CheckBox id="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox id="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </InsertItemTemplate>
                <HeaderTemplate>
                    <asp:Label id="lblThAtivo" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox id="CheckBox1" runat="server" Checked='<%# Eval("Active") %>' Enabled="False" />
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
                <asp:Label id="Label4" runat="server" Text="<%$ Resources:Default, FILTER %>"></asp:Label></td>
           <td style="height: 20px; text-align: left">
                <asp:TextBox id="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:ImageButton id="ImageButton2"
                    runat="server" ImageUrl="~/Images/btn_find.gif" /></td>
        </tr>
    </table>
    <br />
    <asp:GridView id="gvCategory" runat="server" AllowPaging="True" AllowSorting="False"
        AutoGenerateColumns="False" DataKeyNames="Code,Description" DataSourceid="obsCategory" OnSelectedIndexChanged="gvCategory_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemStyle HorizontalAlign="Center" Width="80px" />
                <ItemTemplate>
                    <asp:LinkButton id="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                        Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_DESCRICAO" SortExpression="PS_DESCRICAO">
                <EditItemTemplate>
                    <asp:TextBox id="TextBox1" runat="server" Text='<%# Eval("Description") %>'></asp:TextBox>
                </EditItemTemplate>
                <HeaderTemplate>
                    <asp:Label id="Label3" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label id="Label2" runat="server" Text='<%# Eval("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="PS_ATIVO" SortExpression="PS_ATIVO">
                <ItemStyle HorizontalAlign="Center" Width="50px" />
                <HeaderTemplate>
                    <asp:Label id="Label3" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:CheckBox id="CheckBox1" runat="server" Checked='<%# Eval("Active") %>' Enabled="False" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:ObjectDataSource id="obsCategory" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        SelectMethod="GetDataByDescription" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CategoryTableAdapter"
        UpdateMethod="Update" OnInserting="obsCategory_Inserting" OnDeleted="obsCategory_Deleted" OnInserted="obsCategory_Inserted" OnUpdated="obsCategory_Updated" OnUpdating="obsCategory_Updating">
        <DeleteParameters>
            <asp:ControlParameter Controlid="gvCategory" Name="Original_PA_CODIGO" PropertyName="SelectedValue"
                Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:ControlParameter Controlid="gvCategory" Name="Original_PA_CODIGO" PropertyName="SelectedValue"
                Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter Controlid="txtSearch" DefaultValue="%" Name="DESCRICAO" PropertyName="Text"
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
