function Rufus_Dead()
	local npc = CreateNPC(GetNewNPCName("Rufus"));
	
	if(npc == -1)then
		print("Creating Rufus_Dead Failed!");
	end
	
	SetPlayerInstance(npc,"Zombie01");
	EquipArmor(npc, "ITAR_Prisoner");
	SetPlayerStrength(npc, 150);
	SetPlayerDexterity(npc, 150);
	SetPlayerLevel(npc, 20);
	SetPlayerMaxHealth(npc, 1100);
	SetPlayerHealth(npc, 1100);
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Zombie;
	npcarr.func = Zombie
	
	return npcarr;
end