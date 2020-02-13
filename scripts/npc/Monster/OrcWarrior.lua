
function OrcWarrior()
	local npc = CreateNPC(GetNewNPCName("Orc Warrior"));
	
	if(npc == -1)then
		print("Creating Orc Warrior Failed!");
	end
	
	SetPlayerInstance(npc,"OrcWarrior_Roam");
	
	SetPlayerStrength(npc, 170);
	SetPlayerDexterity(npc, 150);
	SetPlayerLevel(npc, 30);
	SetPlayerMaxHealth(npc, 300);
	SetPlayerHealth(npc, 300);
	SetPlayerSkillWeapon(npc, SKILL_2H, 100);
	EquipMeleeWeapon(npc, "ItMw_2H_OrcAxe_03");
	
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
	npcarr.func = OrcWarrior;
	npcarr.respawntime = 300;
	
	return npcarr;
end



function OrcWarrior1()
	npcarr = OrcWarrior();
	
	npcarr.func = OrcWarrior1;
	
	
	return npcarr;
end

function OrcWarrior2()
	npcarr = OrcWarrior();
	npcarr.func = OrcWarrior2;
	
	return npcarr;
end

function OrcWarrior3()
	npcarr = OrcWarrior();
	npcarr.func = OrcWarrior3;
	
	return npcarr;
end

function OrcWarrior4()
	npcarr = OrcWarrior();
	npcarr.func = OrcWarrior4;
	
	return npcarr;
end