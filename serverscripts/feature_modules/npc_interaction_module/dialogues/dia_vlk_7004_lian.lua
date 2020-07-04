require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
require "serverscripts/price_table"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local check_id = DIA_LIAN_FURSELL_CHECKID
local dia_vlk_7004_lian = {}

local function handleFurSellDialogue(playerid, text)
    if string.match(text, "Arbeit") then
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Eine helfende Hand kann ich immer gebrauchen!. Zurzeit komme ich mit meinen Auftraegen nicht hinterher. Ich brauche <Felle> aller Arten.")
        return true
    elseif string.match(text, "Felle") then
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Genau. Egal ob <Wolffell>, <Keilerfell>, <Wargfell>, <Schattenlaeuferfell>, oder <Trollfell>. Ich zahle fuer jedes Stueck nen guten Preis.")
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
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Ah gute alte Wolfsfelle, die verkaufen sich immer gut. Hier das Gold.")
        local goldToAdd = PRICE_TABLE["ITAT_WOLFFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_ADDON_KEILERFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_ADDON_KEILERFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_ADDON_KEILERFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Ah Keilerfelle. Die sind seltener. Dafuer kriegst du auch entsprechendes Gold.")
        local goldToAdd = PRICE_TABLE["ITAT_ADDON_KEILERFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_WARGFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_WARGFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_WARGFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Wargfelle? Die Biester sind gefaehrlich. Pass auf dass du dich nicht verletzt!")
        local goldToAdd = PRICE_TABLE["ITAT_WARGFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_SHADOWFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_SHADOWFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_SHADOWFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Ein Schattenlaeuferfell! Du hast was drauf. Das muss ich sagen. Hier du hast es verdient!")
        local goldToAdd = PRICE_TABLE["ITAT_SHADOWFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id and item_instance == "ITAT_TROLLFUR" and amount >= 1 then
        RemoveItem(playerid, "ITAT_TROLLFUR", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITAT_TROLLFUR")
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Ein Trollfell. Ich fass es nicht. Du bist ja ein wahrer Meisterjaeger!")
        local goldToAdd = PRICE_TABLE["ITAT_TROLLFUR"] * amount
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id then
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Tut mir Leid, aber es sieht nicht so aus als ob du brauchbare Felle hast.")
    end

end


function dia_vlk_7004_lian.handleDialogue(playerid, text)
    
    if handleFurSellDialogue(playerid, text) == true then
        return
    else
        -- INIT DIALOGUE
        SendPlayerMessage(playerid, 255, 255, 255, "Lian sagt: Helas! Was treibt dich hier durch die Waelder? Suchst du <Arbeit>?")
    end

end


function dia_vlk_7004_lian.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    
    handleFurSellRewardDialogue(playerid, item_instance, amount, equipped, checkid)

end


return dia_vlk_7004_lian
