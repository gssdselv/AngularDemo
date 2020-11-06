<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="TesteReadXLS.aspx.cs" Inherits="ProjectTracker.Pages.TesteReadXLS" Title="Untitled Page" %>

<%@ Register Src="../Common/DropDownCalendar.ascx" TagName="DropDownCalendar" TagPrefix="fit" %>

<%@ Register    
    Assembly="AjaxControlToolkit"
    Namespace="AjaxControlToolkit"
    TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:GridView ID="gv" runat="server">
    </asp:GridView>
    &nbsp;
    <fit:DropDownCalendar ID="DropDownCalendar1" runat="server" NextPrevFormat="CustomText" />
</asp:Content>
