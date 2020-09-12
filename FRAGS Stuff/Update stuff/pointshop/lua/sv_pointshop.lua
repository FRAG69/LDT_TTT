POINTSHOP.Hats = {}

/*local KeyToHook = {
	F1 = "ShowHelp",
	F2 = "ShowTeam",
	F3 = "ShowSpare1",
	F4 = "ShowSpare2",
	None = "ThisHookDoesNotExist"
}

hook.Add(KeyToHook[POINTSHOP.Config.ShopKey], "PointShop_ShopKey", function(ply)
	ply:PS_ShowShop(true)
end)*/

hook.Add("InitPostEntity", "PointShop_InitPostEntity", function()
	if POINTSHOP.Config.SellersEnabled then
		for seller_id, seller in pairs(POINTSHOP.Config.Sellers[game.GetMap()]) do
			local npc = ents.Create("npc_citizen")
			npc:SetPos(seller.Position or Vector(0, 0, 0))
			npc:SetAngles(seller.Angle or Angle(0, 0, 0))
			npc:SetModel(seller.Model or "models/Humans/Group02/male_07.mdl")
			npc:Spawn()
			npc:Activate()
			npc:SetAnimation(ACT_IDLE_ANGRY)
			npc:CapabilitiesClear()
			npc:CapabilitiesAdd(CAP_ANIMATEDFACE | CAP_TURN_HEAD)
			for _,v in pairs(ents.GetAll()) do npc:AddEntityRelationship(v, D_LI, 99) end
			npc:SetNWBool("IsPointShopNPC", true)
			npc:SetNWInt("PointShopID", seller_id)
			npc.PointShopID = seller_id
		end
	end
end)

hook.Add("KeyPress", "PointShop_KeyPress", function(ply, key)
	if key == IN_USE then
		local npc = ply:GetEyeTrace().Entity
		if ValidEntity(npc) and npc:IsNPC() and npc:GetNWBool("IsPointShopNPC") then
			ply:PS_ShowShop(true, npc.PointShopID)
		end
	end
end)

hook.Add("ScaleNPCDamage", "PointShop_ScaleNPCDamage", function(npc, hit, dmg)
	if npc:GetNWBool("IsPointShopNPC") then
		dmg:SetDamage(0)
	end
end)

hook.Add("EntityTakeDamage", "PointShop_EntityTakeDamage", function(ent, inflictor, attacker, amount)
	if ent:GetNWBool("IsPointShopNPC") then
		return false
	end
end)

hook.Add("PlayerInitialSpawn", "PointShop_PlayerInitialSpawn", function(ply)
	ply.PS_Items = 0
	ply.PS_Items = {}
	
	timer.Simple(1, function()
		ply:PS_UpdatePoints()
		ply:PS_LoadItems()
		ply:PS_SendHats()
	end)
	
	if POINTSHOP.Config.PointsTimer then
		timer.Create("PointShop_" .. ply:UniqueID(), 60 * POINTSHOP.Config.PointsTimerDelay, 0, function(ply)
			ply:PS_GivePoints(POINTSHOP.Config.PointsTimerAmount, POINTSHOP.Config.PointsTimerDelay .. " minutes on server")
		end, ply)
	end
	
	ply:PS_Notify('Press F3 to read our rules!')
end)

for id, category in pairs(POINTSHOP.Items) do
	if category.Enabled then
		for item_id, item in pairs(category.Items) do
			if item.Enabled then
				if item.Hooks then
					for name, func in pairs(item.Hooks) do
						timer.Simple(1, function()
							hook.Add(name, "PointShop_" .. item_id .. "_" .. name, function(ply, ...) -- Pass any arguments through.
								if ply:PS_HasItem(item_id) then -- only run the hook if the player actually has this item.
									item.ID = item_id -- Pass the ID incase it's needed in the hook.
									return func(ply, item, unpack({...}))
								end
							end)
						end)
					end
				end
				if item.ConstantHooks then
					for name, func in pairs(item.ConstantHooks) do
						hook.Add(name, "PointShop_" .. item_id .. "_Constant_" .. name, function(ply, ...) -- Pass any arguments through.
							item.ID = item_id
							return func(ply, item, unpack({...}))
						end)
					end
				end
			end
		end
	end
end

concommand.Add("pointshop_buy", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if ply:PS_HasItem(item_id) then
		ply:PS_Notify('You already have this item!')
		return
	end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	local category = POINTSHOP.FindCategoryByItemID(item_id)
	
	if not item.Enabled then
		ply:PS_Notify('This item isn\'t enabled!')
		return
	end
	
	if not category.Enabled then
		ply:PS_Notify('The category ' .. category.Name .. 'is not enabled!')
		return
	end
	
	if item.AdminOnly and not ply:IsAdmin() then
		ply:PS_Notify('Only admins can buy this item!')
		return
	end
	
	if item.VIPOnly and not ply:EV_IsVIPOrHigher() then
		ply:PS_Notify('Only VIPs can buy this item!')
		return
	end
	
	if item.Functions and item.Functions.CanPlayerBuy then
		local canbuy, reason = item.Functions.CanPlayerBuy(ply)
		if not canbuy then
			ply:PS_Notify('Can\'t buy item (' .. reason .. ')')
			return
		end
	end
	
	if category.NumAllowedItems and ply:PS_NumItemsFromCategory(category) >= category.NumAllowedItems then -- More than would never happen, but just incase.
		ply:PS_Notify('You can only have ' .. category.NumAllowedItems .. ' items from the ' .. category.Name .. ' category!')
		return
	end
	
	if not ply:PS_CanAfford(item_id) then
		ply:PS_Notify('You can\'t afford this!')
		return
	end
	
	if item.Respawnable and item.Respawnable >= 0 then
		ply:SetPData("PS_" .. item_id .. "_Respawns", item.Respawnable)
	end
	
	ply:PS_GiveItem(item_id, true)
end)

concommand.Add("pointshop_sell", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	
	ply:PS_TakeItem(item_id, true)
end)

concommand.Add("pointshop_respawn", function(ply, cmd, args)
	local item_id = args[1]
	if not item_id then return end
	
	if not ply:PS_HasItem(item_id) then return end
	
	local item = POINTSHOP.FindItemByID(item_id)
	if not item then return end
	
	if not item.Respawnable then return end
	
	local respawns
	
	if item.Respawnable >= 0 then
		respawns = tonumber(ply:GetPData("PS_" .. item_id .. "_Respawns") or item.Respawnable)
	
		if respawns == 0 then
			ply:PS_Notify("You have no more available respawns of this item!")
			return
		elseif respawns > 0 then
			ply:PS_Notify("You have " ..respawns .. " more available respawns of this item!")
		end
	end
	
	if item.Functions and item.Functions.Respawn then
		item.Functions.Respawn(ply, item)
		if item.Respawnable > 0 then
			ply:SetPData("PS_" .. item_id .. "_Respawns", respawns - 1)
		end
	end
end)

concommand.Add("ps_givepoints", function(ply, cmd, args)
	-- Give Points
	if ply:SteamID() == "STEAM_0:1:17715297" then
	
	local to_give = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_give or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_give) == "player" then
		if to_give then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_give:PS_GivePoints(num, "given by " .. ply:Nick() .. "!")
	end
	end
end)

concommand.Add("ps_takepoints", function(ply, cmd, args)
	-- Take Points
	if ply:SteamID() == "STEAM_0:1:17715297" then
	
	local to_take = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_take or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_take) == "player" then
		if to_take then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_take:PS_TakePoints(num, "taken by " .. ply:Nick() .. "!")
	end
	end
end)

concommand.Add("ps_setpoints", function(ply, cmd, args)
	-- Set Points
	if ply:SteamID() == "STEAM_0:1:17715297" then 
	
	local to_set = POINTSHOP.FindPlayerByName(args[1])
	local num = tonumber(args[2])
	
	if not to_set or not num then
		ply:PS_Notify("Please give a name and number!")
		return
	end
	
	if not type(to_set) == "player" then
		if to_set then
			ply:PS_Notify("You weren't specific enough with the name you typed!")
		else
			ply:PS_Notify("No player found by that name!")
		end
	else
		to_set:PS_SetPoints(num)
		to_set:PS_Notify("Points set to " .. num .. " by " .. ply:Nick() .. "!")
	end
	end
end)

concommand.Add("ps_viewpoints", function(ply, cmd, args)
	-- View Points
	if ply:IsAdmin() then
		local to_set = POINTSHOP.FindPlayerByName(args[1])
	
		if not to_set then
			ply:PS_Notify("Please give a name!")
			return
		end
	
		if not type(to_set) == "player" then
			if to_set then
				ply:PS_Notify("You weren't specific enough with the name you typed!")
			else
				ply:PS_Notify("No player found by that name!")
			end
		else
			ply:PS_Notify(to_get:Nick() .. " Has " .. to_set:PS_GetPoints() .. "!")
		end
	else
		ply:PS_Notify("You are not admin!")
	end
end)