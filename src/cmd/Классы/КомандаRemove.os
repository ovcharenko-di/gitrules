#Использовать fs

///////////////////////////////////////////////////////////////////////////////
//
// Служебный модуль с реализацией работы команды
//
///////////////////////////////////////////////////////////////////////////////

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("PATH", "" ,"Путь к каталогу удаления git-hook разбора правил (По умолчанию текущий каталог)")
		.ТСтрока()
		.ПоУмолчанию(ТекущийКаталог())
		.Обязательный(Ложь); // тип опции Строка
		
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ПутьКОчистки = Команда.ЗначениеАргумента("PATH");

	КаталогПроекта = Новый Файл(ОбъединитьПути(ПутьКОчистки, ".git"));
	Если Не КаталогПроекта.Существует() Тогда
		ВызватьИсключение "Этот каталог не является репозиторием GIT";
	КонецЕсли;

	МассивИменФайлов = Новый Массив;
	МассивИменФайлов.Добавить("pre-commit");
	МассивИменФайлов.Добавить("v8-exchrules1s.os");

	КаталогHooks = ОбъединитьПути(КаталогПроекта.ПолноеИмя, "hooks");
	
	ЕстьОшибки = Ложь;
	Для Каждого ИмяФайла Из МассивИменФайлов Цикл
		Попытка
			УдалитьФайлы(ОбъединитьПути(КаталогHooks, ИмяФайла));
		Исключение
			ЕстьОшибки = Истина;
			Сообщить("При удалении файла " + ИмяФайла + " произошла ошибка. Причина: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		ВызватьИсключение "Операция прервана - ость ошибки";
	Иначе
		Сообщить("Gitrules успешно удален из репозитория");
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКоманду
