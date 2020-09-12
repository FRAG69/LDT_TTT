local Meta = FindMetaTable("Player")

function Meta:SetLevel(lvl,bIgnoreSH)
	self:SetStockTable("Level")[1] = lvl
	
	if (!BIgnoreSH) then self:AddNonTempSH("Level",lvl) end
end

function Meta:AddLevel(lvl,bIgnoreSH)
	self:SetLevel(self:GetLevel()+lvl,bIgnoreSH)
end

function Meta:UpdateLevel()
	self:AddNonTempSH("Level",self:SetStockTable("Level")[1] or 1)
end

function Meta:SetXP(xp)
	repeat
		local Need = self:GetNeedXP()
	
		if (xp >= Need) then 
			xp = xp-Need 
			self:AddLevel(1,true)
		end
	until xp < Need
	
	self:UpdateLevel()

	self:SetStockTable("XP")[1] = xp
	self:SetSHVar("XP",xp,self)
end

function Meta:AddXP(xp)
	self:SetXP(self:GetXP()+xp)
end