<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ProjectTeste.aspx.cs" Inherits="ProjectTracker.Pages.ProjectTeste"  %>


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

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <input type="hidden" id="hddOldIdDivOld" />
    <ajax:ScriptManager ID="scriptManager1" runat="server" EnableScriptGlobalization="true" AllowCustomErrorsRedirect="false" />
    <script language="javascript" type="text/javascript">
        function VerifyKeyPress(obj, max)
        {
            if (obj.value.length == max) 
            {
                event.returnValue = false; 
            } 
        } 

        function VerifyKeyUp(obj, max) 
        { 
            if (obj.value.length > max) 
            {
                obj.value = obj.value.substr(0,max); 
            } 
        }
        
        function ChangeColor(idTextbox)
        {
            
            var textBox = document.getElementById(idTextbox);
            var cellToChange = document.getElementById("tdCostSaving");
            var cellToChange1 = document.getElementById("tdClosedDate");
            
            if(cellToChange !=null && cellToChange!=undefined && cellToChange1 !=null && cellToChange1!=undefined && textBox !=null && textBox!=undefined)
            {
                if(textBox.disabled == false)
                {
                   
                    cellToChange.style.backgroundColor = "#FFFFCC";
                    cellToChange1.style.backgroundColor = "#FFFFCC";
                }
            }
            
            
            
        }
        function VisibleDiv(divName)
        {           
            hddOldIdDivOld2 = document.getElementById('hddOldIdDivOld')
            
            divOldName = hddOldIdDivOld2.value;
            hddOldIdDivOld2.value=divName;
                     
            if(divOldName != '')
            {      
                divOld = document.getElementById(divOldName);            
                divOld.style.display = 'none';
            }
            
            div = document.getElementById(divName);
            div.style.display = 'block';
            return false;
        }
        
        function HiddenDiv(divName)
        {

            div = document.getElementById(divName);
             div.style.display = 'none';
            return false;
        }
        
        function OpenAttachments(projectCode)
        {   
                link = 'Attachments.aspx?ProjectCode=' + projectCode;
                var win1 = window.open(link, 'AttachFile', 'status=yes,toolbar=no,menubar=no,scrollbars=no,location=no,replace=yes,resizable=yes,width=580,height=370');
                win1.focus();
                return false;
        }
        
        function hidden()
        {            
            element = document.getElementById('pnlShowed');            
            content1 = document.getElementById('content');
                      
                        
            if(element.style.visibility == 'visible')
            {                
                    element.style.visibility = 'hidden';
                    element.style.height = 0;
                    content1.style.marginTop = 0;                    
               
            }                
            else         
            {             
                    element.style.visibility = 'visible'; 
                    element.style.height = 100;
                    content1.style.marginTop = 150;            
            }
            
        }
    </script>
    
    <div style="text-align:center">
        <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, TITLE_PROJECTS %>" SkinID="Title"/><br />
        <br />
        <ajax:UpdateProgress ID="updProgress" runat="server" DisplayAfter="0">
            <ProgressTemplate>
                <asp:Image ID="Image3" runat="server" ImageUrl="~/Images/waiting.gif" />
            </ProgressTemplate>
        </ajax:UpdateProgress>
        <br />
    <uc1:MessagePanel ID="MessagePanel1" runat="server" />
    </div>
    <asp:MultiView ID="mvViewers" runat="server" ActiveViewIndex="0">
        <asp:View ID="vwGrid" runat="server" OnActivate="vwGrid_Activate">
          <div style="width:100%;text-align:center;">
            <table style="width: 40%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="8" style="height:15px"><hr /></td>
                </tr>
                <tr>
                    <td style="height: 15px; background-color: #E3E3B5;" width="30"></td>
                    <td style="height: 15px; text-align: left" width="180">&nbsp;Open</td>
                    <td style="height: 15px; background-color: #B3C2F0" width="30"></td>
                    <td style="height: 15px; text-align: left" width="180">&nbsp;Closed</td>
                    <td style="height: 15px; text-align: right" width="180">Hold&nbsp;</td>
                    <td style="height: 15px; background-color: #FFE788" width="30"></td>
                    <td style="height: 15px; text-align: right" width="180">Dropped&nbsp;</td>
                    <td style="height: 15px; background-color: #B3E1C2" width="30"></td>
                </tr>
                <tr>
                    <td colspan="8" style="height:15px"><hr /></td>
                </tr>
            </table>
            </div>
            <br />
        <div onclick="hidden" id="pnlHiddened" style="width:100%;">                  
            <asp:Panel ID="pnlHidden" runat="server" CssClass="collapsePanelHeader" Height="20px"> 
                    <div style="padding:5px;cursor: pointer;text-align:right;background-color:#CECECE;width:100%">
                            <a href="javascript:hidden()" style="text-decoration:none;">  
                            <asp:Label ID="Label1" Text="<%$ Resources:Default, FILTER %>" runat="server"></asp:Label>                              
                            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/down.png" ImageAlign="Left" BorderWidth="0" /></a>  
                    </div>
                </asp:Panel>  
        </div>
        
        
        <div id="pnlShowed" style="text-align:center; visibility:hidden;width:100%;height:0px;position:absolute;float:left;">  
            <asp:Panel ID="Panel3" runat="server" CssClass="collapsePanel" Height="0">
               <table class="FormView" cellpadding="1" cellspacing="0"  border="0">
                        <tr>
                            <td class="DescLeft">Description</td>
                            <td colspan="3" class="NormalField"><asp:TextBox ID="txtDescription" runat="server" Width="633px"></asp:TextBox></td>
                        </tr>
            <tr>
                <td class="DescLeft"><asp:Label ID="lblFilterDis" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label></td>
                <td class="NormalField"><asp:DropDownList ID="drpResponsiblesS" runat="server" DataSourceID="obsResponsiblesS" DataTextField="Name" DataValueField="Username" OnDataBound="dropFilter" Width="200px">
                </asp:DropDownList><asp:ObjectDataSource ID="obsResponsiblesS" runat="server" DeleteMethod="Delete" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByFilter"
                            TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter"
                            UpdateMethod="Update">                
                </asp:ObjectDataSource>
                </td>
                <td class="DescLeft"><asp:Label ID="Label34" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label></td>
                <td class="NormalField"><asp:DropDownList ID="drpCategoriesS" runat="server" DataSourceID="obsCategoriesS"
                            DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter" Width="200px">
                    </asp:DropDownList>
                    <asp:ObjectDataSource
                                ID="obsCategoriesS" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CategoryTableAdapter"
                                UpdateMethod="Update">
                        <DeleteParameters>
                            <asp:Parameter Name="Original_PA_CODIGO" Type="Int32" />
                        </DeleteParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:Parameter Name="Original_PA_CODIGO" Type="Int32" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:Parameter Name="Description" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                        </InsertParameters>
                    </asp:ObjectDataSource>
                </td>
            </tr>
                        <tr>
                            <td class="DescLeft"><asp:Label ID="Label36" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                            <td class="NormalField">
                                <asp:DropDownList ID="drpStatusCodeS" runat="server" DataSourceID="obsStatusS"
                            DataTextField="PS_DESCRICAO" DataValueField="PS_CODIGO" OnDataBound="dropFilter" Width="200px">
                                </asp:DropDownList><asp:ObjectDataSource ID="obsStatusS" runat="server" DeleteMethod="Delete"
                            InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                            TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.StatusTableAdapter"
                            UpdateMethod="Update">
                                    <DeleteParameters>
                                        <asp:Parameter Name="Original_PS_CODIGO" Type="Int32" />
                                    </DeleteParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="PS_DESCRICAO" Type="String" />
                                        <asp:Parameter Name="PS_ATIVO" Type="Boolean" />
                                        <asp:Parameter Name="Original_PS_CODIGO" Type="Int32" />
                                    </UpdateParameters>
                                    <InsertParameters>
                                        <asp:Parameter Name="PS_DESCRICAO" Type="String" />
                                        <asp:Parameter Name="PS_ATIVO" Type="Boolean" />
                                    </InsertParameters>
                                </asp:ObjectDataSource>
                            </td>
                            <td class="DescLeft"><asp:Label ID="Label35" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                            <td class="NormalField">
                                <asp:DropDownList ID="drpLocationsS" runat="server" DataSourceID="obsLocationsS"
                            DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter">
                                </asp:DropDownList>
                                <asp:ObjectDataSource ID="obsLocationsS" runat="server" DeleteMethod="Delete"
                            InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                            TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.LocationTableAdapter"
                            UpdateMethod="Update">
                                    <DeleteParameters>
                                        <asp:Parameter Name="Original_PL_CODIGO" Type="Int32" />
                                    </DeleteParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="Description" Type="String" />
                                        <asp:Parameter Name="Active" Type="Boolean" />
                                        <asp:Parameter Name="Original_PL_CODIGO" Type="Int32" />
                                    </UpdateParameters>
                                    <InsertParameters>
                                        <asp:Parameter Name="Description" Type="String" />
                                        <asp:Parameter Name="Active" Type="Boolean" />
                                    </InsertParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="DescLeft"><asp:Label ID="Label37" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                            <td class="NormalField">
                                <asp:DropDownList ID="drpCustomersS" runat="server" DataSourceID="obsCCustomersS"
                            DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter" Width="200px">
                                </asp:DropDownList><asp:ObjectDataSource
                                ID="obsCCustomersS" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                                OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CustomerTableAdapter"
                                UpdateMethod="Update">
                                    <DeleteParameters>
                                        <asp:Parameter Name="Original_PC_CODIGO" Type="Int32" />
                                    </DeleteParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="Description" Type="String" />
                                        <asp:Parameter Name="Active" Type="Boolean" />
                                        <asp:Parameter Name="Original_PC_CODIGO" Type="Int32" />
                                    </UpdateParameters>
                                    <InsertParameters>
                                        <asp:Parameter Name="Description" Type="String" />
                                        <asp:Parameter Name="Active" Type="Boolean" />
                                    </InsertParameters>
                                </asp:ObjectDataSource>
                            </td>
                            <td class="DescLeft"><asp:Label ID="Label27" runat="server" Text="<%$ Resources:Default, REGION %>"></asp:Label></td>
                            <td class="NormalField"><asp:DropDownList ID="drpRegionS" runat="server" DataSourceID="obsRegionS"
                            DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter" Width="200px">
                                </asp:DropDownList><asp:ObjectDataSource ID="obsRegionS" runat="server"
                            InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData"
                            TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.RegionsTableAdapter">
                                    <InsertParameters>
                                        <asp:Parameter Name="PRE_DESCRICAO" Type="String" />
                                        <asp:Parameter Name="PRE_ATIVO" Type="Boolean" />
                                    </InsertParameters>
                                </asp:ObjectDataSource>
                            </td>
                        </tr>
                        <tr>
                            <td class="Footer" colspan="4" style="height:25px">
                                <asp:LinkButton ID="LinkButton2" runat="server" Text="<%$ Resources:Default, SEARCH_PROJECT %>"></asp:LinkButton>&nbsp;
                                <asp:LinkButton ID="LinkButton3" runat="server" Text="<%$ Resources:Default, GET_ALL %>"></asp:LinkButton></td>
                        </tr>
                        </table>
                    </asp:Panel>
                </div>
                <div id="content"></div>
        
        
            <br />
           
    <asp:GridView ID="gvProjects" runat="server" AutoGenerateColumns="False" DataSourceID="obsProjects" DataKeyNames="Code,StatusCode,Username,CustomerCode,LocationCode,Description,CategoryCode,RegionCode" OnSelectedIndexChanged="gvProjects_SelectedIndexChanged" OnRowDataBound="gvProjects_RowDataBound" SkinID="GridViewMorePagging" OnRowDeleting="gvProjects_RowDeleting" OnRowCommand="gvProjects_RowCommand" AllowSorting="True" OnSorted="gvProjects_Sorted" OnSorting="gvProjects_Sorting">
        <Columns>
            <asp:TemplateField ShowHeader="False">
                <ItemStyle HorizontalAlign="Center" Width="50px" />
                <ItemTemplate>
                    <div id='<%# Eval("Code", "divProject{0}") %>' style="margin-left:130px; position:absolute;width:900px;text-align:left;height:40px;display:none; left: 1px;" >
                        <table class="FormView_Div" cellpadding="1" cellspacing="0" bgcolor="#ffffff" width="500" border=0>
                            <tr>
                                <td class="Header" colspan="4" style="text-align:right;">
                                &nbsp;</td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label></td>
                                <td nowrap>&nbsp;<asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label></td>
                                <td nowrap class="Header"><asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label></td>
                                <td>&nbsp;<asp:Label ID="Label2" runat="server" Text='<%# Eval("CategoryDescription") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label></td>
                                <td nowrap colspan="3">&nbsp;<asp:Label ID="Label3" runat="server" Text='<%# Bind("Description") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                                <td colspan="3">&nbsp;<asp:Label ID="Label5" runat="server" Text='<%# Eval("CustomerName") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label></td>
                                <td colspan="3" nowrap>&nbsp;<asp:Label ID="Label4" runat="server" Text='<%# Eval("Name") %>'></asp:Label>-<asp:Label ID="Label14" runat="server" Text='<%# Eval("Username") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                                <td nowrap width="200">&nbsp;<asp:Label ID="Label6" runat="server" Text='<%# Eval("LocationDescription") %>'></asp:Label></td>
                                <td nowrap class="Header"><asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label></td>
                                <td width="170">&nbsp;<asp:Label ID="Label7" runat="server" Text='<%# Bind("OpenDate", "{0:d}") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label></td>
                                <td nowrap>&nbsp;<asp:Label ID="Label8" runat="server" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:Label></td>
                                <td nowrap class="Header"><asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label></td>
                                <td>&nbsp;<asp:Label ID="Label9" runat="server" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:Label></td>
                            </tr>
                            <tr>                               
                                <td nowrap class="Header"><asp:Label Width="160px" ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label></td>
                                <td>&nbsp;<asp:Label  ID="Label11" runat="server" Text='<%# Bind("CostSaving") %>' OnDataBinding="Label11_DataBinding"></asp:Label></td>
                                <td class="DescLeft" colspan="1">
                                    <asp:Label ID="Label46" runat="server" Text="eRoom Report#"></asp:Label></td>
                                <td colspan="1">&nbsp;
                                    <asp:Label ID="Label47" runat="server" Text='<%# Bind("eRoom", "{0:d}") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Header"><asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label></td>
                                <td colspan="3">&nbsp;<asp:Label ID="Label12" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label></td>
                            </tr>
                            <tr>
                                <td nowrap class="Footer" colspan="4">
                                    <a style="cursor:hand;font-family:Arial Black;color:red;" onclick="<%# Eval("Code", "HiddenDiv('divProject{0}')") %>"><img src="../images/btnClose.jpg" alt="Close the Screen"/></a>
                                    &nbsp;</td>
                            </tr>
                        </table>
                    </div>                    
                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                        Text="Edit" Visible='<%# Eval("CanDelete") %>'></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Code" HeaderText="Code" InsertVisible="False" ReadOnly="True"
                SortExpression="Code" />
            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:TemplateField HeaderText="OpenDate" SortExpression="OpenDate">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("OpenDate") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label10" runat="server" Text='<%# Bind("OpenDate", "{0:d}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="ClosedDate" SortExpression="ClosedDate">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("ClosedDate") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label13" runat="server" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="CommitDate" SortExpression="CommitDate">
                <EditItemTemplate>
                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("CommitDate") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label22" runat="server" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <HeaderTemplate>
                    <asp:Label ID="Label31" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label>
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label30" runat="server" Text='<%# Eval("PS_DESCRICAO") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:ImageButton ID="ImageButton3" runat="server" CommandName="Delete" ImageUrl="~/Images/delete.gif" Visible='<%# Eval("CanDelete") %>' AlternateText="Delete the Project" />
                </ItemTemplate>
                <ItemStyle Width="18px"/>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <a href="#" onclick='<%# Eval("Code", "OpenAttachments({0})") %>'><img src="../images/btn_16x16_attach.gif" border="0" alt="Edit Attachs" AlternateText="Edit/Add Attaches"/></a>
                </ItemTemplate>
                <ItemStyle Width="18px"/>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <%--<a href="#" onmouseenter="<%# Eval("Code", "VisibleDiv('divProject{0}')") %>" onmouseleave="<%# Eval("Code", "HiddenDiv('divProject{0}')") %>">Details</a> --%>
                    <a style="cursor:hand;" OnClick="<%# Eval("Code", "javascript:VisibleDiv('divProject{0}');") %>"><asp:Image ID="Image2" runat="server" BorderWidth="0px" ImageUrl="~/Images/list.gif" AlternateText="See the Details"/></a> 
                </ItemTemplate>
                <ItemStyle Width="18px"/>
            </asp:TemplateField>
        </Columns>
        
        <PagerStyle HorizontalAlign="Justify" />
    </asp:GridView>
        
        </asp:View>
        <asp:View ID="vwForm" runat="server" OnActivate="vwForm_Activate">
        <asp:FormView ID="FormView1" runat="server" DataSourceID="obsProjects" OnDataBound="FormView1_DataBound" DefaultMode="Edit" DataKeyNames="Code,StatusCode,Username,CustomerCode,LocationCode" OnItemUpdating="FormView1_ItemUpdating">
        
        
        
        <EditItemTemplate>
            <table cellpadding="1" cellspacing="0" class="FormView" border="0">
                <tr>
                    <td colspan="4" style="text-align: right" class="Header" ><asp:Label ID="Label8" runat="server" CssClass="warning" Text="* - Required Fields" ForeColor="#B51E17"></asp:Label></td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        <asp:Label ID="Label25" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="drpRegion" ErrorMessage="Region is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label39" runat="server" Text="<%$ Resources:Default, REGION %>"></asp:Label></td>
                    <td class="NormalField">
                        <ajax:UpdatePanel ID="updRegion" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:DropDownList ID="drpRegion" runat="server" DataSourceID="obsRegion"
                        DataTextField="RegionDescription" DataValueField="RegionCode" OnDataBound="drpRegion_DataBound" AutoPostBack="True"  Width="200px" OnSelectedIndexChanged="drpRegion_SelectedIndexChanged">
                        </asp:DropDownList><asp:ObjectDataSource ID="obsRegion" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByUsername"
                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UserRegionsTableAdapter" DeleteMethod="Delete" OnSelecting="obsRegion_Selecting">
                            <DeleteParameters>
                                <asp:Parameter Name="Username" Type="String" />
                                <asp:Parameter Name="RegionCode" Type="Int32" />
                            </DeleteParameters>
                            <SelectParameters>
                                <asp:Parameter Name="PU_USUARIO" Type="String" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                            </ContentTemplate>
                            <Triggers>
                                <ajax:AsyncPostBackTrigger ControlID="drpRegion" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </ajax:UpdatePanel>
                    </td>
                    <td class="DescLeft">
                        <asp:Label ID="Label28" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="drpCategories" ErrorMessage="Category is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label>
                    </td>
                    <td class="NormalField"><asp:DropDownList ID="drpCategories" runat="server" DataSourceID="obsCategories" DataTextField="Description" DataValueField="Code" OnDataBound="drpCategories_DataBound" Width="200px">
                        </asp:DropDownList><asp:ObjectDataSource
                            ID="obsCategories" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                            OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CategoryTableAdapter"
                            UpdateMethod="Update">
                                <DeleteParameters>
                                    <asp:Parameter Name="Original_PA_CODIGO" Type="Int32" />
                                </DeleteParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="Description" Type="String" />
                                    <asp:Parameter Name="Active" Type="Boolean" />
                                    <asp:Parameter Name="Original_PA_CODIGO" Type="Int32" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:Parameter Name="Description" Type="String" />
                                    <asp:Parameter Name="Active" Type="Boolean" />
                                </InsertParameters>
                            </asp:ObjectDataSource>
                        </td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        <asp:Label ID="Label26" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="rqdDescription" runat="server" ControlToValidate="TextBox2" ErrorMessage="Description is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label></td>
                    <td colspan="3" class="NormalField"><asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Description") %>' MaxLength="170" Width="650px"></asp:TextBox>&nbsp;</td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        <asp:Label ID="Label29" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="drpResponsibles" ErrorMessage="Responsible is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label></td>
                    <td class="NormalField" >
                        <asp:Label ID="lblUsername" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                        <ajax:UpdatePanel ID="updResp" runat="server" UpdateMode="Conditional" Visible="False">
                            <ContentTemplate>
                                <asp:DropDownList ID="drpResponsibles" runat="server" DataSourceID="obsResponsibles" DataTextField="Name" DataValueField="Username" OnDataBound="drpResponsibles_DataBound" AutoPostBack="True" OnSelectedIndexChanged="drpResponsibles_SelectedIndexChanged" Width="200px" Enabled="False"> </asp:DropDownList><asp:ObjectDataSource ID="obsResponsibles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByRegion" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
                            <DeleteParameters>
                                <asp:Parameter Name="Username" Type="String" />
                            </DeleteParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Active" Type="Boolean" />
                                <asp:Parameter Name="Username" Type="String" />
                            </UpdateParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="drpRegion" Name="PRE_CODIGO" PropertyName="SelectedValue"
                                    Type="Int32" />
                            </SelectParameters>
                            <InsertParameters>
                                <asp:Parameter Name="Username" Type="String" />
                                <asp:Parameter Name="Active" Type="Boolean" />
                            </InsertParameters>
                        </asp:ObjectDataSource>
                            </ContentTemplate>
                            <Triggers>
                                <ajax:AsyncPostBackTrigger ControlID="drpResponsibles" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </ajax:UpdatePanel>
                        </td>
                    <td class="DescLeft" nowrap >
                        <asp:Panel ID="pnlCollapsedCoResp" runat="server" CssClass="collapsePanelHeader" Width="100%">
                            &nbsp; &nbsp;
                            <asp:Label ID="Label38" runat="server" Text="<%$ Resources:Default, CO_RESPONSIBLE %>"></asp:Label> &nbsp;<asp:Image ID="Image1" runat="server" ImageUrl="~/images/down.png"
                            AlternateText="ASP.NET AJAX" ImageAlign="Right" /></asp:Panel>
                        </td>
                    <td class="NormalField"><ajax:UpdatePanel ID="updCoResp" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                        <ajaxToolkit:CollapsiblePanelExtender ID="cpeCoResps" runat="server" 
                                TargetControlID="pnlHiddenCoResp"
                                ExpandControlID="pnlCollapsedCoResp"
                                CollapseControlID="pnlCollapsedCoResp" 
                                Collapsed="True"
                                TextLabelID="Label1"
                                ExpandedText=""
                                CollapsedText="Edit Co-Responsibles"
                                ImageControlID="Image1"
                                ExpandedImage="~/images/up.png"
                                CollapsedImage="~/images/down.png"
                                SuppressPostBack="true" />
                        <asp:Panel ID="pnlHiddenCoResp" runat="server" Width="100%">
                            <table width="350" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="NormalField" width="150">
                                        <asp:ListBox ID="lstCoRespsAvaiable" runat="server" DataSourceID="obsCoRespsNoProject" DataTextField="Name" DataValueField="Username" OnDataBound="lstCoRespsAvaiable_DataBound" Font-Names="Verdana" Font-Size="8pt"  Width="150px"></asp:ListBox></td>
                                    <td align="center" valign="middle" width="30">
                                        <asp:ImageButton ID="btnMoveCoRespR" runat="server" ImageUrl="~/Images/Right.jpg" OnClick="btnMoveCoRespR_Click" ValidationGroup="moveToInsert" /><br />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="lstCoRespsAvaiable"
                                            Display="Dynamic" ErrorMessage="Select a item" ValidationGroup="moveToInsert" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                        <br />
                                        <asp:ImageButton ID="btnMoveCoRespL" runat="server" ImageUrl="~/Images/left.jpg" OnClick="btnMoveCoRespL_Click" ValidationGroup="moveToAvaiable" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="lstCoRespsToInsert"
                                            Display="Dynamic" ErrorMessage="Select a item" ValidationGroup="moveToAvaiable" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                        </td>
                                    <td>
                                        <asp:ListBox ID="lstCoRespsToInsert" runat="server" DataSourceID="obsCoRespsProject" DataTextField="PU_NAME" DataValueField="PU_USUARIO" Font-Names="Verdana" Font-Size="8pt"  Width="150px"></asp:ListBox></td>
                                </tr>
                            </table>
                        </asp:Panel>
                            </ContentTemplate>
                            <Triggers>
                                <ajax:AsyncPostBackTrigger ControlID="btnMoveCoRespL" EventName="Click" />
                                <ajax:AsyncPostBackTrigger ControlID="btnMoveCoRespR" EventName="Click" />
                            </Triggers>
                        </ajax:UpdatePanel>
                        
                    </td>
                </tr>
                <tr>
                    <td class="DescLeft" >
                        <asp:Label ID="Label41" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="drpLocations" ErrorMessage="Location is required." CssClass="warning" ForeColor="" SetFocusOnError="True" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label32" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                    <td class="NormalField" >
                        <ajax:UpdatePanel ID="updDropLocation" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:DropDownList ID="drpLocations" runat="server" DataSourceID="obsLocations"
                        DataTextField="Description" DataValueField="Code" OnDataBound="drpLocation_DataBound" AutoPostBack="True" OnSelectedIndexChanged="drpLocations_SelectedIndexChanged">
                        </asp:DropDownList><asp:ObjectDataSource ID="obsLocations" runat="server" DeleteMethod="Delete" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.LocationTableAdapter" InsertMethod="Insert" UpdateMethod="Update">
                            <DeleteParameters>
                                <asp:Parameter Name="Original_PL_CODIGO" Type="Int32" />
                            </DeleteParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="Description" Type="String" />
                                <asp:Parameter Name="Active" Type="Boolean" />
                                <asp:Parameter Name="SiteCode" Type="String" />
                                <asp:Parameter Name="CountryCode" Type="String" />
                                <asp:Parameter Name="Code" Type="Int32" />
                            </UpdateParameters>
                            <InsertParameters>
                                <asp:Parameter Name="Description" Type="String" />
                                <asp:Parameter Name="Active" Type="Boolean" />
                                <asp:Parameter Name="SiteCode" Type="String" />
                                <asp:Parameter Name="CountryCode" Type="String" />
                            </InsertParameters>
                        </asp:ObjectDataSource>
                            </ContentTemplate>
                            <Triggers>
                                <ajax:AsyncPostBackTrigger ControlID="drpLocations" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </ajax:UpdatePanel>
                    </td>
                    <td class="DescLeft" >
                    <asp:Panel ID="Panel1" runat="server" CssClass="collapsePanelHeader" Width="100%">
                        &nbsp; &nbsp;
                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:Default, CO_LOCATIONS %>"></asp:Label>
                            <asp:Image ID="Image2" runat="server" AlternateText="ASP.NET AJAX" ImageAlign="Right" ImageUrl="~/images/down.png" /></asp:Panel></td>
                    <td class="NormalField">
                        <asp:Panel ID="pnlHiddenCoLocations" runat="server" Width="100%">
                            <ajaxToolkit:CollapsiblePanelExtender ID="cpeCoLocations" runat="server" CollapseControlID="Panel1"
                                Collapsed="True" CollapsedImage="~/images/down.png" CollapsedText="Edit Co-Responsibles"
                                ExpandControlID="Panel1" ExpandedImage="~/images/up.png" ExpandedText="" ImageControlID="Image2"
                                SuppressPostBack="true" TargetControlID="pnlHiddenCoLocations">
                            </ajaxToolkit:CollapsiblePanelExtender>
                         <ajax:UpdatePanel ID="updLstLocations" runat="server" UpdateMode="Conditional">
                             <ContentTemplate>
                            <table width="350" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td class="NormalField" width="150">
                                        <asp:ListBox ID="lstCoLocationsAvaiable" runat="server" DataSourceID="obsLocations"
                                            DataTextField="Description" DataValueField="Code" Font-Names="Verdana"
                                            Font-Size="8pt" Width="150px"></asp:ListBox></td>
                                    <td align="center" valign="middle" width="30">
                                        <asp:ImageButton ID="btnMoveToInsertLoc" runat="server" ImageUrl="~/Images/Right.jpg"
                                            OnClick="btnMoveToInsertLoc_Click" ValidationGroup="moveToInsertLocation" /><asp:RequiredFieldValidator
                                                ID="RequiredFieldValidator10" runat="server" ControlToValidate="lstCoLocationsAvaiable"
                                                Display="Dynamic" ErrorMessage="Select a item" ValidationGroup="moveToInsertLocation" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                        <br />
                                        <asp:ImageButton ID="btnRemoveLocationProject" runat="server" ImageUrl="~/Images/left.jpg"
                                            OnClick="btnRemoveLocationProject_Click" ValidationGroup="moveToAvaiableLocation" />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="lstCoLocationsToInsert"
                                            Display="Dynamic" ErrorMessage="Select a item" ValidationGroup="moveToAvaiableLocation" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />
                                    </td>
                                    <td>
                                        <asp:ListBox ID="lstCoLocationsToInsert" runat="server" DataSourceID="ObjectDataSource1"
                                            DataTextField="LocationDescription" DataValueField="LocationCode" Font-Names="Verdana"
                                            Font-Size="8pt" Width="150px"></asp:ListBox></td>
                                </tr>
                            </table>
                             </ContentTemplate>
                             <Triggers>
                                 <ajax:AsyncPostBackTrigger ControlID="btnRemoveLocationProject" EventName="Click" />
                                 <ajax:AsyncPostBackTrigger ControlID="btnMoveToInsertLoc" EventName="Click" />
                             </Triggers>
                         </ajax:UpdatePanel>
                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="Delete"
                            InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataProjectLocationsByProjectCode"
                            TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ProjectLocationTableAdapter"
                            UpdateMethod="Update">
                            <DeleteParameters>
                                <asp:Parameter Name="Original_PJ_CODIGO" Type="Int32" />
                                <asp:Parameter Name="Original_PL_CODIGO" Type="Int32" />
                            </DeleteParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="PJ_CODIGO" Type="Int32" />
                                <asp:Parameter Name="PL_CODIGO" Type="Int32" />
                                <asp:Parameter Name="Original_PJ_CODIGO" Type="Int32" />
                                <asp:Parameter Name="Original_PL_CODIGO" Type="Int32" />
                            </UpdateParameters>
                            <SelectParameters>
                                <asp:ControlParameter ControlID="gvProjects" Name="ProjectCode" PropertyName="SelectedDataKey[0]"
                                    Type="Int32" />
                            </SelectParameters>
                            <InsertParameters>
                                <asp:Parameter Name="PJ_CODIGO" Type="Int32" />
                                <asp:Parameter Name="PL_CODIGO" Type="Int32" />
                            </InsertParameters>
                        </asp:ObjectDataSource>
                        </asp:Panel></td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        <asp:Label ID="Label42" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="drpCustomers" ErrorMessage="Customer is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator> <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                    <td class="NormalField" colspan="3"><asp:DropDownList ID="drpCustomers" runat="server" DataSourceID="obsCCustomers"
                        DataTextField="Description" DataValueField="Code" OnDataBound="drpCustomers_DataBound" Width="200px">
                        </asp:DropDownList><asp:ObjectDataSource
                            ID="obsCCustomers" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                            OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CustomerTableAdapter"
                            UpdateMethod="Update">
                                <DeleteParameters>
                                    <asp:Parameter Name="Original_PC_CODIGO" Type="Int32" />
                                </DeleteParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="Description" Type="String" />
                                    <asp:Parameter Name="Active" Type="Boolean" />
                                    <asp:Parameter Name="Original_PC_CODIGO" Type="Int32" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:Parameter Name="Description" Type="String" />
                                    <asp:Parameter Name="Active" Type="Boolean" />
                                </InsertParameters>
                            </asp:ObjectDataSource>
                        &nbsp;&nbsp;</td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        &nbsp; &nbsp;<asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label></td>
                    <td class="NormalField"><cc1:ActualDateTextBox Font-Family="Arial" Font-Size="8pt" ID="txtOpenDate" runat="server" Enabled="False" Text='<%# Bind("OpenDate", "{0:d}") %>' ReadOnly="True" BorderColor="Silver" BorderWidth="1px" Font-Names="Verdana" SkinID="ActualDate" Width="83px"></cc1:ActualDateTextBox></td>
                    <td class="DescLeft">
                        &nbsp;<asp:Label ID="Label43" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="drpSegment" ErrorMessage="Segment is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:Default, SEGMENT %>"></asp:Label></td>
                    <td class="NormalField"><asp:DropDownList ID="drpSegment" runat="server" DataSourceID="obsSegment" DataTextField="Description" DataValueField="Code" SelectedValue='<%# Bind("SegmentCode") %>' Width="200px">
                        </asp:DropDownList><asp:ObjectDataSource ID="obsSegment" runat="server" OldValuesParameterFormatString="original_{0}"
                            SelectMethod="GetDataByDrop" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SegmentTableAdapter">
                        </asp:ObjectDataSource>
                    </td>
                </tr>
                <tr >
                    <td class="DescLeft">
                        <asp:Label ID="Label44" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="rqdCommitDateValidator" runat="server" ControlToValidate="ddcCommitDate"
                            CssClass="warning" ErrorMessage="Commit Date is required." ForeColor="" SetFocusOnError="True" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label></td>
                    <td class="CalendarField"><uc5:DropDownCalendar ID="ddcCommitDate" runat="server" SelectedDateText='<%# Bind("CommitDate", "{0:d}") %>' /><asp:CompareValidator ID="compCommitOpen" Display="Dynamic" runat="server" ControlToCompare="txtOpenDate" ControlToValidate="ddcCommitDate" ErrorMessage="<%$ Resources:Default, DATA_INF_OPEN_DATE %>" Operator="GreaterThan" Type="Date" CssClass="warning" ForeColor="" CultureInvariantValues="True"></asp:CompareValidator></td>
                    <td nowrap class="DescLeft" id="Td1"><ajax:UpdatePanel ID="updCostSavingRqd" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                &nbsp;<asp:Label ID="lblDisplayRequiredCostSaving" runat="server" ForeColor="#C00000"
                                    Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="rqdCostSaving" runat="server" ControlToValidate="txtCostSaving" Enabled="False" ErrorMessage="Cost saving is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                            <asp:Label ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label>
                                </ContentTemplate>
                            </ajax:UpdatePanel>
                    </td>
                    <td nowrap class="NormalField">
                        <ajax:UpdatePanel ID="updCostSaving" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:TextBox ID="txtCostSaving" runat="server"  Text='<%# Bind("CostSaving","{0:F0}") %>' Width="83px" MaxLength="9"></asp:TextBox><asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCostSaving"
                            ErrorMessage="Only non fractional amounts or N/A." ValidationExpression="(N/A|[0-9]+[.][0-9][0-9]|[0-9]+)" CssClass="warning" ForeColor=""></asp:RegularExpressionValidator>
                            </ContentTemplate>
                        </ajax:UpdatePanel>
                        </td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        <asp:Label ID="Label45" runat="server" ForeColor="#C00000" Text="*"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="drpStatusCode" ErrorMessage="Status is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                    <td class="NormalField"><ajax:UpdatePanel ID="updStatus" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:DropDownList ID="drpStatusCode" runat="server" DataSourceID="obsStatus"
                        DataTextField="PS_DESCRICAO" DataValueField="PS_CODIGO" OnDataBound="drpStatus_DataBound" OnSelectedIndexChanged="drpStatusCode_SelectedIndexChanged" AutoPostBack="True" Width="200px" >
                        </asp:DropDownList><asp:ObjectDataSource ID="obsStatus" runat="server" DeleteMethod="Delete"
                        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.StatusTableAdapter"
                        UpdateMethod="Update">
                            <DeleteParameters>
                                <asp:Parameter Name="Original_PS_CODIGO" Type="Int32" />
                            </DeleteParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="PS_DESCRICAO" Type="String" />
                                <asp:Parameter Name="PS_ATIVO" Type="Boolean" />
                                <asp:Parameter Name="Original_PS_CODIGO" Type="Int32" />
                            </UpdateParameters>
                            <InsertParameters>
                                <asp:Parameter Name="PS_DESCRICAO" Type="String" />
                                <asp:Parameter Name="PS_ATIVO" Type="Boolean" />
                            </InsertParameters>
                        </asp:ObjectDataSource>
                            </ContentTemplate>
                            <Triggers>
                                <ajax:AsyncPostBackTrigger ControlID="drpStatusCode" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </ajax:UpdatePanel>
                    </td>
                    <td class="DescLeft" id="Td2"><ajax:UpdatePanel ID="updClosedDateRqd" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                &nbsp;<asp:Label ID="lblDisplayRequiredClosedDate" runat="server" ForeColor="#C00000"
                                    Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="rqdClosedDate" runat="server" ControlToValidate="ddcClosedDate" Enabled="False" ErrorMessage="Closed Date is required." CssClass="warning" ForeColor="" Display="None"></asp:RequiredFieldValidator>
                                <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label>
                            </ContentTemplate>
                        </ajax:UpdatePanel>
                    </td>
                    <td id="Td3" class="CalendarField">
                        <ajax:UpdatePanel ID="updClosedDate" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                        <uc5:DropDownCalendar ID="ddcClosedDate" runat="server" SelectedDateText='<%# Bind("ClosedDate", "{0:d}") %>' />
                            </ContentTemplate>
                        </ajax:UpdatePanel>
                        &nbsp;
                        <asp:CompareValidator
                            ID="compClosedOpen" runat="server" Display="Dynamic" ControlToCompare="txtOpenDate" ControlToValidate="ddcClosedDate"
                            ErrorMessage="<%$ Resources:Default, DATA_INF_OPEN_DATE %>" Operator="GreaterThan"
                            Type="Date" CultureInvariantValues="True"></asp:CompareValidator>
                        </td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        &nbsp; &nbsp;<asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label></td>
                    <td colspan="3" class="NormalField"><asp:TextBox style="width:100%" ID="txtRemarks" runat="server" Height="100px" Text='<%# Bind("Remarks") %>' TextMode="MultiLine"></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="DescLeft">
                        &nbsp; &nbsp;<asp:Label ID="Label40" runat="server" Text="eRoom Report#"></asp:Label></td>
                    <td class="NormalField" colspan="3">
                        <asp:TextBox ID="TextBox6" runat="server" MaxLength="150" Text='<%# Bind("eRoom") %>'></asp:TextBox></td>
                </tr>
                <tr>
                    <td class="Footer" colspan="4" style="width:100%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                        <div>
                            <asp:ImageButton ID="ImageButton2" runat="server" CommandName="Update" ImageUrl="~/Images/Save.jpg" />&nbsp;<asp:ImageButton
                                ID="btnPrevious" runat="server" CausesValidation="False" ImageUrl="~/Images/Previous.jpg"
                                OnClick="imgPrevious_Click" /></div>
                    </td>
                </tr>
            </table>
        </EditItemTemplate>
        <ItemTemplate>
            <table class="FormView" cellpadding="2" cellspacing="0">
                <tr>
                    <td class="Header" colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label></td>
                    <td nowrap><asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label></td>
                    <td nowrap class="Header"><asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label></td>
                    <td><asp:Label ID="Label2" runat="server" Text='<%# Eval("PA_DESCRICAO") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label></td>
                    <td nowrap colspan="3"><asp:Label ID="Label3" runat="server" Text='<%# Bind("Description") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                    <td colspan="3"><asp:Label ID="Label5" runat="server" Text='<%# Eval("PC_DESCRICAO") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label></td>
                    <td colspan="2" nowrap><asp:Label ID="Label4" runat="server" Text='<%# Eval("Name") %>'></asp:Label>-<asp:Label ID="Label14" runat="server" Text='<%# Eval("Username") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                    <td nowrap><asp:Label ID="Label6" runat="server" Text='<%# Eval("PL_DESCRICAO") %>'></asp:Label></td>
                    <td nowrap class="Header"><asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label></td>
                    <td><asp:Label ID="Label7" runat="server" Text='<%# Bind("OpenDate", "{0:d}") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label></td>
                    <td nowrap><asp:Label ID="Label8" runat="server" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:Label></td>
                    <td nowrap class="Header"><asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label></td>
                    <td><asp:Label ID="Label9" runat="server" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                    <td nowrap><asp:Label ID="Label10" runat="server" Text='<%# Eval("PS_DESCRICAO") %>'></asp:Label></td>
                    <td nowrap class="Header"><asp:Label Width="160px" ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label></td>
                    <td><asp:Label  ID="Label11" runat="server" Text='<%# Bind("CostSaving") %>' OnDataBinding="Label11_DataBinding"></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Header"><asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label></td>
                    <td nowrap colspan="3"><asp:Label ID="Label12" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label></td>
                </tr>
                <tr>
                    <td nowrap class="Footer" colspan="4">
                        <uc4:ItemTemplateButtons ID="ItemTemplateButtons1" runat="server" />
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
                    <td class="Footer">
                        <asp:ImageButton ID="ImageButton1" runat="server" CommandName="New" ImageUrl="~/Images/Add.jpg" /></td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:FormView>
            <asp:ObjectDataSource ID="obsCoRespsProject" runat="server" OldValuesParameterFormatString="original_{0}"
                SelectMethod="GetDataByProjectCode" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsiblesProjectsTableAdapter">
                <SelectParameters>
                    <asp:ControlParameter ControlID="gvProjects" Name="ProjectCode" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ObjectDataSource ID="obsCoRespsNoProject" runat="server" DeleteMethod="Delete"
                InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByOtherResponsibleToDrop"
                TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter"
                UpdateMethod="Update">
                <DeleteParameters>
                    <asp:Parameter Name="Username" Type="String" />
                </DeleteParameters>
                <UpdateParameters>
                    <asp:Parameter Name="Active" Type="Boolean" />
                    <asp:Parameter Name="Username" Type="String" />
                </UpdateParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="gvProjects" Name="PJ_CODIGO" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
                <InsertParameters>
                    <asp:Parameter Name="Username" Type="String" />
                    <asp:Parameter Name="Active" Type="Boolean" />
                </InsertParameters>
            </asp:ObjectDataSource>
        </asp:View>
    </asp:MultiView>&nbsp;<br />
    <asp:ObjectDataSource ID="obsProjects" runat="server" DeleteMethod="Delete" SelectMethod="GetProjectByDescription"
        TypeName="ProjectTracker.Business.Project"
        UpdateMethod="UpdateQuery" OnDeleted="obsDataSource_Deleted" OnInserted="obsDataSource_Inserted" OnUpdated="obsDataSource_Updated" OnInserting="obsProjects_Inserting" OnUpdating="obsProjects_Updating" OnSelecting="obsProjects_Selecting" OnDeleting="obsProjects_Deleting">
        <DeleteParameters>
            <asp:Parameter Name="projectCode" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="CategoryCode" Type="Int32" />
            <asp:Parameter Name="Description" Type="String" />
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="CustomerCode" Type="Int32" />
            <asp:Parameter Name="LocationCode" Type="Int32" />
            <asp:Parameter Name="OpenDate" Type="DateTime" />
            <asp:Parameter Name="CommitDate" Type="DateTime" />
            <asp:Parameter Name="ClosedDate" Type="DateTime" />
            <asp:Parameter Name="StatusCode" Type="Int32" />
            <asp:Parameter Name="CostSaving" Type="Decimal" />
            <asp:Parameter Name="Remarks" Type="String" />
            <asp:Parameter Name="SegmentCode" Type="Int32" />
            <asp:Parameter Name="RegionCode" Type="Int32" />
            <asp:Parameter Name="eRoom" Type="String" />
            <asp:ControlParameter ControlID="FormView1" Name="Code" PropertyName="SelectedValue"
                Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtDescription" DefaultValue="%" Name="Description"
                PropertyName="Text" Type="String" />
            <asp:ControlParameter ControlID="drpResponsiblesS" DefaultValue="%" Name="Username"
                PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="drpCategoriesS" DefaultValue="%" Name="CategoryCode"
                PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="drpStatusCodeS" DefaultValue="%" Name="StatusCode"
                PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="drpCustomersS" DefaultValue="%" Name="CustomerCode"
                PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="drpLocationsS" DefaultValue="%" Name="LocationCode"
                PropertyName="SelectedValue" Type="String" />
            <asp:QueryStringParameter DefaultValue="%" Name="ProjectCode" QueryStringField="ProjectCode"
                Type="String" />
            <asp:ControlParameter ControlID="drpRegionS" DefaultValue="%" Name="RegionCode" PropertyName="SelectedValue"
                Type="String" />
            <asp:Parameter Name="UserViewrs" Type="String" />
            <asp:Parameter DefaultValue="%" Name="sort" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>    
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
        ShowSummary="False" />
</asp:Content>

