
local completed = CCachievements.GetValue( "Addicted", "total", 0 ) == 1
local desc = { [ true ] = { 1, "01:00:00" }, [ false ] = { 0, "00:00:00" } }

local ply = LocalPlayer()

if evolve:GetProperty( ply:UniqueID(), "PlayTime", 0) then
	local startTime = CurTime()
	local function Update()
		local time = CurTime() - startTime		
		CCachievements.Update( "Addicted", time / 2592000, CCachievements.FormatTime( time, "h:m:s" ) )
		
		if ( time >= 2592000) then
			CCachievements.SetValue( "Addicted", "total", 1 )
			timer.Destroy( "achievements.Addicted" )
		end
	end
	timer.Create( "achievements.Addicted", 1, 0, Update )
end

CCachievements.Register("Addicted", "Play one month on LDT TTT.", "achievements/addicted",desc[ completed ][ 1 ], desc[ completed ][ 2 ])