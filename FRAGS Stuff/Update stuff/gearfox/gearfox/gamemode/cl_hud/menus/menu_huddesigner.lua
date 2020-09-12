
local HDes
local HDes_BG = surface.GetTextureID("mawbase/designerbg")

-- Objects in the designer. This will allow the player to select the different objects and modify them etc.
local Objects = {}
local Tools = {
	"Hand",
	"Rect",
	"Round",
	"Paint",
	"Delete",
}

local Tools_Tex = {
	surface.GetTextureID("mawbase/designer/icon_hand"),
	surface.GetTextureID("mawbase/designer/icon_rect"),
	surface.GetTextureID("mawbase/designer/icon_round"),
	surface.GetTextureID("mawbase/designer/icon_paint"),
	surface.GetTextureID("mawbase/designer/icon_erase"),
}

local Tools_Clear = surface.GetTextureID("mawbase/designer/icon_clear")
local Tools_Save  = surface.GetTextureID("mawbase/designer/icon_save")

local Tools_Shad = Color(20,40,60,100)
local OffsetDrag = nil




hook.Add("OnContextMenuOpen","OpenDesigner",function()
	if (!GAMEMODE.Name:find("GearFox")) then hook.Remove("OnContextMenuOpen","OpenDesigner") return end

	if (!HDes) then
		HDes = vgui.Create("MBFrame")
		HDes:SetTitle("GearFox HUD Designer")
		HDes:SetPos(50,50)
		HDes:SetSize(559,542)
		HDes:MakePopup()
		HDes:SetSizable(false)
		HDes:SetDeleteOnClose(false)
		
		HDes.Tool 	= "Hand"
		
		HDes.StartP = nil
		HDes.EndP   = nil
		
		HDes.ScaleX = ScrW()/512
		HDes.ScaleY = ScrH()/512
		
		HDes.DragOb = nil
		HDes.IsScal = false
		
		HDes.Paint 	= function(s)
			DrawBoxy(0,0,s:GetWide(),s:GetTall(),s.bgcol)
			DrawLine(0,20,s:GetWide(),20,s.fgcol)
			DrawTexturedRect(42,25,512,512,MAIN_COLOR2,HDes_BG)
			
			for k,v in pairs(Objects) do
				local Posx,Posy = s:ScreenToLocal(v[1],v[2])
				local Siz = {v[3],v[4],}
				local Typ = v[5]
				local Col = v[6]
				
				if (Typ == "Round") then DrawBoxy(Posx,Posy,Siz[1],Siz[2],Col)
				elseif (Typ == "Rect") then DrawRect(Posx,Posy,Siz[1],Siz[2],Col) end
			end
			
			
			if (s.StartP) then
				local Ax,Ay = s:ScreenToLocal(s.StartP[1],s.StartP[2])
				DrawOutlinedRect(Ax,Ay,s.EndP[1],s.EndP[2],MAIN_COLOR2)
				DrawRect(Ax+s.EndP[1]-5,Ay+s.EndP[2]-5,5,5,MAIN_COLOR2)
				
				DrawText("X:"..(Ax-42).." Y:"..(Ay-25),"Trebuchet18",Ax+s.EndP[1]/2,Ay+s.EndP[2]/2-10,MAIN_TEXTCOLOR,1)
				DrawText("W:"..s.EndP[1].." H:"..s.EndP[2],"Trebuchet18",Ax+s.EndP[1]/2,Ay+s.EndP[2]/2+10,MAIN_TEXTCOLOR,1)
			end
		end
		
		
		
		
		HDes.Think = function(s)
			local x1,y1  = s:GetPos()
			local InABox = false
					
			if (s.DragOb) then
				InABox = true
						
				if (s.IsScal) then
					local X,Y = gui.MousePos()
						
					s.DragOb[3] = math.Clamp(X-s.DragOb[1]+2,4,512-(s.DragOb[1]-x1)+42)
					s.DragOb[4] = math.Clamp(Y-s.DragOb[2]+2,4,512-(s.DragOb[2]-y1)+25)
							
				else
					local X,Y = s:ScreenToLocal(gui.MousePos())
						
					if (!OffsetDrag) then OffsetDrag = {X-s.DragOb[1],Y-s.DragOb[2],} end
							
					s.DragOb[1] = math.Clamp(X-OffsetDrag[1]-x1,42,554-s.DragOb[3])+x1
					s.DragOb[2] = math.Clamp(Y-OffsetDrag[2]-y1,25,537-s.DragOb[4])+y1
						
				end
						
				s.StartP = {s.DragOb[1],s.DragOb[2],}
				s.EndP 	 = {s.DragOb[3],s.DragOb[4],}
						
				if (!input.IsMouseDown(MOUSE_LEFT)) then s.DragOb = nil OffsetDrag = nil s.IsScal = false end
						
				return
			end
			
			
			if (input.IsMouseInBox(x1+42,y1+25,512,512)) then
			
				if (s.Tool == "Round" or s.Tool == "Rect") then
				
					if (input.IsMouseDown(MOUSE_LEFT)) then
						local x,y = gui.MousePos()
					
						if (!s.StartP) then s.StartP = {x,y,} end
						
						s.EndP = {
							math.Clamp(x-s.StartP[1],4,512-(s.StartP[1]-x1)+42),
							math.Clamp(y-s.StartP[2],4,512-(s.StartP[2]-y1)+25),}
						
					elseif (s.StartP) then
						if (s.EndP[1] < 2 and s.EndP[2] < 2) then return end
						table.insert(Objects,{
							s.StartP[1],
							s.StartP[2],
							s.EndP[1],
							s.EndP[2],
							s.Tool,
							MAIN_COLOR,
						})
						
						s.StartP = nil
						s.EndP = nil
					end
					
					
				elseif (s.Tool == "Hand" or s.Tool == "Delete" or s.Tool == "Paint") then
				
					for k,v in pairs(Objects) do
						if (input.IsMouseInBox(v[1],v[2],v[3],v[4])) then
							if (!InABox and (!s.Settings or !s.Settings:IsVisible())) then
							
								s.StartP 	= {v[1],v[2],}
								s.EndP 		= {v[3],v[4],}
								
								InABox 		= true
							end
							
							
							
							if (input.MousePress(MOUSE_LEFT)) then
								if (s.Tool == "Delete") then table.remove(Objects,k) return end
								
								if (s.Tool == "Paint") then 
									local Col = C_CUBE:GetRGB()
									Col.a = math.Round(255 - C_ALPHA:GetSlideY() * 255)
									v[6] = table.Copy(Col)
									
									return
								end
								
								s.DragOb = v
								
								if (input.IsMouseInBox(v[1]+v[3]-5,v[2]+v[4]-5,5,5)) then s.IsScal = true end
								
								InABox = false
							end
							
							return
						end
					end
					
					if (!InABox and s.StartP) then s.StartP = nil s.EndP = nil end
				end
			end
		end
		
		for k,v in pairs(Tools) do
			local a = vgui.Create("MBButton",HDes)
			a:SetPos(5,30+32*(k-1))
			a:SetSize(32,32)
			a:SetText("")
			a.DoClick = function() HDes.StartP = nil HDes.EndP = nil HDes.Tool = v end
			a.Paint = function() 
				if (HDes.Tool == v) then DrawRect(0,7,32,18,Tools_Shad) end
				DrawTexturedRect(0,0,32,32,MAIN_WHITECOLOR,Tools_Tex[k])
			end
		end
		
		local a = vgui.Create("MBButton",HDes)
		a:SetPos(5,HDes:GetTall()-37)
		a:SetSize(32,32)
		a:SetText("")
		a.DoClick = function() Objects = {} end
		a.Paint = function() 
			DrawTexturedRect(0,0,32,32,MAIN_WHITECOLOR,Tools_Clear)
		end
		
		local a = vgui.Create("MBButton",HDes)
		a:SetPos(5,HDes:GetTall()-74)
		a:SetSize(32,32)
		a:SetText("")
		a.DoClick = function() CompileDesignToLuaFile() LocalPlayer():AddNote("Design has been compiled in:") LocalPlayer():AddNote("garrysmod/data/gearfox/design") end
		a.Paint = function() 
			DrawTexturedRect(0,0,32,32,MAIN_WHITECOLOR,Tools_Save)
		end
		
		C_CUBE = vgui.Create("DColorCube",HDes)
		C_CUBE:SetPos(5,269)
		C_CUBE:SetSize(33,64)
		C_CUBE.OnUserChanged = function(s) end
		
		C_ALPHA = vgui.Create("DAlphaBar",HDes)
		C_ALPHA:SetPos(27,200)
		C_ALPHA:SetSize(10,64)
		C_ALPHA.OnChange = function(s,alp) end
		
		C_RGB = vgui.Create("DRGBBar",HDes)
		C_RGB:SetPos(5,200)
		C_RGB:SetSize(20,64)
		C_RGB.OnColorChange = function(s,Col)
			C_CUBE:SetColor(Col)
			C_ALPHA:SetImageColor(Col)
		end
	end
	
	HDes.StartP = nil
	HDes.EndP = nil
	HDes:SetVisible(true)
end)



function CompileDesignToLuaFile()
	local StartT = [[/* COMPILED USING THE MAWS GEARFOX HUD DESIGNER */ 
]]
	local Col = [[
local DATA_COLOR = {
]]
	local Typ = [[hook.Add("HUDPaint","CompiledPaint_GearFox",function()
]]
	local Dat = 0
	
	for k,v in pairs(Objects) do
		Dat = Dat+1
		Col = Col..[[	Color(]]..v[6].r..[[,]]..v[6].g..[[,]]..v[6].b..[[,]]..v[6].a..[[),
]]
		
		local X,Y = HDes:ScreenToLocal(v[1],v[2])
		
		if (v[5] == "Round") then
			Typ = Typ..[[	DrawBoxy(]]..math.ceil((X-42)*HDes.ScaleX)..[[,]]..math.ceil((Y-25)*HDes.ScaleY)..[[,]]..math.ceil(v[3]*HDes.ScaleX)..[[,]]..math.ceil(v[4]*HDes.ScaleY)..[[,DATA_COLOR[]]..Dat..[[]); 
]]
		else
			Typ = Typ..[[	DrawRect(]]..math.ceil((X-42)*HDes.ScaleX)..[[,]]..math.ceil((Y-25)*HDes.ScaleY)..[[,]]..math.ceil(v[3]*HDes.ScaleX)..[[,]]..math.ceil(v[4]*HDes.ScaleY)..[[,DATA_COLOR[]]..Dat..[[]); 
]]
		end
	end
	
	Col = Col..[[}

]]
	
	Typ = Typ..[[end)
]]
	
	StartT = StartT..Col..Typ
	
	file.Write("GearFox/Design/Cur.txt",StartT)
end
	
	
	
	
	
	
	