
DialogList = {}
DialogList.__index = DialogList

function DialogList.create()
	local wpnt = {}
	setmetatable(wpnt, DialogList)
	
	wpnt.entrys = {};
	wpnt.position = 1;
	wpnt.maxShow = 5;
	wpnt.playerid = 0;
	
	wpnt.background = nil;
	wpnt.SelBackground = {};
	wpnt.TextView = {};
	
	wpnt.BottomTexture = nil;
	wpnt.TopTexture = nil;
	
	return wpnt
end

function DialogList:Show()
	local height = 400;
	local y = 1880;
	self.background = CreateTexture(0, 8192-y, 8192, 8192, "CONSOLE.TGA");
	
	
	self.TopTexture = CreateTexture(400, 8192-y+150, 500, 8192-y+150+100, "O.TGA");
	self.BottomTexture = CreateTexture(400, 8192-y+150+((5-1)*200)+50, 500, 8192-y+150+((5-1)*200)+100+50, "U.TGA");
	
	ShowTexture(self.playerid, self.background);
	--ShowTexture(self.playerid, self.SelBackground);
	
	if(self.maxShow < #self.entrys)then
		ShowTexture(self.playerid, self.BottomTexture);
	end
	
	
	for var = 1, self.maxShow, 1 do
		
		local ySelBG = 1880-((var-1)*200);
		self.SelBackground[var] = CreateTexture(-2048, 8192-ySelBG, 12288, 8192-ySelBG+400, "PROGRESS.TGA");
	
		local str = "";
		if(self.entrys[var] ~= nil and self.entrys[var]["desc"] ~= nil)then
			str = self.entrys[var]["desc"];
		end
		if(var == self.position)then
			ShowTexture(self.playerid, self.SelBackground[var]);
			self.TextView[var] = CreateDraw(600,8192-y+150+((var-1)*200),str,"Font_Old_10_White_Hi.TGA",255,255,250);
		else
			self.TextView[var] = CreateDraw(600,8192-y+150+((var-1)*200),str,"Font_Old_10_White_Hi.TGA",255,255,0);
		end
		ShowDraw(self.playerid, self.TextView[var]);
	end
	
	
end

function DialogList:Hide()
	DestroyTexture(self.background);
	--DestroyTexture(self.SelBackground);
	
	DestroyTexture(self.TopTexture);
	DestroyTexture(self.BottomTexture);
	
	for var = 1, self.maxShow, 1 do
		DestroyDraw(self.TextView[var]);
		DestroyTexture(self.SelBackground[var]);
	end
end

function DialogList:GoDown()
	self.position = self.position +1;
	if(self.position > #self.entrys)then
		self.position = 1;
	end
	self:Update();
end

function DialogList:GoUp()
	self.position = self.position -1;
	if(self.position < 1)then
		self.position = #self.entrys;
	end
	self:Update();
end

function DialogList:Update()
	--DestroyTexture(self.SelBackground);
	
	if(self.position == #self.entrys)then
		HideTexture(self.playerid, self.BottomTexture);
	elseif(self.maxShow < #self.entrys)then
		ShowTexture(self.playerid, self.BottomTexture);
	end
	
	if(self.maxShow < self.position)then
		ShowTexture(self.playerid, self.TopTexture);
	else
		HideTexture(self.playerid, self.TopTexture);
	end
	
	local y = 1880;
	for var = 1, self.maxShow, 1 do
		local str = "";
		local pos = 1;
		if(self.position <= self.maxShow)then
			pos = 1;
		else
			pos = self.position - self.maxShow+1;
		end
		
		
		
		pos = pos - 1 + var;
		if(self.entrys[pos] ~= nil and self.entrys[pos]["desc"] ~= nil)then
			str = self.entrys[pos]["desc"];
		end
		
		
		if(pos == self.position)then
			UpdateDraw(self.TextView[var], 600,8192-y+150+((var-1)*200),str,"Font_Old_10_White_Hi.TGA",255,255,250);
			
			local height = 400;
			local ySelBG = 1880-((var-1)*200);
			--self.SelBackground = CreateTexture(-2048, 8192-ySelBG, 12288, 8192-ySelBG+height, "PROGRESS.TGA");
			ShowTexture(self.playerid, self.SelBackground[var]);
			
		else
			UpdateDraw(self.TextView[var], 600,8192-y+150+((var-1)*200),str,"Font_Old_10_White_Hi.TGA",255,255,0);
			HideTexture(self.playerid, self.SelBackground[var]);
		end
	end
end