
--Default Monster Daily-Routine
function DR_Monster_Default(_playerid)
    if(TA_FUNC(_playerid,  22,  00,  5,  00))then
		DR_FUNC_SLEEP(_playerid);
    end
    
    if(TA_FUNC(_playerid,  5,  0,  22,  0))then
        DR_FUNC_ROAM(_playerid);
    end
end

--Eating Monster Daily-Routine
function DR_Monster_MidEat(_playerid)
    if(TA_FUNC(_playerid,  22,  00,  5,  00))then
        AI_ClearStates(_playerid);
        DR_FUNC_SLEEP(_playerid);
    end
    
    if(TA_FUNC(_playerid,  5,  0,  22,  0))then
        AI_ClearStates(_playerid);
        DR_FUNC_EAT(_playerid);
    end
end

-- Sheep Routine damit sie nicht zu weit weglaufen
function DR_Sheep_MidEat(_playerid)
    if(TA_FUNC(_playerid,  22,  00,  5,  00))then
        AI_ClearStates(_playerid);
		DR_FUNC_EAT_SHEEP(_playerid);
        --DR_FUNC_SLEEP(_playerid); -- Schafe hauen sonst von Lobarts Wiese Abends ab...
    end
    
    if(TA_FUNC(_playerid,  5,  0,  22,  0))then
        AI_ClearStates(_playerid);
        DR_FUNC_EAT_SHEEP(_playerid);
    end
end

--Shadowbeast Daily-Routine, Sleep on Day, walk on Night
function DR_Monster_Shadowbeast(_playerid)
    if(TA_FUNC(_playerid,  22,  00,  5,  00))then
        AI_ClearStates(_playerid);
        DR_FUNC_EAT(_playerid);
    end
    
    if(TA_FUNC(_playerid,  5,  0,  22,  0))then
        AI_ClearStates(_playerid);
        DR_FUNC_SLEEP(_playerid);
    end
end

-- ORK Routine
function DR_ORK_MidEat(_playerid)
    if(TA_FUNC(_playerid,  22,  00,  5,  00))then
        AI_ClearStates(_playerid);
        DR_FUNC_EAT_ORKS(_playerid);
    end
    
    if(TA_FUNC(_playerid,  5,  0,  22,  0))then
        AI_ClearStates(_playerid);
        DR_FUNC_EAT_ORKS(_playerid);
    end
end

function DR_BLATTCRAWLER(_playerid)
    if(TA_FUNC(_playerid,  22,  00,  5,  00))then
        AI_ClearStates(_playerid);
        DR_FUNC_SLEEP(_playerid);
    end
    
    if(TA_FUNC(_playerid,  5,  0,  22,  0))then
        AI_ClearStates(_playerid);
        DR_FUNC_BLATTCRAWLER(_playerid);
    end
end