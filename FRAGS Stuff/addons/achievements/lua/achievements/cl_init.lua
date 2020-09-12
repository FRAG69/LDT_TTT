include("shared.lua")
include("cl_networking.lua")
include("vgui/ACHNotify.lua")
include("vgui/ACHProgressBar.lua")

function achievements.Award(ply, name, icon)
	if ( ply == LocalPlayer() ) then
		local notify = vgui.Create("AchievementsNotify")
		notify:SetAchievement( name, icon )
		surface.PlaySound( "achievements/achievement_earned.mp3" )
	end
	
	-- TTT quicky - shows achievements ONLY to dead players if the round is live.
	if ( LocalPlayer().IsActive and LocalPlayer():IsActive() ) then return end
	
	chat.AddText( ply, Color(255, 255, 255), " just unlocked the achievement ", Color(100, 255, 100), name )
	
    local ed = EffectData()
    ed:SetEntity(ply)
    util.Effect("achievement", ed)
end

achievements.CurrentView = nil

local function OpenAchievements()
	if achievements.CurrentView then
		if ValidPanel(achievements.CurrentView.ParentFrame) and achievements.CurrentView.ParentFrame:IsVisible() then
			achievements.CurrentView.ParentFrame:Close()
			achievements.CurrentView = nil
			return
		end
	end

	include( achievements.Path .. "/skin/" .. achievements.Skin .. ".lua" )
	achievements.CurrentView = VIEW
	VIEW = nil
	
	achievements.CurrentView:Init( {
		WindowTitle = achievements.FrameTitle or "Achievements"
	} )

	local categories = table.ClearKeys( table.Copy(achievements.GetCategories()) )
	table.SortByMember( categories, "DisplayOrder", true )

	for k, v in ipairs( categories ) do
		local ownAch = 0
		local totalAch = 0
		for _, ach in pairs( v.Achievements ) do
			local plyData = achievements.LocalData[ach] or {}
			ownAch = plyData.Completed and ( ownAch + 1 ) or ownAch
			totalAch = totalAch + 1
		end
		
		achievements.CurrentView:AddCategory(v.Name, v.Icon, ownAch, totalAch)
	end
	
	for _, v in ipairs( categories ) do
		local incompleteAchievements = {}
		local completedAchievements = {}
	
		for _, v2 in pairs( v.Achievements ) do
			local data = table.Copy( achievements.GetAchievement( v2 ) )
			local plyData = achievements.GetPlayerData( data.ID )
			
			table.Merge( data, plyData )
			data.Category = v.Name
			
			table.insert( data.Completed and completedAchievements or incompleteAchievements, data )
			
		end
		
		table.SortByMember( incompleteAchievements, "Name", true )
		table.SortByMember( completedAchievements,  "Name", true )
		
		for _, data in ipairs( incompleteAchievements ) do achievements.CurrentView:AddAchievement( data ) end
		for _, data in ipairs( completedAchievements )  do achievements.CurrentView:AddAchievement( data ) end
	end
end

local btnPressed = false
hook.Add("Think", "AchievementsButtonListener", function()
	if input.IsKeyDown(achievements.OpenKey) then
		if btnPressed then return end
		btnPressed = true
		
		OpenAchievements()
	else
		btnPressed = false
	end
end)

hook.Add("OnPlayerChat", "OpenAchievements", function(ply, msg)
    if ply ~= LocalPlayer() then return end
    if not ( string.sub(msg, 1, string.len(achievements.ChatCommand)) == achievements.ChatCommand ) then return end
    OpenAchievements()
end)

concommand.Add(achievements.ConsoleCommand, OpenAchievements)