	
function GM:HUDPaint()
	DrawRect( 0, 0, ScrW(), 20, MAIN_COLOR )
	DrawText( GM.Name, "Trebuchet18", 5, 0, MAIN_TEXTCOLOR )

	DrawHealthbar()
end

