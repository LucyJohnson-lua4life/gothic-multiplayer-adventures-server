
function Gobbo_Black()
    local npc = CreateNPC(GetNewNPCName("Black Goblin"));
    
    if(npc == -1)then
        print("Creating Gobbo_Black Failed!");
    end
    
    SetPlayerInstance(npc,"Gobbo_Black");
    
    SetPlayerStrength(npc, 110);
    SetPlayerDexterity(npc, 110);
    SetPlayerLevel(npc, 8);
    SetPlayerMaxHealth(npc, 300);
    SetPlayerHealth(npc, 300);
    
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
    npcarr.func = Gobbo_Black;
    
    
    return npcarr;
end



function Gobbo_Warrior()
    local npcArray = Gobbo_Black();
    local name = GetNewNPCName("Gobbo Warrior");
    SetPlayerName(npcArray.id, name);
    
    
    SetPlayerStrength(npcArray.id, 125);
    SetPlayerDexterity(npcArray.id, 125);
    SetPlayerLevel(npcArray.id, 15);
    SetPlayerMaxHealth(npcArray.id, 510);
    SetPlayerHealth(npcArray.id, 510);
    npcArray.func = Gobbo_Warrior;
    
    return npcArray;
end