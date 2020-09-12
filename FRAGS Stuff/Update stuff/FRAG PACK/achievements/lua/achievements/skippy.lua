// Achievement by G3X / GeXeH - Enjoy
// Version 1.0

// Achievement: Jump 1000 times total.

local Value = CCachievements.GetValue( "Skippy", "total", 0 )

local function Update(ply, bind, pressed)

	if (Value != 1000) then
		// print("Check Started.\n")
		local ply = LocalPlayer()

		if (!ValidEntity( ply )) then return end
		
		if ply:IsOnGround() then
		if ( (bind == "+jump") ) then
				// print("Player Jumped.\n")
				Value = math.Clamp( Value + 1, 0, 1000 )
				CCachievements.Update( "Skippy", Value / 1000, Value .. "/1000" )
				CCachievements.SetValue( "Skippy", "total", Value )
		else
			// print("Player Jump Ended.\n")
		end

		// print("Check Ended.\n")
		end
	end

end

hook.Add("PlayerBindPress", "Achievement.Skippy", Update)

CCachievements.Register( "Skippy", "Jump 1000 times total.", "achievements/skippy", Value / 1000, Value .. "/1000" )