ITEM.Name = "Monsterclip"
ITEM.Enabled = true
ITEM.Description = "Gives you 20% more ammo in every clip"
ITEM.Cost = 500
ITEM.Model = "models/props_junk/PopCan01a.mdl"

//local function


ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ply, item)
		ply:GiveAmmo( 256,       "Pistol",               true )
        ply:GiveAmmo( 256,       "SMG1",                 true )
        ply:GiveAmmo( 5,         "grenade",              true )
        ply:GiveAmmo( 64,        "Buckshot",     true )
        ply:GiveAmmo( 32,        "357",                  true )
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:GiveAmmo( 256,       "Pistol",               true )
        ply:GiveAmmo( 256,       "SMG1",                 true )
        ply:GiveAmmo( 5,         "grenade",              true )
        ply:GiveAmmo( 64,        "Buckshot",     true )
        ply:GiveAmmo( 32,        "357",                  true )
	end
}


