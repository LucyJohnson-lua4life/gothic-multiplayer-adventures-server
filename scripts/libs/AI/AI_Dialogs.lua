function startDialog(_npc, _player)
	AID_SetDefaultChoises(_npc);
	
	if(next(AI_NPCList[_npc].DIA_CHOISES) == nil)then
		return;
	end
	
	AI_NPCList[_npc]["INACTIVESTATES"] = table.copy(AI_NPCList[_npc]["STATES"]);
	AI_NPCList[_npc]["STATES"] = {};
	AI_NPCList[_npc]["INDIALOG"] = true;
	AI_NPCList[_npc].DIA_TARGET = _player;
	
	AI_TURNTOPLAYERAO(_npc, _player);
	PlayAnimation(_npc, "S_RUN");
	PlayAnimation(_player, "S_RUN");
	
	FreezePlayer(_player,1);
	FreezePlayer(_npc,1);
	AI_WAITFORCHOISES(_npc);
end

function AID_SetDefaultChoises(_npc)
	AI_NPCList[_npc].DIA_CHOISES = {};
	for key,val in ipairs(AI_NPCList[_npc].Dialogs) do
		if(val["type"] ~= 1)then--keine important dialoge!
			table.insert(AI_NPCList[_npc].DIA_CHOISES, val);--hinzufügen!
		end
	end
end

function endDialog(_npc)
	local lastStates = table.copy(AI_NPCList[_npc]["STATES"]);
	AI_NPCList[_npc]["STATES"] = table.copy(AI_NPCList[_npc]["INACTIVESTATES"]);
	AI_NPCList[_npc]["INDIALOG"] = false;
	FreezePlayer(AI_NPCList[_npc].DIA_TARGET,0);
	FreezePlayer(_npc,0);
	
	if(next(lastStates) ~= nil)then
		for key,val in ipairs(lastStates) do
			table.insert(AI_NPCList[_npc]["STATES"], 1, val);
		end
	end
end

function addDialog(_table, _type, _func, _cond_func, _desc, _nr)
	local dialog = {}
	dialog.type = _type;-- Type 0 => permanent 1 => important 2 => nothing
	dialog.func = _func;
	dialog.condFunc = _cond_func;
	dialog.desc =_desc;
	dialog.listener = {};
	dialog.nr = 0;
	if(_nr ~= nil)then
		dialog.nr = _nr;
	end
	
	table.insert(_table, dialog); 
end

function CompDialogTable(w1, w2)
	if(w1.nr < w2.nr)then
		return true;
	end
		
end


function ClearChoises(_npc)
	AI_NPCList[_npc].DIA_CHOISES = {};
end

function AddChoise(_npc, _func, _cond_func, _desc, _perm, _nr)
	--if(_cond_func == nil or _cond_func(_player, _npc))then
		local dialog = {}
		dialog.type = 0;-- Type 0 => permanent 1 => important 2 => nothing
		if(_perm == false)then
			dialog.type = 2;
		end
		dialog.func = _func;
		dialog.condFunc = _cond_func;
		dialog.desc =_desc;
		dialog.nr = 0;
		if(_nr ~= nil)then
			dialog.nr = _nr;
		end
		
		table.insert(AI_NPCList[_npc].DIA_CHOISES, dialog);
	--end
end


function Player_KnowsInfo(_playerid, func)
	if(AI_PlayerList[_playerid].KnowsDialog[func]~=nil)then
		return true;
	end
	return false;
end

function Npc_GetDistToWP(_playerid, waypoint)
	local ainpc = GetPlayerOrNPC(_playerid);
	local world = ainpc.GP_World;
	
	local wp = AI_WayNets[world]:GetWaypoint(waypoint);
	if(wp == nil)then
		wp = AI_FreePoints[world]:GetFreePoint(waypoint);
	end
	if(wp == nil)then
		return -1;
	end
	
	return getDistance(ainpc.GP_PosX, ainpc.GP_PosY, ainpc.GP_PosZ, wp.x, wp.y, wp.z);
end


