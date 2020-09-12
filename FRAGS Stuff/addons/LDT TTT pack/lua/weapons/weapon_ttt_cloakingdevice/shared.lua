if SERVER then
   AddCSLuaFile( "shared.lua" )
end

if CLIENT then

   SWEP.PrintName    = "Cloaking Device"
   SWEP.Slot         = 7
  
   SWEP.ViewModelFlip = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = [[
Makes you appear invisible for
a short amount of time.]]
   };

   SWEP.Icon = "VGUI/ttt/icon_cloak"
end

SWEP.Base               = "weapon_tttbase"

SWEP.HoldType = "normal"

SWEP.UseHands			= true
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 10
SWEP.ViewModel  = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel			= "models/Items/combine_rifle_ammo01.mdl"

SWEP.DrawCrosshair      = false

SWEP.Primary.ClipSize       = 60
SWEP.Primary.DefaultClip    = 60
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 0.5
SWEP.Primary.Ammo       = "none"

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 0

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}
SWEP.LimitedStock = true

SWEP.NoSights = true

SWEP.Cloaked = false

function SWEP:Initialize()
	self:DrawShadow(false)
end

function SWEP:StartCloak()
	self.AllowDrop = false
	if SERVER then
		if not self.Cloaked then
			local ply = self.Owner
			timer.Simple(0.3, function()
				ply:SetNWBool("cloaked", true)
				ply:SetMaterial("Models/effects/vol_light001")
				ply:DrawShadow(false)
				sound.Play("items/smallmedkit1.wav", ply:GetPos(), 70, 100)
			end)
		end
	else
		if not self.Cloaked then
			local start = CurTime()
			hook.Add("CalcView", "CloakView", function(ply, pos, angles, fov) 
				local view = {}
				local forward = math.Clamp((CurTime() - start)*100, 0, 50)
				view.origin = pos-(angles:Forward()*forward)
				view.angles = angles
				view.fov = fov
				return view
			end)
			hook.Add("ShouldDrawLocalPlayer", "CloakView", function(ply)
				return true
			end)
		end
	end
	timer.Create("EndCloak" .. self.Owner:UserID(), 1, 1, function()
		if not IsValid(self) or not IsValid(self.Owner) then return end
		self:EndCloak()
	end)
end

function SWEP:EndCloak()
	self.AllowDrop = true
	self.Cloaked = false
	if SERVER then
		local ply = self.Owner
		
		ply:SetNWBool("cloaked", false)
		
		ply:SetMaterial(nil)
		ply:DrawShadow(true)
		
		sound.Play("common/warning.wav", ply:GetPos(), 70, 100)
	else
		local start = CurTime()
		hook.Add("CalcView", "CloakView", function(ply, pos, angles, fov) 
			local view = {}
			local forward = 1 - math.Clamp((CurTime() - start)*1.5, 0, 1)
			view.origin = pos-(angles:Forward()*(50*forward))
			view.angles = angles
			view.fov = fov
			return view
		end)
		timer.Simple(0.5, function()
			hook.Remove("CalcView", "CloakView")
			hook.Remove("ShouldDrawLocalPlayer", "CloakView")
		end)
	end
end

hook.Add("PlayerSpawn", "ClearCloaked", function(ply)
	if ply:GetNWBool("cloaked", false) then
		ply:SetNWBool("cloaked", true)
		ply:SetMaterial(nil)
		ply:DrawShadow(true)
	end
end)

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    if self.Weapon:Clip1() <= 0 then return end
	if GetRoundState() != ROUND_ACTIVE or self.Owner:IsSpec() then return end

	self:StartCloak()
	self.Cloaked = true
	
	self:TakePrimaryAmmo( 1 )
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
   return false
end

function SWEP:Holster()
	if timer.Exists("EndCloak" .. self.Owner:UserID()) then
		timer.Destroy("EndCloak" .. self.Owner:UserID())
		self:EndCloak()
	end
	return true
end

function SWEP:Deploy()
   if SERVER and IsValid(self.Owner) then
      self.Owner:DrawViewModel(false)
   end

   return true
end

function SWEP:ShootEffects() end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

if CLIENT then
   function SWEP:Initialize()
	  LANG.AddToLanguage("english", "cloak_help", "Hold {primaryfire} to cloak.")
      self:AddHUDHelp("cloak_help", nil, true)

      return self.BaseClass.Initialize(self)
   end
   
   usermessage.Hook("plydied", function()
		hook.Remove("CalcView", "CloakView") hook.Remove("ShouldDrawLocalPlayer", "CloakView")
   end)
end

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_cloak.vmt")
end


