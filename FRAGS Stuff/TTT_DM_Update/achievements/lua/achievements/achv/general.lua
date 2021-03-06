local category = achievements.CreateCategory("General")
category.Icon = "icon16/world.png"
category.DisplayOrder = 1

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Say 5000 messages in chat."
    ACH.Icon = "gui/achievements/talker.png"
	ACH.Target = 5000
	
	function ACH:Initialize()
		hook.Add( "PlayerSay", "AchTalker", function(ply)
			self:AddPoint( ply )
		end )
	end

    achievements.Register( category, "shutup", "Shut Up!", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Play for 7 days (10080 minutes)"
    ACH.Icon = "gui/achievements/time.png"
	ACH.Target = 10080

	function ACH:Initialize()
		timer.Create( "AchAddict", 60, 0, function()
			for _, ply in pairs( player.GetAll() ) do self:AddPoint( ply ) end
		end )
	end

    achievements.Register( category, "timewaster", "Time Waster", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Fall 10000 feet in total."
    ACH.Icon = "gui/achievements/falling.png"
	ACH.Target = 10000
	
	function ACH:Initialize()
		timer.Create( "AchAaaahCheck", 0.5, 0, function()
			for _, ply in pairs( player.GetAll() ) do
				if not IsValid(ply) then continue end
				
				local ground = ply:IsOnGround()
				local pos = ply:GetPos()
				
				if ( not ply.StartZ or pos.z > ply.StartZ or ( ground and not ply.Falling ) ) then
					ply.StartZ = pos.z
				end
				
				if ( not ground and not ply.Falling ) then
					ply.Falling = true
				elseif ( ground && ply.Falling ) then
					ply.Falling = false
					local distance = math.max( 0, math.floor( ( ply.StartZ - pos.z ) / 12 ) )
					
					if ( distance > 5 ) then -- let's not reward jumping now.
						self:AddPoint( ply, distance )
					end
				end
			end
		end )
	end

    achievements.Register( category, "aaaah", "AAAAH!", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Walk 500 miles! (264000 feet)"
    ACH.Icon = "gui/achievements/proclaimers.png"
	ACH.Target = 2640000

	function ACH:Initialize()
		local PlysLastPlace = {}

		hook.Add("Think", "AchiLongWalk", function()
			for _, ply in pairs(player.GetAll()) do
				if not ply:Alive() then continue end

				local CurPos = ply:GetPos()
				ply.LastPlace = ply.LastPlace or CurPos
				
				local Distance = ply.LastPlace:Distance( CurPos )
				if Distance > 0 and Distance < 150 then
						self:AddPoint( ply, Distance / 16 )
				end
				
				ply.LastPlace = CurPos
			end
		end )
	end

    achievements.Register( category, "proclaimers", "The Proclaimers", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Jump 10,000 times."
    ACH.Icon = "gui/achievements/jumping.png"
	ACH.Target = 10000

	function ACH:Initialize()
		hook.Add( "KeyPress", "CheckJumpAchivement", function( ply, key )
			if key == IN_JUMP and ply:OnGround() and ply:Alive() and (not ply.NextJump or CurTime() > ply.NextJump) then
				ply.NextJump = CurTime() + 0.5
				self:AddPoint( ply, 1 )
			end
		end )
	end

    achievements.Register( category, "jumping", "Jumping Jack Rabbit", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Hold 100,000 points at once."
    ACH.Icon = "gui/achievements/pspoints.png"
	ACH.Target = 100000

	function ACH:Initialize()
		hook.Add("Tick", "AchvPoints", function()
			if not PS then return end
			for _, ply in pairs( player.GetAll() ) do
				if self:GetPoints(ply) < tonumber(ply:PS_GetPoints()) then
					self:SetPoint( ply, tonumber(ply:PS_GetPoints()) )
				end
			end
		end)
	end

    achievements.Register( category, "pspoints", "Pointshop Money Bags", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_PROGRESS
    ACH.Description = "Spend 6 hours underwater."
    ACH.Icon = "gui/achievements/aquatic.png"
	ACH.Target = 60*60*6

	function ACH:Initialize()
		timer.Create( "AchSemiaquatic", 60, 0, function()
			for _, ply in pairs( player.GetAll() ) do
				if ply:WaterLevel() ~= 3 then continue end
				self:AddPoint( ply )
			end
		end )
	end

    achievements.Register( category, "semiaquatic", "Semiaquatic", ACH )
end

do
    local ACH = {}
    ACH.Type = ACHIEVEMENT_ONEOFF
    ACH.Description = "Play with 10 Steam friends."
    ACH.Icon = "gui/achievements/friends.png"

	function ACH:Initialize()
		concommand.Add("__givefriendsachv", function(ply) self:Complete( ply ) end) -- yeah yeah fuck off, garry sucks
	end
	
	if CLIENT then
		local done = false
		hook.Add("OnEntityCreated", "CheckFriends", function()
			local friendCount = 0
			for _, ply in pairs(player.GetAll()) do
				if ply:GetFriendStatus() == "friend" then
					friendCount = friendCount + 1
				end
			end
			
			if friendCount > 9 and not done then RunConsoleCommand("__givefriendsachv") done = true end
		end)
	end

    achievements.Register( category, "friends", "F is for Friends", ACH )
end