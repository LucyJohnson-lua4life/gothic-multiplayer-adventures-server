local mfloor = math.floor;


function GetPlayers(world, x, y, z, values) -- values = Reichweite
    local baseTable = {};

    x =  mfloor(x/AI_TARGET_DISTANCE);
    y =  mfloor(y/AI_TARGET_DISTANCE);
    z =  mfloor(z/AI_TARGET_DISTANCE);

    local fpp = AI_FullPlayerPos[world]; -- alle g�ltigen Spieler/MOnster in derselben Welt

	if fpp ~= nil then -- Added von Jey

		for ix = -1*values, values, 1 do -- von -1 bis 1 do
			for iy = -1*values, values, 1 do
				for iz = -1*values, values, 1 do
					local Str = x+ix+1000*(y+iy)+1000*1000*(z+iz);
					local plPos = fpp[Str]; -- checke ob ein Spieler mit dieser pr�fsumme in der N�he steht
					if(plPos ~= nil) then -- falls ja, dann inserte alle Spieler im selben Sektor
						for key,val in pairs(plPos)do
							table.insert(baseTable, val);
						end
					end
				end
			end
		end
    end
    return baseTable; -- = alle Spieler im Sektor des Monsters
end

--[[
	DER Timer. �berpr�ft regelm��ig die Positionen und Zust�nde der Monster und Spieler
--]]

-- Debug
--local time = 0
--local updateTime = 0
--local printTime = GetTickCount()

function AI_Timer()
	--local a = GetTickCount();

	-- TODO: rework
    AI_FullPlayerPos = {};

	-- Sammle alle Spieler/Monsterdaten
    for key,val in pairs(GetFullPlayerList()) do
        val.GP_World = string.upper(trim(GetPlayerWorld(key)));
        val.GP_IsDead = IsDead(key);
        val.GP_IsUnconscious = IsUnconscious(key);
		val.GP_IsNPC = IsNPC(key); -- Added von Jey
		--val.GP_Guardian = IsGUARDIAN(key); -- by Migos
		val.GP_passiveNPC = IspassiveNPC(key); -- by Migos

        local x,y,z = GetPlayerPos(key);
        val.GP_PosX = x;
        val.GP_PosY = y;
        val.GP_PosZ = z;

		--if(val.GP_IsNPC == 0 or val.GP_Guardian)then -- Schalter zum deaktivieren der �berpr�fung ob Gegner Feind/Freund ist - nur f�r NPC - Wachen werden per val.GP_Guardian aber doch mit abgfragt
		if not(val.GP_passiveNPC) then -- damit die passiven NPCs nicht die Monster abfragen
			if(AI_FullPlayerPos[val.GP_World] == nil)then
				AI_FullPlayerPos[val.GP_World] = {};
			end


			local xStr = mfloor(x/AI_TARGET_DISTANCE)+1000*mfloor(y/AI_TARGET_DISTANCE)+1000*1000*mfloor(z/AI_TARGET_DISTANCE);

			if(AI_FullPlayerPos[val.GP_World][xStr] == nil)then
				AI_FullPlayerPos[val.GP_World][xStr] = {};
			end
			table.insert(AI_FullPlayerPos[val.GP_World][xStr], val); -- speichere Spieler mit Pos etc in AI_FullPlayerPos[welt][pr�fsumme][id]
		end
	end

	--local b = GetTickCount()

	-- �berpr�fe gesammelte Informationen und update alle Routines
	for _, val in pairs(AI_NPCList_Sort) do
		AI_Update(val);
	end

	--local c = GetTickCount()
	--time = time + b - a;
	--updateTime = updateTime + c - b
	--if GetTickCount() - printTime > 1000 then
	--	print("AI Time: t"..time.." u"..updateTime.." ("..time + updateTime.." / 1000)");
	--	time = 0
	--	updateTime = 0
	--	printTime = GetTickCount()
	--end
end

--[[
	�berpr�f-Logik
--]]
function AI_Update(_playerid)
    local ainpc = AI_NPCList[_playerid];

	if ainpc == nil or ainpc.ID == nil then
		return;
	end;

	if not(IspassiveNPC(_playerid)) and (ainpc.GP_IsDead == 0 and ainpc.GP_IsUnconscious == 0 and ainpc.TargetFunc ~= nil and ainpc["INDIALOG"] == false) then
        -- kriege alle Spieler die in der N�he des Monsters stehen
		local npcList = GetPlayers(ainpc.GP_World, ainpc.GP_PosX, ainpc.GP_PosY ,ainpc.GP_PosZ , 1);
		
		ainpc["OLD_TARGETS"] = ainpc["TARGETS"];
        ainpc["TARGETS"] = {};
        local targetdistance = ainpc.Aivars["TARGETDISTANCE"];
        for key,val in pairs(npcList)do -- checke alle Spieler im Sektor des Monsters
			CheckTargetPlayer(ainpc, val, targetdistance);
        end
        ainpc["OLD_TARGETS"] = {};
    end

    if(next(ainpc["ENEMY"]) ~= nil and ainpc.AttackFunc ~= nil and ainpc["INDIALOG"] == false )then
        ENEMY_DISCONNECTED(_playerid)

        if(next(ainpc["ENEMY"]) ~= nil)then
            AI_NPCList[_playerid].AttackFunc(AI_NPCList[_playerid]);
            return;--INTERRUPTED because he attacks the enemy...
        end
    end



    if(ainpc.DailyRoutine ~= nil and ainpc["UPDATETA"] and ainpc["INDIALOG"] == false)then
        ainpc.DailyRoutine(_playerid);
    end

    if(ainpc.UpdateFunc ~= nil  and ainpc["INDIALOG"] == false)then
        ainpc.UpdateFunc(_playerid);
    end

    updateImportantDialogs(_playerid);


    if(ainpc["INTERRUPTED"])then
        return; -- INTERRUPT AI STATES!
    end

    if(ainpc.GP_IsDead == 1 or ainpc.GP_IsUnconscious == 1)then
        return;
    end

    if(next(ainpc["STATES"]) == nil)then
        if(ainpc.LastState ~= nil and ainpc.LastState.Continue == true)then
            ainpc.LastState.start = true;
            --print("LS");
			--print(_playerid);
            table.insert(ainpc["STATES"], AI_NPCList[_playerid].LastState);
            return;
        else
            return;
        end
    end

    ainpc["STATES"][1]:update();
end

function IsGUARDIAN(key)
	if key ~= nil and AI_NPCList[key] ~= nil and AI_NPCList[key].Guardian ~= nil then
		return true;
	else
		return false;
	end;
end;

function IspassiveNPC(key)
	if key ~= nil and AI_NPCList[key] ~= nil and AI_NPCList[key].passiveNPC ~= nil then
		return true;
	else
		return false;
	end;
end;

function mysql_check_connection()
    if mysql_handler then
        if (mysql_ping(mysql_handler) == false) then
            mysql_close(mysql_handler);
            mysql_handler = mysql_connect(database_ip, database_user, database_password, database_name);
            if (mysql_ping(mysql_handler) == true) then
                LogString("logs/techlog_"..cur_date.."","INFO: Database was idle for too long. Reconnected.");
                return true;
            else
                LogString("logs/techlog_"..cur_date.."","WARNING: Database seems to be offline.");
                return false;
            end
        else
            return true;
        end
    else
        mysql_handler = mysql_connect(database_ip, database_user, database_password, database_name);
	end
end

function updateImportantDialogs(_playerid) -- playerid = NPC
    local ainpc = AI_NPCList[_playerid];
    if(next(ainpc.Dialogs) ~= nil and ainpc["INDIALOG"] == false and ainpc.GP_IsDead == 0 and ainpc.GP_IsUnconscious == 0)then
    --Check Distance to players!
        for key,val in pairs(AI_PlayerList) do -- val.ID = Spieler
            if(val ~= nil)then
                local distance = GetDistancePlayers(val.ID, _playerid);
                if(val.GP_World == ainpc.GP_World and distance < 600 and distance ~= 0 and val.GP_IsDead == 0 and val.GP_IsDead == 0)then--Distance has to be less then 1000
                    if(ainpc["DIA_TARGETLIST"][val.ID] == nil)then
						-- Sebalt
						if GetPlayerName(_playerid) == "Sebalt" then
							local name = GetPlayerName(val.ID);
								if (mysql_check_connection() == true) then
								local result = mysql_query(mysql_handler, "SELECT `anzahl` FROM `inventar` WHERE `item` ='itwr_passierschein' AND `name` = '"..name.."'");
								-- IF hat Passierschein THEN nicht ansprechen ELSE ansprechen
								if mysql_num_rows(result) == 1 then
									mysql_free_result(result);
									ainpc["DIA_TARGETLIST"][val.ID] = true;
									_SebaltGespraech[val.ID] = false;
									return;
									--AI_PlayerList[_npc]["KnowsDialog"][val2["func"]] = nil;
								else
									mysql_free_result(result);
									-- Start Sebalt Dialog
									for key2,val2 in ipairs(ainpc.Dialogs) do
										if(val2["type"] == 1 and val.KnowsDialog[val2["func"]] == nil)then--The Dialog is important!
											--Check the Condition-Func
											local dCond = true;
											if(val2["condFunc"] ~= nil)then --condFunc ist bei Sebalt = nil
												dCond = val2["condFunc"](val.ID, _playerid);
											end

											--First time to speak with the npc?
											--if(val2["listener"][val.ID] == nil)then
												if(dCond ) then -- ist true
													--startDialog(_playerid, val);

													ainpc["INACTIVESTATES"] = table.copy(AI_NPCList[_playerid]["STATES"]);
													ainpc["STATES"] = {};
													-- ainpc["INDIALOG"] = true;
													ainpc.DIA_TARGET = val.ID;

													--PlayAnimation(_playerid, "S_LGUARD");
													--PlayAnimation(val.ID, "S_LGUARD");

													FreezePlayer(val.ID,1);
													FreezePlayer(_playerid,1);

													PlayGesticulation(val.ID);
													PlayGesticulation(_playerid);
													AI_TURNTOPLAYERAO(_playerid, val.ID);

													val.DIALOGPATNER = _playerid;
													_SebaltGespraech[val.ID] = true;
													val2["func"](val.ID, _playerid); -- rufe die Dialog Funktion auf

													-- val.KnowsDialog[val2["func"]] = val2["func"];

													ainpc["DIA_TARGETLIST"][val.ID] = true;
													-- val2["listener"][val.ID] = val.ID;
													return;
												end

											--end
										end
									end
									-- Ende Dialog
								end;
							end;

						else
							-- Start Important,Dialogs
							for key2,val2 in ipairs(ainpc.Dialogs) do
								if(val2["type"] == 1 and val.KnowsDialog[val2["func"]] == nil)then--The Dialog is important!
									--Check the Condition-Func
									local dCond = true;
									if(val2["condFunc"] ~= nil)then
										dCond = val2["condFunc"](val.ID, _playerid);
									end

									--First time to speak with the npc?
									--if(val2["listener"][val.ID] == nil)then
										if(dCond ) then
											--startDialog(_playerid, val);

											ainpc["INACTIVESTATES"] = table.copy(AI_NPCList[_playerid]["STATES"]);
											ainpc["STATES"] = {};
											ainpc["INDIALOG"] = true;
											ainpc.DIA_TARGET = val.ID;

											--PlayAnimation(_playerid, "S_LGUARD");
											--PlayAnimation(val.ID, "S_LGUARD");

											FreezePlayer(val.ID,1);
											FreezePlayer(_playerid,1);

											PlayGesticulation(val.ID);
											PlayGesticulation(_playerid);
											AI_TURNTOPLAYERAO(_playerid, val.ID);

											val.DIALOGPATNER = _playerid;
											val2["func"](val.ID, _playerid);
											val.KnowsDialog[val2["func"]] = val2["func"];

											ainpc["DIA_TARGETLIST"][val.ID] = val.ID;
											val2["listener"][val.ID] = val.ID;
											return;
										end

									--end
								end
							end;
							-- Ende Dialog
                        end

                        ainpc["DIA_TARGETLIST"][val.ID] = val.ID;
                    end
                elseif(val.GP_World ~= ainpc.GP_World or GetDistancePlayers(val.ID, _playerid) > 700 or _SebaltGespraech[val.ID] == nil)then--if the distance is over 1100 he will remove the target from the targetlist.
                    if(ainpc["DIA_TARGETLIST"][val.ID] ~= nil)then
                        ainpc["DIA_TARGETLIST"][val.ID] = nil;
						_SebaltGespraech[val.ID] = nil;
                    end
                end

            end
        end
    end
end


function CheckTargetPlayer(ainpc, val, TargetDistance) -- ainpc = Monster, val = Spieler
    if(val ~= nil and val.ID ~= ainpc.ID and (val.Invisible == nil or val.Invisible == false) and val["INDIALOG"] == false)then
        local distancePlayer =  getDistance(val.GP_PosX, val.GP_PosY, val.GP_PosZ, ainpc.GP_PosX,ainpc.GP_PosY,ainpc.GP_PosZ)--GetDistancePlayers(val.ID, _playerid);
        local targetsList = ainpc["TARGETS"];

        if(distancePlayer < TargetDistance and distancePlayer ~= 0)then--Distance has to be less then 1000
            if(ainpc["OLD_TARGETS"][val.ID] == nil)then
                ainpc.TargetFunc(ainpc.ID, val.ID);
            end
            targetsList[val.ID] = val.ID; -- playerid des Gegners
        end
    end
end
