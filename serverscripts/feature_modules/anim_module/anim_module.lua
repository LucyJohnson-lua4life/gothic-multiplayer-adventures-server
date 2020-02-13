
local anim_selection = require "serverscripts/feature_modules/anim_module/anim_selection"
local walk_selection = require "serverscripts/feature_modules/anim_module/walk_selection"

local anim_selection_module = {}

function anim_selection_module.OnPlayerCommandText(playerid, cmdtext)
    anim_selection.OnPlayerCommandText(playerid, cmdtext)
    walk_selection.OnPlayerCommandText(playerid, cmdtext)
end

return anim_selection_module