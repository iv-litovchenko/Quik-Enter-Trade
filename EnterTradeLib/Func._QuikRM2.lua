_QuikRM2 			= {};
_QuikRM2.name		= 'Ëèìèò ïîòåğü â 1 ñäåëêå â "%" îò äåïîçèòà';
_QuikRM2.cell_name 	= 'Ïîòåğ â ñäë. >= ###1###% (###2###%)'; -- Íàçâàíèå
_QuikRM2.cell_help 	= '_QuikRM2:check(code, q_test, sl_test)'; -- Äîêóìåíòàöèÿ
_QuikRM2.cell_eval	= '_QuikRM2:check(TRANS_SECCODE, VAL_Q, VAL_SL)'; -- Âûçîâ ïî óìîë÷àíèş äëÿ ÿ÷åéêè

-- Ïåğåìåííûå
function _QuikRM2:val(code, q_test, sl_test)
	local var_1 = _QuikUtilityRMSetting("_QuikRM2",2);
	local var_2 = (_QuikGetRubPricePointsByIndex(code, q_test * sl_test)/_QuikGetRubDepo())*100;
	return {
		var_1,
		var_2
	};
end;

-- Ïğîâåğêà
function _QuikRM2:check(code, q_test, sl_test)
	local vars = _QuikRM2:val(code, q_test, sl_test);
	if sl_test > 0 and vars[2] > vars[1] then
		return 1;
	end;
	return 0;
end;