local mining_module = {}

local mining_start_time = {}
local player_mining_timer = {}
local MINING_DURATION = 10

local function destroyMiningTimer(playerid)
    mining_start_time[playerid] = nil
    KillTimer(player_mining_timer[playerid])
    player_mining_timer[playerid] = nil
end

function CheckMining()
    for k,v in pairs(mining_start_time) do
        if os.clock() - v > MINING_DURATION then
            destroyMiningTimer(k)
            local number_nuggets = math.random(5)
            SendPlayerMessage(k, 238, 221, 125, "Du hast ".. tostring(number_nuggets) .. " Goldbrocken bekommen!" )
            SendPlayerMessage(k, 238, 221, 125, "Setze die Spitzhacke neu an, um weiter Gold zu schuerfen." )
            GiveItem(k, "ItMi_GoldNugget_Addon", number_nuggets)
        end
    end
end

function mining_module.OnPlayerUseItem(playerid, itemInstance, amount, hand)
    local anim = GetPlayerAnimationName(playerid)   
    if itemInstance == "ITMW_2H_AXE_L_01" and (anim == "T_ORE_S0_2_S1" or anim == "T_ORE_STAND_2_S0") then
        player_mining_timer[playerid] = SetTimer("CheckMining",1000,1);
        mining_start_time[playerid] = os.clock()

    elseif player_mining_timer[playerid] ~= nil and (anim == "T_ORE_S0_2_STAND" or anim == "S_RUN") then
        SendPlayerMessage(playerid, 255, 255, 255, "Schuerfen abgebrochen...")
        destroyMiningTimer(playerid)
    end

end

return mining_module