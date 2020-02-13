function AI_TA_MONSTER(_npc, _other)
	local ainpc = GetPlayerAI(_npc);
	
	
	
end

function AI_UP_MONSTER(_npc)
	local ainpc = GetPlayerAI(_npc);
	

	MAI_CheckWarn(_npc, val);
	if(MAI_LoopWarn(_npc) == false)then
		--PlayAnimation(ainpc.ID, "S_RUN");
	end
end

function AI_GOTENEMY_MONSTER_FLEE(_npc, _enemy)
	if((AI_NPCList[_npc].Guild == AI_GUILD_Scavenger and AI_NPCList[_enemy].Guild == AI_GUILD_Wolf) or
		(AI_NPCList[_npc].Guild == AI_GUILD_Goblin and AI_NPCList[_enemy].Guild == AI_GUILD_Lurker)	)then
		AI_NPCList[_npc].Aivars.Flee = true;
		
	else
		AI_NPCList[_npc].Aivars.Flee = false;
	end
	
	SetEnemy(_npc, _enemy);
end