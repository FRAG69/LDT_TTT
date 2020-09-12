local Value = CCachievements.GetValue( "Wannabe EarthwormEd", "total", 0 )

local function Update()

	if (Value != 3600) then
		// print("Check Started.\n")
		local ply = LocalPlayer()

		if (!ValidEntity( ply )) then return end
		
		if ( (ply:WaterLevel() == 3) && (!ply:IsOnGround()) && (ply:GetMoveType() == MOVETYPE_WALK) && (!ply:InVehicle()) ) then
			// print("Player Inside Water.\n")
			Value = math.Clamp( Value + 1, 0, 3600 )
			CCachievements.SetValue( "Wannabe EarthwormEd", "total", Value )
			CCachievements.Update( "Wannabe EarthwormEd", Value / 3600, string.FormattedTime( Value, "%02i:%02i" ) )
			// achievements.Update( "Master Swimmer", Value / 300, Value .. "/300" )
		else
			// print("Player Outside Water.\n")
		end

		// print("Check Ended.\n")
	
	else
		timer.Destroy("Achievement.MasterSwimmer")
	end

end

timer.Create("Achievement.MasterSwimmer", 1, 0, Update)

CCachievements.Register( "Wannabe EarthwormEd", "Swim for one hour.", "achievements/masterswimmer", Value / 3600, string.FormattedTime( Value, "%02i:%02i" ) )