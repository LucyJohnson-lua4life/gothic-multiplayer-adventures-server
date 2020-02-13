
function AI_OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
	for key,val in ipairs(AI_HASITEM_TABLE) do
		if(val ~= nil and val.CheckPlayer == playerid and val.checkNumber == checkid)then
			val.RealAmount = amount;
			val.Finished = true;
			table.remove(AI_HASITEM_TABLE, key);
		end
	end
end
