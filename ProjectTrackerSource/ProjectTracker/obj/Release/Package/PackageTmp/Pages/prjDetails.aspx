<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/MasterPage.Master" CodeBehind="prjDetails.aspx.cs" Inherits="ProjectTracker.Pages.prjDetails" %>
<%@ Register Src="../Common/DropDownCalendar.ascx" TagName="DropDownCalendar" TagPrefix="uc5" %>

<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc2" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc3" %>
<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons"
    TagPrefix="uc4" %>
<%@ Register Assembly="ProjectTracker" Namespace="ProjectTracker.Common" TagPrefix="cc1" %>
<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<%@ Register    
    Assembly="AjaxControlToolkit"
    Namespace="AjaxControlToolkit"
    TagPrefix="ajaxToolkit" %>
    
<asp:Content ID="content1" runat="server" ContentPlaceHolderID="MainContent">
    <br />
    <br />
    <div style="text-align:center"> <asp:Label runat="server" ID="Title" SkinID="Title" Text='<%$ Resources:Default, DETAIL_PROJECT %>' ></asp:Label>&nbsp;<br />
        <br />
    </div>
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="Code,StatusCode,Username,CustomerCode,LocationCode"
        DataSourceID="obsProject" DefaultMode="Edit" OnDataBound="FormView1_DataBound"
        OnItemUpdating="FormView1_ItemUpdating">
        <EditItemTemplate>
            <table cellpadding="2" cellspacing="0" class="FormView">
                <tr>
                    <td class="Header" colspan="4" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: right;">
                        &nbsp;<span style="color: #ff0000">* - Required Fileds</span></td>
                </tr>
                <tr>
                    <td class="Header" style="width: 150px; border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: left;
                        width: 210px;">
                        &nbsp;<asp:Label ID="Label25" runat="server" Text='<%# Eval("CategoryDescription") %>'></asp:Label></td>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label32" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; width: 350px;">
                        &nbsp;<asp:Label ID="Label27" runat="server" Text='<%# Eval("CategoryDescription") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label></td>
                    <td class="NormalField" colspan="3" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:TextBox ID="TextBox2" runat="server" MaxLength="170" Text='<%# Bind("Description") %>'
                            Width="650px"></asp:TextBox>&nbsp;</td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: left;
                        width: 210px;">
                        &nbsp;<asp:Label ID="Label26" runat="server" Text='<%# Eval("CategoryDescription") %>'></asp:Label></td>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; vertical-align: top;">
                        <asp:Panel ID="pnlCollapsedCoResp" runat="server" CssClass="collapsePanelHeader"
                            Width="100%">
                            <asp:Label ID="Label38" runat="server" Text="<%$ Resources:Default, CO_RESPONSIBLE %>"></asp:Label>
                            &nbsp;<asp:Image ID="Image1" runat="server" AlternateText="ASP.NET AJAX" ImageAlign="Right"
                                ImageUrl="~/images/down.gif" /></asp:Panel>
                    </td>
                    <td class="NormalField" style="text-align: center; border-right: #f8f7f7 1px solid;
                        border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;
                        vertical-align: top;">
                        <ajaxtoolkit:collapsiblepanelextender id="cpeCoResps" runat="server" collapsecontrolid="pnlCollapsedCoResp"
                            collapsed="True" collapsedimage="~/images/down.gif" collapsedtext="Edit Co-Responsibles"
                            expandcontrolid="pnlCollapsedCoResp" expandedimage="~/images/up.gif" expandedtext=""
                            imagecontrolid="Image1" suppresspostback="true" targetcontrolid="pnlHiddenCoResp"
                            textlabelid="Label1"></ajaxtoolkit:collapsiblepanelextender>
                        <asp:Panel ID="pnlHiddenCoResp" runat="server" Width="100%">
                            <table width="350">
                                <tr>
                                    <td class="NormalField" style="height: 20px">
                                        <asp:ListBox ID="lstCoRespsAvaiable" runat="server" DataSourceID="obsCoRespsNoProject"
                                            DataTextField="Name" DataValueField="Username" Font-Names="Verdana" Font-Size="8pt"
                                            OnDataBound="lstCoRespsAvaiable_DataBound" Width="100%"></asp:ListBox></td>
                                    <td class="NormalField" style="text-align: center; width: 20px; height: 20px;">
                                        <asp:ImageButton ID="btnMoveCoRespR" runat="server" ImageUrl="~/Images/Right.jpg"
                                            OnClick="btnMoveCoRespR_Click" ValidationGroup="moveToInsert" /><br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="lstCoRespsAvaiable"
                                            Display="Dynamic" ErrorMessage="Select a item" ValidationGroup="moveToInsert"></asp:RequiredFieldValidator><br />
                                        <br />
                                        <asp:ImageButton ID="btnMoveCoRespL" runat="server" ImageUrl="~/Images/left.jpg"
                                            OnClick="btnMoveCoRespL_Click" ValidationGroup="moveToAvaiable" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="lstCoRespsToInsert"
                                            Display="Dynamic" ErrorMessage="Select a item" ValidationGroup="moveToAvaiable"></asp:RequiredFieldValidator><br />
                                    </td>
                                    <td class="NormalField" style="text-align: right; height: 20px;">
                                        <asp:ListBox ID="lstCoRespsToInsert" runat="server" DataSourceID="obsCoRespsProject"
                                            DataTextField="PU_NAME" DataValueField="PU_USUARIO" Font-Names="Verdana" Font-Size="8pt"
                                            Width="100%"></asp:ListBox></td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: left">
                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: left;
                        width: 210px;">
                        &nbsp;</td>
                    <td class="Header" colspan="1" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: left">
                        <asp:Label ID="Label39" runat="server" Text="<%$ Resources:Default, REGION %>"></asp:Label></td>
                    <td class="NormalField" colspan="1" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; text-align: left">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; width: 210px;">
                        &nbsp;</td>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:Default, SEGMENT %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; height: 20px;">
                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label></td>
                    <td class="CalendarField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; height: 10px;
                        text-align: center; width: 210px;">
                        &nbsp;
                    </td>
                    <td id="Td1" class="Header" style="width: 150px; border-right: #f8f7f7 1px solid;
                        border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;
                        height: 20px;">
                        <asp:Label ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label></td>
                    <td class="NormalField" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; height: 20px;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                    <td class="NormalField" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; width: 210px;">
                        &nbsp;&nbsp;
                    </td>
                    <td id="Td2" class="Header" colspan="1" style="border-right: #f8f7f7 1px solid;
                        border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label></td>
                    <td id="Td3" class="CalendarField" colspan="1" style="border-right: #f8f7f7 1px solid;
                        border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="Header" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label></td>
                    <td class="NormalField" colspan="3" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:TextBox ID="txtRemarks" runat="server" Height="100px" Style="width: 100%" Text='<%# Bind("Remarks") %>'
                            TextMode="MultiLine"></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="Footer" colspan="4" style="width: 100%; border-right: #f8f7f7 1px solid;
                        border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <div>
                            <asp:ImageButton ID="ImageButton2" runat="server" CommandName="Update" ImageUrl="~/Images/Save.jpg" />
                            <asp:ImageButton ID="btnPrevious" runat="server" CausesValidation="False" ImageUrl="~/Images/Previous.jpg"
                                OnClick="imgPrevious_Click" /></div>
                    </td>
                </tr>
            </table>
        </EditItemTemplate>
        <ItemTemplate>
            <table cellpadding="2" cellspacing="0" class="FormView">
                <tr>
                    <td class="Header" colspan="4" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid; font-size: 6pt;
                        height: 10px;">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label></td>
                    <td nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label></td>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label></td>
                    <td style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid;
                        border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("PA_DESCRICAO") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label></td>
                    <td colspan="3" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Description") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                    <td colspan="3" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("PC_DESCRICAO") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label></td>
                    <td colspan="2" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                        -
                        <asp:Label ID="Label14" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                    <td nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("PL_DESCRICAO") %>'></asp:Label></td>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label></td>
                    <td style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid;
                        border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("OpenDate", "{0:d}") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label></td>
                    <td nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:Label></td>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label></td>
                    <td style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid;
                        border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label9" runat="server" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                    <td nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("PS_DESCRICAO") %>'></asp:Label></td>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"
                            Width="160px"></asp:Label></td>
                    <td style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid;
                        border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label11" runat="server" OnDataBinding="Label11_DataBinding" Text='<%# Bind("CostSaving") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Header" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                        <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label></td>
                    <td colspan="3" nowrap="nowrap" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid;
                        border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td class="Footer" colspan="4" nowrap="nowrap" style="width: 100%; border-right: #f8f7f7 1px solid;
                        border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <uc4:itemtemplatebuttons id="ItemTemplateButtons1" runat="server">
</uc4:itemtemplatebuttons>
                    </td>
                </tr>
            </table>
        </ItemTemplate>
        <EmptyDataTemplate>
            <table class="FormView">
                <tr>
                    <td class="Footer">
                        <asp:Label ID="Label33" runat="server" Text="<%$ Resources:Default, INSERT_NEW_PROJECT&#9; %>"></asp:Label></td>
                </tr>
                <tr>
                    <td class="Footer" style="height: 20px">
                        <asp:ImageButton ID="ImageButton1" runat="server" CommandName="New" ImageUrl="~/Images/Add.jpg" /></td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:FormView>
    <br />
    <asp:ObjectDataSource ID="obsProject" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByDescription" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ProjectsTableAdapter">
        <SelectParameters>
            <asp:Parameter DefaultValue="%" Name="PJ_DESCRIPTION" Type="String" />
            <asp:Parameter DefaultValue="%" Name="PU_USUARIO" Type="String" />
            <asp:Parameter DefaultValue="%" Name="PA_CODIGO" Type="String" />
            <asp:Parameter DefaultValue="%" Name="PS_CODIGO" Type="String" />
            <asp:Parameter DefaultValue="%" Name="PC_CODIGO" Type="String" />
            <asp:Parameter DefaultValue="%" Name="PL_CODIGO" Type="String" />
            <asp:QueryStringParameter DefaultValue="" Name="PJ_CODIGO" QueryStringField="projectId"
                Type="String" />
            <asp:Parameter DefaultValue="%" Name="PRE_CODIGO" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
