﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ПрограммныйИнтерфейс
	
	// Процедура печати документа.
	//
	&НаКлиенте
	Процедура Печать(МассивОбъектов,  КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
		//УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
		//КоллекцияПечатныхФорм,
		//"ПЕЧАТЬЭТИКЕТОК",
		//НСтр("ru = 'Печать этикеток'"),
		//СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати),
		//,
		//"МакетПечатиЭтикеток"); 
		
		//ПараметрыФормы = Новый Структура;
		//ПараметрыФормы.Вставить("МассивОбъектов", МассивОбъектов);
		//ПараметрыФормы.Вставить("КоллекцияПечатныхФорм", КоллекцияПечатныхФорм);
		//ПараметрыФормы.Вставить("ОбъектыПечати", ОбъектыПечати);
		//ПараметрыФормы.Вставить("ПараметрыВывода", ПараметрыВывода);
		//
		//ОткрытьФорму("ВнешняяОбработка.ВнешняяПечатнаяФормаПечатиЭтикеток.Форма",ПараметрыФормы);
		
	КонецПроцедуры
	
	Функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати)
		
		УстановитьПривилегированныйРежим(Истина);
		
		Макет = ПолучитьМакет("ПР_МакетПечатиЭтикеток");
		
		ТабличныйДокумент = Новый ТабличныйДокумент;
		
		// Зададим параметры макета по-умолчанию
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		ТабличныйДокумент.ИмяПараметровПечати = "МакетПечатиЭтикеток";
		ТабличныйДокумент.АвтоМасштаб = Истина;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	itilprofПоступлениеАктивовАктивы.КонфигурационнаяЕдиница КАК КонфигурационнаяЕдиница,
		|	itilprofПоступлениеАктивовАктивы.Ссылка.Дата КАК Дата,
		|	itilprofПоступлениеАктивовАктивы.Ссылка.Организация КАК Организация,
		|	itilprofПоступлениеАктивовАктивы.Актив.ПР_СерийныйНомер КАК АктивПР_СерийныйНомер
		|ИЗ
		|	Документ.itilprofПоступлениеАктивов.Активы КАК itilprofПоступлениеАктивовАктивы
		|ГДЕ
		|	itilprofПоступлениеАктивовАктивы.Ссылка В(&Ссылка)");
		Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
		Выборка = Запрос.Выполнить().Выбрать();
		
		ОбластьМакетаШапка = Макет.ПолучитьОбласть("ОбластьШапка");
		Пока Выборка.Следующий() Цикл
			ОбластьМакетаШапка.Параметры.Организация = Выборка.Организация;
			ОбластьМакетаШапка.Параметры.Дата = Выборка.Дата;    
			// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 16.11.2023 - #УправлениеАктивами 
			Если Выборка.КонфигурационнаяЕдиница.Владелец.ПР_УказатьСоставОборудования Тогда
				ОбластьМакетаШапка.Параметры.Единица = Выборка.КонфигурационнаяЕдиница.Владелец;
			Иначе
				ОбластьМакетаШапка.Параметры.Единица = Выборка.КонфигурационнаяЕдиница;
			КонецЕсли;
			// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 16.11.2023 - #УправлениеАктивами
			ОбластьМакетаШапка.Параметры.Штрихкод = Выборка.АктивПР_СерийныйНомер; 
			ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
		КонецЦикла;
		
		Возврат ТабличныйДокумент;
		
	КонецФункции
	
	Функция СведенияОВнешнейОбработке() Экспорт
		
		// Объявим переменную, в которой мы сохраним и вернем "наружу" необходимые данные
		ПараметрыРегистрации = Новый Структура;
		
		
		// Объявим еще одну переменную, которая нам потребуется ниже
		МассивНазначений = Новый Массив;
		
		// Первый параметр, который мы должны указать - это какой вид обработки системе должна зарегистрировать.
		// Допустимые типы: ДополнительнаяОбработка, ДополнительныйОтчет, ЗаполнениеОбъекта, Отчет, ПечатнаяФорма, СозданиеСвязанныхОбъектов
		ПараметрыРегистрации.Вставить("Вид", "ПечатнаяФорма");
		
		//Теперь нам необходимо передать в виде массива имен, к чему будет подключена наша ВПФ
		//Имейте ввиду, что можно задать имя в таком виде: Документ.* - в этом случае обработка будет подключена ко всем документам в системе,
		//которые поддерживают механизм ВПФ
		//МассивНазначений.Добавить("Документ.АвансовыйОтчет");
		
		МассивНазначений.Добавить("Документ.itilprofПоступлениеАктивов");
		МассивНазначений.Добавить("Справочник.itilprofАктивы");
		МассивНазначений.Добавить("Документ.ПР_АктВыполненыхРабот");
		
		ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
		
		// Теперь зададим имя, под которым ВПФ будет зарегистрирована в справочнике внешних обработок
		ПараметрыРегистрации.Вставить("Наименование", "Печать этикеток 40х18");
		
		// Зададим право обработке на использование безопасного режима. Более подробно можно узнать в справке к платформе (метод УстановитьБезопасныйРежим)
		ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
		
		// Следующие два параметра играют больше информационную роль, т.е. это то, что будет видеть пользователь в информации к обработке
		ПараметрыРегистрации.Вставить("Версия", "2.0");
		ПараметрыРегистрации.Вставить("Информация", "Внешняя печатная форма печать этикеток 40х18");
		
		// Создадим таблицу команд (подробнее смотрим ниже)
		ТаблицаКоманд = ПолучитьТаблицуКоманд();
		
		// Добавим команду в таблицу
		//ДобавитьКоманду(ТаблицаКоманд, "АвансовыйОтчет", "АвансовыйОтчет", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
		
		ДобавитьКоманду(ТаблицаКоманд, "Печать этикеток 40х18", "ПечатьЭтикеток40х18", "ВызовКлиентскогоМетода", Истина, "ПечатьMXL");
		
		// Сохраним таблицу команд в параметры регистрации обработки
		ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
		
		// Теперь вернем системе наши параметры
		Возврат ПараметрыРегистрации;
		
	КонецФункции
	
	Функция ПолучитьТаблицуКоманд()
		
		// Создадим пустую таблицу команд и колонки в ней
		Команды = Новый ТаблицаЗначений;
		
		// Как будет выглядеть описание печатной формы для пользователя
		Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
		
		// Имя нашего макета, что бы могли отличить вызванную команду в обработке печати
		Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
		
		// Тут задается, как должна вызваться команда обработки
		// Возможные варианты:
		// - ОткрытиеФормы - в этом случае в колонке идентификатор должно быть указано имя формы, которое должна будет открыть система
		// - ВызовКлиентскогоМетода - вызвать клиентскую экспортную процедуру из модуля формы обработки
		// - ВызовСерверногоМетода - вызвать серверную экспортную процедуру из модуля объекта обработки
		Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
		
		// Следующий параметр указывает, необходимо ли показывать оповещение при начале и завершению работы обработки. Не имеет смысла при открытии формы
		Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
		
		// Для печатной формы должен содержать строку ПечатьMXL
		Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
		
		Возврат Команды;
		
	КонецФункции
	
	Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
		// Добавляем команду в таблицу команд по переданному описанию.
		// Параметры и их значения можно посмотреть в функции ПолучитьТаблицуКоманд
		НоваяКоманда = ТаблицаКоманд.Добавить();
		НоваяКоманда.Представление = Представление;
		НоваяКоманда.Идентификатор = Идентификатор;
		НоваяКоманда.Использование = Использование;
		НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
		НоваяКоманда.Модификатор = Модификатор;
		
	КонецПроцедуры
	
	#КонецОбласти
	
#КонецЕсли