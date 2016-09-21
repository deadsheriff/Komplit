# Komplit
Выполнен WCF-сервис, который позволяет коннектиться к удаленному API и выполнять с данными, которые там находятся CRUD-операции.
C-U-D операции выполняются с помощью соответствующих HTTP запросов (PUT, POST,DELETE).<br> Логика извлечения всей коллекции контактов
выполнена с помощью DataServiceQuery запроса к API.
Клиент выполнен в виде *aspx страницы, с AjaxGridView(GridView, позволяющий выполнять ajax запросы с привязкой операций к WCF сервису).
#Валидация
1)Новый контакт создается только со всеми заполненными и валидными полями.<br>
2)Обновление контакта происходит полностью, вне зависимости от количества изменяемых полей. Таким образом, к примеру, нельзя задать номер телефона
персоне с невалидным либо отсутствующим ФИО и т.д.<br>
##Для тестов
ФИО валидно если состоит из трёх слов, начинающихся с прописной буквы.<br>
Номера мобильных телефонов валидны в двух жестких форматах:<br>
+d(ddd)ddd-dd-dd<br>
+ddd(dd)ddd-dd-dd<br>
Дата рождения валидна в формате<br>
dd.mm.yyyy



