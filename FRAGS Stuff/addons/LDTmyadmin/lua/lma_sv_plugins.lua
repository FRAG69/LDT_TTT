
/*
   __     ___  ______                     _        _             _        
  / /    /   \/__  __|_ __ ___   _   _   /_\    __| | _ __ ___  (_) _ __  
 / /    / /\ /  / /  | '_ ` _ \ | | | | //_\\  / _` || '_ ` _ \ | || '_ \ 
/ /___ / /_//  / /   | | | | | || |_| |/  _  \| (_| || | | | | || || | | |
\____//___,'   \/    |_| |_| |_| \__, |\_/ \_/ \__,_||_| |_| |_||_||_| |_|
                                 |___/                                    

	LDTmyAdmin - fucking incomplete version
	Property of the Let's Do This community
	Made by psycix
*/
/*==========================================================
	Plugins
==========================================================*/

LMA_Commands = {}
LMA_NonPlayerCommands = {}

--==============KICK==============
LMA_Commands["kick"] = {}
LMA_Commands["kick"]["rank"] = 1
LMA_Commands["kick"]["self"] = false
LMA_Commands["kick"]["higherrank"] = true
LMA_Commands["kick"]["func"] = function (source, args, target)
	local reason = "No reason specified."
	if args [3] then
		if args[3] != "" && args[3] != " " then
			reason = ""
			for i=3,#args do
				reason = reason.." "..args[i]
			end
		end
	end
	target:Kick(reason)
	LMA_Broadcast(source:Nick().." kicked "..target:Nick().." with the reason: "..reason)
end


--==============SLAY==============
LMA_Commands["slay"] = {}
LMA_Commands["slay"]["rank"] = 1
LMA_Commands["slay"]["self"] = true
LMA_Commands["slay"]["higherrank"] = false
LMA_Commands["slay"]["func"] = function (source, args, target)
	local reason = ""
	if args [3] then
		if args[3] != "" && args[3] != " " then
			for i=3,#args do
				reason = reason.." "..args[i]
			end
		end
	end
	if target:Alive() then //Is spectator?
		target:Kill()
		if reason == "" then
			LMA_Broadcast(source:Nick().." has slain "..target:Nick())
		else
			LMA_Broadcast(source:Nick().." has slain "..target:Nick().." with the reason: "..reason)
		end
	else
		LMA_FeedbackMessage(source," Can't slay: target is not alive!")		
	end
	
end

--==============SIT OUT==============
LMA_Commands["sitout"] = {}
LMA_Commands["sitout"]["rank"] = 1
LMA_Commands["sitout"]["self"] = false
LMA_Commands["sitout"]["higherrank"] = false
LMA_Commands["sitout"]["func"] = function (source, args, target)
	local reason = ""
	if args [3] then
		if args[3] != "" && args[3] != " " then
			for i=3,#args do
				reason = reason.." "..args[i]
			end
		end
	end
	
	if reason == "" then
		LMA_Broadcast(source:Nick().." made "..target:Nick().." sit out a round.")
		reason = "-"
	else
		LMA_Broadcast(source:Nick().." made "..target:Nick().." sit out a round with the reason: "..reason)
	end

	target:SetPData("LMA_SitOut", reason)
end

LMA_Commands["unsitout"] = {}
LMA_Commands["unsitout"]["rank"] = 1
LMA_Commands["unsitout"]["self"] = false
LMA_Commands["unsitout"]["higherrank"] = false
LMA_Commands["unsitout"]["func"] = function (source, args, target)
	if target:GetPData("LMA_SitOut") then
		LMA_Broadcast(source:Nick().." un-sitoutted "..target:Nick())
		target:RemovePData("LMA_SitOut")		
	else
		LMA_FeedbackMessage(source,target:Nick().." is not sitting out.")		
	end
end

function plmt:SitOut()
	if self:GetPData("LMA_SitOut") then		
		if self:GetPData("LMA_SitOut") == "-" then
			LMA_SendMessage(self, "You are sitting this round out.")	
		else
			LMA_SendMessage(self, "You are sitting this round out for the following reason: "..self:GetPData("LMA_SitOut"))	
		end
		self:RemovePData("LMA_SitOut")
		return true
	else		
		return false
	end
end

--==============TP==============
LMA_Commands["tp"] = {}
LMA_Commands["tp"]["rank"] = 2
LMA_Commands["tp"]["self"] = true
LMA_Commands["tp"]["higherrank"] = true
LMA_Commands["tp"]["func"] = function (source, args, target)
	
	if source == target then
		LMA_Broadcast(source:Nick().." has teleported himself.")
	else
		LMA_Broadcast(source:Nick().." has teleported "..target:Nick()..".")
	end
	
	target:SetPos(source:GetEyeTrace().HitPos - source:GetEyeTrace().Normal*32 + Vector(0,0,1))
	
end

--==============GOTO==============
LMA_Commands["goto"] = {}
LMA_Commands["goto"]["rank"] = 2
LMA_Commands["goto"]["self"] = true
LMA_Commands["goto"]["higherrank"] = true
LMA_Commands["goto"]["func"] = function (source, args, target)
	
	LMA_Broadcast(source:Nick().." has teleported himself to "..target:Nick()..".")
	
	source:SetPos(target:GetPos() + Vector(0,0,129))
	
end

--==============BAN==============
LMA_Commands["ban"] = {}
LMA_Commands["ban"]["rank"] = 2
LMA_Commands["ban"]["self"] = false
LMA_Commands["ban"]["higherrank"] = false
LMA_Commands["ban"]["func"] = function (source, args, target)
	if tonumber(args[3]) then
		local time = tonumber(args[3]) * 60
		local reason = "No reason specified."
		if args [4] then
			if args[4] != "" && args[4] != " " then
				reason = ""
				for i=4,#args do
					reason = reason.." "..args[i]
				end
			end
		end
		
		LMA_BanID(target:SteamID(), time, reason, source:Nick())
		LMA_Broadcast(source:Nick().." has banned "..target:Nick().." for "..args[3].." minutes, reason:"..reason)
	else
		LMA_FeedbackMessage(source,"Please provide a time.")	
	end
end

LMA_NonPlayerCommands["ban"] = {}
LMA_NonPlayerCommands["ban"]["rank"] = 2
LMA_NonPlayerCommands["ban"]["func"] = function (source, args)
	if LMA_ValidateSteamID(args[2]) then
		if tonumber(args[3]) then
			local time = tonumber(args[3]) * 60
			local reason = "No reason specified."
			local steamID = args[2]
			if args [4] then
				if args[4] != "" && args[4] != " " then
					reason = ""
					for i=4,#args do
						reason = reason.." "..args[i]
					end
				end
			end
			
			LMA_BanID(steamID, time, reason, source:Nick())
			LMA_Broadcast(source:Nick().." has banned "..steamID.." for "..args[3].." minutes, reason:"..reason)
		else
			LMA_FeedbackMessage(source,"Please provide a time.")			
		end
	else
		LMA_FeedbackMessage(source,"Not a valid steamID.")
	end
end

LMA_NonPlayerCommands["unban"] = {}
LMA_NonPlayerCommands["unban"]["rank"] = 2
LMA_NonPlayerCommands["unban"]["func"] = function (source, args)
	if LMA_ValidateSteamID(args[2]) then
		LMA_UnbanID(args[2])
		LMA_Broadcast(source:Nick().." has unbanned "..args[2])
	else
		LMA_FeedbackMessage(source,"Not a valid steamID.")
	end
end

LMA_NonPlayerCommands["g"] = {}
LMA_NonPlayerCommands["g"]["rank"] = 2
LMA_NonPlayerCommands["g"]["func"] = function (source, args)
	if args[2] then
	local str = ""
	for i=2,#args do
		str = str..args[i].." "
	end
		LMA_Broadcast("(GLOBAL) "..source:Nick()..": "..str)
	else
		LMA_FeedbackMessage(source,"Please enter a message")
	end
end

--==============RTV==============
LMA_Commands["rtv"] = {}
LMA_Commands["rtv"]["rank"] = 1
LMA_Commands["rtv"]["self"] = false
LMA_Commands["rtv"]["higherrank"] = false
LMA_Commands["rtv"]["func"] = function (source, args, target)
end

function plmt:Rtv( self )
	MAPVOTE:PlayerRTV( self )
end


/*
--==============MUTE==============
LMA_Commands["mute"] = {}
LMA_Commands["mute"]["rank"] = 1
LMA_Commands["mute"]["self"] = false
LMA_Commands["mute"]["higherrank"] = false
LMA_Commands["mute"]["func"] = function (source, args, target)
	LMA_Broadcast(source:Nick().." has muted "..target:Nick())
	target:SetMute(true)
end

LMA_Commands["unmute"] = {}
LMA_Commands["unmute"]["rank"] = 1
LMA_Commands["unmute"]["self"] = false
LMA_Commands["unmute"]["higherrank"] = false
LMA_Commands["unmute"]["func"] = function (source, args, target)
	LMA_Broadcast(source:Nick().." has unmuted "..target:Nick())
	target:SetMute(false)
end

function plmt:SetMute(bool)
	self.LMA_Muted = bool
end

hook.Add("PlayerCanHearPlayersVoice", "LMA_PlayerCanHearPlayer", function(listener, talker)
	return !tobool(talker.LMA_Muted)
end)*/