AddCSLuaFile( "autorun/client/cl_sprayidentifier.lua" )

local Player = FindMetaTable("Player");

SpawnsTillSprayReset = 2;

function Player:GetSprayLocation()
	local spraypos = self:GetEyeTrace().HitPos;
	
	return spraypos;
end

hook.Add("PlayerInitialSpawn", "SPRAY_Player Initial Spawn", function(ply)
	ply.SpawnsGoneTillSprayReset = 0;
end);

hook.Add("PlayerSpawn", "SPRAY_Player Spawn", function(ply)
	if(ply.SpawnsGoneTillSprayReset < SpawnsTillSprayReset) then
		ply.SpawnsGoneTillSprayReset = ply.SpawnsGoneTillSprayReset + 1;
	end
	if(ply.SpawnsGoneTillSprayReset >= SpawnsTillSprayReset) then
		ply.SpawnsGoneTillSprayReset = 0;
		ply:SetNetworkedVector("spray_pos", Vector(0, 0, 0));
	end
end);

hook.Add("PlayerSpray", "SPRAY_Player Spray", function(ply)
	ply:SetNetworkedVector("spray_pos", ply:GetSprayLocation());
end);

