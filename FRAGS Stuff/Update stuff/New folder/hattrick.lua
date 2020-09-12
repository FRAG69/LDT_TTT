local hat = CCachievements.GetValue( "Hat trick", "total", 0 )

local function PlayerHAT()

	local ply = LocalPlayer()
	
	local HatNum = 0
	
	 if ply._Hats then
     local hat = table.Count(ply._Hats)
     end

	 if (HatNum < hat) then
	 hat = math.Clamp( hat, 0, 3 )
		CCachievements.Update( "Hat trick", "total", hat )
		CCachievements.SetValue( "Hat trick", hat / 3, hat .. "/3" )
	end
end
timer.Create( "Achievement.hattrick",2,0, PlayerHAT )
CCachievements.Register( "Hat trick", "Buy your third hat.", "achievements/hattrick", hat / 3, hat .. "/3" )