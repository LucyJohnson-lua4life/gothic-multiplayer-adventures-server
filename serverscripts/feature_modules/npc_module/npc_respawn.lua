require "scripts/libs/AIFunctions"
require "scripts/default_scripts/SpawnNewWorld"
local npc_respawn = {}
local time_npc_is_dead = {}
local respawn_time_npc = {}

local function getNpcForInstance(instance)
    if (instance == "Blattcrawler") then
        return Blattcrawler();
    elseif (instance == "Bloodfly") then
        return Bloodfly();
    elseif (instance == "Bloodhound") then
        return Bloodhound();
    elseif (instance == "Giant_Bug") then
        return Giant_Bug();
    elseif (instance == "Giant_DesertRat") then
        return Giant_DesertRat();
    elseif (instance == "Gobbo_Black") then
        return Gobbo_Black();
    elseif (instance == "Gobbo_Green") then
        return Gobbo_Green();
    elseif (instance == "Gobbo_Skeleton") then
        return Gobbo_Skeleton();
    elseif (instance == "BridgeGolem") then
        return BridgeGolem();
    elseif (instance == "FireGolem") then
        return FireGolem();
    elseif (instance == "IceGolem") then
        return IceGolem();
    elseif (instance == "Shattered_Golem") then
        return Shattered_Golem();
    elseif (instance == "StoneGolem") then
        return StoneGolem();
    elseif (instance == "SwampGolem") then
        return EarthTitan();
    elseif (instance == "Harpie") then
        return Harpie();
    elseif (instance == "Keiler") then
        return Keiler();
    elseif (instance == "Lurker") then
        return Lurker();
    elseif (instance == "Meatbug") then
        return Meatbug();
    elseif (instance == "Minecrawler") then
        return Minecrawler();
    elseif (instance == "MinecrawlerWarrior") then
        return MinecrawlerWarrior();
    elseif (instance == "Molerat") then
        return Molerat();
    elseif (instance == "OrcBiter") then
        return OrcBiter();
    elseif (instance == "Warg") then
        return OrcDog();
    elseif (instance == "OrcElite_Roam") then
        return OrcElite();
    elseif (instance == "OrcScout_Roam") then
        return OrcScout();
    elseif (instance == "OrcShaman_Sit") then
        return OrcShaman();
    elseif (instance == "OrcWarrior_Roam") then
        return OrcWarrior();
    elseif (instance == "Razor") then
        return Razor();
    elseif (instance == "Scavenger") then
        return Scavenger();
    elseif (instance == "Shadowbeast") then
        return Shadowbeast();
    elseif (instance == "Sheep") then
        return Sheep();
    elseif (instance == "Skeleton") then
        return Skeleton();
    elseif (instance == "Snapper") then
        return Snapper();
    elseif (instance == "Stoneguardian") then
        return Stoneguardian();
    elseif (instance == "SwampDrone") then
        return SwampDrone();
    elseif (instance == "Swamprat") then
        return Swamprat();
    elseif (instance == "Swampshark") then
        return Swampshark();
    elseif (instance == "Troll") then
        return Troll();
    elseif (instance == "Waran") then
        return Waran();
    elseif (instance == "Warg") then
        return Warg();
    elseif (instance == "Wolf") then
        return Wolf();
    elseif (instance == "Zombie01") then
        return Kadaver();
    elseif (instance == "Zombie02") then
        return Zombie2();
    elseif (instance == "Zombie03") then
        return Zombie3();
    elseif (instance == "Zombie04") then
        return Zombie4();
    elseif (instance == "Skeleton_Lord") then
        return SkeletonLord()
    elseif (instance == "Demon") then
        return XardasDemon();
    elseif (instance == "DemonLord") then
        return DemonLord();
    elseif (instance == "DRAGONISLE_KEYMASTER") then
        return DeadPirateCaptn();
    elseif (instance == "Troll_Black") then
        return Troll_Black()
    end
end

local function respawnNpc(playerid)
    local instance = GetPlayerInstance(playerid);
    local world = GetPlayerWorld(playerid);
    local wp = AI_NPCList[playerid].StartWP;
    
    DestroyNPC(playerid);
    
    SpawnNPC(getNpcForInstance(instance), wp, world);
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
    if AI_NPCList[playerid] ~= nil then
        time_npc_is_dead[playerid] = os.clock();
        respawn_time_npc[playerid] = AI_NPCList[playerid].RespawnTime
    end
end

return npc_respawn