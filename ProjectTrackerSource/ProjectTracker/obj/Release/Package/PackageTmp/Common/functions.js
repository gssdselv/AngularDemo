var objForm;
var rowBackgroundColor;

function triggerEvent(objSender) {
	objForm = document.forms(0);
	eval(objSender.name + "_On" + event.type + "(objSender)");
}

function lnkPageNavigator_Onclick(objSender) {
	objForm.action = objSender.value;
	objForm.submit();
}

function changePassword(){
	openwindowChangePassword("Includes/frm_changePassword.asp",'FileIII','no');
}

function openwindowChangePassword(window_par,name,bolLocation)
{
	win = window.open(window_par,name,"status=yes,toolbar=yes,menubar=yes,scrollbars=yes,location="+bolLocation+",replace=yes,resizable=yes,width=500,height=210");
	win.focus();
}



function checkCHR13(){
    alert('OPa');
	if (window.event.keyCode == 13) {
		if(ValidFieldsMandatory()){
			Frm_Login.submit();
		}else{
			return false
		}			
	}
}

function blockCHR13(){
	alert('OPA');
	if (window.event.keyCode != 13) {
		if(ValidFieldsMandatory()){
			Frm_Login.submit();

		}else{
			return false			
		}			
	}
}

function makeMask(edtObject,separatorChar)
{
	var strLen = edtObject.value

	if (event.keyCode != 8) {
		if ((strLen.length == 2) || (strLen.length == 5))
			edtObject.value = edtObject.value + separatorChar
	}
}

		
function keyPress(objEdt,aryMask,only){
	formatKey(event,only);
	makeMask(objEdt,aryMask);
}
		
function formatKey(event,only){
	lowerCase = ((event.keyCode>=97) && (event.keyCode<=123));
	if(lowerCase) event.keyCode -= 32;
		
	space    = (event.keyCode==32);
	upperCase = ((event.keyCode>=65) && (event.keyCode<=90));
	number   = ((event.keyCode>=48) && (event.keyCode<=57))
		
	if ((only=='L') && !upperCase && !space) event.keyCode = null;
	if ((only=='N') && !number) event.keyCode = null;
}

function openwindow(window_par,width_par,height_par,name) {
    var win			 = null;
    var LeftPosition = 0;
    var TopPosition  = 0;
    LeftPosition	 = (screen.width) ? (screen.width-width_par)/4 : 0;
    TopPosition		 = (screen.height) ? (screen.height-height_par)/4 : 0;
    return window.open(window_par,name,"height="+height_par+",width="+width_par+",top="+TopPosition+",left="+LeftPosition+",status=no,toolbar=no,menubar=yes,scrollbars=yes,location=no,replace=yes,resizable=yes");
}

//-------------------------------------------------------------
// Select all the checkboxes (Hotmail style)
//-------------------------------------------------------------
function SelectAllCheckboxes(spanChk)
{

// Added as ASPX uses SPAN for checkbox 
// var oItem = spanChk.children;
// var theBox = oItem.item(0);
xState = spanChk.checked;    

elm = spanChk.form.elements;

for (i=0; i < elm.length; i++)
    if (elm[i].type == "checkbox" && elm[i].id != spanChk.id)
    {
        //elm[i].click();
        if(elm[i].checked != xState)
        elm[i].click();
        //elm[i].checked=xState;
    }
}

//-------------------------------------------------------------
//----Select highlish rows when the checkboxes are selected
//
// Note: The colors are hardcoded, however you can use 
//       RegisterClientScript blocks methods to use Grid's
//       ItemTemplates and SelectTemplates colors.
//         for ex: grdEmployees.ItemStyle.BackColor OR
//                 grdEmployees.SelectedItemStyle.BackColor
//-------------------------------------------------------------
function HighlightRow(chkB)    
{
    // var oItem = chkB.children;
    xState = chkB.checked;
    if(xState)
        {
            // Armazenar a cor da célula modificada
            rowBackgroundColor = chkB.parentElement.parentElement.style.backgroundColor;
            chkB.parentElement.parentElement.style.backgroundColor = "#FFFFE5";
            // grdEmployees.SelectedItemStyle.BackColor
            // chkB.parentElement.parentElement.style.color='white'; 
            // grdEmployees.SelectedItemStyle.ForeColor
        }
        else 
        {
            // Recuperar a cor da célula
            chkB.parentElement.parentElement.style.backgroundColor = rowBackgroundColor; 
            //grdEmployees.ItemStyle.BackColor
            // chkB.parentElement.parentElement.style.color='black'; 
            //grdEmployees.ItemStyle.ForeColor
        }
}
// -->

// Abre a janela de anexos do numerário
function OpenAttachments(nummaryID, company, type)
{
    var win = window.open("NummaryAttachs.aspx?Nummary=" + nummaryID + "&Company=" + company + "&Type=" + type, "AttachFile", "status=yes,toolbar=no,menubar=no,scrollbars=yes,location=no,replace=yes,resizable=yes,width=850,height=500");
    win.focus();
}

// Report Windows
function OpenNummaryDetailRep(documentID)
{
    link = "NummaryDetailRep.aspx?sn_numero=" + documentID;
    window.open(link, "_blank", "width=880,height=600");
}

function OpenPurchaseOrderDetailRep(documentID)
{
    link = "PurchaseOrderDetailRep.aspx?som_numero=" + documentID;
    window.open(link, "_blank", "width=880,height=600");
}

function OpenQuotationDetailRep(documentID)
{
    link = "QuotationDetailRep.aspx?sso_numero=" + documentID;
    window.open(link, "_blank", "width=880,height=600");
}

function OpenWorkFlowRep(documentType, documentCode)
{
    link = "WorkFlowRep.aspx?type=" + documentType + "&code=" + documentCode;
    window.open(link, "_blank", "width=880,height=600");
}

function OpenDocumentDetailRep(documentType, documentCode)
{
    link = "DocumentDetailRep.aspx?type=" + documentType + "&code=" + documentCode;
    window.open(link, "_blank", "width=880,height=600");
}

function ConfirmDelete(message){
    Alert(message);
        // return confirm(message);
}

//
// Self
//
function OpenAttachmentsSelf(nummaryID, company, type)
{
    var win = window.open("NummaryAttachs.aspx?Nummary=" + nummaryID + "&Company=" + company + "&Type=" + type, "_self", "status=yes,toolbar=no,menubar=no,scrollbars=yes,location=no,replace=yes,resizable=yes,width=850,height=500");
    win.focus();
}

function OpenWorkFlowRepSelf(documentType, documentCode)
{
    link = "WorkFlowRep.aspx?type=" + documentType + "&code=" + documentCode;
    window.open(link, "_self", "width=880,height=600");
}

function OpenDocumentDetailRepSelf(documentType, documentCode)
{
    link = "DocumentDetailRep.aspx?type=" + documentType + "&code=" + documentCode;
    window.open(link, "_self", "width=880,height=600");
}

//
// MaxLength no TextBox Multiline
//
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


