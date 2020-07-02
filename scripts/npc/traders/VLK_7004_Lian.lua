
function VLK_7004_Lian()
	local npc = CreateNPC(GetNewNPCName("Lian"));
	
	SetPlayerAdditionalVisual(npc,"Hum_Body_Naked0",1, "Hum_Head_FatBald", 51);
	SetPlayerWalk(npc, "HumanS_Relaxed.mds");
	SetPlayerInstance(npc,"PC_HERO");
	SetPlayerFatness(npc, 0.5);
    SetPlayerStrength(npc, 10);
    SetPlayerHealth(npc, 9999);
    SetPlayerMaxHealth(npc, 9999);
	--Items:
	EquipArmor(npc,"ITAR_Leather_L");
	--EquipMeleeWeapon(npc,"ItMw_1h_Bau_Mace");

	
	local npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = TA_VLK_7004;
	npcarr.attack_routine = FAI_HUMAN_ATTACK_UNEXP;
	npcarr.WeaponMode = 3;
	npcarr.dialogs = dialogs;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = nil;
	npcarr.Guild = AI_GUILD_GuildLess;
	npcarr.aivar = {};
	npcarr.aivar["WARNTIME"] = 0;
	
	return npcarr;
end


function TA_VLK_7004(_playerid)
	
	if(TA_FUNC(_playerid, 0, 0, 24, 0))then
		AI_ClearStates(_playerid);
		AI_SETWALKTYPE(_playerid, 0);--Let him walk!
		AI_GOTOFP(_playerid, "FP_ROAM_TAVERNE_TROLLAREA_02_04");
		AI_ALIGNTOFP(_playerid, "FP_ROAM_TAVERNE_TROLLAREA_02_04");
		AI_PLAYANIMATION(_playerid, "S_LGUARD");
	end
end