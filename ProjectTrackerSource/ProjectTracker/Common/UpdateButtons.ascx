<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateButtons.ascx.cs" Inherits="ProjectTracker.Common.UpdateButtons" %>
<asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="True" CommandName="Update"
    ImageUrl="<%$ Resources:Default, SAVE_IMAGE %>" />&nbsp;<asp:ImageButton ID="ImageButton2"
        runat="server" CausesValidation="False" CommandName="Cancel" ImageUrl="<%$ Resources:Default, CANCEL_IMAGE %>" />

