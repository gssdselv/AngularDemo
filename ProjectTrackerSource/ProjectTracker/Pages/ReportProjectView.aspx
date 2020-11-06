<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ReportProjectView.aspx.cs" Inherits="ProjectTracker.Pages.ReportProjectView" %>
<%@ Register Assembly="ReportViewer" Namespace="Microsoft.Samples.ReportingServices"
    TagPrefix="microsoft" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <microsoft:ReportViewer ID="rvProjects"  runat="server" Height="595px" Width="100%" Parameters="false" ServerUrl="http://saont056/reportserver" />                
</asp:Content>
