AI_NPCTrade = {}
AI_NPCTrade.__index = AI_NPCTrade

function AI_NPCTrade.create()
	local wpnt = {}
	setmetatable(wpnt, AI_NPCTrade)
	
	wpnt.pl = {};
	wpnt.pl[1] = {};--NPC
	wpnt.pl[2] = {};--Player
	wpnt.pl[1].id = 0;
	wpnt.pl[2].id = 0;
	wpnt.pl[1].Background = nil;
	wpnt.pl[2].Background = nil;
	
	wpnt.pl[2].GetInvFinished = false;
	
	wpnt.pl[1].Inventory = {};
	wpnt.pl[1].InventorySort = {};
	
	wpnt.pl[2].Inventory = {};
	wpnt.pl[2].InventorySort = {};
	
	wpnt.pl[1].Position = 1;
	wpnt.pl[2].Position = 1;
	wpnt.pl[2].Gold = 0;
	
	wpnt.Cursor = 2;
	
	wpnt.Finished = false;
	
	
	wpnt.MaxItems = 30;
	return wpnt
end

function AI_NPCTrade:Update()
	if(GetPlayerOrNPC(self.pl[2].id).CheckedInventoryTime ~= -1 and self.pl[2].GetInvFinished == false)then
		self.pl[2].Inventory = AI_GET_INVENTORY_INFO[self.pl[2].id];

		for key,val in pairs(self.pl[2].Inventory) do
			if(val.Item ~="ITMI_GOLD")then
				table.insert(self.pl[2].InventorySort, val);
			else
				self.pl[2].Gold = val.Amount;
			end
		end
		
		self:UpdateInventory(2);
		self:UpdateInventory(1);
		--UpdateTradePlayerTimer(self.pl[2].id, 1);
		
		self.pl[2].GetInvFinished = true;
	end
end

function AI_NPCTrade:Show()

	GetInventory(self.pl[2].id);

	local count = 0;
	self.pl[1].Inventory = GetPlayerAI(self.pl[1].id).NPCTradingInventory;
	for key,val in pairs(self.pl[1].Inventory) do
		count = count + 1;
		self.pl[1].InventorySort[count] = val;
	end
	
	
	--BOOK_BROWN_R.TGA
	local width = 6000;
	local height = 7000;
	
	self.pl[2].Background = CreateTexture(0, ((8192-height)/2), width, 8192-((8192-height)/2), "BOOK_BROWN_R.TGA");
	self.pl[1].Background = CreateTexture(8192-width, ((8192-height)/2), 8192, 8192-((8192-height)/2), "BOOK_BROWN_L.TGA");
	
	ShowTexture(self.pl[2].id, self.pl[2].Background);
	ShowTexture(self.pl[2].id, self.pl[1].Background);
	
	
	self.pl[1].InventoryTitleDraw = CreateDraw(0+200, ((8192-height)/2)+200, GetPlayerName(self.pl[1].id).." Inventory", "FONT_20_BOOK.TGA", 0, 0, 0);
	self.pl[2].InventoryTitleDraw = CreateDraw(5392, ((8192-height)/2)+200, GetPlayerName(self.pl[2].id).." Inventory", "FONT_20_BOOK.TGA", 0, 0, 0);

	self.pl[2].GoldDraw = CreateDraw(7392, ((8192-height)/2)+200, "Gold: ", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
	
	ShowDraw(self.pl[2].id, self.pl[1].InventoryTitleDraw);
	ShowDraw(self.pl[2].id, self.pl[2].InventoryTitleDraw);
	ShowDraw(self.pl[2].id, self.pl[2].GoldDraw);
	
	
	self.pl[1].InventoryItemDraw = {};
	self.pl[2].InventoryItemDraw = {};
	for var = 1, self.MaxItems, 1 do
		self.pl[1].InventoryItemDraw[var] = CreateDraw(0+200, ((8192-height)/2)+200+300+((var-1)*200), "", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		self.pl[2].InventoryItemDraw[var] = CreateDraw(5392, ((8192-height)/2)+200+300+((var-1)*200), "", "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		
		ShowDraw(self.pl[2].id, self.pl[1].InventoryItemDraw[var]);
		ShowDraw(self.pl[2].id, self.pl[2].InventoryItemDraw[var]);
	end
end

function AI_NPCTrade:Hide()
	DestroyTexture(self.pl[1].Background);
	DestroyTexture(self.pl[2].Background);
	
	DestroyDraw(self.pl[1].InventoryTitleDraw );
	DestroyDraw(self.pl[2].InventoryTitleDraw );
	
	DestroyDraw(self.pl[2].GoldDraw);
	
	for var = 1, self.MaxItems, 1 do
		DestroyDraw(self.pl[1].InventoryItemDraw[var]);
		DestroyDraw(self.pl[2].InventoryItemDraw[var]);
	end
	self.Finished = true;
end

function AI_NPCTrade:PositionToTop()
	if(self.pl[1].Position > #self.pl[1].InventorySort and #self.pl[1].InventorySort ~= 0)then
		self.pl[1].Position = #self.pl[1].InventorySort;
	elseif(self.pl[1].Position > #self.pl[1].InventorySort  or self.pl[1].Position < 0)then
		self.pl[1].Position = 1;
	end
			
	if(self.pl[2].Position > #self.pl[2].InventorySort and #self.pl[2].InventorySort ~= 0)then
		self.pl[2].Position = #self.pl[2].InventorySort;
	elseif(self.pl[2].Position > #self.pl[2].InventorySort or self.pl[2].Position < 0)then
		self.pl[1].Position = 1;
	end
end

function AI_NPCTrade:KeyHandler(playerid, keydown)
	if(keydown == KEY_RETURN)then
		self:Hide();
	end
	
	if(keydown == KEY_A)then
		if(self.Cursor == 2)then
			self.Cursor = 1;
			self:UpdateInventory(1);
			self:UpdateInventory(2);
		end
	end
	
	if(keydown == KEY_D)then
		if(self.Cursor == 1)then
			self.Cursor = 2;
			self:UpdateInventory(1);
			self:UpdateInventory(2);
		end
	end
	
	if(keydown == KEY_W)then
		self.pl[self.Cursor].Position = self.pl[self.Cursor].Position - 1;
		if(self.pl[self.Cursor].Position < 1)then
			self.pl[self.Cursor].Position = #self.pl[self.Cursor].InventorySort;
		end
		self:UpdateInventory(self.Cursor);
	end
	
	if(keydown == KEY_S)then
		self.pl[self.Cursor].Position = self.pl[self.Cursor].Position + 1;
		if(self.pl[self.Cursor].Position > #self.pl[self.Cursor].InventorySort)then
			self.pl[self.Cursor].Position = 1;
		end
		self:UpdateInventory(self.Cursor);
	end
	
	if(keydown == KEY_LMENU)then
		if(self.Cursor == 1 and 0 < #self.pl[1].InventorySort)then--Buy
			
			local itemname = self.pl[1].InventorySort[self.pl[1].Position].Item;
			
			if(self.pl[2].Gold >= GetItemPrice(itemname))then
				
				--Inventory-Update NPC!
				self.pl[1].Inventory[itemname].Amount = self.pl[1].Inventory[itemname].Amount -1;
				
				if(self.pl[1].Inventory[itemname].Amount <= 0)then
					self.pl[1].Inventory[itemname] = nil;
					table.remove(self.pl[1].InventorySort, self.pl[1].Position);
				end
				
				--Inventory Update Player!
				if(self.pl[2].Inventory[itemname] ~= nil)then
					self.pl[2].Inventory[itemname].Amount = self.pl[2].Inventory[itemname].Amount + 1;
				else
					self.pl[2].Inventory[itemname] = {};
					self.pl[2].Inventory[itemname].Item = itemname;
					self.pl[2].Inventory[itemname].Amount = 1;
					
					table.insert(self.pl[2].InventorySort, self.pl[2].Inventory[itemname]);
				end
				
				self.pl[2].Gold = self.pl[2].Gold - GetItemPrice(itemname);
				
				GiveItem(self.pl[2].id ,itemname, 1);
				RemoveItem(self.pl[2].id, "ITMI_GOLD", GetItemPrice(itemname));
				self:PositionToTop();
				self:UpdateInventory(1);
				self:UpdateInventory(2);
				
			end
		elseif(self.Cursor == 2 and 0 < #self.pl[2].InventorySort)then--Sell
			local itemname = self.pl[2].InventorySort[self.pl[2].Position].Item;
			--Inventory-Update NPC!
			if(self.pl[1].Inventory[itemname] ~= nil)then
				self.pl[1].Inventory[itemname].Amount = self.pl[1].Inventory[itemname].Amount + 1;
			else
				self.pl[1].Inventory[itemname] = {};
				self.pl[1].Inventory[itemname].Item = itemname;
				self.pl[1].Inventory[itemname].Amount = 1;
				
				table.insert(self.pl[1].InventorySort, self.pl[1].Inventory[itemname]);
			end
			
			--Inventory Update Player!
			self.pl[2].Inventory[itemname].Amount = self.pl[2].Inventory[itemname].Amount -1;
			self.pl[2].Gold = self.pl[2].Gold + GetItemPrice(itemname);
			
			if(self.pl[2].Inventory[itemname].Amount <= 0)then
				self.pl[2].Inventory[itemname] = nil;
				table.remove(self.pl[2].InventorySort, self.pl[2].Position);
			end
			
			RemoveItem(self.pl[2].id ,itemname, 1);
			GiveItem(self.pl[2].id, "ITMI_GOLD", GetItemPrice(itemname));
			
			self:PositionToTop();
			
			self:UpdateInventory(1);
			self:UpdateInventory(2);
		end
	end
end

function AI_NPCTrade:UpdateInventory(pl)
	local height = 7000;
	if(pl == 2)then
		UpdateDraw(self.pl[2].GoldDraw, 7392, ((8192-height)/2)+200, "Gold: "..self.pl[2].Gold, "Font_Old_10_White_Hi.TGA", 0, 0, 0);
	
	end

	for var = 1, self.MaxItems, 1 do
		local str = "";
		local pos = 1;
		if(self.pl[pl].Position <= self.MaxItems)then
			pos = 1;
		else
			pos = self.pl[pl].Position - self.MaxItems+1;
		end
		
		
		
		pos = pos - 1 + var;
		if(self.pl[pl].InventorySort[pos] ~= nil and self.pl[pl].InventorySort[pos]["Item"] ~= nil)then
			str = GetItemName(self.pl[pl].InventorySort[pos]["Item"]).." | "..self.pl[pl].InventorySort[pos]["Amount"].." Price: "..GetItemPrice(self.pl[pl].InventorySort[pos]["Item"]);
		end
		
		
		local x = 0+200;
		local y = ((8192-height)/2)+200+300+((var-1)*200);
		
		if(pl == 2)then
			x = 5392;
		end
		
		if(pos == self.pl[pl].Position and self.Cursor == pl)then
			UpdateDraw(self.pl[pl].InventoryItemDraw[var], x, y, str, "Font_Old_10_White_Hi.TGA", 118, 39, 7);
		else
			UpdateDraw(self.pl[pl].InventoryItemDraw[var], x, y, str, "Font_Old_10_White_Hi.TGA", 0, 0, 0);
		end
	end
end