//A cloaking device
//Created by my_hat_stinks
//Created 21 June 2011

//-----------------------------------------------------------
//Script
//-----------------------------------------------------------

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "normal"

if CLIENT then
   SWEP.PrintName = "Cloaking Device"
   SWEP.Slot      = 6 //Will be in slot 7

   SWEP.ViewModelFOV = 10
end

SWEP.Base				= "weapon_tttbase"
SWEP.ViewModel          = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel         = "models/weapons/w_camphone.mdl"
SWEP.Weight			= 5
SWEP.DrawCrosshair		= false
SWEP.ViewModelFlip		= false

SWEP.Primary.Recoil	= 0
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 1
SWEP.Primary.Cone = 0
SWEP.Primary.ClipSize = 200
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 201
SWEP.Primary.ClipMax = 200
SWEP.Primary.Ammo = "CloakAmmo"
SWEP.AutoSpawnable = false
SWEP.AmmoEnt = ""

SWEP.Kind = WEAPON_EQUIP1

SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE}
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.IsSilent = true
SWEP.NoSights = true

//Due to conflicting opinions on what to do with the cloaking device, there are 3 modes
//Mode 0: You CAN change weapons, you are NOT completely invisible.
//Mode 1: You CAN'T change weapons, you are NOT completely invisible.
//Mode 2: You CAN'T change weapons, you ARE completely invisibe UNLESS MOVING. Default.
local ttt_cloak_mode = CreateConVar("ttt_cloak_mode", "2")

function SWEP:Equip(NewOwner)
	self.Wearer = NewOwner
	self:Cloak("Off",NewOwner)
	self.Cloaked = 0
	self.Wearer:SetNWBool("Cloaked",false)
end

function SWEP:DropDamage(Target)
	if (Target:IsPlayer() and Target:Alive()) then
		//Deals 1/2 the damage set for some reason
		//So, deal 5 damage (set 10)
		Target.Entity:TakeDamage(10,self.Wearer,self)
	end
end

function SWEP:OnDrop()
	local r,g,b,a = self.Wearer.Entity:GetColor()
	
	//Player Code
	self.Wearer.Entity:SetColor(r,g,b,255)
	self.Wearer.Entity:DrawShadow(true)
	
	//Weapon Code
	self.Weapon:SetColor(r,g,b,255)
	self.Weapon:DrawShadow(true)
	
	//Pointshop Hat Code
	if (IsEntity(self.Wearer.PointHat)) then
		self.Wearer.PointHat.Entity:SetColor(r,g,b,(a+20))
	end
	
	//Deerstalker Hat Code
	if (IsEntity(self.Wearer.hat)) then
		self.Wearer.hat.Entity:SetColor(r,g,b,(255))
	end
	
	if (self.Cloaked == 1) then
		timer.Simple(0,self.DropDamage,self,self.Wearer) //1 tick delay to counter double body bug
		self.Weapon:EmitSound("ambient/energy/zap1.wav")
	end
	self:Cloak("Off",self.Wearer)
	self.Cloaked = 0
	self.Wearer:SetNWBool("Cloaked",false)
	self.Wearer = nil
end

function SWEP:Cloak(On,Target)
	if (SERVER and (self.Owner:IsPlayer() and self.Owner:Alive())) then
		local r,g,b,a = Target.Entity:GetColor()
		
		if GetRoundState() == ROUND_POST then
			self.Cloaked = 0
			if SERVER then self.Wearer:SetNWBool("Cloaked",false) end
			
			//Player Code
			Target.Entity:SetColor(r,g,b,(255))
	
			//Weapon Code
			self.Weapon:SetColor(r,g,b,255)
			
			//Pointshop Hat Code
			if (IsEntity(Target.PointHat)) then
				Target.PointHat.Entity:SetColor(r,g,b,255)
			end
			
			//Deerstalker Hat Code
			if (IsEntity(Target.hat)) then
				Target.hat.Entity:SetColor(r,g,b,255)
			end
			
			self.Owner:DrawShadow(true)
			self.Weapon:DrawShadow(true)
			self.Weapon:EmitSound("ambient/energy/spark4.wav",75)
			return
		end
		
		//For mode 2: Visible when moving
		self.minalpha = 100 //Standard value if an error avoids the Ifs
		if ((self.CMode == 1) or (self.CMode == 0)) then
			self.minalpha = 50 //Standard value for non-mode 2
		elseif (self.CMode == 2) then
			self.OwnerPos = self.Owner:GetPos()
			if (self.OwnerPos != self.OwnerLastPos) then
				if (On == "On") then
					//Player Code
					Target.Entity:SetColor(r,g,b,(a+20))
					
					//Weapon Code
					self.Weapon:SetColor(r,g,b,a+20)
					
					//Pointshop Hat Code
					if (IsEntity(Target.PointHat)) then
						Target.PointHat.Entity:SetColor(r,g,b,(a+20))
					end
					
					//Deerstalker Hat Code
					if (IsEntity(Target.hat)) then
						Target.hat.Entity:SetColor(r,g,b,(a+20))
					end
				end
				self.minalpha = 100
			else self.minalpha = 20 end
			self.OwnerLastPos = self.OwnerPos
		end
		
		// Prevent weapon switching if not in mode 0
		if (((self.CMode == 1) or (self.CMode == 2)) and (self.Cloaked == 1)) then
			if ((self.Owner:GetActiveWeapon() != self.Weapon) and (self.Owner:IsPlayer() and self.Owner:Alive())) then
				self.Owner:SelectWeapon("weapon_ttt_cloak")
			end
		end
		
		if (On == "On") then
			self.Weapon:SetClip1(self.Weapon:Clip1() - 1)
			if (a > self.minalpha) then
				//Player Code
				Target.Entity:SetColor(r,g,b,(a-20))
	
				//Weapon Code
				self.Weapon:SetColor(r,g,b,a-20)
				
				//Pointshop Hat Code
				if (IsEntity(Target.PointHat)) then
					Target.PointHat.Entity:SetColor(r,g,b,(a+20))
				end
				
				//Deerstalker Hat Code
				if (IsEntity(Target.hat)) then
					Target.hat.Entity:SetColor(r,g,b,(a-20))
				end
			end
			if ((self.Cloaked == 1) and (self.Weapon:Clip1() > 0)) then
				timer.Simple(0.1,self.Cloak,self,"On",Target)
			elseif (self.Weapon:Clip1() <= 0) then
				self.Cloaked = 0
				Target:SetNWBool("Cloaked",false)
				self.Weapon:EmitSound("ambient/energy/spark4.wav",75)
				timer.Simple(0.1,self.Cloak,self,"Off",Target)
				return
			end
		end
		
		if (On == "Off") then
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
			if (a < 255) then
					//Player Code
					Target.Entity:SetColor(r,g,b,(a+20))
	
					//Weapon Code
					self.Weapon:SetColor(r,g,b,a+20)
					
					//Pointshop Hat Code
					if (IsEntity(Target.PointHat)) then
						Target.PointHat.Entity:SetColor(r,g,b,(a+20))
					end
					
					//Deerstalker Hat Code
					if (IsEntity(Target.hat)) then
						Target.hat.Entity:SetColor(r,g,b,(a+20))
					end
			end
			if ((self.Cloaked != 1) and ((a < 255) or (self.Weapon:Clip1() < self.Primary.ClipMax))) then
				timer.Simple(0.1,self.Cloak,self,"Off",Target)
			end
		end
		
		if (self.Weapon:Clip1() > self.Primary.ClipMax) then
			self.Weapon:SetClip1(self.Primary.ClipMax)
		elseif (self.Weapon:Clip1() < 0) then
			self.Weapon:SetClip1(0)
		end
	end
	
	if (self.Owner:IsPlayer() and self.Owner:Alive()) then
		local r,g,b,a = Target.Entity:GetColor()
		if (a < 255) then
			self.Owner:DrawShadow(false)
			self.Weapon:DrawShadow(false)
			if (IsEntity(Target.hat)) then
				Target.hat.Entity:DrawShadow(false)
			end
			if (IsEntity(Target.PointHat)) then
				Target.PointHat.Entity:DrawShadow(false)
			end
			if (CLIENT) then timer.Simple(0.1,self.Cloak,self,"",Target) end
		else
			Target:DrawShadow(true)
			self.Weapon:DrawShadow(true)
			if (IsEntity(Target.hat)) then
				Target.hat.Entity:DrawShadow(true)
			end
			if (IsEntity(Target.PointHat)) then
				Target.PointHat.Entity:DrawShadow(true)
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		if (IsEntity(self.Wearer.hat)) then
			self.Wearer.hat:Drop(Vector(0,0,1))
		end
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if GetRoundState() == ROUND_POST then
		self.Weapon:EmitSound("ambient/energy/spark4.wav",75)
		self.Wearer.Entity:SetColor(255,255,255,(255))
		return
	end
	
	self.CMode = math.Round(ttt_cloak_mode:GetInt())
	if (self.CMode < 0) then self.CMode = 0 end
	if (self.CMode > 2) then self.CMode = 2 end
	
	if (self.Cloaked == 1) then
		self.Cloaked = 0
		if SERVER then self.Wearer:SetNWBool("Cloaked",false) end
	else
		self.Cloaked = 1
		if SERVER then self.Wearer:SetNWBool("Cloaked",true) end
	end
	
	if (self.Cloaked == 1) then
		self.Weapon:EmitSound("ambient/energy/spark3.wav",75)
		self:Cloak("On",self.Owner)
	else
		self.Weapon:EmitSound("ambient/energy/spark4.wav",75)
		self:Cloak("Off",self.Owner)
	end
end

//-----------------------------------------------------------
//Icon
//-----------------------------------------------------------

//I don't have an icon to add, leaving the default code here

//****FRAG - Remember to change this bit, you silly person!

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Path to the icon material
   SWEP.Icon = "VGUI/ttt/icon_cloak"

   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "This will temporary make you invisible."
   };
end

-- Tell the server that it should download our icon to clients.
if SERVER then
   -- It's important to give your icon a unique name. GMod does NOT check for
   -- file differences, it only looks at the name. This means that if you have
   -- an icon_ak47, and another server also has one, then players might see the
   -- other server's dumb icon. Avoid this by using a unique name.
   resource.AddFile("materials/VGUI/ttt/icon_cloak.vmt")
end