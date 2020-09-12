AddCSLuaFile("autorun/client/cl_hitdamagenumbers.lua")

util.AddNetworkString( "imHDN_create" )


local on = true
CreateConVar( "sv_hitnums_show", 1 )
cvars.AddChangeCallback( "sv_hitnums_show", function()
	on = (GetConVarNumber("sv_hitnums_show") ~= 0)
end )


local showAll = false
CreateConVar( "sv_hitnums_showalldamage", 0 )
cvars.AddChangeCallback( "sv_hitnums_showalldamage", function()
	showAll = (GetConVarNumber("sv_hitnums_showalldamage") ~= 0)
end )


local breakablesOnly = true
CreateConVar( "sv_hitnums_breakablesonly", 1 )
cvars.AddChangeCallback( "sv_hitnums_breakablesonly", function()
	breakablesOnly = (GetConVarNumber("sv_hitnums_breakablesonly") ~= 0)
end )


CreateConVar( "sv_hitnums_ignorez", 0 )
SetGlobalBool("HDN_IgnoreZ", false)
cvars.AddChangeCallback( "sv_hitnums_ignorez", function()
	SetGlobalBool("HDN_IgnoreZ", GetConVarNumber("sv_hitnums_showalldamage") ~= 0)
end )


function EntDamage(target, dmginfo)
	
	if not on then return end
	
	local attacker = dmginfo:GetAttacker()
	
	if target:IsValid() then
		
		if (showAll or attacker:IsPlayer()) and (!breakablesOnly or target:Health()>0)
			and target:GetCollisionGroup() ~= COLLISION_GROUP_DEBRIS then
		
			net.Start("imHDN_create")
				
				// Damage amount.
				net.WriteFloat(dmginfo:GetDamage())
				
				// Type of damage.
				net.WriteUInt(dmginfo:GetDamageType(), 32)
				
				// Is it a critical hit? (For players and npcs only)
				net.WriteBit( (dmginfo:GetDamage() >= target:GetMaxHealth())
							and (target:IsPlayer() or target:IsNPC()) )
				
				// Get damage position.
				local pos
				if dmginfo:IsBulletDamage() then
					pos = dmginfo:GetDamagePosition()
				else
					if target:IsPlayer() or target:IsNPC() then
						pos = target:GetPos() + Vector(0,0,48)
					else
						pos = target:GetPos()
					end
					
				end
				net.WriteVector(pos)
				
				// Get force of damage.
				local force
				if dmginfo:IsExplosionDamage() then
					force = dmginfo:GetDamageForce() / 4000
				else
					force = -dmginfo:GetDamageForce() / 1000
				end
				force.x = math.Clamp(force.x, -1, 1)
				force.y = math.Clamp(force.y, -1, 1)
				force.z = math.Clamp(force.z, -1, 1)
				net.WriteVector(force)
				
			if showAll then
				if target:IsPlayer() then
					net.SendOmit(target)
				else
					net.Broadcast()
				end
			else
				net.Send(attacker)
			end
			
		end
		
	end
	
end
hook.Add("EntityTakeDamage", "ihHDN_EntDamage", EntDamage)
