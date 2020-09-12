category.name = "Perks"
category.position = 4

GF.CATEGORY_PERKS = 4

function GF:GetPerk(unique)
	for _, data in pairs(GF.categories[GF.CATEGORY_PERKS].items) do
		if (data.unique == unique) then
			return data
		end
	end
end

function GF:Getperks()
	return GF.categories[GF.CATEGORY_PERKS].items
end