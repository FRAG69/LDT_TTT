
// :O


hook.Add( "PhysgunPickup", "CanPickupPlayer_MB", function(ply,ent)
	GM = GM or GAMEMODE
	
	if (ent:IsPlayer() and GM:GetGlobalSHVar("PlayerPickup",false)) then
		if (GM:GetGlobalSHVar("PlayerPickupAdmin",false)) then return (ply:IsAdmin()) end
		return true
	end
end)



hook.Add("ShouldCollide","MawCollisions",function(ent1,ent2)
	GM = GM or GAMEMODE
	
	if (GM:GetGlobalSHVar("PlayerCollision",false) and ent1:IsPlayer() and ent2:IsPlayer()) then return false end
end)