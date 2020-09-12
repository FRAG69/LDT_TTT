include("gf_shared.lua")

local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid

------------------
--  PLAYER MISC --
------------------

local scrapMetal = 0
local storedRagdolls = {}

function GF:GetScrapMetal()
	return scrapMetal
end

hook.Add("OnEntityCreated", "GoldenForge:OnEntityCreated", function(entity)
	if (IsValid(entity) and entity.GetClass and entity:GetClass() == "class C_HL2MPRagdoll") then
		timer.Simple(0.1, function()
			for k, v in pairs(player.GetAll()) do
				if (!v:Alive() and IsValid(v:GetRagdollEntity()) and v:GetRagdollEntity() == entity) then
					table.insert(storedRagdolls, {ragdoll = entity, player = v})
				end
			end
		end)
	end
end)

usermessage.Hook("gf_gmtl", function(um)
	local amount = um:ReadLong()
	
	scrapMetal = amount
end)

usermessage.Hook("gf_cmsg", function(um)
	local text = um:ReadString()
	
	chat.AddText(Color(255, 215, 0, 255), "[GoldenForge] ", color_white, text)
end)

usermessage.Hook("gf_gvaspml", function(um)
	local selected = nil
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(250, 200)
	frame:Center()
	frame:SetTitle("[SUPERADMIN] Give a player scrap metal.")
	frame:MakePopup()
	
	local list = vgui.Create("DPanelList", frame)
	list:SetTall(frame:GetTall() /1.8)
	list:Dock(TOP)
	list:SetSpacing(2)
	list:EnableVerticalScrollbar(true)
	
	local giveAmount = vgui.Create("DNumSlider", frame)
	giveAmount:SetPos(6, frame:GetTall() -61)
	giveAmount:SetWide(frame:GetWide() -12)
	giveAmount:SetDecimals(0)
	giveAmount:SetText("")
	giveAmount:SetValue(1)
	giveAmount:SetMinMax(1, 2147483630)
	
	giveAmount.OnValueChanged = function(self, value)
		if (IsValid(selected)) then
			self:SetText("Give " .. selected:Nick() .. " " .. value .. " scrap metal")
		end
	end
	
	local complete = vgui.Create("DButton", frame)
	complete:SetTall(18)
	complete:Dock(BOTTOM)
	complete:SetText("Complete")
	
	complete.DoClick = function()
		if (IsValid(selected)) then
			RunConsoleCommand("gf_gvaspml", selected:Nick(), giveAmount:GetValue())
			
			frame:Remove()
		end
	end
	
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v)) then
			local panel = vgui.Create("DPanel")
			panel:SetTall(18)
			
			panel.Paint = function(self)
				if (IsValid(v)) then
					local w, h = self:GetSize()
					
					surface.SetDrawColor(Color(161, 161, 161, 40))
					surface.DrawRect(0, 0, w, h)
					
					draw.SimpleText(v:Nick(), "DefaultBold", 5, h /2 +1, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText(v:Nick(), "DefaultBold", 4, h /2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
			
			panel.OnCursorEntered = function(self)
				self:SetCursor("hand")
				
				surface.PlaySound("ui/buttonrollover.wav")
			end
			
			panel.OnCursorExited = function(self)
				self:SetCursor("arrow")
			end
			
			panel.OnMousePressed = function()
				selected = v
				
				surface.PlaySound("ui/buttonclickrelease.wav")
				
				giveAmount:SetText("Give " .. v:Nick() .. " " .. giveAmount:GetValue() .. " scrap metal")
			end
			
			list:AddItem(panel)
		end
	end

	frame:InvalidateLayout()
end)

usermessage.Hook("gf_gvspml", function(um)
	local selected = nil
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(250, 200)
	frame:Center()
	frame:SetTitle("You have " .. scrapMetal .. " Scrap Metal.")
	frame:MakePopup()
	
	local list = vgui.Create("DPanelList", frame)
	list:SetTall(frame:GetTall() /1.8)
	list:Dock(TOP)
	list:SetSpacing(2)
	list:EnableVerticalScrollbar(true)
	
	local giveAmount = vgui.Create("DNumSlider", frame)
	giveAmount:SetPos(6, frame:GetTall() -61)
	giveAmount:SetWide(frame:GetWide() -12)
	giveAmount:SetDecimals(0)
	giveAmount:SetText("")
	giveAmount:SetValue(1)
	giveAmount:SetMinMax(1, scrapMetal)
	
	giveAmount.OnValueChanged = function(self, value)
		if (IsValid(selected)) then
			self:SetText("Give " .. selected:Nick() .. " " .. value .. " scrap metal")
		end
	end
	
	local complete = vgui.Create("DButton", frame)
	complete:SetTall(18)
	complete:Dock(BOTTOM)
	complete:SetText("Complete")
	
	complete.DoClick = function()
		if (IsValid(selected)) then
			RunConsoleCommand("gf_gvspml", selected:Nick(), giveAmount:GetValue())
			
			frame:Remove()
		end
	end
	
	for k, v in pairs(player.GetAll()) do
		if (IsValid(v) and v != LocalPlayer()) then
			local panel = vgui.Create("DPanel")
			panel:SetTall(18)
			
			panel.Paint = function(self)
				if (IsValid(v)) then
					local w, h = self:GetSize()
					
					surface.SetDrawColor(Color(161, 161, 161, 40))
					surface.DrawRect(0, 0, w, h)
					
					draw.SimpleText(v:Nick(), "DefaultBold", 5, h /2 +1, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText(v:Nick(), "DefaultBold", 4, h /2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
			
			panel.OnCursorEntered = function(self)
				self:SetCursor("hand")
				
				surface.PlaySound("ui/buttonrollover.wav")
			end
			
			panel.OnCursorExited = function(self)
				self:SetCursor("arrow")
			end
			
			panel.OnMousePressed = function()
				selected = v
				
				surface.PlaySound("ui/buttonclickrelease.wav")
				
				giveAmount:SetText("Give " .. v:Nick() .. " " .. giveAmount:GetValue() .. " scrap metal")
			end
			
			list:AddItem(panel)
		end
	end

	frame:InvalidateLayout()
end)

-------------------
--  HAT RENDERER --
-------------------

local ClearHatPreviews = nil
local UpdateHatPreviews = nil

usermessage.Hook("gf_gteqht", function(um)
	local player = um:ReadEntity()
	local equipped = um:ReadString()
	
	player.equippedHats = player.equippedHats or {}
	
	equipped = string.Explode(";", equipped)
	
	if (equipped[#equipped] == "") then
		table.remove(equipped, #equipped)
	end
	
	-- Create new hats if they don't exist.
	for _, unique in pairs(equipped) do
		if (player.equippedHats[unique] == nil) then
			player.equippedHats[unique] = {}
			
			local data = GF:GetHat(unique)
			
			if (data) then
				--if (player != LocalPlayer()) then
					player.equippedHats[unique].entity = ClientsideModel(data.model, RENDERGROUP_OPAQUE)
				--end
				
				player.equippedHats[unique].data = data
				
				if (data.LayoutModel) then
					data.LayoutModel(nil, player.equippedHats[unique].entity)
				end
			end
		end
	end
	
	if (player == LocalPlayer() and UpdateHatPreviews) then
		UpdateHatPreviews()
	end
end)

hook.Add("PostDrawOpaqueRenderables", "GoldenForge:PostDrawOpaqueRenderables", function()
	for k, v in pairs(storedRagdolls) do
		if (IsValid(v.ragdoll) and IsValid(v.player)) then
			local equippedHats = v.player.equippedHats
			
			if (equippedHats) then
				for unique, data in pairs(equippedHats) do
					local data = data
					
					if (data != nil and IsValid(data.entity)) then
						local entity, position, angles = data.data.LayoutEntity(v.ragdoll, data.entity)
						
						entity:SetPos(position)
						entity:SetAngles(angles)
						entity:SetupBones()
					end
				end
			end
		else
			table.remove(storedRagdolls, k)
		end
	end
end)

hook.Add("PostPlayerDraw", "GoldenForge:PostPlayerDraw", function(player)
	local equippedHats = player.equippedHats
	
	if (equippedHats) then
		for unique, data in pairs(equippedHats) do
			local data = data
			
			if (data != nil and IsValid(data.entity)) then
				local entity, position, angles = data.data.LayoutEntity(player, data.entity)
				
				entity:SetPos(position)
				entity:SetAngles(angles)
				entity:SetupBones()
			end
		end
	end
end)

-----------------------
--  GOLDENFORGE MENU --
-----------------------
GF.purchaseTexture = "goldenforge/icon_purchase"

local gfPanel = nil
local gfPanelSettingPanels = {}
local trailColorTexture = "goldenforge/icon_trailcolor"

local ownedHats = {}
local ownedTrails = {}
local equippedTrail = "nil"
local equippedTrailColor = color_white

function GF:AddSettingsPanel(setup)
	table.insert(gfPanelSettingPanels, setup)
end

function GF:GetStorePanel()
	return gfPanel
end

usermessage.Hook("gf_gtoeqtlc", function(um)
	local color = um:ReadVector()

	equippedTrailColor = Color(color.x, color.y, color.z, 255)
end)

usermessage.Hook("gf_gtoeqtl", function(um)
	local unique = um:ReadString()

	equippedTrail = unique
end)

usermessage.Hook("gf_gtodts", function(um)
	local unique = um:ReadString()

	ownedTrails[unique] = true
end)

usermessage.Hook("gf_gtodhs", function(um)
	local unique = um:ReadString()

	ownedHats[unique] = true
end)

concommand.Add("gf_showmenu", function()
	if (!ValidPanel(gfPanel)) then
		gfPanel = vgui.Create("gf_menu")
		
		gfPanel:AddButton("Hats", function(menu)
			menu:Clear()
			
			local list = vgui.Create("DPanelList", menu)
			list:SetPos(2, 60)
			list:SetSize(menu:GetWide() -4, menu:GetTall() -62)
			list:SetPadding(6)
			list:SetSpacing(7)
			list:EnableHorizontal(true)
			list:EnableVerticalScrollbar(true)
			
			list.Paint = function() end
			
			for k, v in pairs(GF:GetHats()) do
				local panel = vgui.Create("DPanel")
				panel:SetSize(200, 100)
				
				panel.Paint = function(_self)
					local w, h = _self:GetSize()

					draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
					draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
					draw.RoundedBoxEx(4, 0, 0, w, h *0.15, Color(0, 0, 0, 240), true, true, false, false)
					
					draw.SimpleText(v.name, "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText(v.name, "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.SimpleText(v.price, "DefaultSmall", 5, h -6, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText(v.price, "DefaultSmall", 4, h -7, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				
				local purchaseButton = vgui.Create("DImageButton", panel)
				purchaseButton:SetPos(panel:GetWide() -22, panel:GetTall() -21)
				purchaseButton:SetSize(20, 20)
				purchaseButton:SetImage(GF.purchaseTexture)
				
				purchaseButton.DoClick = function()
					if (!ownedHats[v.unique]) then
						if (LocalPlayer():CanAffordScrapMetal(v.price)) then
							RunConsoleCommand("gf_byht", v.unique)
						else
							Derma_Message("You can't afford this hat!", "Error.", "OK")
						end
					end
				end
				
				panel.Think = function()
					if (ownedHats[v.unique]) then
						if (purchaseButton:IsVisible()) then
							purchaseButton:SetVisible(false)
						end
					else
						if (!purchaseButton:IsVisible()) then
							purchaseButton:SetVisible(true)
						end
					end
				end
				
				local modelPanel = vgui.Create("DModelPanel", panel)
				modelPanel:SetPos(0, 5)
				modelPanel:SetSize(200, 100)
				modelPanel:SetModel(v.model)
				modelPanel:SetZPos(-1)
				
				modelPanel.Paint = function(self)
					local w, h = self:GetSize()
					local x, y = self:LocalToScreen(0, 0)
					local sl, st, sr, sb = x, y, x +w, y +h
				
					local p = self
					
					while p:GetParent() do
						p = p:GetParent()
						
						local pl, pt = p:LocalToScreen(0, 0)
						local pr, pb = pl +p:GetWide(), pt +p:GetTall()
						
						sl = sl < pl and pl or sl
						st = st < pt and pt or st
						sr = sr > pr and pr or sr
						sb = sb > pb and pb or sb
					end

					render.SetScissorRect(sl, st, sr, sb, true)
						DModelPanel.Paint(self)
					render.SetScissorRect(0, 0, 0, 0, false)
				end
				
				if (v.LayoutModel) then
					v.LayoutModel(modelPanel, modelPanel.Entity)
				end
				
				if (!v.LayoutCamera) then
					local mins, maxs = modelPanel.Entity:GetRenderBounds()
				
					modelPanel:SetLookAt((maxs +mins) /2)
					modelPanel:SetCamPos(mins:Distance(maxs) *Vector(0, 0.75, 0.75))
				else
					v.LayoutCamera(modelPanel)
				end
			
				modelPanel.LayoutEntity = function(_self, entity)
					entity:SetAngles(Angle(0, RealTime() *10, 0))
				end
				
				list:AddItem(panel)
			end
			
			menu:AddPanel(list)
		end)
	
		gfPanel:AddButton("Trails", function(menu)
			menu:Clear()
			
			local list = vgui.Create("DPanelList", menu)
			list:SetPos(2, 60)
			list:SetSize(menu:GetWide() -4, menu:GetTall() -62)
			list:SetPadding(6)
			list:SetSpacing(7)
			list:EnableHorizontal(true)
			list:EnableVerticalScrollbar(true)
			
			list.Paint = function() end
			
			for k, v in pairs(GF:GetTrails()) do
				local panel = vgui.Create("DPanel")
				panel:SetSize(200, 100)
				
				panel.Paint = function(_self)
					local w, h = _self:GetSize()

					draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
					draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
					draw.RoundedBoxEx(4, 0, 0, w, h *0.15, Color(0, 0, 0, 240), true, true, false, false)
				
					draw.SimpleText(v.name, "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText(v.name, "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					draw.SimpleText(v.price, "DefaultSmall", 5, h -6, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					draw.SimpleText(v.price, "DefaultSmall", 4, h -7, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					
					if (v.material) then
						surface.SetDrawColor(color_white)
						surface.SetTexture(v.material)
						surface.DrawTexturedRect(w /2 -64, h /2 -32, 128, 80)
					end
				end
				
				local purchaseButton = vgui.Create("DImageButton", panel)
				purchaseButton:SetPos(panel:GetWide() -22, panel:GetTall() -21)
				purchaseButton:SetSize(20, 20)
				purchaseButton:SetImage(GF.purchaseTexture)
				
				purchaseButton.DoClick = function()
					if (!ownedTrails[v.unique]) then
						if (LocalPlayer():CanAffordScrapMetal(v.price)) then
							RunConsoleCommand("gf_bytrl", v.unique)
						else
							Derma_Message("You can't afford this trail!", "Error.", "OK")
						end
					end
				end
				
				panel.Think = function()
					if (ownedTrails[v.unique]) then
						if (purchaseButton:IsVisible()) then
							purchaseButton:SetVisible(false)
						end
					else
						if (!purchaseButton:IsVisible()) then
							purchaseButton:SetVisible(true)
						end
					end
				end
				
				list:AddItem(panel)
			end
			
			menu:AddPanel(list)
		end)
		
		for k, v in ipairs(GF.categories) do
			if (v.menuSetup) then
				gfPanel:AddButton(v.name, v.menuSetup)
			end
		end
		
		gfPanel:AddButton("Settings", function(menu)
			menu:Clear()
			
			local base = vgui.Create("DPanel", menu)
			base:SetPos(2, 60)
			base:SetSize(menu:GetWide() -4, menu:GetTall() -62)
			
			base.Paint = function(self)
			end
			
			local modelPanel = vgui.Create("DModelPanel", base)
			modelPanel:SetPos(base:GetWide() -300, base:GetTall() /2 -150)
			modelPanel:SetSize(300, 300)
			modelPanel:SetModel(LocalPlayer():GetModel())
			modelPanel:SetFOV(85)
			
			modelPanel.Think = function(self)
				if (IsValid(self.Entity) and self.Entity:GetModel() != LocalPlayer():GetModel()) then
					self:SetModel(LocalPlayer():GetModel())
				end
			end
			
			local hatPreviews = {}
			
			modelPanel.LayoutEntity = function(self, entity)
				entity:SetAngles(Angle(0, RealTime() *15, 0))
				
				for k, v in pairs(hatPreviews) do
					if (ValidPanel(v)) then
						local data = GF:GetHat(k)
					
						if (data) then
							local hat, position, angles = data.LayoutEntity(entity, v.Entity)
							
							hat:SetPos(position)
							hat:SetAngles(angles)
						end
					end
				end
			end
			
			ClearHatPreviews = function()
				for k, v in pairs(hatPreviews) do
					if (ValidPanel(v)) then
						v.Entity:Remove()
						v:Remove()
				
						hatPreviews[k] = nil
					end
				end
			end
			
			UpdateHatPreviews = function()
				ClearHatPreviews()
				
				if (LocalPlayer().equippedHats) then
					for unique, data in pairs(LocalPlayer().equippedHats) do
						local previewPanel = vgui.Create("DModelPanel", modelPanel)
						previewPanel:SetModel(data.data.model)
						previewPanel:SetSize(300, 300)
						previewPanel:SetFOV(85)
					
						if (data.data.LayoutModel) then
							data.data.LayoutModel(previewPanel, previewPanel.Entity)
						end
						
						previewPanel.LayoutEntity = function() end
				
						hatPreviews[unique] = previewPanel
					end
				end
			end
	
			UpdateHatPreviews()
			
			local settingPanels = vgui.Create("DPanelList", base)
			settingPanels:SetSize(base:GetWide() /2 +25, base:GetTall() -12)
			settingPanels:SetPos(4, 10)
			settingPanels:SetPadding(2)
			settingPanels:SetSpacing(4)
			settingPanels:EnableVerticalScrollbar(true)
			
			settingPanels.Paint = function() end
			
			local hatBase = vgui.Create("DPanel")
			hatBase:SetTall(150)
			
			hatBase.Paint = function(self)
				local w, h = self:GetSize()
				
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
				draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
				draw.RoundedBoxEx(4, 0, 0, w, h *0.10, Color(0, 0, 0, 240), true, true, false, false)
				
				draw.SimpleText("Owned Hats", "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Owned Hats", "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			local hatList = vgui.Create("DPanelList", hatBase)
			hatList:SetSpacing(2)
			hatList:SetDrawBackground(false)
			hatList:EnableVerticalScrollbar(true)
			
			hatBase.PerformLayout = function(self)
				DPanel.PerformLayout(self)
				
				local w, h = self:GetSize()
				
				hatList:SetPos(1, 15)
				hatList:SetSize(w -2, h -16)
			end
			
			for k, data in pairs(GF:GetHats()) do
				if (ownedHats[data.unique]) then
					local panel = vgui.Create("DPanel")
					panel:SetTall(18)
					
					panel.Paint = function(self)
						local w, h = self:GetSize()
						
						surface.SetDrawColor(Color(161, 161, 161, 40))
						surface.DrawRect(0, 0, w, h)
					
						draw.SimpleText(data.name, "DefaultBold", 5, h /2 +1, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(data.name, "DefaultBold", 4, h /2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					
					panel.OnCursorEntered = function(self)
						if (!ValidPanel(self.hoverPanel)) then
							self.hoverPanel = vgui.Create("DPanel")
							self.hoverPanel:SetSize(100, 100)
							self.hoverPanel:SetDrawOnTop(true)
							
							self.hoverPanel.Paint = function(_self)
								local w, h = _self:GetSize()
								
								draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
								draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
								draw.RoundedBoxEx(4, 0, 0, w, h *0.15, Color(0, 0, 0, 240), true, true, false, false)
								
								draw.SimpleText(data.name, "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								draw.SimpleText(data.name, "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
							
							self.hoverPanel.Think = function(self)
								local x, y = gui.MousePos()
								
								self:SetPos(x +12, y +12)
							end
							
							local modelPanel = vgui.Create("DModelPanel", self.hoverPanel)
							modelPanel:SetPos(0, 5)
							modelPanel:SetSize(100, 100)
							modelPanel:SetModel(data.model)
							modelPanel:SetZPos(-1)
							
							if (data.LayoutModel) then
								data.LayoutModel(modelPanel, modelPanel.Entity)
							end
						
							if (!data.LayoutCamera) then
								local mins, maxs = modelPanel.Entity:GetRenderBounds()
							
								modelPanel:SetLookAt((maxs +mins) /2)
								modelPanel:SetCamPos(mins:Distance(maxs) *Vector(0, 0.75, 0.75))
							else
								data.LayoutCamera(modelPanel)
							end
							
							modelPanel.LayoutEntity = function(self, entity)
								entity:SetAngles(Angle(0, RealTime() *10, 0))
							end
						end
					end
					
					panel.OnCursorExited = function(self)
						if (ValidPanel(self.hoverPanel)) then
							self.hoverPanel:Remove()
							self.hoverPanel = nil
						end
					end
					
					local button = vgui.Create("DImageButton", panel)
					button:SetSize(16, 16)
					
					button.DoClick = function()
						if (LocalPlayer().equippedHats) then
							if (LocalPlayer().equippedHats[data.unique] != nil) then
								if (IsValid(LocalPlayer().equippedHats[data.unique].entity)) then
									LocalPlayer().equippedHats[data.unique].entity:Remove()
								end
								
								LocalPlayer().equippedHats[data.unique] = nil
								
								local equipped = ""
							
								for unique, _ in pairs(LocalPlayer().equippedHats) do
									equipped = equipped .. unique .. ";"
								end
						
								RunConsoleCommand("gf_eqht", equipped)
							else
								local equipped = ""
							
								for unique, _ in pairs(LocalPlayer().equippedHats) do
									equipped = equipped .. unique .. ";"
								end
								
								equipped = equipped .. data.unique
						
								RunConsoleCommand("gf_eqht", equipped)
							end
						end
					end
					
					button.Think = function(self)
						local x = self:GetPos()
						
						if (x != panel:GetWide() -20) then
							self:SetPos(panel:GetWide() -20, 2)
						end
						
						if (LocalPlayer().equippedHats) then
							if (LocalPlayer().equippedHats[data.unique] != nil) then
								if (self:GetImage() != "gui/silkicons/check_off") then
									self:SetImage("gui/silkicons/check_off")
									self:SetToolTip("Unequip Hat")
								end
							else
								if (self:GetImage() != "gui/silkicons/check_on") then
									self:SetImage("gui/silkicons/check_on")
									self:SetToolTip("Equip Hat")
								end
							end
						end
					end
					
					hatList:AddItem(panel)
				end
			end
			
			settingPanels:AddItem(hatBase)
			
			local trailBase = vgui.Create("DPanel")
			trailBase:SetTall(150)
		
			trailBase.Paint = function(self)
				local w, h = self:GetSize()
				
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
				draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
				draw.RoundedBoxEx(4, 0, 0, w, h *0.10, Color(0, 0, 0, 240), true, true, false, false)
				
				draw.SimpleText("Owned Trails", "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Owned Trails", "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			local trailList = vgui.Create("DPanelList", trailBase)
			trailList:SetSpacing(2)
			trailList:SetDrawBackground(false)
			trailList:EnableVerticalScrollbar(true)
			
			trailBase.PerformLayout = function(self)
				DPanel.PerformLayout(self)
				
				local w, h = self:GetSize()
				
				trailList:SetPos(1, 15)
				trailList:SetSize(w -2, h -16)
			end
			
			for k, data in pairs(GF:GetTrails()) do
				if (ownedTrails[data.unique]) then
					local panel = vgui.Create("DPanel")
					panel:SetTall(18)
					
					panel.Paint = function(self)
						local w, h = self:GetSize()
						
						surface.SetDrawColor(Color(161, 161, 161, 40))
						surface.DrawRect(0, 0, w, h)
					
						draw.SimpleText(data.name, "DefaultBold", 5, h /2 +1, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						draw.SimpleText(data.name, "DefaultBold", 4, h /2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
					
					panel.OnCursorEntered = function(self)
						if (!ValidPanel(self.hoverPanel)) then
							self.hoverPanel = vgui.Create("DPanel")
							self.hoverPanel:SetSize(100, 100)
							self.hoverPanel:SetDrawOnTop(true)
							
							self.hoverPanel.Paint = function(_self)
								local w, h = _self:GetSize()
		
								draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
								draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
								draw.RoundedBoxEx(4, 0, 0, w, h *0.15, Color(0, 0, 0, 240), true, true, false, false)
								
								draw.SimpleText(data.name, "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								draw.SimpleText(data.name, "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								
								if (data.material) then
									surface.SetDrawColor(equippedTrailColor)
									surface.SetTexture(data.material)
									surface.DrawTexturedRect(w /2 -64, h /2 -32, 128, 80)
								end
							end
							
							self.hoverPanel.Think = function(self)
								local x, y = gui.MousePos()
								
								self:SetPos(x +12, y +12)
							end
						end
					end
					
					panel.OnCursorExited = function(self)
						if (ValidPanel(self.hoverPanel)) then
							self.hoverPanel:Remove()
							self.hoverPanel = nil
						end
					end
					
					local button = vgui.Create("DImageButton", panel)
					button:SetSize(16, 16)
					
					button.DoClick = function()
						if (equippedTrail != data.unique) then
							RunConsoleCommand("gf_eqtrl", data.unique)
						else
							RunConsoleCommand("gf_eqtrl", data.unique, "1")
						end
					end
			
					button.Think = function(self)
						local x = self:GetPos()
						
						if (x != panel:GetWide() -20) then
							self:SetPos(panel:GetWide() -20, 2)
						end
						
						if (equippedTrail == data.unique) then
							if (self:GetImage() != "gui/silkicons/check_off") then
								self:SetImage("gui/silkicons/check_off")
								self:SetToolTip("Unequip Trail")
							end
						else
							if (self:GetImage() != "gui/silkicons/check_on") then
								self:SetImage("gui/silkicons/check_on")
								self:SetToolTip("Equip Trail")
							end
						end
					end
					
					local colorButton = vgui.Create("DImageButton", panel)
					colorButton:SetSize(16, 16)
					colorButton:SetImage(trailColorTexture)
					colorButton:SetToolTip("Change Trail Color")
					
					colorButton.DoClick = function()
						local frame = vgui.Create("DFrame")
						frame:SetSize(250, 220)
						frame:Center()
						frame:SetTitle("Trail Color")
						frame:MakePopup()
						frame:SetDrawOnTop(true)
						
						local colorSelect = vgui.Create("DColorMixer", frame)
						colorSelect:SetTall(80)
						colorSelect:Dock(TOP)
						colorSelect:SetColor(equippedTrailColor)
						
						local trailPreview = vgui.Create("DPanel", frame)
						trailPreview:SetTall(80)
						trailPreview:Dock(FILL)
						
						trailPreview.Paint = function(self)
							local w, h  = self:GetSize()
							
							if (data.material) then
								local color = colorSelect:GetColor()
								
								surface.SetDrawColor(color.r, color.g, color.b, 255)
								surface.SetTexture(data.material)
								surface.DrawTexturedRect(w /2 -64, 2, 128, 80)
							end
						end
						
						local complete = vgui.Create("DButton", frame)
						complete:SetTall(20)
						complete:Dock(BOTTOM)
						complete:SetText("Set Trail Color")
						
						complete.DoClick = function()
							local color = colorSelect:GetColor()
							
							RunConsoleCommand("gf_sctrl", data.unique, color.r .. " " .. color.g .. " " .. color.b)
							
							frame:Remove()
						end
						
						frame:InvalidateLayout()
					end
					
					colorButton.Think = function(self)
						local x = self:GetPos()
						
						if (x != panel:GetWide() -38) then
							self:SetPos(panel:GetWide() -38, 2)
						end
					end
					
					trailList:AddItem(panel)
				end
			end
			
			settingPanels:AddItem(trailBase)
			
			for k, v in pairs(gfPanelSettingPanels) do
				v(settingPanels)
			end
			
			menu:AddPanel(base)
		end)
	else
		gfPanel:SetVisible(true)
		
		if (UpdateHatPreviews and gfPanel:GetSelectedID() == "Settings") then
			UpdateHatPreviews()
		end
	end
end)

hook.Add("Initialize", "GoldenForge:Initialize", function()
	surface.CreateFont("Tahoma", 24, 700, true, false, "gf_menuHeader")
end)

local PANEL = {}

function PANEL:Init()
	self.panels = {}
	self.buttons = {}
	
	self:SetPos(ScrW() /2 -325, ScrH() /2 -200)
	self:SetSize(650, 385)
	self:MakePopup()
	
	self.close = vgui.Create("DLabel")
	self.close:SetParent(self)
	self.close:SetPos(self:GetWide() -20, 3)
	self.close:SetText("X")
	self.close:SetFont("gf_menuHeader")
	self.close:SetColor(color_white)
	self.close:SetTextColorHovered(Color(255, 0, 0, 255))
	self.close:SizeToContents()
	
	self.close.OnMousePressed = function()
		if (ClearHatPreviews) then
			ClearHatPreviews()
		end
		
		self:SetVisible(false)
	end
end

function PANEL:Clear()
	for k, v in pairs(self.panels) do
		if (ValidPanel(v)) then
			v:Remove()
		end
	end
	
	self.panels = {}
end

function PANEL:AddPanel(panel)
	table.insert(self.panels, panel)
end

function PANEL:GetSelectedID()
	return self.selectedID
end

function PANEL:AddButton(name, click)
	local button = vgui.Create("DPanel", self)
	button:SetSize(80, 18)
	
	button.Paint = function(_self)
		local w, h = _self:GetSize()
		
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
		
		if (self.selectedButton == _self) then
			draw.RoundedBox(4, 1, 1, w -2, h -2, Color(224, 138, 19, 240))
		else
			draw.RoundedBox(4, 1, 1, w -2, h -2, Color(119, 173, 98, 240))
		end
		
		draw.SimpleText(name, "DefaultBold", w /2 +1, 9, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(name, "DefaultBold", w /2, 8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	button.OnMousePressed = function(_self, code)
		self.selectedID = name
		self.selectedButton = _self
		
		if (click) then
			click(self)
		end
	end
	
	table.insert(self.buttons, button)
	
	local x = 245
	
	if (#self.buttons > 1) then
		x = 407 -(61 *#self.buttons)
	end
	
	for k, v in pairs(self.buttons) do
		v:SetPos(x, 38)
		
		x = x +84
	end
end

function PANEL:Paint()
	local w, h = self:GetSize()
	
	Derma_DrawBackgroundBlur(self)
	
	draw.RoundedBox(4, 0, 0, w, 30, Color(0, 0, 0, 240))
	
	draw.SimpleText("The Golden Forge - You have " .. scrapMetal .. " Scrap Metal", "gf_menuHeader", 6, 16, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText("The Golden Forge - You have " .. scrapMetal .. " Scrap Metal", "gf_menuHeader", 5, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("gf_menu", PANEL, "EditablePanel")

GF:LoadCategories()