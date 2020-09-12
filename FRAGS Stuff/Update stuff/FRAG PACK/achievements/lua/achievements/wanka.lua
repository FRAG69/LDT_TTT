local killed = CCachievements.GetValue( "Wave goodbye to your head, wanka!", "total", 0 )

local function PlayerKilledEnemy()
	//Only using data on ourself
	//So it's OK to use the table
	local ply = LocalPlayer()
	
	//No kills, no point wasting resources
	if ply.LDTAchiveKills == nil then return end
	
	local NumKills = 0
	
	for k,record in pairs(ply.LDTAchiveKills) do
		//Record 1 is the UniqueID, not the player:
		local killed = player.GetByUniqueID(record[1])
		
		//Record 2 is the weapon type, 3 is Headshot (true/false)
		if (killed:IsPlayer()) and (record[2] == "weapon_zm_rifle") and (record[3]) then
			//Valid kill?
			if (ply:IsTraitor() and not killed:IsTraitor()) or (killed:IsTraitor() and not ply:IsTraitor()) then
				NumKills = NumKills + 1
			end
		end
	end
	
	//Update ach with our data
	if (NumKills > killed) then
		killed = math.Clamp( NumKills, 0, 5 )
		CCachievements.SetValue( "Wave goodbye to your head, wanka!", "total", killed )
		CCachievements.Update( "Wave goodbye to your head, wanka!", killed / 5, killed .. "/5" )
	end
end
//Check once every 2 seconds
timer.Create( "Achievement.wanka",2,0, PlayerKilledEnemy )

CCachievements.Register( "Wave goodbye to your head, wanka!", "In a single round, kill 5 people with a sniper rifle.", "achievements/wanka", killed / 5, killed .. "/5" )