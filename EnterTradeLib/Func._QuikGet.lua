-----------------------------------------------------
-- ������� ��������� ���������� �� QUIK
-----------------------------------------------------

-- QUIK �������� ���������� ������ �� ������� ������ (�������� ������)
function _QuikGetRelevantTradesByIndex(code)

	local totalnet = _QuikGetTotalnetByIndex(code);
	local listTrades = {};
	local listQty = {};
	local j = 1;
	local p = 1;
	local k = 0;
	
	-- ������ ������� ������
	for i = 0,getNumberOf("trades") - 1 do -- ���������� �����������
		local trade = getItem("trades",i);
		if trade.class_code == TRANS_CLASS_CODE_FUT then -- ���� ��� �������
		if trade.sec_code == code then -- ���� ��� ��������� ����������
			-- if bit.test(trade.flags,0) then -- ������ �������
				
			-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- ���� ��� �������� �������
			-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- ���� ��� �������� �������

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
		
	-- �������� �������� ������ (�������� ������ �������)
	-- �� ������ �� ����� ������ ������, ������� ������ ���������
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

-- QUIK �������� ���������� ����� �� ������� ������
-- @ code ���
-- @ condition ����������� ������
function _QuikGetRelevantStopOrdersByIndex(code, condition)

	-- ������ ������� ����-�������
	local listStopOrders = {};
	local j = 1;
	local p = 1;
	
	for i = 0,getNumberOf("stop_orders") - 1 do
		local stop_order = getItem("stop_orders",i);
		if stop_order.class_code == TRANS_CLASS_CODE_FUT then -- ���� ��� �������
		if stop_order.sec_code == code then -- ���� ��� ��������� ����������
		if stop_order.stop_order_type == 9 then -- "9" -- ����-������ � ����-�����  
		if bit.test(stop_order.flags,0) then -- ��� 0 (0x1) ������ �������, ����� �� ������� 
			
			-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- ���� ��� �������� �������
			-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- ���� ��� �������� �������
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

-- QUIK ��������: ������� ����� �� ���� ��������
function _QuikGetTotalnetStopOrdersByIndex(code, condition)
	
	local q = 0;
	
	
	-- ������ ������� ����-�������
	for i = 0,getNumberOf("stop_orders") - 1 do
		local stop_order = getItem("stop_orders",i);
		if stop_order.class_code == TRANS_CLASS_CODE_FUT then -- ���� ��� �������
		if stop_order.sec_code == code then -- ���� ��� ��������� ����������
		if stop_order.stop_order_type == 9 then -- "9" -- ����-������ � ����-�����  
		if bit.test(stop_order.flags,0) then -- ��� 0 (0x1) ������ �������, ����� �� ������� 
			
			-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- ���� ��� �������� �������
			-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- ���� ��� �������� �������
			if condition == 0 then -- ��� �������
				q = q + stop_order.qty;
			elseif stop_order.brokerref:find(condition) then -- "LC.Ord/", -- "SC.Ord/"
				q = q + stop_order.qty;
			end;
			
		end;
		end;
		end;
		end;
	end;
	
	-- ������ ������� ������ (���� ��� ���� ������ �� ����-������� ��������)
	-- ��������� -- 
	-- for i = 0,getNumberOf("orders") - 1 do
	-- 	local orders = getItem("orders",i);
	-- 	if orders.class_code == TRANS_CLASS_CODE_FUT then -- ���� ��� �������
	-- 	if orders.sec_code == code then -- ���� ��� ��������� ����������
	-- 	if bit.test(orders.flags,0) then -- ��� 0 (0x1) ������ �������, ����� �� ������� 
	-- 		
	-- 		-- if trade.brokerref:find("OpenLong") and totalnet > 0 then -- ���� ��� �������� �������
	-- 		-- if trade.brokerref:find("OpenShort") and totalnet < 0 then -- ���� ��� �������� �������
	-- 		
	-- 		-- �������� [����� ���� ��������] - ����� ������ � �������������� ��������� ����-������ � ����-���� (���� �� ��� ������)
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

-- QUIK ��������: ������� �������� ��������
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


-- QUIK ��������: �������� ����������� �� �������� + �������� U1 (��� ������ � ����)
-- ! - �����������, ������ US (CL! - Crude Oil)
-- 1! - ��������� (NQ1! - E-mini Nasdaq 100)
-- 2! - ��������� (ES2! - E-mini S&P 500)

--1)
-- F - ������ (CLF3)
-- G - ������� (GCG3)
-- H - ���� (NQH3)		

--2)
-- J - ������
-- K - ���
-- M - ����

--3)
-- N - ����
-- Q - ������
-- U - ��������

--4)
-- V - �������
-- X - ������
-- Z - �������

function _QuikGetNameByListTickets(code)
	-- message("code:"..code..":"..monthCode .. "::" ..year);
	-- return code..monthCode..year;
	
	local findCode = _QuikGetNameByListTickets_FindSecCode(code, 3);
	if findCode then
		return findCode;
	end;
	
	return code;
end;

	function _QuikGetNameByListTickets_FindSecCode(pref, dtmd) -- ���������� ���������� ��� ��������
		if dtmd == nil or dtmd < 1 then
			dtmd = 3;
		end;
		local sec_list = getClassSecurities (TRANS_CLASS_CODE_FUT); -- �������� ������ ������������
		for test_sec_code in string.gmatch(sec_list, "("..pref.."[^%s,]+)") do -- ���������� ������ 
			local param = getParamEx(TRANS_CLASS_CODE_FUT, test_sec_code, "DAYS_TO_MAT_DATE");
			if (param.result == "1") and (param.param_image ~= "" ) and (param.param_type ~= "0") then -- �������� ������� ���������? 
				if (tonumber(param.param_value) >= dtmd) then -- ��������� ��� �� ����������
					return test_sec_code;
				end; 
			end;
		end;
		return code;
	end;

-- QUIK ��������: �������� �����������
-- ����� "_QuikGetParamExByIndex" �� ����������
function _QuikGetShortNameByIndex(code)
	for i = 0,getNumberOf("securities") - 1 do
		if getItem("securities",i).sec_code == code then        
			return getItem("securities",i).name;
		end;
	end;
	return 0;
end;

-- QUIK ��������: ������� �������� ��������� 1 ��� ���������� ������ � ������
function _QuikGetRubPricePointsByIndex(code, count)
	-- "����-������ � �������" * "������� ���������� �� ������ ������" * ("��������� ���� ����" / "��� ����")
	-- "����-���� � �������" * "������� ���������� �� ������ ������" * ("��������� ���� ����" / "��� ����")
	if _QuikGetParamExByIndex(code,"STEPPRICE") > 0 and _QuikGetParamExByIndex(code,"SEC_PRICE_STEP") > 0 then
		return tonumber(_QuikGetParamExByIndex(code,"STEPPRICE")/_QuikGetParamExByIndex(code,"SEC_PRICE_STEP")*count);
	else
		return tonumber(0);
	end;
end;

-- QUIK ��������: ������� ���-�� ������� ������� (�� �����������)
function _QuikGetTotalnetByIndex(code)
	for i = 0,getNumberOf("futures_client_holding") - 1 do
		if getItem("futures_client_holding",i).sec_code == code then
			return getItem("futures_client_holding",i).totalnet;
		end;
	end;
	return 0;
end;

-- QUIK ��������: ������� ���-�� �������� ������������
function _QuikGetActiveTicketsCount()
	local counter = 0;
	for i = 0,getNumberOf("futures_client_holding") - 1 do
		if getItem("futures_client_holding",i).totalnet > 0 or  getItem("futures_client_holding",i).totalnet < 0 then
			counter = counter + 1;
		end;
	end;
	return counter;
end;

-- ������������ ���-�� ��������� ���������� � �������/�������
function _QuikGetMaxQtyByIndex(code)
	local maxQty = 10;
	
	-- ������� �������, ������� �������
	-- maxQty1, maxComiss1 = CalcBuySell(TRANS_CLASS_CODE_FUT, code, TRANS_CLIENT_CODE, TRANS_TRADE_ACC, _QuikUtilityStrRound2(_QuikGetParamExByIndex(code,'LAST'),0), true, false);
	-- maxQty2, maxComiss2 = CalcBuySell(TRANS_CLASS_CODE_FUT, code, TRANS_CLIENT_CODE, TRANS_TRADE_ACC, _QuikUtilityStrRound2(_QuikGetParamExByIndex(code,'LAST'),0), false, false);
	-- maxQty = math.min(maxQty1,maxQty2);
	-- return tonumber(maxQty);
	
	-- ������� ������� / �� - ��������� �������
	if _QuikGetParamExByIndex(code,"SELLDEPO") > 0 then 
		-- ������-�� ������ 1 ������ �������� � �� ���� ����������� ��...
		return tonumber(math.floor((_QuikGetRubFreeDepo()/_QuikGetParamExByIndex(code,"SELLDEPO"))*0.90));
	else
		return 0;
	end;
end;

-- QUIK ��������: ������ (����������� ���)
function _QuikGetRubPrevDepo()
	local fcl=getItem("futures_client_limits",0)
	if fcl ~= nil then
		return tonumber(fcl.cbp_prev_limit);
	else
		return 21034; -- real demo (��� ���������� � ������ � ���������)
	end;
end;

-- QUIK ��������: ������ (�������)
function _QuikGetRubDepo()
	
	-- ������� �1 (��� ���������) - � ���.����� Quik https://forum.quik.ru/forum13/topic978/
	-- for i=0,getNumberOf( "futures_client_limits" )-1 do
		local fcl=getItem( "futures_client_limits" , 0);
		if fcl ~= nil then
		--if fcl.trdaccid==TRANS_TRADE_ACC and fcl.limit_type==0  then
			cbplimit=tonumber(fcl.cbplimit);  --����� ����. ���.
			varmargin=tonumber(fcl.varmargin);  --������. �����
			accruedint=tonumber(fcl.accruedint);  --��������. �����
			ts_comission=tonumber(fcl.ts_comission);  --�������� �����
		-- end;
			b_v1=cbplimit+varmargin+accruedint;
			return b_v1;	
		else
			return 21124; -- real demo (��� ���������� � ������ � ���������)
		end;
	-- end;
	
	-- ������� �2 (��� ���������) - �� �����-��� https://smart-lab.ru/blog/292043.php
	-- n = getItem("futures_client_limits",0).cbplused;
	-- m = getItem("futures_client_limits",0).cbplplanned;
	-- v = getItem("futures_client_limits",0).varmargin;
	-- b_v2=n+m+v;
	
end;

-- QUIK ��������: ������ (���������)
function _QuikGetRubFreeDepo()
	local fcl = getItem("futures_client_limits",0);
	if fcl ~= nil then
		return fcl.cbplplanned;	
	else
		return 21124; -- real demo (��� ���������� � ������ � ���������)
	end;
end;

-- QUIK ��������: ������ (���������) - � "%"
function _QuikGetPercentFreeDepo()
	return ((_QuikGetRubFreeDepo() / _QuikGetRubDepo()) * 100);
end;

-- QUIK ��������: ������ (���������������) - � "%"
function _QuikGetPercentUsedDepo()
	return 100-_QuikGetPercentFreeDepo();
end;


-- QUIK ��������: ����� �� �������� �����������
function _QuikGetRubMarginByIndex(code)
	for i = 0,getNumberOf("futures_client_holding") - 1 do
		if getItem("futures_client_holding",i).sec_code == code then
			return getItem("futures_client_holding",i).varmargin;
		end;
	end;
	return 0;
end;

-- QUIK ��������: ����� �� �������� ����������� - � "%"
function _QuikGetPercentMarginByIndex(code)
	return ((_QuikGetRubMarginByIndex(code) / _QuikGetRubFreeDepo()) * 100);
end;

-- QUIK ��������: ����� (������)
function _QuikGetRubMarginAll()
	local fcl = getItem("futures_client_limits",0);
	if fcl ~= nil then
		return fcl.varmargin;
	else
		return 0;
	end;
end;

-- QUIK ��������: ����� (������) - � "%"
function _QuikGetPercentMarginAll()
	if tonumber(_QuikGetRubMarginAll()) > 0 and tonumber(_QuikGetRubFreeDepo()) > 0 then
		return ((_QuikGetRubMarginAll() / _QuikGetRubFreeDepo()) * 100);
	else 
		return 0;
	end;
end;

-- QUIK ��������: ������� ��������� ����� �� ���� (�� ��������� � ����. ���)
function _QuikGetPercentChangeDepoPerDay()
	if tonumber(_QuikGetRubDepo()) > 0 and tonumber(_QuikGetRubPrevDepo()) then
		return tonumber((((_QuikGetRubDepo()/_QuikGetRubPrevDepo()))*100))-100;
	else
		return 0;
	end;
end;

-- QUIK �������� ���������� � ������� (����������)
-- t � �������, ���������� ������������� ������,
-- n � ���������� ������ � ������� t,
-- l � ������� (�������) �������.
function _QuikGetChartByIndex(code, line, first_candle)

	if line == nil then line = 0; end;
	if first_candle == nil then first_candle = 0; end;

	-- tag � ���������? ������������� ������� ��� ���������
	-- line � ����� ����� ������� ��� ����������. ������ ����� ����� ����� 0,
	-- first_candle � ������ ������? ������. ������ (����� �����) ������ ����� ������ 0,
	-- count � ���������� ������������� ������.
	local t, n, l = getCandlesByIndex(code, 0, 0, getNumCandles(code));
	
	-- ������� ����� ������� ����� �������� l ������� getCandlesByIndex
	-- ���� ����� (�� nil � ������ ������ ��������) ������ �������������� ���.
	if (l~=nil) then
		-- message("GOOD")
		-- local O = t[n-2].open; -- �������� �������� Open ��� ��������� ����� (���� �������� �����)
		-- local H = t[n-2].high; -- �������� �������� High ��� ��������� ����� (���������� ���� �����)
		-- local L = t[n-2].low; -- �������� �������� Low ��� ��������� ����� (���������� ���� �����)
		-- local C = t[n-2].close; -- �������� �������� Close ��� ��������� ����� (���� �������� �����)
		-- local V = t[n-2].volume; -- �������� �������� Volume ��� ��������� ����� (����� ������ � �����)
		-- local T = tonumber(t[n-2].datetime); -- �������� �������� Time ��� ��������� ����� (����� �������� ����� (������� datetime))
		return t[n-1]; -- ���� -2
		
	else
		-- message("BAD" .. code);
		return 0;
		-- message();
	end;
	
end;

-- QUIK ��������� ���. �������
function _QuikChartExistsByIndex(code, regAlert)
	local t, n, l = getCandlesByIndex(code, 0, 0, getNumCandles(code));
	if (t[n-1] == nil) then
		if regAlert == 1 then
			_QuikUtilityRegAlert(code, "������������� ������� �� ����������!");
		end;
		return false;
	else
		return true;
	end;
end;

-- QUIK ��������� http - ������
function _QuikGetHttp()
	content, status, header = socket.http.request(ROBOT_HTTP_URL);
	return content;
end;