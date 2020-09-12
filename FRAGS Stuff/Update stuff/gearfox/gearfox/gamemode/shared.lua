GM.Name 			= "GearFox Beta"
GM.Author 			= "The Maw"
GM.Email 			= "cjbremer@gmail.com"
GM.Website 			= "www.devinity2.eu"

include("autolua.lua")

AddLuaCSFolder("cl_hud")
AddLuaCSFolder("cl_hud/vgui")
AddLuaCSFolder("cl_hud/menus")
AddLuaCSFolder("cl_various")

AddLuaCSFolder("sh_various")
AddLuaCSFolder("sh_var")

AddLuaSVFolder("sh_various")
AddLuaSVFolder("sh_var")

AddLuaSVFolder("sv_various")
AddLuaSVFolder("sv_com")



function GM:PlayerNoClip( pl )
	return (pl:IsAdmin() or self:GetGlobalSHVar("GlobalNoclip",false))
end
