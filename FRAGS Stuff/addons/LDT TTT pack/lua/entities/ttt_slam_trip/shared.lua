if SERVER then AddCSLuaFile("shared.lua") end

if CLIENT then
   ENT.Icon = "VGUI/ttt/icon_c4"
   ENT.PrintName = "S.L.A.M."
   	ENT.Laser = Material( "cable/redlaser" )
end

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_slam.mdl")

ENT.CanHavePrints = true
ENT.CanUseKey = true

ENT.Armed = false

ENT.BlastRadius = 200
ENT.BlastDamage = 1000

AccessorFunc( ENT, "Placer", "Placer")
AccessorFuncDT(ENT, "disarmed", "Disarmed")

local beep = Sound("weapons/c4/c4_beep1.wav")

function ENT:SetupDataTables()
   self:DTVar("Bool", 0, "disarmed")
end

function ENT:Initialize()
	if not IsValid(self) then return end

   self:SetModel(self.Model)
   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetMoveType(MOVETYPE_NONE)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
   if SERVER then
		self:SetMaxHealth(10)
		self:SetUseType(SIMPLE_USE)
   end
    self:SetHealth(10)

    if not self:GetPlacer() then self:SetPlacer(nil) end
   
   self:SetDisarmed(false)
	self:SetBodygroup( 0, 1 )
	
	   if SERVER then
		 self:SendWarn(true)
		 
		 local ind = tostring(self:EntIndex())
		 hook.Add("TTTPrepareRound", "RemoveSlam" .. ind, function()
			if not IsValid(self) then hook.Remove("TTTPrepareRound", "RemoveSlam" .. ind) return end	
			self:Remove() 
		 end)
   end
   
   timer.Simple(1.5, function() if IsValid(self) then self:ActivateSLAM() end end)
end

function ENT:ActivateSLAM()
	if not IsValid(self) then return end

	local beam = self:GetAttachment( self:LookupAttachment("beam_attach") )
	self.beampos = beam.Pos
	
	local tra = util.QuickTrace(self.beampos, self:GetUp()*10000, self.Entity)
	self.LasLength = tra.Fraction
	self.LaserEndPos = tra.HitPos
	
	self.Armed = true
	
	if CLIENT then
		if LocalPlayer():IsTraitor() then
			for idx,b in pairs(RADAR.bombs) do
				if idx == self:EntIndex() then 
					b.beampos =  self.beampos
					b.endpos = self.LaserEndPos
					break
				end
			end
		end
	
		local ind = tostring(self:EntIndex())
		hook.Add("PostDrawTranslucentRenderables", ind, function()
			if not IsValid(self) or self:GetDisarmed() then hook.Remove("PostDrawTranslucentRenderables", ind) end
			if self.Armed then
				render.SetMaterial( self.Laser )
				if LocalPlayer():HasWeapon("weapon_ttt_defuser") then
					render.DrawBeam( self.beampos, self.LaserEndPos, 3, 1, 1, Color( 255, 255, 255, 255 ) )
				else
					render.DrawBeam( self.beampos, self.LaserEndPos, 0.8, 1, 1, Color( 255, 255, 255, 50 ) )
				end
			end
		end)
	end
	
	if SERVER then
		sound.Play( beep, self:GetPos(), 65, 110, 0.7)
	end
end

if SERVER then
function ENT:Defuse( defuser )
	self.Armed = false
	self:SetDisarmed(true)
	
	self:SetBodygroup( 0, 0 )
	
	local owner = self:GetPlacer()
	if IsValid(owner) then
		LANG.Msg(owner, "A S.L.A.M. you planted has been disarmed.")
	end
	
	--Detailed Events support
	if DMG_LOG then
		AddToDamageLog({DMG_LOG.SLAM_DEFUSED, defuser:Nick(), defuser:GetRoleString(), owner:Nick() or "unknown", owner:GetRoleString() or "traitor", {defuser:SteamID(), owner:SteamID() or ""}})
	end

	self:SendWarn(false)
end


function ENT:Think()
	if not IsValid(self) then return end

	if self.Armed then
			local tr = util.QuickTrace(self.beampos, self:GetUp()*10000, self)
			if tr.Fraction < self.LasLength and not self.exploding then
				self.exploding = true
				self:EmitSound( beep )
			
				local hit = tr.Entity
				local owner = self:GetPlacer()
				
				--Detailed Events support
				if DMG_LOG and IsValid(hit) and hit:IsPlayer() then AddToDamageLog({DMG_LOG.SLAM_TRIP, hit:Nick(), hit:GetRoleString(), IsValid(owner) and owner:Nick() or "unknown", IsValid(owner) and owner:GetRoleString() or "traitor", {hit:SteamID(), owner:SteamID() or ""}}) end
			
				timer.Simple(0.1, function() if IsValid(self) then self:Explode() end end)
			end
			self:NextThink( CurTime() + 0.05 )
			return true
	end
end

end

function ENT:OnTakeDamage( dmginfo )
	if not IsValid(self) then return end
	if self.Exploding then return end
	if self:GetDisarmed() then
		util.EquipmentDestroyed(self:GetPos())
		self:Remove() 
		return 
	end

	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if self:Health() <= 0 then
		local atk = dmginfo:GetAttacker()
		local owner = self:GetPlacer()
		if DMG_LOG and IsValid(atk) and atk:IsPlayer() then AddToDamageLog({DMG_LOG.SLAM_DAMAGE, atk:Nick(), atk:GetRoleString(), owner:Nick() or "unknown", owner:GetRoleString() or "traitor", {atk:SteamID(), owner:SteamID() or ""}}) end
		
		self.exploding = true
		self:EmitSound( beep )
		timer.Simple(0.1, function() if IsValid(self) then self:Explode() end end)
	end
end

function ENT:UseOverride(activator)
	if not IsValid(self) or self:GetDisarmed() then return end
	
   if IsValid(activator) and activator:IsPlayer() and not self.Exploding then
      local owner = self:GetPlacer() 
      if owner == activator then
			if (not IsValid(activator)) or (not activator:IsTerror()) or (not activator:Alive()) then return end
			
			if not activator:CanCarryType(WEAPON_EQUIP1) then
				LANG.Msg(activator, "You cannot carry this S.L.A.M.")
			else
				local wep = activator:Give("weapon_ttt_slam")
				if IsValid(wep) then
				   wep.fingerprints = wep.fingerprints or {}
				   table.Add(wep.fingerprints, prints)

				    if self.beam != nil then
						self.beam:Remove()
					end
					if self.beamEnd != nil then
						self.beamEnd:Remove()
					end
					self:Remove()
				end
			end
      end
   end
end

local explodeSound = Sound("c4.explode")
function ENT:Explode()
	if not IsValid(self) or self.Exploding then return end
	
	self.Exploding = true
	
	local pos = self:GetPos()
	local radius = self.BlastRadius
	local damage = self.BlastDamage
	
	util.BlastDamage( self, self:GetPlacer(), pos, radius, damage )
	local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)
		effect:SetScale(radius)
		effect:SetRadius(radius)
		effect:SetMagnitude(damage)
	util.Effect("Explosion", effect, true, true)
	
	sound.Play( explodeSound, self:GetPos(), 60, 150 )
	self:Remove()
end

if SERVER then
   function ENT:SendWarn(armed)
	if not IsValid(self) then return end
      umsg.Start("slam_warn", GetTraitorFilter(true))
		umsg.Short(self:EntIndex())
		umsg.Bool(armed)
		umsg.Vector(self:GetPos())
      umsg.End()
   end

   function ENT:OnRemove()
		if not IsValid(self) then return end
		self:SendWarn(false)
   end
end