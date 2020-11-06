<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserCad.aspx.cs" Inherits="ProjectTracker.Pages.UserCad" MasterPageFile="~/Pages/MasterPage.Master" %>

<%@ Register Src="../Common/ItemTemplateButtons.ascx" TagName="ItemTemplateButtons"
    TagPrefix="uc2" %>
<%@ Register Src="../Common/UpdateButtons.ascx" TagName="UpdateButtons" TagPrefix="uc3" %>
<%@ Register Src="../Common/InsertButtons.ascx" TagName="InsertButtons" TagPrefix="uc4" %>
<%@ Register Src="../Common/MessagePanel.ascx" TagName="MessagePanel" TagPrefix="uc1" %>
<%@ Register    
    Assembly="AjaxControlToolkit"
    Namespace="AjaxControlToolkit"
    TagPrefix="ajaxToolkit" %>
    
<asp:Content ID="contentChildren" ContentPlaceHolderID="MainContent" runat="server">
    <ajax:ScriptManager ID="scriptManager1" runat="server" EnablePartialRendering="true" />
    
    <script language="javascript" type="text/javascript">
        function OpenPageInsertRegion(username)
        {
            var link = "UserRegion.aspx?username="+username;
            window.open(link,"_blank","status=yes,toolbar=no,menubar=no,scrollbars=yes,location=no,replace=yes,resizable=yes,width=700,height=400");
            return false;
        }
    </script>
    
    <div style="text-align:center" class="spacing_title">
    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Default, TITLE_USERS %>" SkinID="Title"/><br />
        <br />
        <uc1:MessagePanel id="MessagePanel1" runat="server"></uc1:MessagePanel> 
    </div>
    <br />
    
    <asp:DetailsView ID="dvUsers" runat="server" AutoGenerateRows="False" DataKeyNames="Username"
        DataSourceID="obsUsers" OnItemInserting="dvUsers_ItemInserting">
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
        <Fields>
            <asp:TemplateField HeaderText="Username" SortExpression="Username">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Username") %>'></asp:Label>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtUsername" runat="server" Text='<%# Bind("Username") %>' MaxLength="15"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUsername"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                    <asp:ImageButton ID="ImageButton2" CausesValidation="false" runat="server" ImageUrl="~/Images/btn_find.gif"
                        OnClick="ImageButton2_Click" />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Username") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, USERNAME_AD %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active" SortExpression="Active">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, ACTIVE %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Name" SortExpression="Name">
                <EditItemTemplate>
                    <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Name") %>' MaxLength="80" Width="385px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rqdEditName" runat="server" ControlToValidate="txtName"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("Name") %>' MaxLength="80" Width="385px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rqdInsertName" runat="server" ControlToValidate="txtName"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label14" runat="server" Text="<%$ Resources:Default, NAME %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Email" SortExpression="Email">
                <EditItemTemplate>
                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' MaxLength="150" Width="457px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rqdEditEmail" runat="server" ControlToValidate="txtEmail"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' MaxLength="150" Width="455px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rqdInsertEmail" runat="server" ControlToValidate="txtEmail"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, EMAIL %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="LanguageCode" SortExpression="LanguageCode">
                <EditItemTemplate><asp:DropDownList ID="DropDownList1" runat="server" OnDataBound="DropDownList1_DataBound" SelectedValue='<%# Bind("LanguageCode") %>' >
                    <asp:ListItem Value="en-US" Selected="True" >English</asp:ListItem>
                    <asp:ListItem Value="pt-BR" >Portuguese</asp:ListItem>
                </asp:DropDownList>&nbsp;
                    <asp:RequiredFieldValidator ID="rqdEditLanguage" runat="server" ControlToValidate="DropDownList1"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:DropDownList ID="DropDownList2" runat="server" OnDataBound="DropDownList1_DataBound" SelectedValue='<%# Bind("LanguageCode") %>' ><asp:ListItem Value="en-US" Selected="True" >English</asp:ListItem>
                        <asp:ListItem Value="pt-BR" >Portuguese</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rqdEditLanguage" runat="server" ControlToValidate="DropDownList2"
                        Display="Dynamic" ErrorMessage="*"></asp:RequiredFieldValidator>
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label6" runat="server" Text='<%# Bind("LanguageCode") %>'></asp:Label>
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, LANGUAGE %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="IsAdmin" SortExpression="IsAdmin">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("IsAdmin") %>' />
                </EditItemTemplate>
                <InsertItemTemplate>
                    <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("IsAdmin") %>' />
                </InsertItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("IsAdmin") %>' Enabled="false" />
                </ItemTemplate>
                <HeaderTemplate>
                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, IS_ADMIN %>"></asp:Label>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" ShowInsertButton="True" ButtonType="Image" CancelImageUrl="~/Images/Cancel.jpg" DeleteImageUrl="~/Images/Delete.jpg" EditImageUrl="~/Images/Edit.jpg" InsertImageUrl="~/Images/Insert.jpg" NewImageUrl="~/Images/New.jpg" UpdateImageUrl="~/Images/Save.jpg">
                <ItemStyle HorizontalAlign="Center"  Wrap="False"/>
            </asp:CommandField>
        </Fields>
        <EmptyDataRowStyle BackColor="Transparent" />
    </asp:DetailsView>
    &nbsp; &nbsp;&nbsp;
    <br />
    <br />
    
    <div style="text-align:left">
    <asp:Panel ID="pnlHidden" runat="server" CssClass="collapsePanelHeader" Height="30px"> 
            <div style="padding:5px; cursor: pointer; vertical-align: middle;">                
                
                    <asp:Label ID="Label1" Text="<%$ Resources:Default, FILTER %>" runat="server"></asp:Label>                              
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/down.gif"
                    AlternateText="ASP.NET AJAX" ImageAlign="Left" />
             
            </div>
        </asp:Panel>
        
        <asp:Panel ID="Panel3" runat="server" CssClass="collapsePanel" Height="0">
            <p>

                <table class="FormView">
        <tr>
            <td class="Header" style="height: 20px">
                <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, FILTER %>"></asp:Label></td>
            <td style="height: 20px">
                <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>&nbsp;<asp:ImageButton ID="ImageButton3"
                    runat="server" ImageUrl="~/Images/btn_find.gif" />&nbsp;</td>
        </tr>
        <tr>
            <td class="Header" style="vertical-align: top; height: 20px">
                <asp:Label ID="lblFilterByDis" runat="server" Text="<%$ Resources:Default, FILTER_BY %>"></asp:Label></td>
            <td style="height: 20px">
                <asp:RadioButtonList ID="RadioButtonList1" runat="server">
                    <asp:ListItem Selected="True" Value="0">Username</asp:ListItem>
                    <asp:ListItem Value="1">Name</asp:ListItem>
                    <asp:ListItem Value="2">Email</asp:ListItem>
                </asp:RadioButtonList></td>
        </tr>
    </table>
            
            </p>
        </asp:Panel>
        </div>
        
        
     <ajaxToolkit:CollapsiblePanelExtender ID="cpeDemo" runat="Server"
        TargetControlID="Panel3"
        ExpandControlID="pnlHidden"
        CollapseControlID="pnlHidden" 
        Collapsed="True"
        TextLabelID="Label1"
        ExpandedText="<%$  Resources:Default, FILTER_HIDDEN %>"
        CollapsedText="<%$  Resources:Default, FILTER_SHOW %>"
        ImageControlID="Image1"
        ExpandedImage="~/images/up.gif"
        CollapsedImage="~/images/down.gif"
        SuppressPostBack="true" />

    <div class="demobottom"></div>
        

    <br />
    <br />
            <asp:GridView ID="gvUsers" runat="server" AllowPaging="True"
                AutoGenerateColumns="False" DataKeyNames="Username" DataSourceID="obsUsers" OnSelectedIndexChanged="gvUsers_SelectedIndexChanged" OnSorting="gvUsers_Sorting" OnDataBound="gvUsers_DataBound" >
                <Columns>
                    <asp:TemplateField ShowHeader="False">
                        <ItemStyle HorizontalAlign="Center" Width="80px" />
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                Text="<%$ Resources:Default, SELECT %>"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, USERNAME_AD %>" SortExpression="Username">
                        <EditItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Username") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, ACTIVE %>" SortExpression="Active">
                        <EditItemTemplate>
                            <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                        </EditItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, NAME %>" SortExpression="Name">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, LAST_LOGIN %>" SortExpression="LastLogin">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("LastLogin") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("LastLogin") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, EMAIL %>" SortExpression="Email">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("Email") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, LANGUAGE %>" SortExpression="LanguageCode">
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("LanguageCode") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# Bind("LanguageCode") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="<%$ Resources:Default, IS_ADMIN %>" SortExpression="IsAdmin">
                        <EditItemTemplate>
                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("IsAdmin") %>' />
                        </EditItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                        <ItemTemplate>
                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Bind("IsAdmin") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Add Region">
                        <ItemTemplate>
                            <asp:HyperLink ID="hplnkAddRegion" runat="server">Add Regions</asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
    &nbsp;
    <br />
    <asp:ObjectDataSource ID="obsUsers" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        SelectMethod="GetDataByOption" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UsersTableAdapter"
        UpdateMethod="Update" OnDeleted="obsCategory_Deleted" OnInserted="obsCategory_Inserted" OnUpdated="obsCategory_Updated">
        <DeleteParameters>
            <asp:Parameter Name="Username" Type="String" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="LanguageCode" Type="String" />
            <asp:Parameter Name="IsAdmin" Type="Boolean" />
            <asp:Parameter Name="Username" Type="String" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Username" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="LanguageCode" Type="String" />
            <asp:Parameter Name="IsAdmin" Type="Boolean" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtSearch" DefaultValue="%" Name="SEARCH" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="RadioButtonList1" DefaultValue="" Name="OPTION"
                PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>


