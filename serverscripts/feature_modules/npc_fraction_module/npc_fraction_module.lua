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
        SpawnNPC(MilitiaOfficer("FG"), "FP_STAND_FARM_GUARD_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("FG"), "FP_STAND_FARM_GUARD_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("FG"), "FP_STAND_FARM_GUARD_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("FG"), "FP_STAND_FARM_GUARD_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("FG"), "FP_STAND_FARM_GUARD_05", "NEWWORLD\\NEWWORLD.ZEN")
        farm_fraction = 2

    else
        SpawnNPC(MercenaryOfficer("FG"), "FP_STAND_FARM_GUARD_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("FG"), "FP_STAND_FARM_GUARD_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("FG"), "FP_STAND_FARM_GUARD_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("FG"), "FP_STAND_FARM_GUARD_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("FG"), "FP_STAND_FARM_GUARD_05", "NEWWORLD\\NEWWORLD.ZEN")
        farm_fraction = 1
    end
end

local function spawnLighthouseGuards()
    if light_tower_fraction == 1 then
        SpawnNPC(KnightGuard("LG"), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaOfficer("LG"), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaOfficer("LG"), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("LG"), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("LG"), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("LG"), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaGuard("LG"), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
        light_tower_fraction = 2
    else
        SpawnNPC(MercenaryEliteGuard("LG"), "FP_STAND_LIGHTHOUSE_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryOfficer("LG"), "FP_STAND_LIGHTHOUSE_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryOfficer("LG"), "FP_STAND_LIGHTHOUSE_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("LG"), "FP_STAND_LIGHTHOUSE_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("LG"), "FP_STAND_LIGHTHOUSE_05", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("LG"), "FP_STAND_LIGHTHOUSE_06", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryGuard("LG"), "FP_STAND_LIGHTHOUSE_07", "NEWWORLD\\NEWWORLD.ZEN")
        light_tower_fraction = 1
    end
end

local function spawnKasernGuards()
    if kasern_fraction == 1 then
        SpawnNPC(PaladinGuard("KG"), "FP_STAND_KASERN_KNIGHT_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(KnightGuard("KG"), "FP_STAND_KASERN_KNIGHT_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(KnightGuard("KG"), "FP_STAND_KASERN_KNIGHT_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MilitiaOfficer("KG"), "FP_STAND_KASERN_OFFICER", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMilitia("KG"), "FP_STAND_KASERN_TRAIN_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMilitia("KG"), "FP_STAND_KASERN_TRAIN_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMilitia("KG"), "FP_STAND_KASERN_TRAIN_03", "NEWWORLD\\NEWWORLD.ZEN") 
        kasern_fraction = 2
    else
        SpawnNPC(MercenaryRoyalGuard("KG"), "FP_STAND_KASERN_KNIGHT_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryEliteGuard("KG"), "FP_STAND_KASERN_KNIGHT_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryEliteGuard("KG"), "FP_STAND_KASERN_KNIGHT_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryOfficer("KG"), "FP_STAND_KASERN_OFFICER", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMercenary("KG"), "FP_STAND_KASERN_TRAIN_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMercenary("KG"), "FP_STAND_KASERN_TRAIN_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(TrainingMercenary("KG"), "FP_STAND_KASERN_TRAIN_03", "NEWWORLD\\NEWWORLD.ZEN") 
        kasern_fraction = 1
    end
end

local function spawnHqGuards()
    if hq_fraction == 1 then
        SpawnNPC(PaladinKing("HG"), "FP_STAND_HQ_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard("HG"), "FP_STAND_HQ_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard("HG"), "FP_STAND_HQ_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard("HG"), "FP_STAND_HQ_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(PaladinGuard("HG"), "FP_STAND_HQ_05", "NEWWORLD\\NEWWORLD.ZEN")
        hq_fraction = 2
    else
        SpawnNPC(MercenaryKing("HG"), "FP_STAND_HQ_01", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard("HG"), "FP_STAND_HQ_02", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard("HG"), "FP_STAND_HQ_03", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard("HG"), "FP_STAND_HQ_04", "NEWWORLD\\NEWWORLD.ZEN")
        SpawnNPC(MercenaryRoyalGuard("HG"), "FP_STAND_HQ_05", "NEWWORLD\\NEWWORLD.ZEN")
        hq_fraction = 1
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


local function handleFg()
    if nr_farm_guards <= 1 then
        spawnFarmGuards()
        nr_lighttower_guards = 5
        SendMessageToAll(39,199,130,"The farm was conquered");
    else
        nr_farm_guards = nr_farm_guards -1
    end
end

local function handleLg()
    if nr_lighttower_guards <= 1 then
        spawnLighthouseGuards()
        nr_lighttower_guards = 7
        SendMessageToAll(39,199,130,"The lighttower was conquered");
    else
        nr_lighttower_guards = nr_lighttower_guards -1
    end
end

local function handleKg()
    if nr_kasern_guards <= 1 then
        spawnKasernGuards()
        nr_kasern_guards = 7
        SendMessageToAll(39,199,130,"The kasern was conquered");
    else
        nr_kasern_guards = nr_kasern_guards -1
    end
end

local function handleHg()
    if nr_hq_guards <= 1 then
        spawnHqGuards()
        nr_hq_guards = 5
        SendMessageToAll(39,199,130,"The headquarter was conquered");
    else
        nr_hq_guards = nr_hq_guards -1
    end
end

local function getDistrictNameFromNpc(name)
    if string.match(name, "FG") then
        return "FG"
    elseif string.match(name, "LG") then
        return "LG"
    elseif string.match(name, "KG") then
        return "KG"
    elseif string.match(name, "HQ") then
        return "HQ"
    else
        return ""
    end
end

function npc_fraction_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    
    if IsNPC(playerid) then
        local district_name = getDistrictNameFromNpc(GetPlayerName(playerid))
        if district_name == "FG" then
            handleFg()
        elseif district_name == "LG" then
            handleLg()    
        elseif district_name == "KG" then
            handleKg()
        elseif district_name == "HG" then
            handleHg()
        end

    end
end

function npc_fraction_module.OnPlayerUnconscious(playerid, p_classid, killerid, k_classid)
   
    if IsNPC(playerid) == 1 then
        if  getDistrictNameFromNpc(GetPlayerName(playerid))~="" then
            SetPlayerHealth(playerid, 0)
        end
    elseif IsNPC(killerid) == 1 then
       if  getDistrictNameFromNpc(GetPlayerName(killerid))~="" then
        SetPlayerHealth(playerid, 0)
       end
    end
end


return npc_fraction_module