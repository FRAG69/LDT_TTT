ITEM.Name = "MEGA Turtle Hat"
ITEM.Enabled = true
ITEM.Donator = true
ITEM.Description = "On the bottom it says the word EPIC, written in GOLD."
ITEM.Cost = 100000
ITEM.Model = "models/props/de_tides/Vending_turtle.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(3, 3, 3))
		pos = pos + (ang:Forward() * -3)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}