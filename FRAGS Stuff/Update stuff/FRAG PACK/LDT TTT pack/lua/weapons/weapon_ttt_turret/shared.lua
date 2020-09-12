
if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttturret.vtf" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttturret.vmt" )
end

SWEP.HoldType = "normal"


if CLIENT then
   SWEP.PrintName = "Turret"
   SWEP.Slot = 6

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[
	Automatic Turret that only attacks
	Innocents.
	
	Not very stable.]]
   };

   SWEP.Icon = "VGUI/ttt/icon_ldttttturret"
end

SWEP.Base = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/props/cs_office/microwave.mdl"

SWEP.DrawCrosshair      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

-- This is special equipment


SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true -- only buyable once

SWEP.AllowDrop = false

SWEP.NoSights = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:HealthDrop()
end
function SWEP:SecondaryAttack() return end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

-- ye olde droppe code
function SWEP:HealthDrop()
   if SERVER then
      local ply = self.Owner
      if not ValidEntity(ply) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()

      local turret = ents.Create("npc_turret_floor")
		 local vec = Vector( ply:GetAngles():Forward().x, ply:GetAngles():Forward().y, 0 )
		 local pos = ply:GetPos() + vec*40
		 local ang = Angle( 0, ply:GetAngles().y, 0 )
         turret:SetPos(pos)
         turret:SetOwner(ply)
		 turret:SetMaterial( "Models/props_combine/tprotato1_sheet" )
		 turret:SetColor( 255, 0, 0, 255 )
         turret:Spawn()
		 turret:SetDamageOwner(ply)
		 for _, v in pairs(player.GetAll()) do
		    if v:IsActiveTraitor() or !v:Alive() or v:IsSpec() then
                turret:AddEntityRelationship(v, D_LI, 99 )
				constraint.NoCollide( turret, v, 0, 0 )
			end
			
		 end
		 for _, v in pairs(ents.GetAll()) do
			if !v:IsPlayer() and !v:IsWorld() then
				constraint.NoCollide( turret, v, 0, 0 )
			end
		 end

		 local vectur = Vector(0, ply:GetAngles().y, 0)
		 turret:SetAngles(vectur)
		 turret:PhysWake()
		 turret:SetHealth(400)
         local phys = turret:GetPhysicsObject()
         self:Remove()

         self.Planted = true
   end

   self.Weapon:EmitSound(throwsound)
end


function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and ValidEntity(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end


function SWEP:Initialize()
	if CLIENT then
		self:AddHUDHelp(
			"MOUSE1 places the turret.",
			false,
			false
		)
   end
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

