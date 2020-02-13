function EarthTitan()
    local npc = CreateNPC(GetNewNPCName("Earth Titan"));
    
    if(npc == -1)then
        print("Creating SwampGolem Failed!");
    end
    
    SetPlayerInstance(npc,"SwampGolem");
    
    SetPlayerStrength(npc, 155);
    SetPlayerDexterity(npc, 155);
    SetPlayerLevel(npc, 25);
    SetPlayerMaxHealth(npc, 3800);
    SetPlayerHealth(npc, 3800);
    SetPlayerScale(npc, 2.0,2.0,2.0)
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = nil;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Golem;
    npcarr.func = SwampGolem;
    npcarr.respawntime = 1800;
    
    return npcarr;
end