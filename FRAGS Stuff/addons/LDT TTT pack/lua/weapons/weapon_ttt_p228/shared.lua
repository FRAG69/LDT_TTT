
if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType = "pistol"
   

if CLIENT then
   SWEP.PrintName = "P228"
   SWEP.Slot = 1

   SWEP.Icon = "VGUI/ttt/icon_pistol"
end

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_PISTOL

SWEP.Base = "weapon_tttbase"
SWEP.Primary.Recoil	= 1.5
SWEP.Primary.Damage = 25
SWEP.Primary.Delay = 0.25
SWEP.Primary.Cone = 0.02
SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 20
SWEP.Primary.ClipMax = 60
SWEP.Primary.Ammo = "Pistol"
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.InLoadoutFor = nil

SWEP.ViewModel  = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound = Sound( "Weapon_P228.Single" )
SWEP.IronSightsPos = Vector(4.75, -3, 4.898)
SWEP.IronSightsAng = Vector(-0.239, 0.05, 0)
SWEP.SightsPos = Vector(4.75, 0, 2.898)
SWEP.SightsAng = Vector(-0.239, 0.05, 0)
SWEP.RunSightsPos = Vector(-2.132, -1.149, 2.131)
SWEP.RunSightsAng = Vector(-15.492, -13.771, 0)

