require "serverscripts/player_globals"
local player_dao = require "serverscripts/daos/player_dao"
local inventory_dao = require "serverscripts/daos/inventory_dao"

local destroy_account_module = {}

local function sendDeletionMessage(playerid, player_deleted, inventory_deleted)
    if player_deleted and inventory_deleted then
        SendPlayerMessage(playerid,0,255,0, "Dein Account wurde geloescht. Starte das Spiel neu um einen neuen Account anzulegen.")
    else    
        SendPlayerMessage(playerid,255,0,0, "Etwas ist beim Loeschen des Accounts schief gelaufen.")
        SendPlayerMessage(playerid,255,0,0, "Du solltest dir einen neuen Account anlegen, weil die Integritaet dieses Accounts")
        SendPlayerMessage(playerid,255,0,0, "nicht mehr gewaehrleistet werden kann.")
    end
end

function destroy_account_module.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/destroy account" then
        local player_deleted = player_dao.deletePlayer(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid])
        local inventory_deleted = inventory_dao.deleteItemByPlayerName(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid])
        sendDeletionMessage(playerid, player_deleted, inventory_deleted)
    elseif cmdtext == "/destroy account help" then
        SendPlayerMessage(playerid, 230,230,230, "Tippe /destroy account ein um deinen Account zu loeschen.")
        SendPlayerMessage(playerid, 230,230,230, "Beachte, dass dein Account daraufhin sofort geloescht wird und keine weitere Nachfrage erfolgt.")
    end
end

return destroy_account_module