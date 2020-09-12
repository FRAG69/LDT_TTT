if SERVER then

AddCSLuaFile( "shared.lua" )

end



SWEP.HoldType = "pistol"



 

if CLIENT then

SWEP.PrintName = "Dual Berettas"

SWEP.Slot = 1

 

SWEP.Icon = "VGUI/ttt/icon_pistol"

end

 

SWEP.Kind = WEAPON_PISTOL

SWEP.WeaponID = AMMO_PISTOL

 

SWEP.Base = "weapon_tttbase"

SWEP.Primary.Recoil = 1.5

SWEP.Primary.Damage = 9

SWEP.Primary.Delay = 0.07

SWEP.Primary.Cone = 0.02

SWEP.Primary.ClipSize = 20

SWEP.Primary.Automatic = true

SWEP.Primary.DefaultClip = 20

SWEP.Primary.ClipMax = 60

SWEP.Primary.Ammo = "Pistol"

SWEP.AutoSpawnable = false

SWEP.AmmoEnt = "item_ammo_pistol_ttt"

 

SWEP.ViewModel = "models/weapons/v_pist_elite.mdl"

SWEP.WorldModel = "models/weapons/w_pist_elite.mdl"

 

SWEP.Primary.Sound = Sound( "Weapon_Elite.Single" )

SWEP.NoSights = true



SWEP.HeadshotMultiplier = 1.5
