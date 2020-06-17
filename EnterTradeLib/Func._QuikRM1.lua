_QuikRM1 			= {};
_QuikRM1.name		= 'Ëèìèò ïîòåğü êàïèòàëà íà 1 äåíü â "%" îò äåïîçèòà';
_QuikRM1.cell_name 	= 'Ïîòåğ â äí: >= ###1###% (###2###%)'; -- Íàçâàíèå
_QuikRM1.cell_help 	= '_QuikRM1:check()'; -- Äîêóìåíòàöèÿ
_QuikRM1.cell_eval	= '_QuikRM1:check()'; -- Âûçîâ ïî óìîë÷àíèş äëÿ ÿ÷åéêè

-- Ïåğåìåííûå
function _QuikRM1:val()
	local var_1 = _QuikUtilityRMSetting("_QuikRM1",2);
	local var_2 = 100-(_QuikGetRubDepo()/_QuikGetRubPrevDepo()*100);
	return {
		var_1,
		_QuikUtilityStrRound2(var_2,0)
	};
end;

-- Ïğîâåğêà
function _QuikRM1:check()
	local vars = _QuikRM1:val();
	if vars[2] >= vars[1] then
		return 1;
	end;
	return 0;
end;