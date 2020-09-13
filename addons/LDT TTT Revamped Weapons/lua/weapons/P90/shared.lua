if SERVER then

   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "smg"


if CLIENT then

   SWEP.PrintName			= "FN P90"
   SWEP.Slot				= 2

   SWEP.Icon = "VGUI/ttt/icon_p90"
end


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_P90

SWEP.Primary.Delay			= 0.07
SWEP.Primary.Recoil			= 1.25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Damage = 9
SWEP.Primary.Cone = 0.0325
SWEP.Primary.ClipSize = 50
SWEP.Primary.ClipMax = 150
SWEP.Primary.DefaultClip = 50
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.ViewModel= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.Primary.Sound = Sound( "Weapon_P90.Single" )

SWEP.HeadshotMultiplier = 1.6


SWEP.IronSightsPos 		= Vector( -4.4, -3, 2 )
