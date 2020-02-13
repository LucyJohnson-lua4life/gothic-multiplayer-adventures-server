function AI_OnPlayerKey(playerid,keydown)
	if(Trade_OnPlayerKey(playerid, keydown) == true)then
		return;
	end
	
	if(AI_PlayerList[playerid] ~= nil and AI_PlayerList[playerid].TRADINGPARTNER ~=nil)then
		AI_NPCList[AI_PlayerList[playerid].TRADINGPARTNER]["STATES"][1].Trading:KeyHandler(playerid, keydown);
	end
	
	if(keydown == KEY_RETURN)then
		local focusid = AI_PlayerList[playerid].DIALOGPATNER;
	    if( focusid == nil) then
			return
		end
		
		if(AI_NPCList[focusid] == nil)then
			return;
		end
		
		if(AI_NPCList[focusid].DIA_WAITFORCHOISE == false)then
			return;
		end
		local state = AI_NPCList[focusid]["STATES"][1];
		AI_NPCList[focusid].DIA_CHOISE = state.DiaList.position;
	end
	if(keydown == KEY_S or keydown == KEY_W)then
		local focusid = AI_PlayerList[playerid].DIALOGPATNER;
	    if( focusid == nil) then
			return;
		end
		
		if(AI_NPCList[focusid] == nil)then
			return;
		end
		
		if(AI_NPCList[focusid].DIA_WAITFORCHOISE == false)then
			return;
		end
		
		local state = AI_NPCList[focusid]["STATES"][1];
		if(keydown == KEY_S)then
			state.DiaList:GoDown();
		else
			state.DiaList:GoUp();
		end
		
	end
	if keydown == KEY_J then
		local focusid = GetFocus(playerid);
	    if( focusid == nil) then
			return
		end
		
		if(AI_NPCList[focusid] == nil)then
			return;
		end
		
		if(AI_NPCList[focusid]["TALKTABLE"] == false)then
			return;
		end
		
		if(AI_NPCList[focusid]["INDIALOG"] == true)then
			return;
		end
		
		if(next(AI_NPCList[focusid]["ENEMY"]) ~= nil and AI_NPCList[focusid].AttackFunc ~= nil )then
			return;
		end
		
		if(next(AI_NPCList[focusid].Dialogs) == nil)then
			return;
		end
		
		AI_PlayerList[playerid].DIALOGPATNER = focusid;
		
		startDialog(focusid, playerid);
		
	end
end