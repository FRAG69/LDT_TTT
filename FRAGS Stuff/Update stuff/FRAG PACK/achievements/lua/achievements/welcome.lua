
local completed = CCachievements.GetValue( "Welcome to the REAL TTT", "total", 0 ) == 1
local desc = { [ true ] = { 1, "01:00:00" }, [ false ] = { 0, "00:00:00" } }

/*
if ( !SinglePlayer() ) then
	desc[ false ] = { 0, "Not in SP" }
end
*/
--if ( !completed && SinglePlayer() ) then
local ply = LocalPlayer()

if evolve:GetProperty( ply:UniqueID(), "PlayTime", 0) then
	local startTime = CurTime()
	local function Update()
		local time = CurTime() - startTime		
		CCachievements.Update( "Welcome to the REAL TTT", time / 3600, CCachievements.FormatTime( time, "h:m:s" ) )
		
		if ( time >= 3600 ) then
			CCachievements.SetValue( "Welcome to the REAL TTT", "total", 1 )
			timer.Destroy( "achievements.Welcome" )
		end
	end
	timer.Create( "achievements.Welcome", 1, 0, Update )
end

CCachievements.Register("Welcome to the REAL TTT", "Play 1 hour on TTT.", "achievements/welcome",desc[ completed ][ 1 ], desc[ completed ][ 2 ])