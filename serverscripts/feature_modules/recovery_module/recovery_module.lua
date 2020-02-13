require "serverscripts/player_globals"
local recovery_module = {}

local function getManaForRecovery(current_mana, max_mana)
    local new_summed_mana = current_mana + math.floor(max_mana / 100 * 5)

    if new_summed_mana > max_mana then
       return max_mana   
    end

    return new_summed_mana
end


local function getHealthForRecovery(current_health, max_health)
    local new_summed_health = current_health + math.floor(max_health / 100 * 5)

    if new_summed_health > max_health then
       return max_health   
    end

    return new_summed_health
end

local function recoverPlayer(playerid)
    if PLAYER_ID_NAME_MAP[playerid] ~= nil then
        local current_health = GetPlayerHealth(playerid)
        local max_health = GetPlayerMaxHealth(playerid)
        local current_mana = GetPlayerMana(playerid)
        local max_mana = GetPlayerMaxMana(playerid)

        if current_health < max_health then
            SetPlayerHealth(playerid, getHealthForRecovery(current_health, max_health))
        end
        if current_mana < max_mana then
            SetPlayerMana(playerid, getManaForRecovery(current_mana, max_mana))
        end
    end
end

function CheckForRecovery()
    for k,v in pairs(PLAYER_ID_NAME_MAP) do
        if IsPlayerConnected(k) == 1 and IsDead(k) == 0 and IsUnconscious(k) == 0 then 
            recoverPlayer(k)
        end
    end

end

function recovery_module.OnGamemodeInit()
    SetTimer("CheckForRecovery",5000,1)
end


return recovery_module