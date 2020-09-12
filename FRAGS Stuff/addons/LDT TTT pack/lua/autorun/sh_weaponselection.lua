function CanPlayerSpawnWith(group, ply)
	local groups = {}
	if group == 1 then
		groups = WEAPONSELECTION_PRIMARIES_GROUPS
	elseif group == 2 then
		groups = WEAPONSELECTION_SECONDARIES_GROUPS
	elseif group == 3 then
		groups = WEAPONSELECTION_GRENADES_GROUPS
	end
	if #groups == 0 then return true end
	
	for _,grp in pairs(groups) do
		if ply:IsDonator(grp) then return true end
	end
	
	return false
end

function PlayerInGroups(groups, ply)
	if #groups == 0 then return true end
	for _,group in pairs(groups) do
		if ply:IsDonator(group) then return true end
	end
	return false
end