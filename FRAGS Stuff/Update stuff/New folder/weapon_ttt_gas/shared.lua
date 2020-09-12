---- Gas Nade for TTT
---- Created by [LDT] FRAG

if SERVER then
   AddCSLuaFile( "shared.lua" )
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName = "Gas Grenade"
   SWEP.Slot = 3

   SWEP.Icon = "VGUI/ttt/icon_gasnades"
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.WeaponID = AMMO_SMOKE
SWEP.Kind = WEAPON_NADE
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true 

SWEP.ViewModel			= "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_smokegrenade.mdl"
SWEP.Weight			= 5
SWEP.AutoSpawnable      = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_gasgrenade_proj"
end

---- All this is really is a copy of the exsisting smoke nade, the real work is done in the ent file!