require "serverscripts/has_item_globals"
require "serverscripts/player_globals"
local class_globals = require "serverscripts/class_globals"
local player_dao = require "serverscripts/daos/player_dao"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local vampirism = {}

local check_ids = {}
local ACTIVATION_ITEM = "ITAT_TEETH"
check_ids["transform"] = SPELLS_MODULE_CHECK_ID1
check_ids["introduction"] = SPELLS_MODULE_CHECK_ID2

local function loadPlayerInventory(handler, playerid, name)
    local items = inventory_dao.getAllItemsAndAmountByName(handler, name)
    inventory_dao.deleteItemByPlayerName(handler, name)
    if(items ~= nil) then
        while true do
            local row = mysql_fetch_assoc(items)
            if (not row) then break end
            GiveItem(playerid, row["item_name"], row["amount"])
        end    
        mysql_free_result(items)
    else
        SendPlayerMessage(playerid,0,255,0,"Error selecting player.")
    end
end

local function transformToHuman(playerid)
    local result = player_dao.getClass(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid])
    if result ~= nil then
        local row = mysql_fetch_assoc(result)
        if row ~= nil and row["class_id"] ~= nil then
            SetPlayerInstance(playerid, "PC_HERO")
            class_globals.setClassAttributes(playerid, tonumber(row["class_id"]))
        end
    end
    loadPlayerInventory(PLAYER_HANDLER_MAP[playerid], playerid,  PLAYER_ID_NAME_MAP[playerid])
end

local function is_night_time(hour)
    if hour > 18 or hour < 6  then
        return true
    end
    return false
end

local function transform(playerid)
    local hour,_ = GetTime();
       
    if GetPlayerInstance(playerid) == "PC_HERO" and is_night_time(hour) then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["transform"])
    elseif GetPlayerInstance(playerid) == "BLOODFLY" then
        transformToHuman(playerid)
    elseif is_night_time(hour) == false then
        SendPlayerMessage(playerid, 255,0,0, "Deine Kraefte funktionieren erst in der Abenddaemmerung!")
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Die Zaehne verleihen dir Vampirismus.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/vampire transform' bei Nacht ein um dich in eine Blutfliege zu verwandeln.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/vampire transform' nochmal ein um dich zurück zu einem Menschen zu verwandeln.")
end

function vampirism.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/vampire transform" then
        transform(playerid)
    elseif cmdtext == "/teeth help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

function vampirism.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["transform"] then
            SetPlayerInstance(playerid, "BLOODFLY")
            SetPlayerHealth(playerid, 1000)
            SetPlayerMaxHealth(playerid, 1000)
            SetPlayerStrength(playerid, 100)
        elseif checkid == check_ids["introduction"] then
            sendIntroductionMessage(playerid)
        end
    end
end

return vampirism;