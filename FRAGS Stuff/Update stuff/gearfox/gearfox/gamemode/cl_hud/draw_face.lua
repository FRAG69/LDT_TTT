
local FACE = surface.GetTextureID("mawbase/awesome")
local FBO  = nil
local Ena  = true

function GM:EnableMawFace(bool)
	Ena = bool
end

hook.Add("PostPlayerDraw","AWESOME_FACE",function(pl)
	if (!Ena) then return end
	
	if (pl.FaceTime and pl.FaceTime > CurTime()) then
		if (!FBO) then FBO = pl:LookupBone("ValveBiped.Bip01_Head1") end
			
		local BonePos,BoneAng = pl:GetBonePosition(FBO)
		BoneAng:RotateAroundAxis(BoneAng:Right(),-90)
		BoneAng:RotateAroundAxis(BoneAng:Forward(),90)
		
		BonePos = BonePos+BoneAng:Up()*7+BoneAng:Right()*-15
		
		cam.Start3D2D(BonePos,BoneAng,0.1)
			DrawTexturedRect(-64,64,128,128,MAIN_WHITECOLOR,FACE)
		cam.End3D2D()
	end
end)