if SERVER then
	AddCSLuaFile( "shared.lua" )
	resource.AddFile("models/weapons/V_healthkit.dx80.vtx")
	resource.AddFile("models/weapons/V_healthkit.dx90.vtx")
	resource.AddFile("models/weapons/v_healthkit.mdl")
	resource.AddFile("models/weapons/V_healthkit.sw.vtx")
	resource.AddFile("models/weapons/v_healthkit.vvd")
end
   
SWEP.HoldType = "slam"

if CLIENT then
   SWEP.PrintName = "Health Pack"
   SWEP.Slot = 3
   SWEP.SlotPos	= 0

   SWEP.Icon = "VGUI/ttt/icon_nades"
end

SWEP.Kind = WEAPON_NADE

SWEP.Base = "weapon_tttbase"

SWEP.DrawCrosshair      = false

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo       = "none"
SWEP.Primary.Delay = 0.3

SWEP.Secondary.ClipSize       = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic      = false
SWEP.Secondary.Ammo       = "none"
SWEP.Secondary.Delay = 0.3

SWEP.DeploySpeed = 10

SWEP.Spawnable = true
SWEP.AutoSpawnable = true
SWEP.ViewModelFlip = false

SWEP.ViewModelFOV = 55

SWEP.UseHands = true
SWEP.ViewModel          = "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"

SWEP.NoSights = true

function SWEP:Think() return end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:Healself()
end

function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
   self:Healteam()
end

local healsound = Sound("items/medshot4.wav")
local healothersound = Sound("vo/npc/male01/health04.wav")

function SWEP:Healself()
	local maxheal = 25
	if SERVER then
		local ply = self.Owner
		if not IsValid(ply) then return end		 
		if (ply:Health() >= (ply:GetMaxHealth() - maxheal)) and (ply:Health() < ply:GetMaxHealth()) then
			ply:SetHealth(ply:GetMaxHealth())
			ply:EmitSound(healsound)
			self:Remove()
		elseif ply:Health() < (ply:GetMaxHealth() - maxheal) then
			local healamount = ply:Health() + maxheal
			ply:SetHealth(healamount)
			ply:EmitSound(healsound)
			self:Remove()
		elseif ply:Health() == ply:GetMaxHealth() then
			ply:SendLua( "surface.PlaySound( Sound( \"buttons/combine_button_locked.wav\" ) )" )
		end
	end
end

function SWEP:Healteam()
	local maxheal = 35
	if SERVER then
		local ply = self.Owner
		local trace = ply:GetEyeTrace()
		local target = trace.Entity
		if not IsValid(target) then 
			ply:SendLua( "surface.PlaySound( Sound( \"buttons/combine_button_locked.wav\" ) )" )
			return
		end		
		if not target:IsPlayer() then 
			ply:SendLua( "surface.PlaySound( Sound( \"buttons/combine_button_locked.wav\" ) )" )
			return
		end
	
		local mepos = ply:GetPos()
		local youpos = target:GetPos()
		local distance = mepos:Distance( youpos )
		if distance < 100 then
			if target:IsPlayer() and target:Alive() and (target:Health() >= (target:GetMaxHealth()-maxheal)) and (target:Health() < target:GetMaxHealth()) then
				ply:EmitSound(healothersound)
				timer.Simple(0.4, function()
					target:SetHealth(target:GetMaxHealth())
					target:EmitSound(healsound)
				end )
				self:Remove()
				self.used = true
			elseif target:IsPlayer() and target:Alive() and (target:Health() < (target:GetMaxHealth()-maxheal)) then
				local healamount = target:Health() + maxheal
				ply:EmitSound(healothersound)
				timer.Simple(0.4, function()
					target:SetHealth(healamount)
					target:EmitSound(healsound)
				end )
				self:Remove()
				self.used = true
			else
				ply:SendLua( "surface.PlaySound( Sound( \"buttons/combine_button_locked.wav\" ) )" )
			end
		else
			ply:SendLua( "surface.PlaySound( Sound( \"buttons/combine_button_locked.wav\" ) )" )
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


function SWEP:Initialize()
	self:SetDeploySpeed(self.DeploySpeed)
	if CLIENT then
		self:AddHUDHelp(
			"MOUSE1 heals yourself for 25HP.",
			"MOUSE2 heals others for 35HP.",
			false
		)
   end
end
   
   
   