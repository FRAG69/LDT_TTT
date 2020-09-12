ITEM.Name = "Money"
ITEM.Enabled = true
ITEM.Description = "Be made of money!"
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
		ply:SetMaterial("models/props/cs_assault/dollar")
	end
}
