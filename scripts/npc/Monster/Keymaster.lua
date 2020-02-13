function Keymaster()
    local npc = CreateNPC(GetNewNPCName("Geisterkrieger"));
    
    if(npc == -1)then
        print("Creating Geisterkrieger Failed!");
    end
    
    SetPlayerInstance(npc,"DRAGONISLE_KEYMASTER");
    
    SetPlayerStrength(npc, 150);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 1800);
    SetPlayerHealth(npc, 1800);
    SetPlayerSkillWeapon(npc, SKILL_1H, 60);
    SetPlayerScale(npc, 1.4,1.4,1.4)
    EquipMeleeWeapon(npc, "ItMw_Orkschlaechter");
    
    npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_DUNGEON_ATTACK;
	npcarr.WeaponMode = 3;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Dungeon;
    npcarr.func = Keymaster;
    npcarr.Aivars={}
    npcarr.Aivars["MaxWarnDistance"] = 100
    npcarr.Aivars["WarnDistance"] = 80
    npcarr.Aivars["MinWarnDistance"] = 80
    return npcarr;
end
