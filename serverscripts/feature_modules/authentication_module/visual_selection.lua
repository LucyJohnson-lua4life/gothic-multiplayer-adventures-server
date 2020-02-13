--[[

    Module responsible for handling visual selection when creating a character.
    The user can customize it's character by changing the body model,
    head model, head texture and body texture.

]]

local ui_utils = require "serverscripts/utils/ui_utils"
local visual_selection = {}
local player = {}

local ARROW_POS = {5800, 6000, 6200, 6400, 6600}
local BODY_MODEL = {"Hum_Body_Naked0", "Hum_Body_Babe0"}
local HEAD_MODEL = {"Hum_Head_FatBald", "Hum_Head_Fighter", "Hum_Head_Pony", "Hum_Head_Bald", "Hum_Head_Thief", "Hum_Head_Psionic", "Hum_Head_Babe"}
local OPTION_NAMES = {"body_model", "body_texture", "head_model", "head_texture"}
local NUM_MENU_OPTIONS = 5
--[[
    NUM_EACH_OPTION contains the number of options for each visual menu option 
    which are:
    1:BODY_MODEL, 2:HEAD_MODEL 3:HEAD_TEXTURE 4:BODY_TEXTURE
]]
local NUM_EACH_OPTION = {2, 10, 7, 162}

local function createMenuStates(playerid)
    player[playerid] = {}
    player[playerid].body_model = 1
    player[playerid].body_texture = 1
    player[playerid].head_model = 1
    player[playerid].head_texture = 1
    player[playerid].selected_option = 1
    player[playerid].in_selection_mode = true
    player[playerid].menu_draw1 = CreatePlayerDraw(playerid, 300, 5800, "BodyForm", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].menu_draw2 = CreatePlayerDraw(playerid, 300, 6000, "BodyTex", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].menu_draw3 = CreatePlayerDraw(playerid, 300, 6200, "HeadForm", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].menu_draw4 = CreatePlayerDraw(playerid, 300, 6400, "HeadTex", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].menu_draw_confirm = CreatePlayerDraw(playerid, 300, 6600, "confirm", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
    player[playerid].select_arrow = CreatePlayerDraw(playerid, 100, 5800, "->", "Font_Old_10_White_Hi.TGA", 250, 250, 250)
end

local function initMenu(playerid)
    ShowPlayerDraw(playerid, player[playerid].menu_draw1)
    ShowPlayerDraw(playerid, player[playerid].menu_draw2)
    ShowPlayerDraw(playerid, player[playerid].menu_draw3)
    ShowPlayerDraw(playerid, player[playerid].menu_draw4)
    ShowPlayerDraw(playerid, player[playerid].menu_draw_confirm)
    ShowPlayerDraw(playerid, player[playerid].select_arrow)
end

local function startSelection(playerid)
    FreezePlayer(playerid, 1)
    PlayAnimation(playerid, "S_THRONE_S1")
    SetPlayerEnable_OnPlayerKey(playerid, 1)
    createMenuStates(playerid)
    initMenu(playerid)
end

local function deleteMenuStates(playerid)
    player[playerid].body_model = nil
    player[playerid].body_texture = nil
    player[playerid].head_model = nil
    player[playerid].head_texture = nil
    player[playerid].selected_option = nil
    player[playerid].in_selection_mode = nil
    player[playerid].menu_draw1 = nil
    player[playerid].menu_draw2 = nil
    player[playerid].menu_draw3 = nil
    player[playerid].menu_draw4 = nil
    player[playerid].menu_draw_confirm = nil
    player[playerid].select_arrow = nil
    player[playerid] = nil
end

local function isVisualSelection(selection)
    return selection >= 1 and selection <= NUM_MENU_OPTIONS
end

local function confirmSelection(playerid)
    FreezePlayer(playerid, 0)
    SetDefaultCamera(playerid)
    SetPlayerEnable_OnPlayerKey(playerid, 0)
    deleteMenuStates(playerid)
    DestroyAllPlayerDraws(playerid)
end

local function navigateSelection(playerid, key)
    if key == KEY_UP then
        player[playerid].selected_option = ui_utils.getPreviousValueOrReset(player[playerid].selected_option, 1, NUM_MENU_OPTIONS)
    end
   
    if key == KEY_DOWN then
        player[playerid].selected_option = ui_utils.getNextValueOrReset(player[playerid].selected_option, NUM_MENU_OPTIONS, 1)
    end

    local option_name = OPTION_NAMES[player[playerid].selected_option]
    UpdatePlayerDraw(playerid, player[playerid].select_arrow, 100, ARROW_POS[player[playerid].selected_option], "->", "Font_Old_10_White_Hi.TGA", 250, 250, 250)

    if key == KEY_RIGHT and isVisualSelection(player[playerid].selected_option) then
        player[playerid][option_name] = ui_utils.getNextValueOrReset(player[playerid][option_name], NUM_EACH_OPTION[player[playerid].selected_option], 1)
    end
    
    if key == KEY_LEFT and isVisualSelection(player[playerid].selected_option) then
        player[playerid][option_name] = ui_utils.getPreviousValueOrReset(player[playerid][option_name], 1, NUM_EACH_OPTION[player[playerid].selected_option])
    end

    if player[playerid].in_selection_mode then
        SetPlayerAdditionalVisual(playerid, BODY_MODEL[player[playerid].body_model], player[playerid].body_texture, HEAD_MODEL[player[playerid].head_model], player[playerid].head_texture)
    end

    if key == KEY_RETURN and player[playerid].selected_option == 5 then
        confirmSelection(playerid)
    end

end

local function navigateSelectionOnSelectionMode(playerid, key)
    if player[playerid] ~= nil and player[playerid].in_selection_mode ~= nil then
        navigateSelection(playerid, key)
    end
end

--  public methods
function visual_selection.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/visual" then
        startSelection(playerid)
    end
end

function visual_selection.OnPlayerKey(playerid, keyDown)
        navigateSelectionOnSelectionMode(playerid, keyDown)
end

return visual_selection
