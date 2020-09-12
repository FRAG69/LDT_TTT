require("glon")

AddCSLuaFile("autorun/gf_load.lua")
AddCSLuaFile("gf_shared.lua")
AddCSLuaFile("gf_client.lua")

include("gf_shared.lua")

resource.AddFile("materials/goldenforge/icon_purchase.vmt")
resource.AddFile("materials/goldenforge/icon_trailcolor.vmt")

-----------
-- HOOKS --
-----------

hook.Add("PlayerDisconnected", "GoldenForge:PlayerDisconnected", function(player)
	if (IsValid(player.gfTrail)) then
		player.gfTrail:Remove()
	end
	
	player:SaveGFData()
end)

local additionalData = {}

function GF:AddPlayerData(name, data, callback)
	additionalData[name] = {data, callback}
end

hook.Add("PlayerInitialSpawn", "GoldenForge:PlayerInitialSpawn", function(player)
	player:ChatPrint("This server is running GoldenForge 1.1! Press F4 for menu.")
	
	timer.Simple(0.3, function()
		if (IsValid(player)) then
			player.gfData = {scrapMetal = 0, hats = {}, trails = {}, equippedHats = "", currentTrail = {id = "", color = color_white}}
			
			local path = "GoldenForge/playerdata/" .. player:GetSafeSteamID() .. ".txt"
			
			if (file.Exists(path)) then
				local data = glon.decode(file.Read(path))
				
				if (data and data != "") then
					player.gfData = data
				end
			end
			
			for k, v in pairs(additionalData) do
				if (!player.gfData[k]) then
					player.gfData[k] = v[1]
				end
				
				if (v[2]) then
					v[2](player)
				end
			end
			
			if (player.gfData.scrapMetal > 0) then
				umsg.Start("gf_gmtl", player)
					umsg.Long(player.gfData.scrapMetal)
				umsg.End()
			end
			
			if (player.gfData.currentTrail.id != "") then
				umsg.Start("gf_gtoeqtl", player)
					umsg.String(player.gfData.currentTrail.id)
				umsg.End()
				
				local color = Vector(player.gfData.currentTrail.color.r, player.gfData.currentTrail.color.g, player.gfData.currentTrail.color.b)
				
				umsg.Start("gf_gtoeqtlc", player)
					umsg.Vector(color)
				umsg.End()
			end
			
			timer.Simple(1, function()
				if (IsValid(player)) then
					umsg.Start("gf_gteqht")
						umsg.Entity(player)
						umsg.String(player.gfData.equippedHats)
					umsg.End()
					
					for k, v in pairs(player.gfData.hats) do
						umsg.Start("gf_gtodhs", player)
							umsg.String(k)
						umsg.End()
					end
					
					for k, v in pairs(player.gfData.perks) do
					    umsg.Start("gf_gtodpk", player)
						    umsg.String(k)
						umsg.End()
					end
					
					for k, v in pairs(player.gfData.trails) do
						umsg.Start("gf_gtodts", player)
							umsg.String(k)
						umsg.End()
					end
					
					if (player:GetObserverMode() == OBS_MODE_NONE and player.gfData.currentTrail.id != "") then
						local data = GF:GetTrail(player.gfData.currentTrail.id)
						
						if (data) then
							player.gfTrail = util.SpriteTrail(player, 0, player.gfData.currentTrail.color, false, 15, 1, 4, 0.125, data.material .. ".vmt")
						end
					end
				end
			end)
			
			timer.Simple(2, function()
				if (IsValid(player)) then
					for k, v in pairs(GF.GetPlayers()) do
						if (v != player and v.gfLoaded and v.gfData.equippedHats != "") then
							umsg.Start("gr_gteqht", player)
								umsg.Entity(v)
								umsg.String(v.gfData.equippedHats)
							umsg.End()
						end
					end
					
					player.gfLoaded = true
				end
			end)
			
			timer.Simple(2, function()
			Msg( "DEBUG PERK TIMER RUNNING\n" )
			    if (IsValid(player)) then
				    for k, v in pairs(GF.GetPlayers()) do
					    if (v != player and v.gfLoaded and v.gfData.equippedPerks !- "") then
						    umsg.Start("gr_gteqpk", player)
							    umsg.Entity(v)
								umsg.String(v.gfData.equippedPerks)
							umsg.End()
						end
					end
					
					player.gfLoaded = true
				end
			end)
		end
	end)
end)

hook.Add("PlayerSpawn", "GoldenForge:PlayerSpawn", function(player)
	if (player.gfLoaded and !IsValid(player.gfTrail) and player:GetObserverMode() == OBS_MODE_NONE and player.gfData.currentTrail.id != "") then
		local data = GF:GetTrail(player.gfData.currentTrail.id)

		if (data) then
			player.gfTrail = util.SpriteTrail(player, 0, player.gfData.currentTrail.color, false, 15, 1, 4, 0.125, data.material .. ".vmt")
		end
	end
end)

hook.Add("PlayerDeath", "GoldenForge:PlayerDeath", function(victim, weapon, killer)
	if (IsValid(victim) and IsValid(victim.gfTrail)) then
		victim.gfTrail:Remove()
	end
end)

hook.Add("PlayerSay", "GoldenForge:PlayerSay", function(player, text, onlyTeam, dead)
	if (string.sub(text, 1, 15) == "/givescrapmetal") then
		umsg.Start("gf_gvspml", player)
		umsg.End()

		return ""
	elseif (string.sub(text, 1, 15) == "/admingivemetal") then
		umsg.Start("gf_gvaspml", player)
		umsg.End()

		return ""
	end
end)

hook.Add("ShowSpare2", "GoldenForge:ShowSpare2", function(player)
	if (player.gfLoaded) then
		player:ConCommand("gf_showmenu")
	else
		player:ChatPrint("Loading data...")
	end
end)

------------------
-- CONCOMMANDS	--
------------------

concommand.Add("gf_bytrl", function(player, command, arguments)
	local data = GF:GetTrail(arguments[1])
	
	if (data) then
		if (!player:OwnsTrail(data.unique)) then
			if (player:CanAffordScrapMetal(data.price)) then
				player.gfData.trails[data.unique] = true
				
				umsg.Start("gf_gtodts", player)
					umsg.String(data.unique)
				umsg.End()
				
				player:RemoveScrapMetal(data.price, "Purchased a trail. -" .. data.price .. ".")
			else
				player:ChatPrint("You can't afford this trail.")
			end
		else
			player:ChatPrint("You already own this trail.")
		end
	end
end)

concommand.Add("gf_sctrl", function(player, command, arguments)
	local unique = arguments[1]
	
	if (player:OwnsTrail(unique)) then
		local color = string.Explode(" ", arguments[2])
		
		player.gfData.currentTrail.color = Color(tonumber(color[1]), tonumber(color[2]), tonumber(color[3]), 255)
		
		if (IsValid(player.gfTrail)) then
			player.gfTrail:SetColor(player.gfData.currentTrail.color)
		end

		umsg.Start("gf_gtoeqtlc", player)
			umsg.Vector(Vector(tonumber(color[1]), tonumber(color[2]), tonumber(color[3])))
		umsg.End()
	
		player:SaveGFData()
	end
end)

concommand.Add("gf_eqtrl", function(player, command, arguments)
	local unique = arguments[1]
	
	if (player:OwnsTrail(unique)) then
		if (arguments[2] and arguments[2] == "1") then
			player.gfData.currentTrail.id = ""
			
			if (IsValid(player.gfTrail)) then
				player.gfTrail:Remove()
			end
			
			umsg.Start("gf_gtoeqtl", player)
				umsg.String("")
			umsg.End()
			
			player:SaveGFData()
		else
			local data = GF:GetTrail(unique)
			
			if (data) then
				player.gfData.currentTrail.id = unique
				
				if (player:GetObserverMode() == OBS_MODE_NONE) then
					if (IsValid(player.gfTrail)) then
						player.gfTrail:Remove()
					end
					
					player.gfTrail = util.SpriteTrail(player, 0, player.gfData.currentTrail.color, false, 15, 1, 4, 0.125, data.material .. ".vmt")
				end
				
				umsg.Start("gf_gtoeqtl", player)
					umsg.String(unique)
				umsg.End()
				
				player:SaveGFData()
			end
		end
	end
end)

concommand.Add("gf_eqht", function(player, command, arguments)
	local equipped = string.Explode(";", arguments[1])
	
	if (equipped[#equipped] == "") then
		table.remove(equipped, #equipped)
	end
	
	player.gfData.equippedHats = ""
	
	for k, v in pairs(equipped) do
		if (player:OwnsHat(v)) then
			player.gfData.equippedHats = player.gfData.equippedHats .. v .. ";"
		end
	end
	
	player:SaveGFData()
	
	umsg.Start("gf_gteqht")
		umsg.Entity(player)
		umsg.String(player.gfData.equippedHats)
	umsg.End()
end)

concommand.Add("gf_byht", function(player, command, arguments)
	local data = GF:GetHat(arguments[1])
	
	if (!player:OwnsHat(id)) then
		if (data) then
			if (player:CanAffordScrapMetal(data.price)) then
				player.gfData.hats[data.unique] = true
				
				player:RemoveScrapMetal(data.price, "You have bought a hat. -" .. data.price .. " scrap metal.")
				
				umsg.Start("gf_gtodhs", player)
					umsg.String(data.unique)
				umsg.End()
			else
				player:ChatPrint("You can't afford this hat.")
			end
		end
	else
		player:ChatPrint("You already own this hat.")
	end
end)

concommand.Add("gf_eqpk", function(player, command, arguments)
	local equipped = string.Explode(";", arguments[1])
	
	if (equipped[#equipped] == "") then
		table.remove(equipped, #equipped)
	end
	
	player.gfData.equippedPerks = ""
	
	for k, v in pairs(equipped) do
		if (player:OwnsPerk(v)) then
			player.gfData.equippedPerks = player.gfData.equippedPerks .. v .. ";"
		end
	end
	
	player:SaveGFData()
	
	umsg.Start("gf_gteqpk")
		umsg.Entity(player)
		umsg.String(player.gfData.equippedPerks)
	umsg.End()
end)

concommand.Add("gf_bypk", function(player, command, arguments)
	local data = GF:GetPerk(arguments[1])
	
	if (!player:OwnsPerk(id)) then
		if (data) then
			if (player:CanAffordScrapMetal(data.price)) then
				player.gfData.perks[data.unique] = true
				
				player:RemoveScrapMetal(data.price, "You have bought a perk. -" .. data.price .. " scrap metal.")
				
				umsg.Start("gf_gtodpk", player)
					umsg.String(data.unique)
				umsg.End()
			else
				player:ChatPrint("You can't afford this perk.")
			end
		end
	else
		player:ChatPrint("You already own this perk.")
	end
end)

concommand.Add("gf_gvspml", function(player, command, arguments)
	local target = GF:FindPlayer(arguments[1])
	
	if (IsValid(target)) then
		local amount = tonumber(arguments[2])
	
		if (target != player and type(amount) == "number" and player:CanAffordScrapMetal(amount)) then
			target:GiveScrapMetal(amount, "Player '" .. player:Nick() .. " has given you '" .. amount .. "' scrap metal.")
			player:RemoveScrapMetal(amount, "You have given '" .. target:Nick() .. "' '" .. amount .. "' scrap metal.")
		end
	elseif (target == false) then
		player:ChatPrint("Found more than one player with that name. Be more specific!")
	elseif (target == nil) then
		player:ChatPrint("Can't find a player with that name.")
	end
end)

concommand.Add("gf_gvaspml", function(player, command, arguments)
	local target = GF:FindPlayer(arguments[1])
	
	if (IsValid(target)) then
		local amount = math.Clamp(tonumber(arguments[2]), 0, 2147483630)
	
		if (player:IsSuperAdmin()) then
			target:GiveScrapMetal(amount, "Player '" .. player:Nick() .. " has given you '" .. amount .. "' scrap metal.")
		else
			player:ChatPrint("You're not superadmin!")
		end
	elseif (target == false) then
		player:ChatPrint("Found more than one player with that name. Be more specific!")
	elseif (target == nil) then
		player:ChatPrint("Can't find a player with that name.")
	end
end)

-------------------
--  PLAYER META	 --
-------------------

local meta = FindMetaTable("Player")

function meta:GetSafeSteamID()
	return string.sub(self:SteamID(), 11)
end

function meta:SaveGFData()
	if (self.gfData) then
		local path = "GoldenForge/playerdata/" .. self:GetSafeSteamID() .. ".txt"
		
		file.Write(path, glon.encode(self.gfData))
	end
end

function meta:OwnsTrail(id)
	return self.gfData.trails[id] != nil
end

function meta:OwnsHat(id)
	return self.gfData.hats[id] != nil
end
/*
function meta:OwnsPerk (id)
    return self.gfData.perks[id] != nil  --Perk Implementation
end
*/

function meta:GiveScrapMetal(amount, reason)
	self.gfData.scrapMetal = math.Clamp(self.gfData.scrapMetal +amount, 0, 2147483630)
	
	umsg.Start("gf_gmtl", self)
		umsg.Long(self.gfData.scrapMetal)
	umsg.End()
	
	if (reason) then
		umsg.Start("gf_cmsg", self)
			umsg.String(tostring(reason))
		umsg.End()
	end
	
	self:SaveGFData()
end

function meta:RemoveScrapMetal(amount, reason)
	self.gfData.scrapMetal = math.Clamp(self.gfData.scrapMetal -amount, 0, 2147483630)
	
	umsg.Start("gf_gmtl", self)
		umsg.Long(self.gfData.scrapMetal)
	umsg.End()
	
	if (reason) then
		umsg.Start("gf_cmsg", self)
			umsg.String(tostring(reason))
		umsg.End()
	end
	
	self:SaveGFData()
end

function meta:GetScrapMetal()
	return self.gfData.scrapMetal
end

function meta:GetGFData(field)
	return self.gfData[field]
end

GF:LoadCategories()