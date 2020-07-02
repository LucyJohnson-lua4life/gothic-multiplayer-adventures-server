
require "serverscripts/has_item_globals"
local teleport = {}

local Player = {}

--1: check id for cmd = "/tps"
--2: check id for cmd = "/tp"
local check_ids = {}
local ACTIVATION_ITEM = "ITMI_GOLDRING"
check_ids["tps"] = SPELLS_MODULE_CHECK_ID1
check_ids["tp"] = SPELLS_MODULE_CHECK_ID2
check_ids["introduction"] = SPELLS_MODULE_CHECK_ID3

local function savePlayerPos(playerid)
    if Player[playerid] == nil then
        Player[playerid] = {}
    end

    local x,y,z = GetPlayerPos(playerid)
    
    Player[playerid].tp_x = x
    Player[playerid].tp_y = y
    Player[playerid].tp_z = z
    SendPlayerMessage(playerid,255,255,255,"Speichere Position: " .. x .. ", " .. y .. ", " .. z .. ".")
end


local function tpToSavedPos(playerid)
    if Player[playerid].tp_x ~= nil and Player[playerid].tp_y ~= nil and Player[playerid].tp_z ~= nil then
        SetPlayerPos(playerid, Player[playerid].tp_x, Player[playerid].tp_y, Player[playerid].tp_z)
        SendPlayerMessage(playerid,255,255,255,"Zur gespeicherten Position teleportiert.")
    end
end

local function checkRequirementsAndTp(playerid)
    local necessary_health = GetPlayerMaxHealth(playerid)/100*75
    if GetPlayerHealth(playerid) >= necessary_health then
        SetPlayerHealth(playerid, GetPlayerHealth(playerid) - necessary_health)
        tpToSavedPos(playerid)
    elseif GetPlayerHealth(playerid) < necessary_health then
        SendPlayerMessage(playerid, 255, 0, 0, "Du hast nicht genug Lebenspunkte fuer die Teleportation.")
    end
end

function teleport.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/tps" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["tps"])
    elseif cmdtext == "/tp" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["tp"])
    elseif cmdtext == "/goldring help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Der Goldring besitzt die Macht der Teleportation.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/tps' ein um dir eine Position zu merken.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/tp' ein um dich in die gemerkte Position zu teleportieren.")
end

function teleport.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["tps"] then
            savePlayerPos(playerid)
        elseif checkid == check_ids["tp"] then
            checkRequirementsAndTp(playerid)
        elseif checkid == check_ids["introduction"] then
            sendIntroductionMessage(playerid)
        end
    end
end

function teleport.OnPlayerDisconnect(playerid, reason)
    Player[playerid] = nil
end

function teleport.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    Player[playerid] = nil
end


return teleport

