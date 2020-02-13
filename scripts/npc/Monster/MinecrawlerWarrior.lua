function MinecrawlerWarrior()
    local npc = CreateNPC(GetNewNPCName("Minecrawler Warrior"));
    
    if(npc == -1)then
        print("Creating MinecrawlerWarrior Failed!");
    end
    
    SetPlayerInstance(npc,"MinecrawlerWarrior");
    
    SetPlayerStrength(npc, 200);
    SetPlayerDexterity(npc, 200);
    SetPlayerLevel(npc, 12);
    SetPlayerMaxHealth(npc, 580);
    SetPlayerHealth(npc, 580);
    
    
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
    npcarr.func = MinecrawlerWarrior;
    
    return npcarr;
end