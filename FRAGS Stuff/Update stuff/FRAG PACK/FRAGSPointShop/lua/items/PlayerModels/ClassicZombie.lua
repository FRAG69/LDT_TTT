ITEM.Name = "Classic Zombie"
ITEM.Enabled = true
ITEM.Description = "PlayerModel"
ITEM.Cost = 200
ITEM.Model = "models/player/classic.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
	end,
	
	OnTake = function(ply, item)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		if not ply._OldModel then
			ply._OldModel = ply:GetModel()
		end
		timer.Simple(0.1, function() ply:SetModel(item.Model) end)
	end
}