require "serverscripts/player_globals"
local db_config = require "serverscripts/db_config"
local registration_handler = require "serverscripts/feature_modules/authentication_module/registration_handler"
local login_handler = require "serverscripts/feature_modules/authentication_module/login_handler"

local player = {}
local authentication_module = {}

local function handleIntegrationCommands(playerid, cmdtext)

    if cmdtext == "/register" then
        login_handler.exitLoginMode(playerid)
        registration_handler.enterRegistrationMode(playerid)
    elseif cmdtext == "/login"  then
        registration_handler.exitRegistrationMode(playerid)
        login_handler.enterLoginMode(playerid)
    end
end

function authentication_module.enterAuthenticationMode(playerid)
    SendPlayerMessage(playerid,0,205,0, "Druecke die Taste 't' um in den chat zu kommen.")
    SendPlayerMessage(playerid,0,205,0, "Tippe /register um ins Registrationsmenue zu kommen.")
    SendPlayerMessage(playerid,0,205,0, "Tippe /login um ins Loginmenue zu kommen.")
    SendPlayerMessage(playerid,0,205,0, "Tippe /logout um das Spiel zu verlassen.")
    SetPlayerVirtualWorld(playerid, playerid+1)
    SpawnPlayer(playerid)
    SetPlayerPos(playerid, 4670, 848, 7116)
    player[playerid] = {}
    player[playerid].in_authentication_mode = true
    PLAYER_HANDLER_MAP[playerid] = db_config.getHandler()
end

function authentication_module.exitAuthenticationMode(playerid)
    if player[playerid] ~= nil and player[playerid].in_authentication_mode == true then
        player[playerid] = nil
    end
end

function authentication_module.OnPlayerCommandText(playerid, cmdtext)
    if player[playerid] ~= nil and player[playerid].in_authentication_mode == true then
        handleIntegrationCommands(playerid, cmdtext)
    end
    
    registration_handler.OnPlayerCommandText(playerid, cmdtext)
    login_handler.OnPlayerCommandText(playerid, cmdtext)
end

function authentication_module.OnPlayerKey(playerid, keyDown)
    registration_handler.OnPlayerKey(playerid, keyDown)
end

function authentication_module.OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped) 
    registration_handler.OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped) 
end

function authentication_module.OnPlayerDisconnect(playerid, reason)
    PLAYER_ID_NAME_MAP[playerid] = nil
    PLAYER_HANDLER_MAP[playerid] = nil
    login_handler.exitLoginMode(playerid)
    registration_handler.exitRegistrationMode(playerid)
    authentication_module.exitAuthenticationMode(playerid)
end

function authentication_module.OnPlayerSpawn(playerid, classid)
    login_handler.exitLoginMode(playerid)
    registration_handler.exitRegistrationMode(playerid)
    authentication_module.exitAuthenticationMode(playerid)
end

return authentication_module





