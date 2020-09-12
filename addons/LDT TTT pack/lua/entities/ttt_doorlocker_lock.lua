if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Model = Model("models/props_wasteland/prison_padlock001a.mdl")

function ENT:Initialize()

	if CLIENT then
		self.Door = self:GetNWEntity("Target")
	end

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetMoveType(MOVETYPE_NONE)
	
	self.CreateTime = CurTime()

	if SERVER then

		self.Done = false
		--local phys = self:GetPhysicsObject()
		--if IsValid(phys) then
			
		--end
		
	end
	
	self.StartPos = self:GetPos()
end

function ENT:GetUnlockMult(v)
	local UnlockMult = 1

	if v:GetTraitor() && not self.Owner:GetDetective() then
		UnlockMult = 3
	elseif (self.Owner == v) then
		UnlockMult = 5
	end

	return UnlockMult
end

function ENT:Think()
	if SERVER then
		self:SetPos(self.Door:LocalToWorld(self.Offset))
		self:SetAngles(self.Door:GetAngles())

		--Use handling
		if (self.Users != nil) then

			local Time = CurTime()

			for k, v in pairs(self.Users) do

				--if player isnt pressing use anymore, remove them from the lock
				if (not v:KeyDown( IN_USE )) or v:GetEyeTrace().Entity != self then
					table.remove(self.Users, k)
					self:TellUserItEnded(v)
				else
					if (v.StartUnlockTime != nil) then
						--Unlock is succesful
						if (Time - v.StartUnlockTime > math.floor(self.LockTime / self:GetUnlockMult(v))) then

							local DoorLockDrop = ents.Create("weapon_ttt_doorlocker")
							
							self:RemoveLock()
							
							DoorLockDrop:SetPos(self:GetPos())
							DoorLockDrop:SetAngles(self:GetAngles())

							DoorLockDrop:Spawn()

							DoorLockDrop.IsDropped = true
							DoorLockDrop.DelayedPickup = true

							DoorLockDrop:SetClip1(1)

						end
					end
				end
			end
		end

		--ticks faster for first 2 seconds of creation, so door can swing
		--ticks faster if someone is cracking the lock
		if (CurTime() - self.CreateTime < 2) or ((self.Users != nil) and (#self.Users > 0)) then

			self:NextThink(CurTime() + 0.05)

			return true

		end

	end
end

function ENT:Use( ply , Caller, UseType, Value)
	--Store the user in the lock
	if not SERVER then return end
	if self.Done then return end

	if (self.Users != nil) then

		if (!table.HasValue(self.Users, ply)) then
			ply.StartUnlockTime = CurTime()
			table.insert(self.Users, ply)
			self:TellUserItStarted(ply)
		end
	else
		ply.StartUnlockTime = CurTime()
		self.Users = { ply }
		self:TellUserItStarted(ply)
	end
end

function ENT:RemoveLock()
	self.Done = true

	self.Door:Fire("unlock")

	if (self.Users != nil) then
		self:TellAllItEnded(v)
	end

	sound.Play( "buttons/lever7.wav", self:GetPos() )

	self.Other:Remove()
	self:Remove()
end

if SERVER then-- server tells client to start progress

	util.AddNetworkString( "StartUnlocking" )
	util.AddNetworkString( "StopUnlocking" )

	function ENT:TellUserItStarted( ply )

		net.Start("StartUnlocking")
			net.WriteInt(math.floor(self.LockTime / self:GetUnlockMult(ply)), 6)
		net.Send(ply)

	end

	function ENT:TellUserItEnded( ply )

		net.Start("StopUnlocking")

		net.Send(ply)

	end

	function ENT:TellAllItEnded()

		for k, v in pairs(self.Users) do

			self:TellUserItEnded(v)

		end
	end

else

	net.Receive( "StartUnlocking", function(len, ply)

		LocalPlayer().CurrentlyUnlocking = true
		LocalPlayer().UnlockTime = net.ReadInt(6)
		LocalPlayer().StartTime = CurTime()

	end)

	net.Receive( "StopUnlocking", function(len, ply)

		LocalPlayer().CurrentlyUnlocking = false

	end)

	--Draw the actual progress bar
	hook.Add( "HUDPaint", "Draw the progress bar for unlocking", function()

		local ply = LocalPlayer()

		if (ply.CurrentlyUnlocking) then
			local ScreenX = (ScrW() / 2)
			local BarLength = (ScreenX / 10) / 2

			local ScreenY = ScrH()
			ScreenY = (ScreenY / 2) + (ScreenY / 30)

			--Draw the line background
			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawLine( ScreenX - BarLength, ScreenY , ScreenX + BarLength, ScreenY )

			
			--Draw the line foreground
			surface.SetDrawColor(0, 255, 0, 255)
			surface.DrawLine( ScreenX - ((CurTime() - ply.StartTime) / (ply.UnlockTime) * BarLength), ScreenY , ScreenX + ((CurTime() - ply.StartTime) / (ply.UnlockTime) * BarLength), ScreenY )
		end

	end)

end

/*
resource.AddFile( "VGUI/ttt/ttt_doorlocker_lock.vmt" )

function ENT:Draw()

	if not self.Door then return end

	local Distance = LocalPlayer():GetPos():Distance(self.Door:GetPos())
	local FadeEndDistance = 100
	local FadeStartDistance = 400

	if (Distance < FadeStartDistance) then

		local Scale = 0.25
		local Size = 128

		local WorldCenter = (self:GetPos())-- + OBBCenter)-- top left corner of 3d2d

		local Ang1 = self.Door:GetAngles() + Angle(180,90,90)
		local Ang2 = self.Door:GetAngles() + Angle(0,90,-90)

		--Draw one side of door
		cam.Start3D2D( self.Door:LocalToWorld(Vector(3,40,0)), Ang1, Scale )

			surface.SetDrawColor(255,255,255)

			surface.SetTexture( self.Material )

			surface.DrawTexturedRect(Size, Size , -Size, -Size)

		cam.End3D2D()

		--Draw one side of door
		cam.Start3D2D( self.Door:LocalToWorld(Vector(-3,7,0)), Ang2, Scale )

			surface.DrawTexturedRect(Size, Size , -Size, -Size)

		cam.End3D2D()

	end

end
*/