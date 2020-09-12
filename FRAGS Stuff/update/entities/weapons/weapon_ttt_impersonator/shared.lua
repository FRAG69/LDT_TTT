//A name stealer, can only be used on corpses
//Created by my_hat_stinks
//Created 21 August 2011

//Based on standard ttt knife

//-----------------------------------------------------------
//Script
//-----------------------------------------------------------

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType = "knife"

if CLIENT then
	SWEP.PrintName    = "Impersonator"
	SWEP.Slot         = 6
	
	SWEP.ViewModelFlip = false
	
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Use on a corpse to steal the name of \nthat person"
	};
	
	SWEP.Icon = "materials/VGUI/ttt/icon_imper"
end

SWEP.Base               = "weapon_tttbase"

SWEP.ViewModel          = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel         = "models/weapons/w_knife_t.mdl"

SWEP.DrawCrosshair      = false
SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.4

SWEP.Kind = WEAPON_EQUIP
SWEP.CanBuy = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock = true -- only buyable once

SWEP.IsSilent = true

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	local ply = self.Owner
	if (self.Weapon.ImpTarget != nil) then
		local imp = ply:GetNWString("ImpName","[Unkown Player]")
		ply:PrintMessage( HUD_PRINTTALK, "You can already impersonate " .. imp .. "!")
		return
	end

	self.Owner:LagCompensation(true)

	local spos = self.Owner:GetShootPos()
	local sdest = spos + (self.Owner:GetAimVector() * 70)

	local kmins = Vector(1,1,1) * -10
	local kmaxs = Vector(1,1,1) * 10

	local tr = util.TraceHull({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})
	
	-- Hull might hit environment stuff that line does not hit
	if not ValidEntity(tr.Entity) then
		tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
	end
	
	local hitEnt = tr.Entity
	
	-- effects
	if ValidEntity(hitEnt) then
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		local edata = EffectData()
		edata:SetStart(spos)
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.Normal)
		edata:SetEntity(hitEnt)
		
		if hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll" then
			util.Effect("BloodImpact", edata)
		end
	else
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	end
	
	if SERVER then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	
	if SERVER and tr.Hit and tr.HitNonWorld and ValidEntity(hitEnt) then
	
		if IsValid(hitEnt) then
			local target = hitEnt:GetDTEntity(CORPSE.dti.ENT_PLAYER)
			if IsValid(target) then
				ply:SetNWBool("Impersonate",false)
				ply:SetNWEntity("ImpTarget",target)
				ply:SetNWString("ImpName",target:Nick())
				ply:PrintMessage( HUD_PRINTTALK, "You may now impersonate " .. target:Nick() .. ".")
				self.Weapon.ImpTarget = target
				self.Weapon.ImpName = target:Nick()
			end
		end
		
	end
	
	self.Owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if SERVER then
		local ply = self.Owner
		
		if (ply:GetNWEntity("ImpTarget",NullEntity()):IsPlayer()) then
			if (ply:GetNWBool("Impersonate",false)) then
				ply:SetNWBool("Impersonate",false)
				local impname = ply:GetNWEntity("ImpTarget",NullEntity()):Nick()
				//MsgN(ply:Nick() .. " no longer impersonating " .. impname)
				ply:PrintMessage( HUD_PRINTTALK, "You are no longer impersonating.")
				
				//*****
				//Hats!
				local plyhat = ply:GetPData("LastHatEquipped")
				if plyhat then
					//MsgN("Hat restored")
					SendUserMessage("PointShop_EquipHat", player.GetAll(), ply:EntIndex(), plyhat)
					ply.ImpHat = nil
				else
					//MsgN("No hat to restore")
					if (ply.ImpHat != "None") then
						SendUserMessage("PointShop_UnEquipHat", player.GetAll(), ply:EntIndex(), ply.ImpHat)
					end
					ply.ImpHat = nil
				end
				//*****
			else
				ply:SetNWBool("Impersonate",true)
				local imp = ply:GetNWEntity("ImpTarget",NullEntity())
				local impname = imp:Nick() or "[Invalid player]"
				//MsgN(ply:Nick() .. " now impersonating " .. impname)
				ply:PrintMessage( HUD_PRINTTALK, "You are now impersonating " .. impname .. ".")
				
				//*****
				//Hats!
				local imphat = imp:GetPData("LastHatEquipped")
				
				if imphat then
					//MsgN("Hat impersonated (Client-side)")
					ply.ImpHat = imphat
					SendUserMessage("PointShop_EquipHat", player.GetAll(), ply:EntIndex(), imphat)
				else
					//MsgN("No hat to impersonate")
					ply.ImpHat = "None"
					local plyhat = ply:GetPData("lastHatEquipped")
					SendUserMessage("PointShop_UnEquipHat", player.GetAll(), ply:EntIndex(), plyhat)
				end
				//*****
			end
		else
			//MsgN(ply:Nick() .. " No target, unimpersonating")
			ply:SetNWBool("Impersonate",false)
		end
	end
end

function SWEP:PreDrop()
	if SERVER then
		local ply = self.Owner
		//MsgN(ply:Nick() .. " pre drop, clearing impersonation")
		ply:SetNWBool("Impersonate",false)
		ply:SetNWEntity("ImpTarget",ply)
		ply:SetNWString("ImpName",ply:Nick())
	end
end

function SWEP:Equip()
	self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
	self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
	
	if SERVER then
		local ply = self.Owner
		if (self.Weapon.ImpTarget != nil) and (self.Weapon.ImpName != nil) then
			ply:SetNWBool("Impersonate",false)
			ply:SetNWEntity("ImpTarget",self.Weapon.ImpTarget)
			ply:SetNWString("ImpName",self.Weapon.ImpName)
		else
			//MsgN("Deployed blank impersonator")
			ply:SetNWBool("Impersonate",false)
			ply:SetNWEntity("ImpTarget",NullEntity())
			ply:SetNWString("ImpName","")
		end
	end
end

function SWEP:Initialize()
   if CLIENT then
      self:AddHUDHelp("Primary fire to choose the corpse", "Secondary fire to impersonate", false)
   end
end