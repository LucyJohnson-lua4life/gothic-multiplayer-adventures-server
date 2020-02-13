local world_item_dao = {}

function world_item_dao.insertItem(handler, item_instance, amount, x, y, z)
    local item_name = mysql_escape_string(handler, item_instance)
    local result = mysql_query(handler, "insert into world_item (id, item_instance, amount, pos_x, pos_y, pos_z) VALUES(null, '".. item_name .."', ".. amount ..",".. x .. ",".. y ..",".. z ..")")
    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end

function world_item_dao.deleteItemById(handler, id)
    local result = mysql_query(handler, "delete from world_item where id = "..id..";")
    if result == nil then
        return false
    else
        return true
    end
end


function world_item_dao.getAll(handler)
    return mysql_query(handler, "select * from world_item;")
end


return world_item_dao