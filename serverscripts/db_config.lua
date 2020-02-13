local db_config = {}

local host = "localhost"
local user = "gmp_master"
local password = "root"
local database_name = "gmp"

function db_config.host()
    return host
end

function db_config.user()
    return user
end

function db_config.password()
    return password
end

function db_config.database_name()
    return database_name
end

function db_config.getHandler()
    return mysql_connect(db_config.host(), db_config.user(), db_config.password(), db_config.database_name())
end


return db_config