ITEM.Name = "Skull Head"
ITEM.Enabled = true
ITEM.Description = "Gives you a skull head."
ITEM.Cost = 700
ITEM.Model = "models/Gibs/HGIBS.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.7, 0.7, 0.7))
		pos = pos + (ang:Forward() * 2)
		ang:RotateAroundAxis(ang:Right(), 20)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}
