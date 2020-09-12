//Throwbar
//Created by my_hat_stinks
//Created 08 September 2011

//-----------------------------------------------------------
//Script
//-----------------------------------------------------------

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName = "Throwbar"
   SWEP.Slot      = 7 //Will be in slot 8
 
   SWEP.ViewModelFOV = 54
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"
SWEP.Weight			= 5
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip		= false

SWEP.Primary.Delay       = 0.5
SWEP.Primary.Recoil      = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 20
SWEP.Primary.Cone        = -1
SWEP.Primary.Ammo        = "Throwbars"
SWEP.Primary.ClipSize    = 1
SWEP.Primary.ClipMax     = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Automatic   = false
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage      = -1
SWEP.Secondary.ClipMax     = -1
SWEP.Secondary.Delay = 1

SWEP.Kind = WEAPON_EQUIP1

SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

//Default Crowbar Code
//____________________
local sound_single = Sound("Weapon_Crowbar.Single")
function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   if not IsValid(self.Owner) then return end

   if self.Owner.LagCompensation then
      self.Owner:LagCompensation(true)
   end

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 70)
   local tr_main = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
   local hitEnt = tr_main.Entity
   self.Weapon:EmitSound(sound_single)

   if IsValid(hitEnt) or tr_main.HitWorld then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      if not (CLIENT and (not IsFirstTimePredicted())) then
         local edata = EffectData()
         edata:SetStart(spos)
         edata:SetOrigin(tr_main.HitPos)
         edata:SetNormal(tr_main.Normal)
         edata:SetEntity(hitEnt)
         if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
            util.Effect("BloodImpact", edata)
            self.Owner:LagCompensation(false)
            self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
         else
            util.Effect("Impact", edata)
         end
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end


   if CLIENT then
   else
      local tr_all = nil
      tr_all = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner})
      
      self.Owner:SetAnimation( PLAYER_ATTACK1 )

      if hitEnt and hitEnt:IsValid() then
         local dmg = DamageInfo()
         dmg:SetDamage(self.Primary.Damage)
         dmg:SetAttacker(self.Owner)
         dmg:SetInflictor(self.Weapon)
         dmg:SetDamageForce(self.Owner:GetAimVector() * 1500)
         dmg:SetDamagePosition(self.Owner:GetPos())
         dmg:SetDamageType(DMG_CLUB)

         hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
      else
         if tr_all.Entity and tr_all.Entity:IsValid() then
            self:OpenEnt(tr_all.Entity)
         end
      end
   end

   if self.Owner.LagCompensation then
      self.Owner:LagCompensation(false)
   end
end
//____________________

function SWEP:SecondaryAttack()
	if (self.Weapon:Clip1() < 1) then
		self:Remove()
		return
	end
	
	if SERVER then
		local ply = self.Owner
		if ValidEntity(ply) then
			self.Weapon:SetClip1(self.Weapon:Clip1()-1)
			
			local throwbar = ents.Create("ent_ttt_throwbar")
			
			throwbar:SetPos(ply:GetShootPos())
			throwbar.Hit = nil
			throwbar.Owner = self.Owner
			throwbar:SetAngles(ply:EyeAngles())
			throwbar:Spawn()
			
			local phys = throwbar:GetPhysicsObject()
			phys:SetVelocity(ply:GetAimVector()*500)
			//throwbar:SetVelocity(ply:GetAimVector()*500)

			self:Remove()
			
		end
	end
end


//-----------------------------------------------------------
//Equipment Menu
//-----------------------------------------------------------

if CLIENT then
   SWEP.Icon = "materials/VGUI/ttt/icon_ttt_throwbar.vft"

   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Throwable Crowbar"
   };
end

//****************
//NOTE: NEEDS ICON
//****************
if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_ttt_throwbar.vmt")
end