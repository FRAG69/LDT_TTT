ITEM.Name = "Skin - Mosaic"
ITEM.Enabled = true
ITEM.VIPOnly = true
ITEM.Description = "Be a mosaic!"
ITEM.Cost = 600
ITEM.Model = "models/weapons/w_toolgun.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:SetMaterial("")
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:SetMaterial("models/shadertest/shader5")
	end
}