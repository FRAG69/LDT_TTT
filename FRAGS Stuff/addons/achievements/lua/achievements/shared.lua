--[[
    Garry's Mod Achievements
    Copyright (c) 2014, Matt Stevens
    All rights reserved.

    Redistribution with or without modification, is strictly prohibited.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
]]--

ACHIEVEMENT_ONEOFF = 1
ACHIEVEMENT_PROGRESS = 2

achievements = achievements or {} -- need a better name damn it default gmod
achievements.Config = {}
achievements.Path = debug.getinfo(1, "S" ).source:gsub("@addons/achievements/lua/", ""):gsub("/shared.lua", "") -- I'm so sorry.

include "sh_config.lua"

local BASE = {}
BASE.Type = ACHIEVEMENT_ONEOFF
BASE.Description = ""
BASE.Icon = "gui/achievements/null.png"
BASE.Target = 0

local categories = {
    ["All"] = { Name = "All", Icon = "icon16/asterisk_yellow.png", DisplayOrder = 9999, Achievements = {} }
}

function achievements.CreateCategory( catname )
    categories[catname] = {
        Name = catname,
		Achievements = {}
    }
    return categories[catname]
end

function achievements.GetCategories()
    return categories
end

local achvs = { }

function achievements.GetAchievement( name )
	return achvs[ name or "" ]
end

function achievements.Register( category, id, name, tbl, base )
    category = category.Name
    if not categories[ category ] then -- string.Format pls
        ErrorNoHalt( string.format( "Failed to register achievement %q! (Invalid category)\n", name ) )
        return
    end

    local o = {}
	setmetatable( o, {__index = BASE} )
    table.Merge( o, tbl )
	o.ID = id
    o.Name = name
    o.Category = category

	if SERVER and o.Icon then resource.AddFile( "materials/" .. o.Icon ) end
	
    achvs[ id ] = o
    table.insert( categories[ category ].Achievements, id )
    table.insert( categories[ "All" ].Achievements, id )

    print( string.format( "Registered achievement %q.", name ) ) 
end

if SERVER then
	hook.Add("Initialize", "AchievementsInitialize", function()
		for _, o in pairs(categories) do resource.AddFile( "materials/" .. o.Icon ) end
		for _, o in pairs(achvs) do
			local cat = categories[ o.Category ]
			if o.Initialize and ( cat.Active == nil or cat.Active() ) then o:Initialize() end
		end
	end)

	function BASE:Initialize() end

    function BASE:AddPoint( ply, pt )
        pt = pt or 1
        local t = self.Target
        if ((!t) || (t == 0)) then return end
		
		local plyData = achievements.GetPlayerAchievementData( ply, self.ID )
		if ( plyData.Completed ) then return end
		
		plyData.Value = math.Clamp( plyData.Value + pt, 0, t )
		
		if ( plyData.Value == t ) then
			self:Complete( ply )
			return
		end
		
		achievements.SetPlayerAchievementData( ply, self.ID, plyData )
    end
	
	function BASE:SetPoint( ply, pt )
        local t = self.Target
        if ((!t) || (t == 0)) then return end
		
		local plyData = achievements.GetPlayerAchievementData( ply, self.ID ) or {}
		if ( plyData.Completed ) then return end
		
		plyData.Value = math.Clamp( pt, 0, t )
		
		if ( plyData.Value == t ) then
			self:Complete( ply )
			return
		end
		
		achievements.SetPlayerAchievementData( ply, self.ID, plyData )
	end
	
	function BASE:GetPoints( ply )
		local plyData = achievements.GetPlayerAchievementData( ply, self.ID ) or {}
		return tonumber(plyData.Value) or 0
	end
	
	function BASE:Complete( ply )
		local plyData = achievements.GetPlayerAchievementData( ply, self.ID ) or {}
		if ( plyData.Completed ) then return end
	
		local data = {
			Value = self.Target,
			Completed = true,
			CompletedOn = os.time()
		}
	
		achievements.SetPlayerAchievementData( ply, self.ID, data, true )
		
		if self.Rewards then
			for _, reward in pairs(self.Rewards) do
				if reward["ps_points"] then
					if not PS then continue end
					ply:PS_GivePoints(reward["ps_points"])
				elseif reward["ps_item"] then
					if not PS then continue end
					ply:PS_GiveItem(reward["ps_item"])
				end
			end
		end

		net.Start("AchvUnlocked")
			net.WriteEntity(ply)
			net.WriteString(self.ID)
		net.Broadcast()
	end
end

local function LoadAchievements()
	local files = file.Find( achievements.Path .. "/achv/*", "LUA" )
	for _, file in pairs(files) do
		if SERVER then AddCSLuaFile("achv/" .. file) end
		include("achv/" .. file)
	end
end

LoadAchievements()