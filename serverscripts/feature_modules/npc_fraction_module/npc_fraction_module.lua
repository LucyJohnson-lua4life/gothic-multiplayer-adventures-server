require "scripts/libs/AIFunctions"
require "scripts/libs/AI/AI_State"
local npc_fraction_module = {}

local farm_fraction = 1
local nr_farm_guards = 0

local light_tower_fraction = 1
local nr_lighttower_guards = 0

local kasern_fraction = 1
local nr_kasern_guards = 0

local hq_fraction = 1
local nr_hq_guards = 0

local function spawnFarmGuards()
    if farm_fraction == 1 then
        SpawnNPC(MilitiaOfficer(), "FP_STAND_FARM_GUARD_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_FARM_GUARD_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_FARM_GUARD_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_FARM_GUARD_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_FARM_GUARD_05", "NEWWORLD\\NEWWORLD.ZEN")

    else
        SpawnNPC(MercenaryOfficer(), "FP_STAND_FARM_GUARD_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_FARM_GUARD_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_FARM_GUARD_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_FARM_GUARD_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_FARM_GUARD_05", "NEWWORLD\\NEWWORLD.ZEN")
    end
end

local function spawnLighthouseGuards()
    if light_tower_fraction == 1 then
        SpawnNPC(KnightGuard(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaOfficer(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaOfficer(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
    else
        SpawnNPC(MercenaryEliteGuard(), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryOfficer(), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryOfficer(), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard(), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
    end
end

local function spawnKasernGuards()
    if kasern_fraction == 1 then
        SpawnNPC(PaladinGuard(), "FP_STAND_KASERN_KNIGHT_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(KnightGuard(), "FP_STAND_KASERN_KNIGHT_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(KnightGuard(), "FP_STAND_KASERN_KNIGHT_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaOfficer(), "FP_STAND_KASERN_OFFICER", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMilitia(), "FP_STAND_KASERN_TRAIN_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMilitia(), "FP_STAND_KASERN_TRAIN_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMilitia(), "FP_STAND_KASERN_TRAIN_03", "NEWWORLD\\NEWWORLD.ZEN") 
    else
        SpawnNPC(MercenaryRoyalGuard(), "FP_STAND_KASERN_KNIGHT_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryEliteGuard(), "FP_STAND_KASERN_KNIGHT_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryEliteGuard(), "FP_STAND_KASERN_KNIGHT_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryOfficer(), "FP_STAND_KASERN_OFFICER", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMercenary(), "FP_STAND_KASERN_TRAIN_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMercenary(), "FP_STAND_KASERN_TRAIN_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMercenary(), "FP_STAND_KASERN_TRAIN_03", "NEWWORLD\\NEWWORLD.ZEN") 
    end
end

local function spawnHqGuards()
    if hq_fraction == 1 then
        SpawnNPC(PaladinKing(), "FP_STAND_HQ_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard(), "FP_STAND_HQ_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard(), "FP_STAND_HQ_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard(), "FP_STAND_HQ_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard(), "FP_STAND_HQ_05", "NEWWORLD\\NEWWORLD.ZEN")
    else
        SpawnNPC(MercenaryKing(), "FP_STAND_HQ_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard(), "FP_STAND_HQ_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard(), "FP_STAND_HQ_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard(), "FP_STAND_HQ_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard(), "FP_STAND_HQ_05", "NEWWORLD\\NEWWORLD.ZEN")
    end
end

local function initNpcs()
    
    spawnFarmGuards()
    nr_farm_guards = 5

    spawnLighthouseGuards()
    nr_lighttower_guards = 7
    

    spawnKasernGuards()
    nr_kasern_guards = 7

    spawnHqGuards()
    nr_hq_guards = 5
    
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





function npc_fraction_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    if IsNPC(playerid) and string.match(GetPlayerName(playerid), "FG") then

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