sceneDummies = {}

function getIconFeatures( role )
	if role == "innocent" then
		return "icon16/emoticon_grin.png", "Innocent"
	elseif role == "detective" then
		return "icon16/magnifier.png", "Detective"
	else
		return "icon16/exclamation.png", "Traitor"
	end
end

local function clearEventsSelection( pnl )
	local selected = pnl:GetSelected()
	
	local tempLine = vgui.Create("DListView_Line")
	for _, v in pairs(selected) do
		v.Paint = tempLine.Paint
	end
	tempLine:Remove()
	pnl:ClearSelection()
end

local function changeSelectionColor ( pnl )
	local selected = pnl:GetSelected()
	for _, v in pairs(selected) do
		if v:GetColumnText(3) != "killed" and v:GetColumnText(3) != "destroyed" then
			v.Paint = function()
				surface.SetDrawColor(255,89,89)
				surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
			end
		else
			v.Paint = function()
				surface.SetDrawColor(235,0,0)
				surface.DrawRect(0, 0, v:GetWide(), v:GetTall())
			end
		end
	end
end

local function selectLinesByString( str, pnl )
	local listItems = pnl:GetLines()
	for _,v in pairs(listItems) do
		local plys = string.Explode("|_|", v:GetColumnText(6))
		if plys[1] == str or plys[2] == str then pnl:SelectItem(v) end
	end
end

local function setUpLogColumns( pnl, iconsize )	
	local timeCol = pnl:AddColumn("Time") --time of event
	local attCol = pnl:AddColumn("") --left image
	local typeCol = pnl:AddColumn("Type") --type of event
	local vicCol = pnl:AddColumn("") --right image
	local eventCol = pnl:AddColumn("Details") --details of event
	pnl.eventCol = eventCol
	
	local searchCol = pnl:AddColumn("") --player names for searching
	local rdmCol = pnl:AddColumn("") --was it possible rdm?
	local roleCol = pnl:AddColumn("") --roles of the attacker/victim
	local infoCol = pnl:AddColumn("") --extra info (disguised, last shot, etc)
	local sceneCol = pnl:AddColumn("")
	
	timeCol:SetFixedWidth(50)
	attCol:SetFixedWidth(iconsize)
    typeCol:SetFixedWidth(60)
	vicCol:SetFixedWidth(iconsize)
	eventCol:SetFixedWidth(pnl:GetWide()-110-iconsize*2)
	
	searchCol:SetFixedWidth(0)
	rdmCol:SetFixedWidth(0)
	roleCol:SetFixedWidth(0)
	infoCol:SetFixedWidth(0)
	sceneCol:SetFixedWidth(0)
	
   timeCol.Header:SetDisabled(true)
   typeCol.Header:SetDisabled(true)
   eventCol.Header:SetDisabled(true)
   attCol.Header:SetDisabled(true)
   vicCol.Header:SetDisabled(true)
   searchCol.Header:SetDisabled(true)
   rdmCol.Header:SetDisabled(true)
   roleCol.Header:SetDisabled(true)
   infoCol.Header:SetDisabled(true)
   sceneCol.Header:SetDisabled(true)
end

local function selectLinesByRDM( pnl )
	local listItems = pnl:GetLines()
	for _, v in pairs(listItems) do
		if v:GetColumnText( 7 ) == 1 then
			pnl:SelectItem( v)
		end
	end
	changeSelectionColor( pnl )
end

local function addSearchBar( frame, pnl, mid )
	local bw, bh = 109, 25
	
	local x = mid and 10 or 0
	local y = mid and (frame:GetTall() - 45) or pnl:GetTall()
	
	local searchPanel = vgui.Create("DPanel", frame)
	searchPanel:SetPos( x, y )
	searchPanel:SetSize( pnl:GetWide(), bh + 10)
	searchPanel.Paint = function()
		surface.SetDrawColor(35,35,35,255)
		surface.DrawRect(0,0,searchPanel:GetWide(),searchPanel:GetTall())
	end
	
	frame.searchpnl = searchPanel
	
	local lblSearch = vgui.Create("DLabel", searchPanel)
	lblSearch:SetText("Search player:")
	lblSearch:SetFont("DefaultBold")
	lblSearch:SetTextColor(color_white)
	lblSearch:SizeToContents()
	lblSearch:SetPos( 8, searchPanel:GetTall() / 2 - lblSearch:GetTall() / 2 )
	pnl.lblsearch = lblSearch
	
	selectedPlayer = 0
	
	local playerDropdown = vgui.Create("DComboBox", searchPanel)
	playerDropdown:SetSize( mid and (searchPanel:GetWide()/3 + 17) or searchPanel:GetWide()/3, bh )
	playerDropdown:SetPos( lblSearch:GetWide() + 12, searchPanel:GetTall() / 2 - playerDropdown:GetTall() / 2)
	playerDropdown.OnSelect = function ( pnl, ind, val, dat )
		selectedPlayer = ind
	end
	
	pnl.dropdown = playerDropdown
	
	local btnClear = vgui.Create("DButton", searchPanel)
	btnClear:SetPos(searchPanel:GetWide() - bw - 5, 5)
	btnClear:SetSize(bw, bh)
	btnClear:SetText("Clear")
	btnClear.DoClick = function()
		clearEventsSelection( pnl )
	end
	pnl.btnclear = btnClear
	
	local btnSearch = vgui.Create("DButton", searchPanel)
	btnSearch:SetPos( lblSearch:GetWide() + playerDropdown:GetWide() + 16, 5)
	btnSearch:SetSize(bw, bh)
	btnSearch:SetText("Search")
	btnSearch.DoClick = function()
		clearEventsSelection( pnl )
		selectLinesByString( playerDropdown:GetOptionText(selectedPlayer), pnl )
	end
	pnl.btnsearch = btnSearch
	
	local btnRDM = vgui.Create("DButton", searchPanel)
	btnRDM:SetPos( lblSearch:GetWide() + playerDropdown:GetWide() + 20 + bw, 5)
	btnRDM:SetSize(bw, bh)
	btnRDM:SetText("Find RDM")
	btnRDM.DoClick = function()
		clearEventsSelection( pnl )
		selectLinesByRDM( pnl )
	end
	pnl.btnrdm = btnRDM
	
	if mid then
		local btnRefresh = vgui.Create("DButton", searchPanel)
		btnRefresh:SetSize(bw, bh)
		btnRefresh:SetImage("icon16/arrow_refresh.png")
		btnRefresh:SetText("")
		btnRefresh:SetTooltip("Refresh")
		btnRefresh.DoClick = function()
				RunConsoleCommand("ttt_show_damagelog")
		end
		pnl.btnrefresh = btnRefresh
	end
end

local function recreateScene( scene, line ) --basically just copying the Visualiser code completely
	if scene == nil then return end

	scene = von.deserialize( scene )
	
	local hit = scene.hit_trace
    local dur = 60
	local corpse = LocalPlayer()
	
   if hit and not scene.knife then --don't show the hit line for knives...
      local e = EffectData()
      e:SetEntity(corpse)
      e:SetStart(hit.StartPos)
      e:SetOrigin(hit.HitPos)
      e:SetMagnitude(hit.HitBox)
      e:SetScale(dur)

      util.Effect("recreate_shot", e)
   end

   local k = {"victim", "killer"}
   for i=1, scene.by do
	table.insert(k, "b" .. i)
   end
   
   for i=1, scene.co do
	table.insert(k, "c" .. i)
   end
   
   for _, dummy_key in pairs(k) do
      local dummy = scene[dummy_key]

	local att
	if dummy_key == "victim" then
		att = 0
	elseif dummy_key == "killer" then
		att = 1
		net.Start("recreate_move")
			net.WriteVector( dummy.pos )
			net.WriteAngle( scene.look )
		net.SendToServer()
	elseif string.sub(dummy_key, 1, 1) == "c" then
		att = 3
	else
		att = 2
	end
	  
      if dummy then
         local e = EffectData()
         e:SetEntity(corpse)
         e:SetOrigin(dummy.pos)
		 if att != 3 then
			e:SetAngles(dummy.ang)
			e:SetColor(dummy.sequence)
			e:SetScale(dummy.cycle)
			e:SetStart(Vector(dummy.aim_yaw, dummy.aim_pitch, dummy.move_yaw))
		 end
         e:SetRadius(dur)
		 e:SetAttachment(att) --victim or attacker

			util.Effect("recreate_dummy", e)
		 if att != 3 then
			dummy.pos.z = dummy.pos.z + 45 --adjust for name drawing
		 end
		 
		 local role = dummy["1"]
		 if role == 1 then
			role = "Killer"
		 elseif role == 2 then
			role = "Victim"
		 elseif role == 3 then
			role = "Bystander"
		 end
		 table.insert(sceneDummies, {dummy.pos, role, dummy["2"], CurTime(), dummy["3"]})
      end
   end
end

local function rightClickDetailed( listview, panel, line )
	local list_line = listview:GetLine(line)
	
	local menu = DermaMenu()
	local message = Format("%s - %s", list_line:GetColumnText(1), list_line:GetColumnText(5))
	menu:AddOption("Copy Line", function() SetClipboardText(message) chat.AddText(Color(0, 255, 0), "Copied '" .. message .. "' to clipboard") end)
	if list_line:GetColumnText(9) != "" then
		menu:AddSpacer()
		local info = von.deserialize(list_line:GetColumnText(9))
		local players = string.Explode("|_|", list_line:GetColumnText(6))
		menu:AddOption("Victim Info (" .. players[2] .. "):")
		if info.VicShot != nil then
			if info.VicShot[2] == "a crowbar" then
				local msg = Format("Victim's last swing was %s seconds before, using %s", info.VicShot[1], info.VicShot[2])
				menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
			elseif info.VicShot[2] == "knife" then
				local msg = Format("Victim's last stab was %s seconds before, using a knife", info.VicShot[1])
				menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
			elseif info.VicShot[2] == "thrownknife" then
				local msg = Format("Victim's last throw was %s seconds before, using a knife", info.VicShot[1])
				menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
			else
				local msg = Format("Victim's last shot was %s seconds before, using %s", info.VicShot[1], info.VicShot[2])
				menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
			end
		else
			local msg = "Victim hadn't shot"
			menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
		end
		if info.VicDisguise != nil then
			local msg = Format("Victim %s disguised", info.VicDisguise and "was" or "wasn't")
			menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
		end
		if info.VicWeapon != nil then
			local msg
			if info.VicWeapon == "weapon_ttt_unarmed" then
				msg = "Victim was unarmed"
			else
				msg = Format("Victim was holding %s", info.VicWeapon)
			end
			menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
		end
		
		local msg
		if info.VicKills[1] == 0 and info.VicKills[2] == 0 then
			msg = "Victim hadn't killed anyone"
		else
			msg = "Victim had killed " .. info.VicKills[1] .. (info.VicKills[1] == 1 and " innocent" or " innocents" ) .. " and " .. info.VicKills[2] .. (info.VicKills[2] == 1 and " traitor" or " traitors")
		end
		menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
		
		menu:AddSpacer()
		menu:AddOption("Attacker Info (" .. players[1] .. "):")
		local msg = Format("Attacker %s DNA on the victim", info.AttDNA and "had" or "didn't have")
		menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
		
		local msg
		if info.AttKills[1] == 0 and info.AttKills[2] == 0 then
			msg = "Attacker hadn't killed anyone"
		else
			msg = "Attacker had killed " .. info.AttKills[1] .. (info.AttKills[1] == 1 and " innocent" or " innocents" ) .. " and " .. info.AttKills[2] .. (info.AttKills[2] == 1 and " traitor" or " traitors")
		end
		menu:AddOption("  " .. msg, function() SetClipboardText(msg) chat.AddText(Color(0, 255, 0), "Copied '" .. msg .. "' to clipboard") end)
		
		menu:AddSpacer()
		
		if list_line:GetColumnText(10) != "" then
			menu:AddOption("Recreate Death", function() recreateScene( list_line:GetColumnText(10), message ) end)
		end
		
		local plyids = von.deserialize(list_line:GetColumnText(11))
		local typ = list_line:GetColumnText(3)
		if plyids[2] == LocalPlayer():SteamID() and (typ == "damaged" or typ == "killed") and  --involves you and is a damage or kill event
		not (list_line:GetColumnText(2).Tooltip == "Traitor" and list_line:GetColumnText(4).Tooltip != "Traitor")  --isn't a traitor damaging/killing an innocent
		and panel.Info[1] == game.GetMap() and panel.Info[2] == GetGlobalInt("ttt_current_round", 0) --happened in the current round on this map
		then
			if list_line:GetColumnText(10) != "" then menu:AddSpacer() end
			local tab = { Details = list_line:GetColumnText(5), IDs = plyids, Nicks = players, Type = typ, Info = panel.Info }
			if typ == "damaged" then
				menu:AddOption("Report as Attempted RDM", function() OpenReportDialog( tab ) end):SetTextColor(Color(255,0,0))
			elseif typ == "killed" then
				menu:AddOption("Report as RDM", function() OpenReportDialog( tab ) end):SetTextColor(Color(255,0,0))
			end
		end
		
		if PCHAT and (LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin()) then
			local plys = string.Implode(",", players)
			if ulx then
				menu:AddOption("Start Chat", function() RunConsoleCommand("ulx", "chat", plys) end)
			elseif exsto then
				menu:AddOption("Start Chat", function() RunConsoleCommand("exsto", "chat", plys) end)
			end
		end
	end
	menu:Open()
end

function setupDetailedEvents( frm )
		local w,h =  frm:GetSize()
		local bw,bh = 109, 25
		
		local detlist = vgui.Create("DListView", frm)
		detlist:SetPos(0, 0)
		detlist:SetSize(w, h-bh-30)
		detlist:SetSortable(true)
		detlist:SetMultiSelect(true)
		detlist.OnClickLine = function(parent, line, isselected)
		end
		detlist:SetDataHeight( 16 )
		detlist.OnRowRightClick = function( panel, line )
			rightClickDetailed( detlist, panel, line )
		end
		
		addSearchBar( frm, detlist, false )
		setUpLogColumns( detlist, 16 )
		
		return detlist
end

local function checkForRDM( att, vic )
	if att == vic then return 1 end
	if att == "Innocent" and vic == "Detective" then return 1 end
	if att == "Detective" and vic == "Innocent" then return 1 end
	return 0
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local function parseDamageLogToPanel( pnl, log )
	local listLength = 0
	
	local playerDropdown = pnl.dropdown
	if playerDropdown != nil then playerDropdown:Clear() end
	
	pnl:Clear()
	
	pnl.Info = log.Info
	
	local invPlayers = {}
	for a, event in pairs( log ) do
		if a == "Info" then continue end
		local events = von.deserialize( event )
		
		local eventTime = events[1]
		local eventType = events[2]
		
		local mat1, mat2, tip1, tip2, eventDetails, plyNames, extraInfo, sceneInfo
		local isRDM = 0
		if eventType == DMG_LOG.DMG then
			eventType = "damaged"
			
			plyNames = events[3] .. "|_|" .. events[5]
			mat1,tip1 = getIconFeatures(events[4])
			mat2,tip2 = getIconFeatures(events[6])
			
			isRDM = checkForRDM(tip1, tip2)
			
			if events[8] == "push" then
				eventDetails =  Format("%s (%s) pushed %s (%s) for %s health", events[3], events[4], events[5], events[6], events[7], events[8])
			elseif events[8] == "goomba stomp" then
				eventDetails = Format("%s (%s) stomped %s (%s) for %s health", events[3], events[4], events[5], events[6], events[7], events[8])
			else
				eventDetails = Format("%s (%s) damaged %s (%s) for %s health with %s", events[3], events[4], events[5], events[6], events[7], events[8])
			end
			extraInfo = von.serialize(events[9])
		elseif eventType == DMG_LOG.KILL then
			eventType = "killed"
			plyNames = events[3] .. "|_|" .. events[5]
			mat1,tip1 = getIconFeatures(events[4])
			mat2,tip2 = getIconFeatures(events[6])
			
			local tempLine = pnl:GetLine(listLength)
			if events[3] == events[5] then --if the attacker and victim are the same (suicide or slay)
				if tempLine:GetColumnText(3) == "moved" and string.find(tempLine:GetColumnText(5), events[3], 1, true) != nil then continue end
				eventType = "suicided"
				eventDetails = Format("%s (%s) killed themself", events[3], events[4], events[7] != "unknown" and (" with " .. events[7]) or "")
			else
				extraInfo = von.serialize(events[8])
				sceneInfo = events[9]
				isRDM = checkForRDM(tip1, tip2)
				if tip1 == "Traitor" and tip2 == "Traitor" and (events[7] == "C4" or events[7] == "a S.L.A.M.") then isRDM = false end --kill a fellow traitor with C4/SLAM? not rdm
				if tempLine:GetColumnText(3) == "damaged" and string.find(tempLine:GetColumnText(5), events[3], 1, true) != nil then 
					extraInfo = tempLine:GetColumnText(9)
					pnl:RemoveLine(listLength)
					listLength = listLength - 1
				end
				if events[7] == "push" then
					eventDetails = Format("%s (%s) pushed %s (%s) to their death", events[3], events[4], events[5], events[6])
				elseif events[7] == "a knife" then
					eventDetails = Format("%s (%s) stabbed %s (%s)", events[3], events[4], events[5], events[6])
				elseif events[7] == "goomba stomp" then
					eventDetails = Format("%s (%s) stomped %s (%s) to death", events[3], events[4], events[5], events[6])
				else
					eventDetails = Format("%s (%s) killed %s (%s) with %s", events[3], events[4], events[5], events[6], events[7])
				end
			end	
		elseif eventType == DMG_LOG.WORLDKILL then
			eventType = "killed"
			plyNames = events[3]
			mat1 = "icon16/world.png"
			tip1 = "World"
			mat2,tip2 = getIconFeatures(events[4])
			eventDetails = Format("<something/world> killed %s (%s)", events[3], events[4])
		elseif eventType == DMG_LOG.FALL then
			eventType = "fell"
			mat1,tip1 = getIconFeatures(events[4])
			mat2 = "icon16/world.png"
			tip2 = "World"
			plyNames = events[3]
			
			local tempLine = pnl:GetLine(listLength)
			if tempLine != nil and string.find(tempLine:GetColumnText(5), events[3], 1, true) != nil and (string.find(tempLine:GetColumnText(5), events[5]+1, 1, true) != nil or string.find(tempLine:GetColumnText(5), "to their death", 1, true) != nil) then continue end
			eventDetails = Format("%s (%s) fell for %s damage", events[3], events[4], events[5])
		elseif eventType == DMG_LOG.SLAY then
			plyNames = events[3] .. "|_|" .. events[4]
			tip1 = "Mod/Admin"
			mat1 = "icon16/shield.png"
			mat2,tip2 = getIconFeatures(events[5])
			
			eventType = "slayed"
			local tempLine = pnl:GetLine(listLength)
			if tempLine != nil and tempLine:GetColumnText(3) == "suicided" and string.find(tempLine:GetColumnText(5), events[4], 1, true) != nil then
				pnl:RemoveLine(listLength)
				listLength = listLength - 1
			end
			
			if events[6] != "" and events[6] != nil and type(events[6]) != "table" then
				eventDetails = Format("%s slayed %s (%s) for %s", events[3], events[4], events[5], events[6])
			else
				eventDetails = Format("%s slayed %s (%s)", events[3], events[4], events[5])
			end
		elseif eventType == DMG_LOG.SPEC then
			plyNames = events[4]
			tip1 = "Mod/Admin"
			mat1 = "icon16/shield.png"
			mat2,tip2 = getIconFeatures(events[5])
			eventType = "moved"
			
			local tempLine = pnl:GetLine(listLength)
			if tempLine != nil and tempLine:GetColumnText(3) == "suicided" and string.find(tempLine:GetColumnText(5), events[4], 1, true) != nil then
				pnl:RemoveLine(listLength)
				listLength = listLength - 1
			end
			eventDetails = Format("%s moved %s (%s) to spectator after %i seconds", events[3], events[4], events[5], events[6])
		elseif eventType == DMG_LOG.SPECAUTO then
			plyNames = events[3]
			tip1 = "World"
			mat1 = "icon16/world.png"
			mat2,tip2 = getIconFeatures(events[4])
			eventType = "moved"
			local tempLine = pnl:GetLine(listLength)
			if tempLine != nil and tempLine:GetColumnText(3) == "suicided" and string.find(tempLine:GetColumnText(5), events[4], 1, true) != nil then
				pnl:RemoveLine(listLength)
				listLength = listLength - 1
			end
			eventDetails = Format("%s (%s) was automatically moved to spectator after %i seconds", events[3], events[4], events[5])	
		elseif eventType == DMG_LOG.GAME then
			local round = string.Explode(" ", events[3])
			round = round[1]
			
			if round == "Round" then
				eventType = "started"
				mat1 = "icon16/application.png"
				tip1 = "Round"
			elseif round == "Innocents" then
				eventType = "won"
				mat1,tip1 = getIconFeatures("innocent")
				tip1 = "Innocents"
			elseif round == "Traitors" then
				eventType = "won"
				mat1,tip1 = getIconFeatures("traitor")
				tip1 = "Innocents"
			else
				eventType = "game"
				mat1 = "icon16/application.png"
				tip1 = "Round"
			end
			
			mat2 = "icon16/application.png"
			tip2 = "Round"
			eventDetails = events[3]
		elseif eventType == DMG_LOG.C4 then
			plyNames = events[4]
			mat1,tip1 = getIconFeatures(events[5])
			mat2 = "icon16/bomb.png"
			tip2 = "C4"
			
			if events[3] == "ARM" then
				eventType = "armed"
				eventDetails = Format("%s (%s) armed C4 for %s seconds", events[4], events[5], events[6])
			elseif events[3] == "DESTROY" then
				eventType = "destroyed"
				eventDetails = Format("%s (%s) destroyed %s's C4", events[4], events[5], events[6])
				plyNames = events[4] .. "|_|" .. events[6]
			elseif events[3] == "DISARM" then
				eventType = "disarmed"
				eventDetails = Format("%s (%s) disarmed %s's C4", events[4], events[5], events[6])
				plyNames = events[4] .. "|_|" .. events[6]
			elseif events[3] == "FAILED" then
				eventType = "failed"
				eventDetails = Format("%s (%s) failed to disarm %s's C4", events[4], events[5], events[6])
				plyNames = events[4] .. "|_|" .. events[6]
				isRDM = 1
			elseif events[3] == "EXPLODE" then
				eventType = "exploded"
				eventDetails = Format("The C4 planted by %s (%s) exploded", events[4], events[5])
			end
		elseif eventType == DMG_LOG.BOMBSTATION then
			plyNames = events[4]
			mat1,tip1 = getIconFeatures(events[5])
			mat2 = "icon16/bomb.png"
			tip2 = "Bomb Station"
			
			if events[3] == "PLANT" then
				eventType = "planted"
				eventDetails = Format("%s (%s) planted a bomb station", events[4], events[5])
			elseif events[3] == "DESTROY" then
				eventType = "destroyed"
				eventDetails = Format("%s (%s) destroyed %s's bomb station", events[4], events[5], events[6])
				plyNames = events[4] .. "|_|" .. events[6]
			elseif events[3] == "TRIP" then
				plyNames = events[4] .. "|_|" .. events[6]
				eventType = "tripped"
				eventDetails = Format("%s (%s) tripped %s's bomb station", events[4], events[5], events[6])
			end
		elseif eventType == DMG_LOG.BODY_FOUND then
			eventType = "found"
			mat1,tip1 = getIconFeatures(events[4])
			mat2,tip2 = getIconFeatures(events[6])
			plyNames = events[3] .. "|_|" .. events[5]
			eventDetails = Format("%s (%s) found the corpse of %s (%s)", events[3], events[4], events[5], events[6])
		elseif eventType == DMG_LOG.BODY_BURNT then
			eventType = "burned"
			mat1,tip1 = getIconFeatures(events[4])
			mat2,tip2 = getIconFeatures(events[6])
			plyNames = events[3] .. "|_|" .. events[5]
			eventDetails = Format("%s (%s) burned the corpse of %s (%s)", events[3], events[4], events[5], events[6])
		elseif eventType == DMG_LOG.DNA_BODY then
			eventType = "dna"
			mat1,tip1 = getIconFeatures(events[4])
			mat2,tip2 = getIconFeatures(events[6])
			plyNames = events[3] .. "|_|" .. events[5]
			
			eventDetails = Format("%s (%s) retrieved DNA of %s (%s) from the corpse of %s (%s)", events[3], events[4], events[5], events[6], events[7], events[8])
		elseif eventType == DMG_LOG.DNA_OBJECT then
			eventType = "dna"
			mat1,tip1 = getIconFeatures(events[4])
			mat2,tip2 = getIconFeatures(events[6])
			plyNames = events[3] .. "|_|" .. events[5]
			
			eventDetails = Format("%s (%s) retrieved DNA of %s (%s) from %s", events[3], events[4], events[5], events[6], events[7])
		elseif eventType == DMG_LOG.BOUGHT_ROLE then
			eventType = "bought"
			tip1 = "Player"
			mat1 = "icon16/user.png"
			mat2,tip2 = getIconFeatures(events[4])
			plyNames = events[3]
			if tip2 == "Detective" then
				eventDetails = Format("%s bought detective for 8 points", events[3])
			else
				eventDetails = Format("%s bought traitor for 20 points", events[3])
			end
		elseif eventType == DMG_LOG.FOUND_CREDITS then
			eventType = "found"
			mat1,tip1 = getIconFeatures(events[4])
			mat2 = "icon16/coins.png"
			tip2 = "Credits"
			
			plyNames = events[3] .. "|_|" .. events[5]
			eventDetails = Format("%s (%s) found %s %s on the body of %s", events[3], events[4], events[6], tonumber(events[6]) == 1 and "credit" or "credits", events[5])
		elseif eventType == DMG_LOG.HEALTH_PLANT then
			mat1,tip1 = getIconFeatures(events[4])
			mat2 = "icon16/heart.png"
			tip2 = "Health Station"
			
			plyNames = events[3]
			
			eventType = "planted"
			eventDetails = Format("%s (%s) put down a health station", events[3], events[4])
		elseif eventType == DMG_LOG.HEALTH_DMG then
			mat1,tip1 = getIconFeatures(events[4])
			mat2 = "icon16/heart.png"
			tip2 = "Health Station"
			
			if tip1 == "Innocent" then isRDM = 1 end
			
			plyNames = events[3] .. "|_|" .. events[5]
			
			eventType = "damaged"
			eventDetails = Format("%s (%s) damaged %s's health station for %s health", events[3], events[4], events[5], events[6])
		elseif eventType == DMG_LOG.HEALTH_DESTROY then
			mat1,tip1 = getIconFeatures(events[4])
			mat2 = "icon16/heart.png"
			tip2 = "Health Station"
			
			if tip1 == "Innocent" then isRDM = 1 end
			
			plyNames = events[3] .. "|_|" .. events[5]
			
			eventType = "destroyed"
			eventDetails = Format("%s (%s) destroyed %s's health station", events[3], events[4], events[5])
		elseif eventType == DMG_LOG.SLAY_TRAITOR then
			plyNames = events[3]
			tip1 = "World"
			mat1 = "icon16/world.png"
			mat2,tip2 = getIconFeatures(events[3])
			
			eventType = "slayed"
			local tempLine = pnl:GetLine(listLength)
			if tempLine != nil and tempLine:GetColumnText(3) == "suicided" and string.find(tempLine:GetColumnText(5), events[3], 1, true) != nil then
				pnl:RemoveLine(listLength)
				listLength = listLength - 1
			end
			
			eventDetails = Format("%s (traitor) was slain for inactivity", events[3])
		elseif eventType == DMG_LOG.SLAM_DAMAGE then
			plyNames = events[3] .. "|_|" .. events[5]
			
			mat1,tip1 = getIconFeatures(events[4])
			tip2 = "S.L.A.M."
			mat2 = "icon16/bomb.png"
			
			eventType = "damaged"
			
			eventDetails = Format("%s (%s) damaged %s's (%s) S.L.A.M.", events[3], events[4], events[5], events[6])
		elseif eventType == DMG_LOG.SLAM_DEFUSED then
			plyNames = events[3] .. "|_|" .. events[5]
			
			mat1,tip1 = getIconFeatures(events[4])
			tip2 = "S.L.A.M."
			mat2 = "icon16/bomb.png"
			
			eventType = "defused"
			
			eventDetails = Format("%s (%s) defused %s's (%s) S.L.A.M.", events[3], events[4], events[5], events[6])
		elseif eventType == DMG_LOG.SLAM_TRIP then
			plyNames = events[3] .. "|_|" .. events[5]
			
			mat1,tip1 = getIconFeatures(events[4])
			tip2 = "S.L.A.M."
			mat2 = "icon16/bomb.png"
			
			eventType = "tripped"
			
			eventDetails = Format("%s (%s) tripped %s's (%s) S.L.A.M.", events[3], events[4], events[5], events[6])
		end
		
		local icon1 = vgui.Create("DImage")
		icon1:SetMaterial(mat1) icon1:SetTooltip(tip1) icon1.Tooltip = tip1
		local icon2 = vgui.Create("DImage")
		icon2:SetMaterial(mat2) icon2:SetTooltip(tip2) icon2.Tooltip = tip2
		
		local line = pnl:AddLine(eventTime, icon1, eventType, icon2, eventDetails, plyNames, isRDM, tip1 != nil and (tip1 .. "_" .. tip2), extraInfo or "", (sceneInfo != nil and von.serialize(sceneInfo) or ""), von.serialize((type(events[#events]) == "table" and events[#events] or {})))
	
		for k, col in pairs(line.Columns) do -- center the event column
			if k == 3 then col:SetContentAlignment(5) break end
        end
		listLength = listLength + 1
		
		if life then
			if events[2] == DMG_LOG.KILL then
				line.Paint = function()
					surface.SetDrawColor(255,210,210)
					surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
				end
			elseif events[2] == DMG_LOG.DMG then
				line.Paint = function()
					surface.SetDrawColor(255,230,230)
					surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
				end
			elseif events[2] == DMG_LOG.DNA_BODY or events[2] == DMG_LOG.DNA_OBJECT then
				line.Paint = function()
					surface.SetDrawColor(197,226,255)
					surface.DrawRect(0, 0, line:GetWide(), line:GetTall())
				end
			end
		end
		
		if not life then
			if pnl.IDs == nil then
				if plyNames != "" and plyNames != nil and not life then --automatically select lines about the calling player
					local plys = string.Explode("|_|", plyNames)
					for _,v in pairs(plys) do
						invPlayers[v] = true --add the players to the involved players table, poor code but fuck me
					end
					if plys[1] == LocalPlayer():Nick() or plys[2] == LocalPlayer():Nick() then
						pnl:SelectItem(pnl:GetLine(listLength))
					end
				end
			else
				local ids = events[#events]
				if type(ids) == "table" then
					local col
					if table.contains(pnl.IDs, ids[1]) and table.contains(pnl.IDs, ids[2]) and (ids[1] != ids[2]) then
						col = Color(255, 166, 166)
						if scrollto == 0 then scrollto = 16 * (listLength-1) end
					elseif table.contains(ids, pnl.IDs[1]) then
						col = Color(0,157,255)
					elseif table.contains(ids, pnl.IDs[2]) then
						col = Color(150,255,102)
					end
					if col != nil then line.Paint = function() surface.SetDrawColor(col.r, col.g, col.b, 200)
					surface.DrawRect(0, 0, line:GetWide(), line:GetTall()) end end
				end
			end
		end
	end
	
	local invPlayers2 = {}
	invPlayers[LocalPlayer():Nick()] = true
	for k,_ in pairs(invPlayers) do
		table.insert(invPlayers2, k)
	end
	table.sort(invPlayers2)
	if playerDropdown != nil then
	for i,v in pairs(invPlayers2) do --populate the dropdown box
		if v == nil then continue end
		playerDropdown:AddChoice( v )
		if v == LocalPlayer():Nick() then
			playerDropdown:ChooseOption( v )
			selectedPlayer = i
		end
	end end
end


logFrame = nil
local dlbuff = ""

function DamageLogHook(damagelog, info, num)
	if num == 1 or num == 2 then --print to standalone panel
		if logFrame != nil and logFrame:IsVisible() then
			if ids != nil then logFrame:Remove() else
			logFrame:SetTitle( (num == 1 and "Detailed Events" or "Previous Detailed Events") .. " - " .. "Round " .. info[2] .. " on " .. info[1])
			logFrame.DType = num
			parseDamageLogToPanel( logFrame.logs, damagelog )
			logFrame:InvalidateLayout()
			return
			end
		end
		
		logFrame = vgui.Create("DFrame")
		local w,h = 640, 500
		logFrame:SetSize(w, h)
		logFrame:Center()
		logFrame:SetTitle( (num == 1 and "Detailed Events" or "Previous Detailed Events") .. " - " .. "Round " .. info[2] .. " on " .. info[1])
		if ids == nil then
			logFrame.DType = num
		else
			logFrame.DType = -1
			logFrame:SetSize(540, 350)
			logFrame:Center()
			local x,y = logFrame:GetPos()
			logFrame:SetPos(x, y-100-5)
			logFrame.IDs = ids
		end
		
		local logList = vgui.Create("DListView", logFrame)
		logList:SetPos(0, 0)
		logList:StretchToParent(10, 30, 10, 45)
		logList:SetSortable(true)
		logList:SetMultiSelect(true)
		logList:SetDataHeight(16)
		logList.OnClickLine = function()
		end
		logList.OnRowRightClick = function( panel, line )
			rightClickDetailed( logList, panel, line )
		end
		if ids != nil then logList.IDs = ids end
		logFrame.logs = logList
		
		setUpLogColumns( logList, 16 )
		if ids == nil then
			addSearchBar( logFrame, logList, true ) 
		end
		parseDamageLogToPanel( logList, damagelog )
		
		logFrame:SetKeyboardInputEnabled(false)
		logFrame:SetSizable(true)
		logFrame:SetMinWidth(200)
		logFrame:SetMinHeight(150)
		
		logFrame.PerformLayout = function( pnl )
			pnl.btnClose:SetPos( pnl:GetWide() - 31 - 4, 0 )
			pnl.btnClose:SetSize( 31, 31 )
			pnl.btnMaxim:SetPos( pnl:GetWide() - 31*2 - 4, 0 )
			pnl.btnMaxim:SetSize( 31, 31 )
			pnl.btnMinim:SetPos( pnl:GetWide() - 31*3 - 4, 0 )
			pnl.btnMinim:SetSize( 31, 31 )
		
			if pnl.searchpnl != nil then
				pnl.searchpnl:SetWide(pnl:GetWide() - 20)
				pnl.searchpnl:SetPos(10, pnl:GetTall() - 10 - pnl.searchpnl:GetTall())
			end
			
			pnl.logs:SetSize(pnl:GetWide() - 20, pnl:GetTall() - 40 - (pnl.searchpnl != nil and pnl.searchpnl:GetTall() or 0))
			pnl.logs.eventCol:SetFixedWidth(math.max(pnl.logs:GetWide()-110-16*2, 10))
			
			if pnl.logs.dropdown != nil then
				pnl.logs.dropdown:SetWide(math.max(70, pnl.searchpnl:GetWide() / 3))
			end
			
			if pnl.DType == 2 then
				local w = (pnl.searchpnl:GetWide() - (pnl.logs.lblsearch:GetWide() + 12 + pnl.logs.dropdown:GetWide())) / 3 - 6
				pnl.logs.btnclear:SetWide(w)
				pnl.logs.btnrdm:SetWide(w)
				pnl.logs.btnsearch:SetWide(w)
				pnl.logs.btnrefresh:SetSize(0,0)
				
				pnl.logs.btnclear:SetPos(pnl.searchpnl:GetWide() - w - 4, 5)
				pnl.logs.btnrdm:SetPos(pnl.searchpnl:GetWide() - w*2 - 8, 5)
				pnl.logs.btnsearch:SetPos(pnl.searchpnl:GetWide() - w*3 - 13, 5)
			elseif pnl.DType == 1 then
				local w = (pnl.searchpnl:GetWide() - (pnl.logs.lblsearch:GetWide() + 12 + pnl.logs.dropdown:GetWide())) / 3 - 13
				pnl.logs.btnclear:SetWide(w)
				pnl.logs.btnrdm:SetWide(w)
				pnl.logs.btnsearch:SetWide(w)
				pnl.logs.btnrefresh:SetSize(24, pnl.logs.btnclear:GetTall())
				pnl.logs.btnrefresh:SetPos(pnl.searchpnl:GetWide() - 24 - 3, 5)
				
				pnl.logs.btnclear:SetPos(pnl.searchpnl:GetWide() - w - 27 - 3, 5)
				pnl.logs.btnrdm:SetPos(pnl.searchpnl:GetWide() - w*2 - 27 - 6, 5)
				pnl.logs.btnsearch:SetPos(pnl.searchpnl:GetWide() - w*3 - 27 - 9, 5)
			end
		end
		
		logFrame.btnClose.DoClick = function()
			gui.EnableScreenClicker(false) --enable mouse
			GAMEMODE.ForcedMouse = false
			logFrame:Close()
		end
		
		logFrame.btnMinim:SetDisabled(false)
		logFrame.btnMaxim:SetDisabled(false)
		
		logFrame.btnMinim.DoClick = function()
			logFrame:MoveTo( ScrW() - logFrame:GetWide(), ScrH() - 22, 0.3, 0, 1 )
			gui.EnableScreenClicker(false) --enable mouse
			GAMEMODE.ForcedMouse = false
		end
		logFrame.btnMaxim.DoClick = function()
			logFrame:SizeTo(w, h, 0.6, 0, 1)
			logFrame:MoveTo(ScrW() / 2 - (w/2), ScrH() / 2 - (h/2), 0.3, 0, 1)
		end
		
		gui.EnableScreenClicker(true) --enable mouse
        GAMEMODE.ForcedMouse = true
	else
		if detbackpanel != nil and detbackpanel:IsVisible() then
			detbackpanel:Remove()

			parseDamageLogToPanel( detlist, damagelog )
		end
	end
end

net.Receive( "DamageLogHook", function( length )
	local cont = net.ReadBit() == 1
	
	dlbuff = dlbuff .. net.ReadString()
	
	if cont then return end
	
	local num = net.ReadInt(8)
	local damagelog = von.deserialize(dlbuff)
	dlbuff = ""
	
	local info = damagelog.Info
	
	DamageLogHook(damagelog, info, num)
end)

local function paintDummies()
	if #sceneDummies != 0 then
		for i,v in pairs(sceneDummies) do
			local p = v[1]
			local role = v[2]
			local name = v[3]
			local pos = p:ToScreen()
			local distance = (p-LocalPlayer():GetShootPos()):Length()
			if distance <= 500 then
				local alpha = math.Clamp(500-distance,0,255)
				draw.DrawText(role, "TargetIDSmall", pos.x, pos.y - 5, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) 
				draw.DrawText(name, "DefaultBold", pos.x, pos.y + 9, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) 
				if v[5] != nil then
					draw.DrawText(v[5], "DefaultBold", pos.x, pos.y + 22, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) 
				end
			end
			if (CurTime() - v[4]) >= 10 then --remove after 10 seconds
				table.remove(sceneDummies, i)
			end
		end
	end
end
hook.Add("HUDPaint","paintDummies",paintDummies)

local keyDown = false
hook.Add("Think", "DetectF8", function()
	if input.IsKeyDown( KEY_F8 ) then
		if keyDown then return end
		RunConsoleCommand("ttt_show_damagelog")
		keyDown = true
	else
		keyDown = false
	end
end)