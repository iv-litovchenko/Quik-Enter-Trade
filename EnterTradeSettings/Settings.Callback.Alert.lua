----------------------------------------------------------------------------------------------------------------------
-- НАСТРОЙКИ (алерты):
----------------------------------------------------------------------------------------------------------------------

-- Пересечение цены с индикатором SAR
function MyAlertSar(indicator_ind, price_ind)

	local identifExists1 = _QuikChartExistsByIndex(indicator_ind, 1);
	local identifExists2 = _QuikChartExistsByIndex(price_ind, 1);
	
	if identifExists1 and identifExists2 then
		
		local val_ind = _QuikGetChartByIndex(indicator_ind).close;
		local val_price = _QuikGetChartByIndex(price_ind).close;
		
		if val_ind == val_price then
			_QuikUtilityRegAlert(indicator_ind, "Стоим на месте");
			_QuikUtilityRegLabel(price_ind, "Стоим на месте");
			
		elseif val_ind > val_price then
			_QuikUtilityRegAlert(indicator_ind, "Падаем");
			_QuikUtilityRegLabel(price_ind, "Падаем");
			
		elseif val_ind < val_price then
			_QuikUtilityRegAlert(indicator_ind, "Ростем");
			_QuikUtilityRegLabel(price_ind, "Ростем");
			
		end;
		
	end;
	
end;

MyAlertSar("RTS_SAR", "RTS_PRICE");
MyAlertSar("GAZR_SAR", "GAZR_PRICE");
MyAlertSar("SBRF_SAR", "SBRF_PRICE");