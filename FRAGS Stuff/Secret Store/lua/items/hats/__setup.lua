category.name = "Hats"
category.position = 1

GF.CATEGORY_HATS = 1

function GF:GetHat(unique)
	for _, data in pairs(GF.categories[GF.CATEGORY_HATS].items) do
		if (data.unique == unique) then
			return data
		end
	end
end

function GF:GetHats()
	return GF.categories[GF.CATEGORY_HATS].items
end