POINTSHOP = {}

function POINTSHOP.FindItemByID(item_id)
	for id, category in pairs(POINTSHOP.Items) do
		if category.Enabled then
			for name, item in pairs(category.Items) do
				if item.Enabled then
					if name == item_id then
						return item
					end
				end
			end
		end
	end
	
	return false
end

function POINTSHOP.FindCategoryByItemID(item_id)
	for id, category in pairs(POINTSHOP.Items) do
		for name, item in pairs(category.Items) do
			if name == item_id then
				return category
			end
		end
	end
	
	return false
end

function POINTSHOP.ValidateItems(items)
	for k, item_id in pairs(items) do
		if not POINTSHOP.FindItemByID(item_id) then
			table.remove(items, k)
		end
	end
	return items
end//test linefunction POINTSHOP.FindAchByID(Ach_id)	for id, category in pairs(POINTSHOP.Ach) do		if category.Enabled then			for name, Ach in pairs(category.Ach) do				if Ach.Enabled then					if name == Ach_id then						return Ach					end				end			end		end	end		return falseendfunction POINTSHOP.FindCategoryByAchID(Ach_id)	for id, category in pairs(POINTSHOP.Ach) do		for name, Ach in pairs(category.Ach) do			if name == Ach_id then				return category			end		end	end		return falseendfunction POINTSHOP.ValidateAch(Ach)	for k, Ach_id in pairs(Ach) do		if not POINTSHOP.FindAchByID(Ach_id) then			table.remove(Ach, k)		end	end	return Achend
//end test line
function POINTSHOP.FindPlayerByName(name)
	local found = {}
	
	for _, ply in pairs(player.GetAll()) do
		if string.find(string.lower(ply:Nick()), string.lower(name)) then
			table.insert(found, ply)
		end
	end
	
	if #found < 1 then
		return false
	elseif #found > 1 then
		return true
	else
		return found[1]
	end
end