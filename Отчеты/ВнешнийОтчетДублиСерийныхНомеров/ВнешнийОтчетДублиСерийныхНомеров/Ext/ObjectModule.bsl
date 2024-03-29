﻿Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура ;
	ПараметрыРегистрации.Вставить("Вид","ДополнительныйОтчет");
	ПараметрыРегистрации.Вставить("Наименование","Отчет по дублям серийных номеров");
	ПараметрыРегистрации.Вставить("Версия","2.0");
	ПараметрыРегистрации.Вставить("Информация","Отчет по дублям серийных номеров");
	ПараметрыРегистрации.Вставить("БезопасныйРежим",Истина);
	
	Команды = ПолучитьТаблицуКоманд() ;
	ДобавитьКоманду(Команды, "Отчет по дублям серийных номеров","Основной","ОткрытиеФормы",Ложь,) ;
	
	ПараметрыРегистрации.Вставить("Команды",Команды) ;
	
	Возврат ПараметрыРегистрации;
КонецФункции

Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции	

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры
