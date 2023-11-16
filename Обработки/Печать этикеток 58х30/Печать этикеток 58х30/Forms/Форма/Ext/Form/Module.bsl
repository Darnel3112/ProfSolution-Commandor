﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого Документ Из Параметры.ОбъектыНазначения Цикл
		
		ОбъектыНазвания.Добавить(Документ);

	КонецЦикла;	
	
	// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 31.08.2022 - #УправлениеАктивами
	Если ТипЗнч(ОбъектыНазвания[0].Значение) = Тип("СправочникСсылка.itilprofАктивы") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	itilprofПоступлениеАктивовАктивы.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.itilprofПоступлениеАктивов.Активы КАК itilprofПоступлениеАктивовАктивы
		|ГДЕ
		|	itilprofПоступлениеАктивовАктивы.Актив = &Актив
		|	И itilprofПоступлениеАктивовАктивы.Ссылка.Проведен");
		Запрос.УстановитьПараметр("Актив", ОбъектыНазвания[0].Значение);
		
		Результат = Запрос.Выполнить().Выгрузить();
		Если Результат.Количество() <> 0 Тогда
			Организация = Результат[0].Ссылка.ПР_Фирма;
		КонецЕсли;
		
	КонецЕсли;
	// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 31.08.2022 - #УправлениеАктивами 

КонецПроцедуры

&НаКлиенте
Процедура Печать(ИдентификатораКоманды,ОбъектыНазначения) Экспорт
	
	ПараметрыФормы = Новый Структура("ОбъектыНазначения", ОбъектыНазначения);
	ОткрытьФорму("ВнешняяОбработка.ВнешняяПечатнаяФормаПечатиЭтикеток58х30.Форма",ПараметрыФормы,ОбъектыНазначения[0],,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПечать(Команда)
	КоллекцияПечФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("МакетПечатиЭтикеток");
	СтруктураКоллекции = КоллекцияПечФорм.Получить(0);
	СтруктураКоллекции.ТабличныйДокумент = СформироватьПечатнуюФорму(ОбъектыНазвания); //ПечатьНаСервере(ОбъектыНазвания);
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечФорм,,ЭтаФорма);
	
	Закрыть();
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму(МассивОбъектов)
		
		УстановитьПривилегированныйРежим(Истина);
		
		Об = РеквизитФормыВЗначение("Объект");
		Макет = Об.ПолучитьМакет("ПР_МакетПечатиЭтикеток");
			
		ТабличныйДокумент = Новый ТабличныйДокумент;
		
		ТабличныйДокумент.АвтоМасштаб = Истина;
		
		ТабличныйДокумент.ПолеСверху = 0;
		ТабличныйДокумент.ПолеСлева = 0;
		ТабличныйДокумент.ПолеСнизу = 0;
		ТабличныйДокумент.ПолеСправа = 0;
		
		ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
		ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
		
		//ТабличныйДокумент.РазмерСтраницы = "Custom";//нестандартный размер   
		//ТабличныйДокумент.ВысотаСтраницы = 30;
		//ТабличныйДокумент.ШиринаСтраницы = 58;
		ТабличныйДокумент.МасштабПечати = 45;
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
				
		ОбластьМакетаШапка = Макет.ПолучитьОбласть("ОбластьШапка");
		
		Для Каждого Строка Из ТаблицаАктивов Цикл
			
			Если Строка.Выбран Тогда
				
				//ОбластьМакетаШапка.Параметры.Организация = Организация;	
				ОбластьМакетаШапка.Параметры.Дата = Формат(Строка.Дата, "ДФ=dd.MM.yyyy");
				// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 16.11.2023 - #УправлениеАктивами 
				Если Строка.Актив.ТипАктива.ПР_УказатьСоставОборудования Тогда
					ОбластьМакетаШапка.Параметры.Единица = Строка.Актив.ТипАктива;
				Иначе
					ОбластьМакетаШапка.Параметры.Единица = Строка.Актив;
				КонецЕсли;
				// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 16.11.2023 - #УправлениеАктивами				
				ОбластьМакетаШапка.Параметры.ИнвентарныйНомер = Строка.Актив.Код;
				ОбластьМакетаШапка.Параметры.Штрихкод = ПолучитьШтрихкод(550, 120, Строка.Штрихкод, 1);
				СтрокаШК = Строка(Строка.Штрихкод);
				ИзмененныйШтрихкод = "";
				Для НомерСимвола = 1 По СтрДлина(СтрокаШК) Цикл
					ИзмененныйШтрихкод = ИзмененныйШтрихкод + Сред(СтрокаШК, НомерСимвола, 1) + "  ";	
				КонецЦикла;
				
				ОбластьМакетаШапка.Параметры.НомерШК = Лев(ИзмененныйШтрихкод, СтрДлина(ИзмененныйШтрихкод) - 1);
				
				ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТабличныйДокумент.АвтоМасштаб = Ложь;
		
		Возврат ТабличныйДокумент;
		
КонецФункции
	
// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 12.08.2022 - #УправлениеАктивами
&НаСервере
Функция ПодключитьКомпонентуГенерацииИзображенияШтрихкода(ТипПлатформыКомпоненты)
	
#Если НЕ МобильноеПриложениеСервер Тогда  
	УстановитьОтключениеБезопасногоРежима(Истина);
#КонецЕсли
	ВнешняяКомпонента = Неопределено;
	
#Если НЕ МобильноеПриложениеСервер Тогда
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВнешниеКомпоненты") Тогда
			МодульВнешниеКомпонентыСервер = ОбщегоНазначения.ОбщийМодуль("ВнешниеКомпонентыСервер");
			РезультатПодключения = МодульВнешниеКомпонентыСервер.ПодключитьКомпоненту("Barcode");
			Если РезультатПодключения.Подключено Тогда
				ВнешняяКомпонента = РезультатПодключения.ПодключаемыйМодуль;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		ВнешняяКомпонента = ОбщегоНазначения.ПодключитьКомпонентуИзМакета("Barcode", "ОбщийМакет.КомпонентаПечатиШтрихкодов");
	КонецЕсли;
	
	Если ВнешняяКомпонента = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	// Установим основные параметры компоненты.
	// Если в системе установлен шрифт Tahoma.
	Если ВнешняяКомпонента.НайтиШрифт("Tahoma") Тогда
		// Выбираем его как шрифт для формирования картинки.
		ВнешняяКомпонента.Шрифт = "Tahoma";
	Иначе
		// Шрифт Tahoma в системе отсутствует.
		// Обойдем все доступные компоненте шрифты.
		Для Сч = 0 По ВнешняяКомпонента.КоличествоШрифтов -1 Цикл
			// Получим очередной шрифт, доступный компоненте.
			ТекущийШрифт = ВнешняяКомпонента.ШрифтПоИндексу(Сч);
			// Если шрифт доступен
			Если ТекущийШрифт <> Неопределено Тогда
				// Они и будет шрифтом для формирования штрихкода.
				ВнешняяКомпонента.Шрифт = ТекущийШрифт;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Установим размер шрифта
	ВнешняяКомпонента.РазмерШрифта = 12;
	
	Возврат ВнешняяКомпонента;
	
КонецФункции

&НаСервере
Функция ПолучитьШтрихкод(ШиринаШтрихкода, ВысотаШтрихкода, ЗначШтрихкод, ЗначТипШтрихкода)
	
	ПараметрыШтрихкода = ПараметрыГенерацииШтрихкода();
	ПараметрыШтрихкода.Ширина = ШиринаШтрихкода;
	ПараметрыШтрихкода.Высота = ВысотаШтрихкода;
	ПараметрыШтрихкода.ТипКода = ЗначТипШтрихкода;
	ПараметрыШтрихкода.Штрихкод = ЗначШтрихкод;
	ПараметрыШтрихкода.ПрозрачныйФон = Истина;
	//ПараметрыШтрихкода.УровеньКоррекцииQR = 2;
	//ПараметрыШтрихкода.ОтображатьТекст = Ложь;
	//ПараметрыШтрихкода.Масштабировать = Истина;
	//ПараметрыШтрихкода.СохранятьПропорции = Истина;
	//ПараметрыШтрихкода.ВертикальноеВыравнивание  = 0; 
	//ПараметрыШтрихкода.GS1DatabarКоличествоСтрок = 1;
	//ПараметрыШтрихкода.ТипВходныхДанных = 0;
	
	РезультатШтрихкод = ИзображениеШтрихкода(ПараметрыШтрихкода);

	Возврат РезультатШтрихкод.Картинка;
	
КонецФункции

&НаСервере
Функция ПараметрыГенерацииШтрихкода()
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина"            , 100);
	ПараметрыШтрихкода.Вставить("Высота"            , 100);
	ПараметрыШтрихкода.Вставить("ТипКода"           , 1);  // 1 - EAN13
	ПараметрыШтрихкода.Вставить("ОтображатьТекст"   , Ложь);
	ПараметрыШтрихкода.Вставить("РазмерШрифта"      , 25);
	ПараметрыШтрихкода.Вставить("УголПоворота"      , 0);
	ПараметрыШтрихкода.Вставить("Штрихкод"          , "");
	ПараметрыШтрихкода.Вставить("ПрозрачныйФон"     , Истина);
	//ПараметрыШтрихкода.Вставить("УровеньКоррекцииQR", 1);
	//ПараметрыШтрихкода.Вставить("Масштабировать"           , Ложь);
	//ПараметрыШтрихкода.Вставить("СохранятьПропорции"       , Ложь);
	//ПараметрыШтрихкода.Вставить("ВертикальноеВыравнивание" , 1); 
	//ПараметрыШтрихкода.Вставить("GS1DatabarКоличествоСтрок", 2);
	//ПараметрыШтрихкода.Вставить("ТипВходныхДанных", 0);
	//ПараметрыШтрихкода.Вставить("УбратьЛишнийФон" , Ложь); 
	//ПараметрыШтрихкода.Вставить("ЛоготипКартинка");
	//ПараметрыШтрихкода.Вставить("ЛоготипРазмерПроцентОтШК");
	
	Возврат ПараметрыШтрихкода;
	
КонецФункции

&НаСервере
Функция ИзображениеШтрихкода(ПараметрыШтрихкода) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ТипПлатформыКомпоненты = Строка(СистемнаяИнформация.ТипПлатформы);
	
	ВнешняяКомпонента = ПодключитьКомпонентуГенерацииИзображенияШтрихкода(ТипПлатформыКомпоненты);
	
	Если ВнешняяКомпонента = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Ошибка подключения внешней компоненты печати штрихкода.'");
		//ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка генерации штрихкода'", 
		//	ОбщегоНазначения.КодОсновногоЯзыка()),
		//	УровеньЖурналаРегистрации.Ошибка,,, 
		//	ТекстСообщения);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Возврат ПодготовитьИзображениеШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода); 
	 
КонецФункции

&НаСервере
Функция ПодготовитьИзображениеШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода)
	
	// Результат 
	РезультатОперации = Новый Структура();
	РезультатОперации.Вставить("Результат", Ложь);
	РезультатОперации.Вставить("ДвоичныеДанные");
	РезультатОперации.Вставить("Картинка");
	
	// Зададим размер формируемой картинки.
	ШиринаШтрихкода = Окр(ПараметрыШтрихкода.Ширина);
	ВысотаШтрихкода = Окр(ПараметрыШтрихкода.Высота);
	Если ШиринаШтрихкода <= 0 Тогда
		ШиринаШтрихкода = 1
	КонецЕсли;
	Если ВысотаШтрихкода <= 0 Тогда
		ВысотаШтрихкода = 1
	КонецЕсли;
	ВнешняяКомпонента.Ширина = ШиринаШтрихкода;
	ВнешняяКомпонента.Высота = ВысотаШтрихкода;
	ВнешняяКомпонента.АвтоТип = Ложь;
	
	ШтрихкодВрем = Строка(ПараметрыШтрихкода.Штрихкод); // Преобразуем явно в строку.
	
	Если ПараметрыШтрихкода.ТипКода = 99 Тогда
		ВнешняяКомпонента.АвтоТип = Истина;
	Иначе
		ВнешняяКомпонента.АвтоТип = Ложь;
		ВнешняяКомпонента.ТипКода = ПараметрыШтрихкода.ТипКода;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ПрозрачныйФон") Тогда
		ВнешняяКомпонента.ПрозрачныйФон = ПараметрыШтрихкода.ПрозрачныйФон;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("ТипВходныхДанных") Тогда
		ВнешняяКомпонента.ТипВходныхДанных = ПараметрыШтрихкода.ТипВходныхДанных;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("GS1DatabarКоличествоСтрок") Тогда
		ВнешняяКомпонента.GS1DatabarКоличествоСтрок = ПараметрыШтрихкода.GS1DatabarКоличествоСтрок;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("УбратьЛишнийФон") Тогда
		ВнешняяКомпонента.УбратьЛишнийФон = ПараметрыШтрихкода.УбратьЛишнийФон;
	КонецЕсли;
	
	ВнешняяКомпонента.ОтображатьТекст = ПараметрыШтрихкода.ОтображатьТекст;
	// Формируем картинку штрихкода.
	ВнешняяКомпонента.ЗначениеКода = ШтрихкодВрем;
	// Угол поворота штрихкода.
	ВнешняяКомпонента.УголПоворота = ?(ПараметрыШтрихкода.Свойство("УголПоворота"), ПараметрыШтрихкода.УголПоворота, 0);
	// Уровень коррекции QR кода (L=0, M=1, Q=2, H=3).
//	ВнешняяКомпонента.УровеньКоррекцииQR = ?(ПараметрыШтрихкода.Свойство("УровеньКоррекцииQR"), ПараметрыШтрихкода.УровеньКоррекцииQR, 1);
	
	// Для обеспечения совместимости с предыдущими версиями БПО.
	Если Не ПараметрыШтрихкода.Свойство("Масштабировать")
		Или (ПараметрыШтрихкода.Свойство("Масштабировать") И ПараметрыШтрихкода.Масштабировать) Тогда
		
		Если Не ПараметрыШтрихкода.Свойство("СохранятьПропорции")
				Или (ПараметрыШтрихкода.Свойство("СохранятьПропорции") И Не ПараметрыШтрихкода.СохранятьПропорции) Тогда
			// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
				ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
			КонецЕсли;
			// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
			Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
				ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
			КонецЕсли;
		ИначеЕсли ПараметрыШтрихкода.Свойство("СохранятьПропорции") И ПараметрыШтрихкода.СохранятьПропорции Тогда
			Пока ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода 
				Или ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Цикл
				// Если установленная нами ширина меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Ширина < ВнешняяКомпонента.МинимальнаяШиринаКода Тогда
					ВнешняяКомпонента.Ширина = ВнешняяКомпонента.МинимальнаяШиринаКода;
					ВнешняяКомпонента.Высота = (ВнешняяКомпонента.МинимальнаяШиринаКода / Окр(ПараметрыШтрихкода.Ширина)) * Окр(ПараметрыШтрихкода.Высота);
				КонецЕсли;
				// Если установленная нами высота меньше минимально допустимой для этого штрихкода.
				Если ВнешняяКомпонента.Высота < ВнешняяКомпонента.МинимальнаяВысотаКода Тогда
					ВнешняяКомпонента.Высота = ВнешняяКомпонента.МинимальнаяВысотаКода;
					ВнешняяКомпонента.Ширина = (ВнешняяКомпонента.МинимальнаяВысотаКода / Окр(ПараметрыШтрихкода.Высота)) * Окр(ПараметрыШтрихкода.Ширина);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	// ВертикальноеВыравниваниеКода: 1 - по верхнему краю, 2 - по центру, 3 - по нижнему краю.
	Если ПараметрыШтрихкода.Свойство("ВертикальноеВыравнивание") И (ПараметрыШтрихкода.ВертикальноеВыравнивание > 0) Тогда
		ВнешняяКомпонента.ВертикальноеВыравниваниеКода = ПараметрыШтрихкода.ВертикальноеВыравнивание;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("РазмерШрифта") И (ПараметрыШтрихкода.РазмерШрифта > 0) 
		И (ПараметрыШтрихкода.ОтображатьТекст) И (ВнешняяКомпонента.РазмерШрифта <> ПараметрыШтрихкода.РазмерШрифта) Тогда
			ВнешняяКомпонента.РазмерШрифта = ПараметрыШтрихкода.РазмерШрифта;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.Свойство("РазмерШрифта") И ПараметрыШтрихкода.РазмерШрифта > 0
		И ПараметрыШтрихкода.Свойство("МонохромныйШрифт") Тогда
		Если ПараметрыШтрихкода.МонохромныйШрифт Тогда
			ВнешняяКомпонента.МаксимальныйРазмерШрифтаДляПринтеровНизкогоРазрешения = ПараметрыШтрихкода.РазмерШрифта + 1;
		Иначе
			ВнешняяКомпонента.МаксимальныйРазмерШрифтаДляПринтеровНизкогоРазрешения = -1;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыШтрихкода.ТипКода = 16 Тогда // QR
		Если ПараметрыШтрихкода.Свойство("ЛоготипКартинка") И Не ПустаяСтрока(ПараметрыШтрихкода.ЛоготипКартинка) Тогда 
			ВнешняяКомпонента.ЛоготипКартинка = ПараметрыШтрихкода.ЛоготипКартинка;
		КонецЕсли;
		Если ПараметрыШтрихкода.Свойство("ЛоготипРазмерПроцентОтШК") И Не ПустаяСтрока(ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК) Тогда 
			ВнешняяКомпонента.ЛоготипРазмерПроцентОтШК = ПараметрыШтрихкода.ЛоготипРазмерПроцентОтШК;
		КонецЕсли;
	КонецЕсли;
		
	// Сформируем картинку
	ДвоичныеДанныеКартинки = ВнешняяКомпонента.ПолучитьШтрихкод();
	РезультатОперации.Результат = 0 ;//ВнешняяКомпонента.Результат = 0;
	// Если картинка сформировалась.
	Если ДвоичныеДанныеКартинки <> Неопределено Тогда
		РезультатОперации.ДвоичныеДанные = ДвоичныеДанныеКартинки;
		РезультатОперации.Картинка = Новый Картинка(ДвоичныеДанныеКартинки); // Формируем из двоичных данных.
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для Каждого Строка Из ТаблицаАктивов Цикл
		Строка.Выбран = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для Каждого Строка Из ТаблицаАктивов Цикл
		Строка.Выбран = Истина;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	
	// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 15.08.2022 - #УправлениеАктивами
	Если ТипЗнч(ОбъектыНазвания[0].Значение) = Тип("ДокументСсылка.itilprofПоступлениеАктивов") Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ПР_ШтрихкодыАктивов.Актив КАК Актив,
		|	ПР_ШтрихкодыАктивов.Штрихкод КАК Штрихкод,
		|	ПоступлениеАктивы.Актив.Код КАК ИнвентарныйНомер,
		|	ВЫБОР
		|		КОГДА ПоступлениеАктивы.Актив <> ЗНАЧЕНИЕ(Справочник.itilprofАктивы.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК Выбран
		|ИЗ
		|	(ВЫБРАТЬ
		|		ПоступлениеАктивы.Актив КАК Актив
		|	ИЗ
		|		Документ.itilprofПоступлениеАктивов.Активы КАК ПоступлениеАктивы
		|	ГДЕ
		|		ПоступлениеАктивы.Ссылка В(&Ссылка)
		|		И ПоступлениеАктивы.Актив <> ЗНАЧЕНИЕ(Справочник.itilprofАктивы.ПустаяСсылка)) КАК ПоступлениеАктивы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПР_ШтрихкодыАктивов КАК ПР_ШтрихкодыАктивов
		|		ПО ПоступлениеАктивы.Актив = ПР_ШтрихкодыАктивов.Актив");  
		
		Запрос.УстановитьПараметр("Ссылка", ОбъектыНазвания);
		
		ТЗ = Запрос.Выполнить().Выгрузить();		
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Организация = ОбъектыНазвания[0].Значение.ПР_Фирма;
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ТаблицаАктивов.Добавить();
			НоваяСтрока.Дата = ТекущаяДата(); 
			//Пелых КД
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
			//Пелых КД
		КонецЦикла; 
		
		
	ИначеЕсли ТипЗнч(ОбъектыНазвания[0].Значение) = Тип("СправочникСсылка.itilprofАктивы") Тогда 
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПР_ШтрихкодыАктивов.Штрихкод КАК Штрихкод,
		|	itilprofАктивы.Ссылка КАК Актив,
		|	itilprofАктивы.Код КАК ИнвентарныйНомер, 
		|	ВЫБОР
		|		КОГДА itilprofАктивы.Ссылка <> ЗНАЧЕНИЕ(Справочник.itilprofАктивы.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК Выбран
		|ИЗ
		|	Справочник.itilprofАктивы КАК itilprofАктивы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПР_ШтрихкодыАктивов КАК ПР_ШтрихкодыАктивов
		|		ПО itilprofАктивы.Ссылка = ПР_ШтрихкодыАктивов.Актив
		|ГДЕ
		|	itilprofАктивы.Ссылка В(&Ссылка)");
		Запрос.УстановитьПараметр("Ссылка", ОбъектыНазвания);
		
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		Если Не ЗначениеЗаполнено(ТЗ[0].Штрихкод) Тогда
			РегистрыСведений.ПР_ШтрихкодыАктивов.СформироватьШтрихКодКакСтроку(ТЗ);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ТаблицаАктивов.Добавить(); 
			НоваяСтрока.Дата = ТекущаяДата();  
			//Пелых КД
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
			//Пелых КД
			
		КонецЦикла;   
		// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 24.10.2023 - #УправлениеАктивами
	ИначеЕсли ТипЗнч(ОбъектыНазвания[0].Значение) = Тип("ДокументСсылка.ПР_АктВыполненыхРабот") Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПР_АктВыполненыхРаботАктивы.Актив КАК Актив,
		|	ПР_АктВыполненыхРаботАктивы.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ВЫБОР
		|		КОГДА ПР_АктВыполненыхРаботАктивы.Актив <> ЗНАЧЕНИЕ(Справочник.itilprofАктивы.ПустаяСсылка)
		|			ТОГДА ИСТИНА
		|	КОНЕЦ КАК Выбран,
		|	ПР_ШтрихкодыАктивов.Штрихкод КАК Штрихкод
		|ИЗ
		|	Документ.ПР_АктВыполненыхРабот.Активы КАК ПР_АктВыполненыхРаботАктивы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПР_ШтрихкодыАктивов КАК ПР_ШтрихкодыАктивов
		|		ПО ПР_АктВыполненыхРаботАктивы.Актив = ПР_ШтрихкодыАктивов.Актив
		|ГДЕ
		|	ПР_АктВыполненыхРаботАктивы.Ссылка В(&Ссылка)");
		Запрос.УстановитьПараметр("Ссылка", ОбъектыНазвания);
		
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		Если Не ЗначениеЗаполнено(ТЗ[0].Штрихкод) Тогда
			РегистрыСведений.ПР_ШтрихкодыАктивов.СформироватьШтрихКодКакСтроку(ТЗ);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = ТаблицаАктивов.Добавить(); 
			НоваяСтрока.Дата = ТекущаяДата();  
			//Пелых КД
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
			//Пелых КД
			
		КонецЦикла;
		// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 24.10.2023 - #УправлениеАктивами			
	КонецЕсли;
	// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 15.08.2022 - #УправлениеАктивами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры
// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 12.08.2022 - #УправлениеАктивами 