function FAI_TWOH_MASTER(player)
    if FAI_CheckPlayerHealth(player) == true then
        return
    end

    if GetPlayerWeaponMode(player.ID) ~= player.WeaponMode then
        SetPlayerWeaponMode(player.ID, player.WeaponMode)
    end

    -- Remove all invisible enemies.
    if #player["ENEMY"] > 0 then
        for key, val in ipairs(player["ENEMY"]) do
            if IsNPC(val) == 0 and AI_PlayerList[val] ~= nil and AI_PlayerList[val].Invisible == true then
                table.remove(player["ENEMY"], key)
            end
        end

        -- Reset NPC when all enemies were removed
        if #player["ENEMY"] == 0 then
            FAI_AllEnemysRemoved(player)
            player.NEXTMOVES = {}

            -- Avoid endless loop of some animations like running. Such animation only stop by another animation.
            PlayAnimation(player.ID, aniHelper("S", player.WeaponMode, "RUN"))

            if player.daily_routine ~= nil then
                Reset_TA(player.ID);
            elseif player.LASTWP ~= nil then
                AI_GOTO_NOW(player.ID, player.LASTWP);
                AI_STOP_NOW(player.ID, 10);
            end
        end
    end

	if player.ENEMY[1] ~= nil then
		-- checke Spieler in der N�he
		for _, val in pairs(player["TARGETS"]) do
			local aitarget = GetPlayerOrNPC(val)
			if aitarget and aitarget.GP_IsDead == 0 and aitarget.GP_IsUnconscious == 0 and GetGuildAttitude(player, aitarget) == AI_ATTITUDE_HOSTILE and aitarget.Invisible == false then
				local dist = GetDistancePlayers(player.ID, val)
				if dist < player.Aivars["MaxWarnDistance"] then
					SetEnemy(player.ID, val)
				end
			end
		end
	end

	-- Kriege n�chsten Feind
	local shortestRangePlayer = nil
	local r = nil
    for key,val in ipairs(player["ENEMY"]) do -- val = playerid des Gegners
        local dist = GetDistancePlayers(player.ID, val)
		if r == nil or dist < r then
            r = dist
            shortestRangePlayer = val
		end

        if dist > 3000 then
            table.remove(player["ENEMY"], key);
            if next(player.ENEMY) == nil then
                FAI_AllEnemysRemoved(player);
                PlayAnimation(player.ID, "T_PERCEPTION");
                player.ENEMY = {};
                player.NEXTMOVES = {}
                if(player.daily_routine ~= nil)then
                    Reset_TA(player.ID);
                elseif(player.LASTWP ~= nil)then
                    AI_GOTO_NOW(player.ID, player.LASTWP);
                    AI_STOP_NOW(player.ID, 10);
                end
                return;
            end
		end
    end
    
    if FAI_UPDATE_NEXTMOVES(player) then
        return
    end

    if player.Aivars["Flee"] == true then
        if player.Aivars["FleeRoute"]==nil then
            player.Aivars["FleeStartWP"] = AI_WayNets[player.GP_World]:GetNearestWP(player.ID)
            player.Aivars["FleeEndWP"] = AI_WayNets[player.GP_World]:GetRandomWaypoint()
            player.Aivars["FleeWPIndex"] = 1
            player.Aivars["FleeRoute"] = AI_WayNets[player.GP_World]:GetWayRoute(player.Aivars["FleeStartWP"], player.Aivars["FleeEndWP"])
            player.LastPosUpdate = 0
            setPlayerWalkType(player.ID, 1)
        end
        if player.Aivars["FleeRoute"]==nil then
            turnPlayer(player.ID, GetAngleToPlayer(player.ID,player.ENEMY[1]) + 180)
            table.insert(player.NEXTMOVES, {type=1, anim="S_FISTRUNL"})
            table.insert(player.NEXTMOVES, {type=2, waittime=150}) -- Testen wozu der Wert gut is, original 500
        else
            local _x = player.Aivars["FleeRoute"][player.Aivars["FleeWPIndex"]].x
            local _y = player.Aivars["FleeRoute"][player.Aivars["FleeWPIndex"]].y
            local _z = player.Aivars["FleeRoute"][player.Aivars["FleeWPIndex"]].z

            if gotoPosition(player.ID, _x, _y, _z) then
                player.Aivars["FleeWPIndex"] = player.Aivars["FleeWPIndex"] + 1
                if player.Aivars["FleeRoute"][player.Aivars["FleeWPIndex"]] == nil then
                    player.Aivars["FleeRoute"] = nil
                end
            end
        end
        return
    end

    if player.ENEMY[1] == nil then
        return
    end

	-- Tausche player.ENEMY[1] mit demjenigen, der am n�chsten steht aka Targetchange
	if shortestRangePlayer ~= player.ENEMY[1] then
		for key, val in ipairs(player["ENEMY"]) do
			if val == shortestRangePlayer then
				player.ENEMY[key] = player.ENEMY[1]
				player.ENEMY[1] = shortestRangePlayer
				break
			end
		end
    end

    local AttackRange = 300
    if player.Aivars["ATTACKRANGE"] ~= nil then
        AttackRange = player.Aivars["ATTACKRANGE"]
    end

    -- Distanz zwischen Monster und Spieler > Attack Range....
    player.attackInterruptable = true
    if GetDistancePlayers(player.ID, player.ENEMY[1]) > AttackRange then
        if player.Aivars["RUNMODE"] ~= nil and player.Aivars["RUNMODE"] == 0 then
            table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("S", player.WeaponMode, "WALKL")})
        else
            table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("S", player.WeaponMode, "RUNL")})
        end
    else
        -- Distanz zwischen Monster und Spieler < Attack Range....
        local dangle = GetPlayerAngle(player.ID) - GetAngleToPlayer(player.ID, player.ENEMY[1]); -- Angle vom Monster - Angle vom Monster zum Spieler
        local timeToWait = 2700 -- Milliseconds to wait for the next attack
        local enemyWeaponMode = GetPlayerWeaponMode(player.ENEMY[1])
        if enemyWeaponMode == WEAPON_BOW or enemyWeaponMode == WEAPON_CBOW or enemyWeaponMode == WEAPON_MAGIC then
            timeToWait = timeToWait * 0.75 -- Attack more often against ranged enemies
        end
        if dangle > -20 and dangle < 20 and math.abs(GetTickCount() - player.attackWait) > timeToWait then
            -- Instant attack!
            player.attackInterruptable = false
            turnPlayer(player.ID, GetAngleToPlayer(player.ID, player.ENEMY[1]))
            PlayAnimation(player.ID, aniHelper("S", player.WeaponMode, "ATTACK"))
			if IsNPC(player.ID) == 1 and IsNPC(player.ENEMY[1]) == 1 then
				local hp = GetPlayerHealth(player.ENEMY[1]) - GetPlayerStrength(player.ID)
				if hp < 0 then
					hp = 0
				end
				SetPlayerHealth(player.ENEMY[1], hp)
				OnPlayerHit(player.ENEMY[1], player.ID)
			else
				HitPlayer(player.ID, player.ENEMY[1])
			end
            player.attackWait = GetTickCount()
            
            
            table.insert(player.NEXTMOVES, {type=2, waittime=500})
            table.insert(player.NEXTMOVES, {type=3, anim=aniHelper("S", player.WeaponMode, "ATTACK"), victim=player.ENEMY[1]})
            table.insert(player.NEXTMOVES, {type=2, waittime=500})
            table.insert(player.NEXTMOVES, {type=3, anim=aniHelper("S", player.WeaponMode, "ATTACK"), victim=player.ENEMY[1]})
            table.insert(player.NEXTMOVES, {type=2, waittime=400})
            table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("S", player.WeaponMode, "RUN")})
        elseif GetDistancePlayers(player.ID, player.ENEMY[1]) < AttackRange - 150 then
            -- When AI is to near to player, quick evade.
            table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "PARADEJUMPB")})
            table.insert(player.NEXTMOVES, {type=2, waittime=200})
        else
            local random = math.random()
            if random < 0.2 then
                table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "PARADEJUMPB")})
                table.insert(player.NEXTMOVES, {type=2, waittime=500})
            elseif random <= 0.3 then
                local pangle = GetAngleToPlayer(player.ID, player.ENEMY[1])
                if pangle > 180 then
                    -- Spieler steht links vom Monster
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFER")})
                    table.insert(player.NEXTMOVES, {type=2, waittime=300})
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFER")})
                else
                    -- Spieler steht rechts vom Monster
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFEL")})
                    table.insert(player.NEXTMOVES, {type=2, waittime=300})
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFEL")})
                end
                table.insert(player.NEXTMOVES, {type=2, waittime=400})
            elseif random <= 0.4 then
                table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "PARADEJUMPB")})
                table.insert(player.NEXTMOVES, {type=2, waittime=500})
                table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "PARADEJUMPB")})
                table.insert(player.NEXTMOVES, {type=2, waittime=300})
            elseif random <= 0.5 and dangle > -20 and dangle < 20 then
                -- Run behind enemy, turn and eventually attack
                if GetAngleToPlayer(player.ID, player.ENEMY[1]) > 180 then
                    -- Spieler steht links vom Monster
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFER")})
                else
                    -- Spieler steht rechts vom Monster
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFEL")})
                end
                table.insert(player.NEXTMOVES, {type=2, waittime=200})
                table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("S", player.WeaponMode, "RUNL")})
                table.insert(player.NEXTMOVES, {type=2, waittime=500})

                player.attackWait = player.attackWait - timeToWait * 0.5 -- Higher chance to attack
                player.attackInterruptable = false
            elseif random < 0.7 and dangle > -20 and dangle < 20 then
                -- Run to side and eventually attack
                if GetAngleToPlayer(player.ID, player.ENEMY[1]) > 180 then
                    -- Spieler steht links vom Monster
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFER")})
                else
                    -- Spieler steht rechts vom Monster
                    table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "RUNSTRAFEL")})
                end
                table.insert(player.NEXTMOVES, {type=2, waittime=200})
                table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("S", player.WeaponMode, "RUNL")})
                table.insert(player.NEXTMOVES, {type=2, waittime=100})

                player.attackWait = player.attackWait - timeToWait * 0.3 -- Higher chance to attack
                player.attackInterruptable = false
            else
                -- Do nothing
                table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("S", player.WeaponMode, "RUN")})
                table.insert(player.NEXTMOVES, {type=2, waittime=500})
            end
		end
    end
    turnPlayer(player.ID, GetAngleToPlayer(player.ID, player.ENEMY[1]))
end

function aniHelper(first, mode, ani)
    local animation = first.."_WALK"..ani
    if mode == WEAPON_NONE or mode == WEAPON_FIST then
        animation = first.."_FIST"..ani
    elseif mode == WEAPON_1H then
        animation = first.."_1H"..ani
    elseif mode == WEAPON_2H then
        animation = first.."_2H"..ani
    elseif mode == WEAPON_BOW then
        animation = first.."_BOW"..ani
    elseif mode == WEAPON_CBOW then
        animation = first.."_CBOW"..ani
    end
    return animation
end

function ON_WOLF_HIT(player, targetid)
    if IsNPC(targetid) == 1 or AI_PlayerList[targetid].Invisible == false then
        SetEnemy(player.ID, targetid);
        -- pulle befreundete Monster in der N�he
        for k, _ in pairs(GetFullPlayerList()) do
            if k ~= player.ID and type(k) == "number" and AI_NPCList[k] then
                if GetDistancePlayers(player.ID, k) < 1500 then
                    local ai = GetPlayerAI(k)
                    if GetGuildAttitude(player, ai) == AI_ATTITUDE_FRIENDLY then
                        SetEnemy(k, targetid)
                    end
                end
            end
        end
    end

    if player.Aivars.Flee == true then
        if GetPlayerHealth(player.ID) <= GetPlayerMaxHealth(player.ID) then
            player.Aivars.Flee = false
        else
            return
        end
    end

    if math.random() > 0.4 then
        -- Remove all currently planned moves if current moves are not special attacks
        if player.attackInterruptable == true then
            for k in pairs(player.NEXTMOVES) do
                player.NEXTMOVES[k] = nil
            end
            turnPlayer(player.ID, GetAngleToPlayer(player.ID, targetid))
            table.insert(player.NEXTMOVES, {type=1, anim=aniHelper("T", player.WeaponMode, "PARADEJUMPB")})
        end

        if GetPlayerWeaponMode(targetid) == WEAPON_2H then
            table.insert(player.NEXTMOVES, {type=2, waittime=200}) -- Stun for 2H
        end
        if player.attackWait > GetTickCount() - 2000 then
            player.attackWait = player.attackWait + 200 -- Lesser chance to attack
        elseif player.attackWait > GetTickCount() - 1000 then
            player.attackWait = player.attackWait - 200 -- Higher chance to attack
        end
	end
end
