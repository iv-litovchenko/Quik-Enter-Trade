_QuikRMSysA = {};

-- Ïåğåìåííûå
function _QuikRMSysA:val(code, q_test, sl_test)
	local var_1 = _QuikUtilityRMSetting("_QuikRMSysA",2);
	local var_2 = (_QuikGetRubPricePointsByIndex(code, q_test * sl_test)/_QuikGetRubDepo())*100;
	return {
		var_1,
		var_2
	};
end;

-- Ïğîâåğêà
function _QuikRMSysA:check(code, q_test, sl_test)
	local vars = _QuikRMSysA:val(code, q_test, sl_test);
	if sl_test > 0 and vars[2] > vars[1] then
		return 1;
	end;
	return 0;
end;