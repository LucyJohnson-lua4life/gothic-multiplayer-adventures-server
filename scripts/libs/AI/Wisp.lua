function Wisp()
	local npc = CreateNPC(GetNewNPCName("Wisp"));
	
	if(npc == -1)then
		print("Creating Wisp Failed!");
	end
	
	SetPlayerInstance(npc,"Wisp");
	
	SetPlayerStrength(npc, 20);
	SetPlayerDexterity(npc, 20);
	SetPlayerLevel(npc, 4);
	SetPlayerMaxHealth(npc, 40);
	SetPlayerHealth(npc, 40);
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Wisp;
	npcarr.func = Wisp;
	
	return npcarr;
end