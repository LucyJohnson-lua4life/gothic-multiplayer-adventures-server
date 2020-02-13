require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
local player_dao = require "serverscripts/daos/player_dao"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local account_dao = require "serverscripts/daos/account_dao"
local player_gold_dao = require "serverscripts/daos/player_gold_dao"

local login_handler = {}

local player = {}

local ERROR_PLAYER_COULD_NOT_BE_LOADED = "Probleme beim Laden des Spielers. Bitte wende dich an den Admin."

local function setPlayerAttributes(playerid, row)
    if(row ~= nil) then
        SetPlayerStrength(playerid, tonumber(row["str"]));
        SetPlayerDexterity(playerid, tonumber(row["dex"]));
        SetPlayerSkillWeapon(playerid, SKILL_1H, tonumber(row["one_h"]));
        SetPlayerSkillWeapon(playerid, SKILL_2H, tonumber(row["two_h"]));
        SetPlayerSkillWeapon(playerid, SKILL_BOW, tonumber(row["bow"]));
        SetPlayerSkillWeapon(playerid, SKILL_CBOW, tonumber(row["cbow"]));
        SetPlayerMaxHealth(playerid, tonumber(row["max_health"]));
        SetPlayerHealth(playerid, tonumber(row["health"]));
        SetPlayerMana(playerid, tonumber(row["mana"]));
        SetPlayerMaxMana(playerid, tonumber(row["max_mana"]));
        SetPlayerMagicLevel(playerid, tonumber(row["magic_level"]));
        SetPlayerScience(playerid, 0, 1)
        EquipArmor(playerid, row["armor"]);
        EquipMeleeWeapon(playerid, row["melee_weapon"]);
        SetPlayerAdditionalVisual(playerid, tostring(row["body_model"]), tonumber(row["body_tex"]), tostring(row["head_model"]), tonumber(row["head_tex"]))
    else
        SendPlayerMessage(playerid,0,70,230,ERROR_PLAYER_COULD_NOT_BE_LOADED);
    end
end

local function loadPlayer(handler, playerid, name, password)
    local row = player_dao.loadPlayerValues(handler, name, SHA256(password))
    if(row == nil) then
        SendPlayerMessage(playerid,0,70,230,ERROR_PLAYER_COULD_NOT_BE_LOADED);
    else
        setPlayerAttributes(playerid, row)
    end
end

local function authenticationSuccessful(handler, name, password)
    local result = account_dao.accountExists(handler, name, password)
    if (mysql_fetch_assoc(result) == nil) then
        return false;
    else
        return true;
    end
end

local function loadPlayerInventory(handler, playerid, name)
    local items = inventory_dao.getAllItemsAndAmountByName(handler, name)
    if(items ~= nil) then
        while true do
            local row = mysql_fetch_assoc(items)
            if (not row) then break end
            GiveItem(playerid, row["item_name"], row["amount"])
        end    
        mysql_free_result(items)
    else
        SendPlayerMessage(playerid,0,255,0,ERROR_PLAYER_COULD_NOT_BE_LOADED)
    end
end

local function loadPlayerGold(handler, playerid, name)
    local row = mysql_fetch_assoc(player_gold_dao.getAmount(handler, name))
    if row["amount"] ~= nil then
        SetPlayerGold(playerid, tonumber(row["amount"]))
    else
        SetPlayerGold(playerid, 0)
    end
end

local function setSavedPlayerPos(playerid, handler, name)
    local row = player_dao.getPlayerPos(handler, name)
    if row ~= nil then
        local x = row["pos_x"]
        local y = row["pos_y"]
        local z = row["pos_z"]
        if x ~= nil and y~=nil and y~=nil then
            SetPlayerPos(playerid, tonumber(x), tonumber(y), tonumber(z))
        end
    end

end

local function runLogin(handler, playerid, name, password)
    if authenticationSuccessful(handler, name, password) then
        SetPlayerVirtualWorld(playerid, 0)
        SetPlayerWorld(playerid,"NEWWORLD\\NEWWORLD.ZEN","CITY2")
        SpawnPlayer(playerid)
        SetPlayerName(playerid, name)
        loadPlayer(handler, playerid, name, password)
        loadPlayerInventory(handler, playerid, name)
        loadPlayerGold(handler, playerid, name)
        setSavedPlayerPos(playerid, handler, name)
        PLAYER_ID_NAME_MAP[playerid] = name
    else
        SendPlayerMessage(playerid, 255,0,0, "Es wurde kein Name mit diesem Passwort gefunden.")
        SendPlayerMessage(playerid, 255,0,0, "Bitte versuche es noch ein mal.")
        SendPlayerMessage(playerid,0,205,0, "Tippe /register um ins Registrationsmenue zu kommen.")
        SendPlayerMessage(playerid,0,205,0, "Tippe /login um ins Loginmenue zu kommen.")
    end
    login_handler.exitLoginMode(playerid)
end

local function handleLoginCommand(playerid, cmdtext)
    local cmd,params = GetCommand(cmdtext);
    local parameter = params:split(" ")
 
    if cmd == "/login" and table.getn(parameter) == 2 then
        runLogin(PLAYER_HANDLER_MAP[playerid], playerid, parameter[1], parameter[2])
    end
end

----------------------------- PUBLIC FUNCTIONS

function login_handler.OnPlayerCommandText(playerid, cmdtext)
    if login_handler.inLoginMode(playerid) then
        handleLoginCommand(playerid, cmdtext)
    end
end

function login_handler.enterLoginMode(playerid)
    player[playerid] = {}
    player[playerid].in_login_mode = true
    SendPlayerMessage(playerid, 0,255,0, "Tippe das Kommando /login [name] [passwort] um dich einzuloggen")
end

function login_handler.inLoginMode(playerid)
    return player[playerid] ~= nil and player[playerid].in_login_mode == true
end

function login_handler.exitLoginMode(playerid)
    if login_handler.inLoginMode(playerid) == true then
        player[playerid] = nil
    end
end


return login_handler