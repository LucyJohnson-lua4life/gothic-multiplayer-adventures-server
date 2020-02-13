function Demon()
    local npc = CreateNPC(GetNewNPCName("Demon"));
    
    if(npc == -1)then
        print("Creating Demon Failed!");
    end
    
    SetPlayerInstance(npc,"DEMON");
    
    SetPlayerStrength(npc, 245);
    SetPlayerDexterity(npc, 90);
    SetPlayerLevel(npc, 40);
    SetPlayerMaxHealth(npc, 1100);
    SetPlayerHealth(npc, 1100);
    
    
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
    npcarr.Aivars={}
    npcarr.Aivars["MaxWarnDistance"] = 500
    npcarr.Aivars["WarnDistance"] = 500
    npcarr.Aivars["MinWarnDistance"] = 500
    npcarr.func = Razor;
    npcarr.respawntime = 3600;
    
    return npcarr;
end