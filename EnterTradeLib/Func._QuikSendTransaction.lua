-----------------------------------------------------
-- ФУНКЦИИ РЕГИСТРАЦИИ ТРАНЗАКЦИЙ
-----------------------------------------------------

-- Функция открытия длинной позиции
function _QuikSendTransactionOpenLongByIndex(code, q, stop, stop_k_take, pattern)
	-- Не торгуется!
	-- Сессия закрыта!
	if tonumber(_QuikGetParamExByIndex(code, "STATUS")) == 0 or 
		 tonumber(_QuikGetParamExByIndex(code, "TRADINGSTATUS")) == 0 then
		return 0;
	end;
	
	if FLAG_DISABLE_BUTTON == 1 then
		return 0;
	end;
	if _QuikGetTotalnetByIndex(code)<0 then
		message("Ранее уже была произведена операция продажи (шорт)!", 3);
		return 0;
	elseif q <= 0 then
		message("Количество в заявке должно быть положительно!", 3);
		return 0;
	else
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonBuy", price, "+"..q});
		
		local id = NEW_ORDER(code, "B", price, q, "LO", "200".._QuikUtilityLogCounterGet("order")+1, stop, stop_k_take, pattern);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
			return 0;
		end;
	end;
end;

-- Функция переворота
function _QuikSendTransactionOverturnByIndex(code, stop, stop_k_take)
	-- todo
	message("TODO");
end;

-- Функция открытия короткой позиции
function _QuikSendTransactionOpenShortByIndex(code, q, stop, stop_k_take, pattern)
	-- Не торгуется!
	-- Сессия закрыта!
	if tonumber(_QuikGetParamExByIndex(code, "STATUS")) == 0 or 
		 tonumber(_QuikGetParamExByIndex(code, "TRADINGSTATUS")) == 0 then
		return 0;
	end;
	
	if FLAG_DISABLE_BUTTON == 1 then
		return 0;
	end;
	if _QuikGetTotalnetByIndex(code)>0 then
		message("Ранее уже была произведена операция купли (лонг)!", 3);
		return 0;
	elseif q <= 0 then
		message("Количество в заявке должно быть положительно!", 3);
		return 0;
	else
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonSell", price, "-"..q});
		
		local id = NEW_ORDER(code, "S", price, q, "SO", "300".._QuikUtilityLogCounterGet("order")+1, stop, stop_k_take, pattern);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
			return 0;
		end;
	end;
end;

-- Функция закрытия части позиций (в %)
function _QuikSendTransactionClosePartByIndex(code, qPart)
	-- Не торгуется!
	-- Сессия закрыта!
	if tonumber(_QuikGetParamExByIndex(code, "STATUS")) == 0 or 
		 tonumber(_QuikGetParamExByIndex(code, "TRADINGSTATUS")) == 0 then
		return 0;
	end;
	
	if FLAG_DISABLE_BUTTON == 1 then
		return 0;
	end;
	-- ToLog("ClickButtonClosePart (Long)", {Q="-".._QuikGetTotalnetByIndex(code),Price=price});
	-- ToLog("ClickButtonClosePart (Short)", {Q="-"..math.abs(_QuikGetTotalnetByIndex(code)),Price=price});
	local tQ = math.abs(_QuikGetTotalnetByIndex(code));
	local resQ = math.ceil((tQ/100)*qPart);
	
	if _QuikGetTotalnetByIndex(code) > 0 then
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonClosePart ("..qPart.."%)", price, "-"..resQ});
		
		local id = NEW_ORDER(code, "S", price, resQ, "LC/Part-"..qPart.."%", "201".._QuikUtilityLogCounterGet("order")+1);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
			return 0;
		end;
	elseif _QuikGetTotalnetByIndex(code) < 0 then
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonClosePart ("..qPart.."%)", price, "+"..resQ});
		
		local id = NEW_ORDER(code, "B", price, resQ, "SC/Part-"..qPart.."%", "301".._QuikUtilityLogCounterGet("order")+1);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
			return 0;
		end;
	else
		message("Нет открытых позиций для закрытия!", 3);
		return 0;
	end;
end;

-- Функция закрытия всех позиций
function _QuikSendTransactionCloseAllByIndex(code)
	-- Не торгуется!
	-- Сессия закрыта!
	if tonumber(_QuikGetParamExByIndex(code, "STATUS")) == 0 or 
		 tonumber(_QuikGetParamExByIndex(code, "TRADINGSTATUS")) == 0 then
		return 0;
	end;
	
	if FLAG_DISABLE_BUTTON == 1 then
		return 0;
	end;
	-- ToLog("ClickButtonCloseAll (Long)", {Q="-".._QuikGetTotalnetByIndex(code),Price=price});
	-- ToLog("ClickButtonCloseAll (Short)", {Q="-"..math.abs(_QuikGetTotalnetByIndex(code)),Price=price});
	if _QuikGetTotalnetByIndex(code) > 0 then
		local price = _QuikGetParamExByIndex(code,'LAST');
		local totalnet = _QuikGetTotalnetByIndex(code);
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonCloseAll", price, "-"..totalnet});
		
		local id = NEW_ORDER(code, "S", price, totalnet, "LC/All", "202".._QuikUtilityLogCounterGet("order")+1);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
			return 0;
		end;
	elseif _QuikGetTotalnetByIndex(code) < 0 then
		local price = _QuikGetParamExByIndex(code,'LAST');
		local totalnet = _QuikGetTotalnetByIndex(code);
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonCloseAll", price, "+"..totalnet});
		
		local id = NEW_ORDER(code, "B", price, math.abs(totalnet), "SC/All", "302".._QuikUtilityLogCounterGet("order")+1);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
			return 0;
		end;
	else
		message("Нет открытых позиций для закрытия!", 3);
		return 0;
	end;
end;

-- Функция генерирует уникальный ID
function ID_GENERATION()
	--%u микросекунды
	-- .. ..string.sub(os.clock(),"[.]",""
	-- message(tostring(res));
	-- message(">>>"..string.sub(tostring(os.clock()),"[.]",""));
	-- return tonumber(os.date("%d%H%M%S", os.time()));
	return os.time();
end;

-- Регистрация транзакции на покупку/продажу
function NEW_ORDER(code, operation, price, q, comment, id, stop, stop_k_take, pattern)   
	
	-- Есть еще вариант ставить "OFFER" - Лучшая цена предложения" вместо LAST
	-- По цене, завышенной на 10 мин. шагов цены
	if(tostring(operation) == "B") then
		PriceRes = price + 100 * _QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		PriceOpenPosition = price;
		symbol = "+";
	elseif(tostring(operation) == "S") then		 
		PriceRes = price - 100 * _QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		PriceOpenPosition = price;
		symbol = "-";
	end;
	
	-- Заполняет структуру для отправки транзакции на покупку ФЬЮЧЕРСОВ
	-- Генерирует случайный ID транзакции на продажу ФЬЮЧЕРСОВ
	local commentJoin = "";
	commentJoin = comment;
	
	if stop ~= nil then
		commentJoin = commentJoin .. "/" .. stop;
	end;
	if stop_k_take ~= nil then
		commentJoin = commentJoin .. "/" .. stop_k_take;
	end;
	if pattern ~= nil then
		commentJoin = commentJoin .. "/" .. pattern;
	end;
	
	-- Оформляем транзакцию
	local TransactionArray = {
		["CLASSCODE"]	= TRANS_CLASS_CODE_FUT,
		["ACCOUNT"]		= TRANS_TRADE_ACC,
		["SECCODE"]		= code,
		["TRANS_ID"]	= tostring(id), -- _MyFuncRandomMax()
		["CLIENT_CODE"]	= commentJoin, -- Так записываем комментарий
		["ACTION"]     	= "NEW_ORDER",
		["OPERATION"]  	= operation, -- покупка/продажа (BUY)
		["TYPE"]       	= "M", -- по рынку (MARKET)
		["PRICE"]      	= CustomPriceFormat(PriceRes), -- по цене, завышенной на 10 мин. шагов цены
		["QUANTITY"]   	= tostring(q), -- количество
		-- ["COMMENT"] 	= tostring("Продажа фьючерсов скриптом");
	};
	
	-- ЕСЛИ функция вернула строку диагностики ошибки, ТО значит транзакция не прошла
	return CustomSendTransaction(TransactionArray, id, "ZAREGISTRIROVANO.NEW_ORDER", "ISPOLNENO.NEW_ORDER");
	
end;

-- Регистрация транзакции на установку стопа (тейк&профит)
function NEW_STOP_ORDER(code, operation, price, q, comment, id, stop, stop_k_take)	

	-- Есть еще вариант ставить "OFFER" - Лучшая цена предложения" вместо LAST
	-- По цене, заниженной на 10 мин. шагов цены
	-- PriceRes = _QuikGetParamExByIndex(code,'LAST');
	
	-- Заполняет структуру для отправки транзакции на покупку ФЬЮЧЕРСОВ
	-- Генерирует случайный ID транзакции на продажу ФЬЮЧЕРСОВ
	local commentJoin = "";
	commentJoin = comment; --  .. "/" .. stop .. "/" .. stop_k_take;
	
	-- Заполняет структуру для отправки транзакции на покупку ФЬЮЧЕРСОВ
	--['CONDITION'] = direction, -- Направленность стоп-цены. Возможные значения: «4» - меньше или равно, «5» – больше или равно
	local TransactionArray = {
		["CLASSCODE"]			= TRANS_CLASS_CODE_FUT,
		["ACCOUNT"]				= TRANS_TRADE_ACC,
		["SECCODE"]				= code,
		["TRANS_ID"]			= tostring(id), -- _MyFuncRandomMax()
		["CLIENT_CODE"]			= commentJoin, -- Так записываем комментарий
		["ACTION"]     			= "NEW_STOP_ORDER", -- Тип заявки
		["STOP_ORDER_KIND"]     = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER", -- Тип стоп-заявки (SIMPLE_STOP_ORDER)
		["TYPE"]       			= "L", -- лимитированная 
		["QUANTITY"]   			= tostring(q), -- количество
		-- ["COMMENT"]    		= "Тейк-профит и стоп-лосс фьючерсов скриптом",
		["OFFSET_UNITS"]        = "PRICE_UNITS",
		["SPREAD_UNITS"]        = "PRICE_UNITS",
		["EXPIRY_DATE"]			= "GTC", -- на учебном серве только стоп-заявки с истечением сегодня, потом поменять на GTC
		["OPERATION"]  			= operation, -- покупка (BUY "B" || SELL "S")
		["IS_ACTIVE_IN_TIME"]	= "NO"
	};
	
	local symbol;
	local priceTp;
	local priceSl;
	
	-- ЕСЛИ это к "покупке"
	if operation == "S" then
		-- символ (покупка, или продажа)
		symbol = "-";
	
		-- Стоп-лосс
		-- по цене, заниженной на 10 мин. шагов цены (100 - это защт. спред)
		priceSl = price-stop;
		TransactionArray["PRICE"] = priceSl-10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		TransactionArray["STOPPRICE2"] = priceSl; -- Цена Стоп-Лосса
		
		-- Тейк-профит
		priceTp = price+(stop*stop_k_take);
		TransactionArray["STOPPRICE"] = priceTp; -- Цена Тэйк-Профита
		TransactionArray["OFFSET"] = "0"; -- tostring(50*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP')); -- Отступы от Min tostring(2*SEC_PRICE_STEP),
		TransactionArray["SPREAD"] = 10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP'); -- Защитный спред
	end;
	
	-- ЕСЛИ это к "продаже"
	if operation == "B" then
		-- символ (покупка, или продажа)
		symbol = "+";
		
		-- Стоп-лосс
		-- по цене, заниженной на 10 мин. шагов цены (100 - это защт. спред)
		priceSl = price+stop;
		TransactionArray["PRICE"] = priceSl+10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		TransactionArray["STOPPRICE2"] = priceSl; -- Цена Стоп-Лосса
		-- Тейк-профит
		priceTp = price-(stop*stop_k_take);
		TransactionArray["STOPPRICE"] = priceTp; -- Цена Тэйк-Профита
		TransactionArray["OFFSET"] = "0"; -- tostring(50*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP')); -- Отступы от Min tostring(2*SEC_PRICE_STEP),
		TransactionArray["SPREAD"] = 10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP'); -- Защитный спред
	end;
	
	-- Приводим в правильное значение
	TransactionArray["PRICE"] = CustomPriceFormat(TransactionArray["PRICE"]);
	TransactionArray["STOPPRICE2"] = CustomPriceFormat(TransactionArray["STOPPRICE2"]);
	TransactionArray["STOPPRICE"] = CustomPriceFormat(TransactionArray["STOPPRICE"]);
	TransactionArray["OFFSET"] = CustomPriceFormat(TransactionArray["OFFSET"]);
	TransactionArray["SPREAD"] = CustomPriceFormat(TransactionArray["SPREAD"]);
	
	-- message("!"..TransactionArray["PRICE"].."\n"
	-- 	..TransactionArray["STOPPRICE2"].."\n"
	-- 	..TransactionArray["STOPPRICE"].."\n"
	-- 	..TransactionArray["OFFSET"].."\n"
	-- 	..TransactionArray["PRICE"].."\n"
	-- );
	
	-- ЕСЛИ функция вернула строку диагностики ошибки, ТО значит транзакция не прошла
	return CustomSendTransaction(TransactionArray, id, "ZAREGISTRIROVANO.NEW_STOP_ORDER", "ISPOLNENO.NEW_STOP_ORDER");
	
end;

-- Регистрация транзакции на модификацию стопа (тейк&профит)
function MODIFY_STOP_ORDER(code, real_id, q)
	for i = 0,getNumberOf("stop_orders") - 1 do
		if getItem("stop_orders",i).sec_code == code then
			if getItem("stop_orders",i).stop_order_type == 9 then -- Флаг "9" -- тэйк-профит и стоп-лимит  
				if bit.test(getItem("stop_orders",i).flags,0) then -- бит 0 (0x1) Заявка активна, иначе не активна
					if getItem("stop_orders",i).order_num == real_id then
						
						-- Если отправили транзакцию на удаление
						if KILL_STOP_ORDER(code,getItem("stop_orders",i).order_num) then
							
							-- Разбираем комментарий
							local comment = getItem("stop_orders",i).brokerref;
							local commentSplit = _QuikUtilitySplit(comment,"/");
							
							local stop_order_comment = commentSplit[1];
							local stop_order_number = commentSplit[2];
							local stop_order_sl = commentSplit[3];
							local stop_order_sl_k_tp = commentSplit[4];
							
							-- Определяем тип ордера
							local operation = "S";
							local price = 0;
							if getItem("stop_orders",i).condition == 5 then -- "5" -- ">=" (продажа)
								operation = "S";
								price = getItem("stop_orders",i).condition_price2+stop_order_sl;
							elseif getItem("stop_orders",i).condition == 4 then -- "4" -- "<=" (покупка)
								operation = "B";
								price = getItem("stop_orders",i).condition_price2-stop_order_sl;
							end;
							
							-- NEW_STOP_ORDER(code, operation, price, q, comment, number, stop, stop_k_take)
							-- message(
							-- 	"code" .. code .."\n"..
							-- 	"operation" .. operation .."\n"..
							-- 	"price" .. getItem("stop_orders",i).price.. "\n"..
							-- 	"q" .. q .."\n"..
							-- 	"stop_order_comment" .. stop_order_comment.. "\n"..
							-- 	"stop_order_number" .. stop_order_number .."\n"..
							-- 	"stop_order_sl" .. stop_order_sl .."\n"..
							-- 	"stop_order_sl_k_tp" .. stop_order_sl_k_tp  .."\n"
							-- );
							
							return NEW_STOP_ORDER(
								code, 
								operation, 
								price,
								q,
								stop_order_comment,
								stop_order_number,
								stop_order_sl,
								stop_order_sl_k_tp
							);
							
						end;
						
					end;
				end;
			end;
		end;
	end;
end;

-- Регистрация транзакции на удаление стоп-ордера
function KILL_STOP_ORDER(code, order_num, trans_id)
	
	-- Заполняет структуру для отправки транзакции на покупку ФЬЮЧЕРСОВ
	local TransactionArray = {
		["CLASSCODE"]			= TRANS_CLASS_CODE_FUT,
		["ACCOUNT"]				= TRANS_TRADE_ACC,
		["SECCODE"]				= code,
		["TRANS_ID"]			= tostring(trans_id), -- _MyFuncRandomMax()
		["CLIENT_CODE"]			= tostring("KILL.Ord"); -- Комментарий
		["ACTION"]     			= "KILL_STOP_ORDER", -- Тип заявки
		["STOP_ORDER_KIND"]     = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER",
		["STOP_ORDER_KEY"] 		= tostring(order_num), -- ID-ордера
	};
	
	-- ЕСЛИ функция вернула строку диагностики ошибки, ТО значит транзакция не прошла
	return CustomSendTransaction(TransactionArray, order_num, "ZAREGISTRIROVANO.KILL_STOP_ORDER", "ISPOLNENO.KILL_STOP_ORDER");

end;

-- Регистрация транзакций на удаление всех ордеров
function KILL_ALL_STOP_ORDERS(code)
	for i = 0,getNumberOf("stop_orders") - 1 do
		if getItem("stop_orders",i).sec_code == code then
			if getItem("stop_orders",i).stop_order_type == 9 then -- Флаг "9" -- тэйк-профит и стоп-лимит  
				if bit.test(getItem("stop_orders",i).flags,0) then -- бит 0 (0x1) Заявка активна, иначе не активна  
				
					-- KILL_STOP_ORDER(code,getItem("stop_orders",i).order_num,getItem("stop_orders",i).trans_id);
					
				end;
			end;
		end;
	end;
end;

-- Регистрация транзакций на удаление нескольких ордеров
-- На данный момент из расчета по 1 ордеру
-- Обрати внимание на getNumberOf("stop_orders") - когда заявка снята, счетчик меняется (буксует)
function KILL_STOP_ORDERS_BY_COUNT(code, q)
	local counter = 1;
	local list_del = {};
	for i = 0,getNumberOf("stop_orders") - 1 do
		if getItem("stop_orders",i).sec_code == code then
			if getItem("stop_orders",i).stop_order_type == 9 then -- Флаг "9" -- тэйк-профит и стоп-лимит  
				if bit.test(getItem("stop_orders",i).flags,0) then -- бит 0 (0x1) Заявка активна, иначе не активна  
					
					if KILL_STOP_ORDER(code,getItem("stop_orders",i).order_num, "500"..math.ceil(os.date("%S%M%H%d")/10000)..i) then
						-- message("СНЯТО++" .. getItem("stop_orders",i).order_num);
						counter = counter + 1;
					end;
					
					if counter > q then
						break;
					end;
					
				end;
			end;
		end;
	end;
	--for i = 1, #list_del do
	--	if KILL_STOP_ORDER(code,list_del[i], string.sub(list_del[i], 4)..i) then
	--		message("СНЯТО++" .. list_del[i]);
	--	end;
	--end;
end;

-- Синхроинизация стоп-ордеров
function SYNCHRONIZATION_ALL_STOP_ORDERS(code)

end;


-- function CustomSendTransaction()
function CustomSendTransaction(TransAr, id, StatusZareg, StatusIsp)
	
	-- Нет соединения
	if isConnected() == 0 then
		return nil;
	end;
	
	-- Преобразование ID
	local nid = tonumber(id);

	--  Защита от дублирования
	if TRANS_LIST[nid] == StatusZareg or TRANS_LIST[nid] == StatusIsp then
		return nil;
	
	-- Отпраляем транзакцию
	else
	
		local Result = sendTransaction(TransAr);
		if Result ~= "" then
			-- Выводит сообщение с ошибкой
			_QuikUtilityLogWrite("report", "System", {"#"..nid, TransAr["SECCODE"], "Error.sendTransaction()", Result});
			message("Сделка не удалась!\nОШИБКА: " .. Result);
			-- message("Выставление Тейк&Стоп ФЬЮЧЕРСОВ не удалось!\nОШИБКА: "..Result);
			-- message("Снятие Тейк&Стоп ФЬЮЧЕРСОВ не удалось!\nОШИБКА: "..Result);
			return nil; -- Завершает выполнение функции
		else
			-- Записывает в лог-файл
			-- ToLog("OnTrans ("..comment..")", {Depo=_QuikGetRubDepo(), Q=symbol..q, Price=price});
			-- Сохраняем и отправляем в поток транзакций для анализа на предмет выполнения
			TRANS_LIST[nid] = StatusZareg;
			TRANS_LIST_SORT[TRANS_LIST_COUNT_NUMBER] = nid;
			TRANS_LIST_COUNT_NUMBER = TRANS_LIST_COUNT_NUMBER + 1;
			
			return nid; -- Завершает выполнение функции (возвращяем ID)
		end;
	
	end;

end;

-- Устраняем ошибку: Неправильно указана цена: "18913.0" Сообщение об ошибке: Число не может содержать знак разделителя дробной части
-- Возможно это актуально только для срочного рынка (но не для фондового)
function CustomPriceFormat(price)
	return tostring(string.format ("%i", price));
end;