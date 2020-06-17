-- Класс №4 Если стоп < 0,2% от стоимости инструмента
-- Принимает один параметр настроек @ Миним. стоимость инструмента
_QuikRM4 = {};
_QuikRM4_doc = "_QuikRM4(code, sl_test)"; -- Документация
_QuikRM4_name = "Минимальный размер стопа в \"%\" от стоимости инструмента"; -- Название

-- Ячейка
function _QuikRM4:cell()
	local s2 = _QuikUtilityRMSetting("_QuikRM4",2);
	local calc = (_QuikGetMaxQtyByIndex(TRANS_SECCODE)/100)*s2;
	return tostring("Оче мал стоп < "..s2.."%");
end;

-- Проверка
function _QuikRM4:check(code, sl_test)
	if code == "UpdateTableGlobalVar" then
		code = TRANS_SECCODE;
		sl_test = VAL_SL;
	end;
	
	local s2 = _QuikUtilityRMSetting("_QuikRM4",2);
	local calc = (_QuikGetParamExByIndex(code,'LAST')/1000)*s2 ;
	local min_step = _QuikGetParamExByIndex(code,'SEC_PRICE_STEP');
	
	if sl_test-min_step < calc then
		return 1;
	end;
	return 0;
end;