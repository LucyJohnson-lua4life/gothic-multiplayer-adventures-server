-- this module ensures that human npc's like Bandits will immediately kill the player and get immediately killed by the player

local npc_human_instakill = {}

local INSTAKILL_NPC_NAMES = {}
INSTAKILL_NPC_NAMES["Bandit"] = true
INSTAKILL_NPC_NAMES["Strong Bandit"] = true
INSTAKILL_NPC_NAMES["Captn Hook"] = true

local function getNameWithoutId(name)
    print(string.gsub(name, "%s%((%d+)%)",""))
	return string.gsub(name, "%s%((%d+)%)","")
end

function npc_human_instakill.OnPlayerUnconscious(playerid, p_classid, killerid, k_classid)
    if IsNPC(playerid) == 1 then
        if  INSTAKILL_NPC_NAMES[getNameWithoutId(GetPlayerName(playerid))] == true then
            SetPlayerHealth(playerid, 0)
        end
    elseif IsNPC(killerid) == 1 then
       if INSTAKILL_NPC_NAMES[getNameWithoutId(GetPlayerName(playerid))] == true then
            SetPlayerHealth(playerid, 0)
       end
    end
end


return npc_human_instakill