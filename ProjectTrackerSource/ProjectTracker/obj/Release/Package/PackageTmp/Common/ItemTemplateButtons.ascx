<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ItemTemplateButtons.ascx.cs" Inherits="ProjectTracker.Common.ItemTemplateButtons" %>
<div style="width:100%; text-align:center;">
<asp:ImageButton ID="ImageButton2" runat="server" CommandName="Edit" ImageUrl="<%$ Resources:Default, EDIT_IMAGE %>" CausesValidation="False" />
<asp:ImageButton ID="ImageButton3" runat="server" CommandName="Delete" ImageUrl="<%$ Resources:Default, DELETE_IMAGE %>" CausesValidation="False" />
<asp:ImageButton ID="ImageButton4" runat="server" CommandName="New" ImageUrl="<%$ Resources:Default, NEW_IMAGE %>" CausesValidation="False" />
</div>