function N_EliteOrc()
    local npc = CreateNPC(GetNewNPCName("Orc Elite"));
    
    if(npc == -1)then
        print("Creating Orc Elite Failed!");
    end
    
    SetPlayerInstance(npc,"OrcElite_Roam");
    
    SetPlayerStrength(npc, 700);
    SetPlayerDexterity(npc, 225);
    SetPlayerLevel(npc, 45);
    SetPlayerMaxHealth(npc, 450);
    SetPlayerHealth(npc, 450);
    
    EquipMeleeWeapon(npc, "ItMw_2H_OrcSword_02");
    
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
    npcarr.func = OrcElite;
    
    return npcarr;
end