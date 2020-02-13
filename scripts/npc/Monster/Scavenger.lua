
function Scavenger()
    local npc = CreateNPC(GetNewNPCName("Scavenger"));
    
    if(npc == -1)then
        print("Creating Scavenger Failed!");
    end
    
    SetPlayerInstance(npc,"Scavenger");
    
    SetPlayerStrength(npc, 150);
    SetPlayerDexterity(npc, 80);
    SetPlayerLevel(npc, 7);
    SetPlayerMaxHealth(npc, 300);
    SetPlayerHealth(npc, 300);
    
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Scavenger;
    npcarr.GotEnemyFunc = AI_GOTENEMY_MONSTER_FLEE;
    npcarr.func = Scavenger;
    
    return npcarr;
end

function YoungScavenger()
    local npcarr = Scavenger();--A normal Wolf will be created
    local name = GetNewNPCName("Young Scavenger");
    SetPlayerName(npcarr.id, name);
    
    SetPlayerStrength(npcarr.id, 6);
    SetPlayerDexterity(npcarr.id, 6);
    SetPlayerLevel(npcarr.id, 4);
    SetPlayerMaxHealth(npcarr.id, 20);
    SetPlayerHealth(npcarr.id, 20);
    npcarr.func = YoungScavenger;
    
    
    return npcarr;
end

function ScavengerDemon()
    local npcarr = Scavenger();--A normal Wolf will be created
    local name = GetNewNPCName("Demon Scavenger");
    SetPlayerName(npcarr.id, name);
    
    SetPlayerInstance(npcarr.id,"Scavenger_Demon");
    
    SetPlayerStrength(npcarr.id, 60);
    SetPlayerDexterity(npcarr.id, 60);
    SetPlayerLevel(npcarr.id, 12);
    SetPlayerMaxHealth(npcarr.id, 120);
    SetPlayerHealth(npcarr.id, 120);
    npcarr.func = ScavengerDemon;
    
    
    return npcarr;
end