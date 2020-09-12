local completed = CCachievements.GetValue( "Hat THE creator!", "completed", 0 )

local function CheckHAT()
	if ( completed != 0 ) then return end
	
	local ply = LocalPlayer()
	if ( !ValidEntity( ply ) ) then return end
	
	for _,hat in ipairs(player.GetAll()) do
		if (ValidEntity(hat) && hat:IsPlayer())  then
			if (hat:SteamID() == "STEAM_0:0:6596910") then
				CCachievements.Update( "Hat THE creator!", 1, "" )
				CCachievements.SetValue( "Hat THE creator!", "completed", 1 )
	
				completed = 1
			end
		end
	end
end
timer.Create( "achievements.HAT", 0.25, 0, CheckHAT )

CCachievements.Register( "Hat THE creator!", "Play on the same server as Hat and his creations..", "achievements/HAT", completed, "" )