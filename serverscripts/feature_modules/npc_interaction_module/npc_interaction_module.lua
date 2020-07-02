require "serverscripts/feature_modules/npc_interaction_module/invisible_npcs"
local dia_vlk_7005_bryan = require "serverscripts/feature_modules/npc_interaction_module/dialogues/dia_vlk_7005_bryan"
local npc_interaction_module = {}
local HAS_ITEM_NPC_INTERACTION_ID = 5


local function handleNpcInteraction(playerid, npc_id, text)

    local npc_name = GetPlayerName(npc_id)

    if npc_name == "Bryan" then
        dia_vlk_7005_bryan.handleDialogue(playerid, text)
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