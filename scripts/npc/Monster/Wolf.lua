
function Wolf()
    local npc = CreateNPC(GetNewNPCName("Wolf"));
    
    if(npc == -1)then
        print("Creating Wolf Failed!");
    end
    
    SetPlayerInstance(npc,"Wolf");
    
    SetPlayerStrength(npc, 170);
    SetPlayerDexterity(npc, 50);
    SetPlayerLevel(npc, 6);
    SetPlayerMaxHealth(npc, 300);
    SetPlayerHealth(npc, 300);
    
    local npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Wolf;
    npcarr.func = Wolf;
    return npcarr;
end

function YoungWolf()
    local npcArray = Wolf();--A normal Wolf will be created
    local youngwolfname = GetNewNPCName("Young Wolf");
    SetPlayerName(npcArray.id, youngwolfname);
    
    SetPlayerStrength(npcArray.id, 10);
    SetPlayerDexterity(npcArray.id, 10);
    SetPlayerLevel(npcArray.id, 3);
    SetPlayerMaxHealth(npcArray.id, 20);
    SetPlayerHealth(npcArray.id, 20);
    
    
    npcArray.func = YoungWolf;
    
    return npcArray;
end