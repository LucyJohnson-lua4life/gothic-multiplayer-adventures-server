function AI_OnPlayerConnect(playerid)
	if(IsNPC(playerid) == 0)then
		AI_SetPlayer(playerid);
		AddPlayerOrNPC(AI_PlayerList[playerid]);
	end
	AI_FullPList[playerid] = playerid;
end