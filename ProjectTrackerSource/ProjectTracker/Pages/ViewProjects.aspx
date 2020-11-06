<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ViewProjects.aspx.cs" Inherits="ProjectTracker.Pages.ViewProjects" %>
<asp:Content ID="viewProjectsContent" ContentPlaceHolderID="MainContent" runat="server">

    <div style="text-align:center">
        <br />
        <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:Default, VIEW_PROJECTS %>" SkinID="Title">
        </asp:Label>
        <br />
        
        <br />
        
        <div style="text-align: left; width: 100%;">
            <asp:Label ID="lblFilterStatus" runat="server" Text="<%$ Resources:Default, STATUS %>">
            </asp:Label>
            &nbsp;:&nbsp;
            <asp:DropDownList ID="lstStatus" runat="server" Width="170px" AutoPostBack="True" DataSourceID="ObjectDataSource1" DataTextField="PS_DESCRICAO" DataValueField="PS_CODIGO" OnDataBound="lstStatus_DataBound">
            </asp:DropDownList>
        </div>
        <div style="text-align: left; width: 100%;">
            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged">
                <asp:ListItem Value="saomimor" >Your Projects</asp:ListItem>
                <asp:ListItem Value="%" >All Projects</asp:ListItem>
            </asp:RadioButtonList></div>        
        <br />
        <asp:FormView ID="frmProjects" runat="server" DataSourceID="sqlDSProjects">
            <EditItemTemplate>
            </EditItemTemplate>
            <EmptyDataTemplate>
                Project not found
            </EmptyDataTemplate>
            <InsertItemTemplate>
            </InsertItemTemplate>
            <ItemTemplate>
                <table class="FormView" cellspacing=0 style="text-align: left">
                    <tr>
                        <td class="Header" colspan="4" style="height:24px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td class="Header" style="width:100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label></td>
                        <td style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label1" runat="server" Text='<%# Eval("PJ_CODIGO") %>'></asp:Label></td>
                        <td class="Header" style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label></td>
                        <td style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label2" runat="server" Text='<%# Eval("PA_DESCRICAO") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label></td>
                        <td class="Unique" colspan="3" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label3" runat="server" Text='<%# Bind("PJ_DESCRIPTION") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label></td>
                        <td class="Unique" colspan="3" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label5" runat="server" Text='<%# Eval("PC_DESCRICAO") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label></td>
                        <td style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;" colspan="3">
                            &nbsp;<asp:Label ID="Label4" runat="server" Text='<%# Eval("PU_NAME") %>'></asp:Label>
                            -
                            <asp:Label ID="Label14" runat="server" Text='<%# Eval("PU_USUARIO") %>'></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label></td>
                        <td style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label6" runat="server" Text='<%# Eval("PL_DESCRICAO") %>'></asp:Label></td>
                        <td class="Header" style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label></td>
                        <td style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label7" runat="server" Text='<%# Bind("PJ_OPEN_DATE", "{0:d}") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label></td>
                        <td style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label8" runat="server" Text='<%# Bind("PJ_COMMIT_DATE", "{0:d}") %>'></asp:Label></td>
                        <td class="Header" style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label></td>
                        <td style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label9" runat="server" Text='<%# Bind("PJ_CLOSED_DATE", "{0:d}") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label></td>
                        <td style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label10" runat="server" Text='<%# Eval("PS_DESCRICAO") %>'></asp:Label></td>
                        <td class="Header" style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label></td>
                        <td style="width: 25%;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label11" runat="server" Text='<%# Bind("PJ_COST_SAVING") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" style="width: 100px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label></td>
                        <td colspan="3" class="Unique" style="border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid;">
                            &nbsp;<asp:Label ID="Label12" runat="server" Text='<%# Bind("PJ_REMARKS") %>'></asp:Label></td>
                    </tr>
                    <tr>
                        <td class="Header" colspan="4" style="height:24px;border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                            &nbsp;</td>
                    </tr>
                </table>
            </ItemTemplate>
        </asp:FormView>
        <br />
        <br />
        <br />
        
        <asp:GridView ID="gvViewProjects" runat="server" OnRowDataBound="gvProjects_RowDataBound" AutoGenerateColumns="False" OnSelectedIndexChanged="gvViewProjects_SelectedIndexChanged" OnPageIndexChanged="gvViewProjects_PageIndexChanged" OnPageIndexChanging="gvViewProjects_PageIndexChanging" DataSourceID="sqlDSProjects">
            <Columns>
                <asp:CommandField ShowSelectButton="True" SelectText="<%$ Resources:Default, SELECT %>" />
                <asp:BoundField DataField="PJ_CODIGO" HeaderText="<%$ Resources:Default, CODE %>" InsertVisible="False"
                    ReadOnly="True" SortExpression="PJ_CODIGO" />
                <asp:BoundField DataField="PJ_DESCRIPTION" HeaderText="<%$ Resources:Default, DESCRIPTION %>" SortExpression="PJ_DESCRIPTION" />
                <asp:BoundField DataField="PJ_PERCENT_COMPLETION" SortExpression="PJ_PERCENT_COMPLETION" />
                <asp:BoundField DataField="PJ_OPEN_DATE" HeaderText="<%$ Resources:Default, OPEN_DATE %>" SortExpression="PJ_OPEN_DATE" DataFormatString="{0:d}" />
                <asp:BoundField DataField="PJ_COMMIT_DATE" HeaderText="<%$ Resources:Default, COMMIT_DATE %>" SortExpression="PJ_COMMIT_DATE" DataFormatString="{0:d}" />
                <asp:BoundField DataField="PJ_CLOSED_DATE" HeaderText="<%$ Resources:Default, CLOSED_DATE %>" SortExpression="PJ_CLOSED_DATE" DataFormatString="{0:d}" />
            </Columns>
            <PagerStyle HorizontalAlign="Right" />
        </asp:GridView>
        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" DeleteMethod="Delete"
            InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData"
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
        <asp:SqlDataSource ID="sqlDSProjects" runat="server" ConnectionString="<%$ ConnectionStrings:d_PTConnectionString %>"
            OnSelecting="sqlDSProjects_Selecting" SelectCommand="SP_FIT_PT_VIEW_PROJECTS"
            SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="lstStatus" Name="STATUS" PropertyName="SelectedValue"
                    Type="Int32" />
                <asp:Parameter Name="USER" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        &nbsp; &nbsp;&nbsp;<br />        
        
    </div>
    
</asp:Content>
