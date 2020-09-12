local sliced = CCachievements.GetValue( "Slicer", "total", 0 )

local function PlayerKilledEnemy()
	local ply = LocalPlayer()
	
	//No kills, no point wasting resources
	if ply.LDTAchiveKills == nil then return end
	
	local NumKills = 0
	
	for k,record in pairs(ply.LDTAchiveKills) do
		//Record 1 is the UniqueID, not the player:
		local sliced = player.GetByUniqueID(record[1])
		
		
		if (sliced) and (record[2] == "weapon_ttt_knife") and (record[3]) then
			if (ply:IsTraitor() and not sliced:IsTraitor()) or (sliced:IsTraitor() and not ply:IsTraitor()) then
				NumKills = NumKills + 1
			end
		end
	end
	
	
	if (NumKills > sliced) then
		sliced = math.Clamp( NumKills, 0, 50 )
		CCachievements.SetValue( "Slicer", "total", sliced )
		CCachievements.Update( "Slicer", sliced / 50, sliced .. "/50" )
	end
end

timer.Create( "Achievement.slicer",2,0, PlayerKilledEnemy )

CCachievements.Register( "Slicer", "Kill 50 people with a knife.", "achievements/slicer", sliced / 50, sliced .. "/50" )