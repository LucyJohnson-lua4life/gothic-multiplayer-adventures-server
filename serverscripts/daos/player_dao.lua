local player_dao = {}

-- handler and values must not be null
--[[ values has following format: 
    string: values.name
    string: values.password
    string: values.body_model 
    number: values.body_tex
    string: values.head_model
    number: values.head_tex
    string: values.melee_weapon
    string: values.ranged_weapon
    string: values.armor
    number: values.str
    number: values.dex
    number: values.one_h
    number: values.two_h
    number: values.bow
    number: values.cbow
    number: values.max_health
    number: values.health
    number: values.mana
    number: values.max_mana
    number: values.magic_level
    number: values.class_id
]]

function player_dao.insertPlayer(handler, values)
        local playerName = mysql_escape_string(handler, values.name);
        local playerPassword = mysql_escape_string(handler, values.password);
        local bodyModel = mysql_escape_string(handler, values.body_model);
        local headModel = mysql_escape_string(handler, values.head_model);
        local melee_weapon = mysql_escape_string(handler, values.melee_weapon);
        local ranged_weapon = mysql_escape_string(handler, values.ranged_weapon);
        local armor = mysql_escape_string(handler, values.armor);

        local result = mysql_query(handler, "INSERT INTO player (name, password, body_model, head_model, body_tex, head_tex, melee_weapon, armor, ranged_weapon, str, dex, one_h, two_h, bow, cbow, health, max_health, mana, max_mana, magic_level, class_id, pos_x , pos_y , pos_z) VALUES ('" .. playerName .."', '" .. playerPassword .."', '" .. bodyModel .."', '" .. headModel .."', " .. values.body_tex ..", ".. values.head_tex ..", '" .. melee_weapon .."', '" .. armor .."', '" .. ranged_weapon .."', " .. values.str ..", " .. values.dex ..", " .. values.one_h ..", " .. values.two_h ..", " .. values.bow ..", " .. values.cbow ..", " .. values.health ..", " .. values.max_health ..", " .. values.mana ..", " .. values.max_mana ..", ".. values.magic_level ..", "..values.class_id ..", 0,0,0);");
       
       if result ~= nil then
            mysql_free_result(result);
            return true
        else
            return false
        end
end

function player_dao.updatePlayerPos(handler, name, x, y, z)
    local result = mysql_query(handler, "UPDATE player SET pos_x="..tostring(x)..", pos_y="..tostring(y)..", pos_z="..tostring(z).." WHERE name='"..name.."';")

    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end


function player_dao.updatePlayerMelee(handler, name, item_instance)
    local item_name = mysql_escape_string(handler, item_instance)
    local result = mysql_query(handler, "UPDATE player SET melee_weapon='"..item_name.."' WHERE name='"..name.."';")

    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end


function player_dao.updatePlayerArmor(handler, name, item_instance)
    local item_name = mysql_escape_string(handler, item_instance)
    local result = mysql_query(handler, "UPDATE player SET armor='"..item_name.."' WHERE name='"..name.."';")

    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end

function player_dao.updatePlayerRanged(handler, name, item_instance)
    local item_name = mysql_escape_string(handler, item_instance)
    local result = mysql_query(handler, "UPDATE player SET ranged_weapon='"..item_name.."' WHERE name='"..name.."';")

    if result ~= nil then
        mysql_free_result(result);
        return true
    else
        return false
    end
end

function player_dao.getPlayerPos(handler, name)
    local result = mysql_query(handler, "SELECT pos_x, pos_y, pos_z FROM player WHERE name='"..name.."';")
    local vals = nil
    if result ~= nil then
        vals = mysql_fetch_assoc(result)
        mysql_free_result(result)
    end
    return vals
end

function player_dao.loadPlayerValues(handler, name, password)
    local player_name = mysql_escape_string(handler, name)
    local player_password = mysql_escape_string(handler, password)
    
    local result = mysql_query(handler, "SELECT * FROM player where name = '"..player_name.."' and password = '"..player_password.."'")
    local vals = nil
    if result == nil then
        vals = nil
    else
        vals = mysql_fetch_assoc(result)
        mysql_free_result(result)
    end
    return vals

end

function player_dao.nameExists(handler, name)
    local player_name = mysql_escape_string(handler, name)
    local result = mysql_query(handler, "SELECT * FROM player where name = '" .. player_name .. "';");
    if (mysql_fetch_assoc(result) == nil) then
        mysql_free_result(result)
        return false;
    else
        return true;
    end
end

function player_dao.getClass(handler, name)
    local player_name = mysql_escape_string(handler, name)
    return mysql_query(handler, "SELECT class_id FROM player where name = '" .. player_name .. "';");
end

function player_dao.deletePlayer(handler, name)
    local player_name = mysql_escape_string(handler, name)
    local result = mysql_query(handler, "delete from player where name = '"..player_name.."'")
    if result == nil then
        return false
    else
        return true
    end

end

return player_dao