category.name = "Trails"
category.position = 2

GF.CATEGORY_TRAILS = 2

function GF:GetTrail(unique)
	for _, data in pairs(GF.categories[GF.CATEGORY_TRAILS].items) do
		if (data.unique == unique) then
			return data
		end
	end
end

function GF:GetTrails()
	return GF.categories[GF.CATEGORY_TRAILS].items
end