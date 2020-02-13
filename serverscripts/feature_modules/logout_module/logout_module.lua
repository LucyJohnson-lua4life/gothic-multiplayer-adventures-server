require "serverscripts/player_globals"
local player_dao = require "serverscripts/daos/player_dao"

local player_logout_timer = {}
local time_till_logout = {}
local logout_module = {}
local LOGOUT_TIME_SECS = 1;

local function playerLoggedIn(playerid)
    return PLAYER_ID_NAME_MAP[playerid] ~= nil
end

function CheckForPlayerLogout()
    for k, v in pairs(time_till_logout) do
        if(os.clock() - v > LOGOUT_TIME_SECS) then
            if playerLoggedIn(k) then
                local x,y,z = GetPlayerPos(k);
                player_dao.updatePlayerPos(PLAYER_HANDLER_MAP[k], PLAYER_ID_NAME_MAP[k], math.floor(x + 0.5),math.floor(y + 0.5),math.floor(z + 0.5) )
            end
            KillTimer(player_logout_timer[k])
            player_logout_timer[k] = nil
            time_till_logout[k] = nil
            Kick(k)
        end
    end
end

local function sendHelpMessage(playerid)
    SendPlayerMessage(playerid,230,230,230, "Verwende /logout um dich auszuloggen.")
end

function logout_module.OnPlayerCommandText(playerid, cmdtext)

    if cmdtext == "/logout" then 
        player_logout_timer[playerid] = SetTimer("CheckForPlayerLogout",1000,1)
        time_till_logout[playerid] = os.clock()
        SendPlayerMessage(playerid, 255,255,255, "Logout: du wirst in 5 Sekunden abgemeldet.")
        SendPlayerMessage(playerid, 255,255,255, "Danach kannst du das Spiel mit ESC verlassen.")
        FreezePlayer(playerid, 1)
    elseif cmdtext == "/logout help" then
        sendHelpMessage(playerid)
    end

end

function logout_module.OnPlayerDisconnect(playerid, reason)
    if player_logout_timer[playerid] ~= nil then
        KillTimer(player_logout_timer[playerid])
        player_logout_timer[playerid] = nil
    end
    if time_till_logout[playerid] ~= nil then
        player_logout_timer[playerid] = nil
    end
end

return logout_module