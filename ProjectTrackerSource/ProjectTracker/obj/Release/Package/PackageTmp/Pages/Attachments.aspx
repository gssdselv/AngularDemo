<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Attachments.aspx.cs" Inherits="ProjectTracker.Pages.Attachments" Theme="Default" %>

<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
 <title>Engineering Project Tracker - Attached Files</title>

</head>
<body style="background-color:#D9D9D9;">
    <form id="form1" runat="server">
    <div style="width:100%;text-align:center;vertical-align:middle;">
    <br />
    <div id="container_popup" style="text-align:center;vertical-align:middle;">
        <asp:Label ID="Label5" runat="server" SkinID="Title" Text="<%$ Resources:Default, ANEXOS %>"></asp:Label><br />
        <br />
        <uc1:MessagePanel ID="MessagePanel1" runat="server" />
        <table class="FormView" style="width:98%;height:10px;">
            <tr>
                <td class="Header" colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td class="DescLeft" style="width: 120px">
                    <asp:Label ID="Label1" runat="server" Text="Find File:"></asp:Label></td>
                <td style="text-align: left">
                    <asp:FileUpload ID="fuAttechement" runat="server" Font-Names="Verdana" Font-Size="8pt" Width="400px" BorderWidth="1px" /></td>
            </tr>
            <tr>
                <td class="Footer" colspan="2">
                    <asp:ImageButton ID="btnAdd" runat="server" ImageUrl="~/Images/Add.jpg" OnClick="btnAdd_Click" />&nbsp;<a href="#" onclick="window.close()"><img src="../images/Cancel.jpg" alt="Close the Screen"/></a></td>
            </tr>
        </table>
        <br />
        &nbsp;<br />
        <div style="text-align:center">
        <asp:GridView ID="gvAtteChement" runat="server" AutoGenerateColumns="False" DataSourceID="obsAttachements"
            Width="97%" DataKeyNames="Code,Url" OnRowDataBound="gvAtteChement_RowDataBound" OnRowDeleting="gvAtteChement_RowDeleting" OnRowCommand="gvAtteChement_RowCommand" OnSelectedIndexChanged="gvAtteChement_SelectedIndexChanged" OnSelectedIndexChanging="gvAtteChement_SelectedIndexChanging">
            <Columns>
                <asp:TemplateField HeaderText="FileName">
                    <ItemTemplate>
                        <asp:Label ID="lblFileName" runat="server" Text='<%# Eval("Url") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle Width="20px" />
                    <HeaderStyle Width="30px" />
                    <ItemTemplate>
                        <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="~/Images/delete.gif" CommandName="Delete" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:ButtonField ButtonType="Image" CommandName="Select" ImageUrl="~/Images/build.gif" >                    
                    <ItemStyle HorizontalAlign="Center" />
                    <HeaderStyle Width="30px" />
                </asp:ButtonField>
            </Columns>
            <EmptyDataTemplate>
                <span style="color: #ff0033">No Attachement Found</span>
            </EmptyDataTemplate>
        </asp:GridView>
        <asp:ObjectDataSource ID="obsAttachements" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataBy1" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ProjectAttchementTableAdapter" UpdateMethod="Update">
            <DeleteParameters>
                <asp:Parameter Name="Original_PJ_CODIGO" Type="Int32" />
                <asp:Parameter Name="Original_PJA_URL" Type="String" />
            </DeleteParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="ProjectCode" QueryStringField="ProjectCode" Type="Int32" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="PJ_CODIGO" Type="Int32" />
                <asp:Parameter Name="PJA_URL" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="PJ_CODIGO" Type="Int32" />
                <asp:Parameter Name="PJA_URL" Type="String" />
                <asp:Parameter Name="Original_PJ_CODIGO" Type="Int32" />
                <asp:Parameter Name="Original_PJA_URL" Type="String" />
            </UpdateParameters>
        </asp:ObjectDataSource>
        &nbsp;</div></div>
    </form>
</body>
</html>
