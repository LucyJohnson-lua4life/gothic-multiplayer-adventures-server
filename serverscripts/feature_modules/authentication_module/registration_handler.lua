require "serverscripts/utils/script_functions"
local visual_selection = require "serverscripts/feature_modules/authentication_module/visual_selection"
local class_selection = require "serverscripts/feature_modules/authentication_module/class_selection"
local player_dao = require "serverscripts/daos/player_dao"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local player_gold_dao = require "serverscripts/daos/player_gold_dao"

local registration_handler = {}

local player = {}



local function getClassIdElseOne(playerid)
    local classid = class_selection.getPlayerClassId(playerid)
    if classid == nil then
        classid = 1
    end
    return classid
end

--[[ 
    Equipped weapons will not be count for inventory init, since a user can have multiple weapons
]]
local function getPlayerValues(playerid, name, password)
    local player_values = {}
    local bm,bt,hm,ht = GetPlayerAdditionalVisual(playerid);
    player_values.name = name
    player_values.password = password
    player_values.body_model = bm
    player_values.body_tex = bt
    player_values.head_model = hm
    player_values.head_tex = ht
    player_values.melee_weapon = GetEquippedMeleeWeapon(playerid)
    player_values.ranged_weapon = GetEquippedRangedWeapon(playerid)
    player_values.armor = GetEquippedArmor(playerid)
    player_values.str = GetPlayerStrength(playerid)
    player_values.dex = GetPlayerDexterity(playerid)
    player_values.one_h = GetPlayerSkillWeapon(playerid, 0)
    player_values.two_h = GetPlayerSkillWeapon(playerid, 1)
    player_values.bow = GetPlayerSkillWeapon(playerid, 2)
    player_values.cbow = GetPlayerSkillWeapon(playerid, 3)
    player_values.max_health = GetPlayerMaxHealth(playerid)
    player_values.health = GetPlayerHealth(playerid)
    player_values.mana = GetPlayerMana(playerid)
    player_values.max_mana = GetPlayerMaxMana(playerid)
    player_values.magic_level = GetPlayerMagicLevel(playerid)
    player_values.class_id = getClassIdElseOne(playerid)
    return player_values
end

local function initInventory(playerid, name)
    local class_id = getClassIdElseOne(playerid)
    local all_items_initialized = true
    
    if CLASS_INVENTORY[class_id] == nil then
        return false;
    end

    for key,value in pairs(CLASS_INVENTORY[class_id]) do
        if inventory_dao.insertItem(PLAYER_HANDLER_MAP[playerid], name, value ,CLASS_INVENTORY_AMOUNT[class_id][key]) == false then
            all_items_initialized = false
        end
    end
    
    return all_items_initialized
end



local function createPlayer(handler, playerid, name, password)

    if player_dao.nameExists(handler, name) then
        SendPlayerMessage(playerid, 255,0,0,"Der Name wird bereits verwendet.")    
        SendPlayerMessage(playerid, 255,0,0,"Bitte waehle einen anderen Namen aus.")
    else
        local player_vals = getPlayerValues(playerid, name, SHA256(password))
        --TODO: der part muss refactored werden, wenn init inventory false dann lösche den user oder so
        if  player_dao.insertPlayer(handler, player_vals) == true and initInventory(playerid,name) == true and player_dao.updatePlayerPos(handler, name, 38994, 3901, -2235) == true and player_gold_dao.insert(handler, name, 100) == true then
            SendPlayerMessage(playerid, 0,255,0,"Der Spieler wurde erfolgreich erstellt.")
            SendPlayerMessage(playerid, 0,255,0,"Tippe /login ein um dich einzuloggen")
        else
            player_dao.deletePlayer(handler, name)
            SendPlayerMessage(playerid, 255,0,0,"Etwas ist bei der Erstellung des Spieler schief gelaufen.")
            SendPlayerMessage(playerid, 255,0,0,"(Es muss eine Klasse ausgewaehlt werden)")
            SendPlayerMessage(playerid,0,205,0, "Tippe /register um ins Registrationsmenue zu kommen.")
            SendPlayerMessage(playerid,0,205,0, "Tippe /login um ins Loginmenue zu kommen.")
        end
        registration_handler.exitRegistrationMode(playerid)
    end
end

local function handleCreateCommand(playerid, cmdtext)
    local cmd,params = GetCommand(cmdtext)
    local parameter = params:split(" ")
    if cmd == "/register" and table.getn(parameter) == 2 then
      createPlayer(PLAYER_HANDLER_MAP[playerid], playerid, parameter[1], parameter[2])
    end

end

----------------------------- PUBLIC FUNCTIONS

function registration_handler.enterRegistrationMode(playerid)
    player[playerid] = {}
    player[playerid].in_registration_mode = true
    SendPlayerMessage(playerid, 0, 205, 0, "1. Tippe '/visual' ein um das Aussehen zu aendern.")
    SendPlayerMessage(playerid, 0, 205, 0, "2. Tippe '/class' ein um die Klasse zu aendern.")
    SendPlayerMessage(playerid, 0, 205, 0, "Wenn du zufrieden bist mit dem Aussehen und der Klasse")
    SendPlayerMessage(playerid, 0, 205, 0, "3. Tippe '/register [name] [passwort]' ein um den Charakter zu registrieren.")
    SendPlayerMessage(playerid, 0, 205, 0, "'name' und 'passwort' sind deine Authentifizierungsdaten")
    SendPlayerMessage(playerid, 0, 205, 0, "welche du fuers nacheste Einloggen benoetigst.")
end

function registration_handler.OnPlayerCommandText(playerid, cmdtext)
    if registration_handler.inRegistrationMode(playerid) == true then
        visual_selection.OnPlayerCommandText(playerid, cmdtext)
        class_selection.OnPlayerCommandText(playerid, cmdtext)
        handleCreateCommand(playerid, cmdtext)
    end
end

function registration_handler.OnPlayerKey(playerid, keyDown)
    visual_selection.OnPlayerKey(playerid, keyDown)
    class_selection.OnPlayerKey(playerid, keyDown)
end

function registration_handler.inRegistrationMode(playerid)
    return player[playerid] ~= nil and player[playerid].in_registration_mode == true
end

function registration_handler.exitRegistrationMode(playerid)
    if registration_handler.inRegistrationMode(playerid) == true then
        player[playerid] = nil
    end
end

return registration_handler