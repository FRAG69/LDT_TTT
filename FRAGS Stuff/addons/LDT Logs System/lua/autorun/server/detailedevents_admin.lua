local function GetPrintFn(ply)
   if IsValid(ply) then
      return function(...)
                local t = ""
                for _, a in ipairs({...}) do
                   t = t .. "\t" .. a
                end
                ply:PrintMessage(HUD_PRINTCONSOLE, t)
             end
   else
      return print
   end
end
local function ShowDamageLog(ply)
	local pr = GetPrintFn(ply)
	if GAMEMODE.DetailedDamageLog == nil then return end
   if (not IsValid(ply)) or ply:IsSuperAdmin() or ply:IsAdmin() or GetRoundState() != ROUND_ACTIVE then
	  local id = ply:SteamID()
	  if ply.PrintedDL != nil then
		ply:ChatPrint("You have already printed the damage log in the last 3 seconds, please wait.")
	  else	
		ply.PrintedDL = true
		  ServerLog(Format("%s used ttt_show_damagelog\n", IsValid(ply) and ply:Nick() or "console"))
		  ply:ConCommand("ttt_detailed_getdamagelog 1")
		  timer.Simple(3, function() if ply != nil then ply.PrintedDL = nil end end)
	  end
   else
      if IsValid(ply) then
         pr("You do not appear to be RCON or an admin, nor are we in the post-round phase!")
      end
   end
end
concommand.Add("ttt_show_damagelog", ShowDamageLog)
local function ShowLastDamageLog(ply)
	local pr = GetPrintFn(ply)
      
	  local id = ply:SteamID()
	  if ply.PrintedDL != nil then
		ply:ChatPrint("You have already printed the damage log in the last 3 seconds, please wait.")
	  else
		ply.PrintedDL = true
		  ServerLog(Format("%s used ttt_show_lastdamagelog\n", IsValid(ply) and ply:Nick() or "console"))
		  ply:ConCommand("ttt_detailed_getdamagelog 2")
		  timer.Simple(3, function() ply.PrintedDL = nil end)
	  end
end
concommand.Add("ttt_show_lastdamagelog", ShowLastDamageLog)
function AddToDamageLog( args )
	if GetRoundState() == ROUND_POST then return end
	if GAMEMODE.DetailedDamageLog == nil then return end
	
	local t = math.max(0, CurTime() - GAMEMODE.RoundStartTime)
	table.insert(args, 1, string.FormattedTime(t, "%02i:%02i.%02i"))
	
	table.insert(GAMEMODE.DetailedDamageLog, von.serialize(args))
end
util.AddNetworkString("DamageLogHook")
local function GetDamageLog(ply, cmd, args)
	if args[1] == nil then return end

	if args[1] == "1" then
		 if not ((not IsValid(ply)) or ply:IsSuperAdmin() or ply:IsAdmin() or GetRoundState() != ROUND_ACTIVE) then ply:PrintMessage(HUD_PRINTTALK, "You can't use that right now!") return end
	end

	local stream
	if args[1] == "2" then
		stream = file.Read("lastdetailedevents.txt", "DATA")
	else
		stream = von.serialize(GAMEMODE.DetailedDamageLog)
	end
	
	local cut = {}
	local max = 60000
	while #stream != 0 do 
		local bit = string.sub(stream, 1, max - 1)
		table.insert(cut, bit)
		stream = string.sub(stream, max, -1)
	end
	
	local parts = #cut
	for k, bit in pairs(cut) do
		net.Start("DamageLogHook")
			net.WriteBit((k != parts))
			net.WriteString(bit)  
			net.WriteInt( tonumber(args[1]), 8 )
		net.Send(ply)
	end
end
concommand.Add("ttt_detailed_getdamagelog", GetDamageLog)