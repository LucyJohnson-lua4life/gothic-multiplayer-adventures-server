AIState = {}
AIState.__index = AIState

function AIState.create( _playerid, _aifunction)
    local wpnt = {}
    setmetatable(wpnt, AIState)
    
    wpnt.aiFunction = _aifunction;
    wpnt.player = _playerid;
    wpnt.start = true;
    wpnt.Continue = false;
    return wpnt
end

function AIState:update()
    self.aiFunction(self, false);
    AI_NPCList[self.player].LastState = self;
end



--Only for internal use!
function ai_reset_dr_func(_aistate)
    Reset_TA(_aistate.player);
    table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
end

--Reset the Daily-Routine. (It is a State variable so it will Reset the DR when the others are finished)
function AI_RESET_DR(_playerid)
    AI_Set(_playerid);
    
    local lAiState = AIState.create(_playerid, ai_reset_dr_func);
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Goto-Function!
--Only for internal use!
function ai_goto_func(_aistate)
    if(_aistate.start) then
        
        _aistate.startWP = AI_WayNets[AI_NPCList[_aistate.player].GP_World]:GetNearestWP(_aistate.player);
        if(_aistate.startWP == _aistate.endWP)then
            PlayAnimation(_aistate.player,"S_LGUARD");
            table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
            return;
        end
        
        _aistate.wpRoute = AI_WayNets[AI_NPCList[_aistate.player].GP_World]:GetWayRoute(_aistate.startWP, _aistate.endWP);
        
        if(_aistate.wpRoute == nil)then
            PlayAnimation(_aistate.player,"S_LGUARD");
            table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
            return;
        end
        
        AI_NPCList[_aistate.player].LASTWP = _aistate.endWP.name;
        AI_NPCList[_aistate.player].LastPosUpdate = 0;
    end
        
    
    if(gotoPosition(_aistate.player, _aistate.wpRoute[_aistate.wpIndex].x,_aistate.wpRoute[_aistate.wpIndex].y,_aistate.wpRoute[_aistate.wpIndex].z)) then
        _aistate.wpIndex = _aistate.wpIndex+1;
        if(_aistate.wpRoute[_aistate.wpIndex] == nil) then
            PlayAnimation(_aistate.player, "S_RUN");--stop animation by overwriting it 
            table.remove(AI_NPCList[_aistate.player]["STATES"], 1);--the actual State is always 1
            return;
        end
    end
    _aistate.start = false;
end

--The NPC goes to the waypoint. It can be a FP too.
function AI_GOTO(_playerid, waypoint)
    AI_Set(_playerid);
    
    if(AI_WayNets[AI_NPCList[_playerid].GP_World] == nil)then
        return;
    end
    
    --Redirect to GotoFP!
    local endWP = AI_WayNets[AI_NPCList[_playerid].GP_World]:GetWaypoint(waypoint);
    if(endWP == nil)then
        endFP = AI_FreePoints[AI_NPCList[_playerid].GP_World]:GetFreePoint(waypoint);
        if(endFP == nil)then
            print("AI_GOTO: Couldn't find the Waypoint "..waypoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
            return;
        end
        
        AI_GOTOFP(_playerid, waypoint);
        
        return;
    end
    
    local lAiState = AIState.create(_playerid, ai_goto_func);
    lAiState.endWP = endWP;
    lAiState.wpIndex= 1;
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

function AI_GOTO_NOW(_playerid, waypoint)
    AI_Set(_playerid);
    
    if(AI_WayNets[AI_NPCList[_playerid].GP_World] == nil)then
        return;
    end
    
    
    --Redirect to GotoFP!
    local endWP = AI_WayNets[AI_NPCList[_playerid].GP_World]:GetWaypoint(waypoint);
    if(endWP == nil)then
        endFP = AI_FreePoints[AI_NPCList[_playerid].GP_World]:GetFreePoint(waypoint);
        if(endFP == nil)then
            print("AI_GOTO: Couldn't find the Waypoint "..waypoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
            return;
        end
        
        AI_GOTOFP_NOW(_playerid, waypoint);
        
        return;
    end
    
    
    
    local lAiState = AIState.create(_playerid, ai_goto_func);
    lAiState.endWP = endWP;
    lAiState.wpIndex= 1;
    
    
    table.insert(AI_NPCList[_playerid]["STATES"], 1, lAiState);
end

--End Goto-Function



--AI-AlignToWP

function ai_aligntowp_func(_aistate)
    local px, py, pz = GetPlayerPos(_aistate.player);
    
    local angle = getAngle(px, pz, px+_aistate.waypoint.dirx, pz+_aistate.waypoint.dirz);
    if(turnPlayer(_aistate.player, angle))then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    end
end

function AI_ALIGNTOWP(_playerid, _waypoint)
    AI_Set(_playerid);
    
    if(AI_WayNets[AI_NPCList[_playerid].GP_World] == nil)then
        return;
    end
    local lAiState = AIState.create(_playerid, ai_aligntowp_func);
    lAiState.waypoint = AI_WayNets[AI_NPCList[_playerid].GP_World]:GetWaypoint(_waypoint);
    
    if(lAiState.waypoint == nil)then
        endFP = AI_FreePoints[AI_NPCList[_playerid].GP_World]:GetFreePoint(_waypoint);
        if(endFP == nil)then
            print("AI_GOTO: Couldn't find the Waypoint ".._waypoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
            return;
        end
        
        AI_ALIGNTOFP(_playerid, _waypoint);
        
        return;
    end
    
    
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end



--Ai-AlignToWP-END


--GotoFP-Function!

function ai_gotofp_func(_aistate)
    if(_aistate.start) then
        
        _aistate.startWP = AI_WayNets[AI_NPCList[_aistate.player].GP_World]:GetNearestWP(_aistate.player);
        if(_aistate.startWP == _aistate.endWP)then
            _aistate.gotoFP = true;
        else
            _aistate.wpRoute = AI_WayNets[AI_NPCList[_aistate.player].GP_World]:GetWayRoute(_aistate.startWP, _aistate.endWP);
            
            if(_aistate.wpRoute == nil)then
                PlayAnimation(_aistate.player,"S_LGUARD");--stop animation by overwriting it 
                table.remove(AI_NPCList[_aistate.player]["STATES"], 1);--the actual State is always 1
                return;
            end
            
            AI_NPCList[_aistate.player].LASTWP = _aistate.endWP.name;
            AI_NPCList[_aistate.player].LastPosUpdate = 0;
        end
        
        
    end
        
    if(_aistate.gotoFP==false)then
        if(gotoPosition(_aistate.player, _aistate.wpRoute[_aistate.wpIndex].x,_aistate.wpRoute[_aistate.wpIndex].y,_aistate.wpRoute[_aistate.wpIndex].z)) then
            _aistate.wpIndex = _aistate.wpIndex+1;
            if(_aistate.wpRoute[_aistate.wpIndex] == nil) then
                _aistate.gotoFP = true;
                AI_NPCList[_aistate.player].LastPosUpdate = 0;
            end
        end
    end
    if(_aistate.gotoFP==true)then
        if(gotoPosition(_aistate.player, _aistate.freepoint.x,_aistate.freepoint.y,_aistate.freepoint.z))then
            _aistate.gotoFP = true;
            AI_NPCList[_aistate.player].LASTFP = _aistate.freepoint.name;
            PlayAnimation(_aistate.player, "S_RUN");--stop animation by overwriting it 
            table.remove(AI_NPCList[_aistate.player]["STATES"], 1);--the actual State is always 1
            return;
        end
    end
    
    _aistate.start = false;
end
function AI_GOTOFP(_playerid, freepoint)
    AI_Set(_playerid);
    
    if(AI_FreePoints[AI_NPCList[_playerid].GP_World] == nil)then
        return;
    end
    
    local fp = AI_FreePoints[AI_NPCList[_playerid].GP_World].freepoints[freepoint];
    if(fp == nil)then
        print("AI-GOTOFP: Couldn't find the Freepoint "..freepoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
        return;
    end
    
    local lAiState = AIState.create(_playerid, ai_gotofp_func);
    lAiState.endWP = AI_WayNets[AI_NPCList[_playerid].GP_World]:GetNearestWPPos(fp.x, fp.y, fp.z);
    lAiState.freepoint = fp;
    lAiState.gotoFP = false;
    lAiState.wpIndex= 1;
    
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

function AI_GOTOFP_NOW(_playerid, freepoint)
    AI_Set(_playerid);
    
    if(AI_FreePoints[AI_NPCList[_playerid].GP_World] == nil)then
        return;
    end
    
    local fp = AI_FreePoints[AI_NPCList[_playerid].GP_World].freepoints[freepoint];
    local lAiState = AIState.create(_playerid, ai_gotofp_func);
    lAiState.endWP = AI_WayNets[AI_NPCList[_playerid].GP_World]:GetNearestWPPos(fp.x, fp.y, fp.z);
    lAiState.freepoint = fp;
    lAiState.gotoFP = false;
    lAiState.wpIndex= 1;
    
    if(fp == nil)then
        print("AI-GOTOFP: Couldn't find the Freepoint "..freepoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
        return;
    end
    table.insert(AI_NPCList[_playerid]["STATES"],1,lAiState);
end


--End GotoFP-Function

--AI-AlignToFP

function ai_aligntofp_func(_aistate)
    local px, py, pz = GetPlayerPos(_aistate.player);
    
    local angle = getAngle(px, pz, px-_aistate.waypoint.dirx, pz-_aistate.waypoint.dirz);
    if(turnPlayer(_aistate.player, angle))then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    end
end

function AI_ALIGNTOFP(_playerid, _waypoint)
    AI_Set(_playerid);
    
    if(AI_FreePoints[AI_NPCList[_playerid].GP_World] == nil)then
        return;
    end
    
    local lAiState = AIState.create(_playerid, ai_aligntofp_func);
    lAiState.waypoint = AI_FreePoints[AI_NPCList[_playerid].GP_World].freepoints[_waypoint];
    if(lAiState.waypoint == nil)then
        print("AI_ALIGNTOFP: Couldn't find the Freepoint ".._waypoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
        return;
    end
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-AlignToFP-END

--Stop-Function
function ai_stop_func(_aistate)
    if(_aistate.start) then
        _aistate.stopTime = os.time()+_aistate.stopTime;
    end
    if(os.time() > _aistate.stopTime) then
        for k in pairs(AI_NPCList[_aistate.player]["STATES"]) do
            AI_NPCList[_aistate.player]["STATES"][k] = nil
        end
        return;
    end
    
    _aistate.start = false;
end

function AI_STOP(_playerid, _stoptime)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_stop_func);
    lAiState.stopTime = _stoptime;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
    --table.insert(AI_NPCList[_playerid]["STATES"], 1, lAiState);
end

function AI_STOP_NOW(_playerid, _stoptime)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_stop_func);
    lAiState.stopTime = _stoptime;
    table.insert(AI_NPCList[_playerid]["STATES"], 1, lAiState);
end

--endStopFunction

--Stop-Function
function ai_stopms_func(_aistate)
    if(_aistate.start) then
        _aistate.stopTime = GetTickCount()+_aistate.stopTime;
    end
    if(GetTickCount() > _aistate.stopTime) then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);--the actual State is always 1
        return;
    end
    
    _aistate.start = false;
end

function AI_STOPMS(_playerid, _stoptime)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_stopms_func);
    lAiState.stopTime = _stoptime;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--endStopFunction

function aniHelper(first, mode, ani)
    local animation = first.."_WALK"..ani
    if mode == WEAPON_NONE or mode == WEAPON_FIST then
        animation = first.."_FIST"..ani
    elseif mode == WEAPON_1H then
        animation = first.."_1H"..ani
    elseif mode == WEAPON_2H then
        animation = first.."_2H"..ani
    elseif mode == WEAPON_BOW then
        animation = first.."_BOW"..ani
    elseif mode == WEAPON_CBOW then
        animation = first.."_CBOW"..ani
    end
    return animation
end

--AiFollow-Function
function ai_follow_func(_aistate)
    -- Stop follow if player disconnected
    if _aistate.followingPlayer == nil or IsPlayerConnected(_aistate.followingPlayer) == 0 then
        _aistate.followingPlayer = nil
        AI_STOP_NOW(_aistate.player, 10)
        return
    end

    local distance = GetDistancePlayers(_aistate.player, _aistate.followingPlayer)
    if distance > 300 then
        local px, _, pz = GetPlayerPos(_aistate.followingPlayer)
        local ox, _, oz = GetPlayerPos(_aistate.player)
        local angle = getAngle(ox, oz, px, pz)
        SetPlayerAngle(_aistate.player,angle)

        local ani = aniHelper("S", GetPlayerWeaponMode(_aistate.player), "RUNL")
        if _aistate.lastAni == nil or _aistate.lastAni ~= ani then
            PlayAnimation(_aistate.player, ani)
            _aistate.lastAni = ani
        end
    elseif distance > 200 then
        local px, _, pz = GetPlayerPos(_aistate.followingPlayer)
        local ox, _, oz = GetPlayerPos(_aistate.player)
        local angle = getAngle(ox, oz, px, pz)
        SetPlayerAngle(_aistate.player,angle)

        local ani = aniHelper("S", GetPlayerWeaponMode(_aistate.player), "WALKL")
        if _aistate.lastAni == nil or _aistate.lastAni ~= ani then
            PlayAnimation(_aistate.player, ani)
            _aistate.lastAni = ani
        end
    else
        local ani = aniHelper("S", GetPlayerWeaponMode(_aistate.player), "RUN")
        if _aistate.lastAni == nil or _aistate.lastAni ~= ani then
            PlayAnimation(_aistate.player, ani)
            _aistate.lastAni = ani
        end
    end
end

function AI_FOLLOW(_playerid, _otherplayerid,  waypoint)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_follow_func);
    lAiState.endWP = AI_WayNets[AI_NPCList[_playerid].GP_World]:GetWaypoint(waypoint);
    lAiState.followingPlayer = _otherplayerid;
    lAiState.lastAni = nil

    local px, _, pz = GetPlayerPos(lAiState.followingPlayer);
    local ox, _, oz = GetPlayerPos(lAiState.player);
    local angle = getAngle(ox, oz, px, pz);
    SetPlayerAngle(lAiState.player,angle);
    
    if(lAiState.endWP == nil)then
        print("AI_FOLLOW: Couldn't find the Waypoint "..waypoint.." in World:"..AI_NPCList[_playerid].GP_World.." Player: ".._playerid);
        return;
    end
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--AiFollow-Function-End

--AiSetWalkType

function ai_setwalktype_func(_aistate)
    setPlayerWalkType(_aistate.player,_aistate.walktype);
    table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    
end

function AI_SETWALKTYPE(_playerid, _walktype)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_setwalktype_func);
    lAiState.walktype = _walktype;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-SetWalkType-End
function ai_playanimation_loop_func(_aistate)
    if(_aistate.start)then
        _aistate.LastPlay = 0;
        _aistate.Current = _aistate.Begin;
        _aistate.start = false;
    end
    if(_aistate.LastPlay + _aistate.Waittime < GetTickCount())then
        if(_aistate.Current > _aistate.End)then
            table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
            return;
        end
        _aistate.LastPlay = GetTickCount();
        PlayAnimation(_aistate.player, _aistate.anim.._aistate.Current);
        
        _aistate.Current = _aistate.Current + 1;
        
    end
    
end

function AI_PLAYANIMATION_LOOP(_playerid, _anim, _begin, _end, _waittime)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_playanimation_loop_func);
    lAiState.anim = _anim;
    lAiState.Continue = true;
    lAiState.Begin = _begin;
    lAiState.Current = _begin;
    lAiState.End = _end;
    lAiState.Waittime = 500;
    lAiState.LastPlay = 0;
    if(_waittime ~= nil)then
        lAiState.Waittime = _waittime;
    end
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end


--AI-PlayAnimation

function ai_playanimation_func(_aistate)
    PlayAnimation(_aistate.player, _aistate.anim);
    table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
end

function AI_PLAYANIMATION(_playerid, _anim, _cont)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_playanimation_func);
    lAiState.anim = _anim;
    lAiState.Continue = true;
    
    if(_cont ~= nil)then
        lAiState.Continue = _cont;
    end
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-PlayAnimation-End

--AI-SetEnemy

function ai_setenemy_func(_aistate)
    table.insert(AI_NPCList[_aistate.player]["ENEMY"], _aistate.enemy); 
    table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    
end

function AI_SETENEMY(_playerid, _enemy)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_setenemy_func);
    lAiState.enemy = _enemy;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-SetEnemy-End


--AI-END_Dialog

function ai_enddialog_func(_aistate)
    table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    endDialog(_aistate.player);
end

function AI_ENDDIALOG(_playerid)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_enddialog_func);
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-END_Dialog-End

--AI-TurnTo

function ai_turnto_func(_aistate)
    
    if(turnPlayer(_aistate.player, _aistate.angle))then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    end
end

function AI_TURNTO(_playerid, _angle)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_turnto_func);
    lAiState.angle = _angle;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-TurnTo-END



--AI-TurnTo

function ai_turntoplayer_func(_aistate)
    
    if(turnPlayer(_aistate.player, GetAngleToPlayer(_aistate.player, _aistate.other)))then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    end
end

function AI_TURNTOPLAYER(_playerid, _other)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_turntoplayer_func);
    lAiState.other = _other;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-TurnTo-END


--AI-TurnToPlayerAO

function ai_turntoplayerao_func(_aistate)
    
    if(turnPlayer(_aistate.player, GetAngleToPlayer(_aistate.player, _aistate.other)) and turnPlayer(_aistate.other, GetAngleToPlayer(_aistate.other, _aistate.player)))then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
    end
end

function AI_TURNTOPLAYERAO(_playerid, _other)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_turntoplayerao_func);
    lAiState.other = _other;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-TurnToPlayerAO-END

--AI_WAITFORCHOISES

function ai_waitforchoise_func(_aistate)
    if(_aistate.start) then
        
        
        
        local diaList = {};
        for key,val in ipairs(AI_NPCList[_aistate.player]["DIA_CHOISES"]) do
            local otherPlayer = AI_PlayerList[AI_NPCList[_aistate.player].DIA_TARGET];
            if(val.condFunc == nil or val.condFunc(otherPlayer.ID, _aistate.player))then
                if(val.type == 0 or (val.type == 2 and otherPlayer.KnowsDialog[val.func] == nil))then
                    table.insert(diaList, val);
                end
            end
        end
        
        if(#diaList == 0)then
            AI_ENDDIALOG(_aistate.player);
            table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
            return;
        end
        
        table.sort(diaList, CompDialogTable);
        
        
        AI_NPCList[_aistate.player].DIA_WAITFORCHOISE = true;
        AI_NPCList[_aistate.player].DIA_CHOISE = 0;
        
        _aistate.DiaList = DialogList.create();
        _aistate.DiaList.entrys = diaList;
        _aistate.DiaList.playerid = AI_NPCList[_aistate.player].DIA_TARGET;
        _aistate.DiaList:Show();
        
    end
    
    if(AI_NPCList[_aistate.player].DIA_CHOISE ~= 0) then
        local ainpc = AI_NPCList[_aistate.player];
        local diafunc = _aistate.DiaList.entrys[ainpc.DIA_CHOISE]["func"];
        _aistate.DiaList:Hide();
        ainpc.DIA_WAITFORCHOISE = false;
        
        diafunc(ainpc.DIA_TARGET,_aistate.player);
        AI_PlayerList[ainpc.DIA_TARGET].KnowsDialog[diafunc] = diafunc;
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);--the actual State is always 1
        return;
    end
    
    _aistate.start = false;
end

function AI_WAITFORCHOISES(_playerid)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_waitforchoise_func);
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai_WAITFORCHOISES-End


--AI_OUTPUT

function ai_output_func(_aistate)
    if(_aistate.start) then
        PlayAnimation(_aistate.otherplayerid, "S_RUN");
        PlayAnimation(_aistate.talkerid, "S_RUN");
        _aistate.stopTime = GetGameTime()+((2+string.len(_aistate.text)*0.3))*200;
        _aistate.drawBG = CreateTexture(0, 0, 8192, 900, "DLG_CONVERSATION.TGA");
        _aistate.draw = CreateDraw(600,600,_aistate.text,"Font_Old_10_White_Hi.TGA",255,255,0);
        _aistate.sound = CreateSound(_aistate.sound);
        
        
        local ox,oy,oz = GetPlayerPos(_aistate.talkerid);
        
        ShowTexture(_aistate.otherplayerid,_aistate.drawBG);
        ShowDraw(_aistate.otherplayerid,_aistate.draw);
        PlayPlayerSound3D(_aistate.otherplayerid,_aistate.sound, ox, oy, oz, 3000);
        
        ShowTexture(_aistate.talkerid,_aistate.drawBG);
        ShowDraw(_aistate.talkerid,_aistate.draw);
        PlayPlayerSound3D(_aistate.talkerid,_aistate.sound, ox, oy, oz, 3000);
        
        PlayGesticulation(_aistate.talkerid);
    end
    
    if(GetGameTime() > _aistate.stopTime) then
        HideDraw(_aistate.talkerid,_aistate.draw);
        HideDraw(_aistate.otherplayerid,_aistate.draw);
        DestroySound(_aistate.sound);
        DestroyDraw(_aistate.draw);
        DestroyTexture(_aistate.drawBG);
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);--the actual State is always 1
        return;
    end
    
    _aistate.start = false;
end

function AI_OUTPUT(_playerid, _otherplayerid, _sound, _text)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_output_func);
    lAiState.talkerid = _playerid;
    lAiState.otherplayerid = _otherplayerid;
    lAiState.sound = _sound;
    lAiState.text = _text;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

function AI_OUTPUT2(_playerid, _talkerid, _otherplayerid, _sound, _text)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_output_func);
    lAiState.talkerid = _talkerid;
    lAiState.otherplayerid = _otherplayerid;
    lAiState.sound = _sound;
    lAiState.text = _text;
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);
end

--Ai-OUTPUT-End

--Ai-HasItem

function ai_hasitem_func(_aistate)
    if(_aistate.start) then
        _aistate.checkNumber = GetGameTime()+string.len(_aistate.CheckItem);
        HasItem(_aistate.CheckPlayer, _aistate.CheckItem, _aistate.checkNumber);
        
        _aistate.start = false;
    end
    
    if(_aistate.Finished == true)then
        if(_aistate.Amount <= _aistate.RealAmount)then
            if(_aistate.FuncTrue ~= nil)then
                _aistate.FuncTrue(_aistate.Arguments, _aistate.CheckItem, _aistate.RealAmount);
            end
        else
            if(_aistate.FuncFalse ~= nil)then
                _aistate.FuncFalse(_aistate.Arguments, _aistate.CheckItem, _aistate.RealAmount);
            end
        end
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
        return;
    end
end
function AI_HasItem(_playerid,_checkPlayerID, _item, _amount, _funcTrue, _funcFalse, arguments)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_hasitem_func);
    
    lAiState.CheckPlayer = _checkPlayerID;
    lAiState.CheckItem = _item;
    lAiState.Amount = _amount;
    lAiState.FuncTrue = _funcTrue;
    lAiState.FuncFalse = _funcFalse;
    lAiState.Arguments = arguments;
    lAiState.Finished = false;
    
    
    table.insert(AI_HASITEM_TABLE, lAiState);
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);

end

--Ai-HasItem-END


--Ai-StartTrade
function ai_starttrade_func(_aistate)
    if(_aistate.start) then
        _aistate.Trading = AI_NPCTrade.create();
        _aistate.Trading.pl[1].id = _aistate.player;
        _aistate.Trading.pl[2].id = _aistate.OtherPlayer;
        
        AI_PlayerList[_aistate.OtherPlayer].TRADINGPARTNER = _aistate.player;
        
        _aistate.Trading:Show();
        _aistate.start = false;
    end
    
    if(GetPlayerOrNPC(_aistate.OtherPlayer) == nil)then
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
        AI_ClearStates(_aistate.player);
        AI_ENDDIALOG(_aistate.player);
        return;
    end
    
    _aistate.Trading:Update();
    
    if(_aistate.Trading.Finished == true)then
        AI_PlayerList[_aistate.OtherPlayer].TRADINGPARTNER = nil;
        table.remove(AI_NPCList[_aistate.player]["STATES"], 1);
        return;
    end
end
function AI_StartTrade(_playerid,_otherplayerid)
    AI_Set(_playerid);
    local lAiState = AIState.create(_playerid, ai_starttrade_func);
    
    lAiState.OtherPlayer = _otherplayerid;
    lAiState.Finished = false;
    
    table.insert(AI_NPCList[_playerid]["STATES"],lAiState);

end

--Ai-StartTrade-End


function AI_ClearStates(_playerid)
    AI_Set(_playerid);
    AI_NPCList[_playerid]["STATES"] = {};
end