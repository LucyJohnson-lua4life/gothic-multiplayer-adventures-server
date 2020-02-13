function DemonSnake()
	local npc = CreateNPC(GetNewNPCName("Demon Snake"));
	
	if(npc == -1)then
		print("Creating Swampshark Failed!");
	end
	
	SetPlayerInstance(npc,"Swampshark");
	
	SetPlayerStrength(npc, 120);
	SetPlayerDexterity(npc, 120);
	SetPlayerLevel(npc, 24);
	SetPlayerMaxHealth(npc, 1840);
	SetPlayerHealth(npc, 1840);
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Dungeon;
	npcarr.func = Swampshark;
	
	return npcarr;
end