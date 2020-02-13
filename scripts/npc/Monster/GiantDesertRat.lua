function Giant_DesertRat()
    local npc = CreateNPC(GetNewNPCName("Giant Desert Rat"));
    
    if(npc == -1)then
        print("Creating GiantDesertRat Failed!");
    end
    
    SetPlayerInstance(npc,"Giant_DesertRat");
    
    SetPlayerStrength(npc, 75);
    SetPlayerDexterity(npc, 75);
    SetPlayerLevel(npc, 10);
    SetPlayerMaxHealth(npc, 75);
    SetPlayerHealth(npc, 75);
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_GiantDesertRat;
    npcarr.func = Giant_DesertRat;
    return npcarr;
end