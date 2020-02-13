require "serverscripts/player_globals"
local inventory_dao = require "serverscripts/daos/inventory_dao"

local DROPABLE_ITEMS = {}

DROPABLE_ITEMS["ITMI_GOLDNUGGET_ADDON"] = true
DROPABLE_ITEMS["ITAT_WARGFUR"] = true
DROPABLE_ITEMS["ITAT_WOLFFUR"] = true
DROPABLE_ITEMS["ITAT_TROLLFUR"] = true
DROPABLE_ITEMS["ITAT_SHADOWFUR"] = true
DROPABLE_ITEMS["ITAT_ADDON_KEILERFUR"] = true

local robbing_module = {}

local function robItem(robber_id, victim_id, item_name, amount)
    if DROPABLE_ITEMS[item_name] ~= nil then
        inventory_dao.deleteItemByInstance(PLAYER_HANDLER_MAP[victim_id], PLAYER_ID_NAME_MAP[victim_id], item_name)
        RemoveItem(victim_id, item_name, amount)
        GiveItem(robber_id, item_name, amount)
        SendPlayerMessage(robber_id,255, 255, 255, tostring(amount).."x "..item_name.." geraubt.")
    end
end

local function robItems(robber_id, victim_id)
    local items = inventory_dao.getAllItemsAndAmountByName(PLAYER_HANDLER_MAP[victim_id], PLAYER_ID_NAME_MAP[victim_id])
    if(items ~= nil) then
        while true do
            local row = mysql_fetch_assoc(items)
            if (not row) then break end
            local item_name = string.upper(row["item_name"])
            local amount = row["amount"]
            robItem(robber_id, victim_id, item_name, amount)
        end    
        mysql_free_result(items)
    end
end

function robbing_module.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/rob" then
        local focusid = GetFocus(playerid);
        if IsUnconscious(focusid) == 1 or IsDead(focusid) == 1 then 
            robItems(playerid, focusid)
        end
    end
end

return robbing_module