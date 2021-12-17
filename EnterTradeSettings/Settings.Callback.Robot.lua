----------------------------------------------------------------------------------------------------------------------
-- НАСТРОЙКИ (роботы):
----------------------------------------------------------------------------------------------------------------------

-- message("robot");
-- Можно сделать стоп-лосс и тейк по умолчанию что бы брались из настроек
-- Продумать как это обернуть в функцию???
-- И почему-то всеравно дублируется открытие поз...

-- Только покупки
--[[
ind = _QuikGetNameByListTickets_FindSecCode("SR");
if _QuikGetTotalnetByIndex(ind) == 0 then
	_QuikSendTransactionOpenLongByIndex(ind,1,60,3,"Robot")
end;
--]]


-- Только продажи
--[[
ind = _QuikGetNameByListTickets_FindSecCode("VB");
if _QuikGetTotalnetByIndex(ind) == 0 then
	_QuikSendTransactionOpenShortByIndex(ind,5,30,3,"Robot");
end;
--]]

-- Чередуем
--[[
ind = _QuikGetNameByListTickets_FindSecCode("GZ");
if _QuikGetTotalnetByIndex(ind) == 0 then
	if CallbackPosition == 1 then
		_QuikSendTransactionOpenLongByIndex(ind,3,40,3,"Robot");
	else
		_QuikSendTransactionOpenShortByIndex(ind,3,40,3,"Robot");
	end;
else
	if _QuikGetTotalnetByIndex(ind) > 0 then
		CallbackPosition = 0;
	elseif _QuikGetTotalnetByIndex(ind) < 0 then
		CallbackPosition = 1;
	end;
end;
--]]

-- Случайно (то лонг, то шорт)
--[[
ind = _QuikGetNameByListTickets_FindSecCode("RI");
if _QuikGetTotalnetByIndex(ind) == 0 then
 	if CallbackPositionRand == 1 then
 		_QuikSendTransactionOpenLongByIndex(ind,3,400,3,"Robot");
 	else
 		_QuikSendTransactionOpenShortByIndex(ind,3,400,3,"Robot");
 	end;
else
 	CallbackPositionRand = math.random(0,1);
end;
--]]

-- sleep(2000);

if ROBOT_DO_FLAG == 1 then
	-- _QuikSendTransactionOpenShortByIndex(code, q, stop, stop_k_take, pattern)
	ind = _QuikGetNameByListTickets_FindSecCode("GZ");
	-- if _QuikGetTotalnetByIndex(ind) == 0 then
		local httpContent = tostring(_QuikGetHttp());
		message("M::"..httpContent);
		if httpContent == 1 then
			if _QuikGetTotalnetByIndex(ind) < 0 then
				_QuikSendTransactionCloseAllByIndex(ind);
				_QuikUtilityRegAlert(ind, "ROBOT :: Close all BUY", 0);
				-- message("ROBOT :: Close all BUY");
			end;
			if _QuikGetTotalnetByIndex(ind) == 0 then
				_QuikSendTransactionOpenLongByIndex(ind,1,0,0,"Robot");
				_QuikUtilityRegAlert(ind, "ROBOT :: BUY", 0);
				-- message("ROBOT :: BUY");
			end;
		end;
		if httpContent == -1 then
			if _QuikGetTotalnetByIndex(ind) > 0 then
				_QuikSendTransactionCloseAllByIndex(ind);
				_QuikUtilityRegAlert(ind, "ROBOT :: Close all SELL", 0);
				-- message("ROBOT :: Close all SELL");
			end;
			if _QuikGetTotalnetByIndex(ind) == 0 then
				_QuikSendTransactionOpenShortByIndex(ind,1,0,0,"Robot");
				_QuikUtilityRegAlert(ind, "ROBOT :: SELL", 0);
				-- message("ROBOT :: SELL");
			end;
		end;
		if httpContent ~= 1 and httpContent ~= -1 then
			_QuikUtilityRegAlert(ind, "ROBOT :: NULL ??? (" .. ind .. tostring(httpContent) .. ")", 0);
			-- message("ROBOT :: NULL");
		end;
	-- end;
	ROBOT_DO_FLAG = 0;
end;