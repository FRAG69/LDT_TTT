ITEM.Name = "100 Health Bonus"
ITEM.Enabled = true
ITEM.Description = "Adds 100 health."
ITEM.Cost = 1500
ITEM.Model = "models/props_combine/health_charger001.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		if ply:Health() > 100 then
			ply:SetHealth(ply:Health() - 100)
			ply:SetMaxHealth( 100, true )
		end
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:SetHealth(ply:Health() + 100)
		ply:SetMaxHealth( 200, true )
	end
}