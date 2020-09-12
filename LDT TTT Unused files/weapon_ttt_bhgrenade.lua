
if SERVER then
   AddCSLuaFile()
end
   
SWEP.HoldType			= "grenade"

if CLIENT then
   SWEP.PrintName = "Black Hole Grenade"
   SWEP.Slot = 3

   SWEP.Icon = "VGUI/ttt/icon_blackhole"
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[
A grenade that spawns a blackhole
on explosion. The blackhole attracts
nearby players and entities and
can grow by "eating" them.]]
   };

   resource.AddFile("materials/VGUI/ttt/icon_blackhole.vmt")
end

SWEP.Base				= "weapon_tttbasegrenade"

SWEP.Kind = WEAPON_NADE

SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 54
SWEP.ViewModel	= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel	= "models/weapons/w_eq_fraggrenade.mdl"
SWEP.Weight			= 5
SWEP.AutoSpawnable      = false

function SWEP:Initialize()

	self:SetColor(Color(0, 0, 0))

	self.BaseClass.Initialize(self)
end

function SWEP:GetGrenadeName()
   return "ttt_bhgrenade_proj"
end

