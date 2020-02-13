function GiantRat()
    local npc = CreateNPC(GetNewNPCName("Giant Rat"));
    
    if(npc == -1)then
        print("Creating GiantRat Failed!");
    end
    
    SetPlayerInstance(npc,"Giant_Rat");
    
    SetPlayerStrength(npc, 20);
    SetPlayerDexterity(npc, 20);
    SetPlayerLevel(npc, 12);
    SetPlayerMaxHealth(npc, 40);
    SetPlayerHealth(npc, 40);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_GiantRat;
    npcarr.func = GiantRat;
    
    return npcarr;
end


function YoungGiantRat()
    local npcarr = GiantRat();
    local name = GetNewNPCName("Young Giant Rat");
    SetPlayerName(npcarr.id, name);
    
    SetPlayerStrength(npcarr.id, 5);
    SetPlayerDexterity(npcarr.id, 5);
    SetPlayerLevel(npcarr.id, 3);
    SetPlayerMaxHealth(npcarr.id, 10);
    SetPlayerHealth(npcarr.id, 10);
    
    
    npcarr.func = YoungGiantRat;
    
    return npcarr;
end