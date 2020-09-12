WPNSELECTION = {}
local frmWeapons
local current

function WPNSELECTION:SelectWep(group, wep)
	if frmWeapons == nil then return end

	local wlist local text
	
	if group == 1 then wlist = mdlPrimary text = lblSelPrimary
	elseif group == 2 then wlist = mdlSecondary text = lblSelSecondary
	elseif group == 3 then wlist = mdlGrenade text = lblSelGrenade end
	
	if wlist == nil then return end
	local items = wlist:GetItems()
	for _,item in pairs(items) do
		if item.icon.class == wep then
			text:SetAlpha(0)
			item.selected = true
			text:SetText(string.upper(item.icon.name))
			text:AlphaTo(255, 0.2, 0)
		else
			item.selected = false
		end
	end
end

function WPNSELECTION:UnselectWep(group, wep)
	if frmWeapons == nil then return end

	local wlist local text
	
	if group == 1 then wlist = mdlPrimary text = lblSelPrimary
	elseif group == 2 then wlist = mdlSecondary text = lblSelSecondary
	elseif group == 3 then wlist = mdlGrenade text = lblSelGrenade end
	
	local items = wlist:GetItems()
	for _,item in pairs(items) do
		if item.icon.class == wep then
			item.selected = false
			text:AlphaTo(0, 0.05, 0)
		end
	end
end

function WPNSELECTION:Show()
	local ply = LocalPlayer()

	local w = 444
	local bw,bh = 75,23
	
	local margin, padding, shadow = 6, 4, 2
	
	local hh = 25
	local iconsize = 64
	local gpadding = 4
	local gh = iconsize + gpadding*2+2
	local cw = w - margin*2 - padding*2
	
	local h = (22 + margin*3 + bh + hh*2 + padding*5 + gh*2) + (WEAPONSELECTION_PRIMARIES_2ROWS and (gh-gpadding*2) or 0)

	frmWeapons = vgui.Create("DFrame")
	frmWeapons:SetTitle("Donator Weapon Selection Menu")
	frmWeapons:SetSize(w,h)
	frmWeapons:Center()
	
	local btnSave = vgui.Create("DButton", frmWeapons)
	btnSave:SetSize(bw, bh)
	btnSave:SetText("Save (" .. input.GetKeyName(WEAPONSELECTION_KEY) .. ")")
	btnSave:SetPos(w - bw - margin, h - bh - margin)
	btnSave.DoClick = function()
		self:Save()
	end
	
	local btnCancel = vgui.Create("DButton", frmWeapons)
	btnCancel:SetSize(bw, bh)
	btnCancel:SetText("Cancel")
	btnCancel:SetPos(margin, h - bh - margin)
	btnCancel.DoClick = function()
		frmWeapons:Remove()
	end
	
	local pnlContent = vgui.Create("DPanel", frmWeapons)
	pnlContent:StretchToParent(margin, 22 + margin, margin, margin*2 + bh - 2)
	pnlContent.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(75,75,75,255)) end
	
	local y = padding
	
	local hdrPrimary = vgui.Create("DPanel", pnlContent)
	hdrPrimary:SetSize(cw, hh)
	hdrPrimary:SetPos(padding,y)
	hdrPrimary.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(50,50,50,255)) draw.RoundedBox(2, 0, 0, w, h-shadow, Color(55,55,55,255)) end
	local lblPrimary = vgui.Create("DLabel", hdrPrimary) lblPrimary:SetText("PRIMARY") lblPrimary:SetFont("SelectionHeader") lblPrimary:StretchToParent(5,0,0,0) lblPrimary:SetContentAlignment(4)
	lblSelPrimary = vgui.Create("DLabel", hdrPrimary) lblSelPrimary:SetText("") lblSelPrimary:SetFont("SelectionCurrent") lblSelPrimary:StretchToParent(0, 0, 5, 1) lblSelPrimary:SetContentAlignment(6)
	y = y + hh + padding
	local grpPrimary = vgui.Create("DPanel", pnlContent)
	grpPrimary:SetSize(cw, (WEAPONSELECTION_PRIMARIES_2ROWS and (gh*2-gpadding*2) or gh))
	grpPrimary:SetPos(padding, y)
	grpPrimary.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(55,55,55,255)) draw.RoundedBox(2, 0, 0, w, h-shadow, Color(60,60,60,255)) end
	mdlPrimary = vgui.Create("DPanelSelect", grpPrimary)
	mdlPrimary:StretchToParent(0,0,0,0)
	mdlPrimary:SetPadding(3)
	mdlPrimary:SetSpacing(1)
	for class,v in pairs(WEAPONSELECTION_PRIMARIES) do
		local pnl = vgui.Create("DPanel")
		pnl:SetSize(iconsize+2, iconsize+1)
		pnl.Paint = function(s, w, h) if s.selected then draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,150)) end end
		
		local icon = vgui.Create("DImageButton", pnl)
		icon:SetPos(1,1) icon:SetSize(iconsize, iconsize)
		local wep = weapons.Get(class) 
		if wep == nil then continue end
		icon:SetImage( wep.Icon )
		local name = LANG.TryTranslation(wep.PrintName or "...") icon:SetTooltip( name )
		icon.class = class
		icon.name = name
		icon.DoClick = function()
			if icon:GetParent().selected then
				self:UnselectWep(1, icon.class)
			else
				self:SelectWep(1, icon.class)
			end
		end
		pnl.icon = icon
		
		if not PlayerInGroups(v, ply) and CanPlayerSpawnWith(1, ply) then
			local disable = vgui.Create("DPanel", pnl)
			disable:StretchToParent(0,0,0,0)
			disable.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,180)) end
			local lbldisable = vgui.Create("DLabel", disable)
			lbldisable:StretchToParent(0,2,0,0)
			lbldisable:SetContentAlignment(5)
			lbldisable:SetText([[  VIP 
ONLY]])
			lbldisable:SetFont("SelectionDisabled2")
		end
		
		mdlPrimary:AddItem(pnl)
	end
	if not CanPlayerSpawnWith(1, ply) then
		local disable = vgui.Create("DPanel", grpPrimary)
		disable:StretchToParent(0,0,0,0)
		disable.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200)) end
		local lbldisable = vgui.Create("DLabel", disable)
		lbldisable:StretchToParent(0,0,0,0)
		lbldisable:SetContentAlignment(5)
		lbldisable:SetText(WEAPONSELECTION_DISABLED_MSG)
		lbldisable:SetFont("SelectionDisabled")
	end
	y = y + gh + padding + (WEAPONSELECTION_PRIMARIES_2ROWS and (gh-gpadding*2) or 0)
	
	local hdrSecondary = vgui.Create("DPanel", pnlContent)
	hdrSecondary:SetSize(cw/2 - padding/2, hh)
	hdrSecondary:SetPos(padding,y)
	hdrSecondary.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(50,50,50,255)) draw.RoundedBox(2, 0, 0, w, h-shadow, Color(55,55,55,255)) end
	local lblSecondary = vgui.Create("DLabel", hdrSecondary) lblSecondary:SetText("SECONDARY") lblSecondary:SetFont("SelectionHeader") lblSecondary:StretchToParent(5,0,0,0) lblSecondary:SetContentAlignment(4)
	lblSelSecondary = vgui.Create("DLabel", hdrSecondary) lblSelSecondary:SetText("") lblSelSecondary:SetFont("SelectionCurrent") lblSelSecondary:StretchToParent(0, 0, 5, 1) lblSelSecondary:SetContentAlignment(6)
	y = y + hh + padding
	local grpSecondary = vgui.Create("DPanel", pnlContent)
	grpSecondary:SetSize(hdrSecondary:GetWide(), gh)
	grpSecondary:SetPos(padding, y)
	grpSecondary.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(55,55,55,255)) draw.RoundedBox(2, 0, 0, w, h-shadow, Color(60,60,60,255)) end
	mdlSecondary = vgui.Create("DPanelSelect", grpSecondary)
	mdlSecondary:StretchToParent(0,0,0,0)
	mdlSecondary:SetPadding(gpadding)
	for class,v in pairs(WEAPONSELECTION_SECONDARIES) do
		local pnl = vgui.Create("DPanel")
		pnl:SetSize(iconsize+2, iconsize+1)
		pnl.Paint = function(s, w, h) if s.selected then draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,150)) end end
	
		local icon = vgui.Create("DImageButton", pnl)
		icon:SetPos(1,1) icon:SetSize(iconsize, iconsize)
		local wep = weapons.Get(class) 
		if wep == nil then continue end
		icon:SetImage( wep.Icon )
		local name = LANG.TryTranslation(wep.PrintName or "...") icon:SetTooltip( name )
		icon.class = class
		icon.name = name
		icon.DoClick = function()
			if icon:GetParent().selected then
				self:UnselectWep(2, icon.class)
			else
				self:SelectWep(2, icon.class)
			end
		end
		pnl.icon = icon
		
		if not PlayerInGroups(v, ply) and CanPlayerSpawnWith(2, ply) then
			local disable = vgui.Create("DPanel", pnl)
			disable:StretchToParent(0,0,0,0)
			disable.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,180)) end
			local lbldisable = vgui.Create("DLabel", disable)
			lbldisable:StretchToParent(0,2,0,0)
			lbldisable:SetContentAlignment(5)
			lbldisable:SetText([[  VIP 
ONLY]])
			lbldisable:SetFont("SelectionDisabled2")
		end
		
		mdlSecondary:AddItem(pnl)
	end
	if not CanPlayerSpawnWith(2, LocalPlayer()) then
		local disable = vgui.Create("DPanel", grpSecondary)
		disable:StretchToParent(0,0,0,0)
		disable.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200)) end
		local lbldisable = vgui.Create("DLabel", disable)
		lbldisable:StretchToParent(0,0,0,0)
		lbldisable:SetContentAlignment(5)
		lbldisable:SetText(WEAPONSELECTION_DISABLED_MSG)
		lbldisable:SetFont("SelectionDisabled")
	end
	y = y - hh - padding
	
	local hdrGrenade = vgui.Create("DPanel", pnlContent)
	hdrGrenade:SetSize(cw/2 - padding/2, hh)
	hdrGrenade:SetPos(grpSecondary:GetWide()+padding+padding,y)
	hdrGrenade.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(50,50,50,255)) draw.RoundedBox(2, 0, 0, w, h-shadow, Color(55,55,55,255)) end
	local lblGrenade = vgui.Create("DLabel", hdrGrenade) lblGrenade:SetText("GRENADE") lblGrenade:SetFont("SelectionHeader") lblGrenade:StretchToParent(5,0,0,0) lblGrenade:SetContentAlignment(4)
	lblSelGrenade = vgui.Create("DLabel", hdrGrenade) lblSelGrenade:SetText("") lblSelGrenade:SetFont("SelectionCurrent") lblSelGrenade:StretchToParent(0, 0, 5, 1) lblSelGrenade:SetContentAlignment(6)
	y = y + hh + padding
	local grpGrenade = vgui.Create("DPanel", pnlContent)
	grpGrenade:SetSize(hdrGrenade:GetWide(), gh)
	grpGrenade:SetPos(grpSecondary:GetWide()+padding+padding, y)
	grpGrenade.Paint = function(s, w, h) draw.RoundedBox(2, 0, 0, w, h, Color(55,55,55,255)) draw.RoundedBox(2, 0, 0, w, h-shadow, Color(60,60,60,255)) end
	mdlGrenade = vgui.Create("DPanelSelect", grpGrenade)
	mdlGrenade:StretchToParent(0,0,0,0)
	mdlGrenade:SetPadding(gpadding)
	for class,v in pairs(WEAPONSELECTION_GRENADES) do
		local pnl = vgui.Create("DPanel")
		pnl:SetSize(iconsize+2, iconsize+1)
		pnl.Paint = function(s, w, h) if s.selected then draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,150)) end end
	
		local icon = vgui.Create("DImageButton", pnl)
		icon:SetPos(1,1) icon:SetSize(iconsize, iconsize)
		local wep = weapons.Get(class) 
		if wep == nil then continue end
		local ic = wep.Icon
		local name = LANG.TryTranslation(wep.PrintName or "...") icon:SetTooltip( name )
		if name == "Discombobulator" then 
			name = "Discombob" ic = "VGUI/ttt/icon_spykr_discombob" 
		elseif name == "Smoke grenade" then 
			name = "Smoke" ic = "VGUI/ttt/icon_spykr_smoke" 
		elseif name == "Incendiary grenade" then 
			name = "Incendiary" ic = "VGUI/ttt/icon_spykr_incendiary" end
		icon:SetImage( ic )
		icon.class = class
		icon.name = name
		icon.DoClick = function()
			if icon:GetParent().selected then
				self:UnselectWep(3, icon.class)
			else
				self:SelectWep(3, icon.class)
			end
		end
		pnl.icon = icon
		
		if not PlayerInGroups(v, ply) and CanPlayerSpawnWith(3, ply) then
			local disable = vgui.Create("DPanel", pnl)
			disable:StretchToParent(0,0,0,0)
			disable.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,180)) end
			local lbldisable = vgui.Create("DLabel", disable)
			lbldisable:StretchToParent(0,2,0,0)
			lbldisable:SetContentAlignment(5)
			lbldisable:SetText([[  VIP 
ONLY]])
			lbldisable:SetFont("SelectionDisabled2")
		end
		
		mdlGrenade:AddItem(pnl)
	end
	if not CanPlayerSpawnWith(3, LocalPlayer()) then
		local disable = vgui.Create("DPanel", grpGrenade)
		disable:StretchToParent(0,0,0,0)
		disable.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200)) end
		local lbldisable = vgui.Create("DLabel", disable)
		lbldisable:StretchToParent(0,0,0,0)
		lbldisable:SetContentAlignment(5)
		lbldisable:SetText(WEAPONSELECTION_DISABLED_MSG)
		lbldisable:SetFont("SelectionDisabled")
	end
	y = y + gh + padding
	
	frmWeapons:MakePopup()
end

function WPNSELECTION:Save()
	if frmWeapons == nil then return end

	local primary = "" local secondary = "" local grenade = ""
	
	for _,item in pairs(mdlPrimary:GetItems()) do if item.selected then primary = item.icon.class end end
	
	for _,item in pairs(mdlSecondary:GetItems()) do if item.selected then secondary = item.icon.class end end
	
	for _,item in pairs(mdlGrenade:GetItems()) do if item.selected then grenade = item.icon.class end end
	
	if primary == current[1] and secondary == current[2] and grenade == current[3] then frmWeapons:Remove() return end
	
	net.Start("sv_saveweapons")
		net.WriteString(primary)
		net.WriteString(secondary)
		net.WriteString(grenade)
	net.SendToServer()

 	frmWeapons:Remove()
end

function WPNSELECTION:Toggle()
	if frmWeapons != nil and frmWeapons:IsVisible() then	
		self:Save()
	else
		self:Show()
		
		current = {}
	
		net.Start("sv_retrieveweapons")
		net.SendToServer()
	end
end

local keyDown = false
hook.Add("Think", "WeaponSelectionKey", function()
	if input.IsKeyDown( WEAPONSELECTION_KEY ) then
		if keyDown then return end
		WPNSELECTION:Toggle()
		keyDown = true
	else
		keyDown = false
	end
end)

net.Receive("cl_retrieveweapons", function()
	local primary = net.ReadString()
	local secondary = net.ReadString()
	local grenade = net.ReadString()
	
	current = { primary, secondary, grenade }
	
	if primary != "" and CanPlayerSpawnWith(1, LocalPlayer()) then WPNSELECTION:SelectWep(1, primary) end
	if secondary != "" and CanPlayerSpawnWith(2, LocalPlayer()) then WPNSELECTION:SelectWep(2, secondary) end
	if grenade != "" and CanPlayerSpawnWith(3, LocalPlayer()) then WPNSELECTION:SelectWep(3, grenade) end
end)

net.Receive("cl_chattext", function()
	local weps = net.ReadTable()
	
	local msg = {}
	if weps[1] == "" and weps[2] == "" and weps[3] == "" then
		msg = {Color(255,255,255), "You will now spawn with no weapons!"}
	else
		msg = {Color(255,255,255), "You will now spawn with the following: " }
		if weps[1] != "" then 
			local wep = weapons.Get(weps[1]) 
			local name = LANG.TryTranslation(wep.PrintName or "...")
			table.insert(msg, Color(151,211,255))
			table.insert(msg, name) 
			if weps[2] != "" and weps[3] != "" then
				table.insert(msg, Color(255,255,255)) table.insert(msg, ", ")
			elseif weps[2] != "" or weps[3] != "" then
				table.insert(msg, Color(255,255,255)) table.insert(msg, " and ")
			end
		end
		if weps[2] != "" then
			local wep = weapons.Get(weps[2]) 
			local name = LANG.TryTranslation(wep.PrintName or "...")
			table.insert(msg, Color(151,211,255))
			table.insert(msg, name) 
			if weps[3] != "" then
				table.insert(msg, Color(255,255,255)) table.insert(msg, " and ")
			end
		end
		if weps[3] != "" then
			local wep = weapons.Get(weps[3]) 
			local name = LANG.TryTranslation(wep.PrintName or "...")
			table.insert(msg, Color(151,211,255))
			table.insert(msg, name) 
		end
		table.insert(msg, Color(255,255,255)) table.insert(msg, ".")
	end
	
	chat.AddText(unpack(msg))
end)