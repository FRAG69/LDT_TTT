--BY KAZAKI--

local function DrawTarget(tgt, size, offset, no_shrink)
   local scrpos = tgt.pos:ToScreen() -- sweet
   local sz = (IsOffScreen(scrpos) and (not no_shrink)) and size/2 or size

   scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
   scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)

   surface.DrawTexturedRect(scrpos.x - sz, scrpos.y - sz, sz * 2, sz * 2)

   if sz == size then
      local text = math.ceil(LocalPlayer():GetPos():Distance(tgt.pos))
      local w, h = surface.GetTextSize(text)

      if offset then
         surface.SetTextPos(scrpos.x - w/2, scrpos.y + (offset * sz) - h/2)
         surface.DrawText(text)
      else
         surface.SetTextPos(scrpos.x - w/2, scrpos.y - h/2)
         surface.DrawText(text)
      end

      if tgt.t then
         text = string.FormattedTime(tgt.t - CurTime(), "%02i:%02i")
         w, h = surface.GetTextSize(text)
         
         surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
         surface.DrawText(text)
      elseif tgt.nick then
         text = tgt.nick
         w, h = surface.GetTextSize(text)
         
         surface.SetTextPos(scrpos.x - w / 2, scrpos.y + sz / 2)
         surface.DrawText(text)
      end
   end
end

local painst = surface.GetTextureID("VGUI/ttt/icon_ldttttpainstation")
local turret = surface.GetTextureID("VGUI/ttt/icon_ldttttturret")local trippy = surface.GetTextureID("VGUI/ttt/icon_tripmine")

hook.Add("HUDPaint", "DrawPSnTicon", function()
	if not LocalPlayer() then return end
	
	--ICONS
	--TURRET ICON
	if LocalPlayer():IsActiveTraitor() then
		surface.SetTexture(turret)
		surface.SetTextColor(200, 55, 55, 0)
		surface.SetDrawColor(255, 255, 255, 150)

		for _, v in pairs( ents.FindByClass( "npc_turret_floor" ) ) do
			DrawTarget({pos=v:GetPos()}, 24, nil, true)
		end
	end

	--PAIN STATION ICON
	if LocalPlayer():IsActiveTraitor() then
		surface.SetTexture(painst)
		surface.SetTextColor(200, 55, 55, 0)
		surface.SetDrawColor(255, 255, 255, 150)

		for _, v in pairs( ents.FindByClass( "ttt_pain_station" ) ) do
			DrawTarget({pos=v:GetPos()}, 24, nil, true)
		end
	end		--TRIPMINE ICON		if LocalPlayer():IsActiveTraitor() then	    surface.SetTexture(trippy)		surface.SetTextColor(200, 55, 55, 0)		surface.SetDrawColor(255, 255, 255, 150)		for _, v in pairs( ents.FindByClass( "npc_tripmine" ) ) do			DrawTarget({pos=v:GetPos()}, 24, nil, true)		end	end
	
end )


local turretmodel = ClientsideModel("models/Combine_turrets/Floor_turret.mdl", RENDERGROUP_OPAQUE)
local mat = Material("Models/props_combine/tprotato1_sheet")
turretmodel:SetNoDraw(true)

hook.Add("PostDrawOpaqueRenderables", "DrawTghost", function()
	if not LocalPlayer() then return end
	if LocalPlayer():GetActiveWeapon() == NULL then return end
	if LocalPlayer():GetActiveWeapon():GetClass() == "weapon_ttt_turret" then
		--Turret Ghost
		 local vec = Vector( LocalPlayer():GetAngles():Forward().x, LocalPlayer():GetAngles():Forward().y, 0 )
		 local pos = LocalPlayer():GetPos() + vec*40
		 local ang = Angle( 0, LocalPlayer():GetAngles().y, 0 )
	 	 turretmodel:SetPos(pos)
	 	 turretmodel:SetAngles(ang)
	 	 turretmodel:SetRenderOrigin( pos )
		 turretmodel:SetRenderAngles( ang )
		 turretmodel:SetupBones() 
		 render.SetColorModulation( 0 , 0 , 0 )
		 render.SetBlend( 0.5 )
		 render.MaterialOverride( mat )
		 turretmodel:DrawModel()
		 render.SetColorModulation( 1, 1, 1 )
		 render.SetBlend( 0.1 )
		 render.MaterialOverride( 0 )
		 turretmodel:SetRenderOrigin()
		 turretmodel:SetRenderAngles()
	end
end )

