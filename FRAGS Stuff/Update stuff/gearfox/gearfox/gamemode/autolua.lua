
function AddLuaCSFolder(DIR)
	local GAMEPAT = GM.Folder:gsub("gamemodes/","").."/gamemode/"..DIR
	local GAMEFIL = file.FindInLua(GAMEPAT.."/*.lua")
	
	for k,v in pairs( GAMEFIL ) do
		if (CLIENT) then include(GAMEPAT.."/"..v)
		else AddCSLuaFile(GAMEPAT.."/"..v) end
	end
end

function AddLuaSVFolder(DIR)
	local GAMEPAT = GM.Folder:gsub("gamemodes/","").."/gamemode/"..DIR
	local GAMEFIL = file.FindInLua(GAMEPAT.."/*.lua")
	
	for k,v in pairs( GAMEFIL ) do
		if (SERVER) then include(GAMEPAT.."/"..v) end
	end
end