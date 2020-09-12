

if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "melee"
   

if CLIENT then
   SWEP.DrawCrosshair   = true
   SWEP.ViewModelFOV    = 82
   SWEP.ViewModelFlip   = true
   SWEP.CSMuzzleFlashes = true

   SWEP.PrintName			= "Disguised M16"			
   SWEP.Author				= "Baykun"
   SWEP.Contact				= "baykun@ymail.com"
   SWEP.Slot				= 6

   SWEP.EquipMenuData = {
      name = "Disguised M16",
      type = "item_weapon",
      desc = "Weakened M16 that looks\nlike a crowbar.\nYou see it as an M16,\nbut others see it as a crowbar."
   };

   SWEP.Icon = "VGUI/ttt/icon_m16"
   SWEP.Base = "weapon_tttbase"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once
SWEP.WeaponID = nil

SWEP.HeadshotMultiplier = 2.0
SWEP.Primary.NumShots       = 1
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Damage = 17
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 20
SWEP.Primary.ClipMax = 20
SWEP.Primary.DefaultClip = 20
SWEP.AutoSpawnable      = false
SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_crowbar.mdl"

SWEP.Primary.Sound = Sound( "Weapon_M4A1.Single" )

SWEP.IronSightsPos 		= Vector( 6, 0, 0.95 )
SWEP.IronSightsAng 		= Vector( 2.6, 1.37, 3.5 )


function SWEP:SetZoom(state)
   if CLIENT then return end
   if state then
      self.Owner:SetFOV(35, 0.5)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end

function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
   
   bIronsights = not self:GetIronsights()
   
   self:SetIronsights( bIronsights )
   
   if SERVER then
      self:SetZoom(bIronsights)
   end
   
   self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
end

function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
   self.Weapon:DefaultReload( ACT_VM_RELOAD );
   self:SetIronsights( false )
   self:SetZoom(false)
end


function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end


