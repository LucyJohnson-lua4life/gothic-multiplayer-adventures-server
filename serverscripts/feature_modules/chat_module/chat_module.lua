local chat_module = {}

local function privateMessage(playerid, params)

	local result,sendid,message = sscanf(params,"ds");
	
	if result == 1
	then
		if playerid == sendid
		then
			SendPlayerMessage(playerid,230,230,230,"Du kannst keine Nachricht an dich selbst senden.");
		else
			if IsPlayerConnected(sendid) == 1
			then
				local format_playerid = string.format("%s %s %s%d%s %s %s","(( >>",GetPlayerName(sendid),"(",sendid,"):",message,"))");
				SendPlayerMessage(playerid,239,226,108,format_playerid);
				
				local format_id = string.format("%s %s %s%d%s %s %s","((",GetPlayerName(playerid),"(",playerid,"):",message,"))");
				SendPlayerMessage(sendid,255,140,0,format_id);
			else
				SendPlayerMessage(playerid,230,230,230,"Der Spieler ist nicht online.");
			end
		end
	else
		SendPlayerMessage(playerid,230,230,230,"Use: /pm (playerid) (message)");
	end
end


local function sendMessageForDistance(playerid, text, distance, textPrefix,r,g,b)
	local name = GetPlayerName(playerid);

	for i = 0, GetMaxPlayers() - 1 do
		if IsPlayerConnected(i) == 1 then
			if GetDistancePlayers(playerid,i) < distance then 
				SendPlayerMessage(i,r,g,b,string.format("%s %s %s",name,textPrefix,text))
			end
		end
	end
end

local function sendOOC(playerid, text)
	for i = 0, GetMaxPlayers() - 1 do
		if IsPlayerConnected(i) == 1 then
			SendPlayerMessage(i, 255, 255, 0,string.format("%s %s %s", GetPlayerName(playerid)," OOC :",text))
		end
	end
end


local function sendHelpMessage(playerid)
	SendPlayerMessage(playerid, 255,255,255, "Verwende /pm (Spieler id) (Nachricht) um einer PM zu schicken.")
	SendPlayerMessage(playerid, 255,255,255, "Verwende /shout (Nachricht) um zu schreien. (Doppelte Reichweite)")
	SendPlayerMessage(playerid, 255,255,255, "Verwende /whisper um zu fluestern.")
	SendPlayerMessage(playerid, 255,255,255, "Verwende /ooc um in den ooc chat zu schreiben.")
	SendPlayerMessage(playerid, 255,255,255, "Verwende /me (Text) fuer RP Interaktionen.")
end

function chat_module.OnGamemodeInit()
    EnableChat(0);
end

function chat_module.OnPlayerCommandText(playerid, cmdtext)

	local cmd,params = GetCommand(cmdtext);
	
	if cmd == "/pm" then
        privateMessage(playerid,params)
    elseif cmd == "/shout" then
        sendMessageForDistance(playerid, params, 2000, "schreit:",230,230,230)
    elseif cmd == "/whisper" then
		sendMessageForDistance(playerid, params, 200, "fluestert:",230,230,230)
	elseif cmd == "/me" then
		sendMessageForDistance(playerid, "", 1000, params, 106, 90, 205)
	elseif cmd == "/ooc" then
		sendOOC(playerid, params)
	elseif cmdtext == "/chat help" then
		sendHelpMessage(playerid)
	end
end

function chat_module.OnPlayerText(playerid, text)
    sendMessageForDistance(playerid, text, 1000, "sagt:", 230, 230, 230)
end

return chat_module
