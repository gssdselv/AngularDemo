<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="UserMaintenance.aspx.cs" Inherits="ProjectTracker.Pages.UserMaintenance" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="fit" %>

<asp:Content ID="userMaintainContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- Script Manager - ASP.NET Ajax Extensions --%>
    <ajax:ScriptManager ID="smUserMaintenance" runat="server" EnablePartialRendering="true" />
    
    <%-- Message Panel + Page Title --%>
    <div style="text-align:center" class="spacing_title">
        <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:Default, TITLE_USERS %>" SkinID="Title"/><br />
        <br />
        <fit:MessagePanel id="MessagePanel" runat="server"></fit:MessagePanel> 
    </div>
    <br />
    
    <%-- Details View - Edit/Insert Data --%>
    <asp:DetailsView ID="dvUsers" runat="server" AutoGenerateRows="False" DataSourceID="odsUsers" DataKeyNames="Username" OnItemInserting="dvUsers_ItemInserting" OnDataBound="dvUsers_DataBound" OnItemInserted="dvUsers_ItemInserted" OnItemDeleted="dvUsers_ItemDeleted" OnItemDeleting="dvUsers_ItemDeleting" OnItemUpdated="dvUsers_ItemUpdated" OnItemUpdating="dvUsers_ItemUpdating">
        <EmptyDataTemplate>
            <table class="FormView">
                <tr>
                    <td class="Footer">
                        <asp:Label ID="lblAddNew" runat="server" Text="<%$ Resources:Default, INSERT_NEW_PROJECT&#9; %>" />
                    </td>
                </tr>
                <tr>
                    <td class="Footer" style="height: 20px">
                        <asp:ImageButton ID="btnAddNewUser" runat="server" CommandName="New" ImageUrl="~/Images/Add.jpg" />
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
        <Fields>
            <asp:TemplateField HeaderText="<%$ Resources:Default, USERNAME_AD %>">
                <EditItemTemplate>
                    <asp:Label ID="lblUsername" runat="server" Text='<%# Eval("Username") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtUsername" runat="server" Text='<%# Bind("Username") %>' MaxLength="8" />
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" Display="Dynamic" ControlToValidate="txtUsername" ErrorMessage="*" />
                    <asp:ImageButton ID="btnFindUserInfo" runat="server" ImageUrl="~/Images/btn_find.gif" OnClick="btnFindUserInfo_Click" CausesValidation="false" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblUsername" runat="server" Text='<%# Eval("Username") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField HeaderText="<%$ Resources:Default, ACTIVE %>" DataField="Active" />
            <asp:TemplateField HeaderText="<%$ Resources:Default, NAME %>">
                <EditItemTemplate>
                    <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Name") %>' MaxLength="80" Width="385px" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" Display="Dynamic" ControlToValidate="txtName" ErrorMessage="*" />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Name") %>' MaxLength="80" Width="385px" />
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" Display="Dynamic" ControlToValidate="txtName" ErrorMessage="*" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="<%$ Resources:Default, EMAIL %>">
                <EditItemTemplate>
                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' MaxLength="80" Width="385px" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ErrorMessage="*" />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' MaxLength="80" Width="385px" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" Display="Dynamic" ControlToValidate="txtEmail" ErrorMessage="*" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Email") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="<%$ Resources:Default, LANGUAGE %>">
                <EditItemTemplate>
                    <asp:DropDownList ID="lstLanguage" runat="server" SelectedValue='<%# Bind("LanguageCode") %>'>
                        <asp:ListItem Text="English" Value="en-US" />
                        <asp:ListItem Text="Portuguese" Value="pt-BR" />
                    </asp:DropDownList>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="lstLanguage" runat="server" SelectedValue='<%# Bind("LanguageCode") %>'>
                        <asp:ListItem Text="English" Value="en-US" />
                        <asp:ListItem Text="Portuguese" Value="pt-BR" />
                    </asp:DropDownList>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblLanguage" runat="server" Text='<%# Eval("LanguageCode") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:CheckBoxField HeaderText="<%$ Resources:Default, IS_ADMIN %>" DataField="IsAdmin" />
            <asp:CheckBoxField HeaderText="<%$ Resources:Default, RESPONSIBLE %>" DataField="IsResponsible" />
            <asp:TemplateField HeaderText="<%$ Resources:Default, USER_REGION %>">
                <EditItemTemplate>
                    <asp:ListBox ID="lstRegions" runat="server" DataSourceID="odsRegions" DataTextField="Description" DataValueField="Code" SelectionMode="Multiple" />
                    <asp:Label ID="lblRegionUsage" runat="server" Text="(Control + Click to select)" />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:ListBox ID="lstRegions" runat="server" DataSourceID="odsRegions" DataTextField="Description" DataValueField="Code" SelectionMode="Multiple" />
                    <asp:Label ID="lblRegionUsage" runat="server" Text="(Control + Click to select)" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:ListBox ID="lstRegions" runat="server" Enabled="false" DataSourceID="odsRegions" DataTextField="Description" DataValueField="Code" SelectionMode="Multiple" />
                </ItemTemplate>                
            </asp:TemplateField>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Delete.jpg" EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Insert.jpg" NewImageUrl="~/Images/New.jpg" UpdateImageUrl="~/Images/Save.jpg">
                <ItemStyle HorizontalAlign="Center"  Wrap="False"/>
            </asp:CommandField>
        </Fields>
    </asp:DetailsView>
    
    <%-- Filter Panels --%>
    <div style="text-align:left">
        <asp:Panel ID="pnlCollapsed" runat="server" CssClass="collapsePanelHeader" Height="30px"> 
            <div style="padding:5px; cursor: pointer; vertical-align: middle;">                
                <asp:Label ID="lblFilterHeader" Text="<%$ Resources:Default, FILTER %>" runat="server" />
                <asp:Image ID="imgOpen" runat="server" ImageUrl="~/images/down.gif" ImageAlign="Left" />             
            </div>
        </asp:Panel>        
        <asp:Panel ID="pnlExpanded" runat="server" CssClass="collapsePanel" Height="0">
            <table class="FormView">
                <tr>
                    <td class="Header" style="height: 20px">
                        <asp:Label ID="lblFilter" runat="server" Text="<%$ Resources:Default, FILTER %>" />
                    </td>
                    <td style="height: 20px">
                        <asp:TextBox ID="txtSearch" runat="server" />
                        <asp:ImageButton ID="btnApplyFilter" runat="server" ImageUrl="~/Images/btn_find.gif" />
                    </td>
                </tr>
                <tr>
                    <td class="Header" style="vertical-align: top; height: 20px">
                        <asp:Label ID="lblFilterBy" runat="server" Text="<%$ Resources:Default, FILTER_BY %>" />
                    </td>
                    <td style="height: 20px">
                        <asp:RadioButtonList ID="rblFilterParameter" runat="server">
                            <asp:ListItem Selected="True" Value="0">Username</asp:ListItem>
                            <asp:ListItem Value="1">Name</asp:ListItem>
                            <asp:ListItem Value="2">Email</asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </div>
    
    <%-- GridView --%>
    <asp:GridView ID="gvUsers" runat="server" DataSourceID="odsUsers" AutoGenerateColumns="False" OnSelectedIndexChanged="gvUsers_SelectedIndexChanged" DataKeyNames="Username">
        <Columns>
            <asp:CommandField ShowSelectButton="True" SelectText="<%$ Resources:Default, SELECT %>" />
            <asp:BoundField HeaderText="<%$ Resources:Default, USERNAME_AD %>" DataField="Username" />
            <asp:CheckBoxField HeaderText="<%$ Resources:Default, ACTIVE %>" DataField="Active" />
            <asp:BoundField HeaderText="<%$ Resources:Default, NAME %>" DataField="Name" />
            <asp:BoundField HeaderText="<%$ Resources:Default, LAST_LOGIN %>" DataField="LastLogin" />
            <asp:BoundField HeaderText="<%$ Resources:Default, EMAIL %>" DataField="Email" />
            <asp:BoundField HeaderText="<%$ Resources:Default, LANGUAGE %>" DataField="LanguageCode" />
            <asp:CheckBoxField HeaderText="<%$ Resources:Default, IS_ADMIN %>" DataField="IsAdmin" />
        </Columns>
    </asp:GridView>
    
    <%-- Ajax Control Toolkit - Collapsable Panel --%>
    <ajaxToolkit:CollapsiblePanelExtender ID="cpFilter" runat="Server" 
        TargetControlID="pnlExpanded"
        ExpandControlID="pnlCollapsed"
        CollapseControlID="pnlCollapsed" 
        Collapsed="True"
        TextLabelID="lblFilterHeader"
        ExpandedText="<%$  Resources:Default, FILTER_HIDDEN %>"
        CollapsedText="<%$  Resources:Default, FILTER_SHOW %>"
        ImageControlID="imgOpen"
        ExpandedImage="~/images/up.gif"
        CollapsedImage="~/images/down.gif"
        SuppressPostBack="true" />
        
    <%-- Users Object Data Source --%>
    <asp:ObjectDataSource ID="odsUsers" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        SelectMethod="GetDataByOption" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UsersTableAdapter"
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
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="SEARCH" PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="rblFilterParameter" DefaultValue="" Name="OPTION" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="LanguageCode" Type="String" />
            <asp:Parameter Name="IsAdmin" Type="Boolean" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsRegions" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetData" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.RegionsTableAdapter">
    </asp:ObjectDataSource>
    
</asp:Content>
