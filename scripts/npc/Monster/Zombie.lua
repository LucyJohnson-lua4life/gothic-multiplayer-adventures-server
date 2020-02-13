function Zombie()
	local npc = CreateNPC(GetNewNPCName("Zombie"));
	
	if(npc == -1)then
		print("Creating Zombie Failed!");
	end
	
	SetPlayerInstance(npc,"Zombie01");
	
	SetPlayerStrength(npc, 150);
	SetPlayerDexterity(npc, 150);
	SetPlayerLevel(npc, 20);
	SetPlayerMaxHealth(npc, 400);
	SetPlayerHealth(npc, 400);
	
	
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

function Zombie_Addon_Knecht()
	npcarr = Zombie();
	EquipArmor(npcarr.id, "ITAR_Thorus_Addon");
	npcarr.func = Zombie_Addon_Knecht;
	return npcarr;
end

function Zombie1()
	npcarr = Zombie();
	
	return npcarr;
end


function Zombie2()
	npcarr = Zombie();
	SetPlayerInstance(npcarr.id,"Zombie02");
	
	SetPlayerStrength(npcarr.id, 150);
	SetPlayerDexterity(npcarr.id, 100);
	SetPlayerLevel(npcarr.id, 20);
	SetPlayerMaxHealth(npcarr.id, 400);
	SetPlayerHealth(npcarr.id, 400);
	
	npcarr.func = Zombie2;
	return npcarr;
end


function Zombie3()
	npcarr = Zombie();
	SetPlayerInstance(npcarr.id,"Zombie03");
	
	SetPlayerStrength(npcarr.id, 150);
	SetPlayerDexterity(npcarr.id, 100);
	SetPlayerLevel(npcarr.id, 20);
	SetPlayerMaxHealth(npcarr.id, 400);
	SetPlayerHealth(npcarr.id, 400);
	npcarr.func = Zombie3;
	return npcarr;
end


function Zombie4()
	npcarr = Zombie();
	SetPlayerInstance(npcarr.id,"Zombie04");
	
	SetPlayerStrength(npcarr.id, 150);
	SetPlayerDexterity(npcarr.id, 100);
	SetPlayerLevel(npcarr.id, 20);
	SetPlayerMaxHealth(npcarr.id, 400);
	SetPlayerHealth(npcarr.id, 400);
	npcarr.func = Zombie4;
	return npcarr;
end


function MayaZombie1()
	npcarr = Zombie();
	EquipArmor(npcarr.id, "ITAR_MayaZombie_Addon");
	
	npcarr.func = MayaZombie1;
	return npcarr;
end

function MayaZombie2()
	npcarr = Zombie();
	EquipArmor(npcarr.id, "ITAR_MayaZombie_Addon");
	
	npcarr.func = MayaZombie2;
	return npcarr;
end

function MayaZombie3()
	npcarr = Zombie();
	EquipArmor(npcarr.id, "ITAR_MayaZombie_Addon");
	
	npcarr.func = MayaZombie3;
	return npcarr;
end

function MayaZombie4()
	npcarr = Zombie();
	EquipArmor(npcarr.id, "ITAR_MayaZombie_Addon");
	
	npcarr.func = MayaZombie4;
	return npcarr;
end