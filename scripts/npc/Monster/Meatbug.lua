function Meatbug()
    local npc = CreateNPC(GetNewNPCName("Meatbug"));
    
    if(npc == -1)then
        print("Creating Meatbug Failed!");
    end
    
    SetPlayerInstance(npc,"Meatbug");
    
    SetPlayerStrength(npc, 1);
    SetPlayerDexterity(npc, 1);
    SetPlayerLevel(npc, 1);
    SetPlayerMaxHealth(npc, 10);
    SetPlayerHealth(npc, 10);
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = nil;
    npcarr.GotEnemyFunc = nil;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.onhitted = nil;
    npcarr.Guild = AI_GUILD_Meatbug;
    npcarr.func = Meatbug;
    
    return npcarr;
end