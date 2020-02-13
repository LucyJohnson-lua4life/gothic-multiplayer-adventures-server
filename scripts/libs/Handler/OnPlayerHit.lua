function AI_OnPlayerHit(playerid, killerid)
	if(AI_NPCList[playerid] == nil)then
		return;
	end
	
	if(AI_NPCList[playerid].OnHitFunc == nil)then
		return;
	end
	AI_NPCList[playerid].OnHitFunc(AI_NPCList[playerid], killerid);
end