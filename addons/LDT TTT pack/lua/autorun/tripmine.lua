if SERVER then
	AddCSLuaFile()
else
	hook.Add("PostDrawOpaqueRenderables","TTT_TripmineViewer",function()
		if LocalPlayer():GetRole() == ROLE_TRAITOR then
			local pos = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*10
			local ang = LocalPlayer():EyeAngles()
			ang = Angle(ang.p+90,ang.y,0)
			for k, v in pairs(ents.FindByClass("npc_tripmine")) do
				render.ClearStencil()
				render.SetStencilEnable(true)
					render.SetStencilWriteMask(255)
					render.SetStencilTestMask(255)
					render.SetStencilReferenceValue(15)
					render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
					render.SetStencilPassOperation(STENCILOPERATION_KEEP)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
					render.SetBlend(0)
					v:DrawModel()
					render.SetBlend(1)
					render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
					cam.Start3D2D(pos,ang,1)
							surface.SetDrawColor(255,0,0,255)
							surface.DrawRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
					cam.End3D2D()
					v:DrawModel()
				render.SetStencilEnable(false)
			end
		end
	end)
end