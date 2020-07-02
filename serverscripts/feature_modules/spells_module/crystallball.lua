require "serverscripts/has_item_globals"

local crystalball = {}
local saved_face = {}
local ACTIVATION_ITEM = "ITMI_AQUAMARINE"
local check_ids = {}
check_ids["save"] = SPELLS_MODULE_CHECK_ID1
check_ids["watch"] = SPELLS_MODULE_CHECK_ID2
check_ids["end"] = SPELLS_MODULE_CHECK_ID3
check_ids["introduction"] = CRYSTALLBALL_CHECK_ID4

function crystalball.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/cbs" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["save"])
    elseif cmdtext == "/cbw" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["watch"])
    elseif cmdtext == "/cbe" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["end"])
    elseif cmdtext == "/aquamarine help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

local function watchCrystallball(playerid)
    if saved_face[playerid] ~= nil then
        SendPlayerMessage(playerid, 255, 228, 181, "Stell sicher, dass du nicht zu weit entfernt")
        SendPlayerMessage(playerid, 255, 228, 181, "von der beobachteten Person dich befindest.")
        SetCameraBehindPlayer(playerid, saved_face[playerid]);
    else
        SendPlayerMessage(playerid, 255, 0, 0, "Du hast dir kein Gesicht gemerkt!");
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Der Aquamarin birgt die Kraft einer Kristallkugel.")
    SendPlayerMessage(playerid, 0, 0, 255, "Fokussiere eine Person und tippe '/cbs' ein")
    SendPlayerMessage(playerid, 0, 0, 255, "um dir das Gesicht einer Person zu merken.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/cbw' ein um die gemerkte Person durch die Kugel zu beobachten.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/cbe' ein um zurueck zu kehren.")
    SendPlayerMessage(playerid, 0, 0, 255, "Du darfst nicht zu weit entfernt von der Person sein, um die Person zu beobachten.")
end

function crystalball.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["save"] then
            saved_face[playerid] = GetFocus(playerid);
            SendPlayerMessage(playerid, 255, 228, 181, "Du hast dir das Gesicht gemerkt ...")
        elseif checkid == check_ids["watch"] then
            watchCrystallball(playerid)
        elseif checkid == check_ids["end"] then
            SetDefaultCamera(playerid);
        elseif checkid == check_ids["introduction"] then
            sendIntroductionMessage(playerid)
        end
    end
end

function crystalball.OnPlayerDisconnect(playerid, reason)
    saved_face[playerid] = nil
end

function crystalball.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    saved_face[playerid] = nil
end

return crystalball;
