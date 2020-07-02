require "serverscripts/feature_modules/npc_interaction_module/invisible_npcs"

local npc_interaction_module = {}
local HAS_ITEM_NPC_INTERACTION_ID = 5



function npc_interaction_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)

    if checkid == HAS_ITEM_NPC_INTERACTION_ID then




    end
end



local function handleNpcInteraction(playerid, npc_id, text)

    local npc_name = GetPlayerName(npc_id)

    --- depending on NPC, the interaction will be forwarded to the npc handler
end

function npc_interaction_module.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/i" then
        local npc_id = GetFocus(playerid)
        if IsNPC(npc_id) then
            handleNpcInteraction()
        end
    end

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