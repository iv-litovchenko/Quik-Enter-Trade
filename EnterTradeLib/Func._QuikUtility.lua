-----------------------------------------------------
-- ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ
-----------------------------------------------------

-- функция запуска проигрывания файла
function _QuikUtilityRegAlert(name, val_comment, disabled_sound)
	if RegAlert[name] == val_comment then
		return 0;
	else
		RegAlert[name] = val_comment;
		-- message(""..name..":"..val_comment); -- ALERT[] = "..."; AddEvent
		
		if t_id2 == nil then
			t_id2 = AllocTable();
			AddColumn(t_id2, 0, "", true, QTABLE_STRING_TYPE, 10);
			AddColumn(t_id2, 1, "", true, QTABLE_STRING_TYPE, 15);
			AddColumn(t_id2, 2, "", true, QTABLE_STRING_TYPE, 50);

			t = CreateWindow(t_id2);-- Создает таблицу
			SetWindowCaption(t_id2, "Enter trade (события)"); -- Устанавливает заголовок	
			SetWindowPos(t_id2, 252, 0,325, 532); -- Задает положение и размеры окна таблицы
		end;
		
		InsertRow(t_id2, RegAlertCounter);
		SetCell(t_id2, RegAlertCounter, 0, tostring(os.date("%H:%M:%S", os.time())));
		SetCell(t_id2, RegAlertCounter, 1, tostring(name));
		SetCell(t_id2, RegAlertCounter, 2, tostring(val_comment));
		RegAlertCounter = RegAlertCounter + 1;
		
		-- Запускаем музыку!
		local path_music = "Sound-5";
		if disabled_sound ~= 1 then
			_QuikUtilitySoundFilePlay(path_music);
		end;
		
		return 1;
	end;
end;

-- функция добавления метки на график
function _QuikUtilityRegLabel(name, val_comment, file_icon_name)
	if RegLabel[name] == val_comment then
		return 0;
	else
		RegLabel[name] = val_comment;
		RegLabelCounter = RegLabelCounter + 1;
		
		function add_zero(number_str)
			if #number_str == 1 then
				return "0"..number_str;
			else
				return number_str;
			end
		end
		
		if file_icon_name == nil then
			file_icon_name = "Placeholder";
		end;

		-- Если сочлененное название
		local oneName = '';
		if name:find("/") then
			local nameSplit = _QuikUtilitySplit(name,"/");
			oneName = nameSplit[1];
		else
			oneName = name;
		end;
		
		-- Представляем дату в виде "ГГГГММДД"
		-- Представляем время в виде "ЧЧММСС"
		local date_pos = (tostring(os.date("%Y", os.time()))..add_zero(tostring(os.date("%m", os.time())))..add_zero(tostring(os.date("%d", os.time()))))
		local time_pos = (add_zero(tostring(os.date("%H", os.time())))..add_zero(tostring(os.date("%M", os.time())))..add_zero(tostring(os.date("%S", os.time()))))
		
		local price = _QuikGetChartByIndex(oneName).close;
			  price = price+((price/100)*0.2);
		
		-- TEXT = "----------------=ТЕСТ=----------------",
		label_params = {
			TEXT = tostring(""),
			DATE = tostring(date_pos), -- "20200526",
			TIME = tostring(time_pos), -- "212020",
			YVALUE = tonumber(price), -- tonumber(_QuikGetChartByIndex(oneName)),
			R = 200,
			G = 200,
			B = 200,
			HINT = tostring(val_comment),
			IMAGE_PATH = tostring(getScriptPath().."\\\\EnterTradeLib\\\\"..file_icon_name..".jpg")
		};
		label_id = AddLabel(oneName, label_params);
		
		return 1;
	end;
end;

-- функция запуска проигрывания файла
function _QuikUtilitySoundFilePlay(file_name)
	w32.mciSendString("CLOSE QUIK_MP3");
	w32.mciSendString("OPEN "..getScriptPath().."\\\\EnterTradeLib\\\\"..file_name..".mp3 TYPE MpegVideo ALIAS QUIK_MP3");
	w32.mciSendString("PLAY QUIK_MP3");
	return 1;
end;

-- функция проигрывания файла (остановка)
function _QuikUtilitySoundFileStop()
	w32.mciSendString("CLOSE QUIK_MP3");
	return 1;
end;

-- Функция округления (,00 два знака после запятой)
function _QuikUtilityStrRound2(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", tonumber(num)));
end;

-- Функция вывода числа в читаемом формате
-- credit http://richard.warburton.it
function _QuikUtilityStrNumberFormat(n,round2)
	-- Без округления если сумма меньше 1 рубля
	if tonumber(n) > 0 then
		n = _QuikUtilityStrRound2(n,round2);
	end;
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$');
	local res = left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right;
	return string.gsub(res,"([.]+)",",");
end;

-- Функция вывода цены в читаемом формате
-- credit http://richard.warburton.it
function _QuikUtilityStrPriceFormat(n,round2)
	-- Без округления если сумма меньше 1 рубля
	if tonumber(n) ~= 0 then
		n = _QuikUtilityStrRound2(n,round2);
	end;
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$');
	local res = left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right;
	return string.gsub(res,"([.]+)",",").." р.";
end;

-- Функция разделения строки на массивы по символы
function _QuikUtilitySplit(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end;

-- Функция отображает содержимое массива (аналог php print_r)
function _QuikUtilityPrintR(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(_QuikUtilityPrintR(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n".._QuikUtilityPrintR(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end;

-- Лог счетчик: Увеличить значение счетчика
function _QuikUtilityLogCounterGetUp(name)
	local file = io.open(getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".count."..name..".txt","a+"); -- os.date("%d-%m-%Y", os.time())
	file:write("|");
	file:flush();
	file:close();
end;

-- Лог счетчик: Получить значение счетчика
function _QuikUtilityLogCounterGet(name)
	local file = io.open(getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".count."..name..".txt","a+"); -- os.date("%d-%m-%Y", os.time())
	local content = file:read("*a");
	if(content ~= 0) then
		content = string.len(content);
	else 
		content = 0;
	end;
	file:close();
	return tonumber(content);
end;

-- Функция для записи в лог действий скрипта
-- Записывает в лог-файл переданную строку, добавляя в ее начало время с точностью до микросекунд
function _QuikUtilityLogWrite(name, log_type, log_array)
	-- https://www.tutorialspoint.com/lua/lua_file_io.htm
	
	local path_file_1 = getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC.."."..name;
	local path_file_2 = getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC.."."..name..".full";
	
	-- Краткий
	if log_type ~= "System" then
		local file = io.open(path_file_1..".csv","a+");
		local content = "";
		for key, value in pairs(log_array) do
			content = content..";"..value;
			content = string.gsub(content,"([.]+)",",");
		end;
		local ctr = 0; -- Кол-во строк в файле
		for _ in io.lines(path_file_1..".csv") do
			ctr = ctr + 1;
		end;
		file:write(
			(ctr+1)..";"..
			os.date("%d.%m.%Y", os.time())..";"..tostring(os.date("%H:%M:%S", os.time()))..";"..
			tostring(log_type)..
			tostring(content).."\n"
		);  -- Записывает в лог-файл
		file:flush();   -- Сохраняет изменения в лог-файле
		file:close();
	end;
	
	-- Полный
	local file = io.open(path_file_2..".csv","a+");
	local content = "";
	for key, value in pairs(log_array) do
		content = content..";"..value;
		content = string.gsub(content,"([.]+)",",");
	end;
	local ctr = 0; -- Кол-во строк в файле
	for _ in io.lines(path_file_2..".csv") do
		ctr = ctr + 1;
	end;
	file:write(
		(ctr+1)..";"..
		os.date("%d.%m.%Y", os.time())..";"..tostring(os.date("%H:%M:%S", os.time()))..";"..
		tostring(log_type)..
		tostring(content).."\n"
	);  -- Записывает в лог-файл
	file:flush();   -- Сохраняет изменения в лог-файле
	file:close();
	
	-- Копируем два файла
	-- os.copyfile(path_file_1..".csv", path_file_1..".copy.csv");
	-- os.copyfile(path_file_2..".csv", path_file_2..".copy.csv");

end;

-- Функция получения параметра настроек риск-менеджера
function _QuikUtilityRMSetting(class,number)
	local key = FILE_SETTINGS_LIST_RM_KEY[class];
	return FILE_SETTINGS_LIST_RM[key][number]; -- @ параметр из настроек 
end;

-- Функция рассчета средневзвешенного
-- Средневзвешенное значение = (x1*w1 + x2*w2 + x3*w3) / (w1+w2+w3)
-- x1,x2,x3 - это значение (например цена)
-- w1,w2,w3 - вес каждого
-- $a = [10,20,30];
-- $b = [5,6,7];
-- $ar = array_map(function($e1,$e2){ return $e1*e2; }, $a, $b);
-- $result = array_sum($ar)/array_sum($b);
-- }
function _QuikUtilityWeightedAverage(ar1,ar2)
	
	local ar1_map = {};
	for i=1, #ar1 do
		ar1_map[#ar1_map+1] = ar1[i] * ar2[i];
	end;
	
	local sumAr1 = 0;
	for i=1, #ar1_map do
		sumAr1 = sumAr1 + ar1_map[i];
	end;
	
	local sumAr2 = 0;
	for i=1, #ar2 do
		sumAr2 = sumAr2 + ar2[i];
	end;
	
	return tonumber(sumAr1/sumAr2);
end;