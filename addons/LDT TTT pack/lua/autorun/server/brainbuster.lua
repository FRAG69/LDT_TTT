--BY KAZAKI--

AddCSLuaFile("autorun/client/cl_ttt_cicons.lua") 

hook.Add("PlayerShouldTakeDamage", "BrainBusterFlame", function( victim , att)	if att:IsPlayer() and ( att:GetClass() == "weapon_ttt_godeagle" ) then		victim:Ignite(1,0)	end
 
end )