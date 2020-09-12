function DrawHealthbar()
	local HP = LocalPlayer():Health()
	local MP = 100 --player:GetMaxHealth() apparently doesn't work quite well on Clients...
	local C  = math.Clamp(HP/MP,0,1)

	DrawBoxy( 10, ScrH()-60, 200, 50, MAIN_COLOR )
	DrawRect( 20, ScrH()-50, 180, 30, MAIN_BLACKCOLOR )
	DrawRect( 20, ScrH()-50, 180*C, 30, MAIN_GREENCOLOR )
	DrawText( HP.."/"..MP, "Trebuchet24", 110, ScrH()-35, MAIN_TEXTCOLOR, 1 )
end