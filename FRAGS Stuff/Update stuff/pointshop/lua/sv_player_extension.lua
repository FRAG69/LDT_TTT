local Player = FindMetaTable("Player")

function Player:PS_SetPoints(num)
	self:SetPData("PointShop_Points", num)
	self:PS_UpdatePoints()
end

function Player:PS_GetPoints(num)
	return tonumber(self:GetPData("PointShop_Points")) or 0
end

function Player:PS_GivePoints(num, reason)
	local p = tonumber(self:GetPData("PointShop_Points")) or 0
	self:PS_SetPoints(p + num)
	
	if reason then reason = " (" .. reason .. ")" else reason = "" end
	self:PS_Notify('+' .. num .. ' dollars!' .. reason)
	
	return p + num
end

function Player:PS_TakePoints(num, reason)
	local p = tonumber(self:GetPData("PointShop_Points")) or 0
	if p - num < 0 then num = 0 end
	self:PS_SetPoints(p - num)
	
	if reason then reason = " (" .. reason .. ")" else reason = "" end
	self:PS_Notify('-' .. num .. ' dollars!' .. reason)
	
	return p - num
end

function Player:PS_GivePointsSilent(num)
	local p = tonumber(self:GetPData("PointShop_Points")) or 0
	self:PS_SetPoints(p + num)
	
	return p + num
end

function Player:PS_TakePointsSilent(num)
	local p = tonumber(self:GetPData("PointShop_Points")) or 0
	if p - num < 0 then num = 0 end
	self:PS_SetPoints(p - num)
	
	return p - num
end

function Player:PS_UpdatePoints()
	self.PS_Points = 0
	umsg.Start("PointShop_Points", self)
		umsg.Long(self:PS_GetPoints())
	umsg.End()
end

function Player:PS_CanAfford(item_id)
	if not item_id then return false end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	return self:PS_GetPoints() - item.Cost >= 0
end

function Player:PS_GiveItem(item_id, buy)
	if not self:PS_HasItem(item_id) then
		table.insert(self.PS_Items, item_id)
		
		self:PS_UpdateItems()
		
		local item = POINTSHOP.FindItemByID(item_id)
		
		if not item then return end
		
		if item.Functions and item.Functions.OnGive then
			item.Functions.OnGive(self, item)
		end
		
		if buy then
			self:PS_TakePoints(item.Cost, "bought " .. item.Name)
			self:PS_ShowShop(false)
			timer.Simple(0.1, function() self:PS_ShowShop(true) end)
		end
		
		return true
	end
	
	return false
end

function Player:PS_TakeItem(item_id, sell)
	if self:PS_HasItem(item_id) then
		for id, name in pairs(self.PS_Items) do
			if name == item_id then
				table.remove(self.PS_Items, id)
			end
		end
		
		self:PS_UpdateItems()
		
		local item = POINTSHOP.FindItemByID(item_id)
		
		if not item then return end
		
		if item.Functions and item.Functions.OnTake then
			item.Functions.OnTake(self, item)
		end
		
		if sell then
			self:PS_GivePoints(POINTSHOP.Config.SellCost(item.Cost), "sold " .. item.Name)
			self:PS_ShowShop(false)
			timer.Simple(0.1, function() self:PS_ShowShop(true) end)
		end
		
		return true
	end
	
	return false
end

function Player:PS_HasItem(item_id)
	return table.HasValue(self.PS_Items, item_id)
end

function Player:PS_HasItemEquipped(item_id)
	return self.PS_Items[item_id] and self.PS_Items[item_id].Equipped
end

function Player:PS_NumItemsFromCategory(category)
	local num = 0
	for item_id, item in pairs(category.Items) do
		if table.HasValue(self.PS_Items, item_id) then
			num = num + 1
		end
	end
	return num
end

function Player:PS_UpdateItems()
	self:SetPData("PointShop_Items", glon.encode(self.PS_Items))
	datastream.StreamToClients(self, "PointShop_Items", self.PS_Items)
end

function Player:PS_LoadItems()
	self.PS_Items = {}
	self.PS_Items = POINTSHOP.ValidateItems(glon.decode(self:GetPData("PointShop_Items", {})) or {})
	self:PS_UpdateItems()
end

function Player:PS_ShowShop(bool, npc_id)	
	umsg.Start("PointShop_Menu", self)
		umsg.Bool(bool)
		umsg.Long(npc_id or 0)
	umsg.End()
end

function Player:PS_Notify(text)
	umsg.Start("PointShop_Notify", self)
		umsg.String(text)
	umsg.End()
end

function PS_Broadcast(text)
	umsg.Start("PointShop_Broadcast")
		umsg.String(text)
	umsg.End()
end

function Player:PS_AddHat(item)
	if not POINTSHOP.Hats[self] then POINTSHOP.Hats[self] = {} end
	POINTSHOP.Hats[self][item.ID] = item.ID
	
	SendUserMessage("PointShop_AddHat", player.GetAll(), self:EntIndex(), item.ID)
end

function Player:PS_RemoveHat(item)
	if not POINTSHOP.Hats[self] then return end
	POINTSHOP.Hats[self][item.ID] = nil
	
	SendUserMessage("PointShop_RemoveHat", player.GetAll(), self:EntIndex(), item.ID)
end

function Player:PS_SendHats()
	for ply, hats in pairs(POINTSHOP.Hats) do
		for _, item_id in pairs(hats) do
			SendUserMessage("PointShop_AddHat", self, ply:EntIndex(), item_id)
		end
	end
end

/*function Player:PS_AddSkin(item)
	if not POINTSHOP.Skins[self] then POINTSHOP.Skins[self] = {} end
	POINTSHOP.Skins[self][item.ID] = item.ID
	
	SendUserMessage("PointShop_AddSkin", player.GetAll(), self:EntIndex(), item.ID)
end

function Player:PS_RemoveSkin(item)
	if not POINTSHOP.Skins[self] then return end
	POINTSHOP.Skins[self][item.ID] = nil
	
	SendUserMessage("PointShop_RemoveSkin", player.GetAll(), self:EntIndex(), item.ID)
end

function Player:PS_SendSkin()
	for ply, skins in pairs(POINTSHOP.Skins) do
		for _, item_id in pairs(skins) do
			SendUserMessage("PointShop_AddSkin", self, ply:EntIndex(), item_id)
		end
	end
end*/