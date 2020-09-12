local Meta = FindMetaTable("Player")

function Meta:GetLevel()
	return self:GetSHVar("Level",1)
end

function Meta:GetXP()
	return self:GetSHVar("XP",0)
end

function Meta:GetNeedXP()
	return math.ceil(200+55*1.3^self:GetLevel())
end