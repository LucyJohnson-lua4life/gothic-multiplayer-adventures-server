require "serverscripts/feature_modules/npc_interaction_module/invisible_npcs"
local dia_vlk_2000_vivien = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_2000_vivien"
local dia_vlk_2001_olga = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_2001_olga"
local dia_vlk_7005_bryan = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_7005_bryan"
local dia_vlk_7004_lian = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_7004_lian"
local dia_vlk_7003_ryan = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_7003_ryan"
local dia_vlk_7002_brad = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_7002_brad"

local npc_interaction_module = {}


local function handleNpcInteraction(playerid, npc_id, text)

    local npc_name = GetPlayerName(npc_id)

    if string.match(npc_name, "^Bryan.*") then
        dia_vlk_7005_bryan.handleDialogue(playerid, text)
    elseif string.match(npc_name, "^Lian.*") then
        dia_vlk_7004_lian.handleDialogue(playerid, text)
    elseif string.match(npc_name, "^Ryan.*") then
        dia_vlk_7003_ryan.handleDialogue(playerid, text)
    elseif string.match(npc_name, "^Brad.*") then
        dia_vlk_7002_brad.handleDialogue(playerid, text)
    elseif string.match(npc_name, "^Vivien.*") then
        dia_vlk_2000_vivien.handleDialogue(playerid, text)
    elseif string.match(npc_name, "^Olga.*") then
        dia_vlk_2001_olga.handleDialogue(playerid, text)
    end
    --- depending on NPC, the interaction will be forwarded to the npc handler
end

function npc_interaction_module.OnPlayerCommandText(playerid, cmdtext)
    local cmd, text = GetCommand(cmdtext);
    if cmd == "/i" then
        local npc_id = GetFocus(playerid)
        if IsNPC(npc_id) then
            handleNpcInteraction(playerid, npc_id, text)
        end
    end

end

function npc_interaction_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)

    dia_vlk_7005_bryan.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    dia_vlk_7004_lian.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    dia_vlk_7003_ryan.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    dia_vlk_7002_brad.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    dia_vlk_2000_vivien.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
end

function npc_interaction_module.OnPlayerHit(playerid, killerid)
    if IsNPC(playerid) then
        local npc_name = GetPlayerName(playerid)
        if INVISIBLE_NPCS[npc_name] == true then
            SetPlayerHealth(playerid, GetPlayerMaxHealth(playerid))
        end
    end
end

return npc_interaction_module