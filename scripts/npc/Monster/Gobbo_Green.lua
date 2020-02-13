
function Gobbo_Green()
    local npc = CreateNPC(GetNewNPCName("Goblin"));
    
    if(npc == -1)then
        print("Creating Gobbo_Green Failed!");
    end
    
    SetPlayerInstance(npc,"Gobbo_Green");
    
    SetPlayerStrength(npc, 20);
    SetPlayerDexterity(npc, 20);
    SetPlayerLevel(npc, 7);
    SetPlayerMaxHealth(npc, 20);
    SetPlayerHealth(npc, 20);
    
    EquipMeleeWeapon(npc, "ItMw_1h_Bau_Mace");
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Goblin;
    npcarr.GotEnemyFunc = AI_GOTENEMY_MONSTER_FLEE;
    npcarr.func = Gobbo_Green;
    
    return npcarr;
end


function YoungGobbo_Green()
    local npcarr = Gobbo_Green();
    local name = GetNewNPCName("Young Goblin");
    SetPlayerName(npcarr.id, name);
    
    SetPlayerStrength(npcarr.id, 5);
    SetPlayerDexterity(npcarr.id, 5);
    SetPlayerLevel(npcarr.id, 3);
    SetPlayerMaxHealth(npcarr.id, 20);
    SetPlayerHealth(npcarr.id, 20);
    
    
    npcarr.func = YoungGobbo_Green;
    
    return npcarr;
end


function Gobbo_Mutation()
    local npc = CreateNPC(GetNewNPCName("Mutated Gobbo"));
    
    if(npc == -1)then
        print("Creating Gobbo_Mutation Failed!");
    end
    
    SetPlayerInstance(npc,"Gobbo_Green");
    
    SetPlayerStrength(npc, 125);
    SetPlayerDexterity(npc, 800);
    SetPlayerLevel(npc, 7);
    SetPlayerMaxHealth(npc, 500);
    SetPlayerHealth(npc, 500);
    SetPlayerScale(npc, 3.0, 3.0, 3.0)
    SetPlayerSkillWeapon(npc, SKILL_1H, 50);
    EquipMeleeWeapon(npc, "ItMw_Folteraxt");
    
    npcarr = {};
    npcarr.id = npc;
    npcarr.daily_routine = DR_Monster_MidEat;
    npcarr.attack_routine = FAI_WOLF_ATTACK;
    npcarr.WeaponMode = 0;
    npcarr.dialogs = nil;
    npcarr.update_func = AI_UP_MONSTER;
    npcarr.target_routine = AI_TA_MONSTER;
    npcarr.onhitted = ON_WOLF_HIT;
    npcarr.Guild = AI_GUILD_Goblin;
    npcarr.GotEnemyFunc = AI_GOTENEMY_MONSTER_FLEE;
    npcarr.func = Gobbo_Green;
    
    return npcarr;
end