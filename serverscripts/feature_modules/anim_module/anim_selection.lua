require "serverscripts/utils/script_functions"
local anim_selection = {}
local ANIMS = {}

ANIMS["/sit"] = "T_STAND_2_SIT"
ANIMS["/sleep"] = "T_STAND_2_SLEEPGROUND"
ANIMS["/guard1"] = "S_LGUARD"
ANIMS["/guard2"] = "S_HGUARD"
ANIMS["/pee"] = "T_STAND_2_PEE"
ANIMS["/watchfight1"] = "S_WATCHFIGHT"
ANIMS["/watchfight2"] = "T_WATCHFIGHT_YEAH"
ANIMS["/watchfight3"] = "T_WATCHFIGHT_OHNO"
ANIMS["/no"] = "T_NO"
ANIMS["/plunder"] = "T_PLUNDER"
ANIMS["/pray"] = "S_PRAY"
ANIMS["/practice"] = "T_1HSFREE"
ANIMS["/practicemagic1"] = "T_PRACTICEMAGIC"
ANIMS["/practicemagic2"] = "T_PRACTICEMAGIC2"
ANIMS["/practicemagic3"] = "T_PRACTICEMAGIC3"
ANIMS["/practicemagic4"] = "T_PRACTICEMAGIC4"
ANIMS["/practicemagic5"] = "T_PRACTICEMAGIC5"
ANIMS["/dance1"] = "T_DANCE_01"
ANIMS["/dance2"] = "T_DANCE_02"
ANIMS["/dance3"] = "T_DANCE_03"
ANIMS["/dance4"] = "T_DANCE_04"
ANIMS["/dance5"] = "T_DANCE_05"
ANIMS["/dance6"] = "T_DANCE_06"
ANIMS["/dance7"] = "T_DANCE_07"
ANIMS["/dance8"] = "T_DANCE_08"
ANIMS["/dance9"] = "T_DANCE_09"

ANIMS["/greet1"] = "T_GREETCOOL"
ANIMS["/greet2"] = "T_GREETGRD"
ANIMS["/greet3"] = "T_GREETLEFT"
ANIMS["/greet4"] = "T_GREETRIGHT"
ANIMS["/greet5"] = "T_GREETNOV"

ANIMS["/casual1"] = "R_LEGSHAKE"
ANIMS["/casual2"] = "R_SCRATCHHEAD"
ANIMS["/casual3"] = "R_SCRATCHEGG"
ANIMS["/casual4"] = "R_SCRATCHLSHOULDER"
ANIMS["/casual5"] = "R_SCRATCHRSHOULDER"
ANIMS["/casual6"] = "T_DONTKNOW"
ANIMS["/getlost1"] = "T_GETLOST"
ANIMS["/getlost2"] = "T_GETLOST2"
ANIMS["/getlost3"] = "T_FORGETIT"
ANIMS["/wash"] = "T_STAND_2_WASH"
ANIMS["/comeoverhere"] = "T_COMEOVERHERE"
ANIMS["/igetyou"] = "T_IGETYOU"
ANIMS["/search"] = "T_SEARCH"
ANIMS["/trade"] = "T_TRADEITEM"




local function printAnimHelp(playerid)
    SendPlayerMessage(playerid,255,255,255,"Das hier sind die verfuegbaren Animationen:")
    SendPlayerMessage(playerid,255,255,255,"/sit /sleep /guard1 /guard2 /pee /watchfight(1-3) /no /plunder /pray /practice /practicemagic(1-5) /dance(1-9) /greet(1-5)")
    SendPlayerMessage(playerid,255,255,255,"/casual(1-6) /getlost(1-2) /wash /comeoverhere /igetyou /search")
end

function anim_selection.OnPlayerCommandText(playerid, cmdtext)
    if ANIMS[cmdtext] ~= nil then
        PlayAnimation(playerid, ANIMS[cmdtext])
    elseif cmdtext == "/anim help" then
        printAnimHelp(playerid)
    end
end

return anim_selection


