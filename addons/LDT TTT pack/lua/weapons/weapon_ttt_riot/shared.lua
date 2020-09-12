if SERVER then
  AddCSLuaFile( "shared.lua" )
	
	resource.AddFile("models/arleitiss/riotshield/shield.mdl")
	resource.AddFile("models/arleitiss/riotshield/shield.dx80.vtx")
	resource.AddFile("models/arleitiss/riotshield/shield.dx90.vtx")
	resource.AddFile("models/arleitiss/riotshield/shield.phy")
	resource.AddFile("models/arleitiss/riotshield/shield.sw.vtx")
	resource.AddFile("models/arleitiss/riotshield/shield.vvd")
	resource.AddFile("materials/pack/icon_riot.png")
	resource.AddFile("materials/pack/icon_jihad.png")
	resource.AddFile("materials/pack/icon_pain2.png")
	resource.AddFile("materials/pack/icon_taser.png")
	resource.AddFile("materials/pack/icon_tripmine.png")
	resource.AddFile("materials/arleitiss/riotshield/riot_metal.vmt")
	resource.AddFile("materials/arleitiss/riotshield/riot_metal_bump.vtf")
	resource.AddFile("materials/arleitiss/riotshield/shield_cloth.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_edges.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_glass.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_grip.vmt")
	resource.AddFile("materials/arleitiss/riotshield/shield_gripbump.vtf")
end

SWEP.HoldType			= "slam"

if CLIENT then
   SWEP.PrintName = "Riot Shield"			
   SWEP.Author = "Soviet"
   SWEP.Slot      = 6
   SWEP.SlotPos		= 1
   SWEP.IconLetter			= "w"

   SWEP.Icon = "pack/icon_riot.png"
end
      SWEP.EquipMenuData = {
      type = "Defense",
      desc = [[
A riot shield used to deflect bullets !]]
    };


SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_EQUIP1
SWEP.WeaponID = AMMO_AK47
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo       = "none"

SWEP.Primary.ClipSize  = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic  = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.CanBuy = {ROLE_DETECTIVE} -- only detectives can buy
SWEP.LimitedStock = true -- only buyable once



SWEP.WorldModel = "models/arleitiss/riotshield/shield.mdl" // The reason im having a world model is that, when it lies on the ground, it should have a model then too.
SWEP.ViewModel = ""

function SWEP:Deploy()
	if SERVER then
		if IsValid(self.ent) then return end //Makes it not able to spawn multiple entities.
		self:SetNoDraw(true)
		self.ent = ents.Create("prop_physics")
			self.ent:SetModel("models/arleitiss/riotshield/shield.mdl")
			self.ent:SetPos(self.Owner:GetPos() + Vector(0,0,5) + (self.Owner:GetForward()*25))
			self.ent:SetAngles(Angle(0,self.Owner:EyeAngles().y,self.Owner:EyeAngles().r))
			self.ent:SetParent(self.Owner)
			self.ent:Fire("SetParentAttachmentMaintainOffset", "eyes", 0.01) // Garry fucked up the parenting on players in latest patch..
			self.ent:SetCollisionGroup( COLLISION_GROUP_WORLD ) // Lets it not collide to anything but world. Taken from Nocollide Rightclick Code
			self.ent:Spawn()
			self.ent:Activate()
	end
	return true
end


function SWEP:Holster()
	if SERVER then
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
	return true
end

function SWEP:OnDrop()
	if SERVER then
		self:SetColor(Color(255,255,255,255))
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:OnRemove()
	if SERVER then
		self:SetColor(Color(255,255,255,255))
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end



