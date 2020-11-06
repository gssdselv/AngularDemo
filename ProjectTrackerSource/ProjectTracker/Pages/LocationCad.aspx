<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="LocationCad.aspx.cs" Inherits="ProjectTracker.Pages.LocationCad" %>



<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons"
    TagPrefix="uc1" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc2" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc3" %>
<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div style="text-align:center;"  class="spacing_title">
    <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, TITLE_LOCATION %>" SkinID="Title"/>
        <br />
        <br />
        <uc4:MessagePanel ID="MessagePanel1" runat="server" />
    </div>
    <br />
    <asp:DetailsView ID="dvLocation" runat="server" AutoGenerateRows="False" DataSourceID="obsLocation">
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
            <asp:TemplateField HeaderText="<%$ Resources:Default,CODE %>" InsertVisible="False" SortExpression="Code">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="<%$ Resources:Default,DESCRIPTION %>" SortExpression="Description">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="50" Text='<%# Bind("Description") %>'></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="<%$ Resources:Default,SITE_CODE %>" SortExpression="SiteCode">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" MaxLength="3" Text='<%# Bind("SiteCode") %>'
                        Width="53px"></asp:TextBox>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" MaxLength="3" Text='<%# Bind("SiteCode") %>'
                        Width="53px"></asp:TextBox>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("SiteCode") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField DataField="Active" HeaderText="<%$ Resources:Default,ACTIVE %>" SortExpression="Active" />
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
    <asp:GridView ID="gvLocation" runat="server" AllowPaging="True"
        AutoGenerateColumns="False" DataKeyNames="Code,Description" DataSourceID="obsLocation" OnSelectedIndexChanged="gvLocation_SelectedIndexChanged">
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
    <asp:ObjectDataSource ID="obsLocation" runat="server" DeleteMethod="Delete" InsertMethod="Insert" SelectMethod="GetDataByDescription"
        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.LocationTableAdapter"
        UpdateMethod="Update" OnDeleted="obsDataSource_Deleted" OnInserted="obsDataSource_Inserted" OnUpdated="obsDataSource_Updated" OnInserting="obsLocation_Inserting" OnUpdating="obsLocation_Updating">
        <DeleteParameters>
            <asp:ControlParameter ControlID="gvLocation" Name="Original_PL_CODIGO" PropertyName="SelectedValue"
                Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="SiteCode" Type="String" />
            <asp:Parameter DefaultValue="df" Name="CountryCode" Type="String" />
            <asp:ControlParameter ControlID="gvLocation" Name="Code" PropertyName="SelectedValue"
                Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="Description" PropertyName="Text"
                Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter DefaultValue="" Name="SiteCode" Type="String" />
            <asp:Parameter DefaultValue="df" Name="CountryCode" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
