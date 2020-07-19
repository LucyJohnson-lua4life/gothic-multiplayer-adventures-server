require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
require "serverscripts/price_table"

local dia_vlk_2001_olga = {}
 
local function handleBuddlertruppDia(playerid, text)
    if string.match(text, "Buddlertrupp") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Hmm tasaechlich. Vor etwa einer Woche kamen hier ein paar <Jungs> mit Schuerfausruestung an.")
        return true
    elseif string.match(text, "Jungs") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Sie haben leider nicht genau gesagt wohin sie wollen. Aber <Einer> von ihnen wurde ganz schoen betrunken.")
        return true
    elseif string.match(text, "Einer") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Er beschwerte sich ueber seine Freundin, wie sie ihn die ganze Zeit schikanierte fuer sein geringes <Gehalt>.")
        return true
    elseif string.match(text, "Gehalt") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Sie schien ziemlich viel von seinem Einkommen fuer Kleider und teure Weine <ausgegeben> zu haben.")
        return true
    elseif string.match(text, "ausgegeben") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Tja was soll ich sagen. Junge Menschen wissen noch nicht viel ueber die Welt. Also haben sie manchmal schlechte <Prioritaeten>.")
        return true
    elseif string.match(text, "Prioritaeten") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Wenn du die Jungs finden willst. Solltest du dich einfach auf dem Weg zur <Goldmine> nahe Onars Hof machen.");
        return true
    elseif string.match(text, "Goldmine") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Von Onars Hof aus, siehst du in den Bergen einen kleinen <Leuchtturm>.");
    elseif string.match(text, "Leuchtturm") then
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Neben dem vergitterten Haupteingang muss es irgendo auch einen weiteren Eingang zur neuen Goldader geben.");
        return true
    else
        return false
    end
end


function dia_vlk_2001_olga.handleDialogue(playerid, text)
    
    if handleBuddlertruppDia(playerid, text) == true then
        return
    else
        -- INIT DIALOGUE
        SendPlayerMessage(playerid, 255, 255, 255, "Olga sagt: Hallo Fremder! Wie kann ich dir helfen?")
    end

end




return dia_vlk_2001_olga
