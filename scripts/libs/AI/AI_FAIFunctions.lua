function FAI_UPDATE_NEXTMOVES(player)
	if(next(player.NEXTMOVES) ~=nil)then
		if(player.NEXTMOVES[1]["type"] == 1)then
			PlayAnimation(player.ID,player.NEXTMOVES[1]["anim"]);
			table.remove(player.NEXTMOVES, 1);
			return true;
		end
		if(player.NEXTMOVES[1]["type"] == 2)then--Wait!
			if(player.NEXTMOVES[1]["startime"] == nil)then
				player.NEXTMOVES[1]["startime"] = GetGameTime();
			end
			if(player.NEXTMOVES[1]["startime"] + player.NEXTMOVES[1]["waittime"] < GetGameTime())then
				table.remove(player.NEXTMOVES, 1);
			end
			return true;
		end
		if(player.NEXTMOVES[1]["type"] == 3)then
			
			PlayAnimation(player.ID, player.NEXTMOVES[1]["anim"])
			if(IsNPC(player.ID) == 1 and IsNPC(player.NEXTMOVES[1]["victim"]) == 1)then
				local hp = GetPlayerHealth(player.NEXTMOVES[1]["victim"])-GetPlayerStrength(player.ID);
				if(hp < 0)then
					hp = 0;
				end
				SetPlayerHealth(player.NEXTMOVES[1]["victim"],hp);
				OnPlayerHit(player.NEXTMOVES[1]["victim"], player.ID);
			else
				HitPlayer(player.ID, player.NEXTMOVES[1]["victim"]);
			end
			player.attackWait = GetTickCount()
			table.remove(player.NEXTMOVES, 1);
			return true;
		end
		if(player.NEXTMOVES[1]["type"] == 4)then
			if(player.WeaponMode ~= 0)then
				if(player.NEXTMOVES[1]["weaponModeType"] == nil or player.NEXTMOVES[1]["weaponModeType"] == 0)then
					SetPlayerWeaponMode(player.ID, 0);
				else
					SetPlayerWeaponMode(player.ID, player.WeaponMode);
				end
			end
			table.remove(player.NEXTMOVES, 1);
		end
		if(player.NEXTMOVES[1]["type"] == 5)then
			turnPlayer(player.ID, GetAngleToPlayer(player.ID, player.NEXTMOVES[1]["target"]));
			table.remove(player.NEXTMOVES, 1);
		end
	end

	return false;
end

function FAI_CheckPlayerHealth(player)
	--The NPC is dead!
	if GetPlayerHealth(player.ID) == 0 then
		player.ENEMY = {}

		if(GetPlayerWeaponMode(player.ID) ~= 0)then
			SetPlayerWeaponMode(player.ID, 0)
		end

		PlayAnimation(player.ID, "S_DEAD");

		if player.daily_routine ~= nil then
			Reset_TA(player.ID)
		end

		return true;
	end

	-- NPC is unconsious. Only possible for humans
	if IsUnconscious(player.ID) == 1 then
		return true
	end

	--The Enemy is dead!
	if player.ENEMY[1] ~= nil and GetPlayerHealth(player.ENEMY[1]) == 0 then
		player.TARGETS[player.ENEMY[1]] = nil;
		table.remove(player.ENEMY, 1);

		if(next(player.ENEMY) == nil)then
			FAI_AllEnemysRemoved(player);
			PlayAnimation(player.ID, "R_CLEAN");
			player.ENEMY = {};

			if(player.daily_routine ~= nil)then
				Reset_TA(player.ID);
			end

			return true;
		else
			FAI_CheckPlayerHealth(player);
		end

	end
	return false;
end

function FAI_AllEnemysRemoved(player)
	player.Aivars["Flee"] = false;
	player.Aivars["FleeRoute"] = nil;

	SetPlayerWeaponMode(player.ID, 0);
end


