
local completed = CCachievements.GetValue( "Expert", "total", 0 ) == 1
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
		CCachievements.Update( "Expert", time / 604800, CCachievements.FormatTime( time, "h:m:s" ) )
		
		if ( time >= 604800 ) then
			CCachievements.SetValue( "Expert", "total", 1 )
			timer.Destroy( "achievements.Expert" )
		end
	end
	timer.Create( "achievements.Expert", 1, 0, Update )
end

CCachievements.Register("Expert", "Play one week on LDT TTT.", "achievements/expert",desc[ completed ][ 1 ], desc[ completed ][ 2 ])