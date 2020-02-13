function Razor()
    local npc = CreateNPC(GetNewNPCName("Razor"));
    
    if(npc == -1)then
        print("Creating Razor Failed!");
    end
    
    SetPlayerInstance(npc,"Razor");
    
    SetPlayerStrength(npc, 200);
    SetPlayerDexterity(npc, 120);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 400);
    SetPlayerHealth(npc, 400);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Razor;
    npcarr.func = Razor;
    npcarr.respawntime = 600;
    
    return npcarr;
end