AddCSLuaFile("autorun/client/simple_spec_dm_autorun.lua")
AddCSLuaFile("cl_specdm.lua")
AddCSLuaFile("sh_specdm.lua")
AddCSLuaFile("cfg_specdm.lua")

include("sh_specdm.lua")
include("sv_specdm_ext.lua")

hook.Add("PlayerSay", "ESChatHook", function(ply, text, ispublic)
   if text == ESConfig.Cmd then
      if ply:IsSpec() and not ply:IsGhost() then
         if (ESConfig.RestrictCmd) then
            local found = false
            for k,v in pairs(ESConfig.RestrictGroup) do
               if ply:IsUserGroup(v) then
                  found = true
                  break
               end
            end

            if not found then
               ply:PrintMessage(HUD_PRINTTALK, "Sorry, you don't have access to this command.")
               return
            end
         end

         ply:SetGhost(true)
         ply:UnSpectate()
         if ESConfig.UseMaterial then
            ply:SetMaterial(ESConfig.GhostMat)
         end

         ply:Spawn()
      elseif ply:IsSpec() and ply:IsGhost() then
         ply:SetGhost(false)
         ply:StripAll()
         GAMEMODE:PlayerSpawnAsSpectator(ply)
      end
   end
end)

local plymeta = FindMetaTable("Player");

function plymeta:SetGhost(bool)
	self:SetNWBool("ESGhost", bool);
end

function plymeta:SetPickingUp(bool)
   self:SetNWBool("ESWeaponPickUp", bool);
end

hook.Add("TTTPrepareRound", "ESPrepareRound", function()
   for k,v in pairs(player.GetAll()) do
      if IsValid(v) and not v:IsSpec() then
         v:SetGhost(false)
         v:SetMaterial("")
      end
   end
end)

hook.Add("TTTBeginRound", "ESBeginRound", function()
   for k,v in pairs(player.GetAll()) do
      if IsValid(v) and not v:IsSpec() then
         v:SetGhost(false)
         v:SetMaterial("")
      end
   end
end)

function IsNotPermitted (holdtype, class)
   if (holdtype == nil) then return true end

   -- Dont permit restricted weapon classes
   if (ESConfig.RestrictWeapons) then
      local found = false
      for k,v in pairs(ESConfig.RestrictedWeaponClasses) do
         if string.lower(class) == string.lower(v) then
            found = true
            break
         end
      end

      if found then
         return true
      end 
   end
   
   local temp = string.lower(holdtype)
   
   if temp == "grenade" or
      temp == "knife" or
      temp == "rpg" or
      temp == "slam" then
      return true
   end

   return false
end

hook.Add("InitPostEntity", "ESInitPostEntity", function()
   hook.Add("PlayerCanPickupWeapon", "ESPickupWeapon", function (ply, wep)
		if not IsValid(wep) and not IsValid(ply) then return end

	   if ply:HasWeapon(wep:GetClass()) then
	      return false
	   elseif not ply:CanCarryWeapon(wep) then
	      return false
	   end

      --Prevent ghosts from fucking with nades cause incens hurt live players
      if (IsValid(ply) and ply:IsGhost() and IsNotPermitted(wep.HoldType, wep:GetClass())) then
         return false
      end

      if (IsValid(ply) and ply:IsGhost() and !ply:IsPickingUp()) then
         local entity = ents.Create(wep:GetClass())

         if (!IsValid(entity)) then return false end
		 
         ply:SetPickingUp(true)
         ply:Give(entity:GetClass())
         return false
      end 

      if (ply:IsGhost() and ply:IsPickingUp()) then
		ply:GiveAmmo( 9999, wep:GetTable().Primary.Ammo, true )
		ply:GiveAmmo( 9999, wep:GetTable().Secondary.Ammo, true )
        ply:SetPickingUp(false) 
		return true		
	elseif (ply:IsGhost() and not ply:IsPickingUp()) then
		return false
    end
   end)
   
   function WEPS.DropNotifiedWeapon(ply, wep, death_drop)
  if IsValid(ply) and IsValid(wep) then
	 if (ply:IsGhost() and not (ply:IsPickingUp())) then
		if wep.PreDrop then
		   wep:PreDrop(death_drop)
		end

		if not IsValid(wep) then return end
		wep:Remove()

		ply:SelectWeapon("weapon_ttt_unarmed")
		
		return
	 elseif (ply:IsGhost() and ply:IsPickingUp()) then
		return
	 end
	 -- Hack to tell the weapon it's about to be dropped and should do what it
	 -- must right now
	 if wep.PreDrop then
		wep:PreDrop(death_drop)
	 end

	 -- PreDrop might destroy weapon
	 if not IsValid(wep) then return end

	 -- Tag this weapon as dropped, so that if it's a special weapon we do not
	 -- auto-pickup when nearby.
	 wep.IsDropped = true

	 ply:DropWeapon(wep)

	 wep:PhysWake()

	 -- After dropping a weapon, always switch to holstered, so that traitors
	 -- will never accidentally pull out a traitor weapon
	 ply:SelectWeapon("weapon_ttt_unarmed")
  end
end
end)

hook.Add("PlayerDeath", "ESPlayerDeath", function(victim, inflictor, attacker)
   if (victim:IsGhost()) then
      victim:ShouldDropWeapon(false)
      return
   end
end)

hook.Add("EntityTakeDamage", "ESEntityDamage", function( ent, dmginfo )
	local infl = dmginfo:GetInflictor()
	if ent:IsPlayer() and infl:IsPlayer() then
		if !(ent:IsGhost() == infl:IsGhost()) then
			dmginfo:ScaleDamage( 0.0 )
		end
	elseif !ent:IsPlayer() and infl:IsPlayer() then
		if (infl:IsGhost()) then
			dmginfo:ScaleDamage( 0.0 )
		end
	end
end)

if (ESConfig.InfiniteAmmo) then
   local function GhostAmmo()
      for k,v in pairs(player.GetAll()) do
         if (v:Alive() and v:IsGhost() and v:GetActiveWeapon() != nil) then
             curwep = v:GetActiveWeapon()
			 if not (curwep.Primary == nil) then
				v:GiveAmmo( 9999, curwep:GetTable().Primary.Ammo, true )
			 end
			 
			 if not (curwep.Secondary == nil) then
				v:GiveAmmo( 9999, curwep:GetTable().Secondary.Ammo, true )
			 end
         end
      end

      timer.Create( "GhostAmmo", 5.00, 0, GhostAmmo)
   end
   GhostAmmo()
end