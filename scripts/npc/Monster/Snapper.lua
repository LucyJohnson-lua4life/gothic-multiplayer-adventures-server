
function Snapper()
	local npc = CreateNPC(GetNewNPCName("Snapper"));
	
	if(npc == -1)then
		print("Creating Snapper Failed!");
	end
	
	SetPlayerInstance(npc,"Snapper");
	
	SetPlayerStrength(npc, 200);
	SetPlayerDexterity(npc, 60);
	SetPlayerLevel(npc, 12);
	SetPlayerMaxHealth(npc, 320);
	SetPlayerHealth(npc, 320);
	
	
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
	
	return npcarr;
end