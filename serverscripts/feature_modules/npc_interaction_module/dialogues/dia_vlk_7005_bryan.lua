require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local check_id = DIA_BRYAN_BANDITHEADS_CHECKID
local dia_vlk_7005_bryan = {}

local function handleBanditDialogue(playerid, text)
    if string.match(text, "Arbeit") then
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Seit Monaten lungern in der Gegend Banditen rum und runieren meine Handelswege. Wenn das so weiter geht, dann kann ich mein Geschaeft bald schliessen! Ich brauche jemanden der diese <Mistkerle> erledigt.")
        return true
    elseif string.match(text, "Mistkerle") then
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Genau Mistkerle! Spuere so viele von den Typen auf und bring mir ihre <Koepfe>. Fuer jeden Kopf zahle ich dir 100 Goldmuenzen!")
        return true
    elseif string.match(text, "Koepfe") then
        HasItem(playerid, "ITMI_ADDON_BLOODWYN_KOPF", DIA_BRYAN_BANDITHEADS_CHECKID)
        return true
    else
        return false
    end

end

local function handleBanditRewardDialogue(playerid,item_instance, amount, equipped, checkid)
    if checkid == check_id and item_instance == "ITMI_ADDON_BLOODWYN_KOPF" and amount >= 1 then
        RemoveItem(playerid, "ITMI_ADDON_BLOODWYN_KOPF", amount)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITMI_ADDON_BLOODWYN_KOPF")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Auf dich ist verlass! Hier nimm das Gold, du hast es dir verdient!")
        local goldToAdd = 100*amount
        SetPlayerGold(playerid, GetPlayerGold(playerid)+goldToAdd)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(goldToAdd).." Gold erhalten.")
    elseif checkid == check_id then
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Tut mir Leid, aber es sieht nicht so aus als haettest du die <Koepfe>. Komm wieder wenn du welche hast.")
    end

end


function dia_vlk_7005_bryan.handleDialogue(playerid, text)
    
    if handleBanditDialogue(playerid, text) == true then
        return
    else
        -- INIT DIALOGUE
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Hm? Willst du was kaufen oder suchst du <Arbeit>?")
    end

end


function dia_vlk_7005_bryan.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    
    handleBanditRewardDialogue(playerid,item_instance, amount, equipped, checkid)

end


return dia_vlk_7005_bryan