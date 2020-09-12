if (SERVER) then
	AddCSLuaFile()
   
	resource.AddFile("models/ldtprops/anvil.dx80.vtx")
   resource.AddFile("models/ldtprops/anvil.dx90.vtx")
   resource.AddFile("models/ldtprops/anvil.mdl")
   resource.AddFile("models/ldtprops/anvil.phy")
   resource.AddFile("models/ldtprops/anvil.sw.vtx")
   resource.AddFile("models/ldtprops/anvil.vvd")
	resource.AddFile("materials/models/ldtprops/anvil.vmt")
   resource.AddFile("materials/models/ldtprops/anvil.vtf")
end

SWEP.HoldType = "normal"

if CLIENT then
	SWEP.PrintName = "Anvil"
	SWEP.Slot = 6

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "A.C.M.E industries standard anvil"
	};

	SWEP.Icon = "vgui/ttt/icon_ldt_anvil"
end

SWEP.Base = "weapon_tttbase"

local ghostmdl = Model("models/ldtprops/anvil.mdl")

SWEP.UseHands = true
SWEP.ViewModel	= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel	= ""

SWEP.DrawCrosshair		= false
SWEP.Primary.ClipSize		 = -1
SWEP.Primary.DefaultClip	 = -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		 = "none"
SWEP.Primary.Delay = 0.1

SWEP.Secondary.ClipSize	  = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic	 = true
SWEP.Secondary.Ammo	  = "none"
SWEP.Secondary.Delay = 1.0

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true

SWEP.AllowDrop = false
SWEP.NoSights = true

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:AnvilDrop()
end
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self:AnvilDrop()
end

local throwsound = Sound("Weapon_Crowbar.Single")
function SWEP:AnvilDrop()
	if SERVER then
		if !self:CanPlace() then return end
		
		local ply = self.Owner
		if not IsValid(ply) then return end
		if self.Planted then return end

		local anvil = ents.Create("ttt_anvil")
		if IsValid(anvil) then
			anvil:SetPos(self:GetPositionFromPlayer(ply))
			anvil:SetAngles(self:GetAngleFromPlayer(ply))
			anvil:SetPlanter(ply)
			anvil:Spawn()

			anvil:PhysWake()
			local phys = anvil:GetPhysicsObject()
			
			self.Planted = true
			self:Remove()
		end
		
		self:EmitSound(throwsound)
	end
end

function SWEP:GetPositionFromPlayer(ply)
	local shootpos = ply:GetShootPos()
	local angles = ply:GetAimVector():GetNormalized()
	local angles2 = ply:GetAimVector()
	angles2.z = 0
	angles2:Normalize()
	
	local pos = ply:GetShootPos() + angles * 70 + angles2 * 30
	pos.z = ply:GetPos().z + 10
	return pos
end

function SWEP:CanPlace()
	if !self.Owner:IsOnGround() then return false end
	local a = self.Owner:GetAimVector()
	a.z = 0
	a:Normalize()
	local tr = util.TraceHull( {
		start = self.Owner:GetPos()+Vector(0,0,35)+a*30,
		endpos = self:GetPositionFromPlayer(self.Owner) + Vector(0,0,25),
		filter = {self,self.Owner},
		mins = Vector( -25, -25, -25 ),
		maxs = Vector( 25, 25, 25 ),
		mask = MASK_SHOT_HULL
	} )
	
	return !tr.Hit
end

function SWEP:GetAngleFromPlayer(ply)
	return Angle(0,ply:GetAimVector():Angle().y,0)
end

function SWEP:Reload()
	return false
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
		RunConsoleCommand("lastinv")
	end
end

if CLIENT then
	function SWEP:Initialize()
		-- create ghosted indicator
		local ghost = ents.CreateClientProp(ghostmdl)
		if IsValid(ghost) then
			ghost:SetPos(self:GetPos())
			ghost:Spawn()

			ghost:SetSolid(SOLID_NONE)
			ghost:SetMoveType(MOVETYPE_NONE)
			ghost:SetNotSolid(true)
			ghost:SetRenderMode(RENDERMODE_TRANSCOLOR)
			ghost:AddEffects(EF_NOSHADOW)
			ghost:SetNoDraw(true)

			self.Ghost = ghost
		end
		
		return self.BaseClass.Initialize(self)
	end
	
	local laser = Material("trails/laser")
	function SWEP:ViewModelDrawn()
		if IsValid(self.Ghost) then
			local ang = LocalPlayer():GetAimVector():Angle()
			self.Ghost:SetPos(self:GetPositionFromPlayer(LocalPlayer()))
			
			self.Ghost:SetAngles(self:GetAngleFromPlayer(LocalPlayer()))
			if self:CanPlace() then
				self.Ghost:SetColor(Color(50, 100, 230, 200))
			else
				self.Ghost:SetColor(Color(255, 0, 0, 200))
			end
			self.Ghost:SetNoDraw(false)
			
			local tr = util.TraceLine({
				start=self:GetPositionFromPlayer(LocalPlayer()), 
				endpos=self:GetPositionFromPlayer(LocalPlayer())+Vector(0,0,-1000),
				filter=self.Ghost
			})
			
			if (tr.StartPos.z > tr.HitPos.z) then
				render.SetMaterial(laser)
				render.DrawBeam(tr.StartPos, tr.HitPos, 10, 0, 0, Color(255,255,255,150))
			end
		end
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

function SWEP:PreDrop()
	self:CallOnClient("HideGhost", "")
end

function SWEP:HideGhost()
	if IsValid(self.Ghost) then
		self.Ghost:SetNoDraw(true)
	end
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Ghost) then
		self.Ghost:Remove()
	end
end

function SWEP:Holster()
	if CLIENT and IsValid(self.Ghost) then
		self.Ghost:SetNoDraw(true)
	end

	return self.BaseClass.Holster(self)
end
