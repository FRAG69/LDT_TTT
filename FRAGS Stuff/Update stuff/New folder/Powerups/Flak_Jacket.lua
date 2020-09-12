ITEM.Name = "Flak Jacket"
ITEM.Enabled = true
ITEM.Description = "Reduces explosion damage."
ITEM.Cost = 1000
ITEM.Model = "models/props_junk/PopCan01a.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:SetArmor(ply:Armor() - 100 >= 0 and ply:Armor() - 100 or 0)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:SetArmor(ply:Armor() + 100)
	end
}