function Harpie()
    local npc = CreateNPC(GetNewNPCName("Harpy"));
    
    if(npc == -1)then
        print("Creating Harpie Failed!");
    end
    
    SetPlayerInstance(npc,"Harpie");
    
    SetPlayerStrength(npc, 90);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 100);
    SetPlayerHealth(npc, 100);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Harpie;
    npcarr.func = Harpie;
    
    return npcarr;
end