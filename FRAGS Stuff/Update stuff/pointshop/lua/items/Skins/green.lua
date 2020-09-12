ITEM.Name = "Green"
ITEM.Enabled = true
ITEM.Description = "Be the color green!"
ITEM.Cost = 1100
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:SetColor(255, 255, 255, 255)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:SetColor(0, 255, 0, 255)
	end
}
