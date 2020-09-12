ITEM.Name = "Third Person"
ITEM.Enabled = true
ITEM.Description = "Gives you the ability to use the third person command."
ITEM.Cost = 1000
ITEM.Model = "models/props_combine/health_charger001.mdl"

ITEM.Functions = {
	OnGive = function(ply, item)
		
	end,
	
	OnTake = function(ply, item)
		ply:SetProperty( "ThirdPersonView", false )
		evolve:Notify(ply, evolve.colors.blue, "Sold thirdperson." )
		ply:SendLua( "LocalPlayer().EV_ThirdPerson = false" )
	end
}

ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		
	end
}