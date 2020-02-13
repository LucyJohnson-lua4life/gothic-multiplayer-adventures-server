function Swampshark()
	local npc = CreateNPC(GetNewNPCName("Swampshark"));
	
	if(npc == -1)then
		print("Creating Swampshark Failed!");
	end
	
	SetPlayerInstance(npc,"Swampshark");
	
	SetPlayerStrength(npc, 250);
	SetPlayerDexterity(npc, 170);
	SetPlayerLevel(npc, 24);
	SetPlayerMaxHealth(npc, 440);
	SetPlayerHealth(npc, 440);
	
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Swampshark;
	npcarr.func = Swampshark;
	npcarr.respawntime = 300;
	
	return npcarr;
end