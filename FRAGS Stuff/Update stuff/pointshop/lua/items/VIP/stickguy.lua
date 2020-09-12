ITEM.Name = "Model - Stickguy"
ITEM.Enabled = true
ITEM.VIPOnly = true
ITEM.Description = "Spawn as the Stickguy model."
ITEM.Cost = 10000
ITEM.Model = "models/Conex/stickguy/stickguy.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		if ply._OldModel then
			ply:SetModel(ply._OldModel)
		end
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if not ply._OldModel then
			ply._OldModel = ply:GetModel()
		end
		if ply:EV_IsVIPOrHigher() then
			timer.Simple(1, function() ply:SetModel(item.Model) end)
		end
	end
}