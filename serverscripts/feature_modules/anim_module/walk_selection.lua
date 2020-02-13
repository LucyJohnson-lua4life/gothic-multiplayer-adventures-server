local walk_selection = {}

local WALKS = {}

WALKS["/walk2"] = "Humans_Militia.mds"
WALKS["/walk3"] = "Humans_Arrogance.mds"
WALKS["/walk4"] = "Humans_Babe.mds"
WALKS["/walk5"] = "Humans_Relaxed.mds"
WALKS["/walk6"] = "Humans_Mage.mds"
WALKS["/walk7"] = "Humans_Tired.mds"


local function printAnimHelp(playerid)
    SendPlayerMessage(playerid,255,255,255,"Tippe diese Kommandos um die Gangart zu aendern:")
    SendPlayerMessage(playerid,255,255,255,"/walk(1-7)")
end

function walk_selection.OnPlayerCommandText(playerid, cmdtext)
    
    if cmdtext == "/walk1" then
        RemovePlayerOverlay(playerid, GetPlayerWalk(playerid))
    elseif WALKS[cmdtext] ~= nil then
        RemovePlayerOverlay(playerid, GetPlayerWalk(playerid))
        SetPlayerWalk(playerid, WALKS[cmdtext])
    elseif cmdtext == "/walk help" then
        printAnimHelp(playerid)
    end
end

return walk_selection