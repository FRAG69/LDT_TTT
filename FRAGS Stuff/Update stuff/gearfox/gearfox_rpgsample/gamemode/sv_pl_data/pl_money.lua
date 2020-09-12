local Meta = FindMetaTable("Player")

function Meta:SetMoney(mon)
	self:SetStockTable("Money")[1] = mon
	self:SetSHVar("Money",mon,self)
end

function Meta:AddMoney(mon)
	self:SetMoney(self:GetMoney()+mon)
end