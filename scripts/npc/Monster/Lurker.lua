
function Lurker()
    local npc = CreateNPC(GetNewNPCName("Lurker"));
    
    if(npc == -1)then
        print("Creating Lurker Failed!");
    end
    
    SetPlayerInstance(npc,"Lurker");
    
    SetPlayerStrength(npc, 60);
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
    npcarr.Guild = AI_GUILD_Lurker;
    npcarr.func = Lurker;
    
    
    return npcarr;
end