<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MessagePanel.ascx.cs" Inherits="Fit.Common.MessagePanel" %>
<asp:Panel ID="pnlMessage" runat="server" BackColor="#FFFFE5" BorderColor="Black" BorderStyle="Solid"
    BorderWidth="1px" Width="95%" EnableViewState="False" Visible="False">
    <table cellpadding="4" style="width: 100%; height: 100%">
        <tr>
            <td align="center">
                <asp:Label ID="lblMessage" runat="server" EnableViewState="False" ForeColor="Black" Font-Bold="true"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Panel>