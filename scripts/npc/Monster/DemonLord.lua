function DemonLord()
    local npc = CreateNPC(GetNewNPCName("Demon Lord"));
    
    if(npc == -1)then
        print("Creating Demon Lord Failed!");
    end
    
    SetPlayerInstance(npc,"DEMONLORD");
    
    SetPlayerStrength(npc, 250);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 18);
    SetPlayerMaxHealth(npc, 2100);
    SetPlayerHealth(npc, 2100);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_DUNGEON_HIT;
    npcarr.Guild = AI_GUILD_Dungeon;
    npcarr.func = Razor;
    npcarr.respawntime = 1800;
    npcarr.Aivars={}
    npcarr.Aivars["MaxWarnDistance"] = 750
    npcarr.Aivars["WarnDistance"] = 750
    npcarr.Aivars["MinWarnDistance"] = 750
    
    return npcarr;
end