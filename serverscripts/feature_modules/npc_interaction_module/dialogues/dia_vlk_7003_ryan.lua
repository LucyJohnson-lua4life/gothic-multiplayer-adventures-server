require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
require "serverscripts/price_table"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local check_id = DIA_RYAN_FURSELL_CHECKID
local dia_vlk_7003_ryan = {}

local function handleFurSellDialogue(playerid, text)
    if string.match(text, "Arbeit") then
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Prima zurzeit bin ich sehr beschaeftigt und es gibt eine Menge <Felle> die ich jagen muss.")
        return true
    elseif string.match(text, "Felle") then
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Egal ob <Wolffell>, <Keilerfell>, <Wargfell>, <Schattenlaeuferfell>, oder <Trollfell>. Ich zahle fuer jedes Stueck nen guten Preis.")
        return true
    elseif string.match(text, "Wolffell") then
        HasItem(playerid, "ITAT_WOLFFUR", check_id)
        return true
    elseif string.match(text, "Keilerfell") then
        HasItem(playerid, "ITAT_ADDON_KEILERFUR", check_id)
        return true
    elseif string.match(text, "Wargfell") then
        HasItem(playerid, "ITAT_WARGFUR", check_id)
        return true
    elseif string.match(text, "Schattenlaeuferfell") then
        HasItem(playerid, "ITAT_SHADOWFUR", check_id)
        return true
    elseif string.match(text, "Trollfell") then
        HasItem(playerid, "ITAT_TROLLFUR", check_id)
        return true
    else
        return false
    end
end

local function handleFurSellRewardDialogue(playerid, item_instance, amount, equipped, checkid)
    if checkid == check_id and item_instance == "ITAT_WOLFFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_WOLFFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_WOLFFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Wolfsfelle! Die sind immer gut. Hier das Gold.")
        local goldToAdd = PRICE_TABLE["ITAT_WOLFFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_ADDON_KEILERFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_ADDON_KEILERFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_ADDON_KEILERFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Ah, Keiler findet man nicht so haeufig hier. Dafuer kriegst du auch ein bisschen mehr.")
        local goldToAdd = PRICE_TABLE["ITAT_ADDON_KEILERFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_WARGFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_WARGFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_WARGFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Aye, du traust dich sogar an Wargs ran? Nimm das fuer deinen Mut.")
        local goldToAdd = PRICE_TABLE["ITAT_WARGFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_SHADOWFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_SHADOWFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_SHADOWFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Ein Schattenlaeuferfell! Mann du bist mir einer. Hier nimm das Gold")
        local goldToAdd = PRICE_TABLE["ITAT_SHADOWFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_TROLLFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_TROLLFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_TROLLFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: DU hast einen Troll erlegt? Wir haben ja einen richtigen Profi in unseren Reihen!")
        local goldToAdd = PRICE_TABLE["ITAT_TROLLFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id then
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Tut mir Leid, aber es sieht nicht so aus als ob du brauchbare Felle hast.")
    end

end


function dia_vlk_7003_ryan.handleDialogue(playerid, text)
    
    if handleFurSellDialogue(playerid, text) == true then
        return
    else
        -- INIT DIALOGUE
        SendPlayerMessage(playerid, 255, 255, 255, "Ryan sagt: Psst! Du verscheuchst hier das Wild! Was willst du? Suchst du <Arbeit>?")
    end

end


function dia_vlk_7003_ryan.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    
    handleFurSellRewardDialogue(playerid, item_instance, amount, equipped, checkid)

end


return dia_vlk_7003_ryan
