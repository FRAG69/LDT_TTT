ITEM.Name = "Basejumper"
ITEM.Enabled = true
ITEM.Description = "Reduces your falling damage"
ITEM.Cost = 1000
ITEM.Model = "models/props_junk/PopCan01a.mdl"

/*

ITEM.Functions = {
    OnGive = function(ply, item)
        item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ent, dmginfo )
	if ent:IsPlayer() and dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( 0.5 )      // Damage is now half of what you would normally take.
	end
end
    
}

ITEM.Hooks = {
    PlayerSpawn = function(ent, dmginfo )
	if ent:IsPlayer() and dmginfo:IsFallDamage() then
		dmginfo:ScaleDamage( 0.5 )
	end
end

}

*/

ITEM.Functions = {
    OnGive = function(ply, item)
        item.Hooks.PlayerSpawn(ply, item)
	end,
	
	OnTake = function(ent, inflictor, attacker, amount, dmginfo)
	if ent:IsPlayer() and ent.ShouldReduceFallDamage and dmginfo:IsFallDamage() then
		dmginfo:SetDamage(1)
	end
end
    
}

ITEM.Hooks = {
    PlayerSpawn = function(ent)
	if ent:IsPlayer() then
		ReduceFallDamage = true
	end
end

}

hook.Add("EntityTakeDamage", "ReduceFallDamage", ReduceFallDamage)
