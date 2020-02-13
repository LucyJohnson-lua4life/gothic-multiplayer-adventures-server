
function DragonSnapper()
	local npc = CreateNPC(GetNewNPCName("Dragon Snapper"));
	
	if(npc == -1)then
		print("Creating Dragon Snapper Failed!");
	end
	
	SetPlayerInstance(npc,"DRAGONSNAPPER");
	
	SetPlayerStrength(npc, 300);
	SetPlayerDexterity(npc, 60);
	SetPlayerLevel(npc, 12);
	SetPlayerMaxHealth(npc, 400);
	SetPlayerHealth(npc, 400);
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Snapper;
	npcarr.func = Snapper;
	npcarr.respawntime = 300;
	
	return npcarr;
end