--[[

    Module which contains logic that is often use in ui operations.

]]

local ui_utility = {}

--[[
Takes a value and increments it. If the given upper bound is reached the value
will be resetted to the given value. This logic is often used in menu selections, when
after a key press a final selection is reached, the user will be led to the first selection 
again.  
]]
function ui_utility.getNextValueOrReset(current_val, upper_bound, reset_val)
    return current_val >= upper_bound and reset_val or current_val + 1
end

--[[
Takes a value and decrements it. If the given upper bound is reached the value
will be resetted to the given value. This logic is often used in menu selections, when
after a key press a final selection is reached, the user will be led to the 
first selection again.
]]
function ui_utility.getPreviousValueOrReset(current_val, lower_bound, reset_val)
    return current_val <= lower_bound and reset_val or current_val - 1
end

return ui_utility;

