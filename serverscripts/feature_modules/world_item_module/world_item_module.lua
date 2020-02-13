
local world_item_module = {}

require "serverscripts/world_globals"
local world_item_dao = require "serverscripts/daos/world_item_dao"


function world_item_module.OnGamemodeInit()
    local items = world_item_dao.getAll(WORLD_HANDLER)

    if(items ~= nil) then
        while true do
            local row = mysql_fetch_assoc(items)
            if (not row) then break end
            CreateItem(row["item_instance"], row["amount"], row["pos_x"], row["pos_y"], row["pos_z"], "NEWWORLD\\NEWWORLD.ZEN")
        end    
        mysql_free_result(items)
    else
        print("World Items could not be loaded")
    end
end

function world_item_module.OnPlayerTakeItem(playerid, itemID, itemInstance, amount, x, y, z, worldName)
    if WORLD_ITEM_ID_MAP[itemID] ~= nil then
        world_item_dao.deleteItemById(WORLD_HANDLER, WORLD_ITEM_ID_MAP[itemID])
    end
end



return world_item_module