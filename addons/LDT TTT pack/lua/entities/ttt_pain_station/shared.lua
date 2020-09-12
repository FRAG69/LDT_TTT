---- Health dispenser

if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
   -- this entity can be DNA-sampled so we need some display info
   
   
   ENT.Icon = "VGUI/ttt/icon_ldttttpainstation"
   ENT.PrintName = "Pain Station"

   local GetPTranslation = LANG.GetParamTranslation

   ENT.TargetIDHint = {
      name = "hstation_name",
      hint = "hstation_hint",
      fmt  = function(ent, txt)
                return GetPTranslation(txt,
                                       { usekey = Key("+use", "USE"),
                                         num    = ent:GetStoredHealth() or 0 } )
             end
   };

end

ENT.Type = "anim"
ENT.Model = Model("models/props/cs_office/microwave.mdl")

ENT.Projectile = true

ENT.CanUseKey = true
ENT.CanHavePrints = true
ENT.MaxHeal = 25
ENT.MaxStored = 200
ENT.RechargeRate = 1
ENT.RechargeFreq = 2 -- in seconds

AccessorFuncDT(ENT, "StoredHealth", "StoredHealth")

function ENT:SetupDataTables()
   self:DTVar("Int", 0, "StoredHealth")
end

function ENT:Initialize()
   self.Entity:SetModel(self.Model)

   self.Entity:PhysicsInit(SOLID_VPHYSICS)
   self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
   self.Entity:SetSolid(SOLID_VPHYSICS)
   self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
   if SERVER then
      self.Entity:SetMaxHealth(200)

      local phys = self.Entity:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(200)
      end
   end
   self.Entity:SetHealth(500000)
   self:SetColor(Color(180, 180, 250, 255))

   self:SetStoredHealth(200)

   self.fingerprints = {}
end

function ENT:UseOverride(activator)
   if IsValid(activator) and activator:IsPlayer() and activator:IsActive() then
      self:GiveHealth(activator)
   end
end

function ENT:AddToStorage(amount)
   self:SetStoredHealth(math.min(self.MaxStored, self:GetStoredHealth() + amount))
end

function ENT:TakeFromStorage(amount)
   -- if we only have 5 healthpts in store, that is the amount we heal
   amount = math.min(amount, self:GetStoredHealth())
   self:SetStoredHealth(math.max(0, self:GetStoredHealth() - amount))
   return amount
end

local healsound = Sound("items/medshot4.wav")
local failsound = Sound("items/medshotno1.wav")
function ENT:GiveHealth(ply)
		 local dmg = ply:GetMaxHealth() - ply:Health()
         local healed = self:TakeFromStorage(math.min(self.MaxHeal, dmg))
		 ply:TakeDamage(20, self:GetOwner(), self)
		 
         self:EmitSound(healsound)

         if not table.HasValue(self.fingerprints, ply) then
            table.insert(self.fingerprints, ply)
         end
end

-- traditional equipment destruction effects
local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:OnTakeDamage(dmginfo)
   if dmginfo:GetAttacker() == self:GetOwner() then return end

   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())
   if self:Health() < 0 then
      self:Remove()

      local effect = EffectData()
      effect:SetOrigin(self:GetPos())
      util.Effect("cball_explode", effect)
      WorldSound(zapsound, self:GetPos())

      if IsValid(self:GetOwner()) then
         LANG.Msg(self:GetOwner(), "hstation_broken")
      end
   end
end

if SERVER then
   -- recharge
   local nextcharge = 0
   function ENT:Think()
      if nextcharge < CurTime() then
         self:AddToStorage(self.RechargeRate)

         nextcharge = CurTime() + self.RechargeFreq
      end
   end
end

