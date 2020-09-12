if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName			= "TripMine"
   SWEP.Slot				= 6

   SWEP.ViewModelFOV = 65
   
   SWEP.EquipMenuData = {
      type  = "item_weapon",
      name  = "TripMine",
      desc  = "Laser tripmine."
   };

   SWEP.Icon = "VGUI/ttt/icon_spykr_slam"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.WeaponID = AMMO_SLAM

SWEP.UseHands      = true
SWEP.ViewModelFlip    = false
SWEP.ViewModelFOV    = 60
SWEP.ViewModel      = "models/weapons/c_slam.mdl"
SWEP.WorldModel = Model("models/weapons/w_slam.mdl")

SWEP.DrawCrosshair      = false
SWEP.ViewModelFlip      = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 0.1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.0

SWEP.NoSights = true

local sticksound = Sound( "weapons/slam/mine_mode.wav" )

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_SLAM_TRIPMINE_DRAW)
	return true
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self:StickSLAM()
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:StickSLAM()
	if SERVER then
		local ply = self.Owner
		if not IsValid(ply) then return end
		 if self.Planted then return end
		 
		 local ignore = {ply, self.Weapon}
		 local spos = ply:GetShootPos()
		 local epos = spos + ply:GetAimVector() * 120
		 local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})
		 if tr.HitWorld then
			local slam = ents.Create("ttt_slam_trip")
			if IsValid(slam) then
				slam:PointAtEntity(ply)
				
				local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, slam)
				if tr_ent.HitWorld then
					self.Weapon:SendWeaponAnim(ACT_SLAM_TRIPMINE_ATTACH)
					timer.Simple(0.1, function()
						if not IsValid(self) then return end
					
						local ang = tr_ent.HitNormal:Angle()
						ang:RotateAroundAxis(ang:Right(), -90)

						slam:SetPos(tr_ent.HitPos + tr_ent.HitNormal * 2)
						slam:SetAngles(ang)
						slam:SetPlacer(ply)
						slam:Spawn()
						
						slam.fingerprints = { ply }
						
						local phys = slam:GetPhysicsObject()
						if IsValid(phys) then
							phys:EnableMotion(false)
						end
						
						self:EmitSound(sticksound)
						
						slam.IsOnWall = true
						self:Remove()
						self.Planted = true
					end)
				end
			end
			
			ply:SetAnimation( PLAYER_ATTACK1 )
		 end
	end
end

function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end


if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_spykr_slam.vmt")
end