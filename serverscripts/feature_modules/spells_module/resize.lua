require "serverscripts/has_item_globals"
local resize = {}
local ACTIVATION_ITEM = "ITMI_SILVERNECKLACE"
local check_ids = {}
check_ids["normal"] = SPELLS_MODULE_CHECK_ID1
check_ids["big"] = SPELLS_MODULE_CHECK_ID2
check_ids["small"] = SPELLS_MODULE_CHECK_ID3
check_ids["mini"] = SPELLS_MODULE_CHECK_ID4
check_ids["introduction"] = SPELLS_MODULE_CHECK_ID5

function resize.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/normal" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["normal"])
    elseif cmdtext == "/big" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["big"])
    elseif cmdtext == "/small" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["small"])
    elseif cmdtext == "/mini" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["mini"])
    elseif cmdtext == "/silvernecklace help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Das Horn besitzt die Macht der Groessenaenderung.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/normal' ein um in deine normale Groesse zurueck zu kehren.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/big' ein um gross zu werden.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/small' ein um klein zu werden.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/mini' ein um winzig zu werden.")
end

function resize.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["normal"] then
            SetPlayerScale(playerid,1.0,1.0,1.0);
        elseif checkid == check_ids["big"] then
            SetPlayerScale(playerid,2.0,3.0,2.0);
        elseif checkid == check_ids["small"] then
            SetPlayerScale(playerid,0.5,0.5,0.5);
        elseif checkid == check_ids["mini"] then
            SetPlayerScale(playerid,0.1,0.1,0.1);
        elseif checkid == check_ids["introduction"] then
            sendIntroductionMessage(playerid)
        end
    end
end

return resize
