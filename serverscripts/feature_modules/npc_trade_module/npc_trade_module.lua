require "serverscripts/price_table"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"

-- TODO: this class needs some serious refactoring!

local inventory_dao = require "serverscripts/daos/inventory_dao"
local npc_trade_module = {}

local trader_npc = {}
local trade_checkid = NPC_TRADE_MODULE_CHECK_ID
trader_npc["Goffrey (1H Weapons)"] = {}
trader_npc["Phillipe (Armors)"] = {}
trader_npc["Brad the Hunter"] = {}
trader_npc["Ryan the Hunter"] = {}
trader_npc["Lian the Hunter"] = {}
trader_npc["Bryan (Armors)"] = {}
trader_npc["Gerald (2H Weapons)"] = {}

trader_npc["Goffrey (1H Weapons)"]["ItNm_LangschwertEdel"] = true
trader_npc["Goffrey (1H Weapons)"]["ItNm_Kriegsschwert"] = true
trader_npc["Goffrey (1H Weapons)"]["ItNm_Priestklinge"] = true
trader_npc["Goffrey (1H Weapons)"]["ItNm_Berserkerwort"] = true
trader_npc["Goffrey (1H Weapons)"]["ItNm_Jaegeraxt"] = true
trader_npc["Goffrey (1H Weapons)"]["ItNm_Raeuberaxt"] = true
trader_npc["Goffrey (1H Weapons)"]["ItNm_Streitkolben"] = true

trader_npc["Phillipe (Armors)"]["ItNm_Panzermantel1"] = true
trader_npc["Phillipe (Armors)"]["ItNm_Panzermantel2"] = true
trader_npc["Phillipe (Armors)"]["ItNm_Koenigsruestung"] = true
trader_npc["Phillipe (Armors)"]["ItNm_Goldruestung"] = true

trader_npc["Brad the Hunter"]["ItRw_Arrow"] = true
trader_npc["Brad the Hunter"]["ItMw_2H_Axe_L_01"] = true
trader_npc["Ryan the Hunter"]["ItRw_Arrow"] = true
trader_npc["Ryan the Hunter"]["ItMw_2H_Axe_L_01"] = true
trader_npc["Lian the Hunter"]["ItRw_Arrow"] = true
trader_npc["Lian the Hunter"]["ItMw_2H_Axe_L_01"] = true

trader_npc["Bryan (Armors)"]["ItNm_Landsknechtruestung"] = true
trader_npc["Bryan (Armors)"]["ItNm_Kriegerinruestung"] = true
trader_npc["Bryan (Armors)"]["ItNm_Rotetunika"] = true
trader_npc["Bryan (Armors)"]["ItNm_Kopfgeldjaegerruestung"] = true

trader_npc["Gerald (2H Weapons)"]["ItMw_2H_Axe_L_01"] = true
trader_npc["Gerald (2H Weapons)"]["ItNm_Berserkeraxt"] = true
trader_npc["Gerald (2H Weapons)"]["ItNm_Berserkerschwert"] = true


local TRADE_FOR_GOLD_FURS = {"ITAT_WARGFUR", "ITAT_SHADOWFUR", "ITAT_TROLLFUR", "ITAT_WOLFFUR", "ITAT_ADDON_KEILERFUR"}

local TRADE_ITEMS = {"ITMI_GOLDNUGGET_ADDON", "ITAT_WARGFUR", "ITAT_SHADOWFUR", "ITAT_TROLLFUR", "ITAT_WOLFFUR", "ITAT_ADDON_KEILERFUR"}

local function isTradeItem(item_instance)

    for k,v in pairs(TRADE_ITEMS) do
        if item_instance == v then
            return true
        end
    end

    return false
end

local function isHunterNpc(id)
    if IsNPC(id) and string.match(GetPlayerName(id), "Hunter") then
        return true
    end
    return false
end

local function isTraderNpc(playerid)
    if IsNPC(playerid) and trader_npc[GetPlayerName(playerid)] ~= nil then
        return true
    end
    return false
end


local function getFocusedTraderId(playerid)
    local npc_id = GetFocus(playerid)
    if isTraderNpc(npc_id) == true then
        return npc_id
    end
    return nil
end

local function hasEnoughGold(playerid, item_instance, anzahl)
    local price = PRICE_TABLE[item_instance]

    if price == nil then
        return false
    elseif price*anzahl > GetPlayerGold(playerid) then
        return false
    elseif price*anzahl <= GetPlayerGold(playerid) then
        return true
    end

    return false
end

local function buyItem(playerid, trader_id, item_instance, anzahl)
    local hasEnoughGold = hasEnoughGold(playerid, item_instance, anzahl)
    
    if trader_npc[GetPlayerName(trader_id)][item_instance] == nil then
        SendPlayerMessage(playerid,255,0,0, "Dein angefragter Gegenstand wurde nicht gefunden.")
    elseif hasEnoughGold == true then
        GiveItem(playerid, item_instance, anzahl)
        SetPlayerGold(playerid, GetPlayerGold(playerid)-anzahl*PRICE_TABLE[item_instance])
        SendPlayerMessage(playerid,0,255,0, "Du hast " .. anzahl .. "x " .. item_instance .. " bekommen.")
    elseif hasEnoughGold == false then
        SendPlayerMessage(playerid,255,0,0, "Du hast nicht genug Gold!")
    end
end

local function printHelpText(playerid, trader_id)
    SendPlayerMessage(playerid, 238, 221, 125, "Tippe '/list items' um zu sehen welche Gegenstaende vom NPC verkauft werden.")
    SendPlayerMessage(playerid, 238, 221, 125, "Tippe '/buy <item name> <anzahl>' um den Gegenstand zu kaufen.")
    SendPlayerMessage(playerid, 238, 221, 125, "Tippe '/trade gold' um Goldbrocken in Goldmuenzen einzutauschen.")
    if isHunterNpc(trader_id) then
        SendPlayerMessage(playerid, 238, 221, 125, "Tippe Felle gegen Gold zu tauschen, tippe eines dieser Befehle: ")
        SendPlayerMessage(playerid, 238, 221, 125, "'/shadowfur', '/wolffur', '/trollfur', '/wargfur', '/keilerfur' ")
    end

end

local function getInventoryList(npc_name)
    local message = "Zum Verkauf: "
    for k,v in pairs(trader_npc[tostring(npc_name)]) do
        message = message .. " " .. k .. " (" .. tostring(PRICE_TABLE[k]) .. " g),"
    end
    return message
end

function npc_trade_module.OnPlayerCommandText(playerid, cmdtext)
    local cmd,params = GetCommand(cmdtext);
    local parameter = params:split(" ")
 
    local trader_id = getFocusedTraderId(playerid)

    if cmdtext == "/trade help" and trader_id ~= nil then
        printHelpText(playerid, trader_id)
    end

    if cmdtext == "/list items" and trader_id ~= nil then
       SendPlayerMessage(playerid, 255, 255, 255, getInventoryList(GetPlayerName(trader_id))) 
    end

    if cmd == "/buy" then
        if parameter[1] ~= nil and parameter[2] ~= nil then
            buyItem(playerid, trader_id, parameter[1], parameter[2])
        elseif parameter[1] == nil then
            SendPlayerMessage(playerid, 255,0,0, "Du hast keinen Gegenstand ausgewaehlt.")
        elseif  parameter[2] == nil  then
            SendPlayerMessage(playerid, 255,0,0, "Du hast keine Mengenangabe angegeben.")
        end
    end

    if cmdtext == "/trade gold" then
        HasItem(playerid, "ITMI_GOLDNUGGET_ADDON", trade_checkid)
    end

    if cmdtext == "/wargfur" and isHunterNpc(trader_id) then
        HasItem(playerid, "ITAT_WARGFUR", trade_checkid)
    elseif cmdtext == "/shadowfur" then
        HasItem(playerid, "ITAT_SHADOWFUR", trade_checkid)
    elseif cmdtext == "/trollfur" then
        HasItem(playerid, "ITAT_TROLLFUR", trade_checkid)
    elseif cmdtext == "/wolffur" then
        HasItem(playerid, "ITAT_WOLFFUR", trade_checkid)
    elseif cmdtext == "/keilerfur" then
        HasItem(playerid, "ITAT_ADDON_KEILERFUR", trade_checkid)
    end

end

local function giveGoldForItem(playerid, item_instance, amount)
    local trade_amount = amount*PRICE_TABLE[item_instance]
    SetPlayerGold(playerid, GetPlayerGold(playerid)+trade_amount)
    SendPlayerMessage(playerid, 0, 255, 0, tostring(trade_amount).." Gold erhalten.")
    RemoveItem(playerid,item_instance,amount);
    inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], item_instance)
end


function npc_trade_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)

    if checkid == trade_checkid and isTradeItem(item_instance) then
      giveGoldForItem(playerid, item_instance, amount)
    end
end


function npc_trade_module.OnPlayerChangeHealth(playerid, currHealth, oldHealth)
    if isTraderNpc(playerid) == true then
        SetPlayerHealth(playerid, GetPlayerMaxHealth(playerid))
    end
end

return npc_trade_module