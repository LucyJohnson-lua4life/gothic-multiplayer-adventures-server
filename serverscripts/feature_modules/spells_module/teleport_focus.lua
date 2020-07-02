require "serverscripts/has_item_globals"
local teleport_focus = {}
local Player = {}
local ACTIVATION_ITEM = "ITMI_SILVERRING"
local check_ids = {}
check_ids["tpfs"] = SPELLS_MODULE_CHECK_ID1
check_ids["tpf"] = SPELLS_MODULE_CHECK_ID2
check_ids["introduction"] = SPELLS_MODULE_CHECK_ID3


local function saveFocusPos(playerid)
    if Player[playerid] == nil then
        Player[playerid] = {}
    end

    local x,y,z = GetPlayerPos(playerid)
    
    Player[playerid].tp_x = x
    Player[playerid].tp_y = y
    Player[playerid].tp_z = z
    SendPlayerMessage(playerid,255,255,255,"Speichere Position: " .. x .. ", " .. y .. ", " .. z .. ".")
end

local function tpfToSavedPos(playerid)
    if Player[playerid].tp_x ~= nil and Player[playerid].tp_y ~= nil and Player[playerid].tp_z ~= nil then
        SetPlayerPos(GetFocus(playerid), Player[playerid].tp_x, Player[playerid].tp_y, Player[playerid].tp_z);
        SendPlayerMessage(playerid,255,255,255,"Ziel wurde zur gespeicherten Position teleportiert.");
    end
end

local function checkRequirementsAndTp(playerid)
    local necessary_health = GetPlayerMaxHealth(playerid)/100*75
    if GetPlayerHealth(playerid) >= necessary_health then
        SetPlayerHealth(playerid, GetPlayerHealth(playerid) - necessary_health)
        tpfToSavedPos(playerid)
    elseif GetPlayerHealth(playerid) < necessary_health then
        SendPlayerMessage(playerid, 255, 0, 0, "Du hast nicht genug Lebenspunkte fuer die Teleportation.")
    end
end

function teleport_focus.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/tpfs" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["tpfs"])
    elseif cmdtext == "/tpf" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["tpf"])
    elseif cmdtext == "/silverring help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Der Silberring besitzt die Macht der Fremdteleportation.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/tpfs' ein um dir eine Position zu merken.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/tpf' ein ein fokussiertes Ziel zu der Position zu teleportieren.")
end

function teleport_focus.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)

    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["tpfs"] then
            saveFocusPos(playerid)
        elseif checkid == check_ids["tpf"] then
            checkRequirementsAndTp(playerid)
        elseif checkid == check_ids["introduction"] then
           sendIntroductionMessage(playerid)
        end
    end
end

function teleport_focus.OnPlayerDisconnect(playerid, reason)
    Player[playerid] = nil
end

function teleport_focus.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    Player[playerid] = nil
end

return teleport_focus