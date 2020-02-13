local player_gold_dao = {}

function player_gold_dao.insert(handler, name, amount)
    local player_name = mysql_escape_string(handler, name)
    local result = mysql_query(handler, "insert into player_gold (id, player_name, amount) VALUES(null, '".. player_name .."',".. amount ..")")
    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end

function player_gold_dao.updateItemAmount(handler, name, amount)
    local player_name = mysql_escape_string(handler, name)
    return mysql_query(handler, "update player_gold set amount = "..amount.." where player_name = '"..player_name.."';")
end


function player_gold_dao.getAmount(handler, name)
    local player_name = mysql_escape_string(handler, name)
    
    return mysql_query(handler, "select amount from player_gold where player_name = '".. player_name .."';")
end

return player_gold_dao