local debug = {}


function debug.OnPlayerCommandText(playerid, cmdtext)
    local cmd, params = GetCommand(cmdtext);
    
    if cmdtext == "/allitems" then
        GiveItem(playerid, "ITMI_SILVERRING", 1)
        GiveItem(playerid, "ITMI_AQUAMARINE", 1)
        GiveItem(playerid, "ITMI_SILVERNECKLACE", 1)
        GiveItem(playerid, "ITMI_GOLDRING", 1)
        GiveItem(playerid, "ITAT_TEETH", 1)
        GiveItem(playerid, "ITAT_SKELETONBONE", 1)
        GiveItem(playerid, "ITMI_DARKPEARL", 1)
    end


    if (cmd == "/goto") then
        local spl = params:split(" ");
        spl[1] = trim(spl[1]);
        spl[2] = trim(spl[2]);
        
        if (spl[1] == "wp") then
            local wp = AI_WayNets[GetPlayerOrNPC(playerid).GP_World]:GetWaypoint(spl[2]);
            if (wp ~= nil) then
                SetPlayerPos(playerid, wp.x, wp.y, wp.z);
            end
        end
    
    end

    if cmd == "/op" then
        SetPlayerHealth(playerid, 99999);
        SetPlayerMaxHealth(playerid, 99999);
        SetPlayerMagicLevel(playerid, 3)
    end

    if cmd == "/rosebud" then
        SetPlayerGold(playerid, 100000)
    end

    if cmd == "/furryball" then
        GiveItem(playerid, "ItAt_WargFur",10)
        GiveItem(playerid, "ItAt_WolfFur",10)
        GiveItem(playerid, "ItAt_ShawdowFur",10)
        GiveItem(playerid, "ItAt_TrollFur",10)
        GiveItem(playerid, "ItAt_Addon_Keilerfur",10)
    end
    
    if(cmdtext == "/tomaya") then
        
        SetPlayerPos(playerid,86044,3842,23504);
    end

    if cmdtext == "/tohunter" then
        SetPlayerPos(playerid,52019.8711,7686.00684,32451.3359)
    end

    if cmdtext == "/tohunter2" then
        SetPlayerPos(playerid, 44990.1914,3046.729,3076.68604)
    end

    if cmdtext == "/tomine1" then
        SetPlayerPos(playerid, 36387.3672,5293.35938,29799.7207)
    end

    if cmdtext == "/npc" then
        --38994, 3901, -2235
        SpawnNPC(PaladinKing("FG"), "TAVERNE", "NEWWORLD\\NEWWORLD.ZEN");
        print("paladin king inserted")
    end

    
    if cmdtext == "/npc1" then
        --38994, 3901, -2235
        SpawnNPC(KnightGuard("FG"), "TAVERNE", "NEWWORLD\\NEWWORLD.ZEN");
        print("paladin king inserted")
    end

    
    if cmdtext == "/npc2" then
        --38994, 3901, -2235
        SpawnNPC(OrcElite(), "TAVERNE", "NEWWORLD\\NEWWORLD.ZEN");
        print("paladin king inserted")
    end

    if cmdtext == "/npc3" then
        --38994, 3901, -2235
        SpawnNPC(MilitiaGuard("FG"), "TAVERNE", "NEWWORLD\\NEWWORLD.ZEN");
        print("paladin king inserted")
    end

    if cmdtext == "/mi" then
        print("oehm")
        print(IsNPC(playerid))
    end

    if cmdtext == "/heads" then
        GiveItem(playerid, "ITMI_ADDON_BLOODWYN_KOPF", 5)
    end
    
end



return debug