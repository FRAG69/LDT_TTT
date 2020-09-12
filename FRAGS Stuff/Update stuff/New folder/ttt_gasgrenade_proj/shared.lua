---- Smoke Nade ent template with added poison ^^

if SERVER then
   AddCSLuaFile("shared.lua")
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
//ENT.Model = Model("models/weapons/w_eq_smokegrenade_thrown.mdl")


AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )
AccessorFunc( ENT, "dmg", "Dmg", FORCE_NUMBER )

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius(20) end

   return self.BaseClass.Initialize(self)
end

if CLIENT then

   local smokeparticles = {
      Model("particle/particle_smokegrenade"),
      Model("particle/particle_noisesphere")
   };

   function ENT:CreateSmoke(center)
      local em = ParticleEmitter(center)

      local r = self:GetRadius()
      for i=1, 20 do
         local prpos = VectorRand() * r
         prpos.z = prpos.z + 32
         local p = em:Add(table.Random(smokeparticles), center + prpos)
         if p then
            local gray = math.random(75, 200)
            p:SetColor(gray, gray, gray)
            p:SetStartAlpha(175)
            p:SetEndAlpha(100)
            p:SetVelocity(VectorRand() * math.Rand(900, 1300))
            p:SetLifeTime(0)
            
            p:SetDieTime(math.Rand(50, 70))

            p:SetStartSize(math.random(140, 150))
            p:SetEndSize(math.random(1, 40))
            p:SetRoll(math.random(-180, 180))
            p:SetRollDelta(math.Rand(-0.1, 0.1))
            p:SetAirResistance(600)

            p:SetCollide(true)
            p:SetBounce(0.4)

            p:SetLighting(false)
         end
      end

      em:Finish()
   end
   
   function ENT:SpawnFunction( ply, tr)

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "ttt_gasgrenade_proj" )
        ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end
end

function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()
	  
	   if util.PointContents(pos) == CONTENTS_WATER then
         self:Remove()
         return
      end

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)
      effect:SetScale(self:GetRadius() * 0.3)
      effect:SetRadius(self:GetRadius())
      effect:SetMagnitude(self.dmg)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      --util.Effect("Explosion", effect, true, true)

      util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

      --StartFires(pos, tr, 10, 20, false, self:GetThrower())

      self:SetDetonateExact(0)

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)      

      self:SetDetonateExact(0)

      if tr.Fraction != 1.0 then
         spos = tr.HitPos + tr.HitNormal * 0.6
      end

      -- Smoke particles can't get cleaned up when a round restarts, so prevent
      -- them from existing post-round.
      if GetRoundState() == ROUND_POST then return end

      self:CreateSmoke(spos)
   end
end
/*
function ENT:Initialize() 
self.Entity:SetModel( "models/weapons/w_eq_smokegrenade_thrown.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )     
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   
self.Entity:SetSolid( SOLID_VPHYSICS )               
local phys = self.Entity:GetPhysicsObject()  
if (phys:IsValid()) then  		
phys:Wake()  	
end 
 
end   


function ENT:SpawnFunction( ply, tr)

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "ttt_gasgrenade_proj" )
        ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:PhysicsCollide( data, physobj )
   	    if data.Speed > 1 and data.DeltaTime > 0.1 then -- if it hits an object at over 1 speed
        self.Entity:EmitSound( "explode_3" )
	   self:Explosion()
	   self.Entity:Remove()
		end
    end

	
function ENT:OnTakeDamage(dmginfo)
self.Entity:TakePhysicsDamage( dmginfo )
end 

*/
function ENT:Explosion()

    local b = ents.Create( "point_hurt" )
	b:SetKeyValue("targetname", "fier" ) 
	b:SetKeyValue("DamageRadius", "90" )
	b:SetKeyValue("Damage", "3.5" )
	b:SetKeyValue("DamageDelay", "0.1" )
	b:SetKeyValue("DamageType", "262144" )
	b:SetPos( self.Entity:GetPos() )
	b:SetDamageOwner( self:GetThrower() )
	b:Spawn()
	b:Fire("turnon", "", 0)
	b:Fire("turnoff", "", 15)
end


