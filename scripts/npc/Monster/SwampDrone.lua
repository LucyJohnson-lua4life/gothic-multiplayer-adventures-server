function SwampDrone()
	local npc = CreateNPC(GetNewNPCName("Swampdrone"));
	
	if(npc == -1)then
		print("Creating Swamp Drone Failed!");
	end
	
	SetPlayerInstance(npc,"Swampdrone");
	
	SetPlayerStrength(npc, 50);
	SetPlayerDexterity(npc, 50);
	SetPlayerLevel(npc, 10);
	SetPlayerMaxHealth(npc, 100);
	SetPlayerHealth(npc, 100);
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_SwampDrone;
	npcarr.func = SwampDrone;
	return npcarr;
end