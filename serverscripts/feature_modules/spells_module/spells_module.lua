
local teleport = require "serverscripts/feature_modules/spells_module/teleport"
local teleport_focus = require "serverscripts/feature_modules/spells_module/teleport_focus"
local resize = require "serverscripts/feature_modules/spells_module/resize"
local crystallball = require "serverscripts/feature_modules/spells_module/crystallball"
local focus_protection = require "serverscripts/feature_modules/spells_module/focus_protection"
local vampirism = require "serverscripts/feature_modules/spells_module/vampirism"
local tracking = require "serverscripts/feature_modules/spells_module/tracking"

local spells_module = {}


function spells_module.OnPlayerCommandText(playerid, cmdtext)
    teleport.OnPlayerCommandText(playerid, cmdtext)
    resize.OnPlayerCommandText(playerid, cmdtext)
    crystallball.OnPlayerCommandText(playerid, cmdtext)
    teleport_focus.OnPlayerCommandText(playerid, cmdtext)
    focus_protection.OnPlayerCommandText(playerid, cmdtext)
    vampirism.OnPlayerCommandText(playerid, cmdtext)
    tracking.OnPlayerCommandText(playerid, cmdtext)
end

function spells_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    teleport.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    resize.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    crystallball.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    teleport_focus.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    vampirism.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    tracking.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    focus_protection.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
end

function spells_module.OnPlayerFocus(playerid, focusid)
    focus_protection.OnPlayerFocus(playerid, focusid)
end

function spells_module.OnPlayerDisconnect(playerid, reason)
    focus_protection.OnPlayerDisconnect(playerid, reason)
    teleport.OnPlayerDisconnect(playerid, reason)
    teleport_focus.OnPlayerDisconnect(playerid, reason)
    crystallball.OnPlayerDisconnect(playerid, reason)
end

function spells_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    focus_protection.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    crystallball.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    teleport_focus.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    teleport.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
end

return spells_module