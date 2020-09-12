ITEM.Name = "Queensdayhat"
ITEM.Enabled = true
ITEM.Description = "Support and honour the Dutch by buying this hat"
ITEM.Cost = 7500
ITEM.Model = "models/ldtevnthat/evthat.mdl"
ITEM.Attachment = "eyes"

ITEM.Functions = {
	OnGive = function(ply, item)
		ply:PS_AddHat(item)
	end,
	
	OnTake = function(ply, item)
		ply:PS_RemoveHat(item)
	end,
	
	ModifyHat = function(ent, pos, ang)
		ent:SetModelScale(Vector(0.85, 0.85, 0.85))
		pos = pos + (ang:Up() * 2.7) + (ang:Forward()*-2)
		ang:RotateAroundAxis(ang:Up(), -90)
		return ent, pos, ang
	end,
}

ITEM.Hooks = {
	PlayerInitialSpawn = function(ply, item)
		ply:PS_AddHat(item)
	end
}