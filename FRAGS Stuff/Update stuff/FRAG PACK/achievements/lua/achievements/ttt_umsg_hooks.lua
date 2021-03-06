//--------------
//Tracking Kills
//--------------

//Table update
local function UpdateKill( data )
	//Umsg only sent to the killer, so we killed
	local ply = LocalPlayer()
	
	local victim = data:ReadString() //Who dieD? UniqueID
	local wep = data:ReadString() //What weapon? Class
	local headshot = data:ReadBool() //Headshot? Bool
	
	//If no kills recorded, clear it
	if not ply.LDTAchiveKills then
		ply.LDTAchiveKills = {}
	end
	//Insert our new table into the kills table
	table.insert(ply.LDTAchiveKills, {victim,wep,headshot})
end
usermessage.Hook("LDTAchUpdKill",UpdateKill)

//Table Clear
local function ClearKill( data )
	local ply = LocalPlayer()
	ply.LDTAchiveKills = nil
end
usermessage.Hook("LDTAchClearKill",ClearKill)