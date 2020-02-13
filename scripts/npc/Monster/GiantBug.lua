function Giant_Bug()
    local npc = CreateNPC(GetNewNPCName("Giant Bug"));
    
    if(npc == -1)then
        print("Creating Giant_Bug Failed!");
    end
    
    SetPlayerInstance(npc,"Giant_Bug");
    
    SetPlayerStrength(npc, 40);
    SetPlayerDexterity(npc, 40);
    SetPlayerLevel(npc, 8);
    SetPlayerMaxHealth(npc, 80);
    SetPlayerHealth(npc, 80);
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_GiantBug;
    npcarr.func = Giant_Bug;
    return npcarr;
end


function YoungGiant_Bug()
    local npcarr = Giant_Bug();
    local name = GetNewNPCName("Young Giant Bug");
    SetPlayerName(npcarr.id, name);
    
    SetPlayerStrength(npcarr.id, 10);
    SetPlayerDexterity(npcarr.id, 10);
    SetPlayerLevel(npcarr.id, 2);
    SetPlayerMaxHealth(npcarr.id, 20);
    SetPlayerHealth(npcarr.id, 20);
    
    
    npcarr.func = YoungGiant_Bug;
    
    return npcarr;
end
