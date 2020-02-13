--[[ todo on login wird inventory_module onplayer take item wird vermutlich durch GiveItem getriggert
-> dadurch vermehrt sich das inventory was doof ist
]]

require "serverscripts/player_globals"
local class_globals = require "serverscripts/class_globals"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local player_dao = require "serverscripts/daos/player_dao"

local inventory_module = {}

local NON_CONSUMABLE_ITEMS = {}
NON_CONSUMABLE_ITEMS["ITMW_2H_AXE_L_01"] = true;


function inventory_module.OnPlayerUseItem(playerid, item_instance, amount, hand)
    local handler = PLAYER_HANDLER_MAP[playerid]
    local name = PLAYER_ID_NAME_MAP[playerid]
    if name ~= nil and NON_CONSUMABLE_ITEMS[item_instance] == nil then
        inventory_dao.updateItemOrDeleteIfAmountIsZero(handler, name, item_instance, 1)
    end

end

function inventory_module.OnPlayerTakeItem(playerid, itemID, item_instance, amount, x, y, z, worldName)
    local handler = PLAYER_HANDLER_MAP[playerid]
    local name = PLAYER_ID_NAME_MAP[playerid]
    
    if name ~= nil then
      inventory_dao.updateItemOrInsertIfNotExist(handler, name, item_instance, amount)
    end
    
end

function inventory_module.OnPlayerDropItem(playerid, itemid, item_instance, amount, x, y, z)
    local handler = PLAYER_HANDLER_MAP[playerid]
    local name = PLAYER_ID_NAME_MAP[playerid]

    if name ~= nil then
        if class_globals.isStarterEquip(item_instance) then
            SendPlayerMessage(playerid,255,0,0, "Startgegenstaende koennen nicht getauscht oder weggeworfen werden!")
            DestroyItem(itemid)
            inventory_dao.updateItemOrDeleteIfAmountIsZero(handler, name, item_instance, amount)
            GiveItem(playerid, item_instance, amount)
        elseif class_globals.isStarterEquip(item_instance) == false then
            inventory_dao.deleteItemByInstance(handler, name, item_instance)
        end
    end
end

function inventory_module.OnPlayerChangeMeleeWeapon(playerid, currMelee, oldMelee)
    local handler = PLAYER_HANDLER_MAP[playerid]
    local name = PLAYER_ID_NAME_MAP[playerid]
    if name ~= nil then
        if currMelee ~= nil then
            inventory_dao.updateItemOrDeleteIfAmountIsZero(handler, name, currMelee, 1)
        end
        if oldMelee ~= nil then
            inventory_dao.updateItemOrInsertIfNotExist(handler, name, oldMelee, 1)
        end
        player_dao.updatePlayerMelee(handler, name, currMelee)
    end

end

function inventory_module.OnPlayerChangeRangedWeapon(playerid, currRanged, oldRanged)
    local handler = PLAYER_HANDLER_MAP[playerid]
    local name = PLAYER_ID_NAME_MAP[playerid]

    if name ~= nil then
        if currRanged ~= nil then
            inventory_dao.updateItemOrDeleteIfAmountIsZero(handler, name, currRanged, 1)
        end
        if oldRanged ~= nil then
            inventory_dao.updateItemOrInsertIfNotExist(handler, name, oldRanged, 1)
        end
        player_dao.updatePlayerRanged(handler, name, currRanged)
    end

end

function inventory_module.OnPlayerChangeArmor(playerid, currArmor, oldArmor)
    local handler = PLAYER_HANDLER_MAP[playerid]
    local name = PLAYER_ID_NAME_MAP[playerid]
    if name ~= nil then
        if currArmor ~= nil then
            inventory_dao.updateItemOrDeleteIfAmountIsZero(handler, name, currArmor, 1)
        end
        if oldArmor ~= nil then
            inventory_dao.updateItemOrInsertIfNotExist(handler, name, oldArmor, 1)
        end
        player_dao.updatePlayerArmor(handler, name, currArmor)
    end

end

return inventory_module

