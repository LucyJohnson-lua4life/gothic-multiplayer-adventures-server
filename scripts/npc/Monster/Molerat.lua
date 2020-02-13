
function Molerat()
    local npc = CreateNPC(GetNewNPCName("Molerat"));
    
    if(npc == -1)then
        print("Creating Molerat Failed!");
    end
    
    SetPlayerInstance(npc,"Molerat");
    
    SetPlayerStrength(npc, 25);
    SetPlayerDexterity(npc, 25);
    SetPlayerLevel(npc, 5);
    SetPlayerMaxHealth(npc, 50);
    SetPlayerHealth(npc, 50);
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Molerat;
    npcarr.func = Molerat;
    
    return npcarr;
end

function YoungMolerat()
    local npcArray = Molerat();--A normal Wolf will be created
    local youngwolfname = GetNewNPCName("Young Molerat");
    SetPlayerName(npcArray.id, youngwolfname);
    
    SetPlayerStrength(npcArray.id, 20);
    SetPlayerDexterity(npcArray.id, 20);
    SetPlayerLevel(npcArray.id, 2);
    SetPlayerMaxHealth(npcArray.id, 10);
    SetPlayerHealth(npcArray.id, 10);
    
    npcArray.func = YoungMolerat;
    
    
    
    return npcArray;
end