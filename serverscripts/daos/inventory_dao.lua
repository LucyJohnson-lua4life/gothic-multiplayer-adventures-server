local inventory_dao = {}

function inventory_dao.insertItem(handler, name, item_instance, amount)
    local player_name = mysql_escape_string(handler, name)
    local item_name = mysql_escape_string(handler, item_instance)
    local result = mysql_query(handler, "insert into inventory (id, inventory_from, item_name, amount) VALUES(null, '".. player_name .."', '".. item_name .."',".. amount ..")")
    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end

function inventory_dao.getAllItemsAndAmountByName(handler, name)
    local player_name = mysql_escape_string(handler, name)
    return mysql_query(handler, "select item_name, amount from inventory where inventory_from = '".. player_name .."'")
end


function inventory_dao.getItemAndAmountByInstance(handler, name, item_instance)
    local player_name = mysql_escape_string(handler, name)
    local item_name = mysql_escape_string(handler, item_instance)
    
    return mysql_query(handler, "select item_name, amount from inventory where inventory_from = '".. player_name .."' and item_name = '"..item_name.."'")
end

function inventory_dao.updateItemAmount(handler, name, item_instance, amount)
    local player_name = mysql_escape_string(handler, name)
    local item_name = mysql_escape_string(handler, item_instance)

    return mysql_query(handler, "update inventory set amount = "..amount.." where inventory_from = '"..player_name.."' and item_name = '"..item_name.."'")
end

function inventory_dao.deleteItemByInstance(handler, name, item_instance)
    local player_name = mysql_escape_string(handler, name)
    local item_name = mysql_escape_string(handler, item_instance)
    local result = mysql_query(handler, "delete from inventory where inventory_from = '"..player_name.."' and item_name = '"..item_name.."'")
    if result == nil then
        return false
    else
        return true
    end
end

function inventory_dao.deleteItemByPlayerName(handler, name)
    local player_name = mysql_escape_string(handler, name)
    local result = mysql_query(handler, "delete from inventory where inventory_from = '"..player_name.."'")
    if result == nil then
        return false
    else
        return true
    end
end

function inventory_dao.updateItemOrDeleteIfAmountIsZero(handler, name, item_instance, amount)
    local result = inventory_dao.getItemAndAmountByInstance(handler, name, item_instance)
    local row = mysql_fetch_assoc(result)
    
    if row ~= nil and row["amount"] ~= nil then
        local new_amount = tonumber(row["amount"]) - amount
        if new_amount > 0 then
            inventory_dao.updateItemAmount(handler, name, item_instance, new_amount)
        elseif new_amount <= 0 then
            inventory_dao.deleteItemByInstance(handler, name, item_instance)
        end
    end
end

function inventory_dao.updateItemOrInsertIfNotExist(handler, name, item_instance, amount)
    local result = inventory_dao.getItemAndAmountByInstance(handler, name, item_instance)
    local row = mysql_fetch_assoc(result)

    if row == nil then
        inventory_dao.insertItem(handler, name, item_instance, amount)
    elseif row ~= nil and row["amount"] ~= nil then
        local newAmount = tonumber(row["amount"]) + amount
        inventory_dao.updateItemAmount(handler, name, item_instance, newAmount)
    end

end


return inventory_dao