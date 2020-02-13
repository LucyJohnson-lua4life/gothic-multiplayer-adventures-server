function AI_OnPlayerDisconnect(playerid)
	if(IsNPC(playerid) == 0)then
		AI_PlayerList[playerid] = nil;
		
		for npckey,npcval in pairs(AI_NPCList) do
			for diakey,diaval in pairs(npcval.Dialogs) do
				diaval["listener"][playerid] = nil;
			end
			npcval["TARGETS"][playerid] = nil;
			npcval["DIA_TARGETLIST"][playerid] = nil;
			
			for enemykey,enemyval in ipairs(npcval["ENEMY"]) do
				if(enemyval == playerid)then
					table.remove(npcval["ENEMY"], enemykey);
				end
			end
		end
	else
		for key,val in ipairs(AI_NPCList_Sort) do
			if(val == playerid) then
				table.remove(AI_NPCList_Sort, key);
			end
		end
	end
	AI_FullPList[playerid] = nil;
	SetPlayerOrNPC(playerid, nil);
	AI_NPCList[playerid] = nil;

end