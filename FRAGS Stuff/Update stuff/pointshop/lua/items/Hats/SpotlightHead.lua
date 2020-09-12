ITEM.Name = "Spotlight Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a spotlight head."
ITEM.Cost = 300
ITEM.Model = "models/props_wasteland/light_spotlight01_lamp.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}