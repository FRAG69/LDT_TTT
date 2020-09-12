	
function GM:HUDPaint()
	DrawRect( 0, 0, ScrW(), 20, MAIN_COLOR )
	DrawText( GM.Name, "Trebuchet18", 5, 0, MAIN_TEXTCOLOR )
	
	DrawHealthbar()
	
	DrawBoxy( 220, ScrH()-60, 200, 50, MAIN_COLOR )
	DrawText( "$"..LocalPlayer():GetMoney(), "Trebuchet24", 235, ScrH()-47, MAIN_TEXTCOLOR )
	
	local XP = LocalPlayer():GetXP()
	local Ne = LocalPlayer():GetNeedXP()
	local Co = XP/Ne
	
	DrawRect( 0, 20, ScrW(), 10, MAIN_RPGCOLORD )
	DrawRect( 0, 20, ScrW()*Co, 10, MAIN_GREENCOLOR )
	DrawOutlinedRect( 0, 20, ScrW(), 10, MAIN_COLOR2 )
	
	DrawText( "Level: "..LocalPlayer():GetLevel(), "Trebuchet18", ScrW()/2-100, 0, MAIN_TEXTCOLOR)
	DrawText( "XP: ("..XP.."/"..Ne..")", "Trebuchet18", ScrW()/2, 0, MAIN_TEXTCOLOR )
end

