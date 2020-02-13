--Waypoint Classes
--Waypoint, WayNet

print("Loaded Lib: WayPoints.lua");




FreePoint = {}
FreePoint.__index = FreePoint

function FreePoint.create()
    local wpnt = {}
    setmetatable(wpnt, FreePoint)
    
    wpnt.name = "";
    wpnt.x = 0.0;
    wpnt.y = 0.0;
    wpnt.z = 0.0;
    wpnt.dirx = 0.0;
    wpnt.dirz = 0.0;
    
    wpnt.type = 2;
    return wpnt
end

function FreePoint:CompareNames(name)
    if(string.upper(trim(self.name)) == string.upper(trim(name))) then
        return true;
    end
    return false;
end


FreePointList = {}
FreePointList.__index = FreePointList

function FreePointList.create( )
    local wpnt = {}
    setmetatable(wpnt, FreePointList)
    wpnt.freepoints = {};
    return wpnt
end

function FreePointList:load(file)
    fh = io.open(file,"r");
    for line in fh:lines() do --reading all lines. Each Line = 1 WP
        local values = string.split(line,";");
        local wp = FreePoint.create();
        wp.name = string.upper(trim(values[1]));
        wp.x =  tonumber(values[2]);
        wp.y = tonumber(values[3]);
        wp.z = tonumber(values[4]);
        wp.dirx = tonumber(values[5]);
        wp.dirz = tonumber(values[6]);
        
        --Remove the first 4 values from 4 to 1. After that the table includes only the next waypoints
        table.remove(values,6);
        table.remove(values,5);
        table.remove(values,4);
        table.remove(values,3);
        table.remove(values,2);
        table.remove(values,1);
        
        self.freepoints[wp.name] = wp; -- All WP's needs a unique name!
        --table.insert(self.waypoints, wp);
        
    end
    fh:close();
end

function FreePointList:GetFreePoint(name)
    return self.freepoints[string.upper(trim(name))];
end

function FreePointList:GetNearestFreePoint(x, y, z)
    local FoundedWP;
    local lastDistance = 99999999999;
    for key,wp in pairs(self.freepoints) do
        local px,py,pz = x, y, z;
        local dis = getDistance( wp.x, wp.y, wp.z, px, py, pz);
        if(dis < lastDistance) then
            FoundedWP = wp;
            lastDistance = dis;
        end
    end
    
    return FoundedWP;
end

function FreePointList:GetNearFreePoints(x, y, z, _name, _maxdistance)
    local FPList = {};
    for key,fp in pairs(self.freepoints) do
        if(string.contains(fp.name, _name))then
            local px,py,pz = x, y, z;
            local dis = getDistance( fp.x, fp.y, fp.z, x, y, z);
            if(dis < _maxdistance) then
                table.insert(FPList, fp);
            end
        end
    end
    
    return FPList;
end



Waypoint = {}
Waypoint.__index = Waypoint

function Waypoint.create()
    local wpnt = {}
    setmetatable(wpnt, Waypoint)
    
    wpnt.name = "";
    wpnt.x = 0.0;
    wpnt.y = 0.0;
    wpnt.z = 0.0;
    wpnt.dirx = 0.0;
    wpnt.dirz = 0.0;
    wpnt.otherWPS = {};
    
    
    wpnt.type = 1;
    return wpnt
end

function Waypoint:CompareNames(name)
    if(string.upper(trim(self.name)) == string.upper(trim(name))) then
        return true;
    end
    return false;
end


WayRoute = {}
WayRoute.__index = WayRoute

function WayRoute.create( )
    local wpnt = {}
    setmetatable(wpnt, WayRoute)
    
    wpnt.waypoints = {};
    return wpnt
end


WayNet = {}
WayNet.__index = WayNet

function WayNet.create( )
    local wpnt = {}
    setmetatable(wpnt, WayNet)
    
    wpnt.waypoints = {};
    wpnt.waypointsSort = {};
    return wpnt
end

function WayNet:load(file)
    fh = io.open(file,"r");
    for line in fh:lines() do --reading all lines. Each Line = 1 WP
        local values = string.split(line,";");
        local wp = Waypoint.create();
        wp.name = string.upper(trim(values[1]));
        wp.x =  tonumber(values[2]);
        wp.y = tonumber(values[3]);
        wp.z = tonumber(values[4]);
        wp.dirx = tonumber(values[5]);
        wp.dirz = tonumber(values[6]);
        
        --Remove the first 4 values from 4 to 1. After that the table includes only the next waypoints
        table.remove(values,6);
        table.remove(values,5);
        table.remove(values,4);
        table.remove(values,3);
        table.remove(values,2);
        table.remove(values,1);
        
        wp.nextWPS = values;
        
        self.waypoints[wp.name] = wp; -- All WP's needs a unique name!
        table.insert(self.waypointsSort, wp);
        --table.insert(self.waypoints, wp);
        
    end
    fh:close();
end

function WayNet:GetWaypoint(name)
    return self.waypoints[string.upper(trim(name))];
    --for key,wp in ipairs(self.waypoints) do
    --  if(string.upper(trim(wp.name)) == string.upper(trim(name))) then
    --      return wp;
    --  end
    --end

end

function WayNet:GetRandomWaypoint()
    return self.waypointsSort[math.random(1, #self.waypointsSort)];
end



function WayNet:GetNearestWP(_playerid)
    local FoundedWP;
    local lastDistance = 99999999999;
    for key,wp in pairs(self.waypoints) do
        if(wp == nil)then
            print("WP is null");
        end
        local px,py,pz = GetPlayerPos(_playerid);
        local dis = getDistance( wp.x, wp.y, wp.z, px, py, pz);
        if(dis < lastDistance) then
            FoundedWP = wp;
            lastDistance = dis;
        end
    end
    
    return FoundedWP;
end

function WayNet:GetNearestWPPos(px, py, pz)
    local FoundedWP;
    local lastDistance = 99999999999;
    for key,wp in pairs(self.waypoints) do
        local dis = getDistance( wp.x, wp.y, wp.z, px, py, pz);
        if(dis < lastDistance) then
            FoundedWP = wp;
            lastDistance = dis;
        end
    end
    
    return FoundedWP;
end

--Only for internal use
function WayNet:GetWayRouteIntern(_startWP, _endWP)
    local openList = {};
    local closedList = {};

    openList[_startWP.name] =  {_startWP, 0, 0,0};
    repeat
        local currentNode = self:OLRemoveMin(openList);
        if(currentNode == nil) then
            return nil;
        end
        if currentNode[1] == _endWP then
            
            return closedList;--Path Found!
        end
        self:ExpandNode(openList, closedList, currentNode, _endWP);
        closedList[currentNode[1].name] = currentNode;
    until(next(openList) == nil)
    
    return nil;--Es wurde kein Pfad gefunden!
end


--Returns a WayRoute with all Waypoints. If no Waypoint was found returns nil!
function WayNet:GetWayRoute(_startWP, _endWP)
    if(_startWP == nil or _endWP == nil)then
        return nil;
    end
    
    local route = self:GetWayRouteIntern(_startWP, _endWP);
    if(route == nil)then
        return nil;
    end
    route[_endWP.name] = {_endWP, 0, 0,0};
    local realRoute = {};
    table.insert(realRoute, _endWP);
    
    --von hinten durchiterieren und auf die tats�chliche Strecke pr�fen!
    local actualWP = _endWP;
    local actualDistance = 0;
    while(true) do
        local lastActualWP = actualWP;
        actualWP = self:NextMinWP(actualWP, route);
        table.insert(realRoute, actualWP);
        if(actualWP == _startWP)then
            break;
        end
        route[lastActualWP.name] = nil;
    end
    
    return table.reverse ( realRoute );
    
end

--Only for internal use
function WayNet:NextMinWP(_actualWP, _route)
    local mDistance = 99999999999999999;
    local mObj;
    for key,val in ipairs(_actualWP.nextWPS) do
        if(_route[val] ~= nil)then--Nur wenn der WP in der Route-List vorhanden ist!
            --Distance berechnen
            local distance = getDistance(_actualWP.x, _actualWP.y, _actualWP.z, _route[val][1].x, _route[val][1].y, _route[val][1].z);
            local insDistance = _route[_actualWP.name][4] + distance + _route[val][2];--Die tats�chliche Instanz!
            if(mDistance > insDistance) then
                mDistance = insDistance;
                mObj = _route[val][1];
                _route[val][4] = _route[_actualWP.name][4] + distance;
            end
        end
    end
    return mObj;
end

--Nur f�r Interne Nutzung, siehe GetWayRoute
function WayNet:OLRemoveMin(_list)
    local lowestPriority = 99999999;
    local k;
    local v;
    for key,val in pairs(_list) do
        if(val[3] < lowestPriority) then
            lowestPriority = val[3];
            k = key;
            v = val;
        end
    end
    --table.remove(_list, k);
    _list[k] = nil;
    return v;
end

function WayNet:ExpandNode(list, clist, node, _endWP)
    if(node[1].nextWPS == nil) then
        return;
    end
    for key,val in ipairs(node[1].nextWPS) do
        if(val ~= "") then
            local valueNode = self:GetWaypoint(val);
            
            if(clist[valueNode.name] == nil) then
                local distance = getDistance(node[1].x, node[1].y, node[1].z, valueNode.x, valueNode.y, valueNode.z);
                local gnew = node[2] + distance; --prio des 1. + neue des 2.
                
                if(list[valueNode.name] ~= nil and gnew >= list[valueNode.name][2]) then
                    --Mache gar nichts mehr! Continue
                else
                    local distance2 = getDistance(_endWP.x, _endWP.y, _endWP.z, valueNode.x, valueNode.y, valueNode.z);
                    local f = gnew + distance2;
                    if(list[valueNode.name] == nil) then
                        list[valueNode.name] = {valueNode, gnew, f};
                    else
                        list[valueNode.name][2] = gnew;
                        list[valueNode.name][3] = f;
                    end
                    
                end
            end
        end
    end
end


--Goto-Functions
local PlayerWalkType = {};
local WALKTYPE_WALK = 0;
local WALKTYPE_RUN = 1;

function setPlayerWalkType(_player, _walktype)
     PlayerWalkType[_player] = _walktype;
end
function run(_player, x, y, z, fight)
    if(PlayerWalkType[_player] == nil)then
        PlayerWalkType[_player] = WALKTYPE_RUN;
    end

    local animname = "S_WALKL";
    if(AI_NPCList[_player].Guild < AI_GUILD_HUMANS)then
        animname = "S_FISTWALKL";
    end
    if(PlayerWalkType[_player] == 1)then
        animname = "S_RUNL";
    end
    if(AI_NPCList[_player].Guild < AI_GUILD_HUMANS and PlayerWalkType[_player] == 1)then
        animname = "S_FISTRUNL";
    end
    PlayAnimation(_player,animname);
end

local sqrt = math.sqrt

function GetDistanceP(val, ainpc)
    return getDistance(val.GP_PosX, val.GP_PosY, val.GP_PosZ, ainpc.GP_PosX,ainpc.GP_PosY,ainpc.GP_PosZ);
end
function getDistance(x1, y1, z1, x2, y2, z2)
    --if(x1 == nil or x2 == nil or y1 == nil or y2 == nil or z1 == nil or z2 == nil)then
    --  print("getDistance Failed! Nil Value found!");
    --  return 99999;--Max Distance...
    --end
    --x1 = tonumber(x1);
    --y1 = tonumber(y1);
    --z1 = tonumber(z1);
    --x2 = tonumber(x2);
    --y2 = tonumber(y2);
    --z2 = tonumber(z2);
    
    local x, y, z = x1-x2, y1-y2, z1-z2;
    return sqrt(x*x+y*y+z*z);
end

function getAngle(x1, y1, x2, y2)
    if(x1 == x2 and y1 == y2) then
        return 0;
    end
    local x, y = x2-x1, y2- y1;
    local angle =  math.atan(x / y) * 180.0 / 3.14;
    if(y < 0) then
        if(angle >= 180.0) then
            angle = angle- 180.0;
        else
            angle = angle + 180.0;
        end
        
    end
    return tonumber(angle);
end

function turnPlayer(_player, _angle)
    SetPlayerAngle(_player, tonumber(_angle));
    return true;
end
function turnPlayer_Slow(_player, _angle)
    if(GetPlayerAngle(_player) == _angle)then
        print("Angle...1");
        return true;
    end


    local a1 = 360 + _angle;
    local a2 = 360 - _angle;
    local a3 = 360 + 360 + _angle;
    
    local player_angle = GetPlayerAngle(_player);
    local pa = 360 + player_angle;
    
    local d1 = 0;
    local d11 = a1-pa;
    if(a1 > pa)then
        d1 = a1 - pa;
    else
        d1 = pa - a1;
    end
    local d2 = pa - a2;
    local d3 = a3 - pa;
    
    
    local distance = 0;
    local turndir = false;--false = - true = +
    
    if(d1 < d2 and d1 < d3)then
        distance = d1;
        if(d11 < 0)then
            turndir = false;
        else
            turndir = true;
        end
    elseif(d2 < d1 and d2 < d3)then
        distance = d2;
        turndir = false;
    elseif(d3 < d2 and d3 < d1)then
        distance = d3;
        turndir = true;
    end
    
    local turnspeed = 20;
    local angle = nil;
    if(distance-5 <= turnspeed)then
        angle = _angle;
    end
    
    if(angle == nil)then
        if(turndir)then
            SetPlayerAngle(_player, player_angle + turnspeed);
        else
            SetPlayerAngle(_player, player_angle - turnspeed);
        end
    else
        SetPlayerAngle(_player, tonumber(angle));
        return true;
    end
    
    if(distance < 20 or GetPlayerAngle(_player) == _angle)then
        return true;
    else
        return false;
    end
    
    return true;
end

function gotoPosition(_player, _x, _y, _z, fight)
    if(_player == nil) then
        return true;
    end
    
    local ainpc = AI_NPCList[_player];
    if(ainpc.LastPosUpdate == 0)then
        ainpc.LastPosUpdate = GetTickCount();
        ainpc.LastPosX = ainpc.GP_PosX;
        ainpc.LastPosY = ainpc.GP_PosY;
        ainpc.LastPosZ = ainpc.GP_PosZ;
    elseif(ainpc.LastPosUpdate + 500 < GetTickCount())then
        if(getDistance(ainpc.LastPosX,ainpc.LastPosY,ainpc.LastPosZ,  ainpc.GP_PosX,  ainpc.GP_PosY,  ainpc.GP_PosZ) < 2)then
            --SetPosition
            local timeDiff = GetTickCount()-ainpc.LastPosUpdate;
            local speed = (5*100)*(timeDiff/1000.0);-- meter per seconds!
            
            local dirX = _x-ainpc.GP_PosX;
            local dirY = _y-ainpc.GP_PosY;
            local dirZ = _z-ainpc.GP_PosZ;
            
            local dirNorm = sqrt(dirX*dirX+dirY*dirY+dirZ*dirZ);
            dirX = dirX / dirNorm;
            dirY = dirY / dirNorm;
            dirZ = dirZ / dirNorm;
            
            local distance = getDistance(ainpc.GP_PosX,ainpc.GP_PosY,ainpc.GP_PosZ, _x, _y, _z);
            if(speed > distance)then
                SetPlayerPos(_player, _x, _y, _z);
                ainpc.GP_PosX = _x;
                ainpc.GP_PosY = _y;
                ainpc.GP_PosZ = _z;
            else
                ainpc.GP_PosX = ainpc.GP_PosX + (dirX*speed);
                ainpc.GP_PosY = ainpc.GP_PosY + (dirY*speed);
                ainpc.GP_PosZ = ainpc.GP_PosZ + (dirZ*speed);
                SetPlayerPos(_player, ainpc.GP_PosX, ainpc.GP_PosY, ainpc.GP_PosZ);
            end
            
            
        end
        
        ainpc.LastPosUpdate = GetTickCount();
        ainpc.LastPosX = ainpc.GP_PosX;
        ainpc.LastPosY = ainpc.GP_PosY;
        ainpc.LastPosZ = ainpc.GP_PosZ;
    end
    
    
    
    
    local px,py,pz = GetPlayerPos(_player);
    
    if(getDistance(px,py,pz, _x, _y, _z) < 100) then
        -- he is there!
        PlayAnimation(_player, "S_RUN");
        return true;
    else
        -- run to the direction
        SetPlayerAngle(_player, getAngle(px, pz, _x, _z));
        run(_player, _x, _y, _z, fight);
        return false;
    end
    
end


