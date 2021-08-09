-- ������� ���������� �����
-- ��������� ����������: @t_id

function SetCellCode(value1, value2, value3)
	SetCell(t_id, COUNTER_CELL, 0, "  <"); 
	SetCell(t_id, COUNTER_CELL, 1,  tostring(value1) .. ". " .. tostring(value3) .. " (" .. tostring(value2) .. ") [?]");
	SetCell(t_id, COUNTER_CELL, 2, "  >"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetRubPricePointsByIndex(code,count)");
	SetColor(t_id, COUNTER_CELL, 0, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	SetColor(t_id, COUNTER_CELL, 1, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	SetColor(t_id, COUNTER_CELL, 2, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellCodePrev";
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellCode";
	CALLBACK_CELL[COUNTER_CELL.."_2"] = "CallbackCellCodeNext";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ ����� ������ "����������"
	function CallbackCellCodePrev()
		_QuikUtilitySoundFilePlay("Sound-1", 0);
			
		local old_tiket = VAL_TIKET;
		VAL_TIKET = VAL_TIKET - 1;
		if VAL_TIKET < 1 then
			VAL_TIKET = #FILE_SETTINGS_LIST_TICKETS;
		end;
		
		-- ��������� ��������� �� �����?
		-- ���� ���������� �� ���������, ������ �������� "RIM5"
		-- if tonumber(_QuikGetParamExByIndex(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1], "STATUS")) == 0 then 
		-- 	message("����� "..FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1].." �� ���������! ���������� �������������� ���� �������� � ����� ��������� FILE_SETTINGS_LIST_TICKETS{}", 3);
		-- 	VAL_TIKET = old_tiket; 
		-- end;
			
		TRANS_SECCODE = _QuikGetNameByListTickets(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1],FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][3]);
		TRANS_SECNAME = _QuikGetShortNameByIndex(TRANS_SECCODE);
		VAL_Q = 0;
		VAL_SL = _QuikUtilityStrRound2(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][2]);
		VAL_SL_K_TP = 3;
	end;
		
	-- ���� ������ ������ ����� ������ "���������"
	function CallbackCellCodeNext()
		_QuikUtilitySoundFilePlay("Sound-1", 0);
		
		-- ��������� ��������� �� �����?
		-- ���� ���������� �� ���������, ������ �������� "RIM5"
		-- if tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "STATUS")) == 1 then 
		
		local old_tiket = VAL_TIKET;
		VAL_TIKET = VAL_TIKET + 1;
		if VAL_TIKET > #FILE_SETTINGS_LIST_TICKETS then
			VAL_TIKET = 1;
		end;
		
		-- ��������� ��������� �� �����?
		-- ���� ���������� �� ���������, ������ �������� "RIM5"
		-- if tonumber(_QuikGetParamExByIndex(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1], "STATUS")) == 0 then 
		-- 	message("����� "..FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1].." �� ���������! ���������� �������������� ���� �������� � ����� ��������� FILE_SETTINGS_LIST_TICKETS{}", 3);
		-- 	VAL_TIKET = old_tiket; 
		-- end;
			
		TRANS_SECCODE = _QuikGetNameByListTickets(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][1],FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][3]);
		TRANS_SECNAME = _QuikGetShortNameByIndex(TRANS_SECCODE);
		VAL_Q = 0;
		VAL_SL = _QuikUtilityStrRound2(FILE_SETTINGS_LIST_TICKETS[VAL_TIKET][2]);
		VAL_SL_K_TP = 3;
	end;
		
	-- ���� ������ ������ �� "�������� �����������" - ������� �������������� ���������
	function CallbackCellCode()
		_QuikUtilitySoundFilePlay("Sound-1", 0);
			
		message(
			"--------------------------------------------\n"..
			tostring(TRANS_SECNAME).." ("..tostring(TRANS_SECCODE)..")\n"..
			"--------------------------------------------\n"..
			"�� ����������: ".._QuikUtilityStrPriceFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"BUYDEPO")).."\n"..
			"�� ��������: ".._QuikUtilityStrPriceFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"SELLDEPO")).."\n"..
			"\n"..
			"���. ��������� ����: ".._QuikUtilityStrPriceFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"PRICEMAX")).."\n"..
			"���. ��������� ����: ".._QuikUtilityStrPriceFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"PRICEMIN")).."\n"..
			"���-�� ������ �� �������: ".._QuikUtilityStrNumberFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"NUMBIDS")).."\n".. 
			"���-�� ������ �� �������: ".._QuikUtilityStrNumberFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"NUMOFFERS")).."\n"..
			"��������� �����: ".._QuikUtilityStrNumberFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"BIDDEPTHT")).."\n"..
			"��������� �����������: ".._QuikUtilityStrNumberFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"OFFERDEPTHT")).."\n"..
			"\n"..
			"���-�� �������� �������: ".._QuikUtilityStrNumberFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"NUMCONTRACTS")).."\n"..
			"% ��������� �� ��������: "..tonumber(_QuikGetParamExByIndex(TRANS_SECCODE,"LASTCHANGE")).."%\n"..
			"--------------------------------------------\n"..
			"�� ���������: ".._QuikUtilityStrNumberFormat(_QuikGetParamExByIndex(TRANS_SECCODE,"DAYS_TO_MAT_DATE")).." ��.\n"..
			"���. ��� ����: ".._QuikUtilityStrRound2(_QuikGetParamExByIndex(TRANS_SECCODE,"SEC_PRICE_STEP"),2).." �����.\n"..
			"�����. ���� ����: ".._QuikUtilityStrPriceFormat(_QuikGetRubPricePointsByIndex(TRANS_SECCODE,1)*_QuikGetParamExByIndex(TRANS_SECCODE,"SEC_PRICE_STEP"),2).."\n"..
			"�����. ������ ������: ".._QuikUtilityStrPriceFormat(_QuikGetRubPricePointsByIndex(TRANS_SECCODE,1),2)
			,2
		);
		
	end;
	
function SetCellPattern()
	SetCell(t_id, COUNTER_CELL, 0, "  <"); 
	SetCell(t_id, COUNTER_CELL, 1,  FILE_SETTINGS_LIST_PATTERN[VAL_PATTERN]);
	SetCell(t_id, COUNTER_CELL, 2, "  >"); 
	SetColor(t_id, COUNTER_CELL, 0, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	SetColor(t_id, COUNTER_CELL, 2, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellPatternPrev";
	CALLBACK_CELL[COUNTER_CELL.."_2"] = "CallbackCellPatternNext";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "���� -"
	function CallbackCellPatternPrev()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		VAL_PATTERN = VAL_PATTERN - 1;
		if VAL_PATTERN < 1 then
			VAL_PATTERN = #FILE_SETTINGS_LIST_PATTERN;
		end;
	end;
	   
	-- ���� ������ ������ "���� +"
	function CallbackCellPatternNext()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		VAL_PATTERN = VAL_PATTERN + 1;
		if VAL_PATTERN > #FILE_SETTINGS_LIST_PATTERN then
			VAL_PATTERN = 1;
		end;
	end;

function SetCellTp(value1, value2)
	SetCell(t_id, COUNTER_CELL, 0, "  <"); 
	SetCell(t_id, COUNTER_CELL, 1, "TP:"..tostring("1�"..value2) .. " = "..(value1*value2));
	SetCell(t_id, COUNTER_CELL, 2, "  >"); 
	SetCell(t_id, COUNTER_CELL, 3, "");
	SetColor(t_id, COUNTER_CELL, 0, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	SetColor(t_id, COUNTER_CELL, 2, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellTpPrev";
	CALLBACK_CELL[COUNTER_CELL.."_2"] = "CallbackCellTpNext";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "���� -"
	function CallbackCellTpPrev()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		if VAL_SL_K_TP <= 1 then
			VAL_SL_K_TP = 1;
		else
			VAL_SL_K_TP = VAL_SL_K_TP - 1;
		end;
	end;
	   
	-- ���� ������ ������ "���� +"
	function CallbackCellTpNext()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		if VAL_SL_K_TP >= 15 then
			VAL_SL_K_TP = 15;
		else
			VAL_SL_K_TP = VAL_SL_K_TP + 1;
		end;
	end;

function SetCellSl(value1, value2)
	SetCell(t_id, COUNTER_CELL, 0, "  <"); 
	if value2 > 0 then
		SetCell(t_id, COUNTER_CELL, 1, "SL:"..tostring(value1).." ("..tostring(_QuikUtilityStrRound2(value2,2)).."%)"); 
	else
		SetCell(t_id, COUNTER_CELL, 1, "SL:"..tostring(value1)); 
	end;
	SetCell(t_id, COUNTER_CELL, 2, "  >"); 
	SetCell(t_id, COUNTER_CELL, 3, "");
	SetColor(t_id, COUNTER_CELL, 0, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	SetColor(t_id, COUNTER_CELL, 2, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	-- ��������� (���� ���� ������)...
	if _QuikRM2:check(TRANS_SECCODE, VAL_Q, VAL_SL) == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(RM_COLOR,0,0), RGB(0,0,0), RGB(RM_COLOR,0,0), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0));
	end;
	
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellSlPrev";
	CALLBACK_CELL[COUNTER_CELL.."_2"] = "CallbackCellSlNext";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "���� -"
	function CallbackCellSlPrev()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
			
		-- ���. ��� ���� / -- ��� ����������� � 10 ���...
		local min_step = _QuikGetParamExByIndex(TRANS_SECCODE,'SEC_PRICE_STEP')*10;
		
		-- ���� > 0,1% �� ��������� ����������� �� �������!
		if VAL_SL-min_step > (_QuikGetParamExByIndex(TRANS_SECCODE,'LAST')/1000)*0.5 then -- ���� 1.2
			VAL_SL = VAL_SL-min_step;
		end;
		VAL_SL = _QuikUtilityStrRound2(VAL_SL);
	end;
	   
	 -- ���� ������ ������ "���� +"
	function CallbackCellSlNext()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		
		-- ���. ��� ���� / -- ��� ����������� � 10 ���...
		local min_step = _QuikGetParamExByIndex(TRANS_SECCODE,'SEC_PRICE_STEP')*10;

		VAL_SL = VAL_SL+min_step;
		VAL_SL = _QuikUtilityStrRound2(VAL_SL);
	end;

function SetCellQ(value_q)
	SetCell(t_id, COUNTER_CELL, 0, "  <"); 
	SetCell(t_id, COUNTER_CELL, 2, "  >"); 
	local max_q = _QuikGetMaxQtyByIndex(TRANS_SECCODE);
	if value_q > 0 and max_q > 0 then
		local v = _QuikUtilityStrRound2((value_q/max_q)*100,2);
		SetCell(t_id, COUNTER_CELL, 1, "Q:"..tostring(value_q).."/"..tostring(max_q).." ("..v.."%)"); 
	else 
		SetCell(t_id, COUNTER_CELL, 1, "Q:"..tostring(value_q).."/"..tostring(max_q)); 
	end;
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetMaxQtyByIndex(code)");
	SetColor(t_id, COUNTER_CELL, 0, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	SetColor(t_id, COUNTER_CELL, 2, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	-- ��������� (���� ���� ������)...
	if _QuikRM3:check(TRANS_SECCODE, VAL_Q) == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(RM_COLOR,0,0), RGB(0,0,0), RGB(RM_COLOR,0,0), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0));
	end;
	
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellQPrev";
	CALLBACK_CELL[COUNTER_CELL.."_2"] = "CallbackCellQNext";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "���-�� -"
	function CallbackCellQPrev()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		if VAL_Q <= 1 then
			VAL_Q = 0;
		else
			VAL_Q = VAL_Q-1;
		end;
	end;
	   
	-- ���� ������ ������ "���-�� +"
	function CallbackCellQNext()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
			
		-- ������ ����. ���������� ���������, ������� �� ����� ������ ��� ������� �����������
		-- ��� ������������ �������: CalcBuySell
		if VAL_Q+1 > _QuikGetMaxQtyByIndex(TRANS_SECCODE) then
			VAL_Q = _QuikGetMaxQtyByIndex(TRANS_SECCODE);
		else	
			VAL_Q = VAL_Q+1;
		end;
	end;
	
function SetCellCalc()
	SetCell(t_id, COUNTER_CELL, 1, "     �����������  "); 
	SetColor(t_id, COUNTER_CELL, 1, RGB(59,59,59), RGB(255,255,255), RGB(59,59,59), RGB(255,255,255));
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellCalc";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- �����������
	function CallbackCellCalc()
		local PipsPercentTp = (_QuikGetRubPricePointsByIndex(TRANS_SECCODE, (VAL_SL*VAL_SL_K_TP) * VAL_Q)/_QuikGetRubDepo())*100;
		local PipsPercentSl = (_QuikGetRubPricePointsByIndex(TRANS_SECCODE, VAL_SL * VAL_Q)/_QuikGetRubDepo())*100;
		local MinSl = (_QuikGetParamExByIndex(TRANS_SECCODE,'LAST')/100)*0.2;
		message(
			tostring(
				"��� �������/�������: \n"..VAL_Q.." �����.\n"..
				"\n" ..
				"����.����:\n"..(VAL_SL*VAL_SL_K_TP).."�=".._QuikUtilityStrPriceFormat(_QuikGetRubPricePointsByIndex(TRANS_SECCODE, (VAL_SL*VAL_SL_K_TP) * VAL_Q),2)..
				" (".._QuikUtilityStrNumberFormat(PipsPercentTp,2).."% �� ��.)\n" ..
				"\n" ..
				"����.����:\n"..VAL_SL.."�=".._QuikUtilityStrPriceFormat(_QuikGetRubPricePointsByIndex(TRANS_SECCODE, VAL_SL * VAL_Q),2)..
				" (".._QuikUtilityStrNumberFormat(PipsPercentSl,2).."% �� ��.)\n"..
				"\n" ..
				"�����. ��� ����: ".._QuikUtilityStrPriceFormat(_QuikGetRubPricePointsByIndex(TRANS_SECCODE,1)*_QuikGetParamExByIndex(TRANS_SECCODE,"SEC_PRICE_STEP"),2).."\n"..
				"�����. ������ ������: ".._QuikUtilityStrPriceFormat(_QuikGetRubPricePointsByIndex(TRANS_SECCODE,1),2).."\n"..
				"���. ��� ����: ".._QuikUtilityStrRound2(_QuikGetParamExByIndex(TRANS_SECCODE,"SEC_PRICE_STEP"),2).." �����.\n"..
				"���. ��������. ����-����: ".._QuikUtilityStrRound2(MinSl).." �����." -- (0,2% �� ��������� �����.)
			), 
		2);
	end;


function SetCellInfo()

	-- ���������� � ������
	-- https://www.moex.com/s96
	-- ���������� ������ (���������� �����):
	-- 10.00 - 14.00 	�������� �������� ������ (������� ��������� ������)
	-- 		14.00 - 14.05 	������� ����������� ������ (������������� �������)
	-- 14.05 - 18.45 	�������� �������� ������ (�������� ��������� ������)
	-- 		18.45 - 19.00* 	�������� ����������� ������ (�������� �������)
	-- 19.00 - 23.50 	�������� �������������� �������� ������
	-- * � �������, ����� � �������� ����������� ������ ����������� �������, ����� ����������� ������ ������������� �� ���� �����.
	-- os.date("%d.%m.%Y", os.time()).." "..tostring(os.date("%H:%M:%S", os.time())
	
	local temp_H = tonumber(os.date("%H", os.time()));
	local temp_M = tonumber(os.date("%M", os.time()));
	local temp_S = tonumber(os.date("%S", os.time()));
	local label = "";
	
	-- ������ �����...
	-- local temp_H = tonumber(23);
	-- local temp_M = tonumber(41);
	
	-- ���� ���������� �� ���������, ������ �������� "RIM5"
	if tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "STATUS")) == 0 then 
		label = "   �� ���������!  ";
	
	-- ������� ��������� � ������� ���������
	-- elseif (temp_H >= 23 and temp_M >= 50) or (temp_H < 10 and temp_M < 59) then
	elseif tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "TRADINGSTATUS")) == 0 then 
		label = " ������ �������!";
		_QuikUtilityRegAlert("STATUS", "������ �������!");
		-- _MyFuncPaySoundFile("session-is-closed");
		
	-- ���� ����� ��������� ���� ���������
	elseif temp_S > 30 and _QuikGetParamExByIndex(TRANS_SECCODE, "DAYS_TO_MAT_DATE") < 10 then
		label = "  �� �����: "..tonumber(_QuikGetParamExByIndex(TRANS_SECCODE, "DAYS_TO_MAT_DATE")).." ��.";
	
	-- ������� ������
	elseif temp_H >= 10 and temp_H <= 13 then
		label = " ������� ������ ";
		
		-- ���� ����� ������� �1!
		if temp_H == 13 and temp_M >= 45 then
			if 60-temp_M > 0 then
				label = "�� ����.: " .. 60-temp_M.." ���.";
				_QuikUtilityRegAlert("STATUS", "�� ����. �1: " .. 60-temp_M.." ���.");
			end;
		else
			_QuikUtilityRegAlert("STATUS", "������� ������");
		end;
		
	-- �������� ������
	elseif temp_H >= 14 and temp_H <= 18 then
		label = "�������� ������";
		
		-- ���� ����� ������� �2!
		if temp_H == 18 and temp_M >= 30 then
			if 45-temp_M > 0 then
				label = "�� ����.: " .. 45-temp_M.." ���.";
				_QuikUtilityRegAlert("STATUS", "�� ����. �2: " .. 45-temp_M.." ���.");
			end;
		else
			_QuikUtilityRegAlert("STATUS", "�������� ������");
		end;
	
	-- ������ ������
	elseif temp_H >= 19 and temp_H <= 23 or (temp_H == 23 and temp_M < 50) then
		label = "  ������ ������ ";
		
		-- ���� ����� ��������!
		if temp_H == 23 and temp_M >= 30 then
			if 50-temp_M > 0 then
				label = "�� ����.: " .. 50-temp_M.." ���.";
				_QuikUtilityRegAlert("STATUS", "�� ����.: " .. 50-temp_M.." ���.");
			end;
		else
			_QuikUtilityRegAlert("STATUS", "������ ������");
		end;
		
	-- ����� ������
	elseif temp_H < 10 then
		label = "  ����� ������ ";
		_QuikUtilityRegAlert("STATUS", "����� ������");
	
	-- 45 �������
	elseif temp_S > 45 then
		label = "    45 �������...";
	
	-- �� ���������	
	else
		label = "";
		
	end;
	
	SetCell(t_id, COUNTER_CELL, 1, label); 
	SetColor(t_id, COUNTER_CELL, 0, RGB(59,59,59), RGB(255,255,255), RGB(59,59,59), RGB(255,255,255));
	SetColor(t_id, COUNTER_CELL, 1, RGB(59,59,59), RGB(255,255,255), RGB(59,59,59), RGB(255,255,255));
	SetColor(t_id, COUNTER_CELL, 2, RGB(59,59,59), RGB(255,255,255), RGB(59,59,59), RGB(255,255,255));
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellInfo";
	
	SetCell(t_id, COUNTER_CELL, 0, ""); 
	SetColor(t_id, COUNTER_CELL, 1, RGB(59,59,59), RGB(255,255,255), RGB(59,59,59), RGB(255,255,255));
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellTest";
	
	COUNTER_CELL = COUNTER_CELL + 1;
		
end;

	-- ����
	function CallbackCellInfo()
		message("TODO: ���� ������� �������");
	end;

	-- ����
	function CallbackCellTest()

		local strContent = "";
		for i = 1, #TRANS_LIST_SORT do
			local trans_id = TRANS_LIST_SORT[i];
			local status = TRANS_LIST[TRANS_LIST_SORT[i]];
			strContent = strContent.."�"..i.." ID="..trans_id.." ("..status..")\n";
		end;
		
		message(tostring(strContent));
		-- message("���������� ������� ����������:\n".._QuikUtilityPrintR(TRANS_LIST_SORT,0));
		
		-- PLAY
		-- if msg == QTABLE_LBUTTONUP and par1 == 1 and par2 == 4 then	
			_QuikUtilitySoundFilePlay("Sound-5", 1);
		-- end;
		
		-- STOP
		-- if msg == QTABLE_LBUTTONUP and par1 == 1 and par2 == 5 then	
			_QuikUtilitySoundFileStop();
		-- end; 

	end;

function SetCellJournal()
	SetCell(t_id, COUNTER_CELL, 1, "   ������ ������"); 
	SetColor(t_id, COUNTER_CELL, 1, RGB(59,59,59), RGB(255,255,255), RGB(59,59,59), RGB(255,255,255));
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellJournal";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ������ ������
	function CallbackCellJournal()
	
		-- ��������������� ����
		local tradelist = {};
		for line in io.lines(getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".report.csv") do
			
			-- 1	22.05.2020	10:00:40	Trade	#58587022	SRM0	LO/60/3/Robot	19245	1	1
			local line_arex = _QuikUtilitySplit(line,";");
			-- message("line_num"..line_arex[1]);
			-- tradelist[#tradelist+1] = {};
			
			if line_arex[7]:find("LO/") then
				tradelist[line_arex[6].."_total"] = (tradelist[line_arex[6].."_total"] or 0) + math.abs(line_arex[9]);
				tradelist[line_arex[6].."_implode"] = (tradelist[line_arex[6].."_implode"] or "") .. ""..line.."@@@";
			
			elseif line_arex[7]:find("LC/") then
				tradelist[line_arex[6].."_total"] = (tradelist[line_arex[6].."_total"] or 0) - math.abs(line_arex[9]);
				tradelist[line_arex[6].."_implode"] = (tradelist[line_arex[6].."_implode"] or "") .. ""..line.."@@@";
			
			-- ??? and (tradelist[line_arex[6].."_total"] ~= nil and tradelist[line_arex[6].."_total"] ~= 0)
			elseif line_arex[7]:find("SO/") then
				tradelist[line_arex[6].."_total"] = (tradelist[line_arex[6].."_total"] or 0) - math.abs(line_arex[9]);
				tradelist[line_arex[6].."_implode"] = (tradelist[line_arex[6].."_implode"] or "") .. ""..line.."@@@";
			
			-- ??? and (tradelist[line_arex[6].."_total"] ~= nil and tradelist[line_arex[6].."_total"] ~= 0)
			elseif line_arex[7]:find("SC/") then
				tradelist[line_arex[6].."_total"] = (tradelist[line_arex[6].."_total"] or 0) + math.abs(line_arex[9]);
				tradelist[line_arex[6].."_implode"] = (tradelist[line_arex[6].."_implode"] or "") .. ""..line.."@@@";
			end;
			
			if tradelist[line_arex[6].."_total"] == 0 then
				tradelist[line_arex[6].."_implode"] = tradelist[line_arex[6].."_implode"].."\n";
			end;
			
		end;
		
		local path_file = getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".report.journal.temp.csv";
		local file = io.open(path_file,"w");
		for key, value in pairs(tradelist) do
			if key:find("_implode") then
				file:write(tostring(value.."\n"));
			end;
		end;
		file:flush(); -- ��������� ��������� � ���-�����
		file:close();
		
		function file_exists(name)
			local f=io.open(name,"r")
			if f~=nil then io.close(f) return true else return false end
		end
		
		-- ������ ����������� (������� ����� ��������)
		-- ��� ����������� ������������
		local commentlist = {};
		if file_exists(getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".report.journal.csv") then
		for line in io.lines(getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".report.journal.csv") do
			local line_arex = _QuikUtilitySplit(line,";");
			local order_num = line_arex[2];
			local comment = line_arex[22];
			if comment ~= "" and comment ~= nil then
				commentlist[order_num] = comment;
			end;
		end;
		end;
		
		-- �������� ����
		local path_file = getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".report.journal.csv";
		local file = io.open(path_file,"w");
		file:write(tostring(
				"�;"..
				"� ������ (����.);"..
				"�����;"..
				"���� ����.;"..
				"����� ����.;"..
				"������� (���.);"..
				"���;"..
				"�������� (������� ����.);"..
				"������ ���� ����.;"..
				"�������. ���� ����.;"..
				"���-��;"..
				-- "�����. 1 �����. (�������.);"..
				"���� ����.;"..
				"����� ����.;"..
				"������� ����.;"..
				"������. ���� ����.;"..
				"�������. ���� ����.;"..
				"���-��;"..
				"�����. 1 �����. (�������.);"..
				"��������� (� %);"..
				"��������� (� ����.);"..
				"��������� (� ���.);"..
				"����������� (�� ���������);\n"
				-- ���-�� ������� ����� � ������ (��������)
				-- ���-�� ������� ����� (��������)
			)
		);
		
		-- ������ ���������
		-- local tradelist = {};
		local test = 1;
		local strWrite = {};
		for line in io.lines(getScriptPath().."//EnterTradeLog//"..TRANS_TRADE_ACC..".report.journal.temp.csv") do
			-- 117;22.05.2020;16:19:27;Trade;#58671614;SRM0;LO/60/3/Robot;18951;+1;1@@@126;22.05.2020;16:35:22;Trade;#58675312;SRM0;LC/Ord;18895;-1;1@@@
			local pos_type = "";
			local ar_open = {};
			local ar_open_total = 0;
			local ar_open_sv_1 = {};
			local ar_open_sv_2 = {};
			local ar_open_sv_3 = {}; -- �����. 1 ������,
			local ar_open_patterns = "";
			
			local ar_close = {};
			local ar_close_total = 0;
			local ar_close_sv_1 = {};
			local ar_close_sv_2 = {};
			local ar_close_sv_3 = {}; -- �����. 1 ������
			local ar_close_patterns = "";
			
			local line_arex = _QuikUtilitySplit(line,"@@@");
			for i=1,#line_arex do
				local line_arex_2 = _QuikUtilitySplit(line_arex[i],";");
				if line_arex_2[7] ~= nil then
					if line_arex_2[7]:find("LO/") or line_arex_2[7]:find("SO/") then
						ar_open[#ar_open+1] = line_arex_2;
						ar_open_sv_3[#ar_open_sv_3+1] = string.gsub(line_arex_2[10],"([,]+)",".");
						ar_open_sv_1[#ar_open_sv_1+1] = string.gsub(line_arex_2[8],"([,]+)",".");
						ar_open_sv_2[#ar_open_sv_2+1] = math.abs(line_arex_2[9]);
						ar_open_total = ar_open_total + math.abs(line_arex_2[9]);
						if line_arex_2[7]:find("LO/") then
							pos_type = "Long";
						else
							pos_type = "Short";
						end;
						
						local commentSplit = _QuikUtilitySplit(line_arex_2[7],"/");
						local pattern = commentSplit[4];
						ar_open_patterns = ar_open_patterns..pattern.."("..math.abs(line_arex_2[9])..") ";
						
					elseif line_arex_2[7]:find("LC/") or line_arex_2[7]:find("SC/") then
						ar_close[#ar_close+1] = line_arex_2;
						ar_close_sv_3[#ar_close_sv_3+1] = string.gsub(line_arex_2[10],"([,]+)",".");
						ar_close_sv_1[#ar_close_sv_1+1] = string.gsub(line_arex_2[8],"([,]+)",".");
						ar_close_sv_2[#ar_close_sv_2+1] = math.abs(line_arex_2[9]);
						ar_close_total = ar_close_total + math.abs(line_arex_2[9]);
						
						-- ������
						-- �� ������ (����)
						-- �� ������ (����)
						local commentSplit = _QuikUtilitySplit(line_arex_2[7],"/");
						local pattern = commentSplit[2];
						ar_close_patterns = ar_close_patterns..pattern.."("..math.abs(line_arex_2[9])..") ";
					end;
				end;
			end;
			
			if ar_open[1] ~= nil then
					
				-- ���������������� ���� (��������)
				local sv_open = _QuikUtilityWeightedAverage(ar_open_sv_1,ar_open_sv_2);
				-- local sv_open_1pips = _QuikUtilityWeightedAverage(ar_open_sv_3,ar_open_sv_2);
				
				local strNum = ar_open[1][5];
				strWrite[strNum] = "";
				strWrite[strNum] = strWrite[strNum]..(ar_open[1][5]..";"); -- �
				strWrite[strNum] = strWrite[strNum]..(ar_open[1][6]..";"); -- �����
				strWrite[strNum] = strWrite[strNum]..(ar_open[1][2]..";"); -- ����
				strWrite[strNum] = strWrite[strNum]..(ar_open[1][3]..";"); -- �����
				strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(ar_open[1][12])..";"); -- �������
				strWrite[strNum] = strWrite[strNum]..(pos_type..";"); -- ��� (����, ����)
				strWrite[strNum] = strWrite[strNum]..(ar_open_patterns..";"); -- ��������
				strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(ar_open[1][8])..";"); -- ������ ���� ����.
				strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(sv_open)..";"); -- �������. ���� ����.;
				strWrite[strNum] = strWrite[strNum]..(ar_open_total..";"); -- ���-��
				-- file:write(";"); -- �����. 1 �����. (�������.);
					
				if ar_close[1] ~= nil then
					
					-- ���������������� ���� (��������)
					local sv_close = _QuikUtilityWeightedAverage(ar_close_sv_1,ar_close_sv_2);
					local sv_close_1pips = _QuikUtilityWeightedAverage(ar_close_sv_3,ar_close_sv_2);
					
					-- ������� ������� ��� ������
					local res_pips = 0;
					if pos_type == "Long" then
						res_pips = sv_close - sv_open; 
						
					elseif pos_type == "Short" then
						res_pips = sv_open - sv_close; 
					end;
					
					strWrite[strNum] = strWrite[strNum]..(ar_close[#ar_close][2]..";"); -- ����
					strWrite[strNum] = strWrite[strNum]..(ar_close[#ar_close][3]..";"); -- �����
					strWrite[strNum] = strWrite[strNum]..(ar_close_patterns..";"); -- ������� ����.
					strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(ar_close[#ar_close][8])..";"); -- ������ ���� ����.;
					strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(sv_close)..";"); -- �������. ���� ����.;
					strWrite[strNum] = strWrite[strNum]..(ar_close_total..";"); -- ���-��
					strWrite[strNum] = strWrite[strNum]..(string.gsub(sv_close_1pips,"([.]+)",",")..";"); -- �����. 1 �����. (�������.);
					strWrite[strNum] = strWrite[strNum]..(string.gsub(_QuikUtilityStrRound2((((res_pips*ar_close_total*sv_close_1pips)/ar_open[1][12])*100),2),"([.]+)",",")..";"); -- ��������� (� %);
					strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(res_pips*ar_close_total,0)..";"); -- ��������� (� ����.);
					strWrite[strNum] = strWrite[strNum]..(_QuikUtilityStrNumberFormat(res_pips*ar_close_total*sv_close_1pips,0)..";"); -- ��������� (� ���.);
					
					
					-- ����������� �����������
					if commentlist[ar_open[1][5]] ~= "" and commentlist[ar_open[1][5]] ~= nil then
						strWrite[strNum] = strWrite[strNum]..commentlist[ar_open[1][5]]..";"; -- �����������;
					end;
				
				end;
					
				strWrite[strNum] = strWrite[strNum]..("\n");
				
			end;
		end;
		
		-- ��������� ������
		local strWriteCounter = 1;
		if strWrite ~= nil then
			local tkeys = {};
			for k in pairs(strWrite) do table.insert(tkeys,k); end;
			table.sort(tkeys);
			for _,k in ipairs(tkeys) do
				file:write(strWriteCounter..";"..strWrite[k]);
				strWriteCounter = strWriteCounter + 1;
			end;
		end;
		
		file:flush(); -- ��������� ��������� � ���-�����
		file:close();
		
		message("������ ������ ����������� � ����: "..TRANS_TRADE_ACC..".report.journal.csv");
		
	end;
	
function SetCellButtonDisabled()
	for k,v in pairs(LIST_NUMBER_BUTTON) do
		SetColor(t_id, k, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	end;
end;

function SetCellButtonEnabled()
	-- for i,v in pairs(LIST_NUMBER_BUTTON) do 
		-- SetColor(t_id, COUNTER_CELL, 1, RGB(165,227,128), RGB(0,0,0), RGB(165,227,128), RGB(0,0,0));
	-- end;
end;

function SetCellButtonBuy()
	SetCell(t_id, COUNTER_CELL, 1, "         -=BUY=-"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikSendTransactionOpenLongByIndex(code,q,stop,stop_k_take)"); 
	if FLAG_DISABLE_BUTTON == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(165,227,128), RGB(0,0,0), RGB(165,227,128), RGB(0,0,0));
	end;
	
	LIST_NUMBER_BUTTON[COUNTER_CELL] = 1;
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonBuy";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "������"
	function CallbackCellButtonBuy()
		_QuikUtilitySoundFilePlay("Sound-3", 0);
		if _QuikSendTransactionOpenLongByIndex(TRANS_SECCODE, VAL_Q, VAL_SL, VAL_SL_K_TP, "Pat#"..VAL_PATTERN) then
			VAL_Q = 0;
		end;
	end;

function SetCellButtonOverturn() -- overturn
	SetCell(t_id, COUNTER_CELL, 1, "   -=OVERTURN=-");  -- CATACLYSM (�������)
	SetCell(t_id, COUNTER_CELL, 3, "_QuikSendTransactionOverturnByIndex(code,stop,stop_k_take)"); 
	if FLAG_DISABLE_BUTTON == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(210,147,219), RGB(0,0,0), RGB(255,168,164), RGB(0,0,0));
	end;
	
	LIST_NUMBER_BUTTON[COUNTER_CELL] = 1;
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonOverturn";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "���������"
	function CallbackCellButtonOverturn()
		message("TODO: OVERTURN");
	end;

function SetCellButtonSell()
	SetCell(t_id, COUNTER_CELL, 1, "        -=SELL=-"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikSendTransactionOpenShortByIndex(code,q,stop,stop_k_take)"); 
	if FLAG_DISABLE_BUTTON == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(255,168,164), RGB(0,0,0), RGB(255,168,164), RGB(0,0,0));
	end;
	
	LIST_NUMBER_BUTTON[COUNTER_CELL] = 1;
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonSell";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "�������"
	function CallbackCellButtonSell()
		_QuikUtilitySoundFilePlay("Sound-3", 0);
		if _QuikSendTransactionOpenShortByIndex(TRANS_SECCODE, VAL_Q, VAL_SL, VAL_SL_K_TP, "Pat#"..VAL_PATTERN) then
			VAL_Q = 0;
		end;
	end;

-- ���. ������ ���. �� ���������� �����������
function SetCellTotalnet(value)
	SetCell(t_id, COUNTER_CELL, 1, "�������� ���: "..tostring(value)); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetTotalnetByIndex(code)");
	SetColor(t_id, COUNTER_CELL, 1, RGB(255,255,0), RGB(0,0,0), RGB(255,255,0), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
end;

-- ���. �����. ������ (�����)
function SetCellTotalnetOrders(value)
	SetCell(t_id, COUNTER_CELL, 1, "�����. �������: "..tostring(value)); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetTotalnetStopOrdersByIndex(code)");
	SetColor(t_id, COUNTER_CELL, 1, RGB(255,255,0), RGB(0,0,0), RGB(255,255,0), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
end;

-- ���. ����� �� �����������
function SetCellMargin(value)
	SetCell(t_id, COUNTER_CELL, 1, "����(���): "..tostring(value).."%"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetPercentMarginByIndex(code)");
	SetColor(t_id, COUNTER_CELL, 1, RGB(255,255,0), RGB(0,0,0), RGB(255,255,0), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
end;

function SetCellButtonClosePart(cell,part)
	SetCell(t_id, COUNTER_CELL, 1, "   -=CLOSE "..part.."%=-	"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikSendTransactionClosePartByIndex(code,part)"); 
	if FLAG_DISABLE_BUTTON == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(255,219,187), RGB(0,0,0), RGB(255,219,187), RGB(0,0,0));
	end;
	
	LIST_NUMBER_BUTTON[COUNTER_CELL] = 1;
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonClosePart"..part;
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "������� 25%/33%/50%/80%"
	function CallbackCellButtonClosePart25()
		_QuikUtilitySoundFilePlay("Sound-4", 0);
		if _QuikSendTransactionClosePartByIndex(TRANS_SECCODE,25) then
			VAL_Q = 0;
		end;
	end;
	
		function CallbackCellButtonClosePart33()
			_QuikUtilitySoundFilePlay("Sound-4", 0);
			if _QuikSendTransactionClosePartByIndex(TRANS_SECCODE,33) then
				VAL_Q = 0;
			end;
		end;
	
			function CallbackCellButtonClosePart50()
				_QuikUtilitySoundFilePlay("Sound-4", 0);
				if _QuikSendTransactionClosePartByIndex(TRANS_SECCODE,50) then
					VAL_Q = 0;
				end;
			end;
			
				function CallbackCellButtonClosePart80()
					_QuikUtilitySoundFilePlay("Sound-4", 0);
					if _QuikSendTransactionClosePartByIndex(TRANS_SECCODE,80) then
						VAL_Q = 0;
					end;
				end;

function SetCellButtonCloseAll()
	SetCell(t_id, COUNTER_CELL, 1, "   -=CLOSE ALL=-	"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikSendTransactionCloseAllByIndex(code)"); 
	if FLAG_DISABLE_BUTTON == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(200,200,0), RGB(0,0,0), RGB(200,200,0), RGB(0,0,0));
	end;
	
	LIST_NUMBER_BUTTON[COUNTER_CELL] = 1;
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonCloseAll";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "������� ���"
	function CallbackCellButtonCloseAll()
		_QuikUtilitySoundFilePlay("Sound-4", 0);
		if _QuikSendTransactionCloseAllByIndex(TRANS_SECCODE) then
			VAL_Q = 0;
		end;
	end;

function SetCellButtonSlZero()
	SetCell(t_id, COUNTER_CELL, 1, "  SL �� (OFF)"); 
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonSlZero";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

function SetCellButtonSlT()
	SetCell(t_id, COUNTER_CELL, 1, "  SL ���� (OFF)");
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonSlT";
	COUNTER_CELL = COUNTER_CELL + 1;
end;
				
function SetCellButtonCloseAuto()
	SetCell(t_id, COUNTER_CELL, 1, "  ��������. (OFF)"); 
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonCloseAuto";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

function SetCellBlockSettings()
	SetCell(t_id, COUNTER_CELL, 1, "     ��������� [?]");
	SetColor(t_id, COUNTER_CELL, 1, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	COUNTER_CELL = COUNTER_CELL + 1;
end;
	
function SetCellButtonClose()
	SetCell(t_id, COUNTER_CELL, 0, "  <"); 
	SetCell(t_id, COUNTER_CELL, 1, VAL_CLOSE_TYPE[VAL_CLOSE_TYPE_NUM][2]); 
	SetCell(t_id, COUNTER_CELL, 2, "  >"); 
	SetCell(t_id, COUNTER_CELL, 3, "_QuikSendTransactionCloseAllByIndex(code), _QuikSendTransactionClosePartByIndex(code,part)"); 
	
	if FLAG_DISABLE_BUTTON == 1 then
		SetColor(t_id, COUNTER_CELL, 0, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
		SetColor(t_id, COUNTER_CELL, 1, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
		SetColor(t_id, COUNTER_CELL, 2, RGB(232,228,225), RGB(0,0,0), RGB(232,228,225), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 0, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
		SetColor(t_id, COUNTER_CELL, 1, RGB(200,200,0), RGB(0,0,0), RGB(200,200,0), RGB(0,0,0));
		SetColor(t_id, COUNTER_CELL, 2, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	end;
	
	LIST_NUMBER_BUTTON[COUNTER_CELL] = 1;
	CALLBACK_CELL[COUNTER_CELL.."_0"] = "CallbackCellButtonClosePrev";
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellButtonClose";
	CALLBACK_CELL[COUNTER_CELL.."_2"] = "CallbackCellButtonCloseNext";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "������� (����������)"
	function CallbackCellButtonClosePrev()
		_QuikUtilitySoundFilePlay("Sound-4", 0);
		VAL_CLOSE_TYPE_NUM = VAL_CLOSE_TYPE_NUM - 1;
		if VAL_CLOSE_TYPE_NUM < 1 then
			VAL_CLOSE_TYPE_NUM = #VAL_CLOSE_TYPE;
		end;
	end;

	-- ���� ������ ������ "�������"
	function CallbackCellButtonClose()
		_QuikUtilitySoundFilePlay("Sound-4", 0);
		message("!2");
		if VAL_CLOSE_TYPE[VAL_CLOSE_TYPE_NUM][3] == 100 then
			message("_QuikSendTransactionCloseAllByIndex");
			if _QuikSendTransactionCloseAllByIndex(TRANS_SECCODE) then
				VAL_Q = 0;
			end;
		else
			message("_QuikSendTransactionClosePartByIndex");
			if _QuikSendTransactionClosePartByIndex(TRANS_SECCODE, VAL_CLOSE_TYPE[VAL_CLOSE_TYPE_NUM][3]) then
				VAL_Q = 0;
			end;
		end;
	end;
	
	-- ���� ������ ������ "����� ���� �������� (���������)"
	function CallbackCellButtonCloseNext()
		_QuikUtilitySoundFilePlay("Sound-4", 0);
		VAL_CLOSE_TYPE_NUM = VAL_CLOSE_TYPE_NUM + 1;
		if VAL_CLOSE_TYPE_NUM > #VAL_CLOSE_TYPE then
			VAL_CLOSE_TYPE_NUM = 1;
		end;
	end;

-- ����-����������
function SetCellBlockRiskManagement(code)
	SetCell(t_id, COUNTER_CELL, 1, "  ����-������� [?]");
	SetColor(t_id, COUNTER_CELL, 1, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellBlockRiskManagement";
	COUNTER_CELL = COUNTER_CELL + 1;
end;

-- ����-���������� (������� ����-���������)
function SetCellBlockRiskManagementElement(name, cell_name, cell_help, cell_eval) -- var_name, var_cell, lua_eval_res, var_doc
	local condition = assert(loadstring("return " .. cell_eval))(); -- pcall -- class..":check()"; -- "math.pow(3,2)"
	local vars = assert(loadstring("return " .. string.gsub(cell_eval,":check",":val")))(); -- pcall -- class..":check()"; -- "math.pow(3,2)"

	local res_cell = cell_name;
	for i = 1, #vars do
		res_cell = string.gsub(res_cell,"###"..i.."###",vars[i]);
	end;
	
	SetCell(t_id, COUNTER_CELL, 1, res_cell);
	SetCell(t_id, COUNTER_CELL, 3, tostring(cell_help .. ", " .. name));
	if tonumber(condition) == 1 then
		SetColor(t_id, COUNTER_CELL, 1, RGB(RM_COLOR,0,0), RGB(0,0,0), RGB(RM_COLOR,0,0), RGB(0,0,0));
	else
		SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	end;
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ "����-�������� [?]"
	function CallbackCellBlockRiskManagement()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
			
	end;

-- ���� ������
function SetCellBlockVersion()
	SetCell(t_id, COUNTER_CELL, 1, "���������� ������");
	SetColor(t_id, COUNTER_CELL, 1, RGB(140,240,144), RGB(0,0,0), RGB(140,240,144), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "��������: https://vk.com/quik.enter.trade");
	SetColor(t_id, COUNTER_CELL, 1, RGB(140,240,144), RGB(0,0,0), RGB(140,240,144), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "����. ����: skype iv.vl.litovchenko@gmail.com");
	SetColor(t_id, COUNTER_CELL, 1, RGB(140,240,144), RGB(0,0,0), RGB(140,240,144), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "�� ����: sber 4276 3800 4467 8519 (���� ������������ �)");
	SetColor(t_id, COUNTER_CELL, 1, RGB(140,240,144), RGB(0,0,0), RGB(140,240,144), RGB(0,0,0));
	COUNTER_CELL = COUNTER_CELL + 1;
end;

-- ���� �������
function SetCellBlockDepo()
	
	SetCell(t_id, COUNTER_CELL, 1, "        ������� [?]");
	SetColor(t_id, COUNTER_CELL, 1, RGB(200,200,200), RGB(0,0,0), RGB(200,200,200), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellBlockDepo";
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "���(���): ".._MyFuncStrHide(_QuikUtilityStrPriceFormat(_QuikGetRubPrevDepo(),0)));
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetRubPrevDepo()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellBlockDepoStrShow";
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "���(���): ".._MyFuncStrHide(_QuikUtilityStrPriceFormat(_QuikGetRubDepo(),0)));
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetRubDepo()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	CALLBACK_CELL[COUNTER_CELL.."_1"] = "CallbackCellBlockDepoStrShow";
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "������� �����: ".._QuikUtilityStrRound2(_QuikGetPercentUsedDepo(),0).."%");
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetPercentUsedDepo()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "������ �����: ".._QuikUtilityStrRound2(_QuikGetPercentFreeDepo(),0).."%");
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetPercentFreeDepo()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "������. �������.: ".._QuikGetActiveTicketsCount());
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetActiveTicketsCount()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "����(���): ".._QuikUtilityStrRound2(_QuikGetPercentMarginAll(),2).."%");
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetPercentMarginAll()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	COUNTER_CELL = COUNTER_CELL + 1;
	
	SetCell(t_id, COUNTER_CELL, 1, "��� �� ��: ".._QuikUtilityStrRound2(_QuikGetPercentChangeDepoPerDay(),2).."%");
	SetCell(t_id, COUNTER_CELL, 3, "_QuikGetPercentChangeDepoPerDay()");
	SetColor(t_id, COUNTER_CELL, 1, RGB(174,177,241), RGB(0,0,0), RGB(174,177,241), RGB(0,0,0));
	
	COUNTER_CELL = COUNTER_CELL + 1;
end;

	-- ���� ������ ������ �� "������� [?]" - ������� �������������� ���������
	function CallbackCellBlockDepo()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
			
		message(
			"� ������ ������ ���� ���������� �����. �� �������, �� ������ - �� ������ �������� ������ � ��������� �������. " .. 
			"��������� ������ �� ������ ��������� - ����� ���������� � �������� ������. "..
			"�� ���������� ��������� ������ ����� ����� ���� ������������. ������������� �� ���-�� �����. "..
			"�������� ������ � �������. �� ��������� ������ ���������� ���������� � ��� ������ ����� �������.  "..
			"��� �� ��������� ������ ����� ������ � ����� �������� �� ������ �� �������.  "..
			"������� ������ ��������� �� ����� ���� ���������� (5 ������� = 5 ���������� ��� �����).  "..
			"����� � ����� ������������� ���� ������� � ����� �������� ���������.  "..
			"���� � �������� ��� �������, �� �������� ����� ��������������, �� �� �����, �.�. ��� �� ����������� ��������.  "..
			"��� ���������� � �����������."
			,2
		);
		
	end;
	
	-- ���� ������ �� ������� �������
	function CallbackCellBlockDepoStrShow()
		_QuikUtilitySoundFilePlay("Sound-2", 0);
		VAL_HIDE_RUB_TIMER = 0;
	end;
	
	function _MyFuncStrHide(str)

		-- ������ ������
		if VAL_HIDE_RUB_TIMER > 11000 then
			return "*****";
		else
			VAL_HIDE_RUB_TIMER = VAL_HIDE_RUB_TIMER + 100; 
			return tostring(str);
		end;
		
	end;