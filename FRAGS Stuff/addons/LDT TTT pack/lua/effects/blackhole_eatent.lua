
function EFFECT:Init(data)
   self.StartPos = data:GetStart()
   self.EndPos = data:GetOrigin()

   self.EndTime = CurTime() + 1.5

   local ent = data:GetEntity()
   if IsValid(ent) then
      self.EntAngles = ent:GetAngles()

      ent:SetNoDraw(true)

      local mdl = ent:GetModel()
      if not util.IsValidModel(mdl) then return end

      self.Dummy = ClientsideModel(mdl, RENDERGROUP_TRANSLUCENT)
      if not self.Dummy then return end
      self.Dummy:AddEffects(EF_NODRAW)
   end
end


function EFFECT:Think()
   if self.EndTime < CurTime() then
      SafeRemoveEntity(self.Dummy)
      return false
   end

   return true

end

function EFFECT:Render()
   if self.Dummy then
      local frac = (self.EndTime - CurTime()) / 1.5

      self.Dummy:SetRenderOrigin(LerpVector(1 - frac, self.StartPos, self.EndPos))
      self.Dummy:SetRenderAngles(self.EntAngles)
      self.Dummy:SetModelScale(frac, 0)
      self.Dummy:SetupBones()

      render.SetBlend(frac)

      self.Dummy:DrawModel()

      render.SetBlend(1)
   end
end

