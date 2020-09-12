category.disabled = true

category.name = "Weapons"
category.position = 3

GF.CATEGORY_WEAPONS = 3

if (!category.disabled) then
	function GF:GetWeapon(unique)
		for _, data in pairs(GF.categories[GF.CATEGORY_WEAPONS].items) do
			if (data.unique == unique) then
				return data
			end
		end
	end

	function GF:GetWeapons()
		return GF.categories[GF.CATEGORY_WEAPONS].items
	end

	if (SERVER) then
		local meta = FindMetaTable("Player")
		
		function meta:OwnsWeapon(weapon)
			return self:GetGFData("weapons").owned[weapon]
		end
		
		GF:AddPlayerData("weapons", {owned = {}, equipped = ""}, function(player)
			local weapons = player:GetGFData("weapons").owned
			
			for k, v in pairs(weapons) do
				umsg.Start("gf_gtodwps", player)
					umsg.String(k)
				umsg.End()
			end
		end)
		
		concommand.Add("gf_bywpn", function(player, commands, arguments)
			local data = GF:GetWeapon(arguments[1])
			
			if (data) then
				if (!player:OwnsWeapon(weapon)) then
					if (player:CanAffordScrapMetal(data.price)) then
						player:RemoveScrapMetal(data.price, "-" .. data.price .. " You bought the '" .. data.name .. "' weapon.")
						
						player:GetGFData("weapons").owned[data.unique] = true
						
						umsg.Start("gf_gtodwps", player)
							umsg.String(data.unique)
						umsg.End()
					
						player:SaveGFData()
					else
						player:ChatPrint("You can't afford this weapon.")
					end
				else
					player:ChatPrint("You already own this weapon.")
				end
			else
				player:ChatPrint("Invalid weapon.")
			end
		end)
		
		concommand.Add("gf_eqwpn", function(player, command, arguments)
			local data = GF:GetWeapon(arguments[1])
			
			if (data) then
				local weapons = player:GetGFData("weapons")
				
				if (weapons.owned[data.unique]) then
					if (arguments[2] == "1") then
						if (weapons.equipped != "") then
							local data = GF:GetWeapon(weapons.equipped)
							
							if (player:HasWeapon(data.className)) then
								player:StripWeapon(data.className)
							end
						end
						
						player:Give(data.className)
						
						weapons.equipped = data.unique
						
						umsg.Start("gf_gteqwps", player)
							umsg.String(data.unique)
						umsg.End()
						
						player:SaveGFData()
					elseif (arguments[2] == "0" and weapons.equipped != "") then
						local data = GF:GetWeapon(weapons.equipped)
						
						player:StripWeapon(data.className)
						
						weapons.equipped = ""
						
						umsg.Start("gf_gteqwps", player)
							umsg.String("")
						umsg.End()
					end
				else
					player:ChatPrint("You don't own this weapon.")
				end
			else
				player:ChatPrint("Invalid weapon.")
			end
		end)
	elseif (CLIENT) then
		local ownedWeapons = {}
		local equippedWeapon = ""
		
		usermessage.Hook("gf_gteqwps", function(um)
			local weapon = um:ReadString()
			
			equippedWeapon = weapon
		end)
		
		usermessage.Hook("gf_gtodwps", function(um)
			local weapon = um:ReadString()
			
			ownedWeapons[weapon] = true
		end)
		
		GF:AddSettingsPanel(function(settingsPanel)
			local weaponBase = vgui.Create("DPanel")
			weaponBase:SetTall(150)
			
			weaponBase.Paint = function(self)
				local w, h = self:GetSize()
				
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 240))
				draw.RoundedBox(4, 1, 1, w -2, h -2, Color(211, 211, 211, 40))
				draw.RoundedBoxEx(4, 0, 0, w, h *0.10, Color(0, 0, 0, 240), true, true, false, false)
				
				draw.SimpleText("Owned Weapons", "Default", w /2 +1, 8, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Owned Weapons", "Default", w /2, 7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			
			local weaponList = vgui.Create("DPanelList", weaponBase)
			weaponList:SetSpacing(2)
			weaponList:SetDrawBackground(false)
			weaponList:EnableVerticalScrollbar(true)
			
			weaponBase.PerformLayout = function(self)
				DPanel.PerformLayout(self)
				
				local w, h = self:GetSize()
				
				weaponList:SetPos(1, 15)
				weaponList:SetSize(w -2, h -16)
			end
			
			for k, data in pairs(GF:GetWeapons()) do
				if (ownedWeapons[data.unique]) then
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
						if (equippedWeapon == data.unique) then
							RunConsoleCommand("gf_eqwpn", data.unique, "0")
						else
							RunConsoleCommand("gf_eqwpn", data.unique, "1")
						end
					end
					
					button.Think = function(self)
						local x = self:GetPos()
						
						if (x != panel:GetWide() -20) then
							self:SetPos(panel:GetWide() -20, 2)
						end

						if (equippedWeapon == data.unique) then
							if (self:GetImage() != "gui/silkicons/check_off") then
								self:SetImage("gui/silkicons/check_off")
								self:SetToolTip("Unequip Weapon")
							end
						else
							if (self:GetImage() != "gui/silkicons/check_on") then
								self:SetImage("gui/silkicons/check_on")
								self:SetToolTip("Equip Weapon")
							end
						end
					end
					
					weaponList:AddItem(panel)
				end
			end
			
			settingsPanel:AddItem(weaponBase)
		end)

		category.menuSetup = function(menu)
			menu:Clear()
			
			local list = vgui.Create("DPanelList", menu)
			list:SetPos(2, 60)
			list:SetSize(menu:GetWide() -4, menu:GetTall() -62)
			list:SetPadding(6)
			list:SetSpacing(7)
			list:EnableHorizontal(true)
			list:EnableVerticalScrollbar(true)
			
			list.Paint = function() end
			
			for k, v in pairs(GF:GetWeapons()) do
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
					if (!ownedWeapons[v.unique]) then
						if (LocalPlayer():CanAffordScrapMetal(v.price)) then
							RunConsoleCommand("gf_bywpn", v.unique)
						else
							Derma_Message("You can't afford this weapon!", "Error.", "OK")
						end
					end
				end
				
				panel.Think = function()
					if (ownedWeapons[v.unique]) then
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
		end
	end
end