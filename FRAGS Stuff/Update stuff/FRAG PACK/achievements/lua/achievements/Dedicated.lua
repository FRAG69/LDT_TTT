
local completed = CCachievements.GetValue( "Dedicated", "total", 0 ) == 1
local desc = { [ true ] = { 1, "01:00:00" }, [ false ] = { 0, "00:00:00" } }

local ply = LocalPlayer()

if evolve:GetProperty( ply:UniqueID(), "PlayTime", 0) then
	local startTime = CurTime()
	local function Update()
		local time = CurTime() - startTime		
		CCachievements.Update( "Dedicated", time / 86400, CCachievements.FormatTime( time, "h:m:s" ) )
		
		if ( time >= 86400 ) then
			CCachievements.SetValue( "Dedicated", "total", 1 )
			timer.Destroy( "achievements.Dedicated" )
		end
	end
	timer.Create( "achievements.Dedicated", 1, 0, Update )
end

CCachievements.Register("Dedicated", "Play one day on LDT TTT.", "achievements/dedicated",desc[ completed ][ 1 ], desc[ completed ][ 2 ])