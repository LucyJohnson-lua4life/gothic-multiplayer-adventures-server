require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
local inventory_dao = require "serverscripts/daos/inventory_dao"
--string.match(GetPlayerName(id), "Hunter")
--ItMi_Addon_Bloodwyn_Kopf
--ItWr_SaturasFirstMessage_Addon
local npc_quest_module = {}
local QUEST_ID = NPC_QUEST_MODULE_CHECK_ID


local function handlePhillipe(playerid, text)
    
    if string.match(text, "Problem") then
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Ich habe heute erfahren, dass mein Bote von Banditen umgelegt wurde.")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Wenn das so weiter geht, dann kann ich mein Geschaeft bald schliessen!")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Wenn du diese Banditen aufspueren und mir ihre <Koepfe> bringen koenntest...")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: dann wuerdest du mir einen Riesen gefallen tun. Sagen wir 3 von denen...")
    elseif string.match(text, "Koepfe") then
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Wunderbar! Nimm diesen Ring hier. Er soll dir Glueck auf deinem Weg geben...")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Sag mir bescheid wenn du deine Aufgabe <erledigt> hast.")
        GiveItem(playerid, "ITRI_RANGER_ADDON", 1)
    elseif string.match(text, "erledigt") then
        HasItem(playerid, "ITMI_ADDON_BLOODWYN_KOPF", QUEST_ID)
    else
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Hey hast du Lust mir bei meinem <Problem> zu helfen?")
    end

end


function npc_quest_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)

    if checkid == QUEST_ID and item_instance == "ITMI_ADDON_BLOODWYN_KOPF" and amount >= 3 then
        RemoveItem(playerid, "ITRI_RANGER_ADDON", 1)
        RemoveItem(playerid, "ITMI_ADDON_BLOODWYN_KOPF", 3)
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITRI_RANGER_ADDON")
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], "ITMI_ADDON_BLOODWYN_KOPF")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Wunderbar! Jetzt kann ich hoffentlich wieder meine Boten rausschicken.")
        SendPlayerMessage(playerid, 255, 255, 255, "Bryan sagt: Hier nimm das Gold zu Belohnung.")
        SetPlayerGold(playerid, GetPlayerGold(playerid)+200)
        SendPlayerMessage(playerid, 0, 255, 0, tostring(200).." Gold erhalten.")
    end
end


function npc_quest_module.OnPlayerCommandText(playerid, cmdtext)
    
    local npc_id = GetFocus(playerid)
    
    local npc_name = GetPlayerName(npc_id)
    
    local cmd, text = GetCommand(cmdtext);
    if cmd == "/t" and IsNPC(npc_id) then
        
        if npc_name == "Bryan (Armors)" then
            handlePhillipe(playerid, text)
        end
    
    end

    if cmd == "/debug" then
        GiveItem(playerid, "ITMI_ADDON_BLOODWYN_KOPF", 3)
    end


end










return npc_quest_module
