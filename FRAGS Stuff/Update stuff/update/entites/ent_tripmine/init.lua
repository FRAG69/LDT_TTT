
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:DrawShadow( false )
	self.Entity:SetModel( "models/weapons/w_eq_smokegrenade.mdl" )
	//self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType(MOVETYPE_NONE)
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Entity:SetTrigger( true )
	
end

/*
function ENT:Think()
	
	if self.LockPos then
		self.Entity:SetPos(self.LockPos)
		self.Entity:SetAngles(self.LockAngle)
	end
	
	if ( self.AlarmTimer && self.AlarmTimer < CurTime() ) then
		self.AlarmTimer = nil
	end

	if ( self.NotifyTimer && self.NotifyTimer < CurTime() ) then
		self.NotifyTimer = nil
	end

	
end
*/

function ENT:StartTripmineMode( hitpos, forward )
	self.Entity.fingerprints = {self.User}

	if (hitpos) then self.Entity:SetPos( hitpos ) end
	self.Entity:SetAngles( forward:Angle() + Angle( 90, 0, 0 ) )

	self.LockPos = self.Entity:GetPos()
	self.LockAngle = self.Entity:GetAngles()
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = self.Entity:GetPos() + (forward * 4096)
	trace.filter = self.Entity
	trace.mask = MASK_NPCWORLDSTATIC
	local tr = util.TraceLine( trace )

	local ent = ents.Create( "ent_triplaser" )
	ent.User = self.User
	ent:SetAngles(self.Entity:GetAngles())
	ent:SetPos( self.Entity:LocalToWorld( Vector( 0, 0, 1) ) )
	ent:Spawn()
	ent:Activate()
	ent:GetTable():SetEndPos( tr.HitPos )	
	ent:SetParent( self.Entity )
	ent:SetOwner( self.Entity )
		
	self.Laser = ent
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetNormal( forward )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 1 )
	util.Effect( "Sparks", effectdata )
	
	timer.Simple(0,self.SendWarn,self,true)
end


local c4boom = Sound("c4.explode")
function ENT:Explode(tr)
   if SERVER then
      self:SetNoDraw(true)
      self:SetSolid(SOLID_NONE)

      -- pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos(tr.HitPos + tr.HitNormal * 0.6)
      end

      local pos = self:GetPos()
      if util.PointContents(pos) == CONTENTS_WATER or GetRoundState() != ROUND_ACTIVE then
         self:Remove()
         self:SetExplodeTime(0)
         return
      end

      local dmgowner = self:GetThrower()
      dmgowner = IsValid(dmgowner) and dmgowner or self.Entity

      local r_inner = 750
      local r_outer = self:GetRadius()

      if self.DisarmCausedExplosion then
         r_inner = r_inner / 2.5
         r_outer = r_outer / 2.5
      end

      -- damage through walls
      self:SphereDamage(dmgowner, pos, r_inner)

      -- explosion damage
      util.BlastDamage(self, dmgowner, pos, r_outer, self:GetDmg())

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)
      -- these don't have much effect with the default Explosion
      effect:SetScale(r_outer)
      effect:SetRadius(r_outer)
      effect:SetMagnitude(self:GetDmg())

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      effect:SetOrigin(pos)
      util.Effect("Explosion", effect, true, true)
      util.Effect("HelicopterMegaBomb", effect, true, true)

      timer.Simple(0.1, function() WorldSound(c4boom, pos, 100, 100) end)

      -- extra push
      local phexp = ents.Create("env_physexplosion")
      phexp:SetPos(pos)
      phexp:SetKeyValue("magnitude", self:GetDmg())
      phexp:SetKeyValue("radius", r_outer)
      phexp:SetKeyValue("spawnflags", "19")
      phexp:Spawn()
      phexp:Fire("Explode", "", 0)


      -- few fire bits to ignite things
      timer.Simple(0.2, function(p) StartFires(pos, tr, 4, 5, true, p) end, dmgowner)

      self:SetExplodeTime(0)

      SCORE:HandleC4Explosion(dmgowner, self:GetArmTime(), CurTime())

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)

      self:SetExplodeTime(0)
   end
end

function ENT:IsDetectiveNear()
   local center = self:GetPos()
   local r = self.DetectiveNearRadius ^ 2
   local d = 0.0
   local diff = nil
   for _, ent in pairs(player.GetAll()) do
      if IsValid(ent) and ent:IsActiveDetective() then
         -- dot of the difference with itself is distance squared
         diff = center - ent:GetPos()
         d = diff:DotProduct(diff)

         if d < r then
            if ent:HasWeapon("weapon_ttt_defuser") then
               return true
            end
         end
      end
   end

   return false
end

/*

function ENT:Alarm()

	if ( self.AlarmTimer ) then return end
	
	self.AlarmTimer = CurTime() +  0.90

	self.Entity:EmitSound( Sound("npc/attack_helicopter/aheli_damaged_alarm1.wav", 100, 400) )

end

function ENT:Notify()

	if ( self.NotifyTimer ) then return end
	
	self.NotifyTimer = CurTime() +  0.90

	self.Entity:EmitSound( Sound("npc/scanner/combat_scan2.wav", 200, 120) )

end
*/

/*---------------------------------------------------------
   Name: UpdateTransmitState
   Desc: Set the transmit state
---------------------------------------------------------*/
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

//Disarming function
function ENT:Disarm()
	util.EquipmentDestroyed(self:GetPos())
	
	self:SendWarn(false)
	self.Laser:Remove()
	self.Entity:Remove()
end


function ENT:SendWarn(armed)
	umsg.Start("trip_warn", GetTraitorFilter(true))
	umsg.Short(self.Entity:EntIndex())
	umsg.Bool(armed)
	if armed then
		umsg.Vector(self.Entity:GetPos())
		umsg.Float(0)
	end
	umsg.End()
end