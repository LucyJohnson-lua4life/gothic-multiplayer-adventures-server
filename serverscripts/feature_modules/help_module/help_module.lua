local help_module = {}


function help_module.OnPlayerCommandText(playerid, cmdtext)
    if cmdtext == "/help" then
        SendPlayerMessage(playerid,230,230,230,"Verwende folgende Kommandos fuer weitere Informationen.")
        SendPlayerMessage(playerid,230,230,230,"/anim help, /walk help, /inventory help, /logout help, /chat help, /suicide help, /destroy account help")
    end
end


function help_module.OnPlayerSpawn(playerid, classid)
    SendPlayerMessage(playerid,230,230,230,"Verwende /help fuer Informationen.")
end

return help_module