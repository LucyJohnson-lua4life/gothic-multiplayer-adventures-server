require "scripts/libs/AIFunctions"
require "scripts/libs/AI/AI_State"
local npc_fraction_module = {}

local light_tower_fraction = 1
local nr_lighttower_guards = 0

local kasern_fraction = 1
local nr_kasern_guards = 0



local function initNpcs()
    local world = "NEWWORLD\\NEWWORLD.ZEN"
    
    SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN") 
    nr_lighttower_guards = 7



    
    SpawnNPC(MilitiaOfficer(), "FP_STAND_KASERN_OFFICER", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(TrainingMilitia(), "FP_STAND_KASERN_TRAIN_01", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(TrainingMilitia(), "FP_STAND_KASERN_TRAIN_02", "NEWWORLD\\NEWWORLD.ZEN")
    SpawnNPC(TrainingMilitia(), "FP_STAND_KASERN_TRAIN_03", "NEWWORLD\\NEWWORLD.ZEN") 

    nr_kasern_guards = 4
    
end



function npc_fraction_module.OnGamemodeInit()
    initNpcs()
end

function npc_fraction_module.OnPlayerConnect(playerid)
    
end

function npc_fraction_module.OnPlayerDisconnect(playerid, reason)
    
end

function npc_fraction_module.OnPlayerKey(playerid, keydown, keyUp)

end

function npc_fraction_module.OnPlayerHit(playerid, killerid)

end

function npc_fraction_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)

end

function npc_fraction_module.OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped)

end

local function spawnLighthouseGuards()
    if light_tower_fraction == 1 then
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
        light_tower_fraction = 2
    else
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
        light_tower_fraction = 1
    end
end

local function spawnKasernGuards()
    if light_tower_fraction == 1 then
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinKing(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
        light_tower_fraction = 2
    else
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryKing(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
        light_tower_fraction = 1
    end
end

function npc_fraction_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    if IsNPC(playerid) and string.match(GetPlayerName(playerid), "Paladin King") then
        
        if nr_lighttower_guards <= 1 then
            spawnLighthouseGuards()
            nr_lighttower_guards = 7
            SendMessageToAll(39,199,130,"The lighttower was conquered");
        else
            nr_lighttower_guards = nr_lighttower_guards - 1
        end
    end
end



return npc_fraction_module