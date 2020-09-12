local Meta = FindMetaTable("Player")

function Meta:GetMoney()
	return self:GetSHVar("Money",0)
end