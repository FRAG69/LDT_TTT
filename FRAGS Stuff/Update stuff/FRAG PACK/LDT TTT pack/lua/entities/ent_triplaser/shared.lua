ENT.Type = "anim"
ENT.PrintName = ""
ENT.Author = "FRAG" -- Code based on trip mine from The Stalker made by Rambo_6 (aka Sechs)
ENT.Purpose	= ""

function ENT:Initialize()
	if SERVER then
		self.Entity:DrawShadow( false )
		self.Entity:SetSolid( SOLID_BBOX )
		self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self.Entity:SetTrigger( true )
	end
	self.at = CurTime() + 2
	
	self.Entity.fingerprints = {self.User}
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:SetEndPos( endpos )
	self.Entity:SetNetworkedVector( "endpos", endpos )	
	self.Entity:SetCollisionBoundsWS( self.Entity:GetPos(), endpos, Vector() * 0.25 )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetEndPos()
	return self.Entity:GetNetworkedVector( "endpos" )
end


/*---------------------------------------------------------
---------------------------------------------------------*/
function ENT:GetActiveTime()
	--return self.Entity:GetNetworkedFloat( "at" )
	return self.at
end


//Code from C4, slightly modified
local c4boom = Sound("c4.explode")
function ENT:Explode()
   SafeRemoveEntity(self:GetParent())
   if SERVER then
   
      local spos = self:GetPos()
      local tr = util.TraceLine({start=spos, endpos=spos + Vector(0,0,-32), mask=MASK_SHOT_HULL, filter=self.User})
	  
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

      //local dmgowner = self:GetOwner()
      local dmgowner = self.User
      //dmgowner = IsValid(dmgowner) and dmgowner or self.Entity

      local r_inner = 750 /6
      local r_outer = 1000 /6

      -- damage through walls
      //self:SphereDamage(dmgowner, pos, r_inner)

      -- explosion damage
      util.BlastDamage(self, dmgowner, pos, r_outer, 200)

      local effect = EffectData()
      effect:SetStart(pos)
      effect:SetOrigin(pos)
      -- these don't have much effect with the default Explosion
      effect:SetScale(r_outer)
      effect:SetRadius(r_outer)
      effect:SetMagnitude(200)

      if tr.Fraction != 1.0 then
         effect:SetNormal(tr.HitNormal)
      end

      effect:SetOrigin(pos)
      util.Effect("Explosion", effect, true, true)
      util.Effect("HelicopterMegaBomb", effect, true, true)

      //timer.Simple(0.1, function() WorldSound(c4boom, pos, 100, 100) end)

      -- extra push
      local phexp = ents.Create("env_physexplosion")
      phexp:SetPos(pos)
      phexp:SetKeyValue("magnitude", 200)
      phexp:SetKeyValue("radius", r_outer)
      phexp:SetKeyValue("spawnflags", "19")
      phexp:Spawn()
      phexp:Fire("Explode", "", 0)


      -- few fire bits to ignite things
      //timer.Simple(0.2, function(p) StartFires(pos, tr, 4, 5, true, p) end, dmgowner)

      self:Remove()
      self:GetOwner():SendWarn(false)
   else
      local spos = self:GetPos()
      local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-128), filter=self})
      util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)
   end
end

function ENT:Disarm()
	self:GetOwner():Disarm()
end


function ENT:OnTakeDamage(dmginfo)
	if (self.Tripped) then return end

	local DmgPos = dmginfo:GetDamagePosition()
	local MinePos = self:GetOwner():GetPos()
	local Dist = DmgPos:Distance(MinePos)
	
	if ((dmginfo:GetDamageType()) and (Dist <= 20)) then
		self:GetOwner():TakeDamage(dmginfo:GetDamage(),dmginfo:GetAttacker(),dmginfo:GetInflictor())
	elseif (Dist <= 50) then
		self:GetOwner():TakeDamage(dmginfo:GetDamage(),dmginfo:GetAttacker(),dmginfo:GetInflictor())
	end
end