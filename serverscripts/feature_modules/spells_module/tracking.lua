require "serverscripts/has_item_globals"
local tracking = {}
local ACTIVATION_ITEM = "ITAT_SKELETONBONE"
local check_ids = {}
check_ids["faehrte aufnehmen"] = SPELLS_MODULE_CHECK_ID1
check_ids["introduction"] = SPELLS_MODULE_CHECK_ID2


function tracking.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/faehrte aufnehmen" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["faehrte aufnehmen"])
    elseif cmdtext == "/bone help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Der Knochen besitzt die Macht des Faehrtenlesens.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/faehrte aufnehmen' ein um dir Informationen über alle Spieler in 2000 Metern Entfernung anzuzeigen.")
end


local function trackAllPlayer(playerid, meters)
    SendPlayerMessage(playerid, 0,0,255, "Beginne Faehrtenlesen ...")
    for i = 0, GetMaxPlayers() - 1 do
        if IsPlayerConnected(i) == 1 and i ~= playerid then
            local dist = GetDistancePlayers(playerid,i)
			if dist < meters then 
                SendPlayerMessage(playerid, 0,0,255, "Jemand ist " .. dist .. " Meter entfernt.")
			end
		end
    end
    PlayAnimation(playerid, "T_PLUNDER")
    SendPlayerMessage(playerid, 0,0,255, "Faehrtenlesen beendet.")
end

function tracking.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["faehrte aufnehmen"] then
            trackAllPlayer(playerid, 2000)
        elseif checkid == check_ids["introduction"] then
            sendIntroductionMessage(playerid)
        end
    end
end

return tracking