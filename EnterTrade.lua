------------------------------------------------------------------------------
-- �������� ������ Enter Trade ��� ��������� Quik (��� �������� ����� FORTS)
-- � �������� �������� �����, � �������������� ������������ StopLoss&TakeProfit
-- ���� ���������� 2020

-- ����� ��������� � ��������� ��������������:
-- http://iv-litovchenko.ru/quik-enter-trade
-- https://vk.com/quik.enter.trade
-- Email: iv-litovchenko@mail.ru

-- ��������� (� �������� ������������� � Quik7, Windows 7,8):
-- 1. ��� ������������ ������ ���������� ������� � �������� � ����� Quik ���������� "w32.dll": https://quik2dde.ru/viewtopic.php?id=78
-- 2. ��� �������������� ���������� ������������� ���������� ������ �� ����-�����
-- 3. ����� ���������� ������ ��� ���������� ������ ���������� ���������� � �����, ��� ���������� Quik ("C:\QUIK-...\LuaIndicators\")
-- 4. � ����� "EnterTrade.Settings.All.lua" ���������� ���������� ��� "�������� ����" � "��� �������"
-- 5. � ����� "EnterTrade.Settings.All.lua" � ���������� "FILE_SETTINGS_LIST_TICKETS" ���������� ����������� ������ ��������� ������� 
-- 6. ��������� ������������ ����� ��� ����� ("C:\QUIK-...\LuaIndicators\EnterTradeLog"), ���� ��� ���� ������� �� �����-���� �������
-- 7. ����� ������������������, ���������� ��������� ��� ������ "������� > Lua-�������... > ��������" 
-- 8. �����: ���� �������� ������ ������ �� ������������� ��������� ����� "������.report.csv" � "������.report.full.csv"
-- 9. �����: 
		-- �� ��������� ��� ������� ������� � ����� "Settings.Callback.Alert.lua" �������� ������ ���������� �� ������ ����������� ���� � ���������� SAR, �� ���������� ��������
		-- �� ��������� ��� ������� ������� � ����� "EnterTrade.Settings.Callback.Robot.lua" � �������� ������� ������� 4 �������� ��������� (������), �� ���������� ��������
-- 10. �����: ��������� ��� �� �������� ��� ���������� ��������� ������� (������ ����� ����������� ����� ����������� Quik � ������� ������� ��� 1 ����������)!
------------------------------------------------------------------------------

-- OnFuturesClientHolding 	-- (������� �� ���������� ������ (��������)) ������� ���������� ���������� QUIK ��� ��������� ������� �� �������� ����� (������� �� ���������� ������ (��������)).		
-- OnTransReply				-- (������� ����������) ������� ���������� ���������� QUIK ��� ��������� ������ �� ���������� ������������.
-- OnOrder					-- (������� ������) ������� ���������� ���������� QUIK ��� ��������� ����� ������ ��� ��� ��������� ���������� ������������ ������.
-- OnTrade					-- (������� ������) ������� ���������� ���������� QUIK ��� ��������� ������.
-- OnStopOrder				-- (������� ����-������) ������� ���������� ���������� QUIK ��� ��������� ����� ����-������ ��� ��� ��������� ���������� ������������ ����-������ .
-- OnParam					-- ������� ���������� ���������� QUIK ��� ��������� ������� ����������.
-- https://sourceforge.net/projects/qllib/files/ (�����. ����������)

-- TODO (START)
	
	-- and (string.sub(getItem("securities",i).code, 1,2)) == "Si" then -- �������� Si

	-- ��������� ���������� ��� ������...
	-- Music �� | CLOSE
	
	-- BUY �� �������� ������ SELL �� �������� ������
	-- ����-�������� (��������� ����� ��������)
	-- ����-�������� (� ������� ��������� ������ - ������. ���-�� �����)
	-- ����-�������� (������� ������� ����� � ����������� �� �����. �����������, �� ���. ���. ����, ���������. ���� ������ ���� ������ ����. �����. ����)
	-- ����-�������� (����� � ���. ����� ��������)
	-- ����-�������� (����. ����� ��������� ������)
	-- ����-�������� (����� ���������������� �������� � ����� > 50% - �� ���� �������)
	-- ����-�������� (����� �������)
	-- ����-�������� (��������� ������)
	-- ����-�������� (������� ������)
	
-- TODO (END)

-- ���������
-- debug = nil;
w32 = require("w32");
dofile(getScriptPath().."\\EnterTradeSettings\\Settings.All.lua"); -- ���� ��������
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikGet.lua");
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikTable.lua");
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikSendTransaction.lua");
dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikUtility.lua");
-- dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikRMSysA.lua");
-- dofile(getScriptPath().."\\EnterTradeLib\\Func._QuikRMSysB.lua");

-- ���������� ��� ��������� �����
TRANS_CLASS_CODE_FUT			= "SPBFUT"; -- ����� ���������
TRANS_TRADE_ACC					= FILE_SETTINGS_TRADE_ACC; -- �������� ����
TRANS_CLIENT_CODE				= FILE_SETTINGS_CLIENT_CODE; -- ��� �������
TRANS_SECCODE					= ""; -- ��� �������� ��� ��������	-- VBM0/SRM0/RIM0
TRANS_SECNAME					= ""; -- �������� �������� -- VTBR-6.20/SBRF-6.20|RTS-6.20

-- ���������� �������
IsRun = true; -- ���� ����������� ������ �������
ScriptVersion 					= "1.3"; 
CheckLastNumOnTrade				= 0;
CheckLastNumOnOrderAct			= 0;
CheckLastNumOnOrderNotAct		= 0;
CheckLastNumOnStopOrder			= 0;
RegAlert 						= {}; -- �������
RegLabel 						= {}; -- �������, ����� �� �������
RegAlertCounter 				= 1; -- ������� (�������)
RegLabelCounter 				= 1; -- �������, ����� �� ������� (�������)

-- ���������� ��� ���������� �������� �������������� ������� "<" � ">"
RM_COLOR						= 255; -- �������� ����-���������
VAL_HIDE_RUB_TIMER				= 11000;
VAL_TIKET 						= 1; -- ������� ����� (��������)
VAL_Q 							= 0; -- ������� ����� (��������)
VAL_SL 							= 60; -- ������� SL (��������)
VAL_SL_K_TP 					= 3; -- ����������� ����� � �����
VAL_PATTERN 					= 1; -- �������
VAL_CLOSE_TYPE_NUM				= 5; -- ������� ������� ��������
VAL_CLOSE_TYPE = {
	{"CallbackCellButtonClosePart25",	"   -=CLOSE 25%=-	",	25},
	{"CallbackCellButtonClosePart33",	"   -=CLOSE 33%=-	",	33},
	{"CallbackCellButtonClosePart50",	"   -=CLOSE 50%=-	",	50},
	{"CallbackCellButtonClosePart80",	"   -=CLOSE 80%=-	",	80},
	{"CallbackCellButtonCloseAll",		"   -=CLOSE ALL=-	",	100}
};

-- ��������� ������������
TRANS_LIST 						= {}; -- ���������� ��������� � ����������� ID-���������
TRANS_LIST_SORT 				= {}; -- ���������� ��������� ���� ������������ �������������������
TRANS_LIST_COUNT_NUMBER			= 1; -- ���������� ���������� �������

FLAG_OnFuturesClientHolding 	= 0;
FLAG_COUNTER_GET_UP				= 0; -- ���� ���������� ���������� �������� - ������� ����� (�.�. ��� �� PHP, � ��� �� ������ ����)
FLAG_COUNTER_GET_UP_TODAY		= 0; -- ���� ���������� ���������� �������� - ������� ������� (�.�. ��� �� PHP, � ��� �� ������ ����)
FLAG_DISABLE_BUTTON				= 0; -- ���� ���������� ������
LIST_NUMBER_BUTTON				= {}; -- ������ �������� � ������� ��������� ������

-- TODO (� ����������)
-- LINE_STOP_ORDERS				= {{}}; -- ������� ����������� ����-�������
-- LINE_STOP_ORDERS_COUNTER		= 1; -- ������� ������� (�����)
-- LINE_STOP_ORDERS_COUNTER_ALL	= 1; -- ������� ������� (�����)

ADDED_ROW						= {}; -- ����������� ������ (������)
COUNTER_CELL 					= 1; -- ����������� ������
CALLBACK_CELL 					= {}; -- �������� ������ ��� ������� �������
FILE_SETTINGS_LIST_RM_KEY 		= {}; -- ����� ����-���������

function OnInit()

	message("Enter Trade "..ScriptVersion.." Start, QUIK "..getInfoParam('VERSION')..".");
	
	-- ��������� ��������� �� �����?
	-- ���� ���������� �� ���������, ������ �������� "RIM5"
	--if tonumber(_QuikGetParamExByIndex(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1], "STATUS")) == 0 then 
	--	message("����� "..FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1].." �� ���������! ���������� �������������� ���� �������� � ����� ��������� FILE_SETTINGS_LIST_TICKETS{}", 3);
	--	IsRun = false;
	
	--else
		-- ������������� �������� �����������
		TRANS_SECCODE = _QuikGetNameByListTickets(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1],FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][3]);
		TRANS_SECNAME = _QuikGetShortNameByIndex(TRANS_SECCODE);
		VAL_SL = _QuikUtilityStrRound2(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][2]);
		
		-- �������� ������ ����-����������
		for i = 1, #FILE_SETTINGS_LIST_RM do
			FILE_SETTINGS_LIST_RM_KEY[FILE_SETTINGS_LIST_RM[i][1]] = i; -- ��������� ���� ��� ������� ��������
			dofile(getScriptPath().."\\EnterTradeLib\\Func."..FILE_SETTINGS_LIST_RM[i][1]..".lua");
		end;
		
		_QuikUtilitySoundFileStop(); -- ������������� ������������ ������ (���� ����)
		CreateTable(); -- ������� �������
	--end;
	
end;             
 
function main()
	-- ���� ����� ����������, ���� IsRun == true
	while IsRun do
		
		-- ���������� ������� ����-�������
		-- TODO: �������� � ���������� �������!
		-- if #LINE_STOP_ORDERS[LINE_STOP_ORDERS_COUNTER] > 0 then
			-- local stop_order_type = LINE_STOP_ORDERS[LINE_STOP_ORDERS_COUNTER][1];
			
			-- ���� ������ �������� �������� ���-�� �������
			-- if stop_order_type == "NEW_STOP_ORDER" then
				-- NEW_STOP_ORDER(sec_code, "S", price, qty, "LC/Ord", trade_num, trade_sl, trade_sl_k_tp);
				-- NEW_STOP_ORDER(sec_code, "B", price, qty, "SC/Ord", trade_num, trade_sl, trade_sl_k_tp);
				
			-- ���� ������ ������ ��������� ���-�� �������
			-- elseif stop_order_type == "KILL_STOP_ORDERS" then
			-- end;
		-- end;
		-- LINE_STOP_ORDERS_COUNTER = LINE_STOP_ORDERS_COUNTER+1;
		-- LINE_STOP_ORDERS[LINE_STOP_ORDERS_COUNTER] = {"NEW_STOP_ORDER",sec_code,"S",price,qty,"LC/Ord",trade_num,trade_sl,trade_sl_k_tp}; --
		-- LINE_STOP_ORDERS[tonumber(LINE_STOP_ORDERS_COUNTER)]["2"]="NEW_STOP_ORDER"; -- ,2=10,3=18000};
		
		UpdateTable(); -- ��������� �������
		
		-- ������������ ��������
		if isConnected() == 1 then
		
			-- Alert
			local callResult, result = pcall(dofile, getScriptPath().."\\EnterTradeSettings\\Settings.Callback.Alert.lua")
			if callResult then
				-- ��� � �������, result ��� ��, ��� ������� ������� dofile
			else
				-- result ��� ��������� �� ������
				message(tostring(result));
				sleep(5000);
			end;
			
			-- Robot
			local callResult, result = pcall(dofile, getScriptPath().."\\EnterTradeSettings\\Settings.Callback.Robot.lua")
			if callResult then
				-- ��� � �������, result ��� ��, ��� ������� ������� dofile
			else
				-- result ��� ��������� �� ������
				message(tostring(result));
				sleep(5000);
			end;
			
		end;
		
		-- ��� ����������
		if isConnected() == 0 then
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
		end;
		
		-- ������: ���� ��������� ���������� ��������
		-- if FLAG_OnFuturesClientHolding == 1 then
		if FLAG_COUNTER_GET_UP == 1 then
			_QuikUtilityLogCounterGetUp("order"); -- _QuikUtilityLogCounterGetUp("order"); -- ����������� ����� ������
			FLAG_COUNTER_GET_UP = 0;
		end;
		-- end;
		
		-- ������: ���� ��������� ���������� ��������
		-- if FLAG_OnFuturesClientHolding == 1 then
		if FLAG_COUNTER_GET_UP_TODAY == 1 then
			_QuikUtilityLogCounterGetUp("order-today."..os.date("%d-%m-%Y", os.time())); -- _QuikUtilityLogCounterGetUp("order"); -- ����������� ����� ������
			FLAG_COUNTER_GET_UP_TODAY = 0;
		end;
		-- end;
		
		-- if isConnected() == 1 then
			-- UpdateOrders(TRANS_SECCODE); -- ��������� ������
		-- end;
		
		if IsWindowClosed(t_id) then --��������� ������, ����� ���� �������
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
	FLAG_DISABLE_BUTTON = 1; -- ��������� ������
	SetCellButtonDisabled();
end;

function OnConnected()
	_QuikUtilityLogWrite("report", "System", {"","","OnConnected"});
	FLAG_DISABLE_BUTTON = 0; -- �������. ������
	SetCellButtonEnabled();
end;
 
-- ������� ������� �������
function CreateTable()
   
	-- �������� ��������� id ��� ��������
	t_id = AllocTable(); 
	
	-- ������� �������
	AddColumn(t_id, 0, "", true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id, 1, "", true, QTABLE_STRING_TYPE, 20);
	AddColumn(t_id, 2, "", true, QTABLE_STRING_TYPE, 5);
	AddColumn(t_id, 3, "", true, QTABLE_STRING_TYPE, 100);

	t = CreateWindow(t_id);-- ������� �������
	SetWindowCaption(t_id, "Enter trade "..ScriptVersion.." (Quik 7,Quik 8)"); -- ������������� ���������	
	SetWindowPos(t_id, 100, 100, 252, 532); -- ������ ��������� � ������� ���� �������
	
	-- ��������� ������� t_id ������� ��������� ������� "CallbackTable"
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

-- ������� ��������� �������
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

	-- ���� ���������� �� ���������, ������ �������� "RIM5"
	if tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "STATUS")) == 1 then 
		-- Clear(t_id); -- ������� �������!
	end;
	
	COUNTER_CELL = 1; -- ���������� �������
	SetCellInfo(); -- ������� (��������)
	SetCellCode(VAL_TIKET, TRANS_SECCODE, TRANS_SECNAME); -- ��� ����������� (��������)
	SetCellPattern(); -- ������� (��������)
	SetCellTp(VAL_SL,VAL_SL_K_TP); -- ����-������ (��������)
	SetCellSl(VAL_SL, PipsPercentSl); -- ����-���� (��������)
	SetCellQ(VAL_Q); -- ���-�� (��������)
	SetCellCalc(); -- ����������� (�������)
	
	-- ���� ���������� �� ���������, ������ �������� "RIM5"
	-- if tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "STATUS")) == 1 then 
	
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellButtonBuy();
		-- SetCellButtonOverturn();
		SetCellButtonSell();
		SetCellTotalnet(_QuikGetTotalnetByIndex(TRANS_SECCODE));
		SetCellTotalnetOrders(_QuikGetTotalnetStopOrdersByIndex(TRANS_SECCODE,0)); -- ����� ����-������ (� ����������) -- todo
		SetCellMargin(_QuikUtilityStrRound2(_QuikGetPercentMarginByIndex(TRANS_SECCODE),2));
		SetCellButtonClosePart(1,25); -- ������ ������� 25% (��������)
		SetCellButtonClosePart(2,33); -- ������ ������� 33% (��������)
		SetCellButtonClosePart(3,50); -- ������ ������� 50% (��������)
		SetCellButtonClosePart(4,80); -- ������ ������� 80% (��������)
		SetCellButtonCloseAll();
		-- SetCellButtonClose();
		
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellBlockSettings(); 
		SetCellButtonCloseAuto(); 
		SetCellButtonSlZero(); -- ������� � ��
		SetCellButtonSlT(); -- �������� ����-����
		
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellBlockRiskManagement(); -- ���� ������� (��������)
		
			-- �������� ������ ����-����������
			for i = 1, #FILE_SETTINGS_LIST_RM do
				local class 		= FILE_SETTINGS_LIST_RM[i][1];
				local var_name 		= _G[FILE_SETTINGS_LIST_RM[i][1]].name;
				local var_cell_name = _G[FILE_SETTINGS_LIST_RM[i][1]].cell_name;
				local var_cell_help = _G[FILE_SETTINGS_LIST_RM[i][1]].cell_help;
				local var_cell_eval = _G[FILE_SETTINGS_LIST_RM[i][1]].cell_eval;
				
				-- local lua_eval_str = var_cell_eval; -- class..":check()"; -- "math.pow(3,2)"
				-- local lua_eval_res = assert(loadstring("return " .. lua_eval_str))(); -- pcall
				
				SetCellBlockRiskManagementElement(var_name, var_cell_name, var_cell_help, var_cell_eval);
				-- message("��������� ������ �������: "..tostring(lua_eval_res));
				-- sleep(1000);
			end;
			
		COUNTER_CELL = COUNTER_CELL + 1;
		SetCellBlockVersion(); -- ���� ������ (�������)
		
	-- end;
	
	COUNTER_CELL = COUNTER_CELL + 1;
	SetCellBlockDepo(); -- ���� ������� (��������)
	SetCellJournal(); -- ������ ������ (�������)
	
	-- ��������� ������
	for i = 1,COUNTER_CELL do
		if ADDED_ROW[i] == nil then
			InsertRow(t_id, i);
			ADDED_ROW[i] = 1;
		end;
	end;
	
end;

-----------------------------------------------------
-- ������� �������� ������� QUIK
-----------------------------------------------------

-- (������� ����������). ������� ���������� ����������, ����� � ������� �������� ����� ���������� � �����������
function OnTransReply(trans_reply)
	local order_num		= trans_reply.order_num;
	local trans_id 		= trans_reply.trans_id;
	local status 		= trans_reply.status;
	local sec_code		= trans_reply.sec_code;
	local class_code	= trans_reply.class_code;
	local result_msg	= trans_reply.result_msg;
	local comment		= trans_reply.brokerref;
	
	-- ���������� �� ����������
	-- if TRANS_LIST[tonumber(trans_id)] == "ZAREGISTRIROVANO" then
	
		-- ������� ������ 2 �������� �������������� (0 - ���������� ���������� �������, 1 - ���������� �������� �� ������ QUIK �� �������),
		-- ��� ��������� ������ ������� ������ ������ �� �����, � ����� ��������� ��������� �������
		-- ������� �� �������		
		if status < 2 then 
			
		-- ���������� ���������
		elseif status == 3 then 
			
			-- message('OnTransReply(): �� ���������� �'..trans_id..' ������� ���������� ������ �'..trans_reply.order_num..' �� ���� '..trans_reply.price..' ������� '..trans_reply.quantity) 
			-- TRANS_LIST[tonumber(trans_id)] = 3; -- ���������� ���������� (��������� � "OnOrder" � "OnStopOrder")
	
		-- ��������� ������
		elseif status > 3 then 
			
			-- todo: �� ���� ����� ����� �������� ��������� ����������...
			_QuikUtilityLogWrite("report", "System", {"#"..order_num.."("..trans_id..")", (sec_code or ""), "Error.OnTransReply()", result_msg});
			message('OnTransReply(): ������ ����������� ������ �� ���������� �'..order_num.."("..trans_id..'), ����� ������: '..result_msg);
			TRANS_LIST[tonumber(trans_id)] = ""; -- ���������� � ������� (��������� ��������� ��������!)
		
			-- ������������ ������
			FLAG_DISABLE_BUTTON = 0; -- ������������ ������
			SetCellButtonEnabled();
			
		end;
		
	-- end;
	
	-- message("OnTransReply()");
	
end;


-- (��������� ������� ����� �������). 
-- ������� ���������� ���������� QUIK ��� ��������� ������� �� �������� �����.
-- �����
-- OnFuturesClientHolding
-- function ()
-- 	// ������� ����� ��������
-- 	// ������� ���� = 1
-- 	-- local sec_code = fut_pos.sec_code
-- 	-- local totalnet = tonumber(fut_pos.totalnet);
-- 	if FLAG_COUNTER_GET_UP == 1 and totalnet ~= nil then
-- 		FLAG_XXX = 1;
-- 	end;
-- end;

-- (������� �� ���������� ������ (��������)). 
-- ������� ���������� ���������� QUIK ��� ��������� ������� �� �������� �����.
function OnFuturesClientHolding(fut_pos)
	-- message("�������� ������� ������� "..tostring(fut_pos.startbuy));-- NUMBER    
	-- message("�������� �������� ������� "..tostring(fut_pos.startsell));-- NUMBER    
	-- message("�������� ������ ������� "..tostring(fut_pos.startnet));-- NUMBER    
	-- message("������� ������� ������� "..tostring(fut_pos.todaybuy));-- NUMBER    
	-- message("������� �������� ������� "..tostring(fut_pos.todaysell));-- NUMBER    
	-- message("������� ������ ������� "..tostring(fut_pos.totalnet));-- NUMBER
	-- local sec_code = fut_pos.sec_code;
	-- local totalnet = tonumber(fut_pos.totalnet);
	-- if FLAG_COUNTER_GET_UP == 1 then --  and totalnet ~= nil
	-- 	FLAG_OnFuturesClientHolding = 1;
	-- end;
end;

--	������� ���������� ���������� QUIK ��� ��������� ������� ����������.
function OnParam(class, seccode)
	-- 
end;

-- (������� ������) ������� ���������� ���������� QUIK ��� ��������� ����� ������ ��� ��� ��������� ���������� ������������ ������.
function OnOrder(order)

	local sec_code 			= order.sec_code;	
	local order_num 		= order.order_num;
	local trans_id 			= order.trans_id;
	local flags 			= order.flags;
	local comment 			= order.brokerref;
	local balance			= order.balance;	
	
	-- ���������� �� ����������
	if TRANS_LIST[tonumber(trans_id)] == "ZAREGISTRIROVANO.NEW_ORDER" then
	
		if CheckLastNumOnOrderAct ~= trans_id then
			CheckLastNumOnOrderAct = trans_id;  -- �������� ����� ����������
			_QuikUtilityLogWrite("report", "System", {"-", sec_code, "Depo", "", "", "", _QuikUtilityStrRound2(_QuikGetRubPrevDepo()), _QuikUtilityStrRound2(_QuikGetRubDepo())});
		end;
		
		if not bit.test(flags,0) then -- ��� 0 (0x1) - ������ �������, ����� �� �������
			
			-- ����������� ������� (���� ���� �� ���� ����� ������ ����������)
			-- _QuikUtilityLogCounterGetUp("order"); -- ����������� ����� ������
				
			-- ������� OnTrade() ����� ���������� ��������� ���...
			-- if balance == 0 then -- �������
			if CheckLastNumOnOrderNotAct ~= trans_id then
				CheckLastNumOnOrderNotAct = trans_id;  -- �������� ����� ����������
				
				-- ���� ��������� �������� ������� (����)
				-- ���� ��������� �������� ������� (����)
				if comment:find("LO/") or comment:find("SO/") then
					FLAG_COUNTER_GET_UP_TODAY = FLAG_COUNTER_GET_UP_TODAY + 1; -- ��������� ��������� �������
				end;
					
				FLAG_COUNTER_GET_UP = FLAG_COUNTER_GET_UP + 1; -- ��������� ��������� �������
				FLAG_DISABLE_BUTTON = 0; -- ����������������
				SetCellButtonEnabled();
				
				-- ������ ��������� ����������!
				-- message("Ya OnOrder()!");
				TRANS_LIST[tonumber(trans_id)] = "ISPOLNENO.NEW_ORDER"; -- ���������� ���������� 
				
				-- message("!!!");
					
			-- end;
			end;
			
	-- ����� ���������� �������
	-- � ������� ���� ������� ������
	else
		
		-- ����� �������!
		-- message("Ya OnStopOrder() else!");
		-- TRANS_LIST[tonumber(trans_id)] = ""; -- �����
			
	end;
	end;

end;
	
-- (������� ������). ������� ���������� ���������� QUIK ��� ��������� ������
function OnTrade(trade)
	
	local trade_num 		= string.format("%f",trade.trade_num);
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
	
	-- ������� OnTrade() ����� ���������� ��������� ���...
	if CheckLastNumOnTrade ~= trans_id then
	CheckLastNumOnTrade = trans_id;  -- �������� ����� ����������
	
		
		-- ���� ��������� �������� ������� (����/����)
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
			
			-- ���������� ���
			_QuikUtilityLogWrite("report", "Trade", {"#"..trans_id, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1), _QuikUtilityStrRound2(_QuikGetRubPrevDepo()), _QuikUtilityStrRound2(_QuikGetRubDepo())});
			
			-- ���������� �����
			-- LINE_STOP_ORDERS				= {}; -- ������� ����������� ����-�������
			-- LINE_STOP_ORDERS_COUNTER		= LINE_STOP_ORDERS_COUNTER+1;
			for i = 1, qty do
				-- NEW_STOP_ORDER(sec_code, "S", price, qty, "LC/Ord", trans_id, trade_sl, trade_sl_k_tp);
				-- trans_id - �������� ������ 3 �������
				_QuikUtilityLogWrite("report", "System", {"#"..agr_id..math.ceil(os.date("%S%M%H%d")/100)..i, sec_code, "NewStopOrder (1)"}); -- , arg_2, trade_sl, trade_sl_k_tp
				NEW_STOP_ORDER(sec_code, arg_3, price, 1, arg_4, agr_id..math.ceil(os.date("%S%M%H%d")/100)..i, trade_sl, trade_sl_k_tp);
			end;
			
		end;
		
		-- ���� ��������� �������� ������� � ������ "�����"
		if comment:find("LC/Part-") or comment:find("SC/Part-") then
			
			if comment:find("LC/Part-") then
				arg_1 = "-";
			else
				arg_1 = "+";
			end;
			
			-- ������� ����� (������������ ���-��)
			_QuikUtilityLogWrite("report", "Trade", {"#"..trans_id, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1)});
			_QuikUtilityLogWrite("report", "System", {"-", sec_code, "KillStopOrders ("..qty..")"});
			KILL_STOP_ORDERS_BY_COUNT(sec_code, qty);
			
		end;
		
		-- ���� ��������� �������� ������� � ������ "������� ���"
		if comment:find("LC/All") or comment:find("SC/All") then
		
			if comment:find("LC/All") then
				arg_1 = "-";
			else
				arg_1 = "+";
			end;
			
			-- ������� ����� (������������ ���-��)
			-- KILL_ALL_STOP_ORDERS(sec_code);
			_QuikUtilityLogWrite("report", "Trade", {"#"..trans_id, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1)});
			_QuikUtilityLogWrite("report", "System", {"-", sec_code, "KillStopOrders ("..qty..")"});
			KILL_STOP_ORDERS_BY_COUNT(sec_code, qty);
			
		end;
		
		-- ���� ��������� �������� ������� �� ������
		if comment:find("LC/Ord") or trade.brokerref:find("SC/Ord") then
			if comment:find("LC/Ord") then
				arg_1 = "-";
			else
				arg_1 = "+";
			end;
			_QuikUtilityLogWrite("report", "Trade", {"#"..trans_id, sec_code, comment, price, tostring(arg_1)..qty, _QuikGetRubPricePointsByIndex(sec_code,1)});
		end;
		
	end;
	
end;

-- (������� ����-������) ������� ���������� ���������� QUIK ��� ��������� ����� ����-������ ��� ��� ��������� ���������� ������������ ����-������ .
function OnStopOrder(stop_order)

	local order_num 		= stop_order.order_num;
	local trans_id 			= stop_order.trans_id;
	local flags 			= stop_order.flags;
	local stop_order_type 	= stop_order.stop_order_type;
	local comment 			= stop_order.brokerref;
	local sec_code 			= stop_order.sec_code;
	
	-- ������� OnTrade() ����� ���������� ��������� ���...
	-- if CheckLastNumOnStopOrder < order_num then
	-- CheckLastNumOnStopOrder = order_num;  -- �������� ����� ����������
	-- end;
	
	-- ���� "9" -- ����-������ � ����-�����  
	if stop_order_type == 9 then
		
		-- ��������� ������!	
		if TRANS_LIST[tonumber(trans_id)] == "ZAREGISTRIROVANO.NEW_STOP_ORDER" then
				
			-- ����� ����������!
			-- if bit.test(flags,0) then -- ��� 0 (0x1) - ������ �������, ����� �� �������
				-- message("Ya OnStopOrder() new!");
				_QuikUtilityLogWrite("report", "System", {"#"..order_num, sec_code, "NewStopOrderSuccessful (1)"});
				TRANS_LIST[tonumber(trans_id)] = "ISPOLNENO.NEW_STOP_ORDER"; -- ���������� ���������� 
				
			-- end;
		
		-- ������ ������!
		elseif TRANS_LIST[tonumber(order_num)] == "ZAREGISTRIROVANO.KILL_STOP_ORDER" then
		
			-- ����� �������!
			-- if not bit.test(flags,0) then -- ��� 0 (0x1) - ������ �������, ����� �� �������
		
				-- ����� �������!;
				-- message("Ya OnStopOrder() kill! "..order_num);
				_QuikUtilityLogWrite("report", "System", {"#"..order_num, sec_code, "KillStopOrderSuccessful (1)"});
				TRANS_LIST[tonumber(order_num)] = "ISPOLNENO.KILL_STOP_ORDER"; -- ���������� ���������� 
			
			-- end;
		
		-- ����� ���������� �������
		-- � ������� ���� ������� ������
		else
			
			-- ����-����� ��������
			-- ��� 0 (0x1)	- ������ �������, ����� �� �������
			-- ��� 1 (0x2)	- ������ �����. ���� �� ���������� � �������� ���� 0 ����� 0, �� ������ ���������
			if not bit.test(flags,0) and not bit.test(flags,1) then
				local commentSplit = _QuikUtilitySplit(comment,"/");
				local open_price = commentSplit[3];
				
				-- ��� 2 (0x4)	-	������ �� �������, ����� � �� �������
				if bit.test(flags,2) then
					-- ���� �������
					if tonumber(_QuikGetParamExByIndex(sec_code,'LAST')) > tonumber(open_price) then
						_QuikUtilityRegAlert(order_num, sec_code..": S �������� ����� ����-������");
					else
						_QuikUtilityRegAlert(order_num, sec_code..": S �������� ����� ����-����");
					end;
				else
					-- ���� �������
					if tonumber(_QuikGetParamExByIndex(sec_code,'LAST')) < tonumber(open_price) then
						_QuikUtilityRegAlert(order_num, sec_code..": B �������� ����� ����-������");
					else
						_QuikUtilityRegAlert(order_num, sec_code..": B �������� ����� ����-����");
					end;
				end;
			end;
		
			-- ����� �������!
			-- message("Ya OnStopOrder() else!");
			-- TRANS_LIST[tonumber(trans_id)] = ""; -- �����
		
		end;
		
	end;
	
	-- https://quikluacsharp.ru/stati-uchastnikov/postanovka-i-snyatie-stop-ordera-v-qlua-lua/
	-- local string state="_" -- ��������� ������
	--��� 0 (0x1) ������ �������, ����� �� �������
	-- if bit.band(stopOrder.flags,0x1)==0x1 then
	-- state="����-������ �������"
	-- if EntryOrExit(stopOrder.trans_id) == "Entry" then
	-- g_stopOrderEntry_num = stopOrder.order_num 
	-- end
	-- if EntryOrExit(stopOrder.trans_id) == "Exit" then
	-- g_stopOrderExit_num = stopOrder.order_num
	-- end 
	-- end
	-- if bit.band(stopOrder.flags,0x2)==0x1 or stopOrder.flags==26 then
	-- state="����-������ �����"
	-- end
	-- if bit.band(stopOrder.flags,0x2)==0x0 and bit.band(stopOrder.flags,0x1)==0x0 then
	-- state="����-����� ��������"
	-- end
	-- if bit.band(stopOrder.flags,0x400)==0x1 then
	-- state="����-������ ���������, �� ���� ���������� �������� ��������"
	-- end
	-- if bit.band(stopOrder.flags,0x800)==0x1 then
	-- state="����-������ ���������, �� �� ������ �������� �������"
	-- end
	-- if state=="_" then
	-- state="����� ������� ������="..tostring(stopOrder.flags)
	-- end
	-- myLog("OnStopOrder(): sec_code="..stopOrder.sec_code.."; "..EntryOrExit(stopOrder.trans_id)..";\t"..state..
	-- "; condition_price="..stopOrder.condition_price.."; transID="..stopOrder.trans_id.."; order_num="..stopOrder.order_num ) 
	
end;