<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserRegion.aspx.cs" Inherits="ProjectTracker.Pages.UserRegion" %>
<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
 <title>Engineering Project Tracker</title>
    <link href="../App_Themes/Default/Default.css" rel="stylesheet" type="text/css" />
</head>
<body style="background-color:#D9D9D9;">
    <form id="form1" runat="server">
    <div style="width:100%;text-align:center;vertical-align:middle;">
    <br />
    <div id="container_popup" style="text-align:center;vertical-align:middle;">
        <div style="text-align:center" class="spacing_title">
            <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:Default, TITLE_USER_REGION %>" SkinID="Title"/>
            <ajax:ScriptManager ID="ScriptManager1" runat="server">
            </ajax:ScriptManager>
            <br />
            <br />
            <uc1:MessagePanel id="MessagePanel1" runat="server"></uc1:MessagePanel> 
            <br />
            <ajax:UpdateProgress ID="UpdateProgress1" runat="server">
                <ProgressTemplate>
                    <strong><span style="color: #ff0066">
                        <img src="../Images/waiting.gif" /></span></strong>
                </ProgressTemplate>
            </ajax:UpdateProgress>
        </div><table class="FormView" style="width:98%;height:10px;text-align:left;" cellpadding=0 cellspacing=1>
            <tr height=20px>
                <td colspan=2 class="Footer">&nbsp;</td>
            </tr>
            <tr height="20px">
                <td class="Header" style="width: 25%"><asp:Label ID="Label2" runat="server" Text="Username:"></asp:Label></td>
                <td><asp:Label ID="lblUsername" runat="server"></asp:Label></td>
            </tr>
            <tr height="20px">
                <td class="Header" style="width: 25%"><asp:Label ID="Label1" runat="server" Text="Name:"></asp:Label></td>
                <td><asp:Label ID="lblName" runat="server"></asp:Label></td>
            </tr>
            <tr height="20px">
                <td class="Header" style="width: 25%;"><asp:Label ID="Label3" runat="server" Text="Regions"></asp:Label></td>
                <td><ajax:UpdatePanel ID="updDropInsert" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                    <asp:DropDownList ID="drpRegion" runat="server" DataSourceID="obsRegions" DataTextField="RegionDescription"
                        DataValueField="RegionCode" OnDataBound="drpRegion_DataBound">
                    </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="drpRegion"
                                Display="Dynamic" ErrorMessage="Select a Item"></asp:RequiredFieldValidator>
                    <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/Images/Add.jpg" OnClick="btnAdd_Click" /><asp:ObjectDataSource ID="obsRegions" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByInsertRegionToUser"
                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UserRegionsTableAdapter">
                        <DeleteParameters>
                            <asp:Parameter Name="Username" Type="String" />
                            <asp:Parameter Name="RegionCode" Type="Int32" />
                        </DeleteParameters>
                        <SelectParameters>
                            <asp:QueryStringParameter Name="Username" QueryStringField="Username" Type="String" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Username" Type="String" />
                            <asp:Parameter Name="RegionCode" Type="Int32" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                        </ContentTemplate>
                        <Triggers>
                            <ajax:AsyncPostBackTrigger ControlID="btnAdd" EventName="Click" />
                        </Triggers>
                    </ajax:UpdatePanel>
                </td>
            </tr>
            <tr height="20px">
                <td colspan="2" class="Footer">&nbsp;</td>
            </tr>
        </table>
        &nbsp; &nbsp; &nbsp; &nbsp;
        <ajax:UpdatePanel ID="updPnlGvUserInRegions" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
        <asp:GridView ID="gvUsersInRegion" runat="server" AutoGenerateColumns="False" DataKeyNames="Username,RegionCode"
            DataSourceID="obsRegionsInUser" OnRowDeleted="gvUsersInRegion_RowDeleted" OnRowDeleting="gvUsersInRegion_RowDeleting">
            <Columns>
                <asp:BoundField DataField="RegionDescription" HeaderText="Region" SortExpression="RegionDescription" />
                <asp:CommandField ShowDeleteButton="True" ButtonType="Image" DeleteImageUrl="~/Images/Remove.jpg" >
                    <HeaderStyle Width="120px" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:CommandField>
            </Columns>
            <EmptyDataTemplate>
                <table class="FormView">
                    <tr>
                        <td class="Footer">
                            <asp:Label ID="Label4" runat="server" Text="No regions added"></asp:Label></td>
                    </tr>
                </table>
            </EmptyDataTemplate>
        </asp:GridView>
            </ContentTemplate>
            <Triggers>
                <ajax:AsyncPostBackTrigger ControlID="gvUsersInRegion" EventName="RowDeleting" />
            </Triggers>
        </ajax:UpdatePanel>
        <br />
        &nbsp;</div>
        <asp:ObjectDataSource ID="obsRegionsInUser" runat="server" DeleteMethod="Delete"
            SelectMethod="GetDataByUsername" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UserRegionsTableAdapter">
            <DeleteParameters>
                <asp:ControlParameter ControlID="gvUsersInRegion" Name="Username" PropertyName="SelectedDataKey[0]"
                    Type="String" />
                <asp:ControlParameter ControlID="gvUsersInRegion" Name="RegionCode" PropertyName="SelectedDataKey[1]"
                    Type="Int32" />
            </DeleteParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="PU_USUARIO" QueryStringField="Username" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
        </div>
    </form>
    
</body>
</html>
