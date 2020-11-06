<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectResponsibles.aspx.cs" Inherits="ProjectTracker.Pages.ProjectResponsibles" %>

<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body style="background-color:#ffffff;">
    <form id="form1" runat="server">
    <div style="background-color:#ffffff;width:100%;height:100%;text-align:center;">
        <uc1:MessagePanel ID="MessagePanel1" runat="server" />
        <br />
        <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Default, RESPONSIBLES %>" SkinID="Title"></asp:Label><br />
        <br />
        <asp:MultiView ID="mvViews" runat="server">
            <asp:View ID="vwGrid" runat="server">
                <asp:GridView ID="gvResponsiblesProject" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="PJ_CODIGO,PU_USUARIO" DataSourceID="obsResponsiblesProject">
                    <Columns>
                        <asp:BoundField DataField="PJ_CODIGO" HeaderText="PJ_CODIGO" ReadOnly="True" SortExpression="PJ_CODIGO" />
                        <asp:BoundField DataField="PU_USUARIO" HeaderText="PU_USUARIO" ReadOnly="True" SortExpression="PU_USUARIO" />
                        <asp:BoundField DataField="PU_NAME" HeaderText="PU_NAME" SortExpression="PU_NAME" />
                        <asp:BoundField DataField="PJ_DESCRIPTION" HeaderText="PJ_DESCRIPTION" SortExpression="PJ_DESCRIPTION" />
                    </Columns>
                </asp:GridView>
            </asp:View>
            <asp:View ID="vwForm" runat="server">
                <asp:FormView ID="frmResponsiblesProject" runat="server" DataKeyNames="PJ_CODIGO,PU_USUARIO"
                    DataSourceID="obsResponsiblesProject">
                    <InsertItemTemplate>
                        &nbsp;<table cellpadding="2" cellspacing="0" class="FormView" style="border-right: #f8f7f7 1px solid;
                            border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;
                            height: 24px">
                            <tr>
                                <td class="Header" colspan="4" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                                    border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                                    border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                                    <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label></td>
                                <td colspan="3" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                                    border-left: #f8f7f7 1px solid; color: #000000; border-bottom: #f8f7f7 1px solid">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td class="Footer" colspan="4" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                                    border-left: #f8f7f7 1px solid; width: 100%; border-bottom: #f8f7f7 1px solid">
                                    <uc2:InsertButtons ID="InsertButtons1" runat="server" />
                                </td>
                            </tr>
                        </table>
                        <br />
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <br />
                    </ItemTemplate>
                </asp:FormView>
            </asp:View>
        </asp:MultiView>
        <asp:ObjectDataSource ID="obsResponsiblesProject" runat="server" OldValuesParameterFormatString="original_{0}"
            SelectMethod="GetData" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsiblesProjectsTableAdapter">
        </asp:ObjectDataSource>
    </div>
    </form>
</body>
</html>
