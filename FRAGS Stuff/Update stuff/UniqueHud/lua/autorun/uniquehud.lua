PlayerRanks = {}
	
		PlayerRanks[1] = {}
		PlayerRanks[1].Name = "Newcomer"
		PlayerRanks[1].Time = 0
	
		PlayerRanks[2] = {}
		PlayerRanks[2].Name = "Noob!"
		PlayerRanks[2].Time = 600
		
		PlayerRanks[3] = {}
		PlayerRanks[3].Name = "Still a Noob!"
		PlayerRanks[3].Time = 2400
		
		PlayerRanks[4] = {}
		PlayerRanks[4].Name = "Semi Noob!"
		PlayerRanks[4].Time = 3600*2
		
		PlayerRanks[5] = {}
		PlayerRanks[5].Name = "Semi Noob! Lv 2"
		PlayerRanks[5].Time = 3600*4
		
		PlayerRanks[6] = {}
		PlayerRanks[6].Name = "Semi Noob! Lv 3"
		PlayerRanks[6].Time = 3600*8
		
		PlayerRanks[7] = {}
		PlayerRanks[7].Name = "Skilled Player"
		PlayerRanks[7].Time = 3600*14
		
		PlayerRanks[8] = {}
		PlayerRanks[8].Name = "Skilled Player Lv 2"
		PlayerRanks[8].Time = 3600*22
		
		PlayerRanks[9] = {}
		PlayerRanks[9].Name = "Skilled Player Lv 3"
		PlayerRanks[9].Time = 3600*36
		
		PlayerRanks[10] = {}
		PlayerRanks[10].Name = "Semi Pro Player"
		PlayerRanks[10].Time = 3600*56
		
		PlayerRanks[11] = {}
		PlayerRanks[11].Name = "Semi Pro Player Lv 1"
		PlayerRanks[11].Time = 3600*86
		
		PlayerRanks[12] = {}
		PlayerRanks[12].Name = "Semi Pro Player Lv 2"
		PlayerRanks[12].Time = 3600*126
		
		PlayerRanks[13] = {}
		PlayerRanks[13].Name = "Semi Pro Player Lv 3"
		PlayerRanks[13].Time = 3600*176
		
		PlayerRanks[14] = {}
		PlayerRanks[14].Name = "Pro Player"
		PlayerRanks[14].Time = 3600*236
		
		PlayerRanks[15] = {}
		PlayerRanks[15].Name = "Pro Player Lv 1"
		PlayerRanks[15].Time = 3600*316
		
		PlayerRanks[16] = {}
		PlayerRanks[16].Name = "Ultimate Player"
		PlayerRanks[16].Time = 3600*416
		
		PlayerRanks[17] = {}
		PlayerRanks[17].Name = "Ultimate Player Lv 1"
		PlayerRanks[17].Time = 3600*550
		
		PlayerRanks[18] = {}
		PlayerRanks[18].Name = "Supreme Player!"
		PlayerRanks[18].Time = 3600*1000
		

function ToHoursMinutesSeconds(curtime)
	local seconds = curtime % 60
	local minutes = math.floor(curtime/60) % 60
	local hours = math.floor(curtime/60/60)
		
	local newtime = ""
		
	if hours < 10 then
		newtime = "0"..hours..":"
	else newtime = hours..":" end
			
	if minutes < 10 then
		newtime = newtime.."0"..minutes..":"
	else newtime = newtime..minutes..":" end
		
	if seconds < 10 then
		newtime = newtime.."0"..seconds
	else newtime = newtime..seconds end
		
	return newtime;
end

if CLIENT then

	local SyncDone = false
	local CurSyncTime = 0;
	local CurSyncRank = 1;
	
	function DrawIDTime()
		local tr = utilx.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() )
		local trace = util.TraceLine( tr )
		if (!trace.Hit) then return end
		if (!trace.HitNonWorld) then return end
		
		local text = "ERROR"
		local font = "TargetIDSmall"
		
		if (trace.Entity:IsPlayer()) then
			text = ToHoursMinutesSeconds(trace.Entity:GetNetworkedInt("TimeUpdate"))
		else return end;
		
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
		
		local x, y = gui.MousePos()
		
		x = x - w / 2
		y = y + 15
		
		local rank = trace.Entity:GetNetworkedInt("PlayerRank")
		if not PlayerRanks[rank] then rank = 1 end
		rank = "Rank: "..PlayerRanks[rank].Name
		
		draw.SimpleText( rank, font, x+1, y+1, Color(0,0,0,120) )
		draw.SimpleText( rank, font, x+2, y+2, Color(0,0,0,50) )
		draw.SimpleText( rank, font, x, y, team.GetColor(trace.Entity:Team()) )
	end
	
	function UpdateTimeHUD()
		if not SyncDone then return end
		DrawIDTime()
		// DrawIcons()
		local newtime = ToHoursMinutesSeconds(CurSyncTime)
		local rank = CurSyncRank
		if not PlayerRanks[rank] then rank = 1 end
		local nextrank = PlayerRanks[rank+1]
		if nextrank then nextrank = nextrank.Name else nextrank = "None" end
		rank = PlayerRanks[rank].Name
		local msg = {}
		msg[1] = "Your Rank"
		msg[2] = "Time spent on the server: "..newtime
		msg[3] = "Rank: "..rank
		msg[4] = "Next Rank: "..nextrank
		
		local longest = 1
		for k,v in pairs(msg) do
			if string.len(v) > string.len(msg[longest]) then
				longest = k
			end
		end
		
		surface.SetFont("DefaultSmall")
		local w,h = surface.GetTextSize(msg[longest])
		local x = ScrW()-w-35
		local y = 94
		w = w + 10
		
				draw.RoundedBox(8, x-235, 10, w+250,h*6+20, Color(30,144,255))
					local SELF = LocalPlayer()
						local Health = SELF:Health()
						
					
				draw.SimpleText("Server Name!", "HudHintTextLarge", x-130, y-80, Color(255,255,255,255))
				draw.SimpleText("Your ping : " .. LocalPlayer():Ping() .. "\n", "Default", x-130, y-20, Color(255,255,255,255))
				
		--Logo
		
		local uniquehudlogo = surface.GetTextureID( "decals/uniquehudlogo" )

		surface.SetTexture( uniquehudlogo )
		surface.SetDrawColor(30,144,255)
		surface.DrawTexturedRect(x+((w+10)/2)-300,20,64,64)
		
		--Info box

		draw.SimpleText(msg[1], "DefaultUnderline", x-5, y-80, Color(255,255,255,255))
		draw.SimpleText(msg[2], "DefaultSmall", x-5, y+h-75, Color(255,255,255,255))
		draw.SimpleText(msg[3], "DefaultSmall", x-5, y+h-40, Color(255,255,255,255))
		draw.SimpleText(msg[4], "DefaultSmall", x-5, y+h-27, Color(255,255,255,255))
		
		
		--Info box progress bar
		if not PlayerRanks[CurSyncRank+1] then return end;
		local rnum = PlayerRanks[CurSyncRank+1].Time - PlayerRanks[CurSyncRank].Time
		local plnum = CurSyncTime - PlayerRanks[CurSyncRank].Time
		local percent = plnum/rnum*100
		local size = (w-4)/100*percent
		local ypos = y-62+h

		surface.SetDrawColor(245,0,90,255)
		surface.DrawRect(x+6,ypos+2,w-4,16)
		
		surface.SetDrawColor(0,217,210,255)
		surface.DrawRect(x+6,ypos+2,size,16)
		
		--Info box progress bar text
		msg = ToHoursMinutesSeconds(rnum-plnum)
		local w2,h2 = surface.GetTextSize(msg)
		local tx = (x+6+((w-4)/2))-(w2/2)
		local ty = (ypos+8)-(h2/4)

		draw.SimpleText(msg, "DefaultSmall", tx, ty, Color(255,255,255,255))
		
	end
	hook.Add("HUDPaint", "UpdateTimeHUD", UpdateTimeHUD);
	
	function TimeUpdate()
		CurSyncTime = CurSyncTime + 1
	end
	timer.Create("timespentlocal", 1, 0, TimeUpdate);
	
	function TimeSyncHook(um)
		CurSyncTime = um:ReadLong() or CurSyncTime
		CurSyncRank = um:ReadShort() or CurSyncRank
		if not SyncDone then SyncDone = true end
	end
	usermessage.Hook("TimeSync", TimeSyncHook);
end

if SERVER then

	AddCSLuaFile("uniquehud.lua")
	
	resource.AddFile("materials/decals/uniquehudlogo.vmt")
	resource.AddFile("materials/decals/uniquehudlogo.vtf")

	local meta = FindMetaTable("Player")
	if (!meta) then return end;
	
	PlayersTime = {}
	
	function meta:GetTimeSpent()
		if not file.IsDir("PlayerTimes") then file.CreateDir("PlayerTimes") end;
		local steamid = self:SteamID()
		local filename = "PlayerTimes/"..string.gsub(steamid, ":", "_")..".txt"
		
		if not file.Exists(filename) then return 0 end
		
		local curfile = file.Read(filename)
		return tonumber(curfile);
	end
	
	function meta:SetTimeSpent(newtime)
		if not file.IsDir("PlayerTimes") then file.CreateDir("PlayerTimes") end;
		local steamid = self:SteamID()
		local filename = "PlayerTimes/"..string.gsub(steamid, ":", "_")..".txt"
		file.Write(filename, newtime);
	end
	
	function meta:GetRank()
		if not PlayersTime[self:SteamID()] then PlayersTime[self:SteamID()] = self:GetTimeSpent() end
		local curtime = PlayersTime[self:SteamID()]
		local final = 1
		for i = 1, table.getn(PlayerRanks) do
			if curtime >= PlayerRanks[i].Time then final = i end
		end
		return final;
	end
	
	function UpdateTime()
		for _,pl in pairs(player.GetAll()) do
			if pl:IsValid() then
				if not PlayersTime[pl:SteamID()] then PlayersTime[pl:SteamID()] = pl:GetTimeSpent() end
				PlayersTime[pl:SteamID()] = PlayersTime[pl:SteamID()] + 1
			end
		end
	end
	timer.Create("TimeUpdate", 1, 0, UpdateTime);
	
	function TimeSyncHook()
		for _,pl in pairs(player.GetAll()) do
			if pl:IsValid() then
				if not PlayersTime[pl:SteamID()] then PlayersTime[pl:SteamID()] = pl:GetTimeSpent() end
				
				umsg.Start("TimeSync", pl)
					umsg.Long(PlayersTime[pl:SteamID()])
					umsg.Short(pl:GetRank())
				umsg.End()
				pl:SetNetworkedInt("PlayerRank", pl:GetRank())
				pl:SetTimeSpent(PlayersTime[pl:SteamID()])
			end
		end
	end
	
	timer.Create("TimeSyncTimer",30,0,TimeSyncHook);
	
	function InitialSpawnSync(pl)
		TimeSyncHook()
	end
	
	hook.Add("PlayerInitialSpawn", "SpawnTimeSync", InitialSpawnSync);
	
	end


