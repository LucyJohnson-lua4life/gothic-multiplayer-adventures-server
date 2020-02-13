function OrcScout()
	local npc = CreateNPC(GetNewNPCName("Orc Scout"));
	
	if(npc == -1)then
		print("Creating Orc Scout Failed!");
	end
	
	SetPlayerInstance(npc,"OrcWarrior_Roam");
	
	SetPlayerStrength(npc, 80);
	SetPlayerDexterity(npc, 70);
	SetPlayerLevel(npc, 15);
	SetPlayerMaxHealth(npc, 150);
	SetPlayerHealth(npc, 150);
	
	EquipMeleeWeapon(npc, "ItMw_2H_OrcAxe_02");
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 4;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Orc;
	npcarr.func = OrcScout;
	npcarr.respawntime = 300;
	
	return npcarr;
end