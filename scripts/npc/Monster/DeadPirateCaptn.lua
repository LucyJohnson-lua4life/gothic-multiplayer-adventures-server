function DeadPirateCaptn()
	local npc = CreateNPC(GetNewNPCName("Captn Hook"));
	
	SetPlayerAdditionalVisual(npc,"Hum_Body_Naked0",1, "Hum_Head_FatBald", 164);
	SetPlayerWalk(npc, "HumanS_Relaxed.mds");
	SetPlayerFatness(npc, 0.5);
    
    SetPlayerStrength(npc, 100);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 1250);
	SetPlayerHealth(npc, 1250);
	SetPlayerSkillWeapon(npc, SKILL_1H, 60);
	--Items:
	EquipArmor(npc,"ITAR_PIR_H_Addon");
    EquipMeleeWeapon(npc,"ItMw_Meisterdegen");
    
    local npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_ONEH_MASTER;
	npcarr.WeaponMode = 3;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Skeleton;
	npcarr.func = DeadPirateCaptn;
	npcarr.respawntime = 1800;
	
	return npcarr;
end
