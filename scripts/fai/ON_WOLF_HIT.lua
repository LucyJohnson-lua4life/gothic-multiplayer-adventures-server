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
