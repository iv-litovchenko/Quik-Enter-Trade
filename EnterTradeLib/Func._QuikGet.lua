-----------------------------------------------------
-- ФУНКЦИИ ПОЛУЧЕНИЯ ИНФОРМАЦИИ ИЗ QUIK
-----------------------------------------------------

-- QUIK Получить актуальные трейды на текущий момент (открытые сделки)
function _QuikGetRelevantTradesByIndex(code)

	local totalnet = _QuikGetTotalnetByIndex(code);
	local listTrades = {};
	local listQty = {};
	local j = 1;
	local p = 1;
	local k = 0;
	
	-- Читаем таблицу сделок
	for i = 0,getNumberOf("trades") - 1 do -- перебираем инструменты
		local trade = getItem("trades",i);
		if trade.class_code == TRANS_CLASS_CODE_FUT then -- если это фьючерс
		if trade.sec_code == code then -- если это выбранный инструмент
			-- if bit.test(trade.flags,0) then -- заявка активна
				
			-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- Если это открытие позиции
			-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- Если это открытие позиции

			if trade.brokerref:find("LO") and totalnet > 0 then
				listTrades[j] = trade;
				listQty[j] = trade.qty;
				j = j + 1;
			end;
			
			if trade.brokerref:find("SO") and totalnet < 0 then
				listTrades[j] = trade;
				listQty[j] = trade.qty;
				j = j + 1;
			end;
				
		end;
		end;
	end;
		
	-- Выявляем активные сделки (обратное чтение массива)
	-- На выходе мы знаем список сделок, которые сейчас актуальны
	-- message("FE"..tostring(listQty[#listQty]));
	-- message(listQty[0]);
	-- str = ".\n";
	result = {};
	for i = #listTrades, 1, -1 do
		-- str = str .. "FE #"..tostring(i).." / "..tostring(listTrades[i].trade_num).." / "..tostring(listQty[i]).."\n";
		result[p] = listTrades[i];
		k = k + listQty[i];
		p = p + 1;
		if k >= totalnet then
			break;
		end;
	end;
	
	-- message(tostring(str));
	return result;
	
end;

-- QUIK Получить актуальные стопы на текущий момент
-- @ code код
-- @ condition направление ордера
function _QuikGetRelevantStopOrdersByIndex(code, condition)

	-- Читаем таблицу стоп-ордеров
	local listStopOrders = {};
	local j = 1;
	local p = 1;
	
	for i = 0,getNumberOf("stop_orders") - 1 do
		local stop_order = getItem("stop_orders",i);
		if stop_order.class_code == TRANS_CLASS_CODE_FUT then -- если это фьючерс
		if stop_order.sec_code == code then -- если это выбранный инструмент
		if stop_order.stop_order_type == 9 then -- "9" -- тэйк-профит и стоп-лимит  
		if bit.test(stop_order.flags,0) then -- бит 0 (0x1) Заявка активна, иначе не активна 
			
			-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- Если это открытие позиции
			-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- Если это открытие позиции
			if stop_order.brokerref:find(condition) then -- "LC.Ord/", -- "SC.Ord/"
				listStopOrders[j] = stop_order;
				j = j + 1;
			end;
			
		end;
		end;
		end;
		end;
	end;
	
	-- message("COUNT : "..tostring(#listStopOrders));
	result = {};
	for i = #listStopOrders, 1, -1 do
		result[p] = listStopOrders[i];
		p = p + 1;
	end;
	
	return result;
	
end;

-- QUIK Получить: текущее объем по стоп опредрам
function _QuikGetTotalnetStopOrdersByIndex(code, condition)
	
	local q = 0;
	
	
	-- Читаем таблицу стоп-ордеров
	for i = 0,getNumberOf("stop_orders") - 1 do
		local stop_order = getItem("stop_orders",i);
		if stop_order.class_code == TRANS_CLASS_CODE_FUT then -- если это фьючерс
		if stop_order.sec_code == code then -- если это выбранный инструмент
		if stop_order.stop_order_type == 9 then -- "9" -- тэйк-профит и стоп-лимит  
		if bit.test(stop_order.flags,0) then -- бит 0 (0x1) Заявка активна, иначе не активна 
			
			-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- Если это открытие позиции
			-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- Если это открытие позиции
			if condition == 0 then -- Без условия
				q = q + stop_order.qty;
			elseif stop_order.brokerref:find(condition) then -- "LC.Ord/", -- "SC.Ord/"
				q = q + stop_order.qty;
			end;
			
		end;
		end;
		end;
		end;
	end;
	
	-- Читаем таблицу заявок (если там есть заявки от стоп-ордеров активные)
	-- Отказался -- 
	-- for i = 0,getNumberOf("orders") - 1 do
	-- 	local orders = getItem("orders",i);
	-- 	if orders.class_code == TRANS_CLASS_CODE_FUT then -- если это фьючерс
	-- 	if orders.sec_code == code then -- если это выбранный инструмент
	-- 	if bit.test(orders.flags,0) then -- бит 0 (0x1) Заявка активна, иначе не активна 
	-- 		
	-- 		-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- Если это открытие позиции
	-- 		-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- Если это открытие позиции
	-- 		
	-- 		-- Отказаля [РЕШИЛ ПОКА ОСТАВИТЬ] - нашел ошибку в неправильности установки тейк-профит и стоп-лосс (цены не так ставил)
	-- 		if orders.brokerref:find(condition) then -- "LC.Ord/", -- "SC.Ord/"
	-- 			q = q + orders.qty;
	-- 		end;
	-- 		
	-- 	end;
	-- 	end;
	-- 	end;
	-- end;
	
	return _QuikUtilityStrRound2(q);
	
end;

-- QUIK Получить: Функция получает параметр
function _QuikGetParamExByIndex(code, param)
	local status = getParamEx(TRANS_CLASS_CODE_FUT, code, "STATUS").param_value;
	local value = getParamEx(TRANS_CLASS_CODE_FUT, code, param).param_value;
	if tonumber(status) == 0 then
		return tonumber(0);
	else
		-- "inf" (+/- 1.#INF) 
		-- "nan" (- 1.#IND)
		if value == math.huge or value == -math.huge or value ~= value then
			return tonumber(0);
		else
			return tonumber(value);
		end;
	end;
end;


-- QUIK Получить: название инструмента из настроек + добавить U1 (код мемяца и года)
-- ! - непрерывный, только US (CL! - Crude Oil)
-- 1! - ближайший (NQ1! - E-mini Nasdaq 100)
-- 2! - следующий (ES2! - E-mini S&P 500)

--1)
-- F - январь (CLF3)
-- G - февраль (GCG3)
-- H - март (NQH3)		

--2)
-- J - апрель
-- K - май
-- M - июнь

--3)
-- N - июль
-- Q - август
-- U - сентябрь

--4)
-- V - октябрь
-- X - ноябрь
-- Z - декабрь

function _QuikGetNameByListTickets(code)
	-- message("code:"..code..":"..monthCode .. "::" ..year);
	-- return code..monthCode..year;
	
	local findCode = _QuikGetNameByListTickets_FindSecCode(code, 3);
	if findCode then
		return findCode;
	end;
	
	return code;
end;

	function _QuikGetNameByListTickets_FindSecCode(pref, dtmd) -- Определяем инструмент для торговли
		if dtmd == nil or dtmd < 1 then
			dtmd = 3;
		end;
		local sec_list = getClassSecurities (TRANS_CLASS_CODE_FUT); -- Получаем список инструментов
		for test_sec_code in string.gmatch(sec_list, "("..pref.."[^%s,]+)") do -- Перебираем список 
			local param = getParamEx(TRANS_CLASS_CODE_FUT, test_sec_code, "DAYS_TO_MAT_DATE");
			if (param.result == "1") and (param.param_image ~= "" ) and (param.param_type ~= "0") then -- Параметр получен корректно? 
				if (tonumber(param.param_value) >= dtmd) then -- Проверяем дни до экспирации
					return test_sec_code;
				end; 
			end;
		end;
		return code;
	end;

-- QUIK Получить: название инструмента
-- Через "_QuikGetParamExByIndex" не получается
function _QuikGetShortNameByIndex(code)
	for i = 0,getNumberOf("securities") - 1 do
		if getItem("securities",i).sec_code == code then        
			return getItem("securities",i).name;
		end;
	end;
	return 0;
end;

-- QUIK Получить: Функция получает стоимость 1 или нескольких пуктов в рублях
function _QuikGetRubPricePointsByIndex(code, count)
	-- "Тейк-профит в пунктах" * "Сколько контрактов вы хотите купить" * ("Стоимость шага цены" / "Шаг цены")
	-- "Стоп-лосс в пунктах" * "Сколько контрактов вы хотите купить" * ("Стоимость шага цены" / "Шаг цены")
	if _QuikGetParamExByIndex(code,"STEPPRICE") > 0 and _QuikGetParamExByIndex(code,"SEC_PRICE_STEP") > 0 then
		return tonumber(_QuikGetParamExByIndex(code,"STEPPRICE")/_QuikGetParamExByIndex(code,"SEC_PRICE_STEP")*count);
	else
		return tonumber(0);
	end;
end;

-- QUIK Получить: текущее кол-во открытх позиций (по инструменту)
function _QuikGetTotalnetByIndex(code)
	for i = 0,getNumberOf("futures_client_holding") - 1 do
		if getItem("futures_client_holding",i).sec_code == code then
			return getItem("futures_client_holding",i).totalnet;
		end;
	end;
	return 0;
end;

-- QUIK Получить: текущее кол-во активных инструментов
function _QuikGetActiveTicketsCount()
	local counter = 0;
	for i = 0,getNumberOf("futures_client_holding") - 1 do
		if getItem("futures_client_holding",i).totalnet > 0 or  getItem("futures_client_holding",i).totalnet < 0 then
			counter = counter + 1;
		end;
	end;
	return counter;
end;

-- Максимальное кол-во доступных контрактов к покупке/продаже
function _QuikGetMaxQtyByIndex(code)
	local maxQty = 10;
	
	-- Признак продажи, признак покупки
	-- maxQty1, maxComiss1 = CalcBuySell(TRANS_CLASS_CODE_FUT, code, TRANS_CLIENT_CODE, TRANS_TRADE_ACC, _QuikUtilityStrRound2(_QuikGetParamExByIndex(code,'LAST'),0), true, false);
	-- maxQty2, maxComiss2 = CalcBuySell(TRANS_CLASS_CODE_FUT, code, TRANS_CLIENT_CODE, TRANS_TRADE_ACC, _QuikUtilityStrRound2(_QuikGetParamExByIndex(code,'LAST'),0), false, false);
	-- maxQty = math.min(maxQty1,maxQty2);
	-- return tonumber(maxQty);
	
	-- ДЕПОЗИТ ТЕКУЩИЙ / ГО - переделал формулу
	if _QuikGetParamExByIndex(code,"SELLDEPO") > 0 then 
		-- Почему-то всегда 1 лишний контракт и не дают открываться им...
		return tonumber(math.floor((_QuikGetRubFreeDepo()/_QuikGetParamExByIndex(code,"SELLDEPO"))*0.90));
	else
		return 0;
	end;
end;

-- QUIK Получить: баланс (предыдущего дня)
function _QuikGetRubPrevDepo()
	local fcl=getItem("futures_client_limits",0)
	if fcl ~= nil then
		return tonumber(fcl.cbp_prev_limit);
	else
		return 21034; -- real demo (для тренировок и тестов в рассчетах)
	end;
end;

-- QUIK Получить: баланс (текущий)
function _QuikGetRubDepo()
	
	-- Вариант №1 (как посчитать) - с офф.сайта Quik https://forum.quik.ru/forum13/topic978/
	-- for i=0,getNumberOf( "futures_client_limits" )-1 do
		local fcl=getItem( "futures_client_limits" , 0);
		if fcl ~= nil then
		--if fcl.trdaccid==TRANS_TRADE_ACC and fcl.limit_type==0  then
			cbplimit=tonumber(fcl.cbplimit);  --Лимит откр. поз.
			varmargin=tonumber(fcl.varmargin);  --Вариац. маржа
			accruedint=tonumber(fcl.accruedint);  --Накоплен. доход
			ts_comission=tonumber(fcl.ts_comission);  --Биржевые сборы
		-- end;
			b_v1=cbplimit+varmargin+accruedint;
			return b_v1;	
		else
			return 21124; -- real demo (для тренировок и тестов в рассчетах)
		end;
	-- end;
	
	-- Вариант №2 (как посчитать) - со смарт-лаб https://smart-lab.ru/blog/292043.php
	-- n = getItem("futures_client_limits",0).cbplused;
	-- m = getItem("futures_client_limits",0).cbplplanned;
	-- v = getItem("futures_client_limits",0).varmargin;
	-- b_v2=n+m+v;
	
end;

-- QUIK Получить: баланс (свободный)
function _QuikGetRubFreeDepo()
	local fcl = getItem("futures_client_limits",0);
	if fcl ~= nil then
		return fcl.cbplplanned;	
	else
		return 21124; -- real demo (для тренировок и тестов в рассчетах)
	end;
end;

-- QUIK Получить: баланс (свободный) - в "%"
function _QuikGetPercentFreeDepo()
	return ((_QuikGetRubFreeDepo() / _QuikGetRubDepo()) * 100);
end;

-- QUIK Получить: баланс (задействованный) - в "%"
function _QuikGetPercentUsedDepo()
	return 100-_QuikGetPercentFreeDepo();
end;


-- QUIK Получить: маржа по текущему инструменту
function _QuikGetRubMarginByIndex(code)
	for i = 0,getNumberOf("futures_client_holding") - 1 do
		if getItem("futures_client_holding",i).sec_code == code then
			return getItem("futures_client_holding",i).varmargin;
		end;
	end;
	return 0;
end;

-- QUIK Получить: маржа по текущему инструменту - в "%"
function _QuikGetPercentMarginByIndex(code)
	return ((_QuikGetRubMarginByIndex(code) / _QuikGetRubFreeDepo()) * 100);
end;

-- QUIK Получить: маржа (общаяя)
function _QuikGetRubMarginAll()
	local fcl = getItem("futures_client_limits",0);
	if fcl ~= nil then
		return fcl.varmargin;
	else
		return 0;
	end;
end;

-- QUIK Получить: маржа (общаяя) - в "%"
function _QuikGetPercentMarginAll()
	if tonumber(_QuikGetRubMarginAll()) > 0 and tonumber(_QuikGetRubFreeDepo()) > 0 then
		return ((_QuikGetRubMarginAll() / _QuikGetRubFreeDepo()) * 100);
	else 
		return 0;
	end;
end;

-- QUIK Получить: процент изменения счета за день (по отношению к пред. дню)
function _QuikGetPercentChangeDepoPerDay()
	if tonumber(_QuikGetRubDepo()) > 0 and tonumber(_QuikGetRubPrevDepo()) then
		return tonumber((((_QuikGetRubDepo()/_QuikGetRubPrevDepo()))*100))-100;
	else
		return 0;
	end;
end;

-- QUIK Получить информацию о графике (индикаторе)
-- t – таблица, содержащая запрашиваемые свечки,
-- n – количество свечек в таблице t,
-- l – легенда (подпись) графика.
function _QuikGetChartByIndex(code, line, first_candle)

	if line == nil then line = 0; end;
	if first_candle == nil then first_candle = 0; end;

	-- tag – строковыи? идентификатор графика или индикатор
	-- line – номер линии графика или индикатора. Первая линия имеет номер 0,
	-- first_candle – индекс первои? свечки. Первая (самая левая) свечка имеет индекс 0,
	-- count – количество запрашиваемых свечек.
	local t, n, l = getCandlesByIndex(code, 0, 0, getNumCandles(code));
	
	-- Легенду можно увидеть через параметр l функции getCandlesByIndex
	-- Если пусто (не nil а именно пустое значение) значит идентификатора нет.
	if (l~=nil) then
		-- message("GOOD")
		-- local O = t[n-2].open; -- Получить значение Open для указанной свечи (цена открытия свечи)
		-- local H = t[n-2].high; -- Получить значение High для указанной свечи (наибольшая цена свечи)
		-- local L = t[n-2].low; -- Получить значение Low для указанной свечи (наименьшая цена свечи)
		-- local C = t[n-2].close; -- Получить значение Close для указанной свечи (цена закрытия свечи)
		-- local V = t[n-2].volume; -- Получить значение Volume для указанной свечи (объем сделок в свече)
		-- local T = tonumber(t[n-2].datetime); -- Получить значение Time для указанной свечи (время открытия свечи (таблица datetime))
		return t[n-1]; -- было -2
		
	else
		-- message("BAD" .. code);
		return 0;
		-- message();
	end;
	
end;

-- QUIK Проверить сущ. графика
function _QuikChartExistsByIndex(code, regAlert)
	local t, n, l = getCandlesByIndex(code, 0, 0, getNumCandles(code));
	if (t[n-1] == nil) then
		if regAlert == 1 then
			_QuikUtilityRegAlert(code, "Идентификатор графика не существует!");
		end;
		return false;
	else
		return true;
	end;
end;

-- QUIK Выполнить http - запрос
function _QuikGetHttp()
	content, status, header = socket.http.request(ROBOT_HTTP_URL);
	return content;
end;