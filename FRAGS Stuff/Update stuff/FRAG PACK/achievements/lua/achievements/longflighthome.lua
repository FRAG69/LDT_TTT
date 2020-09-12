
local maxDistance = CCachievements.GetValue( "What does the Steyr Scout say about his distance?", "total", 0 )
local function PlayerKilledByPlayer( msg )
	local victim = msg:ReadEntity()
	local weapon = msg:ReadString()
	local ply = msg:ReadEntity()
	
	if ( ply == LocalPlayer() ) then
		if ( weapon == "weapon_zm_rifle" ) then
			local distance = math.floor( math.min( ( victim:GetPos() - ply:GetPos() ):Length() / 39.37, 90 ) )
			if ( distance > maxDistance ) then
				maxDistance = distance
				CCachievements.Update( "What does the Steyr Scout say about his distance?", maxDistance / 9000, maxDistance .. "/9000" )
				CCachievements.SetValue( "What does the Steyr Scout say about his distance?", "total", maxDistance )
			end
		end
	end
	
	return victim, weapon, ply
end
usermessage.AddHook( "PlayerKilledByPlayer", "achievements.longflighthome", PlayerKilledByPlayer )

CCachievements.Register( "What does the Steyr Scout say about his distance?", "... ITS OVER 9000 CM !!!", "achievements/longflighthome", maxDistance / 9000, maxDistance .. "/9000" )
