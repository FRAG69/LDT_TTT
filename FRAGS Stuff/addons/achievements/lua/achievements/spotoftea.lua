local total = CCachievements.GetValue( "Spot Of Tea?", "total", 0 )
local done = {}
local function Update(ply, bind, pressed)
	if ( bind != "+duck" ) then return end
	
	local ply = ply:Alive()
	if ( !ValidEntity( ply ) ) then return end
		
	if ( ( total != 100 ) && !ply:Crouching() ) then
		for _, e in pairs( ents.FindInSphere( ply:GetPos(), 15 ) ) do
			local class = e:GetClass()
			if ( !done[ e ] && ( class == "prop_ragdoll" || class == "class C_ClientRagdoll" ) ) then
				total = math.Clamp( total + 1, 0, 100 )
				CCachievements.Update( "Spot Of Tea?", total / 100, total .. "/100" )
				CCachievements.SetValue( "Spot Of Tea?", "total", total )
				
				done[ e ] = true
				break
			end
		end
	end
end
hook.Add( "PlayerBindPress", "Achievement.SpotOfTea", Update )

CCachievements.Register( "Spot Of Tea?", "Teabag 100 people", "achievements/strongknees", total / 100, total .. "/100" )