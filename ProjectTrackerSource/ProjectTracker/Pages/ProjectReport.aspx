<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ProjectReport.aspx.cs" Inherits="ProjectTracker.Pages.ProjectReport"%>
<%@ Register Assembly="ReportViewer" Namespace="Microsoft.Samples.ReportingServices" TagPrefix="microsoft" %>

<%@ Register Src="../Common/DropDownCalendar.ascx" TagName="DropDownCalendar" TagPrefix="uc5" %>

    
<asp:Content ID="viewReport" ContentPlaceHolderID="MainContent" runat="server">
    <ajax:ScriptManager ID="scriptManager1" runat="server" AllowCustomErrorsRedirect="False"> </ajax:ScriptManager>
    
    <script language="javascript" type="text/javascript">
        function VerifyKeyPress(obj, max) {
            if (obj.value.length == max) {
                event.returnValue = false;
            }
        }

        function VerifyKeyUp(obj, max) {
            if (obj.value.length > max) {
                obj.value = obj.value.substr(0, max);
            }
        }

        function changeRevenueCostSaving() {
            var ddlRevenueCostSaving = document.getElementById('<%=drpRevenueCostSaving.ClientID %>');
            var ddlSavingCategory = document.getElementById('<%=lstSavingCategory.ClientID %>');
            var index = ddlRevenueCostSaving.selectedIndex;
            if (ddlRevenueCostSaving.options[index].text == 'Revenue' || ddlRevenueCostSaving.options[index].text == 'Planned Savings') {
                ddlSavingCategory.disabled = 'disabled';
                ddlSavingCategory.selectedIndex = 0;
            }
            else {
                ddlSavingCategory.disabled = '';
            }
        }
    </script>

    <asp:MultiView ID="mvReports" runat="server" ActiveViewIndex="0">
        <asp:View ID="viParameters" runat="server">
            <div runat="server" style="text-align:center" id="Div1">
                    <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:Default, VIEW_PROJECTS %>" SkinID="Title">
                    </asp:Label><br />
                <br />
                <br /><br />
                <table class="FormView" style="width:600px;" cellpadding="1" cellspacing="0">
                        <tr>
                            <td class="Header" style="height:25px" colspan="2"></td>
                        </tr>
                        <tr>
                            <td class="DescLeft" style="width: 25%">
                                <asp:Label id="Label3" runat="server" Text="<%$ Resources:Default, REGION %>">
                                </asp:Label></td>
                            <td class="NormalField"><asp:DropDownList id="lstRegion" runat="server" Width="288px">
                            </asp:DropDownList><!-- Here, the DropDownList for populate Region--></td>
                        </tr>                        
                        <tr>
                            <td class="DescLeft" style="width: 25%">
                                <asp:Label id="lblCustomer" runat="server" Text="<%$ Resources:Default, CUSTOMER %>">
                                </asp:Label></td>
                            <td class="NormalField">
                                <asp:DropDownList id="lstCustomer" runat="server" Width="288px">
                                </asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td class="DescLeft" style="width: 100px">
                                <asp:Label id="lblLocation" runat="server" Text="<%$ Resources:Default, LOCATION %>">
                                </asp:Label></td>
                            <td class="NormalField">
                                <asp:DropDownList id="lstLocation" runat="server" Width="288px">
                                </asp:DropDownList></td>
                        </tr>
                        <tr>
                            <td class="DescLeft">
                                <asp:Label id="lblResponsible" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>">
                                </asp:Label></td>
                            <td class="NormalField">
                                <ajax:UpdatePanel ID="updResp" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>                               
                                        <table width="350" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="NormalField" width="150">
                                                    <asp:ListBox ID="lstResponsiblesAvailable" runat="server" Font-Names="Verdana" Font-Size="8pt"  Width="150px" SelectionMode="Multiple"></asp:ListBox></td>
                                                <td align="center" valign="middle" width="30">
                                                    <asp:ImageButton ID="btnMoveResponsibleR" runat="server" ImageUrl="~/Images/Right.jpg" OnClick="btnMoveResponsibleR_Click" ValidationGroup="moveToInsert" /><br />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="lstResponsiblesAvailable"
                                                        Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToInsert" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                                    <br />
                                                    <asp:ImageButton ID="btnMoveResponsibleL" runat="server" ImageUrl="~/Images/left.jpg" OnClick="btnMoveResponsibleL_Click" ValidationGroup="moveToAvaiable" />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="lstResponsiblesToInsert"
                                                        Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToAvaiable" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                                    </td>
                                                <td>
                                                    <asp:ListBox ID="lstResponsiblesToInsert" runat="server" Font-Names="Verdana" Font-Size="8pt" Width="150px" SelectionMode="Multiple"></asp:ListBox></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3"><asp:Label ID="lblSelectMany" runat="server" Text="<%$ Resources:Default, SELECT_MANY_LISTBOX %>"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </ajax:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="DescLeft">
                                <asp:Label id="Label7" runat="server" Text="Group">
                                </asp:Label></td>
                            <td class="NormalField">
                                <ajax:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>                               
                                        <table width="350" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="NormalField" width="150">
                                                    <asp:ListBox ID="lstGroupsAvailable" runat="server" Font-Names="Verdana" Font-Size="8pt"  Width="150px" SelectionMode="Multiple"></asp:ListBox></td>
                                                <td align="center" valign="middle" width="30">
                                                    <asp:ImageButton ID="btnMoveGroupR" runat="server" ImageUrl="~/Images/Right.jpg" OnClick="btnMoveGroupR_Click" ValidationGroup="groupmoveToInsert" /><br />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="lstGroupsAvailable"
                                                        Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="groupmoveToInsert" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                                    <br />
                                                    <asp:ImageButton ID="btnMoveGroupL" runat="server" ImageUrl="~/Images/left.jpg" OnClick="btnMoveGroupL_Click" ValidationGroup="groupmoveToAvaiable" />
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="lstGroupsToInsert"
                                                        Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="groupmoveToAvaiable" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                                    </td>
                                                <td>
                                                    <asp:ListBox ID="lstGroupsToInsert" runat="server" Font-Names="Verdana" Font-Size="8pt" Width="150px" SelectionMode="Multiple"></asp:ListBox></td>
                                            </tr>
                                            <tr>
                                                <td colspan="3"><asp:Label ID="Label8" runat="server" Text="<%$ Resources:Default, SELECT_MANY_LISTBOX %>"></asp:Label></td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </ajax:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td class="DescLeft" style="height: 20px">
                                <asp:Label id="lblStatus" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                            <td class="NormalField" style="height: 20px">
                                <asp:DropDownList id="lstStatus" runat="server" Width="288px">
                                </asp:DropDownList></td>
                        </tr>
                        
                        <tr>
                            <td class="DescLeft" style="height: 20px">
                                <asp:Label id="Label6" runat="server" Text="<%$ Resources:Default, REVENUE_COSTSAVING %>"></asp:Label></td>
                            <td class="NormalField" style="height: 20px">
                                <asp:DropDownList ID="drpRevenueCostSaving" runat="server" Width="288px" AutoPostBack="false" onchange="changeRevenueCostSaving()">
                                    <asp:ListItem Text="All" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Cost Avoidance" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Hard Saving" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Revenue" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="Planned Savings" Value="4"></asp:ListItem>
                                </asp:DropDownList></td>
                        </tr>
                        
                        <tr>
                            <td class="DescLeft">
                                <asp:Label id="lblSavingCategory" runat="server" Text="<%$ Resources:Default, SAVINGCATEGORY %>"></asp:Label></td>
                            <td class="NormalField">
                                <asp:DropDownList id="lstSavingCategory" runat="server" Width="288px">
                                </asp:DropDownList></td>
                        </tr>
                        
                        
                    <tr style="display:none">
                        <td class="DescLeft ">
                            <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Default, YEAR %>"></asp:Label></td>
                        <td class="NormalField">
                            <asp:DropDownList ID="ddlYear" runat="server" Width="288px">
                            </asp:DropDownList></td>
                    </tr>
                     <tr>
                        <td class="DescLeft " style="height: 20px">
                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, SEGMENT %>"></asp:Label></td>
                        <td class="NormalField" style="height: 20px">
                            <asp:DropDownList ID="ddlSegment" runat="server" Width="288px">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td class="DescLeft">
                            <asp:Label ID="Label25" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                            <asp:Label ID="lblStartDate" runat="server" Text="Start Date (mm/dd/yyyy)"></asp:Label></td>
                        <td class="CalendarField">
                            <ajax:UpdatePanel ID="updStartDate" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <uc5:DropDownCalendar ID="ddcStartDate" runat="server"  />
                                </ContentTemplate>
                            </ajax:UpdatePanel>
                             <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="ddcStartDate"  ErrorMessage="<%$ Resources:Default, REQUIRED_START_DATE %>" CssClass="warning" ForeColor=""> </asp:RequiredFieldValidator>
                                    &nbsp;
                        </td>
                    </tr>
                    <tr>

                        <td class="DescLeft">
                            <asp:Label ID="Label5" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                            <asp:Label ID="lblEndDate" runat="server" Text="End Date (mm/dd/yyyy)"></asp:Label></td>
                        <td class="CalendarField">
                            <ajax:UpdatePanel ID="updEndDate" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <uc5:DropDownCalendar ID="ddcEndDate" runat="server" />
                                </ContentTemplate>
                            </ajax:UpdatePanel>
                             <asp:CompareValidator ID="compCommitOpen" runat="server" ControlToCompare="ddcStartDate"
                                        ControlToValidate="ddcEndDate" Display="Dynamic" ErrorMessage="<%$ Resources:Default, DATA_INF_START_DATE %>"
                                        Operator="GreaterThan" Type="Date" CssClass="warning" ForeColor="">
                                    </asp:CompareValidator>
                                    <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="ddcEndDate"  ErrorMessage="<%$ Resources:Default, REQUIRED_END_DATE %>" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator>
                                    &nbsp;
                        </td>
                    </tr>
                        <tr>
                            <td class="DescLeft">
                                <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Default, REPORT_TYPE %>"></asp:Label></td>
                           <td class="NormalField">
                                <asp:RadioButtonList ID="rblReportType" runat="server" meta:resourcekey="rblReportTypeResource1"
                                    RepeatLayout="Flow" Width="100%">
                                    <asp:ListItem meta:resourceKey="ListItemResource1" Selected="True" Value="0">All Projects</asp:ListItem>
                                    <asp:ListItem meta:resourceKey="ListItemResource2" Value="1">Projects by Month (Current Year)</asp:ListItem>
                                    <asp:ListItem meta:resourceKey="ListItemResource3" Value="2">Projects by Trimester (Current Year)</asp:ListItem>
                                    <asp:ListItem Value="3">Savings Chart</asp:ListItem>
                                    <asp:ListItem Value="4">Download PowerPoint File</asp:ListItem>
                                </asp:RadioButtonList></td>
                        </tr>
                        <tr>
                            <td colspan="2" class="Footer" style="height:25px"><asp:LinkButton id="lnkGenerateReports" runat="server" OnClick="LinkButton1_Click" Text="<%$ Resources:Default, GENERATE_REPORT %>"></asp:LinkButton></td>
                        </tr>
                    </table>                    
                </div>                    
        </asp:View>
        <asp:View ID="viReport" runat="server">
            <asp:LinkButton ID="lnkBack" runat="server" OnClick="lnkBack_Back" Text="<%$ Resources:Default, BACK %>"></asp:LinkButton><br />
            <microsoft:ReportViewer ID="rvProjects"  runat="server" Height="420px" Width="100%" Parameters="false" ServerUrl="http://saont016/reportserver" />                
        </asp:View>
    </asp:MultiView>&nbsp;&nbsp;&nbsp;

</asp:Content>
