local maxDistance = CCachievements.GetValue( "AAAAH!", "total", 0 )

local falling, z
local function OnGround( ply )
	local trace = util.QuickTrace( ply:GetPos(), Vector( 0, 0, -70 ), ply )
	return trace.Hit || ply:IsOnGround()
end
local function Update()
	local ply = LocalPlayer()
	if ( !ValidEntity( ply ) ) then return end
	
	local ground = OnGround( ply ) || ( ply:GetMoveType() != MOVETYPE_WALK )
	local pos = ply:GetPos()
	if ( !z || ( ground && !falling ) ) then
		z = pos.z
	end
	if ( !ground && !falling ) then
		falling = true
	elseif ( ground && falling ) then
		falling = false
		local distance = math.min( math.floor( ( z - pos.z ) / 12 ), 1000 )
		if ( distance > maxDistance ) then
			maxDistance = distance
			CCachievements.Update( "AAAAH!", maxDistance / 1000, maxDistance .. "/1000" )
			CCachievements.SetValue( "AAAAH!", "total", maxDistance )
			
			if ( maxDistance == 1000 ) then
				timer.Destroy( "achievements.AAAAH!" )
			end
		end
	end
end
if ( maxDistance != 1000 ) then
	timer.Create( "achievements.AAAAH!", 0.5, 0, Update )
end

CCachievements.Register( "AAAAH!", "Fall 1000 feet.", "achievements/aaaah", maxDistance / 1000, maxDistance .. "/1000" )