util.AddNetworkString("sv_retrieveweapons")
util.AddNetworkString("cl_retrieveweapons")

util.AddNetworkString("sv_saveweapons")

util.AddNetworkString("cl_chattext")

local function GivePlayerWeapon(ply, weapon)
	ply:Give(weapon)
	ply:SelectWeapon(weapon)
	
	if WEAPONSELECTION_FULLAMMO and PlayerInGroups(WEAPONSELECTION_FULLAMMO_GROUPS, ply) then
		weapon = ply:GetActiveWeapon()
		local ammo = weapon:GetPrimaryAmmoType()
		local ammo_count = ply:GetAmmoCount(ammo)
		local give = weapon.Primary.ClipMax - ammo_count
		ply:GiveAmmo(give, ammo)
	end
end

hook.Add("PlayerSpawn", "GiveWeapons", function( ply )
	if ply:IsSpec() then return end
	
	local primary = ply:GetPData("PrimarySpawn", "")
	local secondary = ply:GetPData("SecondarySpawn", "")
	local grenade = ply:GetPData("GrenadeSpawn", "")
	
	if grenade != "" and CanPlayerSpawnWith(3, ply) then GivePlayerWeapon(ply, grenade) end
	if secondary != "" and CanPlayerSpawnWith(2, ply) then GivePlayerWeapon(ply, secondary) end
	if primary != "" and CanPlayerSpawnWith(1, ply) then GivePlayerWeapon(ply, primary) end
end)

net.Receive("sv_retrieveweapons", function(len, ply)
	local primary = ply:GetPData("PrimarySpawn", "")
	local secondary = ply:GetPData("SecondarySpawn", "")
	local grenade = ply:GetPData("GrenadeSpawn", "")
	
	if primary != "" or secondary != "" or grenade != "" then
		net.Start("cl_retrieveweapons")
			net.WriteString(primary)
			net.WriteString(secondary)
			net.WriteString(grenade)
		net.Send(ply)
	end
end)

net.Receive("sv_saveweapons", function(len, ply)
	local primary = net.ReadString()
	local secondary = net.ReadString()
	local grenade = net.ReadString()
	
	ply:SetPData("PrimarySpawn", primary)
	ply:SetPData("SecondarySpawn", secondary)
	ply:SetPData("GrenadeSpawn", grenade)
	
	net.Start("cl_chattext")
		net.WriteTable({primary, secondary, grenade})
	net.Send(ply)
end)

resource.AddFile("materials/VGUI/ttt/icon_spykr_discombob.vmt")
resource.AddFile("materials/VGUI/ttt/icon_spykr_smoke.vmt")
resource.AddFile("materials/VGUI/ttt/icon_spykr_incendiary.vmt")