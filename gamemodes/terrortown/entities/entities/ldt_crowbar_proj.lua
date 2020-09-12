-- thrown crowbar

AddCSLuaFile()

if CLIENT then
   ENT.PrintName = "Thrown Crowbar"
   ENT.Icon = "vgui/ttt/icon_cbar"
end

ENT.Type = "anim"
ENT.Model = Model("models/weapons/w_crowbar.mdl")

-- When true, score code considers us a weapon
ENT.Projectile = true

ENT.Stuck = false
ENT.Weaponised = true
ENT.CanHavePrints = true
ENT.IsSilent = false
ENT.CanPickup = false

ENT.WeaponID = AMMO_CROWBAR

ENT.Damage = 15
ENT.MaxDamage = 50

ENT.LastSound = 0
ENT.SoundDelay = 0.2

function ENT:Initialize()
    
        self:SetModel(self.Model)

        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid( SOLID_VPHYSICS )
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
    if SERVER then
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if ( IsValid( phys ) ) then phys:Wake() end
        

        self:SetGravity(0.4)
        self:SetFriction(1.0)
        self:SetElasticity(0.45)

        self.StartPos = self:GetPos()

        self:NextThink(CurTime())
        
        self.Weaponised = true
        self.Stuck = false
    end

end

function ENT:HitPlayer(other, tr)

    local range_dmg = math.max(self.Damage, self.StartPos:Distance(self:GetPos()) / 7)
    if range_dmg > self.MaxDamage then
        range_dmg = self.MaxDamage
    end

    if other:Health() < range_dmg + 10 then
        self:KillPlayer(other, tr)
    elseif SERVER then
        local dmg = DamageInfo()
        dmg:SetDamage(range_dmg)
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        dmg:SetDamageForce(self:EyeAngles():Forward())
        dmg:SetDamagePosition(self:GetPos())
        dmg:SetDamageType(DMG_SLASH)

        local ang = Angle(-28,0,0) + tr.Normal:Angle()
        ang:RotateAroundAxis(ang:Right(), -90)
        other:DispatchTraceAttack(dmg, self:GetPos() + ang:Forward() * 3, other:GetPos())

        if self.Weaponised then
            self:DeWeaponise()
        end
    end

    -- As a thrown knife, after we hit a target we can never hit one again.
    -- If we are picked up and re-thrown, a new knife_proj entity is created.
    -- To make sure we can never deal damage twice, make HitPlayer do nothing.
    self.HitPlayer = util.noop
end

function ENT:KillPlayer(other, tr)
    local dmg = DamageInfo()
    dmg:SetDamage(other:Health())
    dmg:SetAttacker(self:GetOwner())
    dmg:SetInflictor(self)
    dmg:SetDamageForce(self:EyeAngles():Forward())
    dmg:SetDamagePosition(self:GetPos())
    dmg:SetDamageType(DMG_SLASH)

    -- this bone is why we need the trace
    local bone = tr.PhysicsBone
    local pos = tr.HitPos
    local norm = tr.Normal
    local ang = Angle(-28,0,0) + norm:Angle()
    ang:RotateAroundAxis(ang:Right(), -90)
    pos = pos - (ang:Forward() * 8)

    local knife = self
    local prints = self.fingerprints

    other.effect_fn = function(rag)

    if not IsValid(knife) or not IsValid(rag) then return end

    knife:SetPos(pos)
    knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    knife:SetAngles(ang)

    knife:SetMoveCollide(MOVECOLLIDE_DEFAULT)
    knife:SetMoveType(MOVETYPE_VPHYSICS)

    knife.fingerprints = prints
    knife:SetNWBool("HasPrints", true)

    --knife:SetSolid(SOLID_NONE)
    -- knife needs to be trace-able to get prints
    local phys = knife:GetPhysicsObject()
    if IsValid(phys) then
       phys:EnableCollisions(false)
    end

    constraint.Weld(rag, knife, bone, 0, 0, true)

    rag:CallOnRemove("ttt_knife_cleanup", function() SafeRemoveEntity(knife) end)
 end


   other:DispatchTraceAttack(dmg, self:GetPos() + ang:Forward() * 3, other:GetPos())

   self.Stuck = true
end

if SERVER then
    function ENT:Think()
        if self.Stuck then return end
        if not self.Weaponised then return end

        local vel = self:GetVelocity()
        if vel == vector_origin then return end

        local tr = util.TraceLine({start=self:GetPos(), endpos=self:GetPos() + vel:GetNormal() * 20, filter={self, self:GetOwner()}, mask=MASK_SHOT_HULL})

        if tr.Hit and tr.HitNonWorld and IsValid(tr.Entity) then
            local other = tr.Entity
            if other:IsPlayer() then
                self:HitPlayer(other, tr)
            end
        end

        local Curtime = CurTime()

        if self.SoundTimer == nil then self.SoundTimer = 0 end

        if (self.Weaponised) then
            if Curtime - self.SoundTimer > 0.2 then
                self.SoundTimer = Curtime
                self:EmitSound("/crowbar/swoosh.mp3", 75, math.random(90,100), 1, CHAN_AUTO)
            end
        end

        self:NextThink(Curtime)
        return true
    end
end

-- When this entity touches anything that is not a player, it should turn into a
-- weapon ent again. If it touches a player it sticks in it.
if SERVER then

    function ENT:DeWeaponise()
        self:SetOwner(null)
        self.Weaponised = false
    end

    function ENT:PhysicsCollide(data, phys)
        if self.Stuck then return false end

        local other = data.HitEntity
        if not IsValid(other) and not other:IsWorld() then return end

        if other:IsPlayer() && self.Weaponised then
            local tr = util.TraceLine({start=self:GetPos(), endpos=other:LocalToWorld(other:OBBCenter()), filter={self, self:GetOwner()}, mask=MASK_SHOT_HULL})
            if tr.Hit and tr.Entity == other then
                self:HitPlayer(other, tr)
            end

            return true
        end

        --plays impact sounds as for some reason they dont by default
        if ( CurTime() - self.LastSound > self.SoundDelay) then
            self.LastSound = CurTime()
            local Vol = 50
            local Speed = self:GetVelocity():Length()
            if(Speed > 60) then
                Vol = Speed

                if Vol > 50 then Vol = 50 end

                local Sound = "weapons/crowbar/crowbar_impact" .. math.random(1,2) .. ".wav"

                self:EmitSound(Sound, 75, math.random(80, 120), Vol/100, CHAN_Auto)
            end
        end

        --Weapon hit the world or something so it needs to stop being able to damage people
        if self.Weaponised then
            self:DeWeaponise()
        end

        return true
    end

    function ENT:Use( Activator, Caller, UseType, Value)
        if Activator:IsPlayer() then
            if not Activator:HasWeapon("weapon_ldt_crowbar") then
                Activator:Give("weapon_ldt_crowbar")
                self:Remove()
            end
        end
    end

end
