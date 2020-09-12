local completed = CCachievements.GetValue( "Yes, I am the real FRAG!", "completed", 0 )

local function CheckFRAG()
	if ( completed != 0 ) then return end
	
	local ply = LocalPlayer()
	if ( !ValidEntity( ply ) ) then return end
	
	for _,frag in ipairs(player.GetAll()) do
		if (ValidEntity(frag) && frag:IsPlayer())  then
			if (frag:SteamID() == "STEAM_0:0:9884005") then
				CCachievements.Update( "Yes, I am the real FRAG!", 1, "" )
				CCachievements.SetValue( "Yes, I am the real FRAG!", "completed", 1 )
	
				completed = 1
			end
		end
	end
end
timer.Create( "achievements.FRAG", 0.25, 0, CheckFRAG )

CCachievements.Register( "Yes, I am the real FRAG!", "Play on the same server as FRAG and his creations.", "achievements/FRAG", completed, "" )
