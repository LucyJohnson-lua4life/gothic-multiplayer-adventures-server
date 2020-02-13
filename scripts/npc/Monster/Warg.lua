function Warg()
	local npc = CreateNPC(GetNewNPCName("Warg"));
	
	if(npc == -1)then
		print("Creating Warg Failed!");
	end
	
	SetPlayerInstance(npc,"Warg");
	
	SetPlayerStrength(npc, 200);
	SetPlayerDexterity(npc, 150);
	SetPlayerLevel(npc, 30);
	SetPlayerMaxHealth(npc, 300);
	SetPlayerHealth(npc, 300);
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Warg;
	npcarr.func = Warg;
	
	return npcarr;
end