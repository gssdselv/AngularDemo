<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SummaryDashboard.aspx.cs" Inherits="ProjectTracker.SummaryDashboard" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Chart ID="SummaryChart" runat="server" Width="950px">
                <Legends>
                    <asp:Legend TitleFont="Verdana, 8pt, style=Bold" BackColor="Transparent" Font="Verdana, 10pt, style=Bold"
                        IsTextAutoFit="False" Enabled="True" Name="Default" Docking="Bottom" Alignment="Center">
                    </asp:Legend>
                </Legends>
                <Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="ChartArea1" Area3DStyle-Enable3D="true"
                        Area3DStyle-IsClustered="true" BorderWidth="1" Area3DStyle-WallWidth="1" Area3DStyle-PointGapDepth="50" Area3DStyle-PointDepth="100" Area3DStyle-Rotation="10">
                    </asp:ChartArea>
                </ChartAreas>

            </asp:Chart>

            <br />
            <asp:GridView ID="gvSummaryDetail" runat="server" Width="950px">
            </asp:GridView>
            <br />
        </div>
    </form>
</body>
</html>
