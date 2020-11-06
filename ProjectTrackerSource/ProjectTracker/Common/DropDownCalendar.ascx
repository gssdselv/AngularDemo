<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DropDownCalendar.ascx.cs" Inherits="ProjectTracker.Common.DropDownCalendar" %>

<script type="text/javascript">
    
    function showCalendar(calendarId, hiddenId)
    {
        var display = document.getElementById(hiddenId).value;
        if(display == "none")
        {
            display = "block";
        }
        else
        {
            display = "none";
        }
        document.getElementById(calendarId).style.display = display;
        if(display=="block")        
            document.getElementById(calendarId).focus();
        document.getElementById(hiddenId).value = display;
    }
    
    function setSelectedDate(textBoxId, selectedDateId, calendarId, hiddenId, date, parentId)
    {
        document.getElementById(textBoxId).value = date;
        document.getElementById(selectedDateId).value = date;
        document.getElementById(parentId).value = date;
        showCalendar(calendarId, hiddenId);
    }
    
    function clearCalendar(textBoxId, selectedDateId, parentId)
    {
        document.getElementById(textBoxId).value = "";
        document.getElementById(selectedDateId).value = "";
        document.getElementById(parentId).value = "";
    }

    function setCtlValue(id1, id2, id3, id4) {
        document.getElementById(id2).value = document.getElementById(id1).value;
        document.getElementById(id3).value = document.getElementById(id1).value;
        document.getElementById(id4).value = document.getElementById(id1).value;
    }
           
</script>

<asp:HiddenField ID="panelStatus" runat="server" Value="none" />
<asp:HiddenField ID="selectedDate" runat="server" Value="" />
<asp:TextBox ID="txtSelectedDate" runat="server" OnLoad="txtSelectedDate_Load" Width="70px"></asp:TextBox>
<asp:ImageButton ID="btnShowCalendar" runat="server" ImageUrl="~/Images/ShowCalendar.gif" ToolTip="Show Calendar" />
<asp:ImageButton ID="btnClearCalendar" runat="server" ImageUrl="~/Images/eraser.gif" ToolTip="Clear Selected Date" />
&nbsp;
<asp:Panel ID="calendarContainer" runat="server" OnLoad="calendarContainer_Load">
    <asp:Calendar ID="cld" runat="server" BackColor="#F1F1F1" BorderColor="#999999" DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="7pt" ForeColor="Black" Height="144px" Width="160px" OnDayRender="cld_DayRender" CellPadding="4" EnableTheming="True">
        <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" Height="10px" />
        <SelectorStyle BackColor="#CCCCCC" Height="10px" />
        <NextPrevStyle Height="10px" />
        <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" Height="10px" />
        <TitleStyle BackColor="#F1F1F1" Font-Bold="True" Font-Size="7pt" Height="10px" HorizontalAlign="Center" />
        <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" Height="10px" />
        <WeekendDayStyle BackColor="LightSteelBlue" Height="10px" />
        <OtherMonthDayStyle ForeColor="Gray" Height="10px" />
        <DayStyle Height="10px" />
    </asp:Calendar>
</asp:Panel>
