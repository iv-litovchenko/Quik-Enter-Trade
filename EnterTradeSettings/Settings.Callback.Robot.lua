----------------------------------------------------------------------------------------------------------------------
-- НАСТРОЙКИ (роботы):
----------------------------------------------------------------------------------------------------------------------

-- message("robot");
-- Можно сделать стоп-лосс и тейк по умолчанию что бы брались из настроек
-- Продумать как это обернуть в функцию???
-- И почему-то всеравно дублируется открытие поз...

-- Только покупки
ind = "SRM0";
if _QuikGetTotalnetByIndex(ind) == 0 then
	_QuikSendTransactionOpenLongByIndex(ind,1,60,3,"Robot")
end;

-- Только продажи
ind = "VBM0";
if _QuikGetTotalnetByIndex(ind) == 0 then
	_QuikSendTransactionOpenShortByIndex(ind,5,30,3,"Robot");
end;

-- Чередуем
ind = "GZM0";
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

-- Случайно (то лонг, то шорт)
ind = "RIM0";
if _QuikGetTotalnetByIndex(ind) == 0 then
 	if CallbackPositionRand == 1 then
 		_QuikSendTransactionOpenLongByIndex(ind,3,400,3,"Robot");
 	else
 		_QuikSendTransactionOpenShortByIndex(ind,3,400,3,"Robot");
 	end;
else
 	CallbackPositionRand = math.random(0,1);
end;

-- sleep(2000);