
function Bloodfly()
    local npc = CreateNPC(GetNewNPCName("Bloodfly"));
    
    if(npc == -1)then
        print("Creating Bloodfly Failed!");
    end
    
    SetPlayerInstance(npc,"Bloodfly");
    
    SetPlayerStrength(npc, 20);
    SetPlayerDexterity(npc, 20);
    SetPlayerLevel(npc, 12);
    SetPlayerMaxHealth(npc, 40);
    SetPlayerHealth(npc, 40);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Bloodfly;
    npcarr.aivar = {};
    npcarr.aivar["ATTACKRANGE"] = 300;
    npcarr.aivar["WARNTIME"] = 3000;
    npcarr.func = Bloodfly;
    
    return npcarr;
end


function YoungBloodfly()
    local npcarr = Bloodfly();
    local name = GetNewNPCName("Young Bloodfly");
    SetPlayerName(npcarr.id, name);
    
    SetPlayerStrength(npcarr.id, 5);
    SetPlayerDexterity(npcarr.id, 5);
    SetPlayerLevel(npcarr.id, 3);
    SetPlayerMaxHealth(npcarr.id, 20);
    SetPlayerHealth(npcarr.id, 20);
    
    
    npcarr.func = YoungBloodfly;
    
    return npcarr;
end