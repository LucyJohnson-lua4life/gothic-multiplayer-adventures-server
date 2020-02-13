function Blattcrawler()
    local npc = CreateNPC(GetNewNPCName("Blattcrawler"));
    
    if(npc == -1)then
        print("Creating Blattcrawler Failed!");
    end
    
    SetPlayerInstance(npc,"Blattcrawler");
    
    SetPlayerStrength(npc, 200);
    SetPlayerDexterity(npc, 170);
    SetPlayerLevel(npc, 15);
    SetPlayerMaxHealth(npc, 350);
    SetPlayerHealth(npc, 350);
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Blattcrawler;
    npcarr.func = Blattcrawler;
    return npcarr;
end