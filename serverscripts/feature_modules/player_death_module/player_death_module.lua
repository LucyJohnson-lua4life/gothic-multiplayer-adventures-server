require "serverscripts/player_globals"
require "serverscripts/player_respawn_points"
local player_dao = require "serverscripts/daos/player_dao"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local class_globals = require "serverscripts/class_globals"
local player_gold_dao = require "serverscripts/daos/player_gold_dao"

local RESPAWN_TIME_SECS = 3
local time_player_dead = {}
local player_death_module = {}
local player_death_timer = {}


local function getPlayerGoldAmount(handler, name)
    local row = mysql_fetch_assoc(player_gold_dao.getAmount(handler, name))
    local current_gold = row["amount"]
    if current_gold == nil then
        return 0
    end
    return tonumber(current_gold)
end


local function loadStarterItems(handler, name, class_id)
    player_dao.updatePlayerArmor(handler, name, CLASS_ARMOR[class_id])
    player_dao.updatePlayerMelee(handler, name, CLASS_MELEE_WEAPON[class_id])
end

local function respawnPlayer(playerid)
    local result = player_dao.getClass(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid])

    if result ~= nil then
        local row = mysql_fetch_assoc(result)
        if row ~= nil and row["class_id"] ~= nil then
            local player_gold_amount = getPlayerGoldAmount(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid])
            SpawnPlayer(playerid)
            local respawnPos = PLAYER_RESPAWN_POINTS[math.random(table.getn(PLAYER_RESPAWN_POINTS))]
            SetPlayerPos(playerid, respawnPos[1], respawnPos[2], respawnPos[3])
            class_globals.setClassAttributes(playerid, tonumber(row["class_id"]))
            class_globals.setClassInventory(playerid, tonumber(row["class_id"]))
            loadStarterItems(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], tonumber(row["class_id"]))
            SetPlayerGold(playerid, player_gold_amount)
        end
    end
end



function CheckDeadPlayersForRespawn()
    for k, v in pairs(time_player_dead) do
        if(os.clock() - v > RESPAWN_TIME_SECS) then
            time_player_dead[k] = nil;
            KillTimer(player_death_timer[k])
            player_death_timer[k] = nil
            respawnPlayer(k);
        end
    end
end



local function removePlayerItems(handler, name)
    player_dao.updatePlayerArmor(handler, name, "NULL")
    player_dao.updatePlayerMelee(handler, name, "NULL")
    player_dao.updatePlayerRanged(handler, name, "NULL")
    inventory_dao.deleteItemByPlayerName(handler, name)
end
 
function player_death_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
   if IsNPC(playerid) == 0 then
        SendPlayerMessage(playerid, 255,0,0, "Du ist gestorben, respawn geschieht in 10 Sekunden.")
        removePlayerItems(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid])
        time_player_dead[playerid] = os.clock()
        player_death_timer[playerid] = SetTimer("CheckDeadPlayersForRespawn",2000,1);
   end
end

function player_death_module.OnPlayerDisconnect(playerid, reason)
    if time_player_dead[playerid] ~= nil then
        time_player_dead[playerid] = nil
    end
    if player_death_timer[playerid] ~= nil then 
        KillTimer(player_death_timer[playerid])
        player_death_timer[playerid] = nil
    end
end


return player_death_module