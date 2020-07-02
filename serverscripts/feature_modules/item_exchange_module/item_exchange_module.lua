
require "serverscripts/utils/script_functions"
require "serverscripts/player_globals"
require "serverscripts/has_item_globals"
local class_globals = require "serverscripts/class_globals"
local inventory_dao = require "serverscripts/daos/inventory_dao"
local item_exchange_module = {}
local check_id = ITEM_EXCHANGE_MODULE_ID
local focus = {}
local planned_amount = {}

local function sendHelpMessage(playerid)
    SendPlayerMessage(playerid, 230, 230, 230, "Tippe /give (Item_Instance) (Anzahl) ein um einem Spieler einen Gegenstand aus deinem Inventar zu geben.")
    SendPlayerMessage(playerid, 230, 230, 230, "Die Item_Instance findest du entweder im Internet oder sie wurde dir beim Droppen angezeigt.")
end

function item_exchange_module.OnPlayerCommandText(playerid, cmdtext)
    local cmd, params = GetCommand(cmdtext);

    if cmd == "/give" then
        local spl = params:split(" ");


        if spl[1] == nil then
            SendPlayerMessage(playerid, 255,0,0, "Du hast kein Item angegeben.")
        elseif spl[2] == nil then
            SendPlayerMessage(playerid, 255,0,0, "Du hast keine Mengenangabe angegeben.")
        end

        local item_instance = trim(spl[1])
        local amount_planned = tonumber(trim(spl[2]))
        
        if type(amount_planned) ~= "number" then
            SendPlayerMessage(playerid, 255,0,0, "Deine Mengenangabe ist keine Nummer.")
        end

        planned_amount[playerid]= amount_planned
        focus[playerid] = GetFocus(playerid)

        if focus[playerid] == nil then
            SendPlayerMessage(playerid, 255,0,0, "Du hast keinen Spieler fokussiert.")
        end

        HasItem(playerid, item_instance, check_id)
    elseif cmdtext == "/inventory help" then
        sendHelpMessage(playerid)
    end
end


local function giveItemOrThrowError(playerid, focusid, item_instance, amount_planned, amount)
    
    if focusid ~= nil and amount >= amount_planned and class_globals.isStarterEquip(item_instance) == false  then
        GiveItem(focusid, item_instance, amount_planned)
        inventory_dao.updateItemAmount(PLAYER_HANDLER_MAP[playerid], PLAYER_ID_NAME_MAP[playerid], item_instance, amount - amount_planned)
        RemoveItem(playerid, item_instance, amount_planned)
        SendPlayerMessage(playerid, 0, 255, 0, "Du hast ".. amount_planned .. "x " .. item_instance .. " vergeben.")
        PlayAnimation(playerid, "T_TRADEITEM")
    end

    if amount == nil or amount < amount_planned then
        SendPlayerMessage(playerid, 255,0,0, "Du verfuegst nicht ueber die angegebene Anzahl.")
    end

    if class_globals.isStarterEquip(item_instance) == true then
        SendPlayerMessage(playerid, 255,0,0, "Du kannst keine Starter Items tauschen.")
    end

end

function item_exchange_module.OnPlayerHasItem(playerid, item_instance, amount, equipped, checkid)
    if checkid == check_id then
 
         if item_instance == "NULL" then
            SendPlayerMessage(playerid,255,255,0,"Item nicht im Inventar gefunden")
         else
            giveItemOrThrowError(playerid, focus[playerid], item_instance, planned_amount[playerid], amount)
         end
         focus[playerid] = nil
         planned_amount[playerid] = nil
    end
end

return item_exchange_module