﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда	
#Область ПрограммныйИнтерфейс	
Процедура Печать(МассивОбъектов,  КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если НЕ ПродолжатьПечать(МассивОбъектов) Тогда
		Сообщение = "Нельзя производить печать накладной на перемещение из состояния ""Новый""";	// {{ ПРОФРЕШЕНИЕ, Барковская А.П. - 16.03.2023 - #ПЕР.ПЭП-01 }} 
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	КоллекцияПечатныхФорм[0].Экземпляров = 2;
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
	"НАКЛАДНАЯНАПЕРЕДАЧУОСНОВНЫХСРЕДСТВВЭКСПЛУАТАЦИЮ",
	НСтр("ru = 'Накладная на передачу основных средств в эксплуатацию'"),
	СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати),,
	"ПР_МакетНакладнаяНаПередачуОсновныхСредствВЭксплуатацию");
	
КонецПроцедуры
#КонецОбласти
	
Функция СформироватьПечатнуюФорму(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Макет = ПолучитьМакет("ПР_МакетНакладнаяНаПередачуОсновныхСредствВЭксплуатацию");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	// Зададим параметры макета по-умолчанию
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПР_МакетНакладнаяНаПередачуОсновныхСредствВЭксплуатацию";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	itilprofПеремещениеАктивовАктивы.Актив КАК Актив,
	|	itilprofПеремещениеАктивовАктивы.АналитикаДо1.ПР_Фирма КАК ФирмаДо,
	|	itilprofПеремещениеАктивовАктивы.АналитикаПосле1.ПР_Фирма КАК ФирмаПосле,
	|	itilprofПеремещениеАктивовАктивы.АналитикаДо1 КАК РабочееМестоДо,
	|	itilprofПеремещениеАктивовАктивы.АналитикаПосле1 КАК РабочееМестоПосле,
	|	itilprofПеремещениеАктивовАктивы.АналитикаПосле2 КАК МОЛПосле,
	|	itilprofПеремещениеАктивовАктивы.Количество КАК Количество,
	|	itilprofПеремещениеАктивовАктивы.Ссылка.Номер КАК Номер,
	|	itilprofПеремещениеАктивовАктивы.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА ЗапросУчета.ТипУчета = &ОССерийный
	|				ИЛИ ЗапросУчета.ТипУчета = &РМСерийный
	|			ТОГДА itilprofПеремещениеАктивовАктивы.Актив.ПР_СерийныйНомер
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК СерийныйНомер,
	|	ВЫБОР
	|		КОГДА ЗапросУчета.ЭтоАктив
	|				И ЗапросУчета.ТипУчета <> &РМСерийный
	|			ТОГДА itilprofПеремещениеАктивовАктивы.Актив.Код
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ИнвентарныйНомер,
	|	itilprofПеремещениеАктивовАктивы.Ссылка.Дата КАК Дата,
	|	itilprofПеремещениеАктивовАктивы.Ссылка КАК Ссылка
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗапросАктивы.НомерСтроки КАК НомерСтроки,
	|		ЗапросАктивы.Актив КАК Актив,
	|		ЗапросАктивы.ЭтоАктив КАК ЭтоАктив,
	|		ВЫБОР
	|			КОГДА ЗапросАктивы.ЭтоАктив
	|				ТОГДА itilprofАктивы.ТипАктива.ПР_Учет
	|			ИНАЧЕ itilprofКонфигурационныеЕдиницы.Владелец.ПР_Учет
	|		КОНЕЦ КАК ТипУчета,
	|		ЗапросАктивы.Ссылка КАК Ссылка
	|	ИЗ
	|		(ВЫБРАТЬ
	|			itilprofПеремещениеАктивовАктивы.НомерСтроки КАК НомерСтроки,
	|			itilprofПеремещениеАктивовАктивы.Актив КАК Актив,
	|			ВЫБОР
	|				КОГДА itilprofПеремещениеАктивовАктивы.Актив ССЫЛКА Справочник.itilprofАктивы
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ КАК ЭтоАктив,
	|			itilprofПеремещениеАктивовАктивы.Ссылка КАК Ссылка
	|		ИЗ
	|			Документ.itilprofПеремещениеАктивов.Активы КАК itilprofПеремещениеАктивовАктивы
	|		ГДЕ
	|			itilprofПеремещениеАктивовАктивы.Ссылка = &Ссылка) КАК ЗапросАктивы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.itilprofАктивы КАК itilprofАктивы
	|			ПО (ВЫБОР
	|					КОГДА ЗапросАктивы.ЭтоАктив
	|						ТОГДА ЗапросАктивы.Актив = itilprofАктивы.Ссылка
	|				КОНЕЦ)
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.itilprofКонфигурационныеЕдиницы КАК itilprofКонфигурационныеЕдиницы
	|			ПО (ВЫБОР
	|					КОГДА НЕ ЗапросАктивы.ЭтоАктив
	|						ТОГДА ЗапросАктивы.Актив = itilprofКонфигурационныеЕдиницы.Ссылка
	|				КОНЕЦ)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗапросАктивы.Актив,
	|		ЗапросАктивы.ЭтоАктив,
	|		ЗапросАктивы.Ссылка,
	|		ВЫБОР
	|			КОГДА ЗапросАктивы.ЭтоАктив
	|				ТОГДА itilprofАктивы.ТипАктива.ПР_Учет
	|			ИНАЧЕ itilprofКонфигурационныеЕдиницы.Владелец.ПР_Учет
	|		КОНЕЦ,
	|		ЗапросАктивы.НомерСтроки) КАК ЗапросУчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.itilprofПеремещениеАктивов.Активы КАК itilprofПеремещениеАктивовАктивы
	|		ПО ЗапросУчета.Ссылка = itilprofПеремещениеАктивовАктивы.Ссылка
	|			И ЗапросУчета.НомерСтроки = itilprofПеремещениеАктивовАктивы.НомерСтроки
	|			И ЗапросУчета.Актив = itilprofПеремещениеАктивовАктивы.Актив
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Актив),
	|	СУММА(Количество),
	|	МАКСИМУМ(Номер),
	|	СУММА(НомерСтроки),
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СерийныйНомер),
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ИнвентарныйНомер),
	|	МАКСИМУМ(Дата),
	|	МАКСИМУМ(Ссылка)
	|ПО
	|	ФирмаДо,
	|	ФирмаПосле,
	|	РабочееМестоДо,
	|	РабочееМестоПосле,
	|	МОЛПосле");
	
	Запрос.УстановитьПараметр("ОССерийный", ПредопределенноеЗначение("Перечисление.ПР_ТипыУчетаКонфигурационныхЕдиниц.ОсновноеСредствоССерийнымНомером"));
	Запрос.УстановитьПараметр("РМСерийный", ПредопределенноеЗначение("Перечисление.ПР_ТипыУчетаКонфигурационныхЕдиниц.РасходныйМатериалССерийнымНомером"));
	
	// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 29.09.2022 - #УправлениеАктивами
	ЗапросСтоимости = Новый Запрос(
	"ВЫБРАТЬ
	|	itilprofАктивы.Сумма КАК Сумма,
	|	itilprofАктивы.Количество КАК Количество,
	|	itilprofАктивы.Актив КАК Актив
	|ИЗ
	|	РегистрНакопления.itilprofАктивы КАК itilprofАктивы
	|ГДЕ
	|	itilprofАктивы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	И itilprofАктивы.Актив = &Актив
	|	И itilprofАктивы.Регистратор = &Регистратор");
		// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 29.09.2022 - #УправлениеАктивами  
	
	Для Каждого ОбъектСсылка Из МассивОбъектов Цикл
		
		Запрос.УстановитьПараметр("Ссылка", ОбъектСсылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ГруппировкаФирмаДо = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФирмаДо");
		
		Пока ГруппировкаФирмаДо.Следующий() Цикл
			
			ГруппировкаФирмаПосле = ГруппировкаФирмаДо.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ФирмаПосле");
			
			Пока ГруппировкаФирмаПосле.Следующий() Цикл
				
				ГруппировкаРабочееМестоДо = ГруппировкаФирмаПосле.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "РабочееМестоДо");
				
				Пока ГруппировкаРабочееМестоДо.Следующий() Цикл
					
					ГруппировкаРабочееМестоПосле = ГруппировкаРабочееМестоДо.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "РабочееМестоПосле");
					
					Пока ГруппировкаРабочееМестоПосле.Следующий() Цикл
						
						ГруппировкаМОЛПосле = ГруппировкаРабочееМестоПосле.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "МОЛПосле");
						
						Пока ГруппировкаМОЛПосле.Следующий() Цикл
							
							// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 28.09.2022 - #УправлениеАктивами
							НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
							
							ОбластьМакетаШапка = Макет.ПолучитьОбласть("ОбластьШапка");
							
							ОбластьМакетаШапка.Параметры.ФирмаДо = ГруппировкаМОЛПосле.ФирмаДо;
							ОбластьМакетаШапка.Параметры.Склад = ГруппировкаМОЛПосле.РабочееМестоДо.Склад;
							ОбластьМакетаШапка.Параметры.АдресМестоположениеСдатчик = ГруппировкаМОЛПосле.РабочееМестоДо.ПР_Подразделение.ПР_Адрес;	
							
							ОбластьМакетаШапка.Параметры.ФирмаПосле = ГруппировкаМОЛПосле.ФирмаПосле;
							ОбластьМакетаШапка.Параметры.СтруктурноеПодразделение = ГруппировкаМОЛПосле.РабочееМестоПосле.ПР_Подразделение;
							ОбластьМакетаШапка.Параметры.АдресМестоположениеПолучатель = ГруппировкаМОЛПосле.РабочееМестоПосле.ПР_Подразделение.ПР_Адрес;
							
							ОбластьМакетаШапка.Параметры.НомерДокумента = ГруппировкаМОЛПосле.Номер;
							ОбластьМакетаШапка.Параметры.ДатаДокумента = Формат(ГруппировкаМОЛПосле.Дата,"ДЛФ=D");
							
							ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
							
							ИтоговаяСотимость = 0;
							
							ВыборкаВТаблицу = ГруппировкаМОЛПосле.Выбрать();
							
							Пока ВыборкаВТаблицу.Следующий() Цикл
								
								// {{ ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 29.09.2022 - #УправлениеАктивами
								ЗапросСтоимости.УстановитьПараметр("Актив", ВыборкаВТаблицу.Актив);
								ЗапросСтоимости.УстановитьПараметр("Регистратор", ВыборкаВТаблицу.Ссылка);
								
								ПолучениеСтоимости = ЗапросСтоимости.Выполнить().Выбрать();
								ПолучениеСтоимости.Следующий();
								Стоимость = ПолучениеСтоимости.Сумма / ПолучениеСтоимости.Количество;
								// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 29.09.2022 - #УправлениеАктивами 
								
								ОбластьМакетаТаблица = Макет.ПолучитьОбласть("ОбластьТаблица");
								
								ОбластьМакетаТаблица.Параметры.Номер = ВыборкаВТаблицу.НомерСтроки;
								ОбластьМакетаТаблица.Параметры.Наименование = ВыборкаВТаблицу.Актив;
								ОбластьМакетаТаблица.Параметры.СерийныйНомер = ВыборкаВТаблицу.СерийныйНомер;
								ОбластьМакетаТаблица.Параметры.ИнвентарныйНомер = ВыборкаВТаблицу.ИнвентарныйНомер;
								ОбластьМакетаТаблица.Параметры.Количество = ВыборкаВТаблицу.Количество;
								ОбластьМакетаТаблица.Параметры.Стоимость = Формат(Стоимость, "ЧДЦ=2");
								
								ИтоговаяСотимость = ИтоговаяСотимость + Стоимость;
								
								ТабличныйДокумент.Вывести(ОбластьМакетаТаблица);
								
							КонецЦикла;
							
							ОбластьМакетаПодвал = Макет.ПолучитьОбласть("ОбластьПодвал");
							ОбластьМакетаКонтактныйТелефон = Макет.ПолучитьОбласть("ОбластьКонтактныйТелефон");							
							ОбластьМакетаПодвал.Параметры.ИтогоСтоимость = Формат(ИтоговаяСотимость, "ЧДЦ=2"); 

							СдалОборудование = ОбъектСсылка.ПР_СдалОборудованиеВЭксплуатацию;
							Пользователь = ПР_ОбщегоНазначенияСервер.ПолучитьПользователяПоФизЛицу(СдалОборудование);  
							Если ЗначениеЗаполнено(Пользователь) Тогда
								ОбластьМакетаПодвал.Параметры.ДолжностьСдал = Пользователь.Должность; 
							КонецЕсли;
							ОбластьМакетаПодвал.Параметры.Сдал = СдалОборудование; 								
							ОбластьМакетаКонтактныйТелефон.Параметры.ТелефонОтправителя = НомерТелефонаФизическогоЛица(СдалОборудование);
							
							ПринялОборудование = ГруппировкаМОЛПосле.МОЛПосле; 
							Пользователь = ПР_ОбщегоНазначенияСервер.ПолучитьПользователяПоФизЛицу(ПринялОборудование);
							Если ЗначениеЗаполнено(Пользователь) Тогда  
								ОбластьМакетаПодвал.Параметры.ДолжностьПринял = Пользователь.Должность;
							КонецЕсли;
							ОбластьМакетаПодвал.Параметры.Принял = ПринялОборудование;						
							ОбластьМакетаКонтактныйТелефон.Параметры.ТелефонПолучателя = НомерТелефонаФизическогоЛица(ПринялОборудование);			
				
							ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);  
							ТабличныйДокумент.Вывести(ОбластьМакетаКонтактныйТелефон);
							ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
							УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбъектСсылка);
							// }} ПРОФРЕШЕНИЕ, Мальцев Е.Д. - 28.09.2022 - #УправлениеАктивами  	                          																		
							
						КонецЦикла;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла; 		
		
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
		
		МассивНазначений.Добавить("Документ.itilprofПеремещениеАктивов");
		ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
		
		// Теперь зададим имя, под которым ВПФ будет зарегистрирована в справочнике внешних обработок
		ПараметрыРегистрации.Вставить("Наименование", "Накладная на передачу ТМЦ");
		
		// Зададим право обработке на использование безопасного режима. Более подробно можно узнать в справке к платформе (метод УстановитьБезопасныйРежим)
		ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
		
		// Следующие два параметра играют больше информационную роль, т.е. это то, что будет видеть пользователь в информации к обработке
		ПараметрыРегистрации.Вставить("Версия", "2.0");
		ПараметрыРегистрации.Вставить("Информация", "Накладная на передачу ТМЦ");
		
		// Создадим таблицу команд (подробнее смотрим ниже)
		ТаблицаКоманд = ПолучитьТаблицуКоманд();
		
		// Добавим команду в таблицу
		//ДобавитьКоманду(ТаблицаКоманд, "АвансовыйОтчет", "АвансовыйОтчет", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
		
		ДобавитьКоманду(ТаблицаКоманд, "Накладная на передачу ТМЦ", "НАКЛАДНАЯНАПЕРЕДАЧУОСНОВНЫХСРЕДСТВВЭКСПЛУАТАЦИЮ", "ВызовСерверногоМетода", Истина, "ПечатьMXL");
		
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

Функция ПродолжатьПечать(МассивОбъектов)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	itilprofПеремещениеАктивов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.itilprofПеремещениеАктивов КАК itilprofПеремещениеАктивов
	|ГДЕ
	|	itilprofПеремещениеАктивов.Ссылка В (&Ссылка)
	|			И itilprofПеремещениеАктивов.ПР_Состояние = ЗНАЧЕНИЕ(Перечисление.ПР_СостоянияПеремещения.ПР_Новый)";	// {{ ПРОФРЕШЕНИЕ, Барковская А.П. - 16.03.2023 - #ПЕР.ПЭП-01 }} 
	Запрос.УстановитьПараметр("Ссылка", МассивОбъектов);
	Результат = Запрос.Выполнить();
	ПродолжатьПечать = Результат.Пустой();
	Возврат ПродолжатьПечать;
КонецФункции

// Найдем номер телефона в контактной информации и преобразуем его к виду //+7 900-652-75-39, если сможем.
Функция НомерТелефонаФизическогоЛица(ФизЛицо)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ФизическиеЛицаКонтактнаяИнформация.НомерТелефона КАК НомерТелефона
	|ИЗ
	|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
	|ГДЕ
	|	ФизическиеЛицаКонтактнаяИнформация.Ссылка = &ФизическоеЛицо
	|	И ФизическиеЛицаКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|	И ФизическиеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.МобильныйТелефонФизическогоЛица)";
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		Телефон = Выборка.НомерТелефона;
		ДлинаНомера = СтрДлина(Телефон); 
		Если ДлинаНомера = 10 Тогда //9006527539
			Телефон = "+7 " + ЛЕВ(Телефон,3) + "-" 
			+ СРЕД(Телефон,4,3) + "-" + СРЕД(Телефон,7,2) + "-" + ПРАВ(Телефон,2);
		ИначеЕсли ДлинаНомера = 11 Тогда //79006527539 или 89006527539
			НачалоНомера = ЛЕВ(Телефон, 1);
			Если НачалоНомера = "7" Тогда
				Телефон = "+" + НачалоНомера + " " + СРЕД(Телефон, 2, 3) + "-" 
				+ СРЕД(Телефон, 5, 3) + "-" + СРЕД(Телефон, 8, 2) + "-" + ПРАВ(Телефон, 2);
			ИначеЕсли НачалоНомера = "8" Тогда
				Телефон = "+7 " + СРЕД(Телефон, 2, 3) + "-" 
				+ СРЕД(Телефон, 5, 3) + "-" + СРЕД(Телефон, 8, 2) + "-" + ПРАВ(Телефон, 2);	
			КонецЕсли;
		ИначеЕсли ДлинаНомера = 12 Тогда
			НачалоНомера = ЛЕВ(Телефон, 2);
			Если НачалоНомера = "+7" Тогда
				Телефон = НачалоНомера + " " + СРЕД(Телефон, 3, 3) + "-" 
				+ СРЕД(Телефон, 6, 3) + "-" + СРЕД(Телефон, 9, 2) + "-" + ПРАВ(Телефон, 2);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Телефон;
КонецФункции		
#КонецЕсли