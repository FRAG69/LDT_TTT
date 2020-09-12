
/*
   __     ___  ______                     _        _             _        
  / /    /   \/__  __|_ __ ___   _   _   /_\    __| | _ __ ___  (_) _ __  
 / /    / /\ /  / /  | '_ ` _ \ | | | | //_\\  / _` || '_ ` _ \ | || '_ \ 
/ /___ / /_//  / /   | | | | | || |_| |/  _  \| (_| || | | | | || || | | |
\____//___,'   \/    |_| |_| |_| \__, |\_/ \_/ \__,_||_| |_| |_||_||_| |_|
                                 |___/                                    

	LDTmyAdmin
	Property of the Let's Do This community
	Made by psycix
*/
---- SERVER NAME ----
LMA_servname = "TTT"
---- SERVER NAME ----

LDT_ranknames = {}
LDT_ranknames[-1] = "Banned"
LDT_ranknames[0] = "Guest"
LDT_ranknames[1] = "Regular"
LDT_ranknames[2] = "Trusted"
LDT_ranknames[3] = "Moderator"
LDT_ranknames[4] = "Admin"

LDT_rankColors = {}
LDT_rankColors[-1] = Color(50,50,50)
LDT_rankColors[0] = Color(255,255,255)
LDT_rankColors[1] = Color(255,255,255)
LDT_rankColors[2] = Color(255,238,0)
LDT_rankColors[3] = Color(255,165,0)
LDT_rankColors[4] = Color(255,0,0)
//Color(0,150,0) <- mods can never have this color

plmt = FindMetaTable("Player")

/*==========================================================
	Utils
==========================================================*/

function plmt:LMA_IsRank(rank)
	if tonumber(rank) then
		return (self:GetNWInt("LDT_rank") >= tonumber(rank))
	elseif tostring(rank) then
		for k,v in pairs(LDT_ranknames) do
			if (string.lower(rank) == string.lower(v)) then
				return self:LMA_IsRank(k)
			end
		end
		return false
	else
		return false
	end
end

function LMA_GetPlayerGroupByName(name)
if name && name != "" then
	local result = {}
	for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(name)) then
			table.insert(result, v)
		end
	end
	
	if #result > 0 then
		return result
	end
end
return false
end

function LMA_GetPlayerByName(name)
	if name && name != "" then
		local result = false
		for k, v in pairs(player.GetAll()) do
			if string.find(string.lower(v:Name()), string.lower(name), 1, false) then
				if !result then
					result = v
				else
					return false
				end
			end
		end
		return result
	else
		return false
	end
end

function LMA_GetPlayerBySession(id)
if tonumber(id) then
	local result = false
	for k, v in pairs(player.GetAll()) do
		if (v:GetNWInt("LMA_session") == tonumber(id)) then
			if !result then
				result = v
			else
				return false
			end
		end
	end
	return result
end
return false
end

function LMA_GetPlayerBySteamID(id)
if id && id != "" then
	for k, v in pairs(player.GetAll()) do
		if (v:SteamID() == id) then
			return v;
		end
	end
end
return false
end

function LMA_ValidateSteamID(id)
	return (id == (string.match( id, "STEAM_[01]:[0-9]:[0-9]+" )))
end
