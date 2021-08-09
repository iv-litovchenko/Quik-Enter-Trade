-----------------------------------------------------
-- ������� ����������� ����������
-----------------------------------------------------

-- ������� �������� ������� �������
function _QuikSendTransactionOpenLongByIndex(code, q, stop, stop_k_take, pattern)
	-- �� ���������!
	-- ������ �������!
	if tonumber(_QuikGetParamExByIndex(code, "STATUS")) == 0 or 
		 tonumber(_QuikGetParamExByIndex(code, "TRADINGSTATUS")) == 0 then
		return 0;
	end;
	
	if FLAG_DISABLE_BUTTON == 1 then
		return 0;
	end;
	if _QuikGetTotalnetByIndex(code)<0 then
		message("����� ��� ���� ����������� �������� ������� (����)!", 3);
		return 0;
	elseif q <= 0 then
		message("���������� � ������ ������ ���� ������������!", 3);
		return 0;
	else
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonBuy", price, "+"..q});
		
		local id = NEW_ORDER(code, "B", price, q, "LO", "200".._QuikUtilityLogCounterGet("order")+1, stop, stop_k_take, pattern);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- �������. ������
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
			return 0;
		end;
	end;
end;

-- ������� ����������
function _QuikSendTransactionOverturnByIndex(code, stop, stop_k_take)
	-- todo
	message("TODO");
end;

-- ������� �������� �������� �������
function _QuikSendTransactionOpenShortByIndex(code, q, stop, stop_k_take, pattern)
	-- �� ���������!
	-- ������ �������!
	if tonumber(_QuikGetParamExByIndex(code, "STATUS")) == 0 or 
		 tonumber(_QuikGetParamExByIndex(code, "TRADINGSTATUS")) == 0 then
		return 0;
	end;
	
	if FLAG_DISABLE_BUTTON == 1 then
		return 0;
	end;
	if _QuikGetTotalnetByIndex(code)>0 then
		message("����� ��� ���� ����������� �������� ����� (����)!", 3);
		return 0;
	elseif q <= 0 then
		message("���������� � ������ ������ ���� ������������!", 3);
		return 0;
	else
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonSell", price, "-"..q});
		
		local id = NEW_ORDER(code, "S", price, q, "SO", "300".._QuikUtilityLogCounterGet("order")+1, stop, stop_k_take, pattern);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- �������. ������
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
			return 0;
		end;
	end;
end;

-- ������� �������� ����� ������� (� %)
function _QuikSendTransactionClosePartByIndex(code, qPart)
	-- �� ���������!
	-- ������ �������!
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
			FLAG_DISABLE_BUTTON = 0; -- �������. ������
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
			return 0;
		end;
	elseif _QuikGetTotalnetByIndex(code) < 0 then
		local price = _QuikGetParamExByIndex(code,'LAST');
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonClosePart ("..qPart.."%)", price, "+"..resQ});
		
		local id = NEW_ORDER(code, "B", price, resQ, "SC/Part-"..qPart.."%", "301".._QuikUtilityLogCounterGet("order")+1);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- �������. ������
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
			return 0;
		end;
	else
		message("��� �������� ������� ��� ��������!", 3);
		return 0;
	end;
end;

-- ������� �������� ���� �������
function _QuikSendTransactionCloseAllByIndex(code)
	-- �� ���������!
	-- ������ �������!
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
			FLAG_DISABLE_BUTTON = 0; -- �������. ������
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
			return 0;
		end;
	elseif _QuikGetTotalnetByIndex(code) < 0 then
		local price = _QuikGetParamExByIndex(code,'LAST');
		local totalnet = _QuikGetTotalnetByIndex(code);
		_QuikUtilityLogWrite("report", "System", {"-", code, "ClickButtonCloseAll", price, "+"..totalnet});
		
		local id = NEW_ORDER(code, "B", price, math.abs(totalnet), "SC/All", "302".._QuikUtilityLogCounterGet("order")+1);
		if id == nil then
			FLAG_DISABLE_BUTTON = 0; -- �������. ������
			SetCellButtonEnabled();
			return id;
		else
			FLAG_DISABLE_BUTTON = 1; -- ��������� ������
			SetCellButtonDisabled();
			return 0;
		end;
	else
		message("��� �������� ������� ��� ��������!", 3);
		return 0;
	end;
end;

-- ������� ���������� ���������� ID
function ID_GENERATION()
	--%u ������������
	-- .. ..string.sub(os.clock(),"[.]",""
	-- message(tostring(res));
	-- message(">>>"..string.sub(tostring(os.clock()),"[.]",""));
	-- return tonumber(os.date("%d%H%M%S", os.time()));
	return os.time();
end;

-- ����������� ���������� �� �������/�������
function NEW_ORDER(code, operation, price, q, comment, id, stop, stop_k_take, pattern)   
	
	-- ���� ��� ������� ������� "OFFER" - ������ ���� �����������" ������ LAST
	-- �� ����, ���������� �� 10 ���. ����� ����
	if(tostring(operation) == "B") then
		PriceRes = price + 100 * _QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		PriceOpenPosition = price;
		symbol = "+";
	elseif(tostring(operation) == "S") then		 
		PriceRes = price - 100 * _QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		PriceOpenPosition = price;
		symbol = "-";
	end;
	
	-- ��������� ��������� ��� �������� ���������� �� ������� ���������
	-- ���������� ��������� ID ���������� �� ������� ���������
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
	
	-- ��������� ����������
	local TransactionArray = {
		["CLASSCODE"]	= TRANS_CLASS_CODE_FUT,
		["ACCOUNT"]		= TRANS_TRADE_ACC,
		["SECCODE"]		= code,
		["TRANS_ID"]	= tostring(id), -- _MyFuncRandomMax()
		["CLIENT_CODE"]	= commentJoin, -- ��� ���������� �����������
		["ACTION"]     	= "NEW_ORDER",
		["OPERATION"]  	= operation, -- �������/������� (BUY)
		["TYPE"]       	= "M", -- �� ����� (MARKET)
		["PRICE"]      	= CustomPriceFormat(PriceRes), -- �� ����, ���������� �� 10 ���. ����� ����
		["QUANTITY"]   	= tostring(q), -- ����������
		-- ["COMMENT"] 	= tostring("������� ��������� ��������");
	};
	
	-- ���� ������� ������� ������ ����������� ������, �� ������ ���������� �� ������
	return CustomSendTransaction(TransactionArray, id, "ZAREGISTRIROVANO.NEW_ORDER", "ISPOLNENO.NEW_ORDER");
	
end;

-- ����������� ���������� �� ��������� ����� (����&������)
function NEW_STOP_ORDER(code, operation, price, q, comment, id, stop, stop_k_take)	

	-- ���� ��� ������� ������� "OFFER" - ������ ���� �����������" ������ LAST
	-- �� ����, ���������� �� 10 ���. ����� ����
	-- PriceRes = _QuikGetParamExByIndex(code,'LAST');
	
	-- ��������� ��������� ��� �������� ���������� �� ������� ���������
	-- ���������� ��������� ID ���������� �� ������� ���������
	local commentJoin = "";
	commentJoin = comment; --  .. "/" .. stop .. "/" .. stop_k_take;
	
	-- ��������� ��������� ��� �������� ���������� �� ������� ���������
	--['CONDITION'] = direction, -- �������������� ����-����. ��������� ��������: �4� - ������ ��� �����, �5� � ������ ��� �����
	local TransactionArray = {
		["CLASSCODE"]			= TRANS_CLASS_CODE_FUT,
		["ACCOUNT"]				= TRANS_TRADE_ACC,
		["SECCODE"]				= code,
		["TRANS_ID"]			= tostring(id), -- _MyFuncRandomMax()
		["CLIENT_CODE"]			= commentJoin, -- ��� ���������� �����������
		["ACTION"]     			= "NEW_STOP_ORDER", -- ��� ������
		["STOP_ORDER_KIND"]     = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER", -- ��� ����-������ (SIMPLE_STOP_ORDER)
		["TYPE"]       			= "L", -- �������������� 
		["QUANTITY"]   			= tostring(q), -- ����������
		-- ["COMMENT"]    		= "����-������ � ����-���� ��������� ��������",
		["OFFSET_UNITS"]        = "PRICE_UNITS",
		["SPREAD_UNITS"]        = "PRICE_UNITS",
		["EXPIRY_DATE"]			= "GTC", -- �� ������� ����� ������ ����-������ � ���������� �������, ����� �������� �� GTC
		["OPERATION"]  			= operation, -- ������� (BUY "B" || SELL "S")
		["IS_ACTIVE_IN_TIME"]	= "NO"
	};
	
	local symbol;
	local priceTp;
	local priceSl;
	
	-- ���� ��� � "�������"
	if operation == "S" then
		-- ������ (�������, ��� �������)
		symbol = "-";
	
		-- ����-����
		-- �� ����, ���������� �� 10 ���. ����� ���� (100 - ��� ����. �����)
		priceSl = price-stop;
		TransactionArray["PRICE"] = priceSl-10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		TransactionArray["STOPPRICE2"] = priceSl; -- ���� ����-�����
		
		-- ����-������
		priceTp = price+(stop*stop_k_take);
		TransactionArray["STOPPRICE"] = priceTp; -- ���� ����-�������
		TransactionArray["OFFSET"] = "0"; -- tostring(50*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP')); -- ������� �� Min tostring(2*SEC_PRICE_STEP),
		TransactionArray["SPREAD"] = 10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP'); -- �������� �����
	end;
	
	-- ���� ��� � "�������"
	if operation == "B" then
		-- ������ (�������, ��� �������)
		symbol = "+";
		
		-- ����-����
		-- �� ����, ���������� �� 10 ���. ����� ���� (100 - ��� ����. �����)
		priceSl = price+stop;
		TransactionArray["PRICE"] = priceSl+10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
		TransactionArray["STOPPRICE2"] = priceSl; -- ���� ����-�����
		-- ����-������
		priceTp = price-(stop*stop_k_take);
		TransactionArray["STOPPRICE"] = priceTp; -- ���� ����-�������
		TransactionArray["OFFSET"] = "0"; -- tostring(50*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP')); -- ������� �� Min tostring(2*SEC_PRICE_STEP),
		TransactionArray["SPREAD"] = 10*_QuikGetParamExByIndex(code,'SEC_PRICE_STEP'); -- �������� �����
	end;
	
	-- �������� � ���������� ��������
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
	
	-- ���� ������� ������� ������ ����������� ������, �� ������ ���������� �� ������
	return CustomSendTransaction(TransactionArray, id, "ZAREGISTRIROVANO.NEW_STOP_ORDER", "ISPOLNENO.NEW_STOP_ORDER");
	
end;

-- ����������� ���������� �� ����������� ����� (����&������)
function MODIFY_STOP_ORDER(code, real_id, q)
	for i = 0,getNumberOf("stop_orders") - 1 do
		if getItem("stop_orders",i).sec_code == code then
			if getItem("stop_orders",i).stop_order_type == 9 then -- ���� "9" -- ����-������ � ����-�����  
				if bit.test(getItem("stop_orders",i).flags,0) then -- ��� 0 (0x1) ������ �������, ����� �� �������
					if getItem("stop_orders",i).order_num == real_id then
						
						-- ���� ��������� ���������� �� ��������
						if KILL_STOP_ORDER(code,getItem("stop_orders",i).order_num) then
							
							-- ��������� �����������
							local comment = getItem("stop_orders",i).brokerref;
							local commentSplit = _QuikUtilitySplit(comment,"/");
							
							local stop_order_comment = commentSplit[1];
							local stop_order_number = commentSplit[2];
							local stop_order_sl = commentSplit[3];
							local stop_order_sl_k_tp = commentSplit[4];
							
							-- ���������� ��� ������
							local operation = "S";
							local price = 0;
							if getItem("stop_orders",i).condition == 5 then -- "5" -- ">=" (�������)
								operation = "S";
								price = getItem("stop_orders",i).condition_price2+stop_order_sl;
							elseif getItem("stop_orders",i).condition == 4 then -- "4" -- "<=" (�������)
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

-- ����������� ���������� �� �������� ����-������
function KILL_STOP_ORDER(code, order_num, trans_id)
	
	-- ��������� ��������� ��� �������� ���������� �� ������� ���������
	local TransactionArray = {
		["CLASSCODE"]			= TRANS_CLASS_CODE_FUT,
		["ACCOUNT"]				= TRANS_TRADE_ACC,
		["SECCODE"]				= code,
		["TRANS_ID"]			= tostring(trans_id), -- _MyFuncRandomMax()
		["CLIENT_CODE"]			= tostring("KILL.Ord"); -- �����������
		["ACTION"]     			= "KILL_STOP_ORDER", -- ��� ������
		["STOP_ORDER_KIND"]     = "TAKE_PROFIT_AND_STOP_LIMIT_ORDER",
		["STOP_ORDER_KEY"] 		= tostring(order_num), -- ID-������
	};
	
	-- ���� ������� ������� ������ ����������� ������, �� ������ ���������� �� ������
	return CustomSendTransaction(TransactionArray, order_num, "ZAREGISTRIROVANO.KILL_STOP_ORDER", "ISPOLNENO.KILL_STOP_ORDER");

end;

-- ����������� ���������� �� �������� ���� �������
function KILL_ALL_STOP_ORDERS(code)
	for i = 0,getNumberOf("stop_orders") - 1 do
		if getItem("stop_orders",i).sec_code == code then
			if getItem("stop_orders",i).stop_order_type == 9 then -- ���� "9" -- ����-������ � ����-�����  
				if bit.test(getItem("stop_orders",i).flags,0) then -- ��� 0 (0x1) ������ �������, ����� �� �������  
				
					-- KILL_STOP_ORDER(code,getItem("stop_orders",i).order_num,getItem("stop_orders",i).trans_id);
					
				end;
			end;
		end;
	end;
end;

-- ����������� ���������� �� �������� ���������� �������
-- �� ������ ������ �� ������� �� 1 ������
-- ������ �������� �� getNumberOf("stop_orders") - ����� ������ �����, ������� �������� (�������)
function KILL_STOP_ORDERS_BY_COUNT(code, q)
	local counter = 1;
	local list_del = {};
	for i = 0,getNumberOf("stop_orders") - 1 do
		if getItem("stop_orders",i).sec_code == code then
			if getItem("stop_orders",i).stop_order_type == 9 then -- ���� "9" -- ����-������ � ����-�����  
				if bit.test(getItem("stop_orders",i).flags,0) then -- ��� 0 (0x1) ������ �������, ����� �� �������  
					
					if KILL_STOP_ORDER(code,getItem("stop_orders",i).order_num, "500"..math.ceil(os.date("%S%M%H%d")/10000)..i) then
						-- message("�����++" .. getItem("stop_orders",i).order_num);
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
	--		message("�����++" .. list_del[i]);
	--	end;
	--end;
end;

-- �������������� ����-�������
function SYNCHRONIZATION_ALL_STOP_ORDERS(code)

end;


-- function CustomSendTransaction()
function CustomSendTransaction(TransAr, id, StatusZareg, StatusIsp)
	
	-- ��� ����������
	if isConnected() == 0 then
		return nil;
	end;
	
	-- �������������� ID
	local nid = tonumber(id);

	--  ������ �� ������������
	if TRANS_LIST[nid] == StatusZareg or TRANS_LIST[nid] == StatusIsp then
		return nil;
	
	-- ��������� ����������
	else
	
		local Result = sendTransaction(TransAr);
		if Result ~= "" then
			-- ������� ��������� � �������
			_QuikUtilityLogWrite("report", "System", {"#"..nid, TransAr["SECCODE"], "Error.sendTransaction()", Result});
			message("������ �� �������!\n������: " .. Result);
			-- message("����������� ����&���� ��������� �� �������!\n������: "..Result);
			-- message("������ ����&���� ��������� �� �������!\n������: "..Result);
			return nil; -- ��������� ���������� �������
		else
			-- ���������� � ���-����
			-- ToLog("OnTrans ("..comment..")", {Depo=_QuikGetRubDepo(), Q=symbol..q, Price=price});
			-- ��������� � ���������� � ����� ���������� ��� ������� �� ������� ����������
			TRANS_LIST[nid] = StatusZareg;
			TRANS_LIST_SORT[TRANS_LIST_COUNT_NUMBER] = nid;
			TRANS_LIST_COUNT_NUMBER = TRANS_LIST_COUNT_NUMBER + 1;
			
			return nid; -- ��������� ���������� ������� (���������� ID)
		end;
	
	end;

end;

-- ��������� ������: ����������� ������� ����: "18913.0" ��������� �� ������: ����� �� ����� ��������� ���� ����������� ������� �����
-- �������� ��� ��������� ������ ��� �������� ����� (�� �� ��� ���������)
function CustomPriceFormat(price)
	return tostring(string.format ("%i", price));
end;