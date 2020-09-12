--BY KAZAKI--

AddCSLuaFile("autorun/client/cl_ttt_cicons.lua") 

hook.Add("PlayerShouldTakeDamage", "BrainBusterFlame", function( victim , attacker  )
 
	if attacker:IsPlayer() and attacker:GetActiveWeapon() then
		if attacker:GetActiveWeapon():GetClass() == "weapon_ttt_godeagle" then
			victim:Ignite(1,0)
		end
	end
 
end )