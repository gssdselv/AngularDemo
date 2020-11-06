<%@ Page Language="C#" MasterPageFile="~/Pages/MasterPage.Master" AutoEventWireup="true" CodeBehind="ProjectCad.aspx.cs" Inherits="ProjectTracker.Pages.ProjectCad" EnableEventValidation="true" %>

<%@ Register Src="../Common/ProgressBar.ascx" TagName="ProgressBar" TagPrefix="uc6" %>
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
    <%--<script type="text/javascript" src="../Scripts/jquery-1.11.3.min.js"></script>--%>
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

        Sys.UI.Point = function Sys$UI$Point(x, y) {
            x = Math.round(x);
            y = Math.round(y);

            var e = Function._validateParams(arguments, [
                { name: "x", type: Number, integer: true },
                { name: "y", type: Number, integer: true }
            ]);
            if (e)
                throw e;
            this.x = x;
            this.y = y;
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

        function ChangeColor(idTextbox) {
            var textBox = document.getElementById(idTextbox);
            var cellToChange = document.getElementById("tdCostSaving");
            var cellToChange1 = document.getElementById("tdClosedDate");

            if (cellToChange != null && cellToChange != undefined && cellToChange1 != null && cellToChange1 != undefined && textBox != null && textBox != undefined) {
                if (textBox.disabled == false) {
                    cellToChange.style.backgroundColor = "#FFFFCC";
                    cellToChange1.style.backgroundColor = "#FFFFCC";
                }
            }
        }

        function VisibleDiv(divName) {
            hddOldIdDivOld2 = document.getElementById('hddOldIdDivOld')

            divOldName = hddOldIdDivOld2.value;
            hddOldIdDivOld2.value = divName;

            if (divOldName != '') {
                divOld = document.getElementById(divOldName);
                divOld.style.display = 'none';
            }

            div = document.getElementById(divName);
            div.style.display = 'block';
            return false;
        }

        function HiddenDiv(divName) {
            div = document.getElementById(divName);
            div.style.display = 'none';
            return false;
        }

        function OpenAttachments(projectCode) {
            link = 'Attachments.aspx?ProjectCode=' + projectCode;
            var win1 = window.open(link, 'AttachFile', 'status=yes,toolbar=no,menubar=no,scrollbars=no,location=no,replace=yes,resizable=yes,width=580,height=370');
            win1.focus();
            return false;
        }

        function hidden() {
            element = document.getElementById('pnlShowed');
            content1 = document.getElementById('content');

            if (element.style.visibility == 'visible') {
                element.style.visibility = 'hidden';
                element.style.height = 0;
                content1.style.marginTop = 0;
            }
            else {
                element.style.visibility = 'visible';
                element.style.height = 100;
                content1.style.marginTop = 150;
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

        function changeRevenueCostSaving() {
            var ddlRevenueCostSaving = document.getElementById('<%=drpRevenueCostSaving.ClientID %>');
            var ddlSavingCategory = document.getElementById('<%=drpSavingCategoryS.ClientID %>');
            var index = ddlRevenueCostSaving.selectedIndex;
            if (index == 2 || index == 3) {
                ddlSavingCategory.disabled = 'disabled';
                ddlSavingCategory.selectedIndex = 0;
            }
            else {
                ddlSavingCategory.disabled = '';
            }
        }

        function changeStatus(drpStatusID, txtPercentCompletionID) {
            var drpStatus = document.getElementById(drpStatusID);
            var txtPercentCompletion = document.getElementById(txtPercentCompletionID);
            var index = drpStatus.selectedIndex;
            if (index != -1) {
                if (drpStatus.options[index].text == 'Closed') {
                    txtPercentCompletion.value = '100';
                }
            }
            return true;
        }

        function changeIP(rdoIP) {
            var rdoID = rdoIP.id.toString();
            var hdfID = "";
            hdfID = rdoID.replace("rdoIPYes", "hdfrfvIP");
            hdfID = hdfID.replace("rdoIPNo", "hdfrfvIP");
            document.getElementById(hdfID).value = 'Y';
            return true;
        }

        function dateSelectionChanged(sender, args) {// When Date changed, we need to set the period to custom
            var periodVal = document.getElementById('ctl00$MainContent$ddlPeriod').value;
            if (periodVal != 4) {
                document.getElementById('ctl00$MainContent$ddlPeriod').value = 4;
                var dateChanged = document.getElementById('<%= hdfDateChanged.ClientID%>');
                dateChanged.value = "true"; // this is ensure that we donot change the Date provided by the user in the custom period.
            }
        }

        function DateTimeDifference(sender, args) {
            var startDate = new Date(document.getElementById('ctl00$MainContent$FromYearTxt').value);
            var endDate = new Date(document.getElementById('ctl00$MainContent$ToYearTxt').value);
            var maxDate = new Date(startDate);
            maxDate.setMonth(maxDate.getMonth() + 6);

            args.IsValid = endDate.getTime() <= maxDate.getTime();
        }

        function checkTextAreaMaxLength(textBox, e, length) {
            //debugger;
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

        function trim(str) {
            return str.replace(/^[\s]+/, '').replace(/[\s]+$/, '');
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

        function ValidateAutomationCostSaving(sender, args) {
            var table, tbody, i, rowLen, row, j, colLen, cell, status;
            table = document.getElementById("ctl00_MainContent_FormView1_grdCostSavings");
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
                        else if (Page_Validators[i].validationGroup == "GrpCloseDeploy") {
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
                        if (Page_Validators[i].validationGroup == "GrpOpenCloseDeploy" || Page_Validators[i].validationGroup == "GrpClosed" || Page_Validators[i].validationGroup == "GrpOpenCloseDeploy") {
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

        function EnableCPXNumber() {
            var ddlStatusCode = document.getElementById('ctl00_MainContent_FormView1_drpStatusCode');
            var StatusIndex = ddlStatusCode.selectedIndex;
            var StatusValue = ddlStatusCode.options[StatusIndex].value;
            
            var ddlStageCode = document.getElementById('ctl00_MainContent_FormView1_drpAutoStage');
            var StageIndex = ddlStageCode.selectedIndex;
            var StageValue = ddlStageCode.options[StageIndex].value;
            
            var txteCpxNumber = document.getElementById('ctl00_MainContent_FormView1_txtPrjNumber');
            
            var radioPaidByList = document.getElementById('ctl00_MainContent_FormView1_rblPaidFlex');
            var radio = radioPaidByList.getElementsByTagName("input");
            for (var x = 0; x < radio.length; x++) {
                if (radio[x].checked) {
                    if (radio[x].value == "C" && StatusValue == 21 && StageValue == "Develop") {
                        txteCpxNumber.disabled = 'disabled';
                        document.getElementById('ctl00_MainContent_FormView1_txtPrjNumber').value = '';
                    }
                    else {
                        txteCpxNumber.disabled = '';
                    }
                    
                }
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
    <asp:UpdatePanel ID="udpMainPage" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <asp:HiddenField ID="hdfEditBtnID" runat="server" />
            <asp:HiddenField ID="hdfHaveClicked" runat="server" />
            <input type="hidden" id="hfInsertAlertText1" value="<%$ Resources:Default, COSTSAVING_ALERTMESSAGE_PART1 %>" runat="server" />
            <input type="hidden" id="hfInsertAlertText2" value="<%$ Resources:Default, COSTSAVING_ALERTMESSAGE_PART2 %>" runat="server" />
            <input type="hidden" id="hfCostSavingAlertValue" runat="server" />
            <input type="hidden" id="hfAutoPlannedSaving" runat="server" />
            <input type="hidden" id="hfAutoActualSaving" runat="server" />
            <asp:HiddenField ID="hdfEngLink" runat="server" />
            <asp:HiddenField ID="hdfEngIP" runat="server" />
            <asp:HiddenField ID="hdfProjectID" runat="server" />
            <asp:HiddenField ID="hdfCreator" runat="server" />
            <asp:HiddenField ID="hdfFromEmail" runat="server" />
            <asp:HiddenField ID="hdfToEmail" runat="server" />
            <asp:HiddenField ID="hdfCCEmail" runat="server" />
            <asp:HiddenField ID="hdfProjDesc" runat="server" />
            <asp:HiddenField ID="hdfResp" runat="server" />
            <asp:HiddenField ID="hdfIsClosed" runat="server" />
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
            <asp:HiddenField ID="hdfDateChanged" runat="server" />
            <asp:HiddenField ID="hdfPeriodSelect" runat="server" />
            <asp:HiddenField ID="hdfReqProjID" runat="server" />
            <asp:HiddenField ID="hdfStatusID" runat="server" />
            <asp:HiddenField ID="hdfRegionID" runat="server" />
            <asp:HiddenField ID="hdfExpectedIRR" runat="server" />
            <asp:HiddenField ID="hdfCapexAppd" runat="server" />

            <asp:HiddenField ID="hdfCapexAppdDate" runat="server" />

            <asp:HiddenField ID="hdfPOIssued" runat="server" />
            <asp:HiddenField ID="hdfPrjNumber" runat="server" />
            <asp:HiddenField ID="hdfFlexPaid" runat="server" />
            <%--<asp:HiddenField ID="hdfCustPaid" runat="server" />--%>
            <asp:HiddenField ID="hdfSummaryLink" runat="server" />
            <asp:HiddenField ID="hdfVideoLink" runat="server" />
            <asp:HiddenField ID="hdfROILink" runat="server" />
            <asp:HiddenField ID="hdfCloseReason" runat="server" />
            <asp:HiddenField ID="hdfCloseRemarks" runat="server" />
            <asp:HiddenField ID="hdfStatus" runat="server" />
            <asp:HiddenField ID="hdfFirstDataLoad" runat="server" />
            <asp:HiddenField ID="hdfHoldReason" runat="server" />
            <asp:HiddenField ID="hdfCurrentPage" runat="server" />
            <asp:HiddenField ID="hdfrbBestPractice" runat="server" />
            <asp:HiddenField ID="hdftxtBestPractice" runat="server" />

            <div style="text-align: center">
                <asp:Label ID="Label5" runat="server" Text="<%$ Resources:Default, TITLE_PROJECTS %>" SkinID="Title" /><br />
                <br />
                <uc1:MessagePanel ID="MessagePanel1" runat="server" />
            </div>
            <div>
                <asp:UpdateProgress ID="UpdateProgress" runat="server" DynamicLayout="false" DisplayAfter="1">
                    <ProgressTemplate>
                        <asp:Image ID="imgSpin" ImageUrl="~/Images/Spinner.gif" AlternateText="Processing" runat="server" />
                    </ProgressTemplate>
                </asp:UpdateProgress>
                <ajaxToolkit:ModalPopupExtender ID="modalPopup" runat="server" TargetControlID="UpdateProgress"
                    PopupControlID="UpdateProgress" BackgroundCssClass="modalPopup" />
            </div>

            <asp:MultiView ID="mvViewers" runat="server" ActiveViewIndex="0" OnActiveViewChanged="mvViewers_ActiveViewChanged">
                <asp:View ID="vwGrid" runat="server" OnActivate="vwGrid_Activate">
                    <div style="width: 100%; text-align: center;">
                        <table style="width: 40%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="8" style="height: 15px">
                                    <hr />
                                </td>
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
                                <td colspan="8" style="height: 15px">
                                    <hr />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <div onclick="hidden" id="pnlHiddened" style="width: 100%;">
                        <asp:Panel ID="pnlHidden" runat="server" CssClass="collapsePanelHeader" Height="20px">
                            <div style="padding: 5px; cursor: pointer; text-align: right; background-color: #CECECE; width: 100%">
                                <a href="javascript:hidden()" style="text-decoration: none;">
                                    <asp:Label ID="Label1" Text="<%$ Resources:Default, FILTER %>" runat="server"></asp:Label>
                                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/down.gif" ImageAlign="Left" BorderWidth="0" />
                                </a>
                            </div>
                        </asp:Panel>
                    </div>
                    <div id="pnlShowed" style="text-align: left; visibility: hidden; width: 100%; height: 0px; position: absolute; float: left; top: 243px">
                        <asp:TextBox runat="server" ID="dummyTextBox" CssClass="none"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" CssClass="none" ControlToValidate="dummyTextBox" ValidationGroup="dummy"></asp:RequiredFieldValidator>
                        <asp:Panel ID="Panel3" runat="server" CssClass="collapsePanel" Height="0">
                            <table class="FormView" cellpadding="1" cellspacing="0" border="1">
                                <tr>
                                    <td>
                                        <table class="FormView" cellpadding="0" cellspacing="0" border="1" width="100%">
                                            <tr>
                                                <td class="DescLeft" nowrap="nowrap">Code</td>
                                                <td colspan="1" class="NormalField">
                                                    <asp:TextBox ID="txtProjectCode" runat="server" Width="200px"></asp:TextBox>
                                                </td>
                                                <td class="DescLeft" nowrap="nowrap">Description</td>
                                                <td colspan="1" class="NormalField">
                                                    <asp:TextBox ID="txtDescription" runat="server" Width="317px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="DescLeft">
                                                    <asp:Label ID="lblFilterDis" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label>
                                                </td>
                                                <td class="NormalField">
                                                    <asp:DropDownList ID="drpResponsiblesS" runat="server" DataSourceID="obsResponsiblesS" DataTextField="Name" DataValueField="Username" OnDataBound="dropFilter" Width="200px"></asp:DropDownList>
                                                    <asp:ObjectDataSource ID="obsResponsiblesS" runat="server" DeleteMethod="Delete" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByFilter"
                                                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter" UpdateMethod="Update"></asp:ObjectDataSource>
                                                </td>
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label34" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label>
                                                </td>
                                                <td class="NormalField" style="width: 317px">
                                                    <asp:DropDownList ID="drpCategoriesS" runat="server" DataSourceID="obsCategoriesS"
                                                        DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter" Width="200px">
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="obsCategoriesS" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
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
                                                    <asp:Label ID="Label36" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label>
                                                </td>
                                                <td class="NormalField">

                                                    <asp:DropDownList ID="drpStatusCodeS" runat="server" DataSourceID="obsStatusS" AutoPostBack="true"
                                                        DataTextField="PS_DESCRICAO" DataValueField="PS_CODIGO" OnDataBound="dropFilter" Width="200px" OnSelectedIndexChanged="drpStatusCodeS_SelectedIndexChanged">
                                                    </asp:DropDownList>

                                                    <asp:ObjectDataSource ID="obsStatusS" runat="server" DeleteMethod="Delete"
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
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label35" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label>
                                                </td>
                                                <td class="NormalField" style="width: 317px">
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
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label37" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label>
                                                </td>
                                                <td class="NormalField">
                                                    <asp:DropDownList ID="drpCustomersS" runat="server" DataSourceID="obsCCustomersS"
                                                        DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter" Width="200px">
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource
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
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label27" runat="server" Text="<%$ Resources:Default, REGION %>"></asp:Label>
                                                </td>
                                                <td class="NormalField" style="width: 317px">
                                                    <asp:DropDownList ID="drpRegionS" runat="server" DataSourceID="obsRegionS"
                                                        DataTextField="RegionDescription" DataValueField="RegionCode" OnDataBound="dropFilter" Width="200px">
                                                    </asp:DropDownList>
                                                    <asp:RequiredFieldValidator ID="rfvRegionS" runat="server" ErrorMessage="Region is required." ControlToValidate="drpRegionS" InitialValue="" Display="Dynamic" />
                                                    <asp:ObjectDataSource ID="obsRegionS" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByUsername"
                                                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.UserRegionsTableAdapter" OnSelecting="obsRegionS_Selecting">
                                                        <SelectParameters>
                                                            <asp:Parameter Name="PU_USUARIO" Type="String" />
                                                        </SelectParameters>
                                                    </asp:ObjectDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label26" runat="server" Text="<%$ Resources:Default, REVENUE_COSTSAVING %>" Width="130px"></asp:Label>
                                                </td>
                                                <td class="NormalField" style="width: 317px">
                                                    <asp:DropDownList ID="drpRevenueCostSaving" runat="server" Width="200px" AutoPostBack="false" onchange="changeRevenueCostSaving()">
                                                        <asp:ListItem Text="-- All --" Value="%"></asp:ListItem>
                                                        <asp:ListItem Text="Cost Saving" Value="1"></asp:ListItem>
                                                        <asp:ListItem Text="Revenue" Value="2"></asp:ListItem>
                                                        <asp:ListItem Text="Planned Saving" Value="3"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label50" runat="server" Text="<%$ Resources:Default, SAVING_CATEGORY_HEADER %>"></asp:Label>
                                                </td>
                                                <td class="NormalField" style="width: 317px">
                                                    <asp:DropDownList ID="drpSavingCategoryS" runat="server" DataSourceID="obsSavingCategory" DataTextField="Description" DataValueField="Code" OnDataBound="dropFilter" Width="200px">
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="obsSavingCategory" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SavingCategoryTableAdapter" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Footer" colspan="4" style="height: 25px">
                                                    <asp:LinkButton ID="LinkButton2" runat="server" Text="<%$ Resources:Default, SEARCH_PROJECT %>" ValidationGroup="Group1"></asp:LinkButton>&nbsp;
                                                    <asp:LinkButton ID="lbGetAll" runat="server" Text="<%$ Resources:Default, GET_ALL %>" OnClick="lbGetAll_Click" Visible="false"></asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td id="tdClose" runat="server" visible="false">
                                        <table id="tblCloseOption" cellpadding="0" cellspacing="0" border="1">
                                            <tr>
                                                <td colspan="2" valign="middle" align="center" class="DescLeft">
                                                    <h5>Closed Date Filter</h5>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="DescLeft">
                                                    <asp:Label ID="lblPeriod" runat="server" Text="<%$ Resources:Default, PERIOD %>"></asp:Label>
                                                </td>
                                                <td class="CalendarField">
                                                    <asp:DropDownList ID="ddlPeriod" runat="server" DataSourceID="obsPeriodS" AutoPostBack="true"
                                                        DataTextField="PCO_DESCRICAO" DataValueField="PCO_CODIGO" OnDataBound="dropFilter" Width="100px" OnSelectedIndexChanged="ddlPeriod_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                    <asp:ObjectDataSource ID="obsPeriodS" runat="server" DeleteMethod="Delete"
                                                        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataPeriodOption"
                                                        TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.PeriodTableAdapter"
                                                        UpdateMethod="Update">
                                                        <DeleteParameters>
                                                            <asp:Parameter Name="Original_PCO_CODIGO" Type="Int32" />
                                                        </DeleteParameters>
                                                        <UpdateParameters>
                                                            <asp:Parameter Name="PCO_DESCRICAO" Type="String" />
                                                            <asp:Parameter Name="PCO_ATIVO" Type="Boolean" />
                                                            <asp:Parameter Name="Original_PCO_CODIGO" Type="Int32" />
                                                        </UpdateParameters>
                                                        <InsertParameters>
                                                            <asp:Parameter Name="PCO_DESCRICAO" Type="String" />
                                                            <asp:Parameter Name="PCO_ATIVO" Type="Boolean" />
                                                        </InsertParameters>
                                                    </asp:ObjectDataSource>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="DescLeft">
                                                    <asp:Label ID="lblStartDate" runat="server" Text="From"></asp:Label>
                                                </td>
                                                <td class="CalendarField">
                                                    <asp:TextBox ID="FromYearTxt" runat="server" Width="100px" CausesValidation="true"></asp:TextBox>
                                                    <ajaxToolkit:CalendarExtender ID="FromYearTxt_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="FromYearTxt" Format="MM/dd/yyyy" PopupPosition="BottomRight" OnClientDateSelectionChanged="dateSelectionChanged">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="DescLeft">
                                                    <asp:Label ID="Label51" runat="server" Text="To"></asp:Label>
                                                </td>
                                                <td class="CalendarField">
                                                    <asp:TextBox ID="ToYearTxt" runat="server" Width="100px" CausesValidation="true"></asp:TextBox>
                                                    <ajaxToolkit:CalendarExtender ID="ToYearTxt_CalendarExtender" runat="server" Enabled="True"
                                                        TargetControlID="ToYearTxt" Format="MM/dd/yyyy" PopupPosition="BottomRight" OnClientDateSelectionChanged="dateSelectionChanged">
                                                    </ajaxToolkit:CalendarExtender>
                                                </td>
                                                <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="FromYearTxt"
                                                    ErrorMessage="<%$ Resources:Default, REQUIRED_START_DATE %>" CssClass="warning" ForeColor=""
                                                    ValidationGroup="Group1" Display="None" EnableClientScript="true"> </asp:RequiredFieldValidator>

                                                <asp:CustomValidator ID="cvFromYearTxt" runat="server" ClientValidationFunction="DateTimeDifference"
                                                    ErrorMessage="The Date range should not exceed more than 6 months" EnableClientScript="true"
                                                    ValidationGroup="Group1" ControlToValidate="FromYearTxt" Display="None"></asp:CustomValidator>

                                                <asp:CompareValidator ID="cvToYearTxt" runat="server"
                                                    ControlToCompare="FromYearTxt" CultureInvariantValues="true"
                                                    EnableClientScript="true"
                                                    ControlToValidate="ToYearTxt"
                                                    ErrorMessage="<%$ Resources:Default, DATA_INF_START_DATE %>"
                                                    Type="Date" SetFocusOnError="true" Operator="GreaterThanEqual"
                                                    Text="<%$ Resources:Default, DATA_INF_START_DATE %>" ValidationGroup="Group1" Display="None"></asp:CompareValidator>

                                                <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="ToYearTxt"
                                                    ErrorMessage="<%$ Resources:Default, REQUIRED_END_DATE %>" CssClass="warning" ForeColor=""
                                                    ValidationGroup="Group1" Display="None" EnableClientScript="true"></asp:RequiredFieldValidator>

                                                <asp:CustomValidator ID="cusvalidator" runat="server" ClientValidationFunction="DateTimeDifference"
                                                    ErrorMessage="The Date range should not exceed more than 6 months" EnableClientScript="true"
                                                    ValidationGroup="Group1" Display="None" ControlToValidate="ToYearTxt"></asp:CustomValidator>

                                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server" TargetControlID="rfvStartDate">
                                                </ajaxToolkit:ValidatorCalloutExtender>
                                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender2" runat="server"
                                                    TargetControlID="rfvEndDate">
                                                </ajaxToolkit:ValidatorCalloutExtender>
                                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender3" runat="server"
                                                    TargetControlID="cvToYearTxt">
                                                </ajaxToolkit:ValidatorCalloutExtender>
                                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender5" runat="server"
                                                    TargetControlID="cvFromYearTxt">
                                                </ajaxToolkit:ValidatorCalloutExtender>
                                                <ajaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender4" runat="server" TargetControlID="cusvalidator"></ajaxToolkit:ValidatorCalloutExtender>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </div>
                    <br />
                    <br />
                    <div id="content" class="info">
                        <asp:Label ID="lblMsg" runat="server"></asp:Label>
                    </div>
                    <asp:GridView ID="gvProjects" runat="server" AutoGenerateColumns="False" DataSourceID="obsProjects" DataKeyNames="Code,StatusCode,Username,CustomerCode,LocationCode,Description,CategoryCode,RegionCode,SegmentCode,SegmentDescription" OnSelectedIndexChanged="gvProjects_SelectedIndexChanged" OnRowDataBound="gvProjects_RowDataBound" SkinID="GridViewMorePagging" OnRowDeleting="gvProjects_RowDeleting" AllowSorting="True" OnSorting="gvProjects_Sorting">
                        <Columns>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <div id='<%# Eval("Code", "divProject{0}") %>' style="margin-left: 130px; position: absolute; width: 900px; text-align: left; height: 40px; display: none; left: 1px;">
                                        <table class="FormView_Div" cellpadding="1" cellspacing="0" bgcolor="#ffffff" width="100%" border="0">
                                            <tr>
                                                <td class="Header" colspan="4" style="text-align: right;">&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                                                </td>
                                                <td nowrap>&nbsp;
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                                                </td>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label>
                                                </td>
                                                <td>&nbsp;
                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("CategoryDescription") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                                                </td>
                                                <td nowrap colspan="3">&nbsp;
                                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label>
                                                </td>
                                                <td colspan="3">&nbsp;
                                            <asp:Label ID="Label5" runat="server" Text='<%# Eval("CustomerName") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label>
                                                </td>
                                                <td colspan="3" nowrap>&nbsp;
                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("Name") %>'></asp:Label>-
                                            <asp:Label ID="Label14" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label>
                                                </td>
                                                <td nowrap width="200" colspan="3">&nbsp;
                                            <asp:Label ID="Label6" runat="server" Text='<%# Eval("LocationDescription") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label>
                                                </td>
                                                <td width="170">&nbsp;
                                            <asp:Label ID="Label7" runat="server" Text='<%# Bind("OpenDate", "{0:d}") %>'></asp:Label>
                                                </td>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label>
                                                </td>
                                                <td nowrap>&nbsp;
                                            <asp:Label ID="Label8" runat="server" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Header">
                                                    <asp:Label ID="Label41" runat="server" Text="Status"></asp:Label>
                                                </td>
                                                <td>&nbsp;
                                            <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("PS_DESCRICAO") %>'></asp:Label>
                                                </td>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label>
                                                </td>
                                                <td>&nbsp;
                                            <asp:Label ID="Label9" runat="server" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Header" colspan="1">
                                                    <asp:Label ID="Label46" runat="server" Text="Eng. Report #"></asp:Label>&nbsp;
                                            <a id="aURL" runat="server" visible="false" target="_blank" title='<%# Bind("eRoom", "{0:d}") %>'>Click here</a>
                                                </td>
                                                <td colspan="3">&nbsp;
                                            <asp:Label ID="Label47" runat="server" Text='<%# Bind("eRoom", "{0:d}") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="Header" colspan="1">
                                                    <asp:Label ID="Label42" runat="server" Text="Eng. Report Link"></asp:Label>&nbsp;
                                            <a id="a1" runat="server" visible="false" target="_blank" title='<%# Bind("eRoom", "{0:d}") %>'>Click here</a>
                                                </td>
                                                <td colspan="3">&nbsp;
                                            <asp:Label ID="lblEngReportLink" runat="server"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" class="Header" style="width: 500px" nowrap="nowrap">
                                                    <asp:Label ID="lblIP" runat="server" Text="Can a patent or IP(Intellectual Property) be generated from this project?"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label Width="160px" ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label>
                                                </td>
                                                <td>&nbsp;
                                            <asp:Label ID="Label11" runat="server" Text='<%# Bind("CostSaving", "{0:c}") %>'></asp:Label>
                                                </td>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label28" runat="server" Text="Revenue"></asp:Label>
                                                </td>
                                                <td colspan="3">&nbsp;
                                            <asp:Label ID="Label29" runat="server" Text='<%# Bind("Revenue", "{0:c}") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label>
                                                </td>
                                                <td colspan="3">&nbsp;
                                            <asp:Label ID="Label12" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Header">
                                                    <asp:Label ID="Label48" runat="server" Text="<%$ Resources:Default, ANEXOS %>"></asp:Label>
                                                </td>
                                                <td colspan="3">
                                                    <asp:Label ID="Label49" runat="server" Text='<%# Bind("TotalAttachments") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td nowrap class="Footer" colspan="4">
                                                    <a style="cursor: hand; font-family: Arial Black; color: red;" onclick="<%# Eval("Code", "HiddenDiv('divProject{0}')") %>">
                                                        <img src="../images/btnClose.jpg" alt="Close the Screen" />
                                                    </a>
                                                    &nbsp;
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Width="1px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Code" HeaderText="Code" InsertVisible="False" ReadOnly="True"
                                SortExpression="Code" />
                            <asp:BoundField DataField="Description" HeaderText="Description" SortExpression="Description" />
                            <asp:TemplateField HeaderText="Progress" SortExpression="PercentageCompletion">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("PercentageCompletion", "{0:N0}") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label25" runat="server" Text='<%# Bind("PercentageCompletion", "{0:N0}") %>'></asp:Label>%
                            <uc6:ProgressBar ID="pbPercentageCompletion" Blocks="50" runat="server" Value='<%# Bind("PercentageCompletion") %>'></uc6:ProgressBar>
                                </ItemTemplate>
                            </asp:TemplateField>
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
                            <asp:BoundField DataField="PlanSav" HeaderText="Planned Saving" SortExpression="PlanSav" DataFormatString="{0:c}" HtmlEncode="False" />
                            <asp:BoundField DataField="CostSaving" HeaderText="Cost Saving" SortExpression="CostSaving" DataFormatString="{0:c}" HtmlEncode="False" />
                            <asp:BoundField DataField="Revenue" HeaderText="Revenue" SortExpression="Revenue" DataFormatString="{0:c}" HtmlEncode="False" />
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="Label31" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label30" runat="server" Text='<%# Bind("PS_DESCRICAO") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:ImageButton ID="btnEditProject" runat="server" CommandName="Select" ImageUrl="~/Images/EditProject.gif" Visible='<%# Eval("CanDelete") %>' AlternateText="Edit the Project" />
                                </ItemTemplate>
                                <ItemStyle Width="18px" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:ImageButton ID="ImageButton3" runat="server" CommandName="Delete" ImageUrl="~/Images/delete.gif" Visible='<%# Eval("CanDelete") %>' AlternateText="Delete the Project" OnClientClick="<%$ Resources:Default, DELETE_CONFIRM %>" />
                                </ItemTemplate>
                                <ItemStyle Width="18px" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Image ID="imgEditAttachments" runat="server" Style="cursor: hand;" onclick='<%# Eval("Code", "OpenAttachments({0})") %>' Visible='<%# Eval("CanDelete") %>' ImageUrl="../images/btn_16x16_attach.gif" BorderWidth="0" AlternateText="Edit Attachments" />
                                </ItemTemplate>
                                <ItemStyle Width="18px" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <a style="cursor: hand;" onclick="<%# Eval("Code", "javascript:VisibleDiv('divProject{0}');") %>">
                                        <asp:Image ID="Image2" runat="server" BorderWidth="0px" ImageUrl="~/Images/list.gif" AlternateText="See the Details" />
                                    </a>
                                </ItemTemplate>
                                <ItemStyle Width="18px" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <a style="cursor: hand;" onclick="<%# Eval("Code", "javascript:window.open('ExportToPowerPoint.aspx?ProjectId={0}');") %>">
                                        <asp:Image ID="imgPowerPoint" runat="server" BorderWidth="0px" ImageUrl="~/Images/ppt.png" AlternateText="Export to PowerPoint" Height="22" />
                                    </a>
                                </ItemTemplate>
                                <ItemStyle Width="18px" />
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle HorizontalAlign="Justify" />
                    </asp:GridView>
                    <asp:DataList CellPadding="5" RepeatDirection="Horizontal" runat="server" ID="dlPager"
                        OnItemCommand="dlPager_ItemCommand">
                        <ItemTemplate>
                            <asp:LinkButton Enabled='<%#Eval("Enabled") %>' runat="server" ID="lnkPageNo" Text='<%#Eval("Text") %>' CommandArgument='<%#Eval("Value") %>' CommandName="PageNo"></asp:LinkButton>
                        </ItemTemplate>
                    </asp:DataList>
                </asp:View>
                <asp:View ID="vwForm" runat="server" OnActivate="vwForm_Activate">
                    <asp:FormView ID="FormView1" runat="server" DataSourceID="obsProjects"
                        OnDataBound="FormView1_DataBound" DefaultMode="Edit"
                        DataKeyNames="Code,StatusCode,Username,CustomerCode,LocationCode"
                        OnItemUpdating="FormView1_ItemUpdating" OnItemUpdated="FormView1_ItemUpdated">
                        <EditItemTemplate>
                            <table cellpadding="1" cellspacing="0" class="FormView" border="0">
                                <tr>
                                    <td colspan="4" style="text-align: right" class="Header"></td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">
                                        <asp:RequiredFieldValidator ID="rfvRegion" runat="server" ControlToValidate="drpRegion" CssClass="warning" ForeColor="" ErrorMessage="Region is required" Display="None" EnableClientScript="true" ValidationGroup="Group1" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label39" runat="server" Text="<%$ Resources:Default, REGION %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:DropDownList ID="drpRegion" runat="server" DataSourceID="obsRegion"
                                            DataTextField="RegionDescription" DataValueField="RegionCode" OnDataBound="drpRegion_DataBound" AutoPostBack="True" Width="200px" OnSelectedIndexChanged="drpRegion_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource ID="obsRegion" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByUsername"
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
                                    </td>
                                    <td class="DescLeft">
                                        <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="drpCategories" CssClass="warning" ForeColor="" ErrorMessage="Category is required" Display="None" EnableClientScript="true" ValidationGroup="Group1" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                        <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:DropDownList ID="drpCategories" runat="server" DataSourceID="obsCategories" DataTextField="Description" DataValueField="Code" OnDataBound="drpCategories_DataBound" Width="200px" OnSelectedIndexChanged="drpCategories_SelectedIndexChanged" AutoPostBack="true">
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource
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
                                    <td class="DescLeft" nowrap="nowrap">
                                        <asp:RequiredFieldValidator ID="rqdDescription" runat="server" ControlToValidate="TextBox2" CssClass="warning" ForeColor="" Display="None" ErrorMessage="Description is required" EnableClientScript="true" ValidationGroup="Group1" SetFocusOnError="true"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                                        <a href="#" class="tooltipDescription">
                                            <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="imgTooltip" ImageUrl="~/Images/help.png" />
                                            <span>For Example:
                                        <br>
                                                &nbsp;&nbsp;<b>-Service:</b>&nbsp;DFx - DFT analysis for Nortel PCBA model Taurus Tx-123<br>
                                                &nbsp;&nbsp;<b>-Non-Service:</b>&nbsp;Scrap reduction on Dell laptop rework project </span>
                                        </a>
                                    </td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("Description") %>' Style="width: 90%" onkeyDown="checkTextAreaMaxLength(this,event,'80');" TextMode="MultiLine"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                                        <ajaxToolkit:TextBoxWatermarkExtender ID="twPrjDesc" runat="server" TargetControlID="TextBox2" Enabled="false"
                                            WatermarkText="Open project with Project Name – feasibility and analysis study" WatermarkCssClass="watermarked" />
                                    </td>
                                    <td class="DescLeft" style="" nowrap="nowrap">
                                        <asp:Label ID="lblSiteBuLead" runat="server" Text="<%$ Resources:Default, BULEAD %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="txtBULead" runat="server" MaxLength="40" Text=''></asp:TextBox>&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">

                                        <asp:Label ID="Label32" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">

                                        <asp:DropDownList ID="drpLocations" runat="server" DataSourceID="obsLocations"
                                            DataTextField="Description" DataValueField="Code" OnDataBound="drpLocation_DataBound" AutoPostBack="True" OnSelectedIndexChanged="drpLocations_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvLocation" runat="server" ControlToValidate="drpLocations" CssClass="warning" ForeColor="" Display="None" SetFocusOnError="true" ErrorMessage="Location is required" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:ObjectDataSource ID="obsLocations" runat="server" DeleteMethod="Delete" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataDropToInsert"
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
                                    </td>
                                    <td class="DescLeft">
                                        <asp:Panel ID="Panel1" runat="server" CssClass="collapsePanelHeader" Width="100%">
                                            <asp:Label ID="Label7" runat="server" Text="<%$ Resources:Default, CO_LOCATIONS %>"></asp:Label>
                                            <asp:Image ID="Image2" runat="server" AlternateText="ASP.NET AJAX" ImageAlign="Right" ImageUrl="~/images/down.gif" />
                                        </asp:Panel>
                                    </td>
                                    <td class="NormalField" nowrap="nowrap">
                                        <asp:Panel ID="pnlHiddenCoLocations" runat="server" Width="100%">
                                            <ajaxToolkit:CollapsiblePanelExtender ID="cpeCoLocations" runat="server" CollapseControlID="Panel1"
                                                Collapsed="True" CollapsedImage="~/images/down.gif" CollapsedText="Edit Co-Responsibles"
                                                ExpandControlID="Panel1" ExpandedImage="~/images/up.gif" ExpandedText="" ImageControlID="Image2"
                                                SuppressPostBack="true" TargetControlID="pnlHiddenCoLocations">
                                            </ajaxToolkit:CollapsiblePanelExtender>
                                            <ajax:UpdatePanel ID="updLstLocations" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <table width="350" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="NormalField" width="150">
                                                                <asp:ListBox ID="lstCoLocationsAvaiable" runat="server" DataSourceID="obsLocations"
                                                                    DataTextField="Description" DataValueField="Code" Font-Names="Verdana"
                                                                    Font-Size="8pt" Width="150px"></asp:ListBox>
                                                            </td>
                                                            <td align="center" valign="middle" width="30">
                                                                <asp:ImageButton ID="btnMoveToInsertLoc" runat="server" ImageUrl="~/Images/Right.jpg"
                                                                    OnClick="btnMoveToInsertLoc_Click" ValidationGroup="moveToInsertLocation" />
                                                                <%--<asp:RequiredFieldValidator
                                                            ID="RequiredFieldValidator10" runat="server" ControlToValidate="lstCoLocationsAvaiable"
                                                            Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToInsertLocation" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator>--%><br />
                                                                <br />
                                                                <asp:ImageButton ID="btnRemoveLocationProject" runat="server" ImageUrl="~/Images/left.jpg"
                                                                    OnClick="btnRemoveLocationProject_Click" ValidationGroup="moveToAvaiableLocation" />
                                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="lstCoLocationsToInsert"
                                                            Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToAvaiableLocation" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator>--%><br />
                                                            </td>
                                                            <td>
                                                                <asp:ListBox ID="lstCoLocationsToInsert" runat="server" DataSourceID="ObjectDataSource1"
                                                                    DataTextField="LocationDescription" DataValueField="LocationCode" Font-Names="Verdana"
                                                                    Font-Size="8pt" Width="150px"></asp:ListBox>
                                                            </td>
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
                                        </asp:Panel>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">

                                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, RESPONSIBLE %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:Label ID="lblUsername" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                        <ajax:UpdatePanel ID="updResp" runat="server" UpdateMode="Conditional" Visible="False">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="drpResponsibles" runat="server" DataSourceID="obsResponsibles" DataTextField="Name" DataValueField="Username" OnDataBound="drpResponsibles_DataBound" AutoPostBack="True" OnSelectedIndexChanged="drpResponsibles_SelectedIndexChanged" Width="200px" Enabled="False"></asp:DropDownList>
                                                <asp:ObjectDataSource ID="obsResponsibles" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetDataByRegion" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.ResponsibleTableAdapter" DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
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
                                    <td class="DescLeft" nowrap>
                                        <asp:Panel ID="pnlCollapsedCoResp" runat="server" CssClass="collapsePanelHeader" Width="100%">
                                            <asp:Label ID="Label38" runat="server" Text="<%$ Resources:Default, CO_RESPONSIBLE %>"></asp:Label>
                                            &nbsp;
                                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/down.gif"
                                        AlternateText="ASP.NET AJAX" ImageAlign="Right" />
                                        </asp:Panel>
                                    </td>
                                    <td class="NormalField">
                                        <ajax:UpdatePanel ID="updCoResp" runat="server" UpdateMode="Conditional">
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
                                                    ExpandedImage="~/images/up.gif"
                                                    CollapsedImage="~/images/down.gif"
                                                    SuppressPostBack="true" />
                                                <asp:Panel ID="pnlHiddenCoResp" runat="server" Width="100%">
                                                    <table width="350" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td class="NormalField" width="150">
                                                                <asp:ListBox ID="lstCoRespsAvaiable" runat="server" DataSourceID="obsCoRespsNoProject" DataTextField="Name" DataValueField="Username" OnDataBound="lstCoRespsAvaiable_DataBound" Font-Names="Verdana" Font-Size="8pt" Width="150px"></asp:ListBox>
                                                            </td>
                                                            <td align="center" valign="middle" width="30">
                                                                <asp:ImageButton ID="btnMoveCoRespR" runat="server" ImageUrl="~/Images/Right.jpg" OnClick="btnMoveCoRespR_Click" ValidationGroup="moveToInsert" /><br />
                                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="lstCoRespsAvaiable"
                                                            Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToInsert" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator><br />--%>
                                                                <br />
                                                                <asp:ImageButton ID="btnMoveCoRespL" runat="server" ImageUrl="~/Images/left.jpg" OnClick="btnMoveCoRespL_Click" ValidationGroup="moveToAvaiable" />
                                                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="lstCoRespsToInsert"
                                                            Display="Dynamic" ErrorMessage="Select an item" ValidationGroup="moveToAvaiable" CssClass="warning" ForeColor=""></asp:RequiredFieldValidator>--%><br />
                                                            </td>
                                                            <td>
                                                                <asp:ListBox ID="lstCoRespsToInsert" runat="server" DataSourceID="obsCoRespsProject" DataTextField="PU_NAME" DataValueField="PU_USUARIO" Font-Names="Verdana" Font-Size="8pt" Width="150px"></asp:ListBox>
                                                            </td>
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
                                    <td class="DescLeft">
                                        <asp:RequiredFieldValidator ID="rfvCustomer" runat="server" SetFocusOnError="true"
                                            ControlToValidate="drpCustomers" CssClass="warning" ForeColor="" ErrorMessage="Customer is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <asp:DropDownList ID="drpCustomers" runat="server" DataSourceID="obsCCustomers"
                                            DataTextField="Description" DataValueField="Code" OnDataBound="drpCustomers_DataBound" Width="200px">
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource
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
                                        &nbsp;&nbsp;
                                    </td>
                                    <td class="DescLeft">
                                        <asp:RequiredFieldValidator ID="rfvSegment" runat="server" ControlToValidate="drpSegment" CssClass="warning" ForeColor="" ErrorMessage="Segment is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label13" runat="server" Text="<%$ Resources:Default, SEGMENT %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <%--<asp:DropDownList ID="drpSegment" runat="server" DataSourceID="obsSegment" DataTextField="Description" DataValueField="Code" SelectedValue='<%# Bind("SegmentCode") %>' Width="200px">                                            
                                        </asp:DropDownList>--%>
                                        <asp:DropDownList ID="drpSegment" runat="server" DataSourceID="obsSegment" DataTextField="Description" DataValueField="Code" OnDataBound="drpSegment_DataBound"  Width="200px">                                            
                                        </asp:DropDownList>
                                        <asp:ObjectDataSource ID="obsSegment" runat="server" OldValuesParameterFormatString="original_{0}"
                                            SelectMethod="GetDataByDrop" TypeName="ProjectTracker.DAO.dtsProjectTrackerTableAdapters.SegmentTableAdapter"></asp:ObjectDataSource>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">
                                        <cc1:ActualDateTextBox Font-Family="Arial" Font-Size="8pt" ID="txtOpenDate" runat="server" Enabled="False" Text='<%# Bind("OpenDate", "{0:d}") %>' ReadOnly="True" BorderColor="Silver" BorderWidth="1px" Font-Names="Verdana" SkinID="ActualDate" Width="83px"></cc1:ActualDateTextBox>
                                    </td>
                                    <td class="DescLeft">
                                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label>
                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="ddcCommitDate" runat="server" Width="100px" CausesValidation="true" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:TextBox>
                                        <ajaxToolkit:CalendarExtender ID="ddcCommitDate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="ddcCommitDate" Format="MM/dd/yyyy" PopupPosition="BottomRight">
                                        </ajaxToolkit:CalendarExtender>
                                        <asp:RequiredFieldValidator ID="rfvCommitDate" SetFocusOnError="true" runat="server" ControlToValidate="ddcCommitDate" ErrorMessage="Commit date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="Group1">
                                        </asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="cmpOpenCommit" runat="server" ControlToCompare="txtOpenDate"
                                            ControlToValidate="ddcCommitDate" Display="None" ErrorMessage="<%$ Resources:Default, DATA_INF_OPEN_DATE %>"
                                            Operator="GreaterThan" Type="Date" CssClass="warning" ForeColor="" EnableClientScript="true" ValidationGroup="Group1"></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft">
                                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label>
                                        <asp:RequiredFieldValidator ID="rfvStatusCode" runat="server" ControlToValidate="drpStatusCode" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Status is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                    </td>
                                    <td class="NormalField">

                                        <asp:DropDownList ID="drpStatusCode" runat="server" DataSourceID="obsStatus"
                                            DataTextField="PS_DESCRICAO" DataValueField="PS_CODIGO" OnDataBound="drpStatus_DataBound" OnSelectedIndexChanged="drpStatusCode_SelectedIndexChanged" AutoPostBack="True" Width="200px">
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
                                    <td class="DescLeft">
                                        <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label>
                                        <asp:Label ID="lblCloseDateRequired" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField">

                                        <asp:TextBox ID="ddcClosedDate" runat="server" Width="100px" CausesValidation="true" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:TextBox>
                                        <ajaxToolkit:CalendarExtender ID="ddcClosedDate_CalendarExtender" runat="server" Enabled="True"
                                            TargetControlID="ddcClosedDate" Format="MM/dd/yyyy" PopupPosition="BottomRight">
                                        </ajaxToolkit:CalendarExtender>
                                        <asp:RequiredFieldValidator ID="rqdClosedDate" runat="server" ControlToValidate="ddcClosedDate" Enabled="False" SetFocusOnError="true" ErrorMessage="Close date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>
                                        <asp:RequiredFieldValidator ID="rqdDropCloseDate" runat="server" ControlToValidate="ddcClosedDate" Enabled="False" SetFocusOnError="true" ErrorMessage="Close date is required" CssClass="warning" ForeColor="" Display="None" EnableClientScript="true" ValidationGroup="GrpDropStatus"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="compCommitOpen" runat="server" ControlToCompare="txtOpenDate"
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
                                                    &nbsp;&nbsp;<b>-Type 1:</b>&nbsp;Connected cells (&lt;50%),e.g. Mix of manual and automated tasks, e.g. manually operated fixture, or tooling with low automation.<br>
                                                    &nbsp;&nbsp;<b>-Type 2:</b>&nbsp;Connected lines (50%-75%), e.g. PLC/IPC, robotics, vision, etc. monitoring and control through HMI.<br>
                                                    &nbsp;&nbsp;<b>-Type 3:</b>&nbsp;Connected operations (>75%), no touch / minimum human intervention, supervisory control level.<br>
                                                    &nbsp;&nbsp;<b>-Type 4:</b>&nbsp;Connected eco-system, cloud, big data, real-time collaboration.<br>
                                                    &nbsp;&nbsp;<b>-N/A:</b>&nbsp;Automation projects without deployment in production floor, including research, studies, evaluations, papers, RFQ, etc... </span>
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
                                                <%-- <asp:ListItem Text="N/A" Value="NA"></asp:ListItem>--%>
                                            </asp:DropDownList>
                                        </td>
                                        <td class="Desc">

                                            <asp:Label ID="lblAutoStage" runat="server" Text="Stage"></asp:Label>
                                            <asp:RequiredFieldValidator ID="rfvAutoStage" runat="server" SetFocusOnError="true" ControlToValidate="drpAutoStage" CssClass="warning" ForeColor="" ErrorMessage="Stage is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        </td>
                                        <td class="NormalField">

                                            <asp:DropDownList ID="drpAutoStage" runat="server" Width="200px" OnSelectedIndexChanged="drpAutoStage_SelectedIndexChanged" AutoPostBack="true">
                                                <asp:ListItem Text="Select One Option" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Evaluation" Value="Eval"></asp:ListItem>
                                                <asp:ListItem Text="Define" Value="Define"></asp:ListItem>
                                                <asp:ListItem Text="Develop" Value="Develop"></asp:ListItem>
                                                <asp:ListItem Text="Deploy" Value="Deploy"></asp:ListItem>
                                                <%--<asp:ListItem Text="N/A" Value="N/A"></asp:ListItem>--%>
                                            </asp:DropDownList>
                                        </td>
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
                                        <td class="Desc">

                                            <asp:Label ID="Label18" runat="server" Text="Automation Category"></asp:Label>
                                            <asp:RequiredFieldValidator ID="rfvAutoType" runat="server" SetFocusOnError="true" ControlToValidate="drpAutomationType" CssClass="warning" ForeColor="" ErrorMessage="Automation Category is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        </td>
                                        <td class="NormalField" colspan="3">
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
                                                ValueToCompare="0" Display="None" ErrorMessage="Estimated Product Life value should be greater than 0" SetFocusOnError="true" Enabled="false"
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
                                            <asp:Label ID="Label43" runat="server" Text="Project Cost"></asp:Label>
                                            <asp:RequiredFieldValidator ID="rfvAutoProjCost" runat="server" ControlToValidate="txtAutomationProjectCost" SetFocusOnError="true"
                                                CssClass="warning" ForeColor="" ErrorMessage="Project Cost is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                            <asp:CompareValidator ID="cvPrjCost" runat="server" ControlToValidate="txtAutomationProjectCost"
                                                ValueToCompare="0" Display="None" ErrorMessage="Project cost value should be greater than 0" SetFocusOnError="true" Enabled="false"
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
                                                ValueToCompare="0" Display="None" ErrorMessage="Headcount Before Automation value should be greater than 0" SetFocusOnError="true" Enabled="false"
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
                                                ValueToCompare="0" Display="None" ErrorMessage="Expected IRR value should be greater than 0" SetFocusOnError="true" Enabled="false"
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
                                                ValueToCompare="0" Display="None" ErrorMessage="Planned Payback value should be greater than 0" SetFocusOnError="true" Enabled="false"
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
                                                ValueToCompare="0" Display="None" ErrorMessage="Estimated ROI value should be greater than 0" SetFocusOnError="true" Enabled="false"
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

                                            <asp:Label ID="Label44" runat="server" Text="Estimated Reuse %"></asp:Label>
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

                                            <asp:Label ID="Label45" runat="server" Text="Project Cost"></asp:Label>
                                            <asp:RequiredFieldValidator ID="rfvTDProjCost" runat="server" ControlToValidate="txtTestDevelopmentProjectCost" CssClass="warning" ForeColor="" ErrorMessage="Project Cost is required" Display="None" Enabled="false"></asp:RequiredFieldValidator>
                                        </td>
                                        <td class="NormalField" colspan="3">
                                            <asp:TextBox ID="txtTestDevelopmentProjectCost" runat="server" Width="85px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </tbody>
                                <tbody id="tbodyFinacialInfo" runat="server">
                                    <tr>
                                        <td nowrap="nowrap" class="DescLeft" align="center" id="Td5">
                                            <asp:Label ID="lblCostSavingRequired" runat="server" CssClass="warning" ForeColor="#B51E17"
                                                Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                            <asp:Label ID="Label4" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblTotalSavings" runat="server" />
                                            <%--<asp:Label ID="lblPlanSaving" runat="server" />
                                            <asp:Label ID="lblActualSaving" runat="server" />--%>
                                            <asp:TextBox ID="txtFinancialRqd" runat="server" Width="0px" Text="1" BackColor="Transparent" BorderStyle="None"></asp:TextBox>
                                            <asp:CustomValidator ID="cvFinancialRqd" runat="server" ClientValidationFunction="ValidateAutomationCostSaving"
                                                ErrorMessage="<%$ Resources:Default, COST_SAVING_REQUIRED %>" EnableClientScript="true" Enabled="false"
                                                ValidationGroup="GrpCloseDeploy" ControlToValidate="txtFinancialRqd" Display="None" ValidateEmptyText="true"></asp:CustomValidator>
                                            <asp:CustomValidator ID="cvPlannedVsActual" runat="server" ClientValidationFunction="ValidateAutomationPlannedVsActual"
                                                ErrorMessage="<%$ Resources:Default, COST_SAVING_MATCH %>" EnableClientScript="true" Enabled="false"
                                                ValidationGroup="GrpCloseDeployPaidBy" ControlToValidate="txtFinancialRqd" Display="None" ValidateEmptyText="true"></asp:CustomValidator>
                                            &nbsp;
                                            &nbsp;
                                        <a href="#" class="tooltipExampleOfCostSaving">
                                            <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton4" ImageUrl="~/Images/help.png" />
                                            <span><b>Examples of Financial Justification:</b>
                                                <br>
                                                <br>
                                                <img src="../Images/exampleSavingCost.JPG" alt="Example of cost saving" />
                                            </span>
                                        </a>

                                            <asp:ValidationSummary ID="vsInsertCostSaving" runat="server" Enabled="false" ValidationGroup="InsertCostSavingGroup" Visible="false" />
                                            <asp:ValidationSummary ID="vsUpdateCostSaving" runat="server" ValidationGroup="UpdateCostSavingGroup" Visible="false" />
                                        </td>
                                        <td class="NormalField" style="text-align: left;" colspan="3">
                                            <asp:GridView ID="grdCostSavings" runat="server" CellPadding="4" ForeColor="#333333" DataKeyNames="CostSavingId"
                                                GridLines="None" Width="297px" AutoGenerateColumns="False" DataSourceID="odsSavings" OnRowDeleted="grdCostSavings_RowDeleted" OnRowUpdated="grdCostSavings_RowUpdated" ShowFooter="True" OnRowDataBound="grdCostSavings_RowDataBound" OnRowUpdating="grdCostSavings_RowUpdating" Height="100px" Style="width: 100%">
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
                                                            <asp:DropDownList ID="drpAutomationSaving" runat="server" DataSourceID="odsAutomationSaving" DataTextField="AutomationSaving" DataValueField="ID" Width="130px" SelectedValue='<%# Bind("AutomationSavingId") %>' OnSelectedIndexChanged="drpAutomationSaving_SelectedIndexChanged" AutoPostBack="true" />
                                                            <asp:RequiredFieldValidator ID="rfvAutomationSaving" runat="server" ErrorMessage="Automation saving is required." ControlToValidate="drpAutomationSaving" InitialValue="0" Display="None" ValidationGroup="UpdateCostSavingGroup" Enabled="false" />
                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vceAutoSaving" runat="server" TargetControlID="rfvAutomationSaving" BehaviorID="b_vceAutoSaving">
                                                            </ajaxToolkit:ValidatorCalloutExtender>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:DropDownList ID="drpFooterdrpAutomationSaving" runat="server" DataSourceID="odsAutomationSavingFooter" DataTextField="AutomationSaving" DataValueField="ID" Width="130px" SelectedValue='<%# Bind("AutomationSavingId") %>' OnSelectedIndexChanged="drpAutomationSaving_SelectedIndexChanged" AutoPostBack="true" />
                                                            <asp:RequiredFieldValidator ID="rfvFooterdrpAutomationSaving" runat="server" ErrorMessage="Automation saving is required." ControlToValidate="drpFooterdrpAutomationSaving" InitialValue="0" Display="None" ValidationGroup="InsertCostSavingGroup" Enabled="false" />
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
                                                            <asp:RequiredFieldValidator ID="rfvSavingType" runat="server" ErrorMessage="<%$ Resources:Default, SAVING_TYPE_REQUIRED %>" ControlToValidate="drpSavingType" InitialValue="" Display="None" ValidationGroup="UpdateCostSavingGroup" Enabled="false" EnableClientScript="true" />
                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vceSavingType" runat="server" TargetControlID="rfvSavingType" BehaviorID="b_vceSavingType">
                                                            </ajaxToolkit:ValidatorCalloutExtender>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:DropDownList ID="drpFooterSavingType" runat="server" DataSourceID="odsSavingType" DataTextField="Description" DataValueField="Code" OnDataBound="drpSavingType_DataBound" Width="130px" SelectedValue='<%# Bind("SavingTypeId") %>' OnSelectedIndexChanged="drpSavingType_SelectedIndexChanged" AutoPostBack="true" />
                                                            <asp:RequiredFieldValidator ID="rfvFooterSavingType" runat="server" Text="*" ControlToValidate="drpFooterSavingType" InitialValue="" ErrorMessage="<%$ Resources:Default, SAVING_TYPE_REQUIRED %>" Display="None" ValidationGroup="InsertCostSavingGroup" Enabled="false" EnableClientScript="true" />
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
                                                            <asp:RequiredFieldValidator ID="rfvSavingCategory" runat="server" ErrorMessage="<%$ Resources:Default, SAVING_CATEGORY_REQUIRED %>" ControlToValidate="drpSavingCategory" InitialValue="" Display="None" ValidationGroup="UpdateCostSavingGroup" Enabled="false" EnableClientScript="true" />
                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vceSavingCategory" runat="server" TargetControlID="rfvSavingCategory" BehaviorID="b_vceSavingCategory">
                                                            </ajaxToolkit:ValidatorCalloutExtender>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:DropDownList ID="drpFooterSavingCategory" runat="server" DataSourceID="odsSavingCategory" DataTextField="Description" DataValueField="Code" OnDataBound="drpSavingCategory_DataBound" SelectedValue='<%# Bind("SavingCategoryId") %>' Width="130px" />
                                                            <asp:RequiredFieldValidator ID="rfvFooterSavingCategory" runat="server" ErrorMessage="<%$ Resources:Default, SAVING_CATEGORY_REQUIRED %>" ControlToValidate="drpFooterSavingCategory" InitialValue="" Display="None" ValidationGroup="InsertCostSavingGroup" Enabled="false" EnableClientScript="true" />
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
                                                            <%--<uc5:DropDownCalendar ID="ddcDate" runat="server" SelectedDateText='<%# Bind("DateString") %>' />--%>
                                                            <asp:TextBox ID="ddcDate" runat="server" Width="100px" CausesValidation="true" Text='<%# Bind("DateString", "{0:d}") %>'></asp:TextBox>
                                                            <ajaxToolkit:CalendarExtender ID="ddcDate_CalendarExtender" runat="server" Enabled="True"
                                                                TargetControlID="ddcDate" Format="MM/dd/yyyy" PopupPosition="BottomRight">
                                                            </ajaxToolkit:CalendarExtender>
                                                            <asp:RequiredFieldValidator ID="rfvDate" runat="server" ErrorMessage="<%$ Resources:Default, DATE_REQUIRED %>" ControlToValidate="ddcDate" InitialValue="" Display="None" ValidationGroup="UpdateCostSavingGroup" Enabled="false" EnableClientScript="true" />
                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vceDate" runat="server" TargetControlID="rfvDate" BehaviorID="b_vceDate">
                                                            </ajaxToolkit:ValidatorCalloutExtender>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <ajax:UpdatePanel ID="updFooterDate" runat="server" UpdateMode="Conditional">
                                                                <ContentTemplate>
                                                                    <%--<uc5:DropDownCalendar ID="ddcFooterDate" runat="server" SelectedDateText='<%# Bind("DateString") %>' />--%>
                                                                    <asp:TextBox ID="ddcFooterDate" runat="server" Width="100px" CausesValidation="true" Text='<%# Bind("DateString", "{0:d}") %>'></asp:TextBox>
                                                                    <ajaxToolkit:CalendarExtender ID="ddcFooterDate_CalendarExtender" runat="server" Enabled="True"
                                                                        TargetControlID="ddcFooterDate" Format="MM/dd/yyyy" PopupPosition="BottomRight">
                                                                    </ajaxToolkit:CalendarExtender>
                                                                </ContentTemplate>
                                                            </ajax:UpdatePanel>
                                                            <asp:RequiredFieldValidator ID="rfvFooterDate" runat="server" ErrorMessage="<%$ Resources:Default, DATE_REQUIRED %>" ControlToValidate="ddcFooterDate" InitialValue="" Display="None" ValidationGroup="InsertCostSavingGroup" Enabled="false" EnableClientScript="true" />
                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vceFooterDate" runat="server" TargetControlID="rfvFooterDate" BehaviorID="b_vceFooterDate">
                                                            </ajaxToolkit:ValidatorCalloutExtender>
                                                        </FooterTemplate>
                                                        <ControlStyle Width="150px" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="<%$ Resources:Default, SAVING_AMOUNT_HEADER %>">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblSavingAmount" runat="server" Text='<%# Bind("SavingAmount", "{0:c}") %>' Width="60px" />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:TextBox ID="txtSavingAmount" runat="server" Text='<%# Bind("SavingAmount", "{0:#.00}") %>' Width="60px" />
                                                            <asp:RegularExpressionValidator ID="revSavingAmt" runat="server" ControlToValidate="txtSavingAmount" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_INVALID %>" ValidationGroup="UpdateCostSavingGroup" ValidationExpression="(^[0-9]+([.][0-9]{1,2}){0,1}$)" Display="None" CssClass="warning" ForeColor="" Enabled="false" EnableClientScript="true"></asp:RegularExpressionValidator>
                                                            <asp:RequiredFieldValidator ID="rfvSavingAmount" runat="server" ControlToValidate="txtSavingAmount" CssClass="warning" Display="None" Enabled="false" ValidationGroup="UpdateCostSavingGroup" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_REQUIRED %>" ForeColor="" EnableClientScript="true"></asp:RequiredFieldValidator>

                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vceSavingAmt" runat="server" TargetControlID="revSavingAmt" BehaviorID="b_vceSavingAmt">
                                                            </ajaxToolkit:ValidatorCalloutExtender>
                                                            <ajaxToolkit:ValidatorCalloutExtender ID="vcerfvSavingAmount" runat="server" TargetControlID="rfvSavingAmount" BehaviorID="b_vcerfvSavingAmount">
                                                            </ajaxToolkit:ValidatorCalloutExtender>

                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:TextBox ID="txtFooterSavingAmount" runat="server" Text='<%# Bind("SavingAmount") %>' Width="60px" />
                                                            <asp:RegularExpressionValidator ID="revFootSavAmt" runat="server" ControlToValidate="txtFooterSavingAmount" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_INVALID %>" ValidationGroup="InsertCostSavingGroup" ValidationExpression="(^[0-9]+([.][0-9]{1,2}){0,1}$)" Display="None" CssClass="warning" ForeColor="" Enabled="false" EnableClientScript="true"></asp:RegularExpressionValidator>
                                                            <asp:RequiredFieldValidator ID="rfvFooterSavingAmount" runat="server" ControlToValidate="txtFooterSavingAmount" CssClass="warning" Display="None" Enabled="false" ValidationGroup="InsertCostSavingGroup" ErrorMessage="<%$ Resources:Default, SAVING_AMOUNT_REQUIRED %>" ForeColor="" EnableClientScript="true"></asp:RequiredFieldValidator>
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
                                                            <asp:ImageButton ImageUrl="~/Images/add.png" ToolTip="Add Cost Saving" ID="btnAdd" runat="server" CommandName="AddCostSaving" ValidationGroup="InsertCostSavingGroup" OnClick="btnAdd_Click" />
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
                                            <asp:ObjectDataSource ID="odsSavings" runat="server" DeleteMethod="DeleteCostSaving" ConflictDetection="OverwriteChanges" InsertMethod="InsertCostSaving" SelectMethod="GetAllCostSaving" TypeName="ProjectTracker.Business.CostSavingDataSource" DataObjectTypeName="ProjectTracker.Business.CostSaving" UpdateMethod="UpdateCostSaving" OnSelected="odsSavings_Selected" OldValuesParameterFormatString="original_{0}">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="gvProjects" Name="ProjectId" PropertyName="SelectedValue"
                                                        Type="Int32" />
                                                </SelectParameters>
                                            </asp:ObjectDataSource>
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
                                </tbody>
                                <%--<tbody id="tbodyCapexAppvdDate" runat="server" style="display: none;">
                                    <tr>
                                        <td class="Desc">
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
                                <tbody id="tbodyPaidbyInfo" runat="server" style="display: none;">
                                    <tr>
                                        <td class="DescLeft">
                                            <asp:Label ID="lblPaidFlex" runat="server" Text="Paid by"></asp:Label>
                                        </td>
                                        <td class="NormalField">
                                            <asp:RadioButtonList ID="rblPaidFlex" runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" Font-Bold="true" OnSelectedIndexChanged="rblPaidFlex_SelectedIndexChanged" AutoPostBack="true" >
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
                                                ControlToValidate="txtPrjNumber" runat="server" CssClass="warning" ForeColor="" ErrorMessage="eCPX Number should be 10 digits" EnableClientScript="true" ValidationExpression="^\d{10}$"></asp:RegularExpressionValidator>
                                        </td>
                                    </tr>
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
                                            <asp:RequiredFieldValidator ID="rfvReturnInvest" runat="server" ControlToValidate="txtReturnInvest" SetFocusOnError="true" CssClass="warning" ForeColor="" ErrorMessage="Return on Investment Link is required" Display="None" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
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
                                    <td class="DescLeft">
                                        <asp:RequiredFieldValidator ID="rqdEngRepNum" runat="server" ControlToValidate="TextBox6" SetFocusOnError="true" Enabled="false" CssClass="warning" Display="None" ErrorMessage="Eng. Report # is required" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label40" runat="server" Text="Eng. Report #"></asp:Label>
                                        <a href="#" class="tooltipEngReportNo">
                                            <asp:ImageButton ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton5" ImageUrl="~/Images/help.png" />
                                            <span>Mandatory for closed project e.g. Eng_2000 </span>
                                        </a>
                                        <asp:Label ID="lblEngRepNumRequired" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField" colspan="3">
                                        <asp:TextBox ID="TextBox6" runat="server" MaxLength="150" Text='<%# Bind("eRoom") %>'></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="fbtbEngrepNum" runat="server"
                                            TargetControlID="TextBox6"
                                            FilterType="Numbers" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="DescLeft" style="width: 150px" nowrap="nowrap">
                                        <asp:RequiredFieldValidator ID="rfvEngReportLink" runat="server" ControlToValidate="txtEngReportLink" SetFocusOnError="true" Enabled="false" CssClass="warning" Display="None" ErrorMessage="Eng.Report Link is required" ForeColor="" EnableClientScript="true" ValidationGroup="GrpClosedStatus"></asp:RequiredFieldValidator>
                                        <asp:Label ID="Label8" runat="server" Text="Eng.Report Link"></asp:Label>
                                        <a href="#" class="tooltipEngReportLink">
                                            <asp:ImageButton Style="z-index: -999;" ImageAlign="AbsMiddle" OnClientClick="return false;" runat="server" ID="ImageButton6" ImageUrl="~/Images/help.png" />
                                            <span>e.g. http://intranet.flextronics.com/go/GOEng/EngineeringReports/ssue_R2.pptx </span>
                                        </a>
                                        <asp:Label ID="lblrfvEngReportLink" runat="server" CssClass="warning" ForeColor="#B51E17" Text="&nbsp;&nbsp;&nbsp;"></asp:Label>
                                    </td>
                                    <td class="NormalField" colspan="3">
                                        <asp:TextBox ID="txtEngReportLink" runat="server" Width="650px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <table>
                                            <tr>
                                                <td class="DescLeft">
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
                                                            <br />
                                                                <br />
                                                                2. A Best Practice being shared needs to be repeatable and scalable. Some home-grown / site-specific best practices use specific software / programming that cannot be copied or scaled to other sites, please ensure repeatability and scalability.
                                                            <br />
                                                                <br />
                                                                3. Every Best Practice needs to have a go-to-person/ SME and also an alternate contact, to provide for SME going on vacation.
                                                            <br />
                                                                <br />
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
                                        <asp:RequiredFieldValidator ID="rfvPercentCompletion" runat="server" ControlToValidate="txtPercentCompletion" SetFocusOnError="true" CssClass="warning" Display="None" ErrorMessage="Progress is required." ForeColor="" EnableClientScript="true" ValidationGroup="Group1"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="revInvalidNotClosedProgressValue" EnableClientScript="true" runat="server" SetFocusOnError="true" ControlToValidate="txtPercentCompletion" ErrorMessage="Progress value is invalid." ValidationExpression="(^(([0-9]{1,2}([.][0-9]{1,2}){0,1})|([1][0][0]([.][0]{1,2}){0,1}))$)" CssClass="warning" ForeColor="" Display="None" ValidationGroup="Group1"></asp:RegularExpressionValidator>
                                        <asp:RegularExpressionValidator ID="revInvalidClosedProgressValue" EnableClientScript="true" runat="server" SetFocusOnError="true" ControlToValidate="txtPercentCompletion" ErrorMessage="Progress value is invalid." ValidationExpression="(^([1][0][0]([.][0]{1,2}){0,1})$)" CssClass="warning" ForeColor="" Display="None" ValidationGroup="Group1"></asp:RegularExpressionValidator>
                                    </td>
                                    <td class="NormalField">
                                        <asp:TextBox ID="txtPercentCompletion" runat="server" Text='<%# Bind("PercentageCompletion", "{0:N0}") %>' Width="85px" MaxLength="3"></asp:TextBox>
                                        <ajaxToolkit:FilteredTextBoxExtender ID="fbtbPerComp" runat="server"
                                            TargetControlID="txtPercentCompletion"
                                            FilterType="Numbers" />
                                        <asp:Label ID="Label12" runat="server" Text="###" />
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
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Qualified sample succesfully </span>
                                        </a>
                                    </td>
                                    <td colspan="3" class="NormalField">
                                        <asp:TextBox Style="width: 100%" ID="txtRemarks" runat="server" Height="100px" Text='<%# Bind("Remarks") %>' TextMode="MultiLine"></asp:TextBox>
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
                                    <%-- <ajaxToolkit:ValidatorCalloutExtender ID="vceCapex" runat="server" TargetControlID="rfvCapexAppd" BehaviorID="b_vceCapex">
                                    </ajaxToolkit:ValidatorCalloutExtender>--%>
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vceCapexAppvdDate" runat="server" TargetControlID="rfvCapexAppvdDate" BehaviorID="b_vceCapexAppvdDate">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vcePoIssued" runat="server" TargetControlID="rfvPOIssued" BehaviorID="b_vcePoIssued">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vcePaidFlex" runat="server" TargetControlID="rfvPaidFlex" BehaviorID="b_vcePaidFlex">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <%--<ajaxToolkit:ValidatorCalloutExtender ID="vceCVCapex" runat="server" TargetControlID="cvCapexAppd" BehaviorID="b_vceCVCapex">
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
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <!-- This is for Financial Justification for automation -->
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vcerblBestPractice" runat="server" TargetControlID="rfvrblBestPractice" BehaviorID="b_vcerblBestPractice">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vcetxtBPComment" runat="server" TargetControlID="rfvtxtBPComment" BehaviorID="b_vcetxtBPComment">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                    <ajaxToolkit:ValidatorCalloutExtender ID="vcecvBpComment" runat="server" TargetControlID="cvBpComment" BehaviorID="b_vcecvBpComment">
                                    </ajaxToolkit:ValidatorCalloutExtender>
                                </tr>
                                <tr>
                                    <td class="Footer" colspan="4" style="width: 100%; border-right: #f8f7f7 1px solid; border-top: #f8f7f7 1px solid; border-left: #f8f7f7 1px solid; border-bottom: #f8f7f7 1px solid">
                                        <div>
                                            <asp:ImageButton ID="ImageButton2" runat="server" CommandName="Update" ImageUrl="~/Images/Save.jpg" OnClientClick="javascript:return ValidatePage();" />&nbsp;
                                    <asp:ImageButton
                                        ID="btnPrevious" runat="server" CausesValidation="False" ImageUrl="~/Images/Previous.jpg"
                                        OnClick="imgPrevious_Click" />
                                        </div>
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
                                    <td nowrap class="Header">
                                        <asp:Label ID="lblHeaderCode" runat="server" Text="<%$ Resources:Default, CODE %>"></asp:Label>
                                    </td>
                                    <td nowrap>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Code") %>'></asp:Label>
                                    </td>
                                    <td nowrap class="Header">
                                        <asp:Label ID="lblHeaderCategory" runat="server" Text="<%$ Resources:Default, CATEGORY %>"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("PA_DESCRICAO") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label15" runat="server" Text="<%$ Resources:Default, DESCRIPTION %>"></asp:Label>
                                    </td>
                                    <td nowrap colspan="3">
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Description") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label17" runat="server" Text="<%$ Resources:Default, CUSTOMER %>"></asp:Label>
                                    </td>
                                    <td colspan="3">
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("PC_DESCRICAO") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label16" runat="server" Text="<%$ Resources:Default, USERNAME %>"></asp:Label>
                                    </td>
                                    <td colspan="2" nowrap>
                                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("Name") %>'></asp:Label>-
                                <asp:Label ID="Label14" runat="server" Text='<%# Eval("Username") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label18" runat="server" Text="<%$ Resources:Default, LOCATION %>"></asp:Label>
                                    </td>
                                    <td nowrap>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("PL_DESCRICAO") %>'></asp:Label>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label19" runat="server" Text="<%$ Resources:Default, OPEN_DATE %>"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Bind("OpenDate", "{0:d}") %>'></asp:Label>
                                    </td>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label20" runat="server" Text="<%$ Resources:Default, COMMIT_DATE %>"></asp:Label>
                                    </td>
                                    <td nowrap>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("CommitDate", "{0:d}") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label22" runat="server" Text="<%$ Resources:Default, STATUS %>"></asp:Label>
                                    </td>
                                    <td nowrap>
                                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("PS_DESCRICAO") %>'></asp:Label>
                                    </td>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label21" runat="server" Text="<%$ Resources:Default, CLOSED_DATE %>"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label9" runat="server" Text='<%# Bind("ClosedDate", "{0:d}") %>'></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label Width="160px" ID="Label23" runat="server" Text="<%$ Resources:Default, COST_SAVING %>"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("CostSaving", "{0:c}") %>'></asp:Label>
                                    </td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td nowrap class="Header">
                                        <asp:Label ID="Label24" runat="server" Text="<%$ Resources:Default, REMARKS %>"></asp:Label>
                                    </td>
                                    <td nowrap colspan="3">
                                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("Remarks") %>'></asp:Label>
                                    </td>
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
                                        <asp:Label ID="Label33" runat="server" Text="<%$ Resources:Default, INSERT_NEW_PROJECT&#9; %>"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="Footer">
                                        <asp:ImageButton ID="ImageButton1" runat="server" CommandName="New" ImageUrl="~/Images/Add.jpg" />
                                    </td>
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
                UpdateMethod="UpdateQuery" OnDeleted="obsDataSource_Deleted" OnInserted="obsDataSource_Inserted" OnUpdated="obsDataSource_Updated" OnInserting="obsProjects_Inserting" OnUpdating="obsProjects_Updating" OnSelecting="obsProjects_Selecting" OnDeleting="obsProjects_Deleting" OnSelected="obsProjects_Selected">
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
                    <asp:Parameter Name="SiteLead" Type="String" />
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
                    <asp:ControlParameter ControlID="txtProjectCode" DefaultValue="%" Name="ProjectCode"
                        PropertyName="Text" Type="String" />

                    <asp:ControlParameter ControlID="drpRegionS" DefaultValue="%" Name="RegionCode" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:ControlParameter ControlID="drpSavingCategoryS" DefaultValue="%" Name="SavingCategoryCode" PropertyName="SelectedValue"
                        Type="String" />
                    <asp:Parameter Name="UserViewrs" Type="String" />
                    <asp:Parameter DefaultValue="%" Name="sort" Type="String" />
                    <asp:Parameter Name="IsGuestUser" Type="Boolean" />
                    <asp:ControlParameter ControlID="drpRevenueCostSaving" DefaultValue="%" Name="revenueCostSaving"
                        PropertyName="SelectedValue" Type="String" />
                    <asp:ControlParameter ControlID="FromYearTxt" DefaultValue="%" Name="StartDate" PropertyName="Text" Type="String" />
                    <asp:ControlParameter ControlID="ToYearTxt" DefaultValue="%" Name="EndDate" PropertyName="Text" Type="String" />
                    <asp:Parameter Name="CurrentPage" Type="Int32" />
                    <asp:Parameter Name="TotalCount" Type="Int32" Direction="Output" DefaultValue="0" />
                </SelectParameters>
            </asp:ObjectDataSource>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <script language="javascript" type="text/javascript">
        var url = window.location.href;
        if (url.indexOf('projectID=') > -1) {
            if (document.getElementById('<%=hdfHaveClicked.ClientID %>').value != '1') {
                var id = document.getElementById('<%=hdfEditBtnID.ClientID %>').value;
                document.getElementById('<%=hdfHaveClicked.ClientID %>').value = '1';
                document.getElementById(id).click();
            }
        }
    </script>
</asp:Content>
