function Minecrawler()
    local npc = CreateNPC(GetNewNPCName("Minecrawler"));
    
    if(npc == -1)then
        print("Creating Minecrawler Failed!");
    end
    
    SetPlayerInstance(npc,"Minecrawler");
    
    SetPlayerStrength(npc, 170);
    SetPlayerDexterity(npc, 60);
    SetPlayerLevel(npc, 12);
    SetPlayerMaxHealth(npc, 120);
    SetPlayerHealth(npc, 120);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Minecrawler;
    npcarr.func = Minecrawler;
    
    return npcarr;
end