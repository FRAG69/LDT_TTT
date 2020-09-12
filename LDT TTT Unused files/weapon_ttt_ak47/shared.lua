if SERVER then

   AddCSLuaFile( "shared.lua" )

   resource.AddFile( "materials/VGUI/ttt/icon_ldttttak47.vtf" )

   resource.AddFile( "materials/VGUI/ttt/icon_ldttttak47.vmt" )

end

if CLIENT then

   SWEP.PrintName = "AK47"
   SWEP.Slot      = 2 
   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = true
   SWEP.Icon = "VGUI/ttt/icon_ldttttak47"

end

SWEP.Base				= "weapon_tttbase"
SWEP.HoldType			= "ar2"
SWEP.Primary.Delay       = 0.1
SWEP.Primary.Recoil      = 2.5
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 20
SWEP.Primary.Cone        = 0.04
SWEP.Primary.Ammo        = "Pistol"
SWEP.Primary.ClipSize    = 25
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 25
SWEP.Primary.Sound       = Sound( "Weapon_AK47.Single" )
SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )
SWEP.ViewModel  = "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
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





