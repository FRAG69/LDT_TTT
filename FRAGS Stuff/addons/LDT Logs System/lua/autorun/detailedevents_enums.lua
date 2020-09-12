if SERVER then
	AddCSLuaFile()
end

DMG_LOG = {
	DMG = 1,
	KILL = 2,
	WORLDKILL = 3,
	FALL = 4,
	SLAY = 5, 
	SPEC = 6,
	SPECAUTO = 7,
	GAME = 8,
	C4 = 9,
	BODY_FOUND = 10,
	BODY_BURNT = 11,
	DNA_BODY = 12,
	DNA_OBJECT = 13,
	BOUGHT_ROLE = 14,
	FOUND_CREDITS = 15,
	HEALTH_PLANT = 16,
	HEALTH_DMG = 17,
	HEALTH_DESTROY = 18,
	SLAY_TRAITOR = 19,
	SLAM_DAMAGE = 20,
	SLAM_DEFUSED = 21,
	SLAM_TRIP = 22,
	BOMB_PLANT = 23,
	BOMB_TRIP = 24,
	BOMBSTATION = 25
}

wepnameswitch = {
	weapon_ttt_ak47 = "an AK47",
	ttt_c4 = "C4",
	weapon_ttt_glock = "a Glock",
	weapon_ttt_knife = "a knife",
	weapon_ttt_m3 = "a Pump Shotgun",
	weapon_ttt_m16 = "an M16",
	weapon_ttt_tmp = "a TMP",
	weapon_zm_mac10 = "a Mac10",
	weapon_zm_pistol = "a pistol",
	weapon_zm_revolver = "a Deagle",
	weapon_zm_rifle = "a rifle",
	weapon_zm_shotgun = "a Hunting Shotgun",
	weapon_zm_sledge = "a H.U.G.E-249",
	weapon_zm_improvised = "a crowbar",
	ttt_knife_proj = "a thrown knife",
	weapon_ttt_push = "a Newton Launcher",
	weapon_ttt_flaregun = "a flare gun",
	weapon_ttt_stungun = "a UMP Prototype",
	weapon_ttt_sipistol = "a silenced pistol",
	ttt_slam_trip = "a S.L.A.M.",
	ttt_bomb_station = "a bomb station"
}


function getWepName(dmginfo)
		local wepname = "unknown"
		 if dmginfo:GetDamageType() == DMG_FALL then
			wepname = "push"
		 elseif dmginfo:GetDamageType() == DMG_CRUSH + DMG_PHYSGUN then
			wepname = "goomba stomp"
		 elseif dmginfo:IsExplosionDamage() then
			local inf = dmginfo:GetInflictor()
			if IsValid(inf) and inf:GetClass() == "ttt_c4" then
				wepname = "C4"
			elseif IsValid(inf) and inf:GetClass() == "ttt_slam_trip" then
				wepname = "a S.L.A.M."
			elseif IsValid(inf) and inf:GetClass() == "ttt_bomb_station" then
				wepname = "a bomb station"
			else
				wepname = "an explosion"
			end
		elseif dmginfo:IsDamageType(DMG_BURN) then
			wepname = "fire"
		 else
			local inf = dmginfo:GetInflictor()
			if IsValid(inf) and inf:GetClass() == "prop_physics_multiplayer" then
				wepname = "a prop"
			else
				wepname = util.WeaponFromDamage(dmginfo)
				if wepname != nil then
				 wepname = wepname:GetClass()
				 if wepnameswitch[wepname] != nil then
					wepname = wepnameswitch[wepname]
				 end
				end
			end
		 end
		if wepname == nil then wepname = "unknown" end
		 return wepname
end

function checkDNA( att, ent )
	local scanner = att:GetWeapon( "weapon_ttt_wtester" )
	if IsValid( scanner ) then
		for _, item in pairs(scanner.ItemSamples) do
			if item.ply == ent then return true end
		end
	end
	return false
end

function getVictimInfo( att, ent )
	 local info = {}
	  if IsValid(att) and att:IsPlayer() and IsValid(ent) and ent:IsPlayer() and ent != att then
		 if ent.LastShot != nil then
			info.VicShot = { math.Round(CurTime() - ent.LastShot[1], 1), ent.LastShot[2] } --save victim's last shot with the time between that and this damage and the weapon name
		end
		
		info.VicDisguise = ent:GetNWBool("disguised", false) --save whether the victim was disguised or not
		
		local wep = ent:GetActiveWeapon() --get victim's weapon
		if IsValid(wep) then
			local wepclass = wep:GetClass()
			if wepnameswitch[wepclass] != nil then
				info.VicWeapon = wepnameswitch[wepclass]
			else
				info.VicWeapon = wepclass
			end
		end
		
		info.AttKills = { att.InnoKills, att.TraitorKills }
		info.VicKills = { ent.InnoKills, ent.TraitorKills }

		info.AttDNA = checkDNA( att, ent )
	  end
	  return info
end