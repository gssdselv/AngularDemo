<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="teste.aspx.cs" Inherits="ProjectTracker.Pages.teste" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <style type="text/css">.cal_Theme1 .ajax__calendar_container   {    background-color: #e2e2e2;     border:solid 1px #cccccc;}.cal_Theme1 .ajax__calendar_header  {    background-color: #ffffff;     margin-bottom: 4px;}.cal_Theme1 .ajax__calendar_title,.cal_Theme1 .ajax__calendar_next,.cal_Theme1 .ajax__calendar_prev    {    color: #004080;     padding-top: 3px;}.cal_Theme1 .ajax__calendar_body    {    background-color: #e9e9e9;     border: solid 1px #cccccc;}.cal_Theme1 .ajax__calendar_dayname {    text-align:center;     font-weight:bold;     margin-bottom: 4px;     margin-top: 2px;}.cal_Theme1 .ajax__calendar_day {    text-align:center;}.cal_Theme1 .ajax__calendar_hover .ajax__calendar_day,.cal_Theme1 .ajax__calendar_hover .ajax__calendar_month,.cal_Theme1 .ajax__calendar_hover .ajax__calendar_year,.cal_Theme1 .ajax__calendar_active  {    color: #004080;     font-weight: bold;     background-color: #ffffff;}.cal_Theme1 .ajax__calendar_today   {    font-weight:bold;}.cal_Theme1 .ajax__calendar_other,.cal_Theme1 .ajax__calendar_hover .ajax__calendar_today,.cal_Theme1 .ajax__calendar_hover .ajax__calendar_title {    color: #bbbbbb;}
</style>
</head>
<body>

    <form id="form1" runat="server">
    <div>  
      <ajax:ScriptManager ID="ScriptManager1" runat="server"></ajax:ScriptManager>
      <asp:TextBox ID="TextBox1" runat="server" Width="200px"></asp:TextBox>
      <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/background_calendar.gif" />&nbsp;
      <cc1:CalendarExtender     CssClass="cal_Theme1"     ID="CalendarExtender1"     runat="server"     
      PopupButtonID="Image1"    PopupPosition="Right"    TargetControlID="TextBox1">
      </cc1:CalendarExtender>
    </div>
    </form>
</body>
</html>
