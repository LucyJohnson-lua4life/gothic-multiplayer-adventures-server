
function MAI_CheckWarn(npc)
    local ainpc = GetPlayerAI(npc);

    if(ainpc.Aivars["WARNTIME"] ~= 0)then
        for key,target in pairs(ainpc["TARGETS"]) do
            local aitarget = GetPlayerOrNPC(target);
            if(aitarget and aitarget.GP_IsDead == 0 and aitarget.GP_IsUnconscious == 0 and GetGuildAttitude(ainpc, aitarget) == AI_ATTITUDE_HOSTILE) then
                if(GetDistancePlayers(npc, target) < ainpc.Aivars["WarnDistance"])then
                    if(ainpc.Aivars["WARN"] == 0)then
                        ainpc.Aivars["WARN"] = GetGameTime();
                        PlayAnimation(npc, "T_WARN");
                        ainpc["INTERRUPTED"] = true;

                        if(table.contains(ainpc.Aivars["TARGETS"], target) == false)then
                            table.insert(ainpc.Aivars["TARGETS"], target);
                        end
                    else
                        if(table.contains(ainpc.Aivars["TARGETS"], target) == false)then
                            table.insert(ainpc.Aivars["TARGETS"], target);
                        end
                    end
                end
			--else 
				--AI_RESET_DR(_playerid); -- Alternativ einen Statusreset?
            end  
        end
    end
end

function MAI_LoopWarn(npc)
    local ainpc = GetPlayerAI(npc);

    if(ainpc.Aivars["WARN"] ~= 0 and ainpc.Aivars["WARNTIME"] ~= 0)then
        turnPlayer(npc, GetAngleToPlayer(npc,ainpc.Aivars["TARGETS"][1]));
        PlayAnimation(npc, "T_WARN")


        --Check the Target distance, and remove targets who are to far away!

        for key,val in ipairs(ainpc.Aivars["TARGETS"])do
            if(GetDistancePlayers(npc, val) > ainpc.Aivars["MaxWarnDistance"])then
                table.remove(ainpc.Aivars["TARGETS"], key);

                if(next(ainpc.Aivars["TARGETS"]) == nil)then
                    ainpc.Aivars["WARN"] = 0;
                    ainpc["INTERRUPTED"] = false;
                    PlayAnimation(ainpc.ID, "S_RUN");
                    Reset_TA(ainpc.ID);

                    return false;
                end
            end
        end


        --Attack Targets who are to near!
        local nearTarget = false;
        for key,val in ipairs(ainpc.Aivars["TARGETS"])do

            if(GetDistancePlayers(npc, val) < ainpc.Aivars["MinWarnDistance"])then
                table.insert(ainpc.NEXTMOVES, {type=1, anim="T_FISTPARADEJUMPB"});
                table.insert(ainpc.NEXTMOVES, {type=2, waittime=1});

                nearTarget = true;
                break;
            end
        end

        --Time is Up! Attack!
        if(nearTarget or ainpc.Aivars["WARN"] + ainpc.Aivars["WARNTIME"] < GetGameTime())then
            -- Angepisstes Monster bekommt Enemies
			for key,val in ipairs(ainpc.Aivars["TARGETS"])do
				SetEnemy(npc, val);
			end;
			local firstTarget = ainpc.Aivars["TARGETS"][1];
			ainpc.Aivars["TARGETS"] = {};
			ainpc.Aivars["WARN"] = 0;
			ainpc["INTERRUPTED"] = false;
			PlayAnimation(ainpc.ID, "S_RUN");
			-- Angepisstes Monster ruft Homies an den Start
			for k,v in pairs(GetFullPlayerList()) do
				if k ~= npc and type(k) == "number" and AI_NPCList[k] then
					if GetDistancePlayers(npc, k) < 1500 then
						local ai = GetPlayerAI(k);
						if GetGuildAttitude(ainpc, ai) == AI_ATTITUDE_FRIENDLY then
							SetEnemy(k, firstTarget);
							ai.Aivars["TARGETS"] = {};
							ai.Aivars["WARN"] = 0;
							ai["INTERRUPTED"] = false;
							PlayAnimation(k, "S_RUN");
						end;
					end;
				end;
			end;
        end
        return true;
    end
    return false;
end
