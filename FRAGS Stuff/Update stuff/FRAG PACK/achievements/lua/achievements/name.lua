local killed = CCachievements.GetValue( "He who has no name.", "total", 0 )

local function PlayerKilledEnemy()
	local ply = LocalPlayer()
	
	//No kills, no point wasting resources
	if ply.LDTAchiveKills == nil then return end
	
	local NumKills = 0
	
	for k,record in pairs(ply.LDTAchiveKills) do
		//Record 1 is the UniqueID, not the player:
		local killed = player.GetByUniqueID(record[1])
		
		
		if (killed:IsPlayer()) and (record[2] == "weapon_ttt_impersonator") and (record[3]) then
			if (ply:IsTraitor() and not killed:IsTraitor()) or (killed:IsTraitor() and not ply:IsTraitor()) then
				NumKills = NumKills + 1
			end
		end
	end
	
	
	if (NumKills > killed) then
		killed = math.Clamp( NumKills, 0, 50 )
		CCachievements.SetValue( "He who has no name.", "total", killed )
		CCachievements.Update( "He who has no name.", killed / 50, killed .. "/50" )
	end
end

timer.Create( "Achievement.name",2,0, PlayerKilledEnemy )

CCachievements.Register( "He who has no name.", "Earn 50 kills whilst wearing the Disguiser.", "achievements/name", killed / 50, killed .. "/50" )