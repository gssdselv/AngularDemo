<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ProjectInsert.aspx.cs" Inherits="ProjectTracker.Pages.ProjectInsert" EnableViewState="true" %>

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
    <ajax:ScriptManager ID="scriptManager1" runat="server" AllowCustomErrorsRedirect="False">
    </ajax:ScriptManager>

    <script language="javascript" type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        //Raised before processing of an asynchronous postback starts and the postback request is sent to the server.
        prm.add_beginRequest(BeginRequestHandler);
        // Raised after an asynchronous postback is finished and control has been returned to the browser.
        prm.add_endRequest(EndRequestHandler);
        function BeginRequestHandler(sender, args) {
            //Shows the modal popup - the update progress
            var popup = $find('<%= modalPopup.ClientID %>');
            if (popup != null) {
                popup.show();
            }
        }

        function EndRequestHandler(sender, args) {
            //Hide the modal popup - the update progress
            var popup = $find('<%= modalPopup.ClientID %>');
            if (popup != null) {
                popup.hide();
            }
        }

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

        function VerifyCostSavingValue(txtAmountId, doValidation) {
            //if (doValidation == "True" && !EnableCostSavingButton()) {
            //    return false;
            //}
            var txtFooterSavingAmount = document.getElementById(txtAmountId);
            var hfCostSavingAlertValue = document.getElementById('<%= hfCostSavingAlertValue.ClientID %>');
            var hfInsertAlertText1 = document.getElementById('<%= hfInsertAlertText1.ClientID %>');
            var hfInsertAlertText2 = document.getElementById('<%= hfInsertAlertText2.ClientID %>');
            if (Number(txtFooterSavingAmount.value) >= Number(hfCostSavingAlertValue.value)) {
                return confirm(hfInsertAlertText1.value + hfCostSavingAlertValue.value + hfInsertAlertText2.value);
            }
            return true;

        }

        function changeIP(rdoIP) {
            var rdoID = rdoIP.id.toString();
            var hdfID = "";
            hdfID = rdoID.replace("rdoIPYes", "hdfrfvIP");
            hdfID = hdfID.replace("rdoIPNo", "hdfrfvIP");
            document.getElementById(hdfID).value = 'Y';
            document.getElementById('ctl00_MainContent_FormView1_hdfrfvIP').value = 'Y';
            ValidatePage();
            return true;
        }
        function checkTextAreaMaxLength(textBox, e, length) {

            var mLen = textBox["MaxLength"];
            if (null == mLen)
                mLen = length;

            var maxLength = parseInt(mLen);
            if (!checkSpecialKeys(e)) {
                if (textBox.value.length > maxLength - 1) {
                    if (window.event)//IE
                        e.returnValue = false;
                    else//Firefox
                        e.preventDefault();
                }
            }
        }
        function checkSpecialKeys(e) {
            if (e.keyCode != 8 && e.keyCode != 46 && e.keyCode != 37 && e.keyCode != 38 && e.keyCode != 39 && e.keyCode != 40)
                return false;
            else
                return true;
        }

        function EnableCostSavingButton() {
            var grdDDLSavType = document.getElementById('ctl00_MainContent_FormView1_grdCostSavings_ctl03_drpFooterSavingType');
            var grdddlSavTypeIndex = grdDDLSavType.selectedIndex;
            var grdddlSavTypeValue = grdDDLSavType.options[grdddlSavTypeIndex].value;
            if (grdddlSavTypeValue == "") {
                return false;
            }
            return true;
        }

        function EnableValidators() {
            var ddlCategoryCode = document.getElementById('ctl00_MainContent_FormView1_drpCategories');
            var CategoryIndex = ddlCategoryCode.selectedIndex;
            var CategoryValue = ddlCategoryCode.options[CategoryIndex].value;

            var ddlStatusCode = document.getElementById('ctl00_MainContent_FormView1_drpStatusCode');
            var StatusIndex = ddlStatusCode.selectedIndex;
            var StatusValue = ddlStatusCode.options[StatusIndex].value;

            if (CategoryValue == 107 || CategoryValue == 145) {
                var ddlStageCode = document.getElementById('ctl00_MainContent_FormView1_drpAutoStage');
                var StageIndex = ddlStageCode.selectedIndex;
                var StageValue = ddlStageCode.options[StageIndex].value;
            }

            for (i = 0; i < Page_Validators.length; i++) {
                if (CategoryValue == 107 || CategoryValue == 145) // only for automation category
                {
                    if (StatusValue == 20 && (StageValue == "Define" || StageValue == "Eval" || StageValue == "Develop")) {
                        if (Page_Validators[i].validationGroup == "GrpClosed") {
                            ValidatorEnable(Page_Validators[i], true);
                        }
                        else if (Page_Validators[i].validationGroup == "GrpClosedOther") {
                            var ddlCloseOption = document.getElementById('ctl00_MainContent_FormView1_drpCloseInfo');
                            var SelClosedIndex = ddlCloseOption.selectedIndex;
                            var SelCloseValue = ddlCloseOption.options[SelClosedIndex].value;
                            if (SelCloseValue == "OTH") {
                                ValidatorEnable(Page_Validators[i], true);
                            }
                            else {
                                ValidatorEnable(Page_Validators[i], false);
                            }
                        }
                    }
                    else if (StatusValue == 21 && (StageValue == "Develop" || StageValue == "Deploy")) {
                        if (Page_Validators[i].validationGroup == "GrpOpenDevelop") {
                            ValidatorEnable(Page_Validators[i], true);
                        }
                        else if (Page_Validators[i].validationGroup == "GrpOpenDevelopCapexDate") {
                            var radioCapexList = document.getElementById('ctl00_MainContent_FormView1_rblPOIssued');
                            var radio = radioCapexList.getElementsByTagName("input");
                            for (var x = 0; x < radio.length; x++) {
                                if (radio[x].checked) {
                                    ValidatorEnable(Page_Validators[i], radio[x].value == "Y");
                                }
                            }
                        }
                        else if (Page_Validators[i].validationGroup == "GrpOpenDevelopConditional") {
                            var radioPaidByList = document.getElementById('ctl00_MainContent_FormView1_rblPaidFlex');
                            var radio = radioPaidByList.getElementsByTagName("input");
                            for (var x = 0; x < radio.length; x++) {
                                if (radio[x].checked) {
                                    ValidatorEnable(Page_Validators[i], radio[x].value == "F");
                                }
                            }
                        }
                    }
                    else if ((StatusValue == 21 || StatusValue == 20) && StageValue == "Deploy") {
                        if (Page_Validators[i].validationGroup == "GrpOpenCloseDeploy") {
                            ValidatorEnable(Page_Validators[i], true);
                        }
                        else if (Page_Validators[i].validationGroup == "GrpOpenDevelop") {
                            // Change from Define to Deploy and status closed, we need to validate Develop stage controls
                            ValidatorEnable(Page_Validators[i], true);
                        }
                        else if (Page_Validators[i].validationGroup == "GrpOpenDevelopCapexDate") {
                            var radioCapexList = document.getElementById('ctl00_MainContent_FormView1_rblPOIssued');
                            var radio = radioCapexList.getElementsByTagName("input");
                            for (var x = 0; x < radio.length; x++) {
                                if (radio[x].checked) {
                                    ValidatorEnable(Page_Validators[i], radio[x].value == "Y");
                                }
                            }
                        }
                        else if (Page_Validators[i].validationGroup == "GrpOpenDevelopConditional") {
                            var radioPaidByList = document.getElementById('ctl00_MainContent_FormView1_rblPaidFlex');
                            var radio = radioPaidByList.getElementsByTagName("input");
                            for (var x = 0; x < radio.length; x++) {
                                if (radio[x].checked) {
                                    ValidatorEnable(Page_Validators[i], radio[x].value == "F");
                                }
                            }
                        }
                        else if (Page_Validators[i].validationGroup == "GrpCloseDeployPaidBy") {
                            var radioPaidByList = document.getElementById('ctl00_MainContent_FormView1_rblPaidFlex');
                            var radio = radioPaidByList.getElementsByTagName("input");
                            for (var x = 0; x < radio.length; x++) {
                                if (radio[x].checked) {
                                    ValidatorEnable(Page_Validators[i], (radio[x].value == "F" && StatusValue == 20));
                                }
                            }
                        }
                    }
                    else {
                        if (Page_Validators[i].validationGroup == "GrpOpenCloseDeploy" || Page_Validators[i].validationGroup == "GrpClosed" || Page_Validators[i].validationGroup == "GrpOpenDevelop") {
                            ValidatorEnable(Page_Validators[i], false);
                        }
                    }
                }
                if (Page_Validators[i].validationGroup == "GrpClosedStatus") {
                    if (StatusValue == 20) { // enabling validation for closed status fields
                        ValidatorEnable(Page_Validators[i], true);
                    }
                    else {
                        ValidatorEnable(Page_Validators[i], false);
                    }
                }
                if (Page_Validators[i].validationGroup == "GrpClosedBestPractice") {
                    if (StatusValue == 20) { // enabling best practice Comments validation
                        var radioBestPracList = document.getElementById('ctl00_MainContent_FormView1_rblBestPractice');
                        var radio = radioBestPracList.getElementsByTagName("input");
                        for (var x = 0; x < radio.length; x++) {
                            if (radio[x].checked) {
                                ValidatorEnable(Page_Validators[i], radio[x].value == "Y");
                            }
                        }
                    }
                    else {
                        ValidatorEnable(Page_Validators[i], false);
                    }
                }
                if (Page_Validators[i].validationGroup == "GrpDropStatus") {
                    if (StatusValue == 22) {
                        ValidatorEnable(Page_Validators[i], true);
                    }
                    else {
                        ValidatorEnable(Page_Validators[i], false);
                    }
                }
                if (Page_Validators[i].validationGroup == "GrpHold") {
                    if (StatusValue == 22 || StatusValue == 23) { // enabling validation for Dropped and Hold status fields
                        ValidatorEnable(Page_Validators[i], true);
                    }
                    else {
                        ValidatorEnable(Page_Validators[i], false);
                    }
                }
            }
        }
        function ValidatePage() {

            EnableValidators();

            if (typeof (Page_Validators) == "undefined") return;

            var noOfValidators = Page_Validators.length;
            var count = 0;
            var Page_Callout = [];
            for (var i = 0; i < Page_Validators.length; i++) {
                Page_Callout[Page_Callout.length++] = Page_Validators[i]._behaviors != null ? Page_Validators[i]._behaviors[0]._id : "";
                count++;
            }

            for (var validatorIndex = 0; validatorIndex < noOfValidators; validatorIndex++) {
                var validator = Page_Validators[validatorIndex];

                ValidatorValidate(validator);

                if (!validator.isvalid) {
                    showValidatorCallout($find(Page_Callout[validatorIndex]));
                    return false;
                }
            }
            return true;
        }

        function hideValidatorCallout() {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }

        function showValidatorCallout(currrentCallout) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout = currrentCallout;
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.show(true);
        }

        function ValidateRadioButtons(sender, args) {
            var radios = document.getElementsByName('ctl00_MainContent_FormView1_rdoGrpIP');
            if (radios.length > 0) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }
        }

        function ValidateCapexApproval(sender, args) {
            var radioCapexList = document.getElementById('ctl00_MainContent_FormView1_rblCapexAppd');
            var radio = radioCapexList.getElementsByTagName("input");
            for (var x = 0; x < radio.length; x++) {
                if (radio[x].checked) {
                    args.IsValid = radio[x].value == "Y";
                    if (args.IsValid) {
                        $find("b_vceCVCapex")._ensureCallout();
                        $find("b_vceCVCapex").hide();
                    }
                    else {
                        $find("b_vceCVCapex")._ensureCallout();
                        $find("b_vceCVCapex").show();
                    }
                }
            }

        }

        function ValidatePOApproval(sender, args) {
            var radioPOIssueList = document.getElementById('ctl00_MainContent_FormView1_rblPOIssued');
            var radioPO = radioPOIssueList.getElementsByTagName("input");
            for (var x = 0; x < radioPO.length; x++) {
                if (radioPO[x].checked) {
                    args.IsValid = radioPO[x].value == "Y";
                    if (args.IsValid) {
                        $find("b_vceCVPOIssued")._ensureCallout();
                        $find("b_vceCVPOIssued").hide();
                    }
                    else {
                        $find("b_vceCVPOIssued")._ensureCallout();
                        $find("b_vceCVPOIssued").show();
                    }
                }
            }
        }

        function CalculateHeadCount() {
            var txtHeadcountBefore = document.getElementById("ctl00_MainContent_FormView1_txtHeadcountBeforeAutomation");
            var txtHeadcountAfter = document.getElementById("ctl00_MainContent_FormView1_txtHeadcountAfterAutomation");
            if (Number(txtHeadcountBefore.value) >= Number(txtHeadcountAfter.value)) {
                document.getElementById("ctl00_MainContent_FormView1_txtHeadcountReduction").value = Number(txtHeadcountBefore.value) - Number(txtHeadcountAfter.value);
            }
            else {
                document.getElementById("ctl00_MainContent_FormView1_txtHeadcountReduction").value = 0;
            }
        }

        function ShowCapexDate() {
            var content = document.getElementById('ctl00_MainContent_FormView1_ddcCapexAppvdDate');
            //var element = document.getElementById('ctl00_MainContent_FormView1_tbodyCapexAppvdDate');
            var element = document.getElementById('ctl00_MainContent_FormView1_tdlblPoAppvdDate');
            var element1 = document.getElementById('ctl00_MainContent_FormView1_tdPoAppvdDate');
            var radioCapexList = document.getElementById('ctl00_MainContent_FormView1_rblPOIssued');
            var radio = radioCapexList.getElementsByTagName("input");
            for (var x = 0; x < radio.length; x++) {
                if (radio[x].checked) {
                    if (radio[x].value == "Y") {
                        element.style.display = 'block';
                        element1.style.display = 'block';
                    }
                    else {
                        element.style.display = 'none';
                        element1.style.display = 'none';
                        document.getElementById("ctl00_MainContent_FormView1_ddcCapexAppvdDate").value = ''
                    }
                }
            }
        }

        function ValidateAutomationCostSaving(sender, args) {
            var table, tbody, i, rowLen, row, j, colLen, cell, status;
            table = document.getElementById("ctl00_MainContent_FormView1_grdCostSavings");
            //debugger;
            tbody = table.tBodies[0];
            row:
                for (i = 0, rowLen = tbody.rows.length; i < rowLen; i++) {
                    row = tbody.rows[i];
                    for (j = 0, colLen = row.cells.length; j < colLen; j++) {
                        cell = row.cells[j];
                        if (cell.innerText == "Automation Saving" || cell.innerText == "" || cell.innerText.length > 30) {
                            args.IsValid = false;
                            break;
                        }
                        else if (trim(cell.innerText) != "") {
                            args.IsValid = true;
                            break row;
                        }
                        else {
                            args.IsValid = false;
                            break;
                        }
                    }
                }
            if (args.IsValid) {
                $find("b_vcecvFinancialRqd")._ensureCallout();
                $find("b_vcecvFinancialRqd").hide();
            }
            else {
                $find("b_vcecvFinancialRqd")._ensureCallout();
                $find("b_vcecvFinancialRqd").show();
            }
        }

        function ValidateAutomationPlannedVsActual(sender, args) {
            var hfPlannedSaving = document.getElementById('<%= hfAutoPlannedSaving.ClientID %>');
            var hfActualSaving = document.getElementById('<%= hfAutoActualSaving.ClientID %>');
            if (Number(hfPlannedSaving.value) != Number(hfActualSaving.value)) {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }

            if (args.IsValid) {
                $find("b_vcecvPlannedVsActual")._ensureCallout();
                $find("b_vcecvPlannedVsActual").hide();
            }
            else {
                $find("b_vcecvPlannedVsActual")._ensureCallout();
                $find("b_vcecvPlannedVsActual").show();
            }

        }

        function ShowBestPracticeComment() {
            var element = document.getElementById('ctl00_MainContent_FormView1_tdBPComment');
            var radioBestPracList = document.getElementById('ctl00_MainContent_FormView1_rblBestPractice');
            var radio = radioBestPracList.getElementsByTagName("input");
            for (var x = 0; x < radio.length; x++) {
                if (radio[x].checked) {
                    if (radio[x].value == "Y") {
                        element.style.display = 'block';
                    }
                    else {
                        element.style.display = 'none';
                        document.getElementById("ctl00_MainContent_FormView1_txtBPComment").value = ''
                    }
                }
            }
        }

        function CheckMinLength(sender, args) {
            var txtBpComment = document.getElementById('ctl00_MainContent_FormView1_txtBPComment');
            args.IsValid = txtBpComment.value.length >= 50
            if (args.IsValid) {
                $find("b_vcecvBpComment")._ensureCallout();
                $find("b_vcecvBpComment").hide();
            }
            else {
                $find("b_vcecvBpComment")._ensureCallout();
                $find("b_vcecvBpComment").show();
            }
        }
    </script>

    <div>
        <asp:UpdateProgress ID="UpdateProgress" runat="server" DynamicLayout="false" DisplayAfter="1">
            <ProgressTemplate>
                <asp:Image ID="Image1" ImageUrl="~/Images/Spinner.gif" AlternateText="Processing" runat="server" />
                <%--<div style="top: 0px; height: 100%; background-color: white; opacity: 1; filter: alpha(opacity=75); vertical-align: middle; left: 0px; z-index: 999999; width: 99%; position: absolute; text-align: center;">
                    <div style="position: absolute; top: 40%; text-align: center; right: 50%; vertical-align: middle;">
                        <img src="../Images/Spinner.gif" height="60px" width="60px" style="vertical-align: middle"
                            alt="Processing" />
                    </div>
                </div>--%>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <ajaxToolkit:ModalPopupExtender ID="modalPopup" runat="server" TargetControlID="UpdateProgress"
            PopupControlID="UpdateProgress" BackgroundCssClass="modalPopup" />
    </div>
    <asp:UpdatePanel ID="udpMainPage" runat="server" UpdateMode="Always">
        <ContentTemplate>

            <input type="hidden" id="hfInsertAlertText1" value="<%$ Resources:Default, COSTSAVING_ALERTMESSAGE_PART1 %>" runat="server" />
            <input type="hidden" id="hfInsertAlertText2" value="<%$ Resources:Default, COSTSAVING_ALERTMESSAGE_PART2 %>" runat="server" />
            <input type="hidden" id="hfCostSavingAlertValue" runat="server" />
            <input type="hidden" id="hfAutoPlannedSaving" runat="server" />
            <input type="hidden" id="hfAutoActualSaving" runat="server" />
            <asp:HiddenField ID="hdfEngLink" runat="server" />
            <asp:HiddenField ID="hdfEngIP" runat="server" />
            <asp:HiddenField ID="hdfAutoLevel" runat="server" />
            <asp:HiddenField ID="hdfAutoType" runat="server" />
            <asp:HiddenField ID="hdfProjCost" runat="server" />
            <asp:HiddenField ID="hdfReuse" runat="server" />
            <asp:HiddenField ID="hdfCategory" runat="server" />
            <asp:HiddenField ID="hdfPlannedPaybackinMonths" runat="server" />
            <asp:HiddenField ID="hdfEstimatedProductLifeinMonths" runat="server" />
            <asp:HiddenField ID="hdfHeadcountBeforeAutomation" runat="server" />
            <asp:HiddenField ID="hdfHeadcountAfterAutomation" runat="server" />
            <asp:HiddenField ID="hdfEstimatedROIafterendoflife" runat="server" />
            <asp:HiddenField ID="hdfAutoStage" runat="server" />
            <asp:HiddenField ID="hdfExpectedIRR" runat="server" />
            <asp:HiddenField ID="hdfCapexAppd" runat="server" />

            <asp:HiddenField ID="hdfCapexAppdDate" runat="server" />

            <asp:HiddenField ID="hdfPOIssued" runat="server" />
            <asp:HiddenField ID="hdfPrjNumber" runat="server" />
            <asp:HiddenField ID="hdfFlexPaid" runat="server" />
            <asp:HiddenField ID="hdfCustPaid" runat="server" />
            <asp:HiddenField ID="hdfSummaryLink" runat="server" />
            <asp:HiddenField ID="hdfVideoLink" runat="server" />
            <asp:HiddenField ID="hdfROILink" runat="server" />
            <asp:HiddenField ID="hdfCloseReason" runat="server" />
            <asp:HiddenField ID="hdfCloseRemarks" runat="server" />
            <asp:HiddenField ID="hdfStatus" runat="server" />
            <asp:HiddenField ID="hdfHoldReason" runat="server" />
            <asp:HiddenField ID="hdfrbBestPractice" runat="server" />
            <asp:HiddenField ID="hdftxtBestPractice" runat="server" />

            <div class="spacing_title" style="text-align: center; width: 1082px;">
                <asp:Label ID="Label5" runat="server" SkinID="Title" Text="<%$ Resources:Default, TITLE_PROJECTS %>"></asp:Label><br />
                <uc1:MessagePanel ID="MessagePanel1" runat="server" />
            </div>
            <div style="position: relative;">
                <asp:FormView ID="FormView1" runat="server" DataSourceID="obsProjects" DefaultMode="Insert" OnDataBound="FormView1_DataBound" OnItemInserting="FormView1_ItemInserting1">
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
                    <InsertItemTemplate>
                        <table cellpadding="1" cellspacing="0" class="FormView" border="0">
                            <tr>
                                <td colspan="4" style="text-align: right" class="Header"></td>
                            </tr>
                            <tr>
                                <td class="DescLeft">
                                    <asp:Label ID="Label6" runat="server" Text="<%$ Resources:Default, Region %>"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvRegion" runat="server" ControlToValidate="drpRegion" CssClass="warning" ForeColor="" ErrorMessage="Region is required" Display="None" EnableClientScript="true" ValidationGroup="Group1" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
                                <td class="NormalField">

                                    <asp:DropDownList ID="drpRegion" runat="server" DataSourceID="obsRegion" DataTextField="RegionDescription"
                                        DataValueField="RegionCode" OnDataBound="drpCategories_DataBound" Width="200px" SelectedValue='<%# Bind("RegionCode") %>' AutoPostBack="True" OnSelectedIndexChanged="drpRegion_SelectedIndexChanged">
                                    </asp:DropDownList><asp:ObjectDataSource ID="obsRegion" runat="server"
                                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByUsername" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UserRegionsTableAdapter" DeleteMethod="Delete" OnSelecting="obsRegion_Selecting">
                                        <DeleteParameters>
                                            <asp:Parameter Name="Username" Type="String" />
                                            <asp:Parameter Name="RegionCode" Type="Int32" />
                                        </DeleteParameters>
                                        <SelectParameters>
                                            <asp:Parameter Name="PU_USUARIO" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    </ContentTemplate>                             
                                </td>
                                <td class="Desc">
                                    <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="drpCategories" CssClass="warning" ForeColor="" ErrorMessage="Category is required" Display="None" EnableClientScript="true" ValidationGroup="Group1" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
                                <td class="NormalField">
                                    <asp:DropDownList ID="drpCategories" runat="server" DataSourceID="obsCategories" OnSelectedIndexChanged="drpCategories_SelectedIndexChanged" AutoPostBack="true"
                                        DataTextField="Description" DataValueField="Code" OnDataBound="drpCategories_DataBound"
                                        Width="200px" SelectedValue='<%# Bind("CategoryCode") %>'>
                                    </asp:DropDownList><asp:ObjectDataSource
                                        ID="obsCategories" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CategoryTableAdapter"
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
                                <td class="DescLeft" style="" nowrap="nowrap">
                                    <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                                    <a href="#" class="tooltipDescription">
                                        <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="imgTooltip" ImageUrl="~/Images/help.png" />
                                        <span>For Example:
                                <br>
                                            &nbsp;&nbsp;<b>-Service:</b>&nbsp;DFx - DFT analysis for Nortel PCBA model Taurus Tx-123<br>
                                            &nbsp;&nbsp;<b>-Non-Service:</b>&nbsp;Scrap reduction on Dell laptop rework project
                                        </span></a>
                                    <asp:RequiredFieldValidator ID="rqdDescription" runat="server" ControlToValidate="TextBox2" CssClass="warning" ForeColor="" Display="None" ErrorMessage="Description is required" EnableClientScript="true" ValidationGroup="Group1" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
                                <td class="NormalField">
                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Description") %>' Style="width: 90%" onkeyDown="checkTextAreaMaxLength(this,event,'80');" TextMode="MultiLine"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                        <ajaxToolkit:TextBoxWatermarkExtender ID="twPrjDesc" runat="server" TargetControlID="TextBox2" Enabled="false"
                            WatermarkText="Open project with Project Name – feasibility and analysis study" WatermarkCssClass="watermarked" />
                                </td>

                                <td class="DescLeft" style="" nowrap="nowrap">
                                    <asp:Label ID="lblSiteBuLead" runat="server" Text="<%$ Resources:Default, BULEAD %>"></asp:Label>
                                </td>
                                <td class="NormalField">
                                    <asp:TextBox ID="txtBULead" runat="server" MaxLength="40" Text=""></asp:TextBox>&nbsp;&nbsp;&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td class="DescLeft">
                                    <asp:Label ID="Label32" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label>

                                    <td class="NormalField">

                                        <asp:DropDownList ID="drpLocations" runat="server" DataSourceID="obsLocations" DataTextField="Description"
                                            DataValueField="Code" OnDataBound="drpCategories_DataBound" SelectedValue='<%# Bind("LocationCode") %>' AutoPostBack="True" OnSelectedIndexChanged="drpLocations_SelectedIndexChanged">
                                        </asp:DropDownList><asp:ObjectDataSource ID="obsLocations" runat="server" DeleteMethod="Delete" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                                            TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.LocationTableAdapter">
                                            <DeleteParameters>
                                                <asp:Parameter Name="Original_PL_CODIGO" Type="Int32" />
                                            </DeleteParameters>
                                        </asp:ObjectDataSource>
                                        <asp:RequiredFieldValidator ID="rfvLocation" runat="server" ControlToValidate="drpLocations" CssClass="warning" ForeColor="" Display="None" SetFocusOnError="true" ErrorMessage="Location is required" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator></td>

                                </td>

                                <td class="Desc">
                                    <asp:Panel ID="Panel1" runat="server" CssClass="collapsePanelHeader"
                                        Width="100%">
                                        <asp:Label ID="Label7" runat="server" Text="<%$ Resources:Default, CO_LOCATIONS %>"></asp:Label>
                                        &nbsp;<asp:Image ID="Image2" runat="server" AlternateText="ASP.NET AJAX" ImageAlign="Right"
                                            ImageUrl="~/images/down.gif" />
                                    </asp:Panel>
                                </td>
                                <td class="NormalField">

                                    <asp:Panel ID="pnlHiddenCoLocations" runat="server" Width="100%">
                                        <table width="350" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="150" style="height: 79px">
                                                    <asp:ListBox ID="lstCoLocationsAvaiable" runat="server" DataSourceID="obsLocations"
                                                        DataTextField="Description" DataValueField="Code" Font-Names="Verdana" Font-Size="8pt" Width="150px"></asp:ListBox></td>
                                                <td align="center" valign="middle" width="30" style="height: 79px">
                                                    <asp:ImageButton ID="btnMoveToInsertLoc" runat="server" ImageUrl="~/Images/Right.jpg" ValidationGroup="moveToInsertL" OnClick="btnMoveToInsertLoc_Click" CausesValidation="false" />
                                                    <%--<asp:RequiredFieldValidator
                                                            ID="rfvlstCoLocationsAvaiable" runat="server" ControlToValidate="lstCoLocationsAvaiable"
                                                            Display="None" ValidationGroup="Group1" CssClass="warning" ForeColor="" ErrorMessage="Select an item" EnableClientScript="true"></asp:RequiredFieldValidator>--%>
                                                    <br />
                                                    <br />
                                                    <asp:ImageButton ID="btnRemoveLocationProject" runat="server" ImageUrl="~/Images/left.jpg" ValidationGroup="moveToAvaiableL" OnClick="btnRemoveLocationProject_Click" CausesValidation="false" />
                                                    <br />
                                                    <%--<asp:RequiredFieldValidator ID="rfvLstCoLocationInsert" runat="server" ControlToValidate="lstCoLocationsToInsert"
                                                            CssClass="warning" Display="None" ForeColor="" ValidationGroup="Group1" ErrorMessage="Select an item" EnableClientScript="true"></asp:RequiredFieldValidator>--%></td>
                                                <td style="height: 79px">
                                                    <asp:ListBox ID="lstCoLocationsToInsert" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                                        Width="150px"></asp:ListBox></td>
                                            </tr>
                                        </table>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="cpeCoLocations" runat="server" CollapseControlID="Panel1"
                                            Collapsed="True" CollapsedImage="~/images/down.gif" CollapsedText="Edit Co-Responsibles"
                                            ExpandControlID="Panel1" ExpandedImage="~/images/up.gif" ExpandedText=""
                                            ImageControlID="Image2" SuppressPostBack="true" TargetControlID="pnlHiddenCoLocations" EnableViewState="true">
                                        </ajaxToolkit:CollapsiblePanelExtender>
                                    </asp:Panel>

                                </td>

                            </tr>
                            <tr>
                                <td class="DescLeft">
                                    <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="drpResponsibles" ErrorMessage="*" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator> --%><asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label></td>
                                <td class="NormalField">
                                    <asp:Label ID="lblUsername" runat="server"></asp:Label>
                                    <ajax:UpdatePanel ID="updResponsible" runat="server" UpdateMode="Conditional" Visible="False">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="drpResponsibles" runat="server" AutoPostBack="True" DataSourceID="obsResponsibles"
                                                DataTextField="Name" DataValueField="Username" OnDataBound="drpResponsible_DataBound"
                                                OnSelectedIndexChanged="drpResponsibles_SelectedIndexChanged" Width="200px" Enabled="False">
                                            </asp:DropDownList><asp:ObjectDataSource ID="obsResponsibles" runat="server" OldValuesParameterFormatString="original_{0}"
                                                SelectMethod="GetDataByRegion" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
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
                                <td class="Desc">
                                    <asp:Panel ID="pnlCollapsedCoResp" runat="server" CssClass="collapsePanelHeader"
                                        Width="100%">
                                        <asp:Label ID="Label38" runat="server" Text="<%$ Resources:Default, CO_RESPONSIBLE %>"></asp:Label>
                                        &nbsp;<asp:Image ID="Image1" runat="server" AlternateText="ASP.NET AJAX" ImageAlign="Right"
                                            ImageUrl="~/images/down.gif" />
                                    </asp:Panel>
                                </td>
                                <td class="NormalField">
                                    <%-- <ajax:UpdatePanel ID="updCoResponsible" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>--%>
                                    <asp:Panel ID="pnlHiddenCoResp" runat="server" Width="100%">
                                        <table width="350" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td width="150">
                                                    <asp:ListBox ID="lstCoRespsAvaiable" runat="server" DataSourceID="odsCoResponsible"
                                                        DataTextField="Name" DataValueField="Username" Font-Names="Verdana" Font-Size="8pt" Width="150px" OnDataBound="lstCoRespsAvaiable_DataBound"></asp:ListBox></td>
                                                <td align="center" valign="middle" width="30">
                                                    <asp:ImageButton ID="btnMoveCoRespR" runat="server" ImageUrl="~/Images/Right.jpg"
                                                        OnClick="btnMoveCoRespR_Click" ValidationGroup="moveToInsert" CausesValidation="false" />
                                                    <%--<asp:RequiredFieldValidator
                                                                ID="rfvlstCoRespsAvaiable" runat="server" ControlToValidate="lstCoRespsAvaiable"
                                                                Display="None" ValidationGroup="Group1" CssClass="warning" ForeColor="" ErrorMessage="Select an item" EnableClientScript="true"></asp:RequiredFieldValidator>--%><br />
                                                    <br />
                                                    <asp:ImageButton ID="btnMoveCoRespL" runat="server" ImageUrl="~/Images/left.jpg"
                                                        OnClick="btnMoveCoRespL_Click" ValidationGroup="moveToAvaiable" CausesValidation="false" />
                                                    <%--<asp:RequiredFieldValidator ID="rfvlstCoRespsToInsert" runat="server" ControlToValidate="lstCoRespsToInsert"
                                                            Display="None" ValidationGroup="Group1" CssClass="warning" ForeColor="" ErrorMessage="Select an item" EnableClientScript="true"></asp:RequiredFieldValidator>--%><br />
                                                </td>
                                                <td>
                                                    <asp:ListBox ID="lstCoRespsToInsert" runat="server" Font-Names="Verdana" Font-Size="8pt"
                                                        Width="150px"></asp:ListBox></td>

                                            </tr>
                                        </table>
                                        <ajaxToolkit:CollapsiblePanelExtender ID="cpeCoResps" runat="server" CollapseControlID="pnlCollapsedCoResp"
                                            Collapsed="True" CollapsedImage="~/images/down.gif" CollapsedText="Edit Co-Responsibles"
                                            ExpandControlID="pnlCollapsedCoResp" ExpandedImage="~/images/up.gif" ExpandedText=""
                                            ImageControlID="Image1" SuppressPostBack="true" TargetControlID="pnlHiddenCoResp" EnableViewState="true">
                                        </ajaxToolkit:CollapsiblePanelExtender>
                                    </asp:Panel>
                                    <asp:ObjectDataSource ID="odsCoResponsible" runat="server" OldValuesParameterFormatString="original_{0}"
                                        SelectMethod="GetCoResponsiblesByRegion" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="drpRegion" Name="PRE_CODIGO" PropertyName="SelectedValue" Type="Int32" />
                                            <asp:SessionParameter Name="Current" SessionField="UsernameProjectInsert" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>

                                </td>

                            </tr>
                            <tr>
                                <td class="DescLeft">
                                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvCustomer" runat="server" SetFocusOnError="true"
                                        ControlToValidate="drpCustomers" CssClass="warning" ForeColor="" ErrorMessage="Customer is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator></td>
                                <td class="NormalField">
                                    <asp:DropDownList ID="drpCustomers" runat="server" DataSourceID="obsCCustomers" DataTextField="Description"
                                        DataValueField="Code" OnDataBound="drpCategories_DataBound" Width="200px" SelectedValue='<%# Bind("CustomerCode") %>'>
                                    </asp:DropDownList><asp:ObjectDataSource
                                        ID="obsCCustomers" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
                                        OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
                                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.CustomerTableAdapter"
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

                                <td class="Desc">
                                    <asp:Label ID="Label13" runat="server" Text="<%$ Resources:Default, SEGMENT %>"></asp:Label>
                                    <td class="NormalField">
                                        <asp:DropDownList ID="drpSegment" runat="server" DataSourceID="obsSegment" DataTextField="Description"
                                            DataValueField="Code" OnDataBound="drpCategories_DataBound" SelectedValue='<%# Bind("SegmentCode") %>'
                                            Width="200px">
                                        </asp:DropDownList><asp:ObjectDataSource
                                            ID="obsSegment" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetDataByDrop" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SegmentTableAdapter"></asp:ObjectDataSource>
                                        <asp:RequiredFieldValidator ID="rfvSegment" runat="server" ControlToValidate="drpSegment" CssClass="warning" ForeColor="" ErrorMessage="Segment is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator></td>
                                </td>
                            </tr>
                            <tr>
                                <td class="DescLeft">
                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label>
                                </td>
                                <td class="CalendarField">

                                    <uc5:DropDownCalendar ID="ddcOpenDate" runat="server" SelectedDateText='<%# Bind("OpenDate", "{0:d}") %>' />
                                    &nbsp;
                                <asp:RequiredFieldValidator ID="rfvOpenDate" runat="server" ControlToValidate="ddcOpenDate" SetFocusOnError="true"
                                    ErrorMessage="Open date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="Group1">
                                </asp:RequiredFieldValidator>


                                </td>
                                <td class="Desc">
                                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label>
                                </td>
                                <td class="CalendarField">

                                    <uc5:DropDownCalendar ID="ddcCommitDate" runat="server" SelectedDateText='<%# Bind("CommitDate", "{0:d}") %>' />
                                    &nbsp;
                                <asp:RequiredFieldValidator ID="rfvCommitDate" SetFocusOnError="true" runat="server" ControlToValidate="ddcCommitDate" ErrorMessage="Commit date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="Group1">
                                </asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="cmpOpenCommit" runat="server" ControlToCompare="ddcOpenDate"
                                        ControlToValidate="ddcCommitDate" Display="None" ErrorMessage="<%$ Resources:Default, DATA_INF_OPEN_DATE %>"
                                        Operator="GreaterThan" Type="Date" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="Group1"></asp:CompareValidator>

                                </td>
                            </tr>
                            <tr>
                                <td class="DescLeft">

                                    <asp:Label ID="Label1" runat="server" Text="Status"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvStatusCode" runat="server" ControlToValidate="drpStatusCode" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Status is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>

                                </td>
                                <td class="NormalField">

                                    <asp:DropDownList ID="drpStatusCode" runat="server" DataSourceID="obsStatus"
                                        DataTextField="PS_DESCRICAO" DataValueField="PS_CODIGO" OnDataBound="drpStatus_DataBound"
                                        SelectedValue='<%# Bind("StatusCode") %>' Width="200px" OnSelectedIndexChanged="drpStatusCode_SelectedIndexChanged" AutoPostBack="True">
                                    </asp:DropDownList>
                                    <asp:ObjectDataSource ID="obsStatus" runat="server" DeleteMethod="Delete"
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
                                <td class="Desc">

                                    <asp:Label ID="Label3" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label>
                                    <asp:Label ID="lblCloseDateRequired" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>

                                </td>
                                <td class="CalendarField">

                                    <uc5:DropDownCalendar ID="ddcClosedDate" runat="server" SelectedDateText='<%# Bind("ClosedDate", "{0:d}") %>' />
                                    <asp:RequiredFieldValidator ID="rqdClosedDate" runat="server" ControlToValidate="ddcClosedDate" Enabled="False" SetFocusOnError="true" ErrorMessage="Close date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>
                                    <asp:RequiredFieldValidator ID="rqdDropCloseDate" runat="server" ControlToValidate="ddcClosedDate" Enabled="False" SetFocusOnError="true" ErrorMessage="Close date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="GrpDropStatus"></asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="compCommitOpen" runat="server" ControlToCompare="ddcOpenDate"
                                        ControlToValidate="ddcClosedDate" Display="None" ErrorMessage="<%$ Resources:Default, DATA_INF_OPEN_DATE %>" SetFocusOnError="true"
                                        Operator="GreaterThan" Type="Date" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>&nbsp;
                               
                                </td>
                            </tr>
                            <tbody id="tbodyAutomation" runat="server" visible="false">
                                <tr>
                                    <td class="DescLeft" nowrap="nowrap">
                                        <asp:Label ID="Label14" runat="server" Text="Automation Type"></asp:Label>
                                        <a href="#" class="tooltipAutoLevel">
                                            <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton7" ImageUrl="~/Images/help.png" />
                                            <span>Automation Type:
                                            <br>
                                                &nbsp;&nbsp;<b>-Type 1:</b>&nbsp;Connected cells (&lt;50%), e.g. Mix of manual and automated tasks, e.g. manually operated fixture, or tooling with low automation.<br>
                                                &nbsp;&nbsp;<b>-Type 2:</b>&nbsp;Connected lines (50%-75%), e.g. PLC/IPC, robotics, vision, etc. monitoring and control through HMI.<br>
                                                &nbsp;&nbsp;<b>-Type 3:</b>&nbsp;Connected operations (>75%), no touch / minimum human intervention, supervisory control level.<br>
                                                &nbsp;&nbsp;<b>-Type 4:</b>&nbsp;Connected eco-system, cloud, big data, real-time collaboration.<br>
                                                &nbsp;&nbsp;<b>-N/A:</b>&nbsp;Automation projects without deployment in production floor, including research, studies, evaluations, papers, RFQ, etc...                                             
                                            </span>
                                        </a>
                                        <asp:RequiredFieldValidator ID="rfvAutoLevel" runat="server" SetFocusOnError="true" ControlToValidate="drpAutoLevel" CssClass="warning" ForeColor="" ErrorMessage="Automation Type is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>

                                    </td>
                                    <td class="NormalField">

                                        <asp:DropDownList ID="drpAutoLevel" runat="server" Width="200px" OnSelectedIndexChanged="drpAutoLevel_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Text="Select One Option" Value=""></asp:ListItem>
                                            <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                            <%--<asp:ListItem Text="N/A" Value="NA"></asp:ListItem>--%>
                                        </asp:DropDownList>

                                    </td>
                                    <td class="Desc">

                                        <asp:Label ID="lblAutoStage" runat="server" Text="Stage"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvAutoStage" runat="server" SetFocusOnError="true" ControlToValidate="drpAutoStage" CssClass="warning" ForeColor="" ErrorMessage="Stage is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>

                                    </td>
                                    <td class="NormalField">

                                        <asp:DropDownList ID="drpAutoStage" runat="server" Width="200px" OnDataBound="drpAutoStage_DataBound" OnSelectedIndexChanged="drpAutoStage_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Text="Evaluation" Value="Eval"></asp:ListItem>
                                            <asp:ListItem Text="Define" Value="Define"></asp:ListItem>
                                            <asp:ListItem Text="Develop" Value="Develop"></asp:ListItem>
                                            <asp:ListItem Text="Deploy" Value="Deploy"></asp:ListItem>
                                           <%-- <asp:ListItem Text="N/A" Value="N/A"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                </tr>
                                <tr>
                                    <asp:Panel ID="pnlHoldReason" runat="server" Visible="false">
                                         <td class="DescLeft" style="" nowrap="nowrap">
                                        <asp:Label ID="lblHoldReason" runat="server" Text="Hold/Drop Reason"></asp:Label>                                       
                                        <asp:RequiredFieldValidator ID="rfvHoldReason" runat="server" ControlToValidate="txtHoldReason" CssClass="warning" ForeColor="" Display="None" ErrorMessage="Reason is required" EnableClientScript="true" ValidationGroup="GrpHold" SetFocusOnError="true"></asp:RequiredFieldValidator></td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="txtHoldReason" runat="server" Style="width: 90%" onkeyDown="checkTextAreaMaxLength(this,event,'80');" TextMode="MultiLine"></asp:TextBox>&nbsp;&nbsp;&nbsp;                                
                                    </td>
                                    </asp:Panel>
                                </tr>
                            </tbody>
                            <tbody id="tbodyAutomationType" runat="server" visible="false">
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="Label18" runat="server" Text="Automation Category"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvAutoType" runat="server" SetFocusOnError="true" ControlToValidate="drpAutomationType" CssClass="warning" ForeColor="" ErrorMessage="Automation Category is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                    </td>
                                    <td class="NormalField">
                                        <asp:DropDownList ID="drpAutomationType" runat="server" Width="200px">
                                            <asp:ListItem Text="Select One Option" Value=""></asp:ListItem>
                                            <asp:ListItem Text="Generic" Value="Generic"></asp:ListItem>
                                            <asp:ListItem Text="Custom" Value="Custom"></asp:ListItem>                                            
                                            <%--<asp:ListItem Text="Technology Evaluation" Value="Evaluation"></asp:ListItem>
                                            <asp:ListItem Text="Feasibility Study" Value="Study"></asp:ListItem>
                                            <asp:ListItem Text="Project" Value="Project"></asp:ListItem>
                                            <asp:ListItem Text="Paper" Value="Paper"></asp:ListItem>
                                            <asp:ListItem Text="Other" Value="Other"></asp:ListItem>--%>
                                        </asp:DropDownList>
                                    </td>
                                    
                                </tr>
                            </tbody>
                            <tbody id="tbodyOtherAutomation" runat="server" visible="false">
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="Label25" runat="server" Text="Project Life Time (In Months)"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvEstimatedProductLifeinMonths" runat="server" SetFocusOnError="true" ControlToValidate="txtEstimatedProductLifeinMonths" CssClass="warning" ForeColor="" ErrorMessage="Estimated Product Life in Months is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvEstProdLifeMonths" runat="server" ControlToValidate="txtEstimatedProductLifeinMonths"
                                        ValueToCompare="0"  Display="None" ErrorMessage="Estimated Product Life value should be greater than 0" SetFocusOnError="true" Enabled="false"
                                        Operator="GreaterThan" Type="Integer" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>
                                    </td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="txtEstimatedProductLifeinMonths" runat="server" Width="85px"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender4" runat="server"
                                            TargetControlID="txtEstimatedProductLifeinMonths"
                                            FilterType="Custom, Numbers"
                                            ValidChars="" />
                                    </td>
                                    <td class="Desc">
                                        <asp:Label ID="Label20" runat="server" Text="Project Cost"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvAutoProjCost" runat="server" ControlToValidate="txtAutomationProjectCost" SetFocusOnError="true"
                                            CssClass="warning" ForeColor="" ErrorMessage="Project Cost is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvPrjCost" runat="server" ControlToValidate="txtAutomationProjectCost"
                                        ValueToCompare="0"  Display="None" ErrorMessage="Project cost value should be greater than 0" SetFocusOnError="true" Enabled="false"
                                        Operator="GreaterThan" Type="Double" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>
                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="txtAutomationProjectCost" runat="server" Width="85px"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server"
                                            TargetControlID="txtAutomationProjectCost"
                                            FilterType="Custom, Numbers"
                                            ValidChars="." />

                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">

                                        <asp:Label ID="Label26" runat="server" Text="Headcount Before Automation (All Shifts)"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvHeadcountBeforeAutomation" runat="server" SetFocusOnError="true" ControlToValidate="txtHeadcountBeforeAutomation" CssClass="warning" ForeColor="" ErrorMessage="Headcount Before Automation is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvHeadCountBefore" runat="server" ControlToValidate="txtHeadcountBeforeAutomation"
                                        ValueToCompare="0"  Display="None" ErrorMessage="Headcount Before Automation value should be greater than 0" SetFocusOnError="true" Enabled="false"
                                        Operator="GreaterThan" Type="Integer" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>
                                    </td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="txtHeadcountBeforeAutomation" runat="server" Width="85px" onchange="CalculateHeadCount()"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender5" runat="server"
                                            TargetControlID="txtHeadcountBeforeAutomation"
                                            FilterType="Custom, Numbers"
                                            ValidChars="" />
                                    </td>
                                    <td class="Desc">

                                        <asp:Label ID="Label27" runat="server" Text="Headcount After Automation (All Shifts)"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvHeadcountAfterAutomation" runat="server" SetFocusOnError="true" ControlToValidate="txtHeadcountAfterAutomation" CssClass="warning" ForeColor="" ErrorMessage="Headcount After Automation is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>

                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="txtHeadcountAfterAutomation" runat="server" Width="85px" onchange="CalculateHeadCount()"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender6" runat="server"
                                            TargetControlID="txtHeadcountAfterAutomation"
                                            FilterType="Custom, Numbers"
                                            ValidChars="" />

                                    </td>
                                </tr>
                                <tr>
                                        <td class="DescLeft">
                                            <asp:Label ID="lblHeadcountReduction" runat="server" Text="Headcount Reduction"></asp:Label>
                                        </td>
                                        <td class="NormalField">
                                            <asp:TextBox ID="txtHeadcountReduction" runat="server" Width="85px" Enabled="false"></asp:TextBox>
                                        </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblExpectedIRR" runat="server" Text="Expected IRR %"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvIRR" runat="server" ControlToValidate="txtExpectedIRR" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Estimated ROI after end of life is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvExpectedIRR" runat="server" ControlToValidate="txtExpectedIRR"
                                        ValueToCompare="0"  Display="None" ErrorMessage="Expected IRR value should be greater than 0" SetFocusOnError="true" Enabled="false"
                                        Operator="GreaterThan" Type="Double" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>
                                    </td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="txtExpectedIRR" runat="server" Width="85px"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender8" runat="server"
                                            TargetControlID="txtExpectedIRR"
                                            FilterType="Custom, Numbers"
                                            ValidChars="." />
                                    </td>
                                    <td class="Desc">
                                        <asp:Label ID="Label23" runat="server" Text="Planned Payback in Months"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvPlannedPaybackinMonths" runat="server" SetFocusOnError="true" ControlToValidate="txtPlannedPaybackinMonths" CssClass="warning" ForeColor="" ErrorMessage="Planned Payback in Months is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvPlanedPayBack" runat="server" ControlToValidate="txtPlannedPaybackinMonths"
                                        ValueToCompare="0"  Display="None" ErrorMessage="Planned Payback value should be greater than 0" SetFocusOnError="true" Enabled="false"
                                        Operator="GreaterThan" Type="Integer" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>
                                    </td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="txtPlannedPaybackinMonths" runat="server" Width="85px"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender3" runat="server"
                                            TargetControlID="txtPlannedPaybackinMonths"
                                            FilterType="Custom, Numbers"
                                            ValidChars="" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">

                                        <asp:Label ID="Label28" runat="server" Text="Estimated ROI %"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvEstimatedROIafterendoflife" runat="server" SetFocusOnError="true" ControlToValidate="txtEstimatedROIafterendoflife" CssClass="warning" ForeColor="" ErrorMessage="Estimated ROI % is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cvEstROI" runat="server" ControlToValidate="txtEstimatedROIafterendoflife"
                                        ValueToCompare="0"  Display="None" ErrorMessage="Estimated ROI value should be greater than 0" SetFocusOnError="true" Enabled="false"
                                        Operator="GreaterThan" Type="Double" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:CompareValidator>
                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="txtEstimatedROIafterendoflife" runat="server" Width="85px"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender7" runat="server"
                                            TargetControlID="txtEstimatedROIafterendoflife"
                                            FilterType="Custom, Numbers"
                                            ValidChars="." />

                                    </td>
                                    <td class="Desc">

                                        <asp:Label ID="Label21" runat="server" Text="Estimated Reuse %"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvReuse" runat="server" ControlToValidate="txtReuse" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Estimated Reuse % is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>

                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="txtReuse" runat="server" Width="85px"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server"
                                            TargetControlID="txtReuse"
                                            FilterType="Custom, Numbers"
                                            ValidChars="." />

                                    </td>
                                </tr>
                            </tbody>
                            <tbody id="tbodyTestDevelopment" runat="server" visible="false">
                                <tr>
                                    <td class="DescLeft">

                                        <asp:Label ID="Label22" runat="server" Text="Project Cost"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvTDProjCost" runat="server" SetFocusOnError="true" ControlToValidate="txtTestDevelopmentProjectCost" CssClass="warning" ForeColor="" ErrorMessage="Project Cost is required" Display="None"></asp:RequiredFieldValidator>

                                    </td>
                                    <td class="NormalField" colspan="3">
                                        <asp:TextBox ID="txtTestDevelopmentProjectCost" runat="server" Width="85px"></asp:TextBox>
                                    </td>
                                </tr>
                            </tbody>
                            <tbody id="tbodyFinacialInfo" runat="server">
                                <tr>
                                    <td class="DescLeft" align="left">
                                        <asp:Label ID="lblCostSavingRequired" runat="server" CssClass="warning" ForeColor="#B51E17"
                                            Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                        <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label>
                                        <br />
                                        <asp:Label ID="lblTotalSavings" runat="server" />
                                         <asp:TextBox ID ="txtFinancialRqd" runat ="server" Width="0px" Text="1" BackColor="Transparent" BorderStyle="None"></asp:TextBox>                                           
                                         <asp:CustomValidator ID="cvFinancialRqd" runat="server" ClientValidationFunction="ValidateAutomationCostSaving"
                                             ErrorMessage="<%$ Resources:Default, COST_SAVING_REQUIRED %>" EnableClientScript="true" Enabled="false"
                                             ValidationGroup="GrpCloseDeploy" ControlToValidate="txtFinancialRqd" Display="None" ValidateEmptyText="true"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cvPlannedVsActual" runat="server" ClientValidationFunction="ValidateAutomationPlannedVsActual"
                                                ErrorMessage="<%$ Resources:Default, COST_SAVING_MATCH %>" EnableClientScript="true" Enabled="false"
                                                ValidationGroup="GrpCloseDeployPaidBy" ControlToValidate="txtFinancialRqd" Display="None" ValidateEmptyText="true"></asp:CustomValidator>
                                            &nbsp;
                                            &nbsp;<a href="#" class="tooltipExampleOfCostSaving"><asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton4" ImageUrl="~/Images/help.png" />
                                            <span><b>Examples of Financial justification:</b>
                                                <br>
                                                <br>
                                                <img src="../Images/exampleSavingCost.JPG" alt="Example of cost saving" />
                                            </span>
                                        </a>
                                        <asp:ValidationSummary ID="vsInsertCostSaving" runat="server" ValidationGroup="InsertCostSavingGroup" Visible="false" />
                                        <asp:ValidationSummary ID="vsUpdateCostSaving" runat="server" ValidationGroup="UpdateCostSavingGroup" Visible="false" />
                                    </td>
                                    <td class="NormalField" style="text-align: left;" colspan="3">
                                        <asp:GridView ID="grdCostSavings" runat="server" CellPadding="4" ForeColor="#333333" DataKeyNames="CostSavingId"
                                            GridLines="None" Width="297px" AutoGenerateColumns="False" DataSourceID="odsSavings" OnRowUpdating="grdCostSavings_RowUpdating" ShowFooter="True" OnRowDataBound="grdCostSavings_RowDataBound" Height="100px" Style="width: 100%">
                                            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="Black" />
                                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                                            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                                            <EditRowStyle BackColor="#999999" />
                                            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="Automation Saving" Visible="false">
                                                    <ItemTemplate>                                                      
                                                        <asp:Label ID="lblAutomationSaving" runat="server" Text='<%# Bind("AutomationSaving") %>' />
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="drpAutomationSaving" runat="server" DataSourceID="odsAutomationSaving" DataTextField="AutomationSaving" DataValueField="ID" OnDataBound="drpAutomationSaving_DataBound" Width="130px" SelectedValue='<%# Bind("AutomationSavingId") %>' OnSelectedIndexChanged="drpAutomationSaving_SelectedIndexChanged" AutoPostBack="true" />
                                                        <asp:RequiredFieldValidator ID="rfvAutomationSaving" runat="server" SetFocusOnError="true" ErrorMessage="Automation saving is required" ControlToValidate="drpAutomationSaving" InitialValue="0" Display="None" ValidationGroup="UpdateCostSavingGroup" Enabled="false" EnableClientScript="true" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceAutoSaving" runat="server" TargetControlID="rfvAutomationSaving" BehaviorID="b_vceAutoSaving">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </EditItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:DropDownList ID="drpFooterdrpAutomationSaving" runat="server" DataSourceID="odsAutomationSavingFooter" DataTextField="AutomationSaving" DataValueField="ID" OnDataBound="drpAutomationSaving_DataBound" Width="130px" SelectedValue='<%# Bind("AutomationSavingId") %>' OnSelectedIndexChanged="drpAutomationSaving_SelectedIndexChanged" AutoPostBack="true" />
                                                        <asp:RequiredFieldValidator ID="rfvFooterdrpAutomationSaving" runat="server" SetFocusOnError="true" ErrorMessage="Automation saving is required" ControlToValidate="drpFooterdrpAutomationSaving" InitialValue="0" Display="None" ValidationGroup="InsertCostSavingGroup" Enabled="false" EnableClientScript="true" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceFootAutoSav" runat="server" TargetControlID="rfvFooterdrpAutomationSaving" BehaviorID="b_vceFootAutoSav">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </FooterTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField SortExpression="CostSavingId" Visible="False">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblCostSavingId" runat="server" Text='<%# Bind("CostSavingId") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="<%$ Resources:Default, SAVING_TYPE_HEADER %>">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSavingType" runat="server" Text='<%# Bind("SavingType") %>' />
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="drpSavingType" runat="server" DataSourceID="odsSavingType" DataTextField="Description" DataValueField="Code" OnDataBound="drpSavingType_DataBound" Width="130px" SelectedValue='<%# Bind("SavingTypeId") %>' OnSelectedIndexChanged="drpSavingType_SelectedIndexChanged" AutoPostBack="true" />
                                                        <asp:RequiredFieldValidator ID="rfvSavingType" runat="server" SetFocusOnError="true" ErrorMessage="<%$ Resources:Default, SAVING_TYPE_REQUIRED %>" ControlToValidate="drpSavingType" InitialValue="" Display="None" ValidationGroup="UpdateCostSavingGroup" Enabled="false" ForeColor="Black" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceSavingType" runat="server" TargetControlID="rfvSavingType" BehaviorID="b_vceSavingType">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </EditItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:DropDownList ID="drpFooterSavingType" runat="server" DataSourceID="odsSavingType" DataTextField="Description" DataValueField="Code" OnDataBound="drpSavingType_DataBound" Width="130px" SelectedValue='<%# Bind("SavingTypeId") %>' OnSelectedIndexChanged="drpSavingType_SelectedIndexChanged" AutoPostBack="true" />
                                                        <asp:RequiredFieldValidator ID="rfvFooterSavingType" runat="server" SetFocusOnError="true" ErrorMessage="<%$ Resources:Default, SAVING_TYPE_REQUIRED %>" ControlToValidate="drpFooterSavingType" InitialValue="" Display="None" ValidationGroup="InsertCostSavingGroup" Enabled="false" ForeColor="Black" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceFooterSavingType" runat="server" TargetControlID="rfvFooterSavingType" BehaviorID="b_FooterSavingType">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </FooterTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="<%$ Resources:Default, SAVING_CATEGORY_HEADER %>">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSavingCategory" runat="server" Text='<%# Bind("SavingCategory") %>' />
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:DropDownList ID="drpSavingCategory" runat="server" DataSourceID="odsSavingCategory" DataTextField="Description" DataValueField="Code" OnDataBound="drpSavingCategory_DataBound" SelectedValue='<%# Bind("SavingCategoryId") %>' Width="130px" />
                                                        <asp:RequiredFieldValidator ID="rfvSavingCategory" runat="server" SetFocusOnError="true" ErrorMessage="<%$ Resources:Default, SAVING_CATEGORY_REQUIRED %>" ControlToValidate="drpSavingCategory" InitialValue="" Display="None" ValidationGroup="UpdateCostSavingGroup" EnableClientScript="true" Enabled="false" ForeColor="Black" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceSavingCategory" runat="server" TargetControlID="rfvSavingCategory" BehaviorID="b_vceSavingCategory">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </EditItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:DropDownList ID="drpFooterSavingCategory" runat="server" DataSourceID="odsSavingCategory" DataTextField="Description" DataValueField="Code" OnDataBound="drpSavingCategory_DataBound" SelectedValue='<%# Bind("SavingCategoryId") %>' Width="130px" />
                                                        <asp:RequiredFieldValidator ID="rfvFooterSavingCategory" runat="server" SetFocusOnError="true" ErrorMessage="<%$ Resources:Default, SAVING_CATEGORY_REQUIRED %>" ControlToValidate="drpFooterSavingCategory" InitialValue="" Display="None" ValidationGroup="InsertCostSavingGroup" EnableClientScript="true" Enabled="false" ForeColor="Black" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceFooterSavingCategory" runat="server" TargetControlID="rfvFooterSavingCategory" BehaviorID="b_vceFooterSavingCategory">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </FooterTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="<%$ Resources:Default, DATE_HEADER %>">
                                                    <ItemTemplate>
                                                        <div style="width: 150px">
                                                            <asp:Label ID="lblDate" runat="server" Text='<%# Bind("Date", "{0:d}") %>' />
                                                        </div>
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <uc5:DropDownCalendar ID="ddcDate" runat="server" SelectedDateText='<%# Bind("DateString") %>' />
                                                        <asp:RequiredFieldValidator ID="rfvDate" runat="server" SetFocusOnError="true" ErrorMessage="<%$ Resources:Default, DATE_REQUIRED %>" ControlToValidate="ddcDate" InitialValue="" Display="None" ValidationGroup="UpdateCostSavingGroup" EnableClientScript="true" Enabled="false" ForeColor="Black" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceDate" runat="server" TargetControlID="rfvDate" BehaviorID="b_vceDate">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </EditItemTemplate>
                                                    <FooterTemplate>
                                                        <ajax:UpdatePanel ID="updFooterDate" runat="server" UpdateMode="Conditional">
                                                            <ContentTemplate>
                                                                <uc5:DropDownCalendar ID="ddcFooterDate" runat="server" SelectedDateText='<%# Bind("DateString") %>' />
                                                            </ContentTemplate>
                                                        </ajax:UpdatePanel>
                                                        <asp:RequiredFieldValidator ID="rfvFooterDate" runat="server" SetFocusOnError="true" ErrorMessage="<%$ Resources:Default, DATE_REQUIRED %>" ControlToValidate="ddcFooterDate" InitialValue="" Display="None" ValidationGroup="InsertCostSavingGroup" EnableClientScript="true" Enabled="false" ForeColor="Black" />
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceFooterDate" runat="server" TargetControlID="rfvFooterDate" BehaviorID="b_vceFooterDate">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </FooterTemplate>
                                                    <ControlStyle Width="150px" />
                                                    <FooterStyle Width="150px" />
                                                    <HeaderStyle Width="150px" />
                                                    <ItemStyle Width="150px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="<%$ Resources:Default, SAVING_AMOUNT_HEADER %>">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSavingAmount" runat="server" Text='<%# Bind("SavingAmount", "{0:c}") %>' Width="35px" />
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="txtSavingAmount" runat="server" Text='<%# Bind("SavingAmount", "{0:#.00}") %>' Width="35px" />
                                                        <asp:RegularExpressionValidator ID="revSavingAmt" runat="server" SetFocusOnError="true" ControlToValidate="txtSavingAmount" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_INVALID %>" ValidationGroup="UpdateCostSavingGroup" ValidationExpression="(^[0-9]+([.][0-9]{1,2}){0,1}$)" Display="None" CssClass="warning" ForeColor="Black" EnableClientScript="true" Enabled="false"></asp:RegularExpressionValidator>
                                                        <asp:RequiredFieldValidator ID="rfvSavingAmount" runat="server" SetFocusOnError="true" ControlToValidate="txtSavingAmount" CssClass="warning" Display="None" ValidationGroup="UpdateCostSavingGroup" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_REQUIRED %>" ForeColor="Black" EnableClientScript="true" Enabled="false"></asp:RequiredFieldValidator>
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vceSavingAmt" runat="server" TargetControlID="revSavingAmt" BehaviorID="b_vceSavingAmt">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vcerfvSavingAmount" runat="server" TargetControlID="rfvSavingAmount" BehaviorID="b_vcerfvSavingAmount">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </EditItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:TextBox ID="txtFooterSavingAmount" runat="server" Text='<%# Bind("SavingAmount") %>' Width="60px" />
                                                        <asp:RegularExpressionValidator ID="revFootSavAmt" runat="server" SetFocusOnError="true" ControlToValidate="txtFooterSavingAmount" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_INVALID %>" ValidationGroup="InsertCostSavingGroup" ValidationExpression="(^[0-9]+([.][0-9]{1,2}){0,1}$)" Display="None" CssClass="warning" ForeColor="Black" EnableClientScript="true" Enabled="false"></asp:RegularExpressionValidator>
                                                        <asp:RequiredFieldValidator ID="rfvFooterSavingAmount" runat="server" SetFocusOnError="true" ControlToValidate="txtFooterSavingAmount" CssClass="warning" Display="None" ValidationGroup="InsertCostSavingGroup" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_REQUIRED %>" ForeColor="Black" EnableClientScript="true" Enabled="false"></asp:RequiredFieldValidator>
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vcerevFootSavAmt" runat="server" TargetControlID="revFootSavAmt" BehaviorID="b_vcerevFootSavAmt">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                        <ajaxToolkit:ValidatorCalloutExtender ID="vcerfvFooterSavingAmount" runat="server" TargetControlID="rfvFooterSavingAmount" BehaviorID="b_vcerfvFooterSavingAmount">
                                                        </ajaxToolkit:ValidatorCalloutExtender>
                                                    </FooterTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:ImageButton ImageUrl="~/Images/EditProject.gif" ToolTip="Edit Cost Saving" ID="btnEdit" runat="server" CommandName="Edit" CausesValidation="false" />
                                                    </ItemTemplate>
                                                    <EditItemTemplate>
                                                        <div style="width: 50px">
                                                            <asp:ImageButton ImageUrl="~/Images/button_save.gif" ToolTip="Update Cost Saving" ID="btnUpdate" runat="server" CommandName="Update" ValidationGroup="UpdateCostSavingGroup" />
                                                            <asp:ImageButton ImageUrl="~/Images/cancel.gif" ToolTip="Cancel Editing" ID="btnCancel" runat="server" CommandName="Cancel" CausesValidation="false" />
                                                        </div>
                                                    </EditItemTemplate>
                                                    <FooterTemplate>
                                                        <asp:ImageButton ImageUrl="~/Images/add.png" ToolTip="Add Cost Saving" ID="btnAdd" runat="server" CommandName="AddCostSaving" ValidationGroup="InsertCostSavingGroup" OnClick="btnAdd_Click" OnClientClick="javascript:return EnableCostSavingButton();" />
                                                    </FooterTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:ImageButton ImageUrl="~/Images/delete.gif" ToolTip="Delete Cost Saving" ID="btnDelete" runat="server" CommandName="Delete" CausesValidation="false" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                        <asp:ObjectDataSource
                                            ID="odsSavingType" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SavingTypeTableAdapter" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
                                            <DeleteParameters>
                                                <asp:Parameter Name="Original_PV_CODIGO" Type="Int32" />
                                            </DeleteParameters>
                                            <UpdateParameters>
                                                <asp:Parameter Name="PV_ABBREVIATION" Type="String" />
                                                <asp:Parameter Name="PV_DESCRIPTION" Type="String" />
                                                <asp:Parameter Name="Original_PV_CODIGO" Type="Int32" />
                                            </UpdateParameters>
                                            <InsertParameters>
                                                <asp:Parameter Name="PV_ABBREVIATION" Type="String" />
                                                <asp:Parameter Name="PV_DESCRIPTION" Type="String" />
                                            </InsertParameters>
                                        </asp:ObjectDataSource>
                                        <asp:ObjectDataSource
                                            ID="odsSavingCategory" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetData" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SavingCategoryTableAdapter" />
                                        <asp:ObjectDataSource ID="odsSavings" runat="server" DeleteMethod="DeleteCostSaving" ConflictDetection="OverwriteChanges" InsertMethod="InsertCostSaving" SelectMethod="GetAllCostSaving" TypeName="ProjectTracker.Business.CostSavingDataSource" DataObjectTypeName="ProjectTracker.Business.CostSaving" UpdateMethod="UpdateCostSaving" OnSelected="odsSavings_Selected" OldValuesParameterFormatString="original_{0}"></asp:ObjectDataSource>
                                        <asp:ObjectDataSource ID="odsAutomationSaving" runat="server" TypeName="ProjectTracker.Business.AutomationSaving" SelectMethod="GetData"></asp:ObjectDataSource>
                                        <asp:ObjectDataSource ID="odsAutomationSavingFooter" runat="server" TypeName="ProjectTracker.Business.AutomationSaving" SelectMethod="GetFooterData" OnSelecting="odsAutomationSavingFooter_Selecting">
                                                <SelectParameters>
                                                    <asp:Parameter Name="cStatus" Type="string" />
                                                </SelectParameters>
                                            </asp:ObjectDataSource>
                                    </td>                                    
                                </tr>
                            </tbody>                            
                            <tbody id="tbodyOpenDevelop" runat="server" style="display: none;">
                                <tr>
                                    <%--<td class="DescLeft">
                                        <asp:Label ID="lblCapexAppd" runat="server" Text="Capex Approved"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:RadioButtonList ID="rblCapexAppd" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Font-Bold="true" onclick="ShowCapexDate();">
                                            <asp:ListItem Value="Y">Yes</asp:ListItem>
                                            <asp:ListItem Value="N">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                        <asp:RequiredFieldValidator ID="rfvCapexAppd" runat="server" SetFocusOnError="true" ControlToValidate="rblCapexAppd" ErrorMessage="Select Capex Approval" ForeColor="" ValidationGroup="GrpOpenDevelop" EnableClientScript="true" Display="None" Enabled="false"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="cvCapexAppd" runat="server" SetFocusOnError="true" ClientValidationFunction="ValidateCapexApproval"
                                            ErrorMessage="<%$ Resources:Default, CAPEX_APPROVAL %>" EnableClientScript="true" Enabled="false"
                                            ValidationGroup="GrpOpenDevelop" ControlToValidate="rblCapexAppd" Display="None"></asp:CustomValidator>
                                    </td>--%>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblPOIssued" runat="server" Text="PO Issued"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:RadioButtonList ID="rblPOIssued" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Font-Bold="true" onclick="ShowCapexDate();">
                                            <asp:ListItem Value="Y">Yes</asp:ListItem>
                                            <asp:ListItem Value="N">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                        <asp:RequiredFieldValidator ID="rfvPOIssued" runat="server" SetFocusOnError="true" ControlToValidate="rblPOIssued" Enabled="false" ErrorMessage="Select an option for PO Issued" ForeColor="" ValidationGroup="GrpOpenDevelop" EnableClientScript="true" Display="None"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="cvPOIssued" runat="server" ClientValidationFunction="ValidatePOApproval"
                                            ErrorMessage="<%$ Resources:Default, PO_APPROVAL %>" EnableClientScript="true" Enabled="false"
                                            ValidationGroup="GrpOpenDevelop" ControlToValidate="rblPOIssued" Display="None"></asp:CustomValidator>
                                    </td>
                                    <td class="Desc" id="tdlblPoAppvdDate" runat="server" style="display: none;">
                                            <asp:Label ID="lblCapexAppvdDate" runat="server" Text="<%$ Resources:Default, CAPEX_DATE %>"></asp:Label>
                                        </td>
                                        <td class="NormalField" id="tdPoAppvdDate" runat="server" style="display: none;">
                                            <asp:TextBox ID="ddcCapexAppvdDate" runat="server" Width="100px" CausesValidation="true" Text=""></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender ID="ddcCapexAppvdDate_CalendarExtender" runat="server" Enabled="True"
                                                TargetControlID="ddcCapexAppvdDate" Format="MM/dd/yyyy" PopupPosition="BottomRight">
                                            </ajaxToolkit:CalendarExtender>
                                            <asp:RequiredFieldValidator ID="rfvCapexAppvdDate" runat="server" ControlToValidate="ddcCapexAppvdDate" Enabled="False" SetFocusOnError="true" ErrorMessage="PO Approval date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="GrpOpenDevelopCapexDate"></asp:RequiredFieldValidator>
                                        </td>
                                </tr>
                                <%--<tbody id="tbodyCapexAppvdDate" runat="server" style="display: none;">
                                    <tr>
                                        <td class="DescLeft">
                                            <asp:Label ID="lblCapexAppvdDate" runat="server" Text="<%$ Resources:Default, CAPEX_DATE %>"></asp:Label>                                            
                                        </td>
                                        <td class="NormalField">
                                            <asp:TextBox ID="ddcCapexAppvdDate" runat="server" Width="100px" CausesValidation="true" Text=""></asp:TextBox>
                                            <ajaxToolkit:CalendarExtender ID="ddcCapexAppvdDate_CalendarExtender" runat="server" Enabled="True"
                                                TargetControlID="ddcCapexAppvdDate" Format="MM/dd/yyyy" PopupPosition="BottomRight">
                                            </ajaxToolkit:CalendarExtender>
                                            <asp:RequiredFieldValidator ID="rfvCapexAppvdDate" runat="server" ControlToValidate="ddcCapexAppvdDate" Enabled="False" SetFocusOnError="true" ErrorMessage="Capex Approval date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="GrpOpenDevelopCapexDate"></asp:RequiredFieldValidator>
                                            
                                        </td>
                                    </tr>
                                </tbody>--%>
                            </tbody>
                            <tbody id="tbodyPaidbyInfo" runat="server" style="display: none;">
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblPaidFlex" runat="server" Text="Paid by"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:RadioButtonList ID="rblPaidFlex" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Font-Bold="true" OnSelectedIndexChanged="rblPaidFlex_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Value="F">Flex</asp:ListItem>
                                            <asp:ListItem Value="C">Customer</asp:ListItem>
                                        </asp:RadioButtonList>
                                        <asp:RequiredFieldValidator ID="rfvPaidFlex" runat="server" ControlToValidate="rblPaidFlex" SetFocusOnError="true" Enabled="false" ErrorMessage="Payment source is required" ForeColor="" ValidationGroup="GrpOpenDevelop" EnableClientScript="true" Display="None"></asp:RequiredFieldValidator>
                                    </td>
                                    <td class="Desc">
                                        <asp:Label ID="lblPrjNumber" runat="server" Text="eCPX Number"></asp:Label>
                                        <asp:Label ID="lblRfvPrjNumber" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                            <div style="border: solid 1px black; text-align: left; width: 185px; background-color: white;">
                                                <span>&nbsp;eCPX</span><asp:TextBox ID="txtPrjNumber" runat="server" BorderWidth="0" Width="150px" MaxLength="10"></asp:TextBox>
                                            </div>
                                            <ajaxToolkit:FilteredTextBoxExtender ID="ftbTxtPrjNumber" runat="server"
                                                TargetControlID="txtPrjNumber"
                                                FilterType="Numbers" />
                                            <ajaxToolkit:TextBoxWatermarkExtender ID="wmtxtPrjNumber" runat="server" TargetControlID="txtPrjNumber" Enabled="true"
                                                WatermarkText="Enter 10 digit number" WatermarkCssClass="watermarked" />
                                            <asp:RequiredFieldValidator ID="rfvPrjNumber" runat="server" Enabled="false" SetFocusOnError="true" ControlToValidate="txtPrjNumber" CssClass="warning" ForeColor="" ErrorMessage="eCPX Number is required" Display="None" EnableClientScript="true" ValidationGroup="GrpOpenDevelopConditional"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="regexValPrjNumber" ValidationGroup="GrpOpenDevelopConditional" Display="None" SetFocusOnError="true"
                                                ControlToValidate="txtPrjNumber" runat="server" CssClass="warning" ForeColor="" ErrorMessage="eCPX Number should be 10 digits"  EnableClientScript="true" ValidationExpression="^\d{10}$"></asp:RegularExpressionValidator>
                                        </td>
                            </tbody>
                            <tbody id="tbodyCloseInfo" runat="server" visible="false">
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblCloseReason" runat="server" Text="Close Reason"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:DropDownList ID="drpCloseInfo" runat="server" OnDataBound="drpCloseInfo_DataBound" OnSelectedIndexChanged="drpCloseInfo_SelectedIndexChanged" AutoPostBack="true">
                                            <asp:ListItem Text="Customer did not Approve" Value="CNA"></asp:ListItem>
                                            <asp:ListItem Text="Site did not Approve" Value="SNA"></asp:ListItem>
                                            <asp:ListItem Text="Others" Value="OTH"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvCloseInfo" runat="server" ControlToValidate="drpCloseInfo" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Close reason is required" Display="None" EnableClientScript="true" ValidationGroup="GrpClosed"></asp:RequiredFieldValidator>
                                    </td>
                                    <td class="NormalField" colspan="3" id="tdCloseOther" runat="server" visible="false">
                                        <asp:TextBox ID="txtCloseOther" runat="server" Style="width: 90%" onkeyDown="checkTextAreaMaxLength(this,event,'80');" TextMode="MultiLine"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                                    <asp:RequiredFieldValidator ID="rfvCloseOther" runat="server" ControlToValidate="txtCloseOther" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Close reason is required" Display="None" EnableClientScript="true" ValidationGroup="GrpClosedOther"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </tbody>
                            <tbody id="tbodyCloseDeployOther" runat="server" visible="false">
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblOnePageSumm" runat="server" Text="One Page Summary Link Field"></asp:Label>
                                        <a href="#" class="tooltipEngReportLink">
                                                <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="imgOnePageSumHelp" ImageUrl="~/Images/help.png" />
                                                <span>e.g. http://intranet.flextronics.com/go/GOEng/AC%20Product%20Showcase/Forms/AllItems.aspx </span>
                                            </a>
                                        <asp:Label ID="lblRfvOnePageLink" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField" colspan="3">
                                        <asp:TextBox ID="txtOnePageSummary" runat="server" Width="650px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvOnePageSummary" runat="server" ControlToValidate="txtOnePageSummary" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="One Page Summary Link is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblReturnInvest" runat="server" Text="Return On Investment Link"></asp:Label>
                                        <a href="#" class="tooltipROILink">
                                                <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="imgROIHelp" ImageUrl="~/Images/help.png" />
                                                <span>e.g. https://flextronics365.sharepoint.com/sites/aeg/autmnctrls/Automation%20Project%20Tracker%20ROIs/Forms/AllItems.aspx </span>
                                        </a>
                                        <asp:Label ID="lblRfvROILink" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField" colspan="3">
                                        <asp:TextBox ID="txtReturnInvest" runat="server" Width="650px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvReturnInvest" runat="server" ControlToValidate="txtReturnInvest" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Return on Investment Link is required is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="lblVideoLink" runat="server" Text="Video Link"></asp:Label>
                                        <a href="#" class="tooltipVideoLink">
                                                <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="imgVideoLnkHelp" ImageUrl="~/Images/help.png" />
                                                <span>e.g. http://intranet.flextronics.com/go/GOEng/EngineeringReports/Forms/AllItems.aspx?View={F3EE7A1A-8CA4-4786-92E7-5DDDFCB7D162}&FilterField1=Category&FilterValue1=Automation </span>
                                        </a>
                                        <asp:Label ID="lblrfvVideoLnk" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField" colspan="3">
                                        <asp:TextBox ID="txtVideoLink" runat="server" Width="650px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvVideoLink" runat="server" ControlToValidate="txtVideoLink" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Video Link is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                            </tbody>
                            <tr>
                                <td class="DescLeft" nowrap="nowrap">
                                    <asp:Label ID="Label10" runat="server" Text="Eng. Report #"></asp:Label>
                                    <a href="#" class="tooltipEngReportNo">
                                        <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton5" ImageUrl="~/Images/help.png" />
                                        <span>Mandatory for closed project e.g. Eng_2000
                                        </span>
                                    </a>
                                    <asp:Label ID="lblEngRepNumRequired" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                </td>
                                <td class="NormalField" colspan="3">
                                    <asp:TextBox ID="TextBox1" runat="server" MaxLength="150" Text='<%# Bind("eRoom") %>' Width="225px" />
                                     <ajaxToolkit:FilteredTextBoxExtender ID="fbtbEngrepNum" runat="server"
                                                TargetControlID="TextBox1"
                                                FilterType="Numbers" />
                                    <asp:RequiredFieldValidator ID="rqdEngRepNum" runat="server" ControlToValidate="TextBox1" SetFocusOnError="true" Enabled="false" CssClass="warning" Display="None" ErrorMessage="Eng. Report # is required" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="DescLeft" style="width: 150px" nowrap="nowrap">

                                    <asp:Label ID="Label8" runat="server" Text="Eng.Report Link"></asp:Label>
                                    <a href="#" class="tooltipEngReportLink">
                                        <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton6" ImageUrl="~/Images/help.png" />
                                        <span>e.g. http://intranet.flextronics.com/go/GOEng/EngineeringReports/ssue_R2.pptx
                                        </span>
                                    </a>
                                    <asp:Label ID="lblrfvEngReportLink" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvEngReportLink" runat="server" ControlToValidate="txtEngReportLink" SetFocusOnError="true" Enabled="false" CssClass="warning" Display="None" ErrorMessage="Eng.Report Link is required" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>

                                </td>
                                <td class="NormalField" colspan="3">
                                    <asp:TextBox ID="txtEngReportLink" runat="server" Width="650px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <table>
                                        <tr>
                                            <td class="DescLeft" nowrap="nowrap">

                                                <asp:Label ID="Label9" runat="server" Text="Can a patent or IP(Intellectual Property) be generated from this project?" Width="430px"></asp:Label>
                                                <asp:Label ID="lblrfvIP" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>

                                            </td>
                                            <td class="Desc">
                                                <asp:RadioButton ID="rdoIPYes" onclick="changeIP(this);" runat="server" Text="Yes" GroupName="rdoGrpIP" />
                                                <asp:RadioButton ID="rdoIPNo" onclick="changeIP(this);" runat="server" Text="No" GroupName="rdoGrpIP" />
                                                <asp:TextBox ID="hdfrfvIP" runat="server" Style="text-align: right; width: 0px; border: 0px  #BBBBBB; background: rgb(230, 230, 230); color: rgb(230, 230, 230);"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvIP" runat="server" ControlToValidate="hdfrfvIP" Enabled="false" SetFocusOnError="true" CssClass="warning" Display="None" ErrorMessage="Intellectual Property is required" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tbody id="tbodyBestPractice" runat="server" style="display: none;">
                                <tr>
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td class="DescLeft" style="width: 430px" nowrap="nowrap">
                                                    <asp:Label ID="Label52" runat="server" Text="Can a Best Practice be generated from this project?"></asp:Label>
                                                       <a href="#" class="tooltipRemarks">
                                                            <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton8" ImageUrl="~/Images/help.png" />
                                                            <span>1. A Best Practice would be a process / systemic improvement over existing ones at sites. This improved process / systemic improvement will lead to enhanced output (higher productivity, quality, flexibility, customer satisfaction, etc.).
                                                            <br /><br />
                                                                  2. A Best Practice being shared needs to be repeatable and scalable. Some home-grown / site-specific best practices use specific software / programming that cannot be copied or scaled to other sites, please ensure repeatability and scalability.
                                                            <br /><br />
                                                                  3. Every Best Practice needs to have a go-to-person/ SME and also an alternate contact, to provide for SME going on vacation.
                                                            <br /><br />
                                                                  4. If the savings from implementing a Best Practice needs to be captured in some special way, same needs to be explained while sharing the Best Practice.
                                                            </span>
                                                        </a>
                                                    <asp:Label ID="lblrfvBestPractice" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                                </td>
                                                <td class="Desc">
                                                    <asp:RadioButtonList ID="rblBestPractice" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Font-Bold="true" onclick="ShowBestPracticeComment();">
                                                    <asp:ListItem Value="Y">Yes</asp:ListItem>
                                                    <asp:ListItem Value="N">No</asp:ListItem>
                                                    </asp:RadioButtonList>
                                                    <asp:RequiredFieldValidator ID="rfvrblBestPractice" runat="server" SetFocusOnError="true" ControlToValidate="rblBestPractice" ErrorMessage="Best Practice selection is required" ForeColor="" ValidationGroup="GrpClosedStatus" EnableClientScript="true" Display="None" Enabled="false"></asp:RequiredFieldValidator>                                                    
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td colspan="2" class="NormalField" id="tdBPComment" runat="server" style="display: none;">
                                        <asp:TextBox Style="width: 100%" ID="txtBPComment" runat="server" Height="25px" TextMode="MultiLine" onkeyDown="checkTextAreaMaxLength(this,event,'150');"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvtxtBPComment" runat="server" SetFocusOnError="true" ControlToValidate="txtBPComment" ErrorMessage="Best Practice Comment is required" ForeColor="" ValidationGroup="GrpClosedBestPractice" EnableClientScript="true" Display="None" Enabled="false"></asp:RequiredFieldValidator>
                                        <ajaxToolkit:TextBoxWatermarkExtender ID="txtwmextBpComment" runat="server" TargetControlID="txtBPComment" Enabled="true"
                                            WatermarkText="Please write a brief description of the Best Practice" WatermarkCssClass="watermarked" />
                                        <asp:CustomValidator ID="cvBpComment" runat="server" ClientValidationFunction="CheckMinLength"
                                                ErrorMessage="Description should have minimum of 50 Characters" EnableClientScript="true" Enabled="false"
                                                ValidationGroup="GrpClosedBestPractice" ControlToValidate="txtBPComment" Display="None"></asp:CustomValidator>
                                    </td>
                                </tr>
                             </tbody>                              
                            <tr>
                                <td class="DescLeft">
                                    <asp:Label ID="Label11" runat="server" Text="<%$ Resources:Default, PERCENT_COMPLETION %>"></asp:Label>
                                </td>
                                <td class="NormalField">
                                    <asp:TextBox ID="txtPercentCompletion" runat="server" Text='<%# Bind("PercentCompletion") %>' Width="85px" MaxLength="3"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvPercentCompletion" runat="server" ControlToValidate="txtPercentCompletion" SetFocusOnError="true" CssClass="warning" Display="None" ErrorMessage="Progress is required." ForeColor="" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="revInvalidNotClosedProgressValue" EnableClientScript="true" runat="server" SetFocusOnError="true" ControlToValidate="txtPercentCompletion" ErrorMessage="Progress value is invalid." ValidationExpression="(^(([0-9]{1,2}([.][0-9]{1,2}){0,1})|([1][0][0]([.][0]{1,2}){0,1}))$)" CssClass="warning" ForeColor="" Display="None" ValidationGroup="Group1"></asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="revInvalidClosedProgressValue" EnableClientScript="true" runat="server" SetFocusOnError="true" ControlToValidate="txtPercentCompletion" ErrorMessage="Progress value is invalid." ValidationExpression="(^([1][0][0]([.][0]{1,2}){0,1})$)" CssClass="warning" ForeColor="" Display="None" ValidationGroup="Group1"></asp:RegularExpressionValidator>
                                    <asp:Label ID="Label12" runat="server" Text="###" />
                                    <ajaxToolkit:FilteredTextBoxExtender ID="fbtbPerComp" runat="server"
                                                TargetControlID="txtPercentCompletion"
                                                FilterType="Numbers" />
                                </td>
                            </tr>
                            <tr>
                                <td class="DescLeft">
                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label>
                                    <a href="#" class="tooltipRemarks">
                                        <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton3" ImageUrl="~/Images/help.png" />
                                        <span>For Example:<br>
                                            &nbsp;&nbsp;&nbsp;<b>-Purpose:</b>
                                            <br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Cost Savings & EHS Compliance
                                <br>
                                            &nbsp;&nbsp;&nbsp;<b>Target:</b>
                                            <br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Wave pallet cleaning process is compliant with EHS requirement;<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Around US$240K/ year for Zhuhai<br>
                                            &nbsp;&nbsp;&nbsp;<b>How:</b>
                                            <br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Apply a Survey<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Define technical spec for cleaning solvent (water base);<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Qualify sample<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Deploy the process to wave pallet cleaning.
                                <br>
                                            &nbsp;&nbsp;&nbsp;<b>Challenges:</b>
                                            <br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Ultrasonic cleaning machine investment<br>
                                            &nbsp;&nbsp;&nbsp;<b>Current Progress:</b>
                                            <br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Survey applied<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Specs have been defined<br>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Qualified sample succesfully
                                        </span>
                                    </a>
                                </td>
                                <td colspan="3" class="NormalField">
                                    <asp:TextBox ID="txtRemarks" runat="server" Height="100px" Style="width: 100%" Text="Purpose:

How:

Challenges:

Progress:"
                                        TextMode="MultiLine"></asp:TextBox>
                                </td>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceRegion" runat="server" TargetControlID="rfvRegion" BehaviorID="b_vceRegion">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCategory" runat="server" TargetControlID="rfvCategory" BehaviorID="b_vceCategory">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceDesc" runat="server" TargetControlID="rqdDescription" BehaviorID="b_vceDesc">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceLocation" runat="server" TargetControlID="rfvLocation" BehaviorID="b_vceLocation">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCustomer" runat="server" TargetControlID="rfvCustomer" BehaviorID="b_vceCustomer">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceSegment" runat="server" TargetControlID="rfvSegment" BehaviorID="b_vceSegment">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceOpenDate" runat="server" TargetControlID="rfvOpenDate" BehaviorID="b_vceOpenDate">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCommitDate" runat="server" TargetControlID="rfvCommitDate" BehaviorID="b_vceCommitDate">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCmpval" runat="server" TargetControlID="cmpOpenCommit" BehaviorID="b_vceCmpval">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceStatusCode" runat="server" TargetControlID="rfvStatusCode" BehaviorID="b_vceStatusCode">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceClosedDate" runat="server" TargetControlID="rqdClosedDate" BehaviorID="b_vceClosedDate">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceDropCloseDate" runat="server" TargetControlID="rqdDropCloseDate" BehaviorID="b_vceDropCloseDate">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcecmpCommitOpen" runat="server" TargetControlID="compCommitOpen" BehaviorID="b_vcecmpCommitOpen">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceAutoStage" runat="server" TargetControlID="rfvAutoStage" BehaviorID="b_vceAutoStage">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceAutoLevel" runat="server" TargetControlID="rfvAutoLevel" BehaviorID="b_vceAutoLevel">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceAutoType" runat="server" TargetControlID="rfvAutoType" BehaviorID="b_vceAutoType">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceEstProdLife" runat="server" TargetControlID="rfvEstimatedProductLifeinMonths" BehaviorID="b_vceEstProdLife">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceAutoPrj" runat="server" TargetControlID="rfvAutoProjCost" BehaviorID="b_vceAutoPrj">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceHCBefore" runat="server" TargetControlID="rfvHeadcountBeforeAutomation" BehaviorID="b_vceHCBefore">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceHCAfter" runat="server" TargetControlID="rfvHeadcountAfterAutomation" BehaviorID="b_vceHCAfter">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceIRR" runat="server" TargetControlID="rfvIRR" BehaviorID="b_vceIRR">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePayBack" runat="server" TargetControlID="rfvPlannedPaybackinMonths" BehaviorID="b_vcePayBack">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceEstROI" runat="server" TargetControlID="rfvEstimatedROIafterendoflife" BehaviorID="b_vceEstROI">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceReuse" runat="server" TargetControlID="rfvReuse" BehaviorID="b_vceReuse">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePrjNumner" runat="server" TargetControlID="rfvPrjNumber" BehaviorID="b_vcePrjNumner">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCloseInfo" runat="server" TargetControlID="rfvCloseInfo" BehaviorID="b_vceCloseInfo">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCloseOther" runat="server" TargetControlID="rfvCloseOther" BehaviorID="b_vceCloseOther">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceOnePage" runat="server" TargetControlID="rfvOnePageSummary" BehaviorID="b_vceOnePage">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceReturnInvest" runat="server" TargetControlID="rfvReturnInvest" BehaviorID="b_vceReturnInvest">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceVideo" runat="server" TargetControlID="rfvVideoLink" BehaviorID="b_vceVideo">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceIP" runat="server" TargetControlID="rfvIP" BehaviorID="b_vceIP">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceEngRepNum" runat="server" TargetControlID="rqdEngRepNum" BehaviorID="b_vceEngRepNum">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceEngLink" runat="server" TargetControlID="rfvEngReportLink" BehaviorID="b_vceEngLink">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceNotProgress" runat="server" TargetControlID="revInvalidNotClosedProgressValue" BehaviorID="b_vceNotProgress">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceProgress" runat="server" TargetControlID="revInvalidClosedProgressValue" BehaviorID="b_vceProgress">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePercentComp" runat="server" TargetControlID="rfvPercentCompletion" BehaviorID="b_vcePercentComp">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceHoldReason" runat="server" TargetControlID="rfvHoldReason" BehaviorID="b_vceHoldReason">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <%--<ajaxToolkit:ValidatorCalloutExtender ID="vceCapex" runat="server" TargetControlID="rfvCapexAppd" BehaviorID="b_vceCapex">
                                </ajaxToolkit:ValidatorCalloutExtender>--%>

                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCapexAppvdDate" runat="server" TargetControlID="rfvCapexAppvdDate" BehaviorID="b_vceCapexAppvdDate">
                                    </ajaxToolkit:ValidatorCalloutExtender>

                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePoIssued" runat="server" TargetControlID="rfvPOIssued" BehaviorID="b_vcePoIssued">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePaidFlex" runat="server" TargetControlID="rfvPaidFlex" BehaviorID="b_vcePaidFlex">
                                </ajaxToolkit:ValidatorCalloutExtender>                               
                               <%-- <ajaxToolkit:ValidatorCalloutExtender ID="vceCVCapex" runat="server" TargetControlID="cvCapexAppd" BehaviorID="b_vceCVCapex">
                                </ajaxToolkit:ValidatorCalloutExtender>--%>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceCVPOIssued" runat="server" TargetControlID="cvPOIssued" BehaviorID="b_vceCVPOIssued">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                 <ajaxToolkit:ValidatorCalloutExtender ID="vceRegExpPrjNum" runat="server" TargetControlID="regexValPrjNumber" BehaviorID="b_vceRegexValPrjNumber">
                                 </ajaxToolkit:ValidatorCalloutExtender>
                                 <ajaxToolkit:ValidatorCalloutExtender ID="vceEstProdLifeComp" runat="server" TargetControlID="cvEstProdLifeMonths" BehaviorID="b_vceEstProdLifeComp">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePrjCost" runat="server" TargetControlID="cvPrjCost" BehaviorID="b_vcecvPrjCost">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceHeadCountBefore" runat="server" TargetControlID="cvHeadCountBefore" BehaviorID="b_vcecvHeadCountBefore">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vceExpectedIRR" runat="server" TargetControlID="cvExpectedIRR" BehaviorID="b_vcecvExpectedIRR">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcePlanedPayBack" runat="server" TargetControlID="cvPlanedPayBack" BehaviorID="b_vcePlanedPayBack">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcecvEstROI" runat="server" TargetControlID="cvEstROI" BehaviorID="b_vcecvEstROI">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcecvFinancialRqd" runat="server" TargetControlID="cvFinancialRqd" BehaviorID="b_vcecvFinancialRqd">
                                </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcecvPlannedVsActual" runat="server" TargetControlID="cvPlannedVsActual" BehaviorID="b_vcecvPlannedVsActual">
                                    </ajaxToolkit:ValidatorCalloutExtender><!-- This is for Financial Justification for automation -->
                                 <ajaxToolkit:ValidatorCalloutExtender ID="vcerblBestPractice" runat="server" TargetControlID="rfvrblBestPractice" BehaviorID="b_vcerblBestPractice">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vcetxtBPComment" runat="server" TargetControlID="rfvtxtBPComment" BehaviorID="b_vcetxtBPComment">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                <ajaxToolkit:ValidatorCalloutExtender ID="vcecvBpComment" runat="server" TargetControlID="cvBpComment" BehaviorID="b_vcecvBpComment">
                                    </ajaxToolkit:ValidatorCalloutExtender>   

                            </tr>
                            <tr>
                                <td class="Footer" colspan="4">
                                    <div>
                                        <asp:ImageButton ID="ImageButton2" runat="server" CommandName="Insert" ImageUrl="~/Images/Save.jpg" OnClientClick="javascript:return ValidatePage();" />&nbsp;
                                    </div>
                                </td>
                            </tr>

                        </table>
                        <br />
                    </InsertItemTemplate>

                </asp:FormView>
                <br />
                <asp:ObjectDataSource ID="obsProjects" runat="server"
                    InsertMethod="InsertQuery" OldValuesParameterFormatString="original_{0}" OnInserted="obsDataSource_Inserted"
                    OnInserting="obsProjects_Inserting" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ProjectsTableAdapter" SelectMethod="GetDataByDescription">
                    <InsertParameters>
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
                        <asp:Parameter Name="Creater" Type="String" />
                        <asp:Parameter Name="SegmentCode" Type="Int32" />
                        <asp:Parameter Name="RegionCode" Type="Int32" />
                        <asp:Parameter Name="eRoom" Type="String" />
                        <asp:Parameter Name="BULead" Type="String" />
                    </InsertParameters>
                    <SelectParameters>
                        <asp:Parameter Name="Description" Type="String" />
                        <asp:Parameter Name="Username" Type="String" />
                        <asp:Parameter Name="CategoryCode" Type="String" />
                        <asp:Parameter Name="StatusCode" Type="String" />
                        <asp:Parameter Name="CustomerCode" Type="String" />
                        <asp:Parameter Name="LocationCode" Type="String" />
                        <asp:Parameter Name="ProjectCode" Type="String" />
                        <asp:Parameter Name="RegionCode" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <%-- <ajax:UpdatePanel ID="upValidation" runat="server" UpdateMode="Conditional">
                <ContentTemplate>--%>
                <asp:ValidationSummary ID="vsProject" runat="server" ShowMessageBox="True" ShowSummary="False" />
                <%-- </ContentTemplate>
            </ajax:UpdatePanel>--%>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
