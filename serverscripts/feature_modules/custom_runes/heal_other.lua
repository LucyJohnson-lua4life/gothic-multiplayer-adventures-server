local heal_other = {}
local HEAL_AMOUNT = 300

function heal_other.OnPlayerSpellCast(playerid, spellInstance)
    if spellInstance == "ITRU_HEALOTHER" then
        local focus = GetFocus(playerid)
        SetPlayerHealth(focus, GetPlayerHealth(focus) + HEAL_AMOUNT)
    end
end

return heal_other