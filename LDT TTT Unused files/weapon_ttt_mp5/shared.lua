if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttmp5.vtf" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttmp5.vmt" )
end

if CLIENT then
   SWEP.PrintName = "MP5"
   SWEP.Slot      = 2 

   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   SWEP.Icon = "VGUI/ttt/icon_ldttttmp5"
end

SWEP.Base				= "weapon_tttbase"


SWEP.HoldType			= "ar2"

SWEP.Primary.Delay       = 0.08
SWEP.Primary.Recoil      = 0.5
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 15
SWEP.Primary.Cone        = 0.025
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.ClipSize    = 25
SWEP.Primary.ClipMax     = 75
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Sound       = Sound( "Weapon_MP5Navy.Single" )

SWEP.IronSightsPos = Vector( 4.7, -4, 2 )

SWEP.ViewModel  = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"


SWEP.Kind = WEAPON_HEAVY


SWEP.AutoSpawnable = true


SWEP.AmmoEnt = "item_ammo_smg1_ttt"

SWEP.InLoadoutFor = nil

SWEP.LimitedStock = false


SWEP.AllowDrop = true


SWEP.IsSilent = false


SWEP.NoSights = false


if CLIENT then
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Example custom weapon."
   };
end


