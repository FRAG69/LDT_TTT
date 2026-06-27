---- Example TTT custom weapon

-- First some standard GMod stuff
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then
   SWEP.PrintName = "Galil AR"
   SWEP.Slot      = 2 -- add 1 to get the slot number key

   SWEP.ViewModelFOV  = 72
   SWEP.ViewModelFlip = false
end

-- Always derive from weapon_tttbase.
SWEP.Base				= "weapon_tttbase"

--- Standard GMod values

SWEP.HoldType			= "ar2"

SWEP.Primary.Delay       = 0.19
SWEP.Primary.Recoil      = 0.9
SWEP.Primary.Automatic   = true
SWEP.Primary.Damage      = 19
SWEP.Primary.Cone        = 0.025
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.ClipSize    = 35
SWEP.Primary.ClipMax     = 105
SWEP.Primary.DefaultClip = 35
SWEP.Primary.Sound       = Sound( "Weapon_GALIL.Single" )
SWEP.ViewModel  = "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"
SWEP.IronSightsPos = Vector(-5.1337, -3.9115, 2.1624)
SWEP.IronSightsAng = Vector(0.0873, 0.0006, 0)
SWEP.IronsightsFOV = 60


SWEP.HeadshotMultiplier = 1.7



--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_HEAVY

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon. Of course this AK is special equipment so it won't,
-- but for the sake of example this is explicitly set to false anyway.
SWEP.AutoSpawnable = false

-- The AmmoEnt is the ammo entity that can be picked up when carrying this gun.
SWEP.AmmoEnt = "item_ammo_smg1_ttt"

-- If IsSilent is true, victims will not scream upon death.
SWEP.IsSilent = false

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = false
