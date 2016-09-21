<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="KomplitWebApp._Default" 
    EnableViewState="false" EnableSessionState="False" %>
<%@ Register assembly="AjaxDataControls" namespace="AjaxDataControls" tagprefix="AjaxData" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Комплит</title>
    <link rel="Stylesheet" href="Resources/css/Stylesheet.css" type="text/css" /> 
    <link rel="Stylesheet" href="Resources/css/bootstrap.css" type="text/css" /> 
    <script type="text/javascript" src="Resources/js/jquery.js"></script>
    <script type="text/javascript" src="Resources/js/bootstrap.min.js"></script>
</head>
<body>
    <center>
    <button class="addButton btn btn-info" id="addBtn" onclick="showPopup()" style="display:none">Добавить новый контакт</button>
	<div class="popup">
		<div class="popup_bg"></div>
		<div class="form">
        <form method="POST" action="javascript:void(null);" onsubmit="CreateContact(this)">
            <legend>Добавьте новый контакт</legend>
            <label for="Name"></label><input id="name" name="Name" value="" type="text" placeholder="ФИО">
            <label for="Dear"></label><input id="dear" name="Dear" value="" type="text" placeholder="Имя">
            <label for="BirthDate"></label><input id="Text1" name="BirthDate" value="" type="text" placeholder="Дата рождения DD.MM.YYYY">
            <label for="JobTitle"></label><input id="Text2" name="JobTitle" value="" type="text" placeholder="Должность">
            <label for="MobilePhone"></label><input id="Text3" name="MobilePhone" value="" type="text" placeholder="Телефон +375-29-123-45-67">
            <input value="Добавить контакт" type="submit" class="btn btn-primary">
        </form>
		</div>
	</div>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    <Services>
        <asp:ServiceReference Path="~/ContactService.svc" />
    </Services>
    </asp:ScriptManager>
        
        <div id="loadMessageDiv" style="display:none">
            <img src="Resources/loading.gif" alt="" />
        </div>
        
    <AjaxData:GridView ID="gridView" runat="server" AllowPaging="True" 
PageSize="10" CssClass="StdGrd" DataKeyName="Id"
        EditCommandEvent="OnEditContact" 
        UpdateCommandEvent="OnUpdateContact" 
        CancelCommandEvent="OnCancelUpdate" 
        DeleteCommandEvent="OnDeleteContact">


        <FooterStyle CssClass="StdGrdFooter" />
        <RowStyle CssClass="StdGrdRow" />
        <AlternatingRowStyle CssClass="StdGrdAltRow" />
        <SelectedRowStyle CssClass="StdGrdSelectedRow" />
        <HeaderStyle CssClass="StdGrdHeader" />
        <EmptyDataRowStyle CssClass="StdGrdEmptyRow" />
        <EditRowStyle CssClass="StdGrdEditRow" />
    
        <Columns>
            <AjaxData:GridViewBoundColumn HeaderText="ФИО" DataField="Name" />
            <AjaxData:GridViewBoundColumn HeaderText="Имя" DataField="Dear"  />
            <AjaxData:GridViewBoundColumn HeaderText="Год рождения" DataField="BirthDate"  />
            <AjaxData:GridViewBoundColumn HeaderText="Должность" DataField="JobTitle"  />
            <AjaxData:GridViewBoundColumn HeaderText="Мобильный телефон" DataField="MobilePhone"  />

            <AjaxData:GridViewCommandColumn ButtonType="Link"
                ShowEditButton="true"
                ShowDeleteButton="true" 
                ShowCancelButton="true" />
        </Columns>

  </AjaxData:GridView>
</form>

 <script type="text/javascript">
 var _people;
 var _loadMessageDiv;
 var _gridView;

function pageLoad() {
   _loadMessageDiv = $get('loadMessageDiv');
   _gridView = $find('<%= gridView.ClientID %>');
    GetContacts();
    $(".popup_bg").click(function () {
        $(".popup").fadeOut(200);
    });
}

function OnError(result) {
    alert("Error: " + result.get_message());
}

function GetContacts() {
    showLoadIndicator();
    Komplit.IContactService.GetContacts(OnGetContactsComplete);
}

function OnGetContactsComplete(result) {
    _people = result;
    DataBindGridView();
    hideLoadIndicator();
    showAddContactButton();
}

function DataBindGridView() {
    _gridView.set_dataSource(_people);
    _gridView.dataBind();
}

function OnEditContact(sender, e) {
    var rowIndex = e.get_row().get_rowIndex();
    _gridView.set_editIndex(rowIndex);
    DataBindGridView();
}

function OnUpdateContact(sender, e) {
    var row = e.get_row();
    var personId = _gridView.get_dataKeys()[e.get_row().get_rowIndex()];
    var name = row.get_container().childNodes[0].childNodes[0];
    var dear = row.get_container().childNodes[1].childNodes[0];
    var birthdate = row.get_container().childNodes[2].childNodes[0];
    var jobtitle = row.get_container().childNodes[3].childNodes[0];
    var mobilephone = row.get_container().childNodes[4].childNodes[0];

    if (isValidFio(name.value) && isValidDate(birthdate.value) && isValidPhone(mobilephone.value) && jobtitle.value) {
        var person = {
            "Id": personId,
            "Name": name.value,
            "Dear": dear.value,
            "BirthDate": birthdate.value,
            "JobTitle": jobtitle.value,
            "MobilePhone": mobilephone.value
        };
        Komplit.IContactService.UpdateContact(person, OnUpdateContactSuccess);
    } else {
        alert("Проверьте корректность введенных данных");
    }
}

function OnUpdateContactSuccess(result) {
    if (result == true) {
        _gridView.set_editIndex(-1);
        GetContacts();
        alert("Контакт успешно обновлен");
    }
}

function OnCancelUpdate(sender, e) {
    _gridView.set_editIndex(-1);
    DataBindGridView();
}

function OnDeleteContact(sender, e) {
    var row = e.get_row();
    var personId = _gridView.get_dataKeys()[e.get_row().get_rowIndex()];
    Komplit.IContactService.DeleteContact(personId, OnDeleteContactSuccess);
}

function OnDeleteContactSuccess(result) {
    if (result == true) {
        _gridView.set_editIndex(-1);
        GetContacts();
        alert("Контакт успешно удален");
    } else { alert("У вас нет прав на удаление этого контакта"); }
}
function showLoadIndicator() {
    _loadMessageDiv.style.display = '';
}
function hideLoadIndicator() {
    _loadMessageDiv.style.display = 'none';
}
function hideAddContactButton() {
    document.getElementById("addBtn").style.display = 'none';

}
function showAddContactButton() {
    document.getElementById("addBtn").style.display = '';
}
function isValidDate(value) {
    var arrD = value.split(".");
    arrD[1] -= 1;
    var d = new Date(arrD[2], arrD[1], arrD[0]);
    if ((d.getFullYear() == arrD[2]) && (d.getMonth() == arrD[1]) && (d.getDate() == arrD[0])) {
        if (d.getFullYear() < new Date().getFullYear() - 100 || d.getFullYear() > new Date().getFullYear())
        {
            return false;
        }
        return true;
    } else {
        return false;
    }
}
function isValidFio(value) {
    return /^[А-ЯЁ][а-яё]+ [А-ЯЁ][а-яё]+ [А-ЯЁ][а-яё]+$/.test(value);
}
function isValidPhone(value) {
    return /^\+\d{1,3}\(\d{2,3}\)\d{3}-\d{2}-\d{2}$/.test(value);
}
function showPopup() {
    $(".popup").fadeIn(200);
}

function CreateContact(form) {
    if (form.elements.name.value && form.elements.Dear.value && form.elements.BirthDate.value && form.elements.JobTitle.value && form.elements.MobilePhone.value) {
        if (isValidFio(form.elements.name.value) && isValidDate(form.elements.BirthDate.value) && isValidPhone(form.elements.MobilePhone.value)) {
            var person = {
                "Name": form.elements.name.value,
                "Dear": form.elements.Dear.value,
                "BirthDate": form.elements.BirthDate.value,
                "JobTitle": form.elements.JobTitle.value,
                "MobilePhone": form.elements.MobilePhone.value
            };
            Komplit.IContactService.CreateContact(person, OnCreateContactSuccess);
            
        } else {
            alert("Ошибка валидации. Введите данные в правильном формате");
        }
    } else {
        alert("Введены не все данные");
    }

}
function OnCreateContactSuccess(result) {
    if (result == true) {
        _gridView.set_editIndex(-1);
        $(".popup").fadeOut(200);
        alert("Контакт успешно создан");
        GetContacts();
    }
}

 </script>
 </body>
</html>
