function GraveGuard()
	local npc = CreateNPC(GetNewNPCName("Grave Guard"));
	
	if(npc == -1)then
		print("Creating Grave Guard Failed!");
	end
	
	SetPlayerInstance(npc,"Swampshark");
	
	SetPlayerStrength(npc, 200);
	SetPlayerDexterity(npc, 90);
	SetPlayerLevel(npc, 18);
	SetPlayerMaxHealth(npc, 3500);
	SetPlayerHealth(npc, 3500);
	
	npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = nil;
	npcarr.attack_routine = FAI_WOLF_ATTACK;
	npcarr.WeaponMode = 0;
	npcarr.dialogs = nil;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = ON_WOLF_HIT;
	npcarr.Guild = AI_GUILD_Orc;
	npcarr.func = Stoneguardian;
	npcarr.respawntime = 600;
	npcarr.Aivars={}
    npcarr.Aivars["MaxWarnDistance"] = 750
    npcarr.Aivars["WarnDistance"] = 750
    npcarr.Aivars["MinWarnDistance"] = 750
	return npcarr;
end