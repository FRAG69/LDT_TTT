ITEM.Name = "Fragalicious"
ITEM.Enabled = true
ITEM.Description = "Makes you able to have two granades"
ITEM.Cost = 500
ITEM.Model = "models/props_junk/PopCan01a.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:Give( "weapon_zm_molotov" )
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:Give( "weapon_zm_molotov" )
	end
}