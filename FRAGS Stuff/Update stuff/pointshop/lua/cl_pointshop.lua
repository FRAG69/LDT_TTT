usermessage.Hook("PointShop_Menu", function(um)
	if um:ReadBool() then
		POINTSHOP.Menu = vgui.Create("DFrame")
		POINTSHOP.Menu:SetSize(455, 400)
		POINTSHOP.Menu:SetTitle("Shop")
		POINTSHOP.Menu:SetVisible(true)
		POINTSHOP.Menu:SetDraggable(true)
		POINTSHOP.Menu:ShowCloseButton(true)
		POINTSHOP.Menu:MakePopup()
		POINTSHOP.Menu:Center()
		POINTSHOP.Menu:SizeToContents()
		
		local Tabs = vgui.Create("DPropertySheet", POINTSHOP.Menu)
		Tabs:SetPos(5, 30)
		Tabs:SetSize(POINTSHOP.Menu:GetWide() - 10, POINTSHOP.Menu:GetTall() - 35)
		
		-- Feel free to add your own tabs.
		
		local npc_id = um:ReadLong()
		local is_npc_menu = false
		
		if npc_id > 0 then
			is_npc_menu = true
			npcs = POINTSHOP.Config.Sellers[game.GetMap()]
			npc = npcs[npc_id]
			npc_categories = npc.Categories
		end
		
		for c_id, category in pairs(POINTSHOP.Items) do
			if category.Enabled then
				if (is_npc_menu and table.HasValue(npc_categories, category.Name)) or not is_npc_menu then
					local CategoryTab = vgui.Create("DPanelList", ShopCategoryTabs)
					CategoryTab:SetSpacing(1)
					CategoryTab:SetPadding(1)
					CategoryTab:EnableHorizontal(true)
					CategoryTab:EnableVerticalScrollbar(true)
					CategoryTab:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 30)
					
					for item_id, item in pairs(category.Items) do
						if item.Enabled then
							if not table.HasValue(LocalPlayer():PS_GetItems(), item_id) then
								local Panel = vgui.Create("DPanel")
								Panel:SetSize(CategoryTab:GetWide() - 2, 30)
								
								local DLabel2 = vgui.Create("DLabel", Panel)
								DLabel2:SetPos(Panel:GetWide() - 120, Panel:GetTall() - 27)
								DLabel2:SetFont("TargetID")
								DLabel2:SetText("Gil: " .. item.Cost)
								DLabel2:SizeToContents()
								
								local DImageButton1 = vgui.Create("DImageButton", Panel)
								DImageButton1:SetSize(25, 25)
								DImageButton1:SetPos(Panel:GetWide() - 40, Panel:GetTall() - 24)
								if item.VIPOnly then
									DImageButton1:SetImage("gui/silkicons/star.vmt")
								else
									DImageButton1:SetImage("gui/silkicons/money_dollar.vmt")
								end
								DImageButton1:SizeToContents()
								DImageButton1.DoClick = function()
									if LocalPlayer():PS_CanAfford(item.Cost) then
										Derma_Query("Do you want to buy '" .. item.Name .. "' for " .. item.Cost .. " gil?", "Buy Item",
											"Yes", function() RunConsoleCommand("pointshop_buy", item_id) end,
											"No", function() end
										)
									else
										Derma_Message("You can't afford this item!", "PointShop", "Close")
									end
								end

								local DLabel1 = vgui.Create("DLabel", Panel)
								DLabel1:SetPos(Panel:GetWide() - 420, Panel:GetTall() - 27)
								DLabel1:SetFont("TargetID")
								DLabel1:SetText(item.Name)
								DLabel1:SizeToContents()
	
								CategoryTab:AddItem(Panel)
							end
						end
					end
					Tabs:AddSheet(category.Name, CategoryTab, "gui/silkicons/" .. category.Icon, category.Name)
				end
			end
		end
		
		-- Inventory Tab
		
		local InventoryContainer = vgui.Create("DPanelList", POINTSHOP.Menu)
		InventoryContainer:SetSize(Tabs:GetWide() - 10, Tabs:GetTall() - 30)
		InventoryContainer:SetSpacing(1)
		InventoryContainer:SetPadding(1)
		InventoryContainer:EnableHorizontal(true)
		InventoryContainer:EnableVerticalScrollbar(false)
		
		for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
			
			local item = POINTSHOP.FindItemByID(item_id)
			
			if item then
				local Panel = vgui.Create("DPanel")
				Panel:SetSize(InventoryContainer:GetWide() - 2, 30)
								
				local DLabel2 = vgui.Create("DLabel", Panel)
				DLabel2:SetPos(Panel:GetWide() - 120, Panel:GetTall() - 27)
				DLabel2:SetFont("TargetID")
				DLabel2:SetText("Gil: " .. item.Cost)
				DLabel2:SizeToContents()

				local DImageButton1 = vgui.Create("DImageButton", Panel)
				DImageButton1:SetSize(25, 25)
				DImageButton1:SetPos(Panel:GetWide() - 40, Panel:GetTall() - 24)
				DImageButton1:SetImage("gui/silkicons/money_dollar.vmt")
				DImageButton1:SizeToContents()
				DImageButton1.DoClick = function()
					Derma_Query("Do you want to sell '" .. item.Name .. "' for " .. POINTSHOP.Config.SellCost(item.Cost) .. " gil?", "Sell Item",
						"Yes", function() RunConsoleCommand("pointshop_sell", item_id) end,
						"No", function() end
					)
				end

				local DLabel1 = vgui.Create("DLabel", Panel)
				DLabel1:SetPos(Panel:GetWide() - 420, Panel:GetTall() - 27)
				DLabel1:SetFont("TargetID")
				DLabel1:SetText(item.Name)
				DLabel1:SizeToContents()
	
				InventoryContainer:AddItem(Panel)
			end
		end
		
		Tabs:AddSheet("Inventory", InventoryContainer, "gui/silkicons/box", false, false, "Browse your inventory!")
	else
		if POINTSHOP.Menu then
			POINTSHOP.Menu:Remove()
		end
	end
end)

usermessage.Hook("PointShop_Notify", function(um)
	local text = um:ReadString()
	if text then
		chat.AddText(Color(255, 255, 255), text)
	end
end)

usermessage.Hook("PointShop_Broadcast", function(um)
	local text = um:ReadString()
	if text then
		chat.AddText(Color(255, 255, 255), text)
	end
end)

usermessage.Hook("PointShop_AddHat", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not item_id then return end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	if not ply._Hats then
		ply._Hats = {}
	end
	
	if ply._Hats[item_id] then return end
	
	local mdl = ClientsideModel(item.Model, RENDERGROUP_OPAQUE)
	mdl:SetNoDraw(true)
	
	ply._Hats[item_id] = {
		Model = mdl,
		Attachment = item.Attachment or nil,
		Bone = item.Bone or nil,
		Modify = item.Functions.ModifyHat or function(ent, pos, ang) return ent, pos, ang end
	}
end)

usermessage.Hook("PointShop_RemoveHat", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not ply:IsValid() or not ply:IsPlayer() or not item_id then return end
	if not ply._Hats then return end
	if not ply._Hats[item_id] then return end
	
	ply._Hats[item_id] = nil
end)

/*usermessage.Hook("PointShop_AddSkin", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not item_id then return end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	if not ply._Skins then
		ply._Skins = {}
	end
	
	if ply._Skins[item_id] then return end
	
	local mdl = ClientsideModel(item.Model, RENDERGROUP_OPAQUE)
	mdl:SetNoDraw(true)
	
	ply._Skins[item_id] = {
		Model = mdl,
		Attachment = item.Attachment or nil,
		Bone = item.Bone or nil,
		Modify = item.Functions.ModifyHat or function(ent, pos, ang) return ent, pos, ang end
	}
end)

usermessage.Hook("PointShop_RemoveSkin", function(um)
	local ply = Entity(um:ReadLong())
	local item_id = um:ReadString()
	
	if not ply or not ply:IsValid() or not ply:IsPlayer() or not item_id then return end
	if not ply._Hats then return end
	if not ply._Hats[item_id] then return end
	
	ply._Hats[item_id] = nil
end)*/

hook.Add("InitPostEntity", "PointShop_InitPostEntity", function()
	LocalPlayer().PS_Points = 0
	LocalPlayer().PS_Items = {}
end)

hook.Add("Initialize", "PointShop_DColumnSheet_AddSheet_Override", function()
	function DColumnSheet:AddSheet(label, panel, material, tooltip)
		if not IsValid(panel) then return end

		local Sheet = {}
		
		if self.ButtonOnly then
			Sheet.Button = vgui.Create("DImageButton", self.Navigation)
		else
			Sheet.Button = vgui.Create("DButton", self.Navigation)
		end
		
		Sheet.Button:SetImage(material)
		Sheet.Button.Target = panel
		Sheet.Button:Dock(TOP)
		Sheet.Button:SetText(label)
		Sheet.Button:DockMargin(0, 1, 0, 0)
		
		if tooltip then
			Sheet.Button:SetToolTip(tooltip)
		end
		
		Sheet.Button.DoClick = function()
			self:SetActiveButton(Sheet.Button)
		end
		
		Sheet.Panel = panel
		Sheet.Panel:SetParent(self.Content)
		Sheet.Panel:SetVisible(false)
		
		if self.ButtonOnly then
			Sheet.Button:SizeToContents()
			Sheet.Button:SetColor(Color(150, 150, 150, 100))
		end
		
		table.insert(self.Items, Sheet)
		
		if not IsValid(self.ActiveButton) then
			self:SetActiveButton(Sheet.Button)
		end
	end
end)

hook.Add("PostPlayerDraw", "PointShop_PostPlayerDraw", function(ply)
	if not ply:Alive() then return end
	if not POINTSHOP.Config.AlwaysDrawHats and not hook.Call("ShouldDrawHats", GAMEMODE) and ply == LocalPlayer() and GetViewEntity():GetClass() == "player" then return end
	
	if ply._Hats and #ply._Hats then
		for id, hat in pairs(ply._Hats) do
			local pos = Vector()
			local ang = Angle()
			
			if not hat.Attachment and not hat.Bone then return end
			
			if hat.Attachment then
				local attach = ply:GetAttachment(ply:LookupAttachment(hat.Attachment))
				pos = attach.Pos
				ang = attach.Ang
			elseif hat.Bone then
				pos, ang = ply:GetBonePosition(ply:LookupBone(hat.Bone))
			end
			
			hat.Model, pos, ang = hat.Modify(hat.Model, pos, ang)
			hat.Model:SetPos(pos)
			hat.Model:SetAngles(ang)
			
			hat.Model:SetRenderOrigin(pos)
			hat.Model:SetRenderAngles(ang)
			hat.Model:SetupBones()
			hat.Model:DrawModel()
			hat.Model:SetRenderOrigin()
			hat.Model:SetRenderAngles()
		end
	end
end)

hook.Add("PostDrawOpaqueRenderables", "PointShop_PostDrawOpaqueRenderables", function()
	for _, npc in pairs(ents.FindByClass("npc_citizen")) do
		if npc:GetNWBool("IsPointShopNPC") then
			local ang = LocalPlayer():EyeAngles()
			local pos = npc:GetPos() + Vector(0, 0, 85)
			
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)
			
			cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
				draw.DrawText(POINTSHOP.Config.Sellers[game.GetMap()][npc:GetNWInt("PointShopID")].Name, "HUDNumber", 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end)

if POINTSHOP.Config.DisplayPoints then
	hook.Add("HUDPaint", "PointShop_HUDPaint", function()
		local text = "Dollars: " .. LocalPlayer():PS_GetPoints()
		surface.SetFont("ScoreboardText")
		local w, h = surface.GetTextSize(text)
		draw.RoundedBox(6, 10, 10, w + 10, h + 10, Color(0, 0, 0, 100))
		draw.SimpleText(text, "ScoreboardText", 15, 15, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end)
end