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