if SERVER then

	AddCSLuaFile("shared.lua")

  	resource.AddFile("materials/VGUI/ttt/icon_padlock.vmt")

else

   SWEP.PrintName			= "Padlock"
   SWEP.Slot				= 7

   SWEP.ViewModelFOV = 65
   
   SWEP.EquipMenuData = {
      type  = "item_weapon",
      name  = "Padlock",
      desc  = "Locks doors with a large padlock.\n It takes some time to remove."
   };

   SWEP.Icon = "VGUI/ttt/icon_padlock"
end

SWEP.Base = "weapon_tttbase"

SWEP.HoldType			= "slam"
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

SWEP.SpecialOnlyPickup = true
SWEP.DelayedPickup = false

SWEP.UseHands      = true
SWEP.ViewModelFlip    = false
SWEP.ViewModelFOV    = 60
SWEP.ViewModel      = "models/weapons/c_arms.mdl"
SWEP.WorldModel = Model("models/props_wasteland/prison_padlock001a.mdl")

game.AddAmmoType( {
	name = "ttt_doorlocker_lock_ammo",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE,
	plydmg = 0,
	npcdmg = 0,
	force = 2000,
	minsplash = 10,
	maxsplash = 5
} )

SWEP.DrawCrosshair      	= false
SWEP.ViewModelFlip      	= false
SWEP.Primary.ClipSize 		= 2
SWEP.Primary.ClipMax 		= 10
SWEP.Primary.DefaultClip    = 2
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay 			= 1
SWEP.Primary.Ammo 			= "ttt_doorlocker_lock_ammo"

SWEP.NoSights = true

SWEP.MinLockTime = 5
SWEP.MaxLockTime = 30
SWEP.ChargeTimeMax = 15

function SWEP:PrimaryAttack()
	return false
end

function SWEP:Reload()
   return false
end

function SWEP:Initialize()
	self.Done = false
	self.CooldownStart = 0
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

function SWEP:SecondaryAttack()

	if SERVER then
		local tr = self.Owner:GetEyeTrace()

		if (tr.Hit) then

			if (tr.Entity:GetClass() == "weapon_ttt_doorlocker") then

				self:SetClip1(self:Clip1() + tr.Entity:Clip1())
				tr.Entity:Remove()

			end

		end
	end
end

function SWEP:LockDoor(Target, Duration)

	if SERVER then	

		Lock1 = ents.Create("ttt_doorlocker_lock")

		Lock1:SetNWEntity("Target", Target)
		Lock1.Door = Target
		Lock1.Offset = Vector(-3,42.5,-15)
		Lock1.LockTime = Duration
		Lock1.Owner = self.Owner

		Lock2 = ents.Create("ttt_doorlocker_lock")

		Lock2:SetNWEntity("Target", Target)
		Lock2.Door = Target
		Lock2.Offset = Vector(3,42.5,-15)
		Lock2.LockTime = Duration
		Lock2.Owner = self.Owner

		Lock1.Other = Lock2
		Lock2.Other = Lock1

		Target:Fire("lock")

		timer.Simple( 0.1, function() Lock1:Spawn() end )
		timer.Simple( 0.1, function() Lock2:Spawn() end )

		sound.Play( "buttons/lever7.wav", self:GetPos() )
		
	end

end

if SERVER then

function SWEP:StopLock()
	self.Target = nil
	self.ChargeTime = nil
	self.Done = false

	self:TellUserItEnded(self.Owner)
end

function SWEP:ProgressLock(ply)
	local tr = ply:GetEyeTrace()

	if (tr.Hit) then

		if (tr.Entity:GetClass() == "prop_door_rotating") then

			--preflight checks
			if self.Target == nil then -- assigns target ent
				self.Target = tr.Entity
			elseif not(self.Target == tr.Entity) then -- checks if target is consistent

				return false
			elseif self.ChargeTime != nil && self.ChargeTime >= self.ChargeTimeMax then

				self:TellUserItEnded(self.Owner)
				self.Done = true
				return true
			end

			local Distance = tr.HitPos:Distance(self.Owner:GetPos())
			if Distance < 80 then

				local SaveTable = self.Target:GetSaveTable()
				--if door is locked
				if (not SaveTable.m_bLocked) then

					if (self.ChargeTime == nil) then

						self:TellUserItStarted(self.Owner)

						self.LastChargeTime = CurTime()
						self.ChargeTime = 0
					else
						self.ChargeTime = self.ChargeTime + (CurTime() - self.LastChargeTime)
						self.LastChargeTime = CurTime()
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	end

	return true
end

--Charging up the lock and placing it
function SWEP:Think()

	local ply = self.Owner

	if ply:KeyDown( IN_ATTACK) && not self.Done then

		if not self:CanPrimaryAttack() then return end
		if not (CurTime() - self.CooldownStart > self.Primary.Delay) then return end

		if not self:ProgressLock(ply) then 
			self:StopLock() 
		end
		
	elseif (self.ChargeTime != nil) then

		--final trace to check if door is still there
		local tr = self.Owner:GetEyeTrace()

		if (tr.Hit) then
			if (tr.Entity:GetClass() == "prop_door_rotating") then

				local Target = tr.Entity

				local Distance = tr.HitPos:Distance(self.Owner:GetPos())
				if Distance < 80 then

					local SaveTable = Target:GetSaveTable()
					--if door is locked
					if (not SaveTable.m_bLocked) then

						local Range = self.MaxLockTime - self.MinLockTime
						local Mult = self.ChargeTime / self.ChargeTimeMax

						self:LockDoor(Target, (Range * Mult) + self.MinLockTime)
						self:TakePrimaryAmmo( 1 )

						self:TellUserItEnded(self.Owner)

						self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
						self.CooldownStart = CurTime()

					end
				end		
			end
		end

		self.Done = false
		self.Target = nil
		self.ChargeTime = nil

		if self:Clip1() == 0 then self:Remove() end
	end
end

end

--Networking and client draw stuff
if SERVER then-- server tells client to start progress

	util.AddNetworkString( "StartLocking" )
	util.AddNetworkString( "StopLocking" )

	function SWEP:TellUserItStarted( ply )

		local Range = self.MaxLockTime - self.MinLockTime

		net.Start("StartLocking")
			net.WriteInt(self.MinLockTime, 6)
			net.WriteInt(Range, 6)
			net.WriteInt(self.ChargeTimeMax, 6)

		net.Send(ply)

	end

	function SWEP:TellUserItEnded( ply )

		net.Start("StopLocking")

		net.Send(ply)

	end

else

	net.Receive( "StartLocking", function(len, ply)

		local ply = LocalPlayer()

		ply.StartLocking = true

		ply.MinLockTime = net.ReadInt(6)
		ply.Range = net.ReadInt(6)
		ply.ChargeTimeMax = net.ReadInt(6)

		ply.StartTime = CurTime()

	end)

	net.Receive( "StopLocking", function(len, ply)

		LocalPlayer().StartLocking = false

	end)

	--Draw the actual progress bar
	hook.Add( "HUDPaint", "Draw the progress bar for locking", function()

		local ply = LocalPlayer()

		if (ply.StartLocking) then
			local ScreenX = (ScrW() / 2)
			local BarLength = (ScreenX / 10) / 2

			local ScreenY = ScrH()
			ScreenY = (ScreenY / 2) + (ScreenY / 30)

			--Draw the line background
			surface.SetDrawColor(0, 0, 255, 255)
			surface.DrawLine( ScreenX - BarLength, ScreenY , ScreenX + BarLength, ScreenY )
			
			--Draw the line foreground
			surface.SetDrawColor(0, 255, 0, 255)
			surface.DrawLine( ScreenX - (((CurTime() - ply.StartTime) / ply.ChargeTimeMax) * BarLength), ScreenY , ScreenX + (((CurTime() - ply.StartTime) / ply.ChargeTimeMax) * BarLength), ScreenY )

			local ChargeTime = (CurTime() - ply.StartTime)
			local Mult = ChargeTime / ply.ChargeTimeMax

			draw.SimpleText( math.floor((ply.Range * Mult) + ply.MinLockTime), "default", ScreenX, ScreenY + (ScreenY/30), Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	end)

end
