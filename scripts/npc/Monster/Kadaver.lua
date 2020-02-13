function Kadaver()
	local npc = CreateNPC(GetNewNPCName("Mutierter Kadaver"));
	
	if(npc == -1)then
		print("Creating Zombie Failed!");
	end
	
	SetPlayerInstance(npc,"Zombie01");
	
	SetPlayerStrength(npc, 120);
	SetPlayerDexterity(npc, 100);
	SetPlayerLevel(npc, 20);
	SetPlayerMaxHealth(npc, 1400);
	SetPlayerHealth(npc, 1400);
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_DUNGEON_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_DUNGEON_HIT;
	npcarr.Guild = AI_GUILD_Dungeon;
	npcarr.func = Zombie
	npcarr.Aivars={}
	npcarr.Aivars["MaxWarnDistance"] = 500
    npcarr.Aivars["WarnDistance"] = 500
    npcarr.Aivars["MinWarnDistance"] = 500
	EquipArmor(npcarr.id, "ITAR_Leather_L");
	
	return npcarr;
end