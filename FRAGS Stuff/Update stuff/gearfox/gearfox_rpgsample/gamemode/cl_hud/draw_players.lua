local UpVec = Vector(0,0,80)
local C	 	= MAIN_TEXTCOLOR
local C2	= MAIN_COLORD

hook.Add("HUDPaint","DrawPlayerNames",function()
	for k,pl in pairs( player.GetAll() ) do
		if (LocalPlayer() != pl) then 
			local Dis = pl:GetPos():Distance(LocalPlayer():GetPos())
			
			if (Dis < 800) then
				local spos	= (pl:GetPos()+UpVec):ToScreen()
				local Alpha = math.Clamp(Dis/800,0,1)
				local A		= C.a*1
				local A2	= C2.a*1
				
				surface.SetFont("Trebuchet24")
				
				local W,H = surface.GetTextSize(pl:Nick())
				
				C.a		= A-A*Alpha
				C2.a 	= A2-A2*Alpha
				
				local x = spos.x-W/2-10
				local y = spos.y-30
				
				DrawBoxy( x, y, W+20, 50, C2 )
				DrawText( pl:Nick(), "Trebuchet24", x+10, y+5, C )
				DrawText( "Level "..pl:GetLevel(), "Trebuchet18", x+10, y+25, C )
				
				C.a 	= A
				C2.a 	= A2
			end
		end
	end
end)