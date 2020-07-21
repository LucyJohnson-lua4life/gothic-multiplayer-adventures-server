function StrongBandit()
	local npc = CreateNPC(GetNewNPCName("Strong Bandit"));
	SetPlayerInstance(npc,"DRAGONISLE_KEYMASTER");	
    SetPlayerAdditionalVisual(npc,"Hum_Body_Naked0",1, "Hum_Head_FatBald", math.random(35,80));
	SetPlayerWalk(npc, "HumanS_Relaxed.mds");
	SetPlayerFatness(npc, 0.5);
    
    SetPlayerStrength(npc, 200);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 1100);
	SetPlayerHealth(npc, 1100);
	SetPlayerSkillWeapon(npc, SKILL_1H, 60);
	--Items:
	EquipArmor(npc,"ITAR_BDT_H");
    EquipMeleeWeapon(npc,"ItMw_Doppelaxt");

    local npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = DR_Guard_Lguard;
	npcarr.attack_routine = FAI_ONEH_MASTER;
	npcarr.WeaponMode = 3;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Wolf;
	--npcarr.func = StrongBandit;
	npcarr.respawntime = 300;
	
	return npcarr;
end
