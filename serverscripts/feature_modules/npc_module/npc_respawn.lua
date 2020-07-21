require "scripts/libs/AIFunctions"
require "scripts/default_scripts/SpawnNewWorld"
local npc_respawn = {}
local time_npc_is_dead = {}
local respawn_time_npc = {}

local function getNpcForName(name)
    if (string.match(name, "^Blattcrawler.*")) then
        return Blattcrawler();
    elseif (string.match(name, "^Bloodfly.*")) then
        return Bloodfly();
    elseif (string.match(name, "^Bloodhound.*")) then
        return Bloodhound();
    elseif (string.match(name, "^Black Goblin.*")) then
        return Gobbo_Black();
    elseif (string.match(name, "^Goblin.*")) then
        return Gobbo_Green();
    elseif (string.match(name, "^Goblin Skeleton.*")) then
        return Gobbo_Skeleton();
    elseif (string.match(name, "^Earth Titan.*")) then
        return EarthTitan();
    elseif (string.match(name, "^Harpy.*")) then
        return Harpie();
    elseif (string.match(name, "^Dragon Snapper.*")) then
        return DragonSnapper();
    elseif (string.match(name, "^Keiler.*")) then
        return Keiler();
    elseif (string.match(name, "^Lurker.*")) then
        return Lurker();
    elseif (string.match(name, "^Meatbug.*")) then
        return Meatbug();
    elseif (string.match(name, "^Minecrawler.*")) then
        return Minecrawler();
    elseif (string.match(name, "^Minecrawler Warrior.*")) then
        return MinecrawlerWarrior();
    elseif (string.match(name, "^Molerat.*")) then
        return Molerat();
    elseif (string.match(name, "^Orc Biter.*")) then
        return OrcBiter();
    elseif (string.match(name, "^Warg.*")) then
        return OrcDog();
    elseif (string.match(name, "^Orc Elite.*")) then
        return OrcElite();
    elseif (string.match(name, "^Orc Scout.*")) then
        return OrcScout();
    elseif (string.match(name, "^Orc Shaman.*")) then
        return OrcShaman();
    elseif (string.match(name, "^Orc Warrior.*")) then
        return OrcWarrior();
    elseif (string.match(name, "^Razor.*")) then
        return Razor();
    elseif (string.match(name, "^Scavenger.*")) then
        return Scavenger();
    elseif (string.match(name, "^Shadowbeast.*")) then
        return Shadowbeast();
    elseif (string.match(name, "^Sheep.*")) then
        return Sheep();
    elseif (string.match(name, "^Skeleton Warrior.*")) then
        return SkeletonWarrior()
    elseif (string.match(name, "^Skeleton Lord.*")) then
        return SkeletonLord()
    elseif (string.match(name, "^Skeleton.*")) then
        return Skeleton();
    elseif (string.match(name, "^Snapper.*")) then
        return Snapper();
    elseif (string.match(name, "^Stoneguardian.*")) then
        return Stoneguardian();
    elseif (string.match(name, "^Swampshark.*")) then
        return Swampshark();
    elseif (string.match(name, "^Black Troll.*")) then
        return Troll_Black();
    elseif (string.match(name, "^Troll.*")) then
        return Troll();
    elseif (string.match(name, "^Waran.*")) then
        return Waran();
    elseif (string.match(name, "^Warg.*")) then
        return Warg();
    elseif (string.match(name, "^Wolf.*")) then
        return Wolf();
    elseif (string.match(name, "^Zombie.*")) then
        return Zombie2();
    elseif (string.match(name, "^Demon Lord.*")) then
        return DemonLord();
    elseif (string.match(name, "^Demon.*")) then
        return XardasDemon();
    elseif (string.match(name, "^Captn Hook.*")) then
        return DeadPirateCaptn();
    elseif (string.match(name, "^Rufus.*")) then
        return Rufus_Dead();
    end
end

local function respawnNpc(playerid)
    local name = GetPlayerName(playerid);
    local world = GetPlayerWorld(playerid);
    local wp = AI_NPCList[playerid].StartWP
    DestroyNPC(playerid);
    SpawnNPC(getNpcForName(name), wp, world);
end

function CheckDeadNpcForRespawn()
    for key, value in pairs(time_npc_is_dead) do
        if (os.clock() - value > respawn_time_npc[key]) then
            time_npc_is_dead[key] = nil
            respawn_time_npc[key] = nil
            respawnNpc(key);
        end
    end
end

function npc_respawn.OnGamemodeInit()
    R1_Respawn_Timer = SetTimer("CheckDeadNpcForRespawn", 5000, 1);
end

function npc_respawn.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    if AI_NPCList[playerid] ~= nil and IsNPC(playerid) == 1 then
        time_npc_is_dead[playerid] = os.clock();
        respawn_time_npc[playerid] = AI_NPCList[playerid].RespawnTime
    end
end

return npc_respawn