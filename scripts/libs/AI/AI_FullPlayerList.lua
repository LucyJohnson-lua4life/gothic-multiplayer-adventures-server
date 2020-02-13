local FullPlayerList = {};-- This is the List with all Players and their Data

function GetFullPlayerList()
	return FullPlayerList;
end

function AddPlayerOrNPC(player)
	FullPlayerList[player.ID] = player;
end

function GetPlayerOrNPC(playerid)
	return FullPlayerList[playerid];
end

function SetPlayerOrNPC(playerid, val)
	FullPlayerList[playerid] = val;
end