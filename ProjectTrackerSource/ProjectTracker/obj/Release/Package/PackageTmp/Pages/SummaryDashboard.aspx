<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="SummaryDashboard.aspx.cs" Inherits="ProjectTracker.Pages.SummaryDashboard" %>

<%--<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div>
        <asp:Panel ID="pnlNonClosed" runat="server" Style="float: left; width: 55%">
            <asp:Chart ID="SummaryChart" runat="server" Width="700px">
                <Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea1">
                        <Area3DStyle Enable3D="True" IsClustered="True" />
                    </asp:ChartArea>
                </ChartAreas>
                <Legends>
                    <asp:Legend Alignment="Center" BackColor="Transparent" Docking="Bottom" Font="Verdana, 9.75pt, style=Bold" IsTextAutoFit="False" Name="Legend1">
                    </asp:Legend>
                </Legends>
            </asp:Chart>
        </asp:Panel>
        <asp:Panel ID="pnlClosed" runat="server" Style="float: left; width: 45%;">
            <asp:Chart ID="SummaryChartClosed" runat="server" Width="595px">
                <Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea1">
                        <Area3DStyle Enable3D="True" IsClustered="True" />
                    </asp:ChartArea>
                </ChartAreas>
                <Legends>
                    <asp:Legend Alignment="Center" BackColor="Transparent" Docking="Bottom" Font="Verdana, 9.75pt, style=Bold" IsTextAutoFit="False" Name="Legend1">
                    </asp:Legend>
                </Legends>
            </asp:Chart>
        </asp:Panel>
        <br />
        <asp:Panel ID="pnlGrid" runat="server" Width="100%">
            <table style="width:100%;">
                <tr>
                    <td align="center" style="font-size: 12pt; font-family: Verdana; font-weight: bold">
                        Summary Dashboard
                    </td>
                </tr>
                <tr>
                    <td align="center">
                        <asp:GridView ID="gvSummaryDetail" runat="server" Width="70%"  BorderColor="Black" BorderWidth="1px" BorderStyle="Solid" AlternatingRowStyle-Height="23px" RowStyle-Height="23px" Font-Names="Verdana" Font-Size="9.75pt" OnRowDataBound="gvSummaryDetail_RowDataBound">
                        </asp:GridView>
                    </td>
                </tr>
            </table>

        </asp:Panel>



        <br />
    </div>
</asp:Content>

