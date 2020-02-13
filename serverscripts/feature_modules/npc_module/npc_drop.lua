local npc_drop = {}

local DROP_EARTH_TITAN = {"ITMI_AQUAMARINE", "ITMI_SILVERNECKLACE"}
local DROP_DEAD_PIRATE_CAPTN = {"ITAT_TEETH","ITAT_SKELETONBONE"}
local DROP_LIBRARY_DEMON = {"ITMI_DARKPEARL"}
local DROP_XARDAS_DEMON = {"ITMI_SILVERRING", "ITMI_AQUAMARINE"}
local DROP_BLACK_TROLL = {"ITMI_GOLDRING", "ITAT_SKELETONBONE"}

local DROP_ORC_ELITE = {"ItFo_Milk", "ItFo_Wine", "ItFo_Booze","ItFo_Stew", "ItFo_Apple"}
local DROP_ORC_WARRIOR = {"ItFo_Milk", "ItFo_Wine", "ItFo_Booze", "ItFo_Beer", "ItFo_Honey", "ItFo_Sausage", "ItFo_FishSoup", "ItFo_Bread"
, "ItFo_Stew", "ItFo_Apple", "ItFo_Cheese", "ItFo_Bacon"}
local DROP_TROLL = { "ItFo_Wine", "ItFo_Booze", "ItFo_Honey", "ItFo_Bread", "ItMw_2H_Axe_L_01", "ItMi_Rake"}
local DROP_CRAWLER_WARRIOR = {"ItFo_Beer", "ItFo_Bread", "ItFo_Stew", "ItFo_Apple"}
local DROP_SHADOW_BEAST = {"ItAt_ShadowHorn"}

local DROP_GOBBO = {"ItMi_Lute", "ItMi_Brush", "ItMi_Broom", "ItMi_Saw", "ItMi_Scoop", "ItMw_2H_Axe_L_01", "ItMi_Rake"}
local DROP_SKELETON_LORD = {"ItAm_Prot_Fire_01", "ItSc_BreathOfDeath", "ItSc_TrfSheep", "ItSc_TrfScavenger", "ItSc_TrfShadowbeast", "ItSc_TrfDragonSnapper", "ItSc_Whirlwind"}


local function getRandomDrop(drop_collection)
    local number_of_drops = table.getn(drop_collection)
    local index = math.random(number_of_drops)
    return drop_collection[index]
end

local function getDropForInstance(instance)
    if (instance == "MinecrawlerWarrior") then
        return {getRandomDrop(DROP_CRAWLER_WARRIOR)}
    elseif (instance == "Molerat") then
        return {"ItFoMutton", "ItFo_Water"}
    elseif (instance == "DRAGONSNAPPER") then
        return { "ItRw_Arrow"}
    elseif (instance == "Warg") then
        return {"ItFoMutton", "ItRw_Arrow", "ItAt_WargFur"}
    elseif (instance == "OrcElite_Roam") then
        return {"ItFo_Booze", "ItFo_Stew", getRandomDrop(DROP_ORC_ELITE)}
    elseif (instance == "OrcScout_Roam") then
        return {"ItFoMutton", "ItFo_Water"}
    elseif (instance == "OrcShaman_Sit") then
        return {getRandomDrop(DROP_ORC_WARRIOR)}
    elseif (instance == "OrcWarrior_Roam") then
        return {"ItFo_Beer", "ItFo_Bacon", getRandomDrop(DROP_ORC_WARRIOR)}
    elseif (instance == "Razor") then
        return {"ItRw_Arrow"}
    elseif (instance == "Scavenger") then
        return {"ItFoMutton", "ItFo_Water"}
    elseif (instance == "Shadowbeast") then
        return {"ItAt_ShadowFur", "ItRw_Arrow"}
    elseif (instance == "Sheep") then
        return {"ItFoMutton", "ItFo_Water"}
    elseif (instance == "Skeleton") then
        return {"ItFo_Milk"}
    elseif (instance == "Snapper") then
        return {"ItRw_Arrow", "ItFo_Booze", "ItRw_Arrow"}
    elseif (instance == "Swamprat") then
        return {"ItFoMutton", "ItFo_Water"}
    elseif (instance == "Swampshark") then
        return {"ItFo_Fish"}
    elseif (instance == "Troll") then
        return {"ItFo_Stew", "ItAt_TrollFur", "ItRw_Arrow", getRandomDrop(DROP_TROLL)}
    elseif (instance == "Waran") then
        return {"ItFo_Fish"}
    elseif (instance == "Wolf") then
        return {"ItFoMutton", "ItFo_Water", "ItAt_WolfFur"}
    elseif (instance == "Keiler") then
        return {"ItFo_Sausage", "ItRw_Arrow", "ItAt_Addon_KeilerFur"}
    elseif (instance == "Lurker") then
        return {"ItFo_Fish", "ItFo_FishSoup"}
    elseif (instance == "Gobbo_Black") then
        return {"ItFo_Beer","ItFo_Cheese", getRandomDrop(DROP_GOBBO)}
    elseif (instance == "Skeleton_Lord") then
        return {getRandomDrop(DROP_SKELETON_LORD)}
    elseif (instance == "DEMONLORD") then
        return {getRandomDrop(DROP_LIBRARY_DEMON)}
    elseif (instance == "Troll_Black") then
        return {getRandomDrop(DROP_BLACK_TROLL)}
    elseif (instance == "DRAGONISLE_KEYMASTER") then
        return {getRandomDrop(DROP_DEAD_PIRATE_CAPTN)}
    elseif (instance == "SwampGolem") then
        return {getRandomDrop(DROP_EARTH_TITAN)}
    elseif (instance == "DEMON") then
        return {getRandomDrop(DROP_XARDAS_DEMON)}
    elseif (instance == "CRYPT_SKELETON_LORD") then
        return {"ItKe_MonastarySecretLibrary_Mis"}
    else
        return {"ItFoMutton", "ItFo_Water"}
    end
end

local function giveItemForInstance(playerid, instance)
    if instance == "ItRw_Arrow" then
        GiveItem(playerid, instance, 10)
    else
        GiveItem(playerid, instance, 1)
    end
end

local function sendMessageOnSpecialItem(playerid, item_instance)
    if item_instance == "ITMI_GOLDRING" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/goldring help' ein fuer naehere Informationen.")
    elseif item_instance == "ITMI_SILVERNECKLACE" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/silvernecklace help' ein fuer naehere Informationen.")
    elseif item_instance == "ITMI_AQUAMARINE" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/aquamarine help' ein fuer naehere Informationen.")
    elseif item_instance == "ITMI_SILVERRING" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/silverring help' ein fuer naehere Informationen.")
    elseif item_instance == "ITAT_TEETH" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/teeth help' ein fuer naehere Informationen.")
    elseif item_instance == "ITAT_SKELETONBONE" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/bone help' ein fuer naehere Informationen.")
    elseif item_instance == "ITMI_DARKPEARL" then
        SendPlayerMessage(playerid, 0, 0, 255, "Du hast ein legendaeres Artefakt gefunden!")
        SendPlayerMessage(playerid, 0, 0, 255, "Tippe '/darkperl help' ein fuer naehere Informationen.")
    end
end

function npc_drop.OnPlayerDeath(playerid, p_classid, killerid, k_classid)
    if IsNPC(playerid) == 1 and IsNPC(killerid) == 0 then
        local items = getDropForInstance(GetPlayerInstance(playerid))
        for _, value in pairs(items) do
            giveItemForInstance(killerid, value)
            SendPlayerMessage(killerid, 255,228,181, value.." gefunden.")
            sendMessageOnSpecialItem(killerid, value)
        end
    end
end


return npc_drop;