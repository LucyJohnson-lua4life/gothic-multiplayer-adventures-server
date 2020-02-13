local focus_protection = {}
local FREEZE_TIME_SECS = 4

FOCUS_PROTECTION_VICTIMS = {}
local player_victim_timer = {}
local player_in_protection_mode = {}
local player_original_strength = {}
local player_original_dexterity = {}

local ACTIVATION_ITEM = "ITMI_DARKPEARL"
local check_ids = {}
check_ids["protection on"] = 1
check_ids["protection off"] = 2
check_ids["introduction"] = 3


function CheckFocusProtectionVictims()
    for k, v in pairs(FOCUS_PROTECTION_VICTIMS) do
        if(os.clock() - v > FREEZE_TIME_SECS) then
            FOCUS_PROTECTION_VICTIMS[k] = nil;
            KillTimer(player_victim_timer[k])
            player_victim_timer[k] = nil
            FreezePlayer(k, 0)
        end
    end
end

local function runFocusProtection(playerid)
    if IsNPC(playerid) == 0 then
        SendPlayerMessage(playerid, 255,0,0, "Eine dunkle Aura erstarrt deinen Koerper fuer kurze Zeit.")
        FOCUS_PROTECTION_VICTIMS[playerid] = os.clock()
        FreezePlayer(playerid, 1)
        player_victim_timer[playerid] = SetTimer("CheckFocusProtectionVictims",1000,1);
        local sound_id = CreateSound("ZOM_DIE02.WAV"); --Sound of attack by dragon's fire.
        local sound_id2 = CreateSound("MYSTERIOUS_AMBIENCE.WAV")
        PlayPlayerSound(playerid, sound_id2)
        PlayPlayerSound(playerid, sound_id)
        PlayAnimation(playerid, "S_FEAR_VICTIM2")
    end
end

local function sendIntroductionMessage(playerid)
    SendPlayerMessage(playerid, 0, 0, 255, "Die schwarze Perle besitzt die Kraft des Fokusschutzes.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/protect on' ein um den Fokusschutz zu aktivieren.")
    SendPlayerMessage(playerid, 0, 0, 255, "Waehrend du dich im Fokusschutzmodus befindest, wird deine Staerke auf 10 reduziert.")
    SendPlayerMessage(playerid, 0, 0, 255, "Jeder Spieler der seinen Fokus auf dich wechselt, wird für 8 Sekunden eingefroren.")
    SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/protect off' ein um den Fokusschutz zu deaktivieren.")
end


function focus_protection.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/protect on" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["protection on"])
    end

    if cmdtext =="/protect off" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["protection off"])
    end

    if cmdtext == "/darkperl help" then
        HasItem(playerid, ACTIVATION_ITEM, check_ids["introduction"])
    end
end

function focus_protection.OnPlayerFocus(playerid, focusid)
    if player_in_protection_mode[focusid] then
        runFocusProtection(playerid)
    end
end

function focus_protection.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if item_instance == ACTIVATION_ITEM then
        if checkid == check_ids["protection on"] then
            player_in_protection_mode[playerid] = true
            player_original_strength[playerid] = GetPlayerStrength(playerid)
            player_original_dexterity[playerid] = GetPlayerDexterity(playerid)
            SetPlayerStrength(playerid, 1)
            SetPlayerDexterity(playerid, 1)
            SendPlayerMessage(playerid, 0, 255, 0, "Fokusschutz aktiviert.")
        elseif checkid == check_ids["protection off"] then
            player_in_protection_mode[playerid] = nil
            SetPlayerStrength(playerid, player_original_strength[playerid])
            SetPlayerDexterity(playerid, player_original_dexterity[playerid])
            player_original_strength[playerid] = nil
            player_original_dexterity[playerid] = nil
            SendPlayerMessage(playerid, 0, 255, 0, "Fokusschutz deaktiviert.")
        elseif checkid == check_ids["introduction"] then
            sendIntroductionMessage(playerid)
        end
    end
end

function focus_protection.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    player_in_protection_mode[playerid] = nil
end

function focus_protection.OnPlayerDisconnect(playerid, reason)
    player_in_protection_mode[playerid] = nil
end

return focus_protection


