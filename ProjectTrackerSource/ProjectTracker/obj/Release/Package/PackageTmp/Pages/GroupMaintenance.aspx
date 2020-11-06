<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="GroupMaintenance.aspx.cs" Inherits="ProjectTracker.Pages.GroupMaintenance" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="fit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="text-align:center" class="spacing_title">
        <asp:Label ID="lblPageTitle" runat="server" Text="Group Maintenance" SkinID="Title"/><br />
        <br />
        <fit:MessagePanel id="MessagePanel" runat="server"></fit:MessagePanel> 
    </div>
    <br />
    <table class="FormView" cellpadding="1" cellspacing="0"  border="1">
        <tr>
            <td class="DescLeft" nowrap="nowrap">Group</td>
            <td colspan="1" class="NormalField">
                <asp:TextBox ID="txtGroup" runat="server" Width="300px"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td class="DescLeft" nowrap="nowrap">Users</td>
            <td colspan="1" class="NormalField">
                <table width="350" cellpadding="0" cellspacing="0">
                    <tr>
                        <td class="NormalField" width="150">
                            <asp:ListBox ID="lstResponsiblesAvailable" runat="server" Font-Names="Verdana" Font-Size="8pt" Width="300px" SelectionMode="Multiple" Rows="10"></asp:ListBox></td>
                        <td align="center" valign="middle" width="30">
                            <asp:ImageButton ID="btnMoveResponsibleR" runat="server" ImageUrl="~/Images/Right.jpg" OnClick="btnMoveResponsibleR_Click" ValidationGroup="moveToInsert" /><br />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="lstResponsiblesAvailable"
                                Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToInsert" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                            <br />
                            <asp:ImageButton ID="btnMoveResponsibleL" runat="server" ImageUrl="~/Images/left.jpg" OnClick="btnMoveResponsibleL_Click" ValidationGroup="moveToAvaiable" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="lstResponsiblesToInsert"
                                Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToAvaiable" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                            </td>
                        <td>
                            <asp:ListBox ID="lstResponsiblesToInsert" runat="server" Font-Names="Verdana" Font-Size="8pt" Width="300px" SelectionMode="Multiple" Rows="10"></asp:ListBox></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/Images/Add.jpg" 
                    onclick="btnAdd_Click" />
                <asp:ImageButton ID="btnSave" runat="server" ImageUrl="~/Images/Save.jpg" 
                    onclick="btnSave_Click" />
                <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/Images/Delete.jpg" 
                    onclick="btnDelete_Click" />
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                <asp:GridView ID="GridView1" runat="server" DataSourceID="ObjectDataSource1" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" DataKeyNames="ID,GroupName">
                    <Columns>
                        <asp:CommandField ShowSelectButton="True" SelectText="Select">
                            <HeaderStyle HorizontalAlign="Left" Width="150px" />
                        </asp:CommandField>
                        <asp:BoundField HeaderText="Group" DataField="GroupName" HtmlEncode="false">
                            <HeaderStyle HorizontalAlign="Left" Width="300px" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView> 
                <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetGroups" DeleteMethod="EmptyDelete" TypeName="ProjectTracker.Business.Group">
                </asp:ObjectDataSource>
            </td>
        </tr>
    </table>
    <table cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <asp:HiddenField ID="hdfID" runat="server" />
            </td>
        </tr>
    </table>
</asp:Content>
