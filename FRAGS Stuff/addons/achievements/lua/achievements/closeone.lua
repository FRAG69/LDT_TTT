local achieved = CCachievements.GetValue( "Close 1", "achieved", 0 )

if ( achieved == 0 ) then
	local lastHealth
	local function Check()
		local health = math.max( LocalPlayer():Health(), 0 )
		if ( health == 1 && ( lastHealth or 0 ) >= 51 ) then
			CCachievements.Update( "Close 1", 1, "" )
			CCachievements.SetValue( "Close 1", "achieved", 1 )
			timer.Destroy( "achievements.Close1" )
		end
		lastHealth = health
	end
	timer.Create( "achievements.Close1", 1, 0, Check )
end

CCachievements.Register( "Close 1", "Take 50 or more damage and be left with 1 health.", "achievements/close1", achieved, "" )