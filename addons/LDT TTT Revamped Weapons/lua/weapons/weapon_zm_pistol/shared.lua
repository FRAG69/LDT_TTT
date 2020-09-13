

if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "pistol"
   


if CLIENT then
   SWEP.PrintName = "Pistol"
   SWEP.Slot = 1


   SWEP.Icon = "VGUI/ttt/icon_pistol"
end


SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL


SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= .3
SWEP.Primary.Damage = 17
SWEP.Primary.Delay = 0.17
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"


SWEP.ViewModel  = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"


SWEP.Primary.Sound = Sound( "Weapon_FiveSeven.Single" )
SWEP.IronSightsPos = Vector( 4.53, -4, 3.2 )

SWEP.HeadshotMultiplier = 1.5
