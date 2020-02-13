
function FAI_HUMAN_ATTACK_UNEXP(player)
	if(GetPlayerWeaponMode(player.ID) == 0)then
		SetPlayerWeaponMode(player.ID, player.WeaponMode);
	end
	
	if(FAI_CheckPlayerHealth(player))then
		return;
	end
	
	if(FAI_UPDATE_NEXTMOVES(player))then
		return;
	end
	
	turnPlayer(player.ID, GetAngleToPlayer(player.ID,player.ENEMY[1]));
	
	if(GetDistancePlayers(player.ID, player.ENEMY[1]) > 200)then
		if(GetPlayerWeaponMode(player.ID) == 1)then
			table.insert(player.NEXTMOVES, {type=1, anim="S_FISTRUNL"});
		elseif(GetPlayerWeaponMode(player.ID) == 3)then
			table.insert(player.NEXTMOVES, {type=1, anim="S_1HRUNL"});
		elseif(GetPlayerWeaponMode(player.ID) == 4)then
			table.insert(player.NEXTMOVES, {type=1, anim="S_2HRUNL"});
		end
	else
		if(GetPlayerWeaponMode(player.ID) == 1)then
			table.insert(player.NEXTMOVES, {type=1, anim="T_FISTATTACKMOVE"});
		elseif(GetPlayerWeaponMode(player.ID) == 3)then
			table.insert(player.NEXTMOVES, {type=1, anim="T_1HATTACKMOVE"});
		elseif(GetPlayerWeaponMode(player.ID) == 4)then
			table.insert(player.NEXTMOVES, {type=1, anim="T_2HATTACKMOVE"});
		end
		
		local dangle = GetPlayerAngle(player.ID) - GetAngleToPlayer(player.ID, player.ENEMY[1]);
		if( dangle > -10 and dangle < 10 and GetDistancePlayers(player.ID, player.ENEMY[1]) < 200)then
			table.insert(player.NEXTMOVES, {type=3, victim=player.ENEMY[1]});
			table.insert(player.NEXTMOVES, {type=2, waittime=100});
		end
		
	end
end