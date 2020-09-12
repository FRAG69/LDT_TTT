--BY KAZAKI--

AddCSLuaFile("autorun/client/cl_ttt_cicons.lua") 

hook.Add("EntityTakeDamage", "KazakisHook", function( ent, inflictor, attacker, amount )
 
	if ent:IsPlayer() and ( attacker:GetClass() == "npc_turret_floor" ) then
		if ent:Health() > 10 then
			local dmghp = ent:Health() - 10
			ent:SetHealth(dmghp)
		end
	end
 
end )



hook.Add( "PlayerDeath", "playerDeathTest", function( victim, weapon, killer )

	for _, v in pairs(ents.FindByClass("npc_turret_floor")) do
		v:AddEntityRelationship(victim, D_LI, 99 )
	end
	
end )


hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", function( ply )
 
		for _, v in pairs(ents.FindByClass("npc_turret_floor")) do
			v:AddEntityRelationship(ply, D_LI, 99 )
		end
 
end )

hook.Add( "TTTEndRound", "TTT_turret_server_endround", function()
		
		for _, p in pairs(player.GetAll()) do
			p:StripWeapon("weapon_ttt_turret")
		end
		for _, v in pairs(ents.FindByClass("npc_turret_floor")) do
			v:Remove()
		end

end )

hook.Add( "OnNPCKilled", "trolasdfdf", function( victim, killer, weapon ) 
	
	if victim:GetClass() == "npc_turret_floor" then
		victim:StopSound( "npc/turret_floor/alarm.wav" )
	end

end )