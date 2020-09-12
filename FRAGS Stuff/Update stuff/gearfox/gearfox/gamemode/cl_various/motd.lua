
local MOTD_URL 		= "http://andlit.com/fastdl/themaw/public/mawbasemotd/changelog.txt" --Change URL here.
local MOTD_ENABLE 	= true

function GM:SetMOTD(url)
	MOTD_URL = url
end

function GM:EnableMOTD(boolean)
	MOTD_ENABLE = boolean
end

function GM:ReloadMOTD()
	if (!MOTD_ENABLE) then return end
	
	if (GM.MOTD) then
		GM.MOTD:OpenURL(MOTD_URL)
		GM.MOTD:SetVisible(true)
	end
end
	

hook.Add("InitPostEntity","MawBase_MOTD",function()
	if (!MOTD_ENABLE) then return end
	
	GM = GM or GAMEMODE
	
	GM.MOTD = vgui.Create("MBBrowser")
	GM.MOTD:SetTitle("Message of the Day")
	GM.MOTD:SetPos(100,100)
	GM.MOTD:SetSize(ScrW()-200,ScrH()-200)
	GM.MOTD:SetDraggable( false )
	GM.MOTD:SetSizable( false )
	GM.MOTD:SetDeleteOnClose( false )
	GM.MOTD:OpenURL(MOTD_URL)
	GM.MOTD:MakePopup()
end)