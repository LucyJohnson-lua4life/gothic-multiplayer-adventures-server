--[[

    Module responsible for handling class selection when creating a character and
    defining class specifics (attributes, equipment) etc.

]]

local class_globals = require "serverscripts/class_globals"
local ui_utils = require "serverscripts/utils/ui_utils"
local class_selection = {}
local player = {}
local player_classid = {}

local function initMenu(playerid)
    ShowPlayerDraw(playerid, player[playerid].menu_draw)
    ShowPlayerDraw(playerid, player[playerid].menu_description1)
    ShowPlayerDraw(playerid, player[playerid].menu_description2)
end

local function createMenuStates(playerid)
    player[playerid] = {}
    player[playerid].selected_class = 1
    player[playerid].in_selection_mode = true
    player[playerid].menu_draw = CreatePlayerDraw(playerid, 500, 5800, "<- " .. CLASS_NAMES[1] .. " ->", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].menu_description1 = CreatePlayerDraw(playerid, 300, 6200, CLASS_DESCRIPTION1[1], "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].menu_description2 = CreatePlayerDraw(playerid, 300, 6200, CLASS_DESCRIPTION2[1], "Font_Old_10_White_Hi.TGA", 250, 250, 250)
end

local function deleteMenuStates(playerid)
    player[playerid].selected_class = nil
    player[playerid].in_selection_mode = nil
    player[playerid].menu_draw = nil
    player[playerid].menu_description1 = nil
    player[playerid].menu_description2 = nil
    player[playerid] = nil
end

local function initSelection(playerid)
    FreezePlayer(playerid, 1)
    --PlayAnimation(playerid, "S_THRONE_S1")
    SetPlayerEnable_OnPlayerKey(playerid, 1)
    createMenuStates(playerid)
    initMenu(playerid)
end

local function confirmSelection(playerid)
    FreezePlayer(playerid, 0)
    SetDefaultCamera(playerid)
    SetPlayerEnable_OnPlayerKey(playerid, 0)
    ClearInventory(playerid)
    class_globals.setClassAttributes(playerid, player[playerid].selected_class)
    class_globals.setClassInventory(playerid, player[playerid].selected_class)
    deleteMenuStates(playerid)
    DestroyAllPlayerDraws(playerid)
end

local function showPreview(playerid, classid)
    ClearInventory(playerid)
    EquipArmor(playerid, CLASS_ARMOR[classid])
    class_globals.setClassAttributes(playerid, player[playerid].selected_class)
    EquipMeleeWeapon(playerid, CLASS_MELEE_WEAPON[classid])
end

local function navigateSelection(playerid, key)
    if key == KEY_RIGHT then
        player[playerid].selected_class = ui_utils.getNextValueOrReset(player[playerid].selected_class, table.getn(CLASS_NAMES), 1)
    elseif key == KEY_LEFT then
        player[playerid].selected_class = ui_utils.getPreviousValueOrReset(player[playerid].selected_class, 1, table.getn(CLASS_NAMES))
    end
    
    UpdatePlayerDraw(playerid, player[playerid].menu_draw, 500, 5800, "<- " .. CLASS_NAMES[player[playerid].selected_class] .. " ->", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    UpdatePlayerDraw(playerid, player[playerid].menu_description1, 300, 6200, CLASS_DESCRIPTION1[player[playerid].selected_class], "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    UpdatePlayerDraw(playerid, player[playerid].menu_description2, 300, 6400, CLASS_DESCRIPTION2[player[playerid].selected_class], "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    showPreview(playerid, player[playerid].selected_class)
    
    if key == KEY_RETURN then
        player_classid[playerid] = player[playerid].selected_class
        confirmSelection(playerid)
    end
end

local function navigateSelectionOnSelectionMode(playerid, key)
    if player[playerid].in_selection_mode then
        navigateSelection(playerid, key)
    end
end

--- public methods

function class_selection.getPlayerClassId(playerid)
    return player_classid[playerid]
end

function class_selection.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/class" then
        initSelection(playerid)
    end
end

function class_selection.OnPlayerKey(playerid, keyDown)
    if (player[playerid] ~= nil) then
        navigateSelectionOnSelectionMode(playerid, keyDown)
    end
end

function class_selection.OnPlayerDisconnect(playerid, reason)
    if player_classid[playerid] ~= nil then
        player_classid[playerid] = nil
    end
end

return class_selection