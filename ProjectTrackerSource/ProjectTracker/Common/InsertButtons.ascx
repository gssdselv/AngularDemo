<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="InsertButtons.ascx.cs" Inherits="ProjectTracker.Common.InsertButtons" %>
<div style="text-align:center">
<asp:ImageButton ID="ImageButton1" runat="server" CommandName="Insert" ImageUrl="<%$ Resources:Default, INSERT_IMAGE %>" />&nbsp;<asp:ImageButton
    ID="ImageButton2" runat="server" CommandName="Cancel" ImageUrl="<%$ Resources:Default, CANCEL_IMAGE %>" CausesValidation="False" />
    </div>
