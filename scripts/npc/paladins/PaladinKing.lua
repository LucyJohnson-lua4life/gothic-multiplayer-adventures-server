function PaladinKing()
	local npc = CreateNPC(GetNewNPCName("Paladin King"));
	
	SetPlayerAdditionalVisual(npc,"Hum_Body_Naked0",1, "Hum_Head_FatBald", 120);
	SetPlayerWalk(npc, "HumanS_Relaxed.mds");
	SetPlayerInstance(npc,"PC_HERO");
	SetPlayerFatness(npc, 0.5);
    
    SetPlayerStrength(npc, 100);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 200);
	SetPlayerHealth(npc, 200);
	SetPlayerSkillWeapon(npc, SKILL_1H, 60);
	--Items:
	EquipArmor(npc,"ITAR_PAL_H");
    EquipMeleeWeapon(npc,"ItMw_Meisterdegen");
    
    local npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_TEST;
	npcarr.WeaponMode = 3;
	npcarr.dialogs = dialogs;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Dungeon;
	npcarr.aivar = {};
	npcarr.aivar["WARNTIME"] = 0;


	--npcarr.respawntime = 1800;
	
	return npcarr;
end