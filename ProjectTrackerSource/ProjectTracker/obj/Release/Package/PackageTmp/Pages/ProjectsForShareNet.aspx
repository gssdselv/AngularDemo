<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectsForShareNet.aspx.cs" Inherits="ProjectTracker.Pages.ProjectsForShareNet" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:GridView ID="GridView1" SkinID="GridViewForShareNet" AllowPaging="true" AllowSorting="true" DataSourceID="ObjectDataSource1" onrowdatabound="GridView1_RowDataBound" AutoGenerateColumns="false" runat="server" DataKeyNames="DESCRIPTION,ENG_LINK,ENG_IP,STATUS">
            <Columns>
                <asp:BoundField HeaderText="Number" DataField="CODE" SortExpression="CODE">
                </asp:BoundField>
                <asp:BoundField HeaderText="Region" DataField="REGION" SortExpression="REGION">
                </asp:BoundField>
                <asp:TemplateField HeaderText="Project Title With Link to Eng. Report">
                    <ItemTemplate>
                        <asp:HyperLink ID="hylProjectTitle" runat="server" Target="_blank"></asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Responsible" DataField="RESPONSIBLE_NAME" SortExpression="RESPONSIBLE_NAME">
                    <ItemStyle Wrap="false" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Open Date" DataField="OPEN_DATE" DataFormatString="{0:yyyy-MM-dd}" SortExpression="OPEN_DATE">
                    <HeaderStyle Wrap="false" />
                    <ItemStyle Wrap="false" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Due Date" DataField="COMMIT_DATE" DataFormatString="{0:yyyy-MM-dd}" SortExpression="COMMIT_DATE">
                    <HeaderStyle Wrap="false" />
                    <ItemStyle Wrap="false" />
                </asp:BoundField>
                <asp:BoundField HeaderText="Closed Date" DataField="CLOSED_DATE" DataFormatString="{0:yyyy-MM-dd}" SortExpression="CLOSED_DATE">
                    <HeaderStyle Wrap="false" />
                    <ItemStyle Wrap="false" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Status">
                    <ItemTemplate>
                        <asp:Image ID="imgStatus" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField HeaderText="Customer" DataField="CUSTOMER" SortExpression="CUSTOMER">
                </asp:BoundField>
                <asp:BoundField HeaderText="Planned Savings" DataField="PLAN_SAV" DataFormatString="{0:c}" SortExpression="PLAN_SAV">
                </asp:BoundField>
                <asp:BoundField HeaderText="Savings" DataField="COST_SAVING" DataFormatString="{0:c}" SortExpression="COST_SAVING">
                </asp:BoundField>
                <asp:BoundField HeaderText="Revenue" DataField="REVENUE" DataFormatString="{0:c}" SortExpression="REVENUE">
                </asp:BoundField>
                <asp:TemplateField HeaderText="IP-Candidate" SortExpression="ENG_IP">
                    <HeaderStyle Wrap="false" />
                    <ItemTemplate>
                        <asp:Image ID="imgIP" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <a style="cursor:hand;" onclick="<%# Eval("CODE", "javascript:window.open('ExportToPowerPoint.aspx?ProjectId={0}');") %>">
                        <asp:Image ID="imgPowerPoint" runat="server" BorderWidth="0px" ImageUrl="~/Images/ppt.png" AlternateText="Export to PowerPoint" Height="22"/></a> 
                    </ItemTemplate>
                    <ItemStyle Width="18px"/>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetProjectsForGroup" DeleteMethod="EmptyDelete" TypeName="ProjectTracker.Business.Group">
            <SelectParameters>
                <asp:QueryStringParameter Name="groupName" QueryStringField="groupName" Type="String" />
                <asp:QueryStringParameter Name="status" QueryStringField="status" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </div>
    </form>
</body>
</html>
