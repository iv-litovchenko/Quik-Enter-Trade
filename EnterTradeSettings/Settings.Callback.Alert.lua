----------------------------------------------------------------------------------------------------------------------
-- НАСТРОЙКИ (алерты):
----------------------------------------------------------------------------------------------------------------------

-- Пересечение цены с индикатором NRTR
function MyAlertIndicator(indicator_ind, price_ind)

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

-- MyAlertIndicator("RI_SAR", "RI_PRICE");
-- MyAlertIndicator("Si_SAR", "Si_PRICE");

-- Функция для сообщение о цене
function MyAlert(ind, price)
	local indFunc = _QuikChartExistsByIndex(ind, 1);
	if indFunc then
		
		local val_price = _QuikGetChartByIndex(ind).close;
		local ind_comment = ind.."/"..tostring(price);
		
		if tonumber(val_price) > price then
			_QuikUtilityRegAlert(ind_comment, "Цена > "..price); -- Рег. алерт в таблице окошка
			-- _QuikUtilityRegLabel(ind_comment, "Цена > "..price); -- Добавляем метку на график
		
		elseif tonumber(val_price) < price then
			_QuikUtilityRegAlert(ind_comment, "Цена < "..price); -- Рег. алерт в таблице окошка
			-- _QuikUtilityRegLabel(ind_comment, "Цена < "..price); -- Добавляем метку на график
		
		else
			_QuikUtilityRegAlert(ind_comment, "Цена = "..price); -- Рег. алерт в таблице окошка
			-- _QuikUtilityRegLabel(ind_comment, "Цена = "..price); -- Добавляем метку на график	
		end;
		
	end;
	
end; 

-- MyAlert("P1-1", 122361);