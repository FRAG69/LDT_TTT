if SERVER then
   AddCSLuaFile( "shared.lua" )
end


SWEP.HoldType = "ar2"


if CLIENT then


   SWEP.PrintName = "MAC 10"
   SWEP.Slot = 2


   SWEP.Icon = "VGUI/ttt/icon_mac"
end




SWEP.Base = "weapon_tttbase"


SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_MAC10


SWEP.Primary.Damage      = 7
SWEP.Primary.Delay       = 0.06
SWEP.Primary.Cone        = 0.03
SWEP.Primary.ClipSize    = 32
SWEP.Primary.ClipMax     = 96
SWEP.Primary.DefaultClip = 32
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.10
SWEP.Primary.Sound       = Sound( "Weapon_mac10.Single" )


SWEP.AutoSpawnable = true


SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.HeadshotMultiplier = 1.6


SWEP.ViewModel  = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"


SWEP.IronSightsPos = Vector( 6.62, -3, 2.9 )
SWEP.IronSightsAng = Vector( 0.7, 5.3, 7 )


SWEP.DeploySpeed = 3



