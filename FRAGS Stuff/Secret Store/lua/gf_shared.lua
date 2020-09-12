GF.categories = {}

function GF:LoadCategories()
	local itemFolders = file.FindInLua("../addons/LDT Shop/lua/items/*")

	if (CLIENT and !SinglePlayer()) then
		itemFolders = file.FindInLua("../lua_temp/items/*")
	end

	for k, v in pairs(itemFolders) do
		if (v != "." and v != ".." and v != ".svn") then
			category = {items = {}}
			
			if (SinglePlayer()) then
				if (SERVER) then
					AddCSLuaFile("items/" .. v .. "/__setup.lua")
				end
				
				include("items/" .. v .. "/__setup.lua")
				
				if (!category.disabled) then
					local itemFiles = file.FindInLua("../addons/LDT Shop/lua/items/" .. v .. "/*.lua")
					
					for k2, v2 in pairs(itemFiles) do
						if (v2 != "__setup.lua") then
							item = {}
							
							if (SERVER) then
								AddCSLuaFile("items/" .. v .. "/" .. v2)
							end
							
							include("items/" .. v .. "/" .. v2)
							
							table.insert(category.items, item)
							
							item = nil
						end
					end
					
					GF.categories[category.position] = category
				end
				
				category = nil
			else
				if (SERVER) then
					AddCSLuaFile("items/" .. v .. "/__setup.lua")
					include("items/" .. v .. "/__setup.lua")
					
					if (!category.disabled) then
						local itemFiles = file.FindInLua("../addons/LDT Shop/lua/items/" .. v .. "/*.lua")
					
						for k2, v2 in pairs(itemFiles) do
							if (v2 != "__setup.lua") then
								item = {}
								
								AddCSLuaFile("items/" .. v .. "/" .. v2)
								include("items/" .. v .. "/" .. v2)
								
								table.insert(category.items, item)
								
								item = nil
							end
						end
						
						GF.categories[category.position] = category
					end
					
					category = nil
				elseif (CLIENT) then
					include("items/" .. v .. "/__setup.lua")
					
					if (!category.disabled) then
						local itemFiles = file.FindInLua("../lua_temp/items/" .. v .. "/*.lua")
					
						for k2, v2 in pairs(itemFiles) do
							if (v2 != "__setup.lua") then
								item = {}
								
								include("items/" .. v .."/" .. v2)
								
								table.insert(category.items, item)
								
								item = nil
							end
						end
						
						GF.categories[category.position] = category
					end
					
					category = nil
				end
			end
		end
	end
end

---------------
-- UTILITIES --
---------------

GF.GetPlayers = player.GetAll

function GF:FindPlayer(name)
	if (!name) then return nil end
	
	name = string.lower(name)
	
	local output = {}

	for k, v in pairs(self.GetPlayers()) do
		if (string.lower(v:Nick()) == name) then
			return v
		end
		
		if (string.find(string.lower(v:Nick()), name)) then
			table.insert(output, v)
		end
	end
	
	if (#output == 1) then
		return output[1]
	elseif (#output > 1) then
		return false
	else
		return nil
	end
end

------------------
-- PLAYER META	--
------------------

local meta = FindMetaTable("Player")

function meta:CanAffordScrapMetal(amount)
	return (CLIENT and GF:GetScrapMetal() >= amount) or (SERVER and self:GetScrapMetal() >= amount)
end