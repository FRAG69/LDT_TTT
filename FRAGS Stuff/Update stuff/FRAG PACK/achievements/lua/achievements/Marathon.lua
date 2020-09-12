
local totalLength = CCachievements.GetValue( "Marathon", "total", 0 )
local length = 823680000 // One mile.
if ( totalLength != length ) then
	local lastPos
	local function Update()
		local ply = LocalPlayer()
		if ( !ValidEntity( ply ) ) then return end
		if ( !ply:IsOnGround() ) then return end
		
		local pos = ply:GetPos()
		totalLength = math.min( totalLength + ( pos - ( lastPos or pos ) ):Length(), length )
		lastPos = pos
		
		local show = math.floor( totalLength )
		CCachievements.Update( "Marathon", show / length, show .. "/" .. length )
		CCachievements.SetValue( "Marathon", "total", show )
		
		if ( totalLength == length ) then
			timer.Destroy( "achievements.Marathon" )
		end
	end
	timer.Create( "achievements.Marathon", 0.1, 0, Update )
end

CCachievements.Register("Marathon", "Walk 26 miles.", "achievements/Marathon",totalLength / length, totalLength .. "/" .. length)