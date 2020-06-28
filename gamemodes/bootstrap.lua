local db_config = require "serverscripts/db_config"
local authentication_module = require "serverscripts/feature_modules/authentication_module/authentication_module"
local inventory_module = require "serverscripts/feature_modules/inventory_module/inventory_module"
local player_death_module = require "serverscripts/feature_modules/player_death_module/player_death_module"
local spells_module = require "serverscripts/feature_modules/spells_module/spells_module"
local anim_module = require "serverscripts/feature_modules/anim_module/anim_module"
local destroy_account_module = require "serverscripts/feature_modules/destroy_account_module/destroy_account_module"
local item_exchange_module = require "serverscripts/feature_modules/item_exchange_module/item_exchange_module"
local chat_module = require "serverscripts/feature_modules/chat_module/chat_module"
local logout_module = require "serverscripts/feature_modules/logout_module/logout_module"
local help_module = require "serverscripts/feature_modules/help_module/help_module"
local npc_module = require "serverscripts/feature_modules/npc_module/npc_module"
local directory_scan = require "serverscripts/security/directory_scan"
local recovery_module = require "serverscripts/feature_modules/recovery_module/recovery_module"
local mining_module = require "serverscripts/feature_modules/mining_module/mining_module"
local npc_trade_module = require "serverscripts/feature_modules/npc_trade_module/npc_trade_module"
local heal_other = require "serverscripts/feature_modules/custom_runes/heal_other"
local player_gold_module = require "serverscripts/feature_modules/player_gold_module/player_gold_module"
local robbing_module = require "serverscripts/feature_modules/robbing_module/robbing_module"
local npc_quest_module = require "serverscripts/feature_modules/npc_quest_module/npc_quest_module"
local debug = require "filterscripts/debug"
local npc_fraction_module = require "serverscripts/feature_modules/npc_fraction_module/npc_fraction_module"

function OnGamemodeInit()
	WORLD_HANDLER = db_config.getHandler()
	print("--------------------");
	print("Description gamemode");
	print("--------------------");
	chat_module.OnGamemodeInit()
	--EnableExitGame(0)
	recovery_module.OnGamemodeInit()
	npc_module.OnGamemodeInit()
	npc_fraction_module.OnGamemodeInit()
end

function OnGamemodeExit()

	print("-------------------");
	print("Gamemode was exited");
	print("-------------------");
end

function OnPlayerFileList(playerid, pathFile,fileEnding, fileCounter, fileList)
	--directory_scan.OnPlayerFileList(playerid, pathFile,fileEnding, fileCounter, fileList)
end

function OnPlayerChangeGold(playerid, currGold, oldGold)
	player_gold_module.OnPlayerChangeGold(playerid, currGold, oldGold)
end

function OnPlayerChangeClass(playerid, classid)
end

function OnPlayerSelectClass(playerid, classid)
end

function OnPlayerSpellCast(playerid, spellInstance)
	heal_other.OnPlayerSpellCast(playerid, spellInstance)
end

function OnPlayerConnect(playerid)
	--directory_scan.OnPlayerConnect(playerid)
	if(IsNPC(playerid) == 0) then
		authentication_module.enterAuthenticationMode(playerid)
	end
	npc_module.OnPlayerConnect(playerid)
end

function OnPlayerMD5File(playerid, pathFile, hash)
	--directory_scan.OnPlayerMD5File(playerid, pathFile, hash)
end

function OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped) 
	npc_module.OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped)
end

function OnPlayerDisconnect(playerid, reason)
	if(IsNPC(playerid) == 0) then
		authentication_module.OnPlayerDisconnect(playerid, reason)
		spells_module.OnPlayerDisconnect(playerid, reason)
		logout_module.OnPlayerDisconnect(playerid, reason)
		player_death_module.OnPlayerDisconnect(playerid, reason)
	end
	npc_module.OnPlayerDisconnect(playerid, reason)
end

function OnPlayerSpawn(playerid, classid)
	authentication_module.OnPlayerSpawn(playerid, classid)
	help_module.OnPlayerSpawn(playerid, classid)
end

function OnPlayerChangeHealth(playerid, currHealth, oldHealth)
	npc_trade_module.OnPlayerChangeHealth(playerid, currHealth, oldHealth)
end

function OnPlayerDeath(playerid, p_classid, killerid, k_classid)
	player_death_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
	spells_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
	npc_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
	npc_fraction_module.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
end

function OnPlayerHit(playerid, killerid)
	npc_module.OnPlayerHit(playerid, killerid)
end

function OnPlayerText(playerid, text)
	chat_module.OnPlayerText(playerid, text)
end

function OnPlayerFocus(playerid, focusid)
	spells_module.OnPlayerFocus(playerid, focusid)
end

function OnPlayerCommandText(playerid, cmdtext)
	authentication_module.OnPlayerCommandText(playerid, cmdtext)
	spells_module.OnPlayerCommandText(playerid, cmdtext)
	anim_module.OnPlayerCommandText(playerid, cmdtext)
	destroy_account_module.OnPlayerCommandText(playerid, cmdtext)
	item_exchange_module.OnPlayerCommandText(playerid, cmdtext)
	chat_module.OnPlayerCommandText(playerid, cmdtext)
	logout_module.OnPlayerCommandText(playerid, cmdtext)
	help_module.OnPlayerCommandText(playerid, cmdtext)
	if cmdtext == "/suicide" then
		SetPlayerHealth(playerid, 0)
	elseif cmdtext == "/suicide help" then
		SendPlayerMessage(playerid, 230,230,230, "Gebe /suicide ein um deinen Charakter umzubringen. Dein Charakter wird dabei seine gesammelten Items verlieren.")
	end

	robbing_module.OnPlayerCommandText(playerid, cmdtext)
	npc_trade_module.OnPlayerCommandText(playerid, cmdtext)
	npc_quest_module.OnPlayerCommandText(playerid, cmdtext)
	debug.OnPlayerCommandText(playerid, cmdtext)
end

function OnPlayerDropItem(playerid, itemid, item_instance, amount, x, y, z)
	if(IsNPC(playerid) == 0) then
		inventory_module.OnPlayerDropItem(playerid, itemid, item_instance, amount, x, y, z)
	end
end

function OnPlayerKey(playerid, keyDown, keyUp)
	authentication_module.OnPlayerKey(playerid, keyDown)
	npc_module.OnPlayerKey(playerid, keyDown, keyUp)
end

function OnPlayerTakeItem(playerid, itemid, item_instance, amount, x, y, z, worldName)
	if(IsNPC(playerid) == 0) then
		inventory_module.OnPlayerTakeItem(playerid, itemid, item_instance, amount, x, y, z, worldName)
	end
end

function OnPlayerUseItem(playerid, item_instance, amount, hand)
	if(IsNPC(playerid) == 0) then
		inventory_module.OnPlayerUseItem(playerid, item_instance, amount, hand)
		mining_module.OnPlayerUseItem(playerid, item_instance, amount, hand)
	end
end

function OnPlayerChangeMeleeWeapon(playerid, currMelee, oldMelee)
	if(IsNPC(playerid) == 0) then
		inventory_module.OnPlayerChangeMeleeWeapon(playerid, currMelee, oldMelee)
	end
end

function OnPlayerChangeRangedWeapon(playerid, currRanged, oldRanged)
	if(IsNPC(playerid) == 0) then
		inventory_module.OnPlayerChangeRangedWeapon(playerid, currRanged, oldRanged)
	end
end

function OnPlayerChangeArmor(playerid, currArmor, oldArmor)
	if(IsNPC(playerid) == 0) then
		inventory_module.OnPlayerChangeArmor(playerid, currArmor, oldArmor)
	end
end

function OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
	if(IsNPC(playerid) == 0) then
		spells_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
		item_exchange_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
		npc_trade_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
		npc_quest_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
	end
	npc_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
end

function OnPlayerWeaponMode(playerid, weaponmode)
	if IsNPC(playerid) then
	--	print("changed to: " .. weaponmode)
	end
end