require "scripts/dialogs/Dia_Moe"

function VLK_432_Moe()
	local npc = CreateNPC(GetNewNPCName("Moe"));
	
	SetPlayerAdditionalVisual(npc,"Hum_Body_Babe0",1, "Hum_Head_FatBald", 1);
	SetPlayerWalk(npc, "HumanS_Relaxed.mds");
	SetPlayerInstance(npc,"PC_HERO");
	SetPlayerFatness(npc, 0.5);
	SetPlayerStrength(npc, 100);
	--Items:
	EquipArmor(npc,"ITAR_Vlk_L");
	EquipMeleeWeapon(npc,"ItMw_1h_Bau_Mace");
	
	
	
	local dialogs = {};
	addDialog(dialogs, 2, test_trade, nil, "Let's Trade!");
	addDialog(dialogs, 2, test_dialog, nil, "Dies ist eine Test-Funktion!");
	addDialog(dialogs, 2, test_dialog, nil, "Dies ist eine zweite Test-Funktion!");
	addDialog(dialogs, 2, test_dialog, nil, "Dies ist eine dritte Test-Funktion!");
	addDialog(dialogs, 2, test_dialog, nil, "Dies ist eine vierte Test-Funktion!");
	addDialog(dialogs, 2, test_dialog, nil, "Dies ist eine fuenfte Test-Funktion!");
	
	--addDialog(dialogs, 1, IMPORTENT_DIALOG, nil, "");
	
	
	local npcarr = {};
	npcarr.id = npc;
	npcarr.daily_routine = TA_VLK_432;
	npcarr.attack_routine = FAI_HUMAN_ATTACK_UNEXP;
	npcarr.WeaponMode = 3;
	npcarr.dialogs = dialogs;
	npcarr.update_func = AI_UP_MONSTER;
	npcarr.target_routine = AI_TA_MONSTER;
	npcarr.onhitted = OnHitted;
	npcarr.Guild = AI_GUILD_GuildLess;
	npcarr.aivar = {};
	npcarr.aivar["WARNTIME"] = 0;
	
	npcarr.tradingInventory = {};
	npcarr.tradingInventory["ITMW_BELIARWEAPON_2H_20"] = {};
	npcarr.tradingInventory["ITMW_BELIARWEAPON_2H_20"].Item = "ITMW_BELIARWEAPON_2H_20";
	npcarr.tradingInventory["ITMW_BELIARWEAPON_2H_20"].Amount = 1;

	
	return npcarr;
end

function OnHitted(player, targetid)
	SetEnemy(player.ID, targetid);
end



function TA_VLK_432(_playerid)
	
	if(TA_FUNC(_playerid, 0, 0, 24, 0))then
		AI_ClearStates(_playerid);
		AI_SETWALKTYPE(_playerid, 0);--Let him walk!
		AI_GOTOFP(_playerid, "FP_STAND_CITY_01");
		AI_ALIGNTOFP(_playerid, "FP_STAND_CITY_01");
		--AI_PLAYANIMATION(_playerid, "S_LGUARD");
		--AI_SETENEMY(_playerid, 1);
		--AI_OUTPUT(_playerid, 1, "DIA_Moe_Hallo_01_00", "Hey, ich kenne dich nicht. Was willst du hier? Willst du in die Kneipe?");
	end
end