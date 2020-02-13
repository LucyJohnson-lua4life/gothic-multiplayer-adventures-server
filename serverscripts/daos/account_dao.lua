local account_dao = {}

function account_dao.accountExists(handler, name, password)
    local player_name = mysql_escape_string(handler, name)
    local player_password = SHA256(mysql_escape_string(handler, password))
    return mysql_query(handler, "SELECT name FROM player where name = '"..player_name.."' and password = '"..player_password.."'")
end

return account_dao