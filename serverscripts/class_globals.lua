CLASS_NAMES = {"Fighter", "Hunter", "Spell Fighter", "Berserker", "Tank"}

--[[CLASS_DESCRIPTION = {"Bester Nahkaempfer, hohe HP, hohe STR, 100% 1H", "Bester Fernkaempfer, niedrige HP, hohe DEX, 60% Bogen",
"Nahkampf-Fernkampfhybrid. Verwendet 1H und Magie im Kampf.", "Hoechster Schaden im Spiel. Allerdings unzuverlaessiger Schaden. 60% 2H",
"Hoechste HP im Spiel. Allerdings niedrige Staerke und unzuverlaessiger Schaden. 30% 1H"}
]]--
CLASS_DESCRIPTION1 = {"Bester Nahkaempfer im Spiel.", "Bester Fernkaempfer im Spiel.",
"Magie-Nahkampfhybrid.", "Hoechster Schaden im Spiel.",
"Hoechste HP im Spiel."}

CLASS_DESCRIPTION2 = {"Geeignet fuer Duelle und Schlachten.", "Geeignet fuer Scharmuetzel und als Support.",
"Einsatzmoeglichkeit in allen Bereichen.", "Geeignet fuer Schlachten.",
"Geeignet fuer Schlachten."}

CLASS_ID = {1,2,3,4,5}
CLASS_STR = {145, 120, 140, 200, 40}
CLASS_DEX = {50, 140, 50, 50, 50}
CLASS_ONE_H = {100, 50, 70, 30, 60}
CLASS_TWO_H = {40, 40, 40, 60, 30}
CLASS_BOW = {40, 60, 40, 40, 30}
CLASS_CBOW = {40, 60, 40, 40, 40}
CLASS_HEALTH = {1595, 1015, 1160, 1015, 5075}
CLASS_MANA = {50, 50, 75, 50, 50}
CLASS_MAGIC_LEVEL = {1, 1, 6, 1, 1}
CLASS_MELEE_WEAPON = {"ItNm_Kriegsschwert", "ItNm_Jaegeraxt", "ItNm_Priestklinge", "ItNm_Berserkeraxt", "ItNm_Streitkolben"}
CLASS_ARMOR = {"ItNm_Panzerweste", "ItNm_Panzerweste", "ItNm_Panzerweste", "ItNm_Panzerweste", "ItNm_Panzerweste"}
CLASS_NUM = 5
--
CLASS_INVENTORY = {}
CLASS_INVENTORY[1] = {"ItNm_Panzerkleid", "ItLsTorch"}
CLASS_INVENTORY[2] = {"ItNm_Panzerkleid", "ItRw_Bow_H_01", "ItRw_Arrow", "ItLsTorch"}
CLASS_INVENTORY[3] = {"ItNm_Panzerkleid", "ItLsTorch", "ItRu_HealOther", "ItRu_LightningFlash"}
CLASS_INVENTORY[4] = {"ItNm_Panzerkleid", "ItLsTorch"}
CLASS_INVENTORY[5] = {"ItNm_Panzerkleid", "ItLsTorch", "ItRu_PalLight", "ItRu_Zap"}
CLASS_INVENTORY_AMOUNT = {}
CLASS_INVENTORY_AMOUNT[1] = {1, 10}
CLASS_INVENTORY_AMOUNT[2] = {1, 1, 100, 10}
CLASS_INVENTORY_AMOUNT[3] = {1, 10, 1, 1}
CLASS_INVENTORY_AMOUNT[4] = {1, 10}
CLASS_INVENTORY_AMOUNT[5] = {1, 10, 1, 1}
CLASS_STARTER_EQUIP = {}

local class_globals = {}

function class_globals.isStarterEquip(item_instance)
    local isStarterEquip = false
    for _,value in pairs(CLASS_STARTER_EQUIP) do
        if value == item_instance then
            isStarterEquip = true
        end
    end

    return isStarterEquip
end

function class_globals.setClassAttributes(playerid, classid)
    ClearInventory(playerid)
    SetPlayerStrength(playerid, CLASS_STR[classid])
    SetPlayerDexterity(playerid, CLASS_DEX[classid])
    SetPlayerSkillWeapon(playerid, SKILL_1H, CLASS_ONE_H[classid])
    SetPlayerSkillWeapon(playerid, SKILL_2H, CLASS_TWO_H[classid])
    SetPlayerSkillWeapon(playerid, SKILL_BOW, CLASS_BOW[classid])
    SetPlayerSkillWeapon(playerid, SKILL_CBOW, CLASS_CBOW[classid])
    SetPlayerMaxHealth(playerid, CLASS_HEALTH[classid])
    SetPlayerHealth(playerid, CLASS_HEALTH[classid])
    SetPlayerMana(playerid, CLASS_MANA[classid])
    SetPlayerMaxMana(playerid, CLASS_MANA[classid])
    SetPlayerMagicLevel(playerid, CLASS_MAGIC_LEVEL[classid])
    EquipArmor(playerid, CLASS_ARMOR[classid])
    EquipMeleeWeapon(playerid, CLASS_MELEE_WEAPON[classid])
    SetPlayerScience(playerid, 0, 1)
end

function class_globals.setClassInventory(playerid, classid)
    for key,value in pairs(CLASS_INVENTORY[classid]) do
        GiveItem(playerid, value, CLASS_INVENTORY_AMOUNT[classid][key])
    end
end

return class_globals
