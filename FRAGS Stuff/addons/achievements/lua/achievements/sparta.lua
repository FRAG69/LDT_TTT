local killed = CCachievements.GetValue( "This is SPARTA", "total", 0 )

local function PlayerKilledEnemy()
	local ply = LocalPlayer()
	
	//No kills, no point wasting resources
	if ply.LDTAchiveKills == nil then return end
	
	local NumKills = 0
	
	for k,record in pairs(ply.LDTAchiveKills) do
		//Record 1 is the UniqueID, not the player:
		local killed = player.GetByUniqueID(record[1])
		
		
		if (killed:IsPlayer()) and (record[2] == "weapon_zm_improvised") and (record[3]) then
			if (ply:IsTraitor() and not killed:IsTraitor()) or (killed:IsTraitor() and not ply:IsTraitor()) then
				NumKills = NumKills + 1
			end
		end
	end
	
	
	if (NumKills > killed) then
		killed = math.Clamp( NumKills, 0, 1 )
		CCachievements.SetValue( "This is SPARTA", "total", killed )
		CCachievements.Update( "This is SPARTA", killed / 1, killed .. "/1" )
	end
end

timer.Create( "Achievement.sparta",2,0, PlayerKilledEnemy )

CCachievements.Register( "This is SPARTA", "Successfully push someone of the edge (must be valid kill).", "achievements/sparta", killed / 1, killed .. "/1" )