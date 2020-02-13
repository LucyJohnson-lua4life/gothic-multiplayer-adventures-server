 function KlosterSkeletonLord()
	local npc = CreateNPC(GetNewNPCName("Keymaster"));
	
	if(npc == -1 or npc == nil)then
		print("Creating Skeleton Warrior Failed!");
	end
	
	SetPlayerInstance(npc,"CRYPT_SKELETON_LORD");
	
	SetPlayerStrength(npc, 105);
	SetPlayerDexterity(npc, 100);
	SetPlayerLevel(npc, 40);
	SetPlayerMaxHealth(npc, 400);
	SetPlayerHealth(npc, 400);
	
	EquipMeleeWeapon(npc, "ItMw_Zweihaender2");
	EquipArmor(npc, "ITAR_PAL_SKEL");
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 4;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Skeleton;
	npcarr.func = SkeletonWarrior;
	npcarr.respawntime = 600;
	npcarr.Aivars = {}
	npcarr.Aivars["MaxWarnDistance"] = 750
	
	return npcarr;
end
