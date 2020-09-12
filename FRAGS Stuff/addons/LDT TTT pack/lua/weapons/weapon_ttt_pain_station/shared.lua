
if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttpainstation.vtf" )
   resource.AddFile( "materials/VGUI/ttt/icon_ldttttpainstation.vmt" )
end

SWEP.HoldType = "normal"


if CLIENT then
   SWEP.PrintName = "Pain Station"
   SWEP.Slot = 6

   SWEP.ViewModelFOV = 10

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[
		Corrupt Health Station that deals 
		damage to players who use it.
	  
		You can also use it to corrupt a
		Health Station.]]
   };

   SWEP.Icon = "VGUI/ttt/icon_ldttttpainstation"
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
function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:HealthDrop()
end

local throwsound = Sound( "Weapon_SLAM.SatchelThrow" )

function SWEP:HealthDrop()
	
	if SERVER then
		
		local Replace = false
		local ply = self.Owner
		for _, v in pairs( ents.FindByClass( "ttt_health_station" ) ) do
			Replace = true
			local plpos = ply:GetPos()
			local hstpos = v:GetPos()
			if plpos:Distance( hstpos ) < 100 then
				v:Remove()
				local health = ents.Create("ttt_pain_station")
				if IsValid(health) then
					local pstpos = Vector(hstpos.x, hstpos.y, hstpos.z + 32)
					health:SetPos(pstpos)
					health:SetOwner(ply)
					health:Spawn()
					health:PhysWake()
					health:SetAngles(v:GetAngles())
				self:Remove()
				self.Planted = true
				end
			else
				if not IsValid(ply) then return end
				if self.Planted then return end
				local vsrc = ply:GetShootPos()
				local vang = ply:GetAimVector()
				local vvel = ply:GetVelocity()
				local vthrow = vvel + vang * 200
				local health = ents.Create("ttt_pain_station")
				if IsValid(health) then
					health:SetPos(vsrc + vang * 10)
					health:SetOwner(ply)
					health:Spawn()
					health:PhysWake()
					local phys = health:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(vthrow)
					end   
					self:Remove()
					self.Planted = true
				end
			end
		end
		
		if ( !Replace ) then
			if not IsValid(ply) then return end
			if self.Planted then return end
			local vsrc = ply:GetShootPos()
			local vang = ply:GetAimVector()
			local vvel = ply:GetVelocity()
			local vthrow = vvel + vang * 200
			local health = ents.Create("ttt_pain_station")
			if IsValid(health) then
				health:SetPos(vsrc + vang * 10)
				health:SetOwner(ply)
				health:Spawn()
				health:PhysWake()
				local phys = health:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(vthrow)
				end   
				self:Remove()
				self.Planted = true
			end
		end
	end
	
	self.Weapon:EmitSound(throwsound)
	
end


function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

function SWEP:Initialize()
	if CLIENT then
		self:AddHUDHelp(
			"MOUSE1 places the Pain Station.",
			"YOU CAN INSTANTLY REPLACE A HEALTH STATIONS WITH IT.",
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

