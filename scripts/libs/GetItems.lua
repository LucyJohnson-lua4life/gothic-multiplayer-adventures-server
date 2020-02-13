TRADE_ITEM_LIST = {};
TRADE_ITEM_PRICE_LIST = {};
require "scripts/libs/Items/items_en"
require "scripts/libs/Items/items_prices"

function GetItemName(item_instance)
	if(TRADE_ITEM_LIST[item_instance] == nil)then
		return item_instance;
	end
	
	return TRADE_ITEM_LIST[item_instance];
end

function GetItemPrice(item_instance)
	if(TRADE_ITEM_PRICE_LIST[item_instance] == nil)then
		return 1000;
	end
	
	return TRADE_ITEM_PRICE_LIST[item_instance];
end

AI_GET_INVENTORY_INFO = {};
local AI_GET_INVENTORY_increment = 10;--10 Item per time

function TRADING_OnPlayerResponseItem(playerid, slot, item_instance, amount, equipped)
	if(AI_GET_INVENTORY_INFO[playerid] ~= nil)then
		if(item_instance ~= "NULL")then
			if(AI_GET_INVENTORY_INFO[playerid][item_instance] == nil)then
				AI_GET_INVENTORY_INFO[playerid][item_instance] = {Item=item_instance, Amount=amount, Equipped=equipped, Slots=false};
			else
				AI_GET_INVENTORY_INFO[playerid][item_instance].Slots = true;
				AI_GET_INVENTORY_INFO[playerid][item_instance]["Amount"] = AI_GET_INVENTORY_INFO[playerid][item_instance]["Amount"]+amount;
			end
		end
		
		if((slot+1) % AI_GET_INVENTORY_increment == 0)then
			if(item_instance ~= "NULL")then
				for var = 1, AI_GET_INVENTORY_increment, 1 do
					GetPlayerItem(playerid, slot+var);
				end
			else
				GetPlayerOrNPC(playerid).CheckedInventoryTime = GetGameTime();--end
				
			end
		end
	end
end

function GetInventory(playerid)
	if(AI_GET_INVENTORY_INFO[playerid] ~= nil and (GetPlayerOrNPC(playerid).CheckedInventoryTime ~= nil and GetPlayerOrNPC(playerid).CheckedInventoryTime==-1))then
		return false;
	end
	
	GetPlayerOrNPC(playerid).CheckedInventoryTime = -1;
	AI_GET_INVENTORY_INFO[playerid] = {};
	
	for var = 0, AI_GET_INVENTORY_increment-1, 1 do
		GetPlayerItem(playerid, var);
	end
	
	return true;
end

local MaxItems = 27;
local MaxTradingItems = 15;
local PlayerTimers = {};
function LoadTradingPlayers(playerid1, playerid2)
	if(PlayerTimers[playerid1] ~= nil or PlayerTimers[playerid2] ~= nil)then
		return
	end
	
	FreezePlayer(playerid1, 1);
	FreezePlayer(playerid2, 1);
	
	GetInventory(playerid1);
	GetInventory(playerid2);
	
	tradeTimer = SetTimerEx("TradeTimer",1000,1, playerid1);
	
	local trading = {};
	trading.Timer = tradeTimer;
	trading.pl = {};
	trading.pl[1] = {};
	trading.pl[2] = {};
	trading.pl[1].id = playerid1;
	trading.pl[2].id = playerid2;
	trading.pl[1].Position = 1;
	trading.pl[2].Position = 1;
	
	trading.pl[1].GetInvFinished = false;
	trading.pl[2].GetInvFinished = false;
	trading.pl[1].TradeInventory = {};
	trading.pl[2].TradeInventory = {};
	trading.pl[1].TradeInventorySort = {};
	trading.pl[2].TradeInventorySort = {};
	trading.LockedPlayer = 0;
	trading.Locked = false;
	
	trading.ListTexture = CreateTexture(2596, 0+600, 8192, 8192-600, "BOOK_BROWN_L.TGA");
	ShowTexture(playerid1, trading.ListTexture);
	ShowTexture(playerid2, trading.ListTexture);
	
	trading.OtherTexture = CreateTexture(0, 256, 2048+1024+500, 1536+2048+256, "BOOK_BROWN_R.TGA");
	trading.YourTexture = CreateTexture(0, 4096+256, 2048+1024+500, 4096+1024+2048+512+256, "BOOK_BROWN_R.TGA");
	ShowTexture(playerid1, trading.OtherTexture);
	ShowTexture(playerid2, trading.OtherTexture);
	ShowTexture(playerid1, trading.YourTexture);
	ShowTexture(playerid2, trading.YourTexture);
	
	
	trading.LockedTexture = CreateTexture(4096-1000, 4096-1000, 4096+1000, 4096+1000, "LETTERS.TGA");
	trading.LockedDraw = CreateDraw(4096-700, 4096-200, "The Trade is locked!", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
	
	PlayerTimers[playerid1] = trading;
	PlayerTimers[playerid2] = trading;
	
	
	--"FONT_20_BOOK.TGA"
	--"FONT_10_BOOK.TGA"
	local x = 5500;
	local y = 900;
	trading.pl[1].ListText = CreateDraw(x, y, GetPlayerName(playerid1).." Inventory", "FONT_20_BOOK.TGA", 0, 0, 0);
	trading.pl[2].ListText = CreateDraw(x, y, GetPlayerName(playerid2).." Inventory", "FONT_20_BOOK.TGA", 0, 0, 0);
	ShowDraw(playerid1, trading.pl[1].ListText);
	ShowDraw(playerid2, trading.pl[2].ListText);
	
	local x = 125;
	
	local y = 4096+256+125;
	trading.pl[1].YourText = CreateDraw(x, y, GetPlayerName(playerid1).." Offer", "FONT_10_BOOK.TGA", 0, 0, 0);
	trading.pl[2].YourText = CreateDraw(x, y, GetPlayerName(playerid2).." Offer", "FONT_10_BOOK.TGA", 0, 0, 0);
	ShowDraw(playerid1, trading.pl[1].YourText);
	ShowDraw(playerid2, trading.pl[2].YourText);
	
	local y = 256+125;
	trading.pl[1].OtherText = CreateDraw(x, y, GetPlayerName(playerid2).." Offer", "FONT_10_BOOK.TGA", 0, 0, 0);
	trading.pl[2].OtherText = CreateDraw(x, y, GetPlayerName(playerid1).." Offer", "FONT_10_BOOK.TGA", 0, 0, 0);
	ShowDraw(playerid1, trading.pl[1].OtherText);
	ShowDraw(playerid2, trading.pl[2].OtherText);
	
	trading.pl[1].InvList = {};
	trading.pl[2].InvList = {};
	for var = 1, MaxItems, 1 do
		local x = 5500;
		local y = 1100+(200*(var-1));
		if(var == trading.pl[1].Position)then
			trading.pl[1].InvList[var] = CreateDraw(x, y, "", "FONT_10_BOOK.TGA", 118, 39, 7);
		else
			trading.pl[1].InvList[var] = CreateDraw(x, y, "", "FONT_10_BOOK.TGA", 0, 0, 0);
		end
		if(var == trading.pl[2].Position)then
			trading.pl[2].InvList[var] = CreateDraw(x, y, "", "FONT_10_BOOK.TGA", 118, 39, 7);
		else
			trading.pl[2].InvList[var] = CreateDraw(x, y, "", "FONT_10_BOOK.TGA", 0, 0, 0);
		end
		ShowDraw(playerid1, trading.pl[1].InvList[var]);
		ShowDraw(playerid2, trading.pl[2].InvList[var]);
	end
	
	trading.pl[1].YourTradingItemsDraw = {};
	trading.pl[2].YourTradingItemsDraw = {};
	trading.pl[1].OtherTradingItemsDraw = {};
	trading.pl[2].OtherTradingItemsDraw = {};
	for var = 1, MaxTradingItems, 1 do
		local x = 125;
		local y = 4096+256+125+200+(200*(var-1));
		trading.pl[1].YourTradingItemsDraw[var] = CreateDraw(x, y, "", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		trading.pl[2].YourTradingItemsDraw[var] = CreateDraw(x, y, "", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		ShowDraw(playerid1, trading.pl[1].YourTradingItemsDraw[var]);
		ShowDraw(playerid2, trading.pl[2].YourTradingItemsDraw[var]);
		
		local y = 256+125+200+(200*(var-1));
		trading.pl[1].OtherTradingItemsDraw[var] = CreateDraw(x, y, "", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		trading.pl[2].OtherTradingItemsDraw[var] = CreateDraw(x, y, "", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		ShowDraw(playerid1, trading.pl[1].OtherTradingItemsDraw[var]);
		ShowDraw(playerid2, trading.pl[2].OtherTradingItemsDraw[var]);
	end
end

function StopTradingPlayers(playerid)
	local trading = PlayerTimers[playerid];
	if(trading == nil)then
		return;
	end
	PlayerTimers[trading.pl[1].id] = nil;
	PlayerTimers[trading.pl[2].id] = nil;
	
	KillTimer(trading.Timer);
	DestroyTexture(trading.ListTexture);
	DestroyTexture(trading.OtherTexture);
	DestroyTexture(trading.YourTexture);
	
	DestroyDraw(trading.pl[1].ListText);
	DestroyDraw(trading.pl[2].ListText);
	
	DestroyDraw(trading.pl[1].YourText);
	DestroyDraw(trading.pl[2].YourText);
	
	DestroyDraw(trading.pl[1].OtherText);
	DestroyDraw(trading.pl[2].OtherText);
	
	DestroyTexture(trading.LockedTexture);
	DestroyDraw(trading.LockedDraw); 
	
	for var = 1, MaxItems, 1 do
		DestroyDraw(trading.pl[1].InvList[var]);
		DestroyDraw(trading.pl[2].InvList[var]);
	end
	
	for var = 1, MaxTradingItems, 1 do
		DestroyDraw(trading.pl[1].OtherTradingItemsDraw[var]);
		DestroyDraw(trading.pl[2].OtherTradingItemsDraw[var]);
		
		DestroyDraw(trading.pl[1].YourTradingItemsDraw[var]);
		DestroyDraw(trading.pl[2].YourTradingItemsDraw[var]);
	end
	FreezePlayer(trading.pl[1].id, 0);
	FreezePlayer(trading.pl[2].id, 0);
end


function TradeTimer(playerid)
	local trading = PlayerTimers[playerid];
	
	if(GetPlayerOrNPC(playerid) == nil or GetPlayerOrNPC(trading.pl[2].id) == nil)then
		KillTimer(trading.Timer);
		return;
	end
	
	if(GetPlayerOrNPC(playerid).CheckedInventoryTime ~= -1 and trading.pl[1].GetInvFinished == false)then
		trading.pl[1].Inventory = AI_GET_INVENTORY_INFO[playerid];
		UpdateTradePlayerTimer(trading.pl[1].id, 1);
		
		trading.pl[1].GetInvFinished = true;
	end
	
	if(GetPlayerOrNPC(trading.pl[2].id).CheckedInventoryTime ~= -1 and trading.pl[2].GetInvFinished == false)then
		trading.pl[2].Inventory = AI_GET_INVENTORY_INFO[trading.pl[2].id];
		UpdateTradePlayerTimer(trading.pl[2].id, 2);
		
		trading.pl[2].GetInvFinished = true;
	end
	if(trading.pl[1].GetInvFinished == true and trading.pl[2].GetInvFinished == true)then
		KillTimer(trading.Timer);
		return;
	end
end

function UpdateTradePlayerTimer(playerid, pl)
	local trading = PlayerTimers[playerid];
	trading.pl[pl].InventorySort = {};
	local count = 0;
	for key,val in pairs(trading.pl[pl].Inventory) do
		count = count + 1;
		trading.pl[pl].InventorySort[count] = val;
		if(count <= MaxItems)then
			local x = 5500;
			local y = 1200+(220*(count-1));
			if(count == trading.pl[pl].Position)then
				UpdateDraw(trading.pl[pl].InvList[count], x, y, GetItemName(val.Item).." | "..val.Amount, "Font_Old_10_White_Hi.TGA", 118, 39, 7);
			else
				UpdateDraw(trading.pl[pl].InvList[count], x, y, GetItemName(val.Item).." | "..val.Amount, "Font_Old_10_White_Hi.TGA", 0, 0, 0);
			end
		end
	end
	
	trading.pl[pl].InventorySize = count;
	
end

function UpdateTradePlayer(trading, pl)
	for var = 1, MaxItems, 1 do
		local str = "";
		local pos = 1;
		if(trading.pl[pl].Position <= MaxItems)then
			pos = 1;
		else
			pos = trading.pl[pl].Position - MaxItems+1;
		end
		
		
		
		pos = pos - 1 + var;
		if(trading.pl[pl].InventorySort[pos] ~= nil and trading.pl[pl].InventorySort[pos]["Item"] ~= nil)then
			str = GetItemName(trading.pl[pl].InventorySort[pos]["Item"]).." | "..trading.pl[pl].InventorySort[pos]["Amount"];
		end
		

		local x = 5500;
		local y = 1200+(220*(var-1));
		
		if(pos == trading.pl[pl].Position)then
			UpdateDraw(trading.pl[pl].InvList[var], x, y, str, "Font_Old_10_White_Hi.TGA", 118, 39, 7);
		else
			UpdateDraw(trading.pl[pl].InvList[var], x, y, str, "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		end
	end
end

function UpdateTradePlayerYourDraw(trading, pl)
	for var = 1, MaxTradingItems, 1 do
		local str = "";
		if(trading.pl[pl].TradeInventorySort[var] ~= nil)then
			str = GetItemName(trading.pl[pl].TradeInventorySort[var]["Item"]).." | "..trading.pl[pl].TradeInventorySort[var]["Amount"];
		end
		
		local x = 125;
		local y = 4096+256+125+200+(200*(var-1));
		UpdateDraw(trading.pl[pl].YourTradingItemsDraw[var], x, y, str, "Font_Old_10_White_Hi.TGA", 0, 0, 0);
	end
end

function UpdateTradePlayerOtherDraw(trading, pl)
	local otherpl = 1;
	if(pl == 1)then
		otherpl = 2;
	end
	
	for var = 1, MaxTradingItems, 1 do
		local str = "";
		if(trading.pl[pl].TradeInventorySort[var] ~= nil)then
			str = GetItemName(trading.pl[pl].TradeInventorySort[var]["Item"]).." | "..trading.pl[pl].TradeInventorySort[var]["Amount"];
		end

		local x = 125;
		local y = 256+125+200+(200*(var-1));
		UpdateDraw(trading.pl[otherpl].OtherTradingItemsDraw[var], x, y, str, "Font_Old_10_White_Hi.TGA", 0, 0, 0);
	end
end

function Trade_OnPlayerKey(playerid, keydown)
	local trading = PlayerTimers[playerid];
	if(trading == nil)then
		return false;
	end
	
	local pl = 2;
	if(trading.pl[1].id == playerid)then
		pl = 1;
	end
	
	if(trading.pl[pl].InventorySort == nil)then
		return false;
	end
	
	if(keydown == KEY_RETURN)then
		if(trading.Locked == true and trading.LockedPlayer ~= pl)then
			for key,val in ipairs(trading.pl[1].TradeInventorySort) do
				RemoveItem(trading.pl[1].id, val.Item, val.Amount);
				GiveItem(trading.pl[2].id, val.Item, val.Amount);
			end
			for key,val in ipairs(trading.pl[2].TradeInventorySort) do
				RemoveItem(trading.pl[2].id, val.Item, val.Amount);
				GiveItem(trading.pl[1].id, val.Item, val.Amount);
			end
			StopTradingPlayers(playerid);
			return true;
		elseif(trading.Locked == false)then
			trading.Locked = true;
			trading.LockedPlayer = pl;
			ShowTexture(trading.pl[1].id,trading.LockedTexture);
			ShowTexture(trading.pl[2].id,trading.LockedTexture);
			ShowDraw(trading.pl[1].id, trading.LockedDraw);
			ShowDraw(trading.pl[2].id, trading.LockedDraw);
			return true;
		end
	end
	
	if(keydown == KEY_A and #trading.pl[pl].TradeInventorySort <= MaxTradingItems)then
		local item = trading.pl[pl].InventorySort[trading.pl[pl].Position];
		if(item.Amount ~= 0)then
			if(trading.pl[pl].TradeInventory[item.Item] == nil or trading.pl[pl].TradeInventory[item.Item].Amount == 0)then
				local newItem = {};
				newItem.Amount = 1;
				newItem.Item = item.Item;
				newItem.Slots = item.Slots;
				trading.pl[pl].TradeInventory[item.Item] = newItem;
				table.insert(trading.pl[pl].TradeInventorySort, newItem);
			else
				trading.pl[pl].TradeInventory[item.Item].Amount = trading.pl[pl].TradeInventory[item.Item].Amount + 1;
			end
			item.Amount = item.Amount - 1;
			UpdateTradePlayer(trading, pl);
			UpdateTradePlayerYourDraw(trading, pl);
			UpdateTradePlayerOtherDraw(trading, pl);
			
			trading.Locked = false;
			HideTexture(trading.pl[1].id,trading.LockedTexture);
			HideTexture(trading.pl[2].id,trading.LockedTexture);
			HideDraw(trading.pl[1].id, trading.LockedDraw);
			HideDraw(trading.pl[2].id, trading.LockedDraw);
		end
	end
	
	if(keydown == KEY_D)then
		local item = trading.pl[pl].InventorySort[trading.pl[pl].Position];
		if(trading.pl[pl].TradeInventory[item.Item] ~= nil and trading.pl[pl].TradeInventory[item.Item].Amount ~= 0)then
			trading.pl[pl].TradeInventory[item.Item].Amount = trading.pl[pl].TradeInventory[item.Item].Amount - 1;
			item.Amount = item.Amount + 1;
			
			if(trading.pl[pl].TradeInventory[item.Item].Amount == 0)then--Delete from List!
				for key,val in ipairs(trading.pl[pl].TradeInventorySort) do
					if(val == trading.pl[pl].TradeInventory[item.Item])then
						table.remove(trading.pl[pl].TradeInventorySort, key);
						break;
					end
				end
				trading.pl[pl].TradeInventory[item.Item] = nil;
			end
			UpdateTradePlayer(trading, pl);
			UpdateTradePlayerYourDraw(trading, pl);
			UpdateTradePlayerOtherDraw(trading, pl);
			trading.Locked = false;
			HideTexture(trading.pl[1].id,trading.LockedTexture);
			HideTexture(trading.pl[2].id,trading.LockedTexture);
			HideDraw(trading.pl[1].id, trading.LockedDraw);
			HideDraw(trading.pl[2].id, trading.LockedDraw);
		end
	end
	
	if(keydown == KEY_W)then
		trading.pl[pl].Position = trading.pl[pl].Position - 1;
		if(trading.pl[pl].Position < 1)then
			trading.pl[pl].Position = #trading.pl[pl].InventorySort;
		end
		UpdateTradePlayer(trading, pl);
	end
	
	if(keydown == KEY_S)then
		trading.pl[pl].Position = trading.pl[pl].Position + 1;
		if(trading.pl[pl].Position > #trading.pl[pl].InventorySort)then
			trading.pl[pl].Position = 1;
		end
		UpdateTradePlayer(trading, pl);
	end
	
	return false;
end