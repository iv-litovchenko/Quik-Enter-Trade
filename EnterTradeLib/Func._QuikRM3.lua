_QuikRM3 			= {};
_QuikRM3.name		= 'Максимальная загрузка капитала в % от депозита';
_QuikRM3.cell_name 	= 'Задейст капит: > ###1###% (###2###%)'; -- Название
_QuikRM3.cell_help 	= '_QuikRM3:check(code, q_test)'; -- Документация
_QuikRM3.cell_eval	= '_QuikRM3:check(TRANS_SECCODE, VAL_Q)'; -- Вызов по умолчанию для ячейки

-- Переменные
function _QuikRM3:val(code, q_test)
	local var_1 = _QuikUtilityRMSetting("_QuikRM3",2);
	local var_2 = (_QuikGetMaxQtyByIndex(code)/100)*var_1;
	return {
		var_1,
		var_2
	};
end;

-- Проверка
function _QuikRM3:check(code, q_test)
	local vars = _QuikRM3:val(code, q_test);
	if q_test > 0 and q_test > vars[2] then
		return 1;
	end;
	return 0;
end;