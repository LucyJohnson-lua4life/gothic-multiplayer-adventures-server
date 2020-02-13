function Troll()
	local npc = CreateNPC(GetNewNPCName("Troll"));
	
	if(npc == -1)then
		print("Creating Troll Failed!");
	end
	
	SetPlayerInstance(npc,"Troll");
	
	SetPlayerStrength(npc, 105);
	SetPlayerDexterity(npc, 100);
	SetPlayerLevel(npc, 50);
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
	npcarr.Guild = AI_GUILD_Troll;
	npcarr.func = Troll;
	npcarr.respawntime = 300;
	
	return npcarr;
end


function Troll_Black()
	local npc = CreateNPC(GetNewNPCName("Black Troll"));
	
	if(npc == -1)then
		print("Creating Troll_Black Failed!");
	end
	
	SetPlayerInstance(npc,"Troll_Black");
	
	SetPlayerStrength(npc, 200);
	SetPlayerDexterity(npc, 200);
	SetPlayerLevel(npc, 100);
	SetPlayerMaxHealth(npc, 2500);
	SetPlayerHealth(npc, 2500);
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Troll;
	npcarr.func = Troll_Black;
	npcarr.respawntime = 3600;
	
	return npcarr;
end