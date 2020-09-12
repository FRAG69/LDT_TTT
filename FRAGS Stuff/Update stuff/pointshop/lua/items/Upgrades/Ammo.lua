ITEM.Name = "+50 Ammo"
ITEM.Enabled = true
ITEM.Description = "Gives you +50 ammo."
ITEM.Cost = 900
ITEM.Model = "models/props_combine/health_charger001.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		
	end,
	
	OnTake = function(ply, item)

	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		
	end
}