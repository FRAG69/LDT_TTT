include( "shared.lua" )





function GM:Initialize()
end

function GM:PlayerInitialSpawn(pl)
end

function GM:Think()
end





function GM:PlayerSpawn(pl)
	hook.Call( "PlayerSetModel" , self , pl )
	self:PlayerLoadout(pl)
end

function GM:PlayerLoadout( ply )
	ply:Give("weapon_physcannon")
	ply:Give("weapon_physgun")
	ply:SelectWeapon("weapon_physgun")
	
	for k,v in pairs(ply:GetWeapons()) do
		v:DrawShadow(false)
	end
 
	return true
end






