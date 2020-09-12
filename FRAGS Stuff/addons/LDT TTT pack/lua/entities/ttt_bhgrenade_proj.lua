if SERVER then
   AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_fraggrenade.mdl")

function ENT:Initialize()

   self:SetColor(Color(0, 0, 0))
   self:SetMaterial("models/shiny")

   self.BaseClass.Initialize(self)
end

function ENT:Explode(tr)
   if SERVER then
      self.Entity:SetNoDraw(true)
      self.Entity:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self.Entity:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self.Entity:GetPos()

      local bh = ents.Create("ttt_blackhole")
      bh:SetPos(pos)
      bh:SetSpawner(self:GetThrower())
      bh:Spawn()

      self:SetDetonateExact(0)

      self:Remove()
   else
      self:SetDetonateExact(0)
   end
end

