AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_networking.lua")
AddCSLuaFile("vgui/ACHFrame.lua")
AddCSLuaFile("vgui/ACHNotify.lua")
AddCSLuaFile("vgui/ACHProgressBar.lua")

include( "shared.lua" )

include( "sv_config.lua" )
include( "sv_data.lua" )
include( "sv_player.lua" )

AddCSLuaFile("skin/" .. achievements.Skin .. ".lua")
resource.AddFile( "sound/achievements/achievement_earned.mp3" )
resource.AddFile( "materials/gui/achievements/gift.png" )
resource.AddFile( "materials/gui/achievements/null.png" )