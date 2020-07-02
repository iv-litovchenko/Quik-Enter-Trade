------------------------------------------------------------------------------
-- Торговый привод Enter Trade для терминала Quik (для срочного рынка FORTS)
-- с открытым исходным кодом, с автоматическим выставлением StopLoss&TakeProfit
-- Иван Литовченко 2020

-- Любые пожелания и замечания приветствуются:
-- http://iv-litovchenko.ru/quik-enter-trade
-- https://vk.com/quik.enter.trade
-- Email: iv-litovchenko@mail.ru

-- Установка (в основном тестировалось в Quik7, Windows 7,8):
-- 1. Для проигрывания звуков необходимо скачать и закинуть в папку Quik библиотеку "w32.dll": https://quik2dde.ru/viewtopic.php?id=78
-- 2. При первоначальном знакомстве рекомендуется опробовать привод на демо-счете
-- 3. После скачивания архива все содержимое архива необходимо разместить в папку, где установлен Quik ("C:\QUIK-...\LuaIndicators\")
-- 4. В файле "EnterTrade.Settings.All.lua" необходимо установить ваш "Торговый счет" и "Код клиента"
-- 5. В файле "EnterTrade.Settings.All.lua" в переменной "FILE_SETTINGS_LIST_TICKETS" необходимо перечислить список торгуемых тикетов 
-- 6. Проверить сущестование папки для логов ("C:\QUIK-...\LuaIndicators\EnterTradeLog"), если она была удалена по какой-либо причине
-- 7. После вышеперечисленного, необходимо запустить сам скрипт "Сервисы > Lua-скрипты... > Добавить" 
-- 8. Важно: пока работает скрипт крайне не рекомендуется открывать файлы "№СЧЕТА.report.csv" и "№СЧЕТА.report.full.csv"
-- 9. Важно: 
		-- по умолчанию при запуске скрипта в файле "Settings.Callback.Alert.lua" приведен пример оповещения на основе пересечения цены и индикатора SAR, их необходимо затереть
		-- по умолчанию при запуске скрипта в файле "EnterTrade.Settings.Callback.Robot.lua" в качестве примера описаны 4 торговых алгоритма (робота), их необходимо затереть
-- 10. Важно: убедиться что не запущено два экземпляра торгового привода (обычно может происходить после перезапуска Quik и ручного запуска еще 1 экземпляра)!
------------------------------------------------------------------------------

-- OnFuturesClientHolding 	-- (Позиции по клиентским счетам (фьючерсы)) Функция вызывается терминалом QUIK при изменении позиции по срочному рынку (Позиции по клиентским счетам (фьючерсы)).		
-- OnTransReply				-- (Таблица транзакций) Функция вызывается терминалом QUIK при получении ответа на транзакцию пользователя.
-- OnOrder					-- (Таблица заявок) Функция вызывается терминалом QUIK при получении новой заявки или при изменении параметров существующей заявки.
-- OnTrade					-- (Таблица сделок) Функция вызывается терминалом QUIK при получении сделки.
-- OnStopOrder				-- (Таблица стоп-заявок) Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки .
-- OnParam					-- Функция вызывается терминалом QUIK при изменении текущих параметров.
-- https://sourceforge.net/projects/qllib/files/ (полез. библиотека)

-- TODO (START)
	
	-- and (string.sub(getItem("securities",i).code, 1,2)) == "Si" then -- содержит Si

	-- Подобрать библиотеку для музыки...
	-- Music БУ | CLOSE
	
	-- BUY на растущей свечке SELL на падающей свечке
	-- Риск-Менеджер (интервалы между сделками)
	-- Риск-Менеджер (в сулчаем убыточной сделки - уменьш. кол-ва лотов)
	-- Риск-Менеджер (рассчет размера стопа в зависимости от волат. инструмента, от кол. тек. цены, реккоменд. стоп должен быть больше случ. колеб. цены)
	-- Риск-Менеджер (штрам в сек. между сделками)
	-- Риск-Менеджер (макс. серия убыточных сделок)
	-- Риск-Менеджер (объем задействованного капитала в рынке > 50% - по всем сделкам)
	-- Риск-Менеджер (скоро клиринг)
	-- Риск-Менеджер (убыточных сделок)
	-- Риск-Менеджер (убытков подряд)
	
-- TODO (END)

-- Включения
-- debug = nil;
w32 = require("w32");
dofile(getScriptPath().."\\EnterTradeSettings\\Settings.All.lua"); -- файл настроек
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikGet.lua");
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikTable.lua");
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikSendTransaction.lua");
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikUtility.lua");
-- dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikRMSysA.lua");
-- dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikRMSysB.lua");

-- Переменные для настройки счета
TRANS_CLASS_CODE_FUT			= "SPBFUT"; -- Класс ФЬЮЧЕРСОВ
TRANS_TRADE_ACC					= FILE_SETTINGS_TRADE_ACC; -- Торговый счет
TRANS_CLIENT_CODE				= FILE_SETTINGS_CLIENT_CODE; -- Код клиента
TRANS_SECCODE					= ""; -- Код ФЬЮЧЕРСА для открытия	-- VBM0/SRM0/RIM0
TRANS_SECNAME					= ""; -- Название ФЬЮЧЕРСА -- VTBR-6.20/SBRF-6.20|RTS-6.20

-- Переменные системы
IsRun = true; -- Флаг поддержания работы скрипта
ScriptVersion = "1.1"; 
CheckLastNumOnTrade				= 0;
CheckLastNumOnOrderAct			= 0;
CheckLastNumOnOrderNotAct		= 0;
CheckLastNumOnStopOrder			= 0;
RegAlert 						= {}; -- События
RegLabel 						= {}; -- События, метки на графике
RegAlertCounter 				= 1; -- События (счетчик)
RegLabelCounter 				= 1; -- События, метки на графике (счетчик)

-- Переменные для сохранения значений переключателей стрелок "<" и ">"
RM_COLOR						= 255; -- Мерцание риск-менеджера
VAL_HIDE_RUB_TIMER				= 11000;
VAL_TIKET 						= 1; -- Текущий тикет (значение)
VAL_Q 							= 0; -- Текущий объем (значение)
VAL_SL 							= 60; -- Текущий SL (значение)
VAL_SL_K_TP 					= 3; -- Соотношение тейка к стопу
VAL_PATTERN 					= 1; -- Паттерн
VAL_CLOSE_TYPE_NUM				= 5; -- Текущий вариант закрытия
VAL_CLOSE_TYPE = {
	{"CallbackCellButtonClosePart25",	"   -=CLOSE 25%=-	",	25},
	{"CallbackCellButtonClosePart33",	"   -=CLOSE 33%=-	",	33},
	{"CallbackCellButtonClosePart50",	"   -=CLOSE 50%=-	",	50},
	{"CallbackCellButtonClosePart80",	"   -=CLOSE 80%=-	",	80},
	{"CallbackCellButtonCloseAll",		"   -=CLOSE ALL=-	",	100}
};

-- Переменны отслеживания
TRANS_LIST 						= {}; -- Глобальная переменна с сохранением ID-транзаций
TRANS_LIST_SORT 				= {}; -- Глобальная переменна куда записывается №последовательности
TRANS_LIST_COUNT_NUMBER			= 1; -- Глобальная переменная счетчик

FLAG_OnFuturesClientHolding 	= 0;
FLAG_COUNTER_GET_UP				= 0; -- Флаг разрешения увеличения счетчика - ордеров всего (т.к. это не PHP, и код не сверху вниз)
FLAG_COUNTER_GET_UP_TODAY		= 0; -- Флаг разрешения увеличения счетчика - ордеров сегодня (т.к. это не PHP, и код не сверху вниз)
FLAG_DISABLE_BUTTON				= 0; -- Флаг блокировки кнопок
LIST_NUMBER_BUTTON				= {}; -- Список №колонок в которых находится кнопка

-- TODO (в дальнейшем)
-- LINE_STOP_ORDERS				= {{}}; -- Очередь выставления стоп-ордеров
-- LINE_STOP_ORDERS_COUNTER		= 1; -- Счетчик очереди (всего)
-- LINE_STOP_ORDERS_COUNTER_ALL	= 1; -- Счетчик очереди (всего)

ADDED_ROW						= {}; -- Добавленные ячейки (строки)
COUNTER_CELL 					= 1; -- Добавленные ячейки
CALLBACK_CELL 					= {}; -- Обратные вызовы для нажатия колонок
FILE_SETTINGS_LIST_RM_KEY 		= {}; -- Ключи риск-менеджера

function OnInit()

	message("Enter Trade "..ScriptVersion.." Start, QUIK "..getInfoParam('VERSION')..".");
	
	-- Проверяем торгуется ли тикет?
	-- Если инструмент не торгуется, выбран например "RIM5"
	--if tonumber(_QuikGetParamExByIndex(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1], "STATUS")) == 0 then 
	--	message("Тикет "..FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1].." не торгуется! Пожалуйста актуализируйте файл настроек в части параметра FILE_SETTINGS_LIST_TICKETS{}", 3);
	--	IsRun = false;
	
	--else
		-- Устанавливаем название инструмента
		TRANS_SECCODE = FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1];
		TRANS_SECNAME = _QuikGetShortNameByIndex(TRANS_SECCODE);
		VAL_SL = _QuikUtilityStrRound2(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][2]);
		
		-- Включаем классы риск-менеджеров
		for i = 1, #FILE_SETTINGS_LIST_RM do
			FILE_SETTINGS_LIST_RM_KEY[FILE_SETTINGS_LIST_RM[i][1]] = i; -- сохраняем ключ для выборки настроек
			dofile(getScriptPath().."\\EnterTradeLib\\Func."..FILE_SETTINGS_LIST_RM[i][1]..".lua");
		end;
		
		_QuikUtilitySoundFileStop(); -- Останавливаем проигрывание музыки (если есть)
		CreateTable(); -- Создаем таблицу
	--end;
	
end;             
 
function main()
	-- Цикл будет выполнятся, пока IsRun == true
	while IsRun do
		
		-- ОБРАБОБТКА ОЧЕРЕДИ СТОП-ОРДЕРОВ
		-- TODO: возможно в дальнейшем сделаем!
		-- if #LINE_STOP_ORDERS[LINE_STOP_ORDERS_COUNTER] > 0 then
			-- local stop_order_type = LINE_STOP_ORDERS[LINE_STOP_ORDERS_COUNTER][1];
			
			-- Если просят добавить некторое кол-во ордеров
			-- if stop_order_type == "NEW_STOP_ORDER" then
				-- NEW_STOP_ORDER(sec_code, "S", price, qty, "LC/Ord", trade_num, trade_sl, trade_sl_k_tp);
				-- NEW_STOP_ORDER(sec_code, "B", price, qty, "SC/Ord", trade_num, trade_sl, trade_sl_k_tp);
				
			-- Если просят убрать некоторое кол-во ордеров
			-- elseif stop_order_type == "KILL_STOP_ORDERS" then
			-- end;
		-- end;
		-- LINE_STOP_ORDERS_COUNTER = LINE_STOP_ORDERS_COUNTER+1;
		-- LINE_STOP_ORDERS[LINE_STOP_ORDERS_COUNTER] = {"NEW_STOP_ORDER",sec_code,"S",price,qty,"LC/Ord",trade_num,trade_sl,trade_sl_k_tp}; --
		-- LINE_STOP_ORDERS[tonumber(LINE_STOP_ORDERS_COUNTER)]["2"]="NEW_STOP_ORDER"; -- ,2=10,3=18000};
		
		UpdateTable(); -- Обновляем таблицу
		
		-- Динамические коллбэки
		if isConnected() == 1 then
		
			-- Alert
			local callResult, result = pcall(dofile, getScriptPath().."\\EnterTradeSettings\\Settings.Callback.Alert.lua")
			if callResult then
				-- все в порядке, result это то, что вернула функция dofile
			else
				-- result это сообщение об ошибке
				message(tostring(result));
				sleep(5000);
			end;
			
			-- Robot
			local callResult, result = pcall(dofile, getScriptPath().."\\EnterTradeSettings\\Settings.Callback.Robot.lua")
			if callResult then
				-- все в порядке, result это то, что вернула функция dofile
			else
				-- result это сообщение об ошибке
				message(tostring(result));
				sleep(5000);
			end;
			
		end;
		
		-- Нет соединения
		if isConnected() == 0 then
			FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
			SetCellButtonDisabled();
		end;
		
		-- СДЕЛКИ: если разрешено увеличение счетчика
		-- if FLAG_OnFuturesClientHolding == 1 then
		if FLAG_COUNTER_GET_UP == 1 then
			_QuikUtilityLogCounterGetUp("order"); -- _QuikUtilityLogCounterGetUp("order"); -- Увеличиваем число сделок
			FLAG_COUNTER_GET_UP = 0;
		end;
		-- end;
		
		-- СДЕЛКИ: если разрешено увеличение счетчика
		-- if FLAG_OnFuturesClientHolding == 1 then
		if FLAG_COUNTER_GET_UP_TODAY == 1 then
			_QuikUtilityLogCounterGetUp("order-today."..os.date("%d-%m-%Y", os.time())); -- _QuikUtilityLogCounterGetUp("order"); -- Увеличиваем число сделок
			FLAG_COUNTER_GET_UP_TODAY = 0;
		end;
		-- end;
		
		-- if isConnected() == 1 then
			-- UpdateOrders(TRANS_SECCODE); -- Обновляем ордера
		-- end;
		
		if IsWindowClosed(t_id) then --закрываем скрипт, когда окно закрыто
			OnStop();
		end;
		sleep(100);
	end;
end;
 
function OnStop()
	_QuikUtilityLogWrite("report", "System", {"","","OnStop"});
	_QuikUtilitySoundFileStop();
	IsRun = false;
	message("Enter Trade Stop.");
	DestroyTable(t_id);
	DestroyTable(t_id2);
end;

function OnClose()
	_QuikUtilityLogWrite("report", "System", {"","","OnClose"});
	_QuikUtilitySoundFileStop();
	IsRun = false;
end;

function OnDisconnected()
	_QuikUtilityLogWrite("report", "System", {"","","OnDisconnected"});
	FLAG_DISABLE_BUTTON = 1; -- блокируем кнопки
	SetCellButtonDisabled();
end;

function OnConnected()
	_QuikUtilityLogWrite("report", "System", {"","","OnConnected"});
	FLAG_DISABLE_BUTTON = 0; -- разблок. кнопки
	SetCellButtonEnabled();
end;
 
-- Функция создает таблицу
function CreateTable()
   
	-- Получает доступный id для создания
	t_id = AllocTable(); 
	
	-- Создаем колонки
	AddColumn(t_id, 0, "", true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id, 1, "", true, QTABLE_STRING_TYPE, 20);
	AddColumn(t_id, 2, "", true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id, 3, "", true, QTABLE_STRING_TYPE, 100);

	t = CreateWindow(t_id);-- Создает таблицу
	SetWindowCaption(t_id, "Enter trade "..ScriptVersion.." (Quik 7,Quik 8)"); -- Устанавливает заголовок	
	SetWindowPos(t_id, 100, 100, 252, 532); -- Задает положение и размеры окна таблицы
	
	-- Назначает таблице t_id функцию обработки событий "CallbackTable"
	SetTableNotificationCallback(t_id, function(t_id, msg, par1, par2)
		if msg == QTABLE_LBUTTONUP then
			if CALLBACK_CELL[tostring(par1.."_"..par2)] ~= nil then
				local funcName = CALLBACK_CELL[tostring(par1.."_"..par2)];
				if  _G[funcName] ~= nil then
					_G[funcName](); -- message(CALLBACK_CELL[tostring(par1.."_"..par2)]);
				end;
			end;
		end;
	end); 
 
end;

-- Функция обновляет таблицу
function UpdateTable()

	if RM_COLOR == 245 then
		RM_COLOR = 230;
	elseif RM_COLOR == 230 then
		RM_COLOR = 200;
	elseif RM_COLOR == 200 then
		RM_COLOR = 180;
	else
		RM_COLOR = 245;
	end;
	
	local PipsPercentSl = (_QuikGetRubPricePointsByIndex(TRANS_SECCODE, VAL_SL * VAL_Q)/_QuikGetRubDepo())*100;

	-- Если инструмент не торгуется, выбран например "RIM5"
	if tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "STATUS")) == 1 then 
		-- Clear(t_id); -- Очищаем таблицу!
	end;
	
	COUNTER_CELL = 1; -- Сбрасываем счетчик
	SetCellInfo(); -- События (динамика)
	SetCellCode(VAL_TIKET, TRANS_SECCODE, TRANS_SECNAME); -- Код инструмента (динамика)
	SetCellPattern(); -- Паттерн (динамика)
	SetCellTp(VAL_SL,VAL_SL_K_TP); -- Тейк-профит (динамика)
	SetCellSl(VAL_SL, PipsPercentSl); -- Стоп-лосс (динамика)
	SetCellQ(VAL_Q); -- Кол-во (динамика)
	SetCellCalc(); -- Калькулятор (статика)
	
	-- Если инструмент не торгуется, выбран например "RIM5"
	-- if tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "STATUS")) == 1 then 
	
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellButtonBuy();
		-- SetCellButtonOverturn();
		SetCellButtonSell();
		SetCellTotalnet(_QuikGetTotalnetByIndex(TRANS_SECCODE));
		SetCellTotalnetOrders(_QuikGetTotalnetStopOrdersByIndex(TRANS_SECCODE,0)); -- Объем стоп-лоссов (в контрактах) -- todo
		SetCellMargin(_QuikUtilityStrRound2(_QuikGetPercentMarginByIndex(TRANS_SECCODE),2));
		SetCellButtonClosePart(1,25); -- Кнопка закрыть 25% (динамика)
		SetCellButtonClosePart(2,33); -- Кнопка закрыть 33% (динамика)
		SetCellButtonClosePart(3,50); -- Кнопка закрыть 50% (динамика)
		SetCellButtonClosePart(4,80); -- Кнопка закрыть 80% (динамика)
		SetCellButtonCloseAll();
		-- SetCellButtonClose();
		
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellBlockSettings(); 
		SetCellButtonCloseAuto(); 
		SetCellButtonSlZero(); -- Перенос в БУ
		SetCellButtonSlT(); -- Трейлинг Стоп-лосс
		
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellBlockRiskManagement(); -- Блок депозит (динамика)
		
			-- Включаем классы риск-менеджеров
			for i = 1, #FILE_SETTINGS_LIST_RM do
				local class 		= FILE_SETTINGS_LIST_RM[i][1];
				local var_name 		= _G[FILE_SETTINGS_LIST_RM[i][1]].name;
				local var_cell_name = _G[FILE_SETTINGS_LIST_RM[i][1]].cell_name;
				local var_cell_help = _G[FILE_SETTINGS_LIST_RM[i][1]].cell_help;
				local var_cell_eval = _G[FILE_SETTINGS_LIST_RM[i][1]].cell_eval;
				
				-- local lua_eval_str = var_cell_eval; -- class..":check()"; -- "math.pow(3,2)"
				-- local lua_eval_res = assert(loadstring("return " .. lua_eval_str))(); -- pcall
				
				SetCellBlockRiskManagementElement(var_name, var_cell_name, var_cell_help, var_cell_eval);
				-- message("Результат работы функции: "..tostring(lua_eval_res));
				-- sleep(1000);
			end;
			
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellBlockVersion(); -- Блок версия (статика)
		
	-- end;
	
	COUNTER_CELL = COUNTER_CELL + 1;
	SetCellBlockDepo(); -- Блок депозит (динамика)
	SetCellJournal(); -- Журнал сделок (статика)
	
	-- Добавляет строки
	for i = 1,COUNTER_CELL do
		if ADDED_ROW[i] == nil then
			InsertRow(t_id, i);
			ADDED_ROW[i] = 1;
		end;
	end;
	
end;

-----------------------------------------------------
-- ФУНКЦИИ ОБРАТНЫЕ СОБЫТИЯ QUIK
-----------------------------------------------------

-- (таблица транзакций). Функция вызывается терминалом, когда с сервера приходит новая информация о транзакциях
function OnTransReply(trans_reply)
	local order_num		= trans_reply.order_num;
	local trans_id 		= trans_reply.trans_id;
	local status 		= trans_reply.status;
	local sec_code		= trans_reply.sec_code;
	local class_code	= trans_reply.class_code;
	local result_msg	= trans_reply.result_msg;
	local comment		= trans_reply.brokerref;
	
	-- Транзакция не обработана
	-- if TRANS_LIST[tonumber(trans_id)] == "ZAREGISTRIROVANO" then
	
		-- Статусы меньше 2 являются промежуточными (0 - транзакция отправлена серверу, 1 - транзакция получена на сервер QUIK от клиента),
		-- при появлении такого статуса делать ничего не нужно, а ждать появления значащего статуса
		-- Выходит из функции		
		if status < 2 then 
			
		-- Транзакция выполнена
		elseif status == 3 then 
			
			-- message('OnTransReply(): По транзакции №'..trans_id..' УСПЕШНО ВЫСТАВЛЕНА заявка №'..trans_reply.order_num..' по цене '..trans_reply.price..' объемом '..trans_reply.quantity) 
			-- TRANS_LIST[tonumber(trans_id)] = 3; -- транзакция обработана (переходим к "OnOrder" и "OnStopOrder")
	
		-- Произошла ошибка
		elseif status > 3 then 
			
			-- todo: по идее здесь можно повторно отправить транзакцию...
			_QuikUtilityLogWrite("report", "System", {"#"..order_num.."("..trans_id..")", (sec_code or ""), "Error.OnTransReply()", result_msg});
			message('OnTransReply(): ОШИБКА выставления заявки по транзакции №'..order_num.."("..trans_id..'), текст ошибки: '..result_msg);
			TRANS_LIST[tonumber(trans_id)] = ""; -- транзакция с ошибкой (разрешаем повторную отправку!)
		
			-- Разблокируем кнопки
			FLAG_DISABLE_BUTTON = 0; -- разблокируем кнопки
			SetCellButtonEnabled();
			
		end;
		
	-- end;
	
	-- message("OnTransReply()");
	
end;


-- (ИЗМЕНЕНИЕ БАЛАНСА НАЙТИ ФУНКЦЙЮ). 
-- Функция вызывается терминалом QUIK при изменении позиции по срочному рынку.
-- ФФФФФ
-- OnFuturesClientHolding
-- function ()
-- 	// СДЕЛАТЬ ЗАПСЬ ДЕПОЗИТА
-- 	// СДЕЛАТЬ ФЛАГ = 1
-- 	-- local sec_code = fut_pos.sec_code
-- 	-- local totalnet = tonumber(fut_pos.totalnet);
-- 	if FLAG_COUNTER_GET_UP == 1 and totalnet ~= nil then
-- 		FLAG_XXX = 1;
-- 	end;
-- end;

-- (Позиции по клиентским счетам (фьючерсы)). 
-- Функция вызывается терминалом QUIK при изменении позиции по срочному рынку.
function OnFuturesClientHolding(fut_pos)
	-- message("Входящие длинные позиции "..tostring(fut_pos.startbuy));-- NUMBER    
	-- message("Входящие короткие позиции "..tostring(fut_pos.startsell));-- NUMBER    
	-- message("Входящие чистые позиции "..tostring(fut_pos.startnet));-- NUMBER    
	-- message("Текущие длинные позиции "..tostring(fut_pos.todaybuy));-- NUMBER    
	-- message("Текущие короткие позиции "..tostring(fut_pos.todaysell));-- NUMBER    
	-- message("Текущие чистые позиции "..tostring(fut_pos.totalnet));-- NUMBER
	-- local sec_code = fut_pos.sec_code;
	-- local totalnet = tonumber(fut_pos.totalnet);
	-- if FLAG_COUNTER_GET_UP == 1 then --  and totalnet ~= nil
	-- 	FLAG_OnFuturesClientHolding = 1;
	-- end;
end;

--	Функция вызывается терминалом QUIK при изменении текущих параметров.
function OnParam(class, seccode)
	-- 
end;

-- (Таблица заявок) Функция вызывается терминалом QUIK при получении новой заявки или при изменении параметров существующей заявки.
function OnOrder(order)

	local sec_code 			= order.sec_code;	
	local order_num 		= order.order_num;
	local trans_id 			= order.trans_id;
	local flags 			= order.flags;
	local comment 			= order.brokerref;
	local balance			= order.balance;	
	
	-- Транзакция не обработана
	if TRANS_LIST[tonumber(trans_id)] == "ZAREGISTRIROVANO.NEW_ORDER" then
	
		if CheckLastNumOnOrderAct < order_num then
			CheckLastNumOnOrderAct = order_num;  -- Запомним номер последнего
			_QuikUtilityLogWrite("report", "System", {"-", sec_code, "Depo", "", "", "", _QuikUtilityStrRound2(_QuikGetRubPrevDepo()), _QuikUtilityStrRound2(_QuikGetRubDepo())});
		end;
		
		if not bit.test(flags,0) then -- бит 0 (0x1) - Заявка активна, иначе не активна
		
			-- Увеличиваем счетчик (даже если не весь объем сделки выполнился)
			-- _QuikUtilityLogCounterGetUp("order"); -- Увеличиваем число сделок
				
			-- Функция OnTrade() может высываться несколько раз...
			-- if balance == 0 then -- Остаток
			if CheckLastNumOnOrderNotAct < order_num then
				CheckLastNumOnOrderNotAct = order_num;  -- Запомним номер последнего
				
				-- Если произошло открытие позиции (лонг)
				-- Если произошло открытие позиции (шорт)
				if comment:find("LO/") or comment:find("SO/") then
					FLAG_COUNTER_GET_UP_TODAY = FLAG_COUNTER_GET_UP_TODAY + 1; -- разрешаем увеличить счетчик
				end;
					
				FLAG_COUNTER_GET_UP = FLAG_COUNTER_GET_UP + 1; -- разрешаем увеличить счетчик
				FLAG_DISABLE_BUTTON = 0; -- разблокировываем
				SetCellButtonEnabled();
				
				-- Сделка выполнена установлен!
				-- message("Ya OnOrder()!");
				TRANS_LIST[tonumber(trans_id)] = "ISPOLNENO.NEW_ORDER"; -- транзакция обработана 
					
			-- end;
			end;
			
	-- Иначе сбрасываем статуса
	-- К примеру если удалили руками
	else
		
		-- Ордер отменен!
		-- message("Ya OnStopOrder() else!");
		-- TRANS_LIST[tonumber(trans_id)] = ""; -- сброс
			
	end;
	end;

end;
	
-- (Таблица сделок). Функция вызывается терминалом QUIK при получении сделки
function OnTrade(trade)
	
	local trade_num 		= trade.trade_num;
	local trans_id 			= trade.trans_id;
	local flags 			= trade.flags;
	local comment 			= trade.brokerref;
	local qty 				= trade.qty;
	local price 			= trade.price;
	local sec_code 			= trade.sec_code;
	local class_code 		= trade.class_code;
	
	local arg_1 = nil;
	local arg_2 = nil;
	local arg_3 = nil;
	local arg_4 = nil;
	local arg_5 = nil;
	
	-- Функция OnTrade() может высываться несколько раз...
	if CheckLastNumOnTrade < trade_num then
	CheckLastNumOnTrade = trade_num;  -- Запомним номер последнего
		
		-- Если произошло открытие позиции (лонг/шорт)
		if comment:find("LO/") or comment:find("SO/") then
			
			if comment:find("LO/") then
				arg_1 = "+";
				arg_2 = tostring("-1");
				arg_3 = "S";
				arg_4 = "LC/Ord/"..price;
				agr_id = "203";
			else
				arg_1 = "-";
				arg_2 = tostring("+1");
				arg_3 = "B";
				arg_4 = "SC/Ord/"..price;
				agr_id = "303";
			end;
			
			local commentSplit = _QuikUtilitySplit(comment,"/");
			local trade_sl = commentSplit[2];
			local trade_sl_k_tp = commentSplit[3];
			
			-- Записываем лог
			_QuikUtilityLogWrite("report", "Trade", {"#"..trade_num, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1), _QuikUtilityStrRound2(_QuikGetRubPrevDepo()), _QuikUtilityStrRound2(_QuikGetRubDepo())});
			
			-- Выставляем стопы
			-- LINE_STOP_ORDERS				= {}; -- Очередь выставления стоп-ордеров
			-- LINE_STOP_ORDERS_COUNTER		= LINE_STOP_ORDERS_COUNTER+1;
			for i = 1, qty do
				-- NEW_STOP_ORDER(sec_code, "S", price, qty, "LC/Ord", trade_num, trade_sl, trade_sl_k_tp);
				-- trade_num - обрезаем первые 3 символа
				_QuikUtilityLogWrite("report", "System", {"#"..agr_id..string.sub(trade_num, 5)..i, sec_code, "NewStopOrder (1)"}); -- , arg_2, trade_sl, trade_sl_k_tp
				NEW_STOP_ORDER(sec_code, arg_3, price, 1, arg_4, agr_id..string.sub(trade_num, 5)..i, trade_sl, trade_sl_k_tp);
			end;
			
		end;
		
		-- Если произошло закрытие позиции в ручную "Часть"
		if comment:find("LC/Part-") or comment:find("SC/Part-") then
		
			if comment:find("LC/Part-") then
				arg_1 = "-";
			else
				arg_1 = "+";
			end;
			
			-- Удаляем стопы (определенное кол-во)
			_QuikUtilityLogWrite("report", "Trade", {"#"..trade_num, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1)});
			_QuikUtilityLogWrite("report", "System", {"-", sec_code, "KillStopOrders ("..qty..")"});
			KILL_STOP_ORDERS_BY_COUNT(sec_code, qty);
			
		end;
		
		-- Если произошло закрытие позиции в ручную "Закрыть все"
		if comment:find("LC/All") or comment:find("SC/All") then
		
			if comment:find("LC/All") then
				arg_1 = "-";
			else
				arg_1 = "+";
			end;
			
			-- Удаляем стопы (определенное кол-во)
			-- KILL_ALL_STOP_ORDERS(sec_code);
			_QuikUtilityLogWrite("report", "Trade", {"#"..trade_num, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1)});
			_QuikUtilityLogWrite("report", "System", {"-", sec_code, "KillStopOrders ("..qty..")"});
			KILL_STOP_ORDERS_BY_COUNT(sec_code,qty);
			
		end;
		
		-- Если произошло закрытие позиции по ордеру
		if comment:find("LC/Ord") or trade.brokerref:find("SC/Ord") then
			if comment:find("LC/Ord") then
				arg_1 = "-";
			else
				arg_1 = "+";
			end;
			_QuikUtilityLogWrite("report", "Trade", {"#"..trade_num, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1)});
		end;
		
	end;
	
end;

-- (Таблица стоп-заявок) Функция вызывается терминалом QUIK при получении новой стоп-заявки или при изменении параметров существующей стоп-заявки .
function OnStopOrder(stop_order)

	local order_num 		= stop_order.order_num;
	local trans_id 			= stop_order.trans_id;
	local flags 			= stop_order.flags;
	local stop_order_type 	= stop_order.stop_order_type;
	local comment 			= stop_order.brokerref;
	local sec_code 			= stop_order.sec_code;
	
	-- Функция OnTrade() может высываться несколько раз...
	-- if CheckLastNumOnStopOrder < order_num then
	-- CheckLastNumOnStopOrder = order_num;  -- Запомним номер последнего
	-- end;
	
	-- Флаг "9" -- тэйк-профит и стоп-лимит  
	if stop_order_type == 9 then
		
		-- Установка ордера!	
		if TRANS_LIST[tonumber(trans_id)] == "ZAREGISTRIROVANO.NEW_STOP_ORDER" then
				
			-- Ордер установлен!
			-- if bit.test(flags,0) then -- бит 0 (0x1) - Заявка активна, иначе не активна
				-- message("Ya OnStopOrder() new!");
				_QuikUtilityLogWrite("report", "System", {"#"..order_num, sec_code, "NewStopOrderSuccessful (1)"});
				TRANS_LIST[tonumber(trans_id)] = "ISPOLNENO.NEW_STOP_ORDER"; -- транзакция обработана 
				
			-- end;
		
		-- Отмена ордера!
		elseif TRANS_LIST[tonumber(order_num)] == "ZAREGISTRIROVANO.KILL_STOP_ORDER" then
		
			-- Ордер отменен!
			-- if not bit.test(flags,0) then -- бит 0 (0x1) - Заявка активна, иначе не активна
		
				-- Ордер отменен!;
				-- message("Ya OnStopOrder() kill! "..order_num);
				_QuikUtilityLogWrite("report", "System", {"#"..order_num, sec_code, "KillStopOrderSuccessful (1)"});
				TRANS_LIST[tonumber(order_num)] = "ISPOLNENO.KILL_STOP_ORDER"; -- транзакция обработана 
			
			-- end;
		
		-- Иначе сбрасываем статуса
		-- К примеру если удалили руками
		else
			
			-- Стоп-ордер исполнен
			-- бит 0 (0x1)	- Заявка активна, иначе не активна
			-- бит 1 (0x2)	- Заявка снята. Если не установлен и значение бита 0 равно 0, то заявка исполнена
			if not bit.test(flags,0) and not bit.test(flags,1) then
				local commentSplit = _QuikUtilitySplit(comment,"/");
				local open_price = commentSplit[3];
				
				-- бит 2 (0x4)	-	Заявка на продажу, иначе – на покупку
				if bit.test(flags,2) then
					-- Если продажа
					if tonumber(_QuikGetParamExByIndex(sec_code,'LAST')) > tonumber(open_price) then
						_QuikUtilityRegAlert(order_num, sec_code..": S Сработал ордер тейк-профит");
					else
						_QuikUtilityRegAlert(order_num, sec_code..": S Сработал ордер стоп-лосс");
					end;
				else
					-- Если покупка
					if tonumber(_QuikGetParamExByIndex(sec_code,'LAST')) < tonumber(open_price) then
						_QuikUtilityRegAlert(order_num, sec_code..": B Сработал ордер тейк-профит");
					else
						_QuikUtilityRegAlert(order_num, sec_code..": B Сработал ордер стоп-лосс");
					end;
				end;
			end;
		
			-- Ордер отменен!
			-- message("Ya OnStopOrder() else!");
			-- TRANS_LIST[tonumber(trans_id)] = ""; -- сброс
		
		end;
		
	end;
	
	-- https://quikluacsharp.ru/stati-uchastnikov/postanovka-i-snyatie-stop-ordera-v-qlua-lua/
	-- local string state="_" -- состояние заявки
	--бит 0 (0x1) Заявка активна, иначе не активна
	-- if bit.band(stopOrder.flags,0x1)==0x1 then
	-- state="стоп-заявка создана"
	-- if EntryOrExit(stopOrder.trans_id) == "Entry" then
	-- g_stopOrderEntry_num = stopOrder.order_num 
	-- end
	-- if EntryOrExit(stopOrder.trans_id) == "Exit" then
	-- g_stopOrderExit_num = stopOrder.order_num
	-- end 
	-- end
	-- if bit.band(stopOrder.flags,0x2)==0x1 or stopOrder.flags==26 then
	-- state="стоп-заявка снята"
	-- end
	-- if bit.band(stopOrder.flags,0x2)==0x0 and bit.band(stopOrder.flags,0x1)==0x0 then
	-- state="стоп-ордер исполнен"
	-- end
	-- if bit.band(stopOrder.flags,0x400)==0x1 then
	-- state="стоп-заявка сработала, но была отвергнута торговой системой"
	-- end
	-- if bit.band(stopOrder.flags,0x800)==0x1 then
	-- state="стоп-заявка сработала, но не прошла контроль лимитов"
	-- end
	-- if state=="_" then
	-- state="Набор битовых флагов="..tostring(stopOrder.flags)
	-- end
	-- myLog("OnStopOrder(): sec_code="..stopOrder.sec_code.."; "..EntryOrExit(stopOrder.trans_id)..";\t"..state..
	-- "; condition_price="..stopOrder.condition_price.."; transID="..stopOrder.trans_id.."; order_num="..stopOrder.order_num ) 
	
end;