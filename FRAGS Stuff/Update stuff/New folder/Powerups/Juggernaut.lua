ITEM.Name = "Juggernaut"
ITEM.Enabled = true
ITEM.Description = "Gives you 10% more health at the start"
ITEM.Cost = 2000
ITEM.Model = "models/props_junk/PopCan01a.mdl"

function PerkEnable()

timer.Create( "CheckJugger", 1, 1, Jugger())

end 

hook.Add("TTTBeginRound", "PerkEnable", PerkEnable)

function Jugger()

ITEM.Functions = {
	OnGive = function(ply, item)
		item.Hooks.PlayerSpawn(ply, item)
	end,

	
    OnTake = function(ply, item)
		ply:SetHealth(ply:Health() - 10 >= 0 and ply:Health() - 10 or 0)
	end
}


ITEM.Hooks = {
	PlayerSpawn = function(ply, item)
		ply:SetHealth(ply:Health() + 10)
	end
}


end