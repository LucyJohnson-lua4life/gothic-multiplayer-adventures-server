require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
require "serverscripts/price_table"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local check_id = DIA_VIVIEN_QUEST_CHECKID
local dia_vlk_2000_vivien = {}
 
local function handleMissingBoyfriendDia(playerid, text)
    if string.match(text, "Gefallen") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Seit einigen Tagen habe ich nichts mehr von meinem <Freund> gehoert, ich mache mir langsam sorgen.")
        return true
    elseif string.match(text, "Freund") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Sein Name ist Rufus. Er hat sich vor etwa 1 Woche einem <Buddlertrupp> angeschlossen.")
        return true
    elseif string.match(text, "Buddlertrupp") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Anscheinend haben Sie in der Goldmine nahe Onars Hof eine neue geheime <Goldader> gefunden.")
        return true
    elseif string.match(text, "Goldader") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Genaueres weiss ich nicht darueber. Wenn du aber in die <Taverne> zur toten Harpie gehst. Solltest du mehr erfahren koennen.")
        return true
    elseif string.match(text, "Taverne") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Es ist gut moeglich dass die Buddlertruppe einen Zwischenstop dort gemacht hat. Am besten Fragst du dort den <Besitzer>.")
        return true
    elseif string.match(text, "Besitzer") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Frag den Besitzer am besten ueber den 'Buddlertrupp' aus. Er wird dir bestimmt weiter <helfen>");
        return true
    elseif string.match(text, "helfen") then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Vielen Dank! Wenn du Rufus siehst. Sag ihm bitte, dass es mir Leid tut und dass ich ihn schrecklich <vermisse>!");
        return true
    elseif string.match(text, "vermisse") then
        HasItem(playerid, "STANDARDBRIEF", check_id)
        return true
    else
        return false
    end
end

local function handleRufusLetterDia(playerid, item_instance, amount, equipped, checkid)
    if checkid == check_id and item_instance == "STANDARDBRIEF" and amount >= 1 then
        RemoveItem(playerid, "STANDARDBRIEF", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "STANDARDBRIEF")
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Ein Brief? Von Rufus?")
        SendPlayerMessage(playerid, 0, 0, 255, "Vivien liest den Brief und bricht zusammen...")
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Das darf nicht war sein... Das war alles meine Schuld...")
        SendPlayerMessage(playerid, 0, 255, 0, "Du hast die Quest beendet!")
        local goldToAdd = 500
        SetPlayerGold(playerid, GetPlayerGold(playerid) + goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd) .. " Gold erhalten.")
    elseif checkid == check_id then
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Hast du Rufus gefunden und ihm gesagt dass ich ihn <vermisse>?");
    end
end

function dia_vlk_2000_vivien.handleDialogue(playerid, text)
    
    if handleMissingBoyfriendDia(playerid, text) == true then
        return
    else
        -- INIT DIALOGUE
        SendPlayerMessage(playerid, 255, 255, 255, "Vivien sagt: Hallo Fremder! Darf ich dich um einen <Gefallen> bitten?")
    end

end

function dia_vlk_2000_vivien.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    handleRufusLetterDia(playerid, item_instance, amount, equipped, checkid)
end


return dia_vlk_2000_vivien
