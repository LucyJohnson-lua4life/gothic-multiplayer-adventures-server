require "serverscripts/player_globals"
local player_gold_module = {}
local player_gold_dao = require "serverscripts/daos/player_gold_dao"

function player_gold_module.OnPlayerChangeGold(playerid, currGold, oldGold)
    if IsDead(playerid) == 0 then
        player_gold_dao.updateItemAmount(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], currGold)
    end
end


return player_gold_module