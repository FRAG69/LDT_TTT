local totalProps = CCachievements.GetValue( "Smash!", "total", 0 )
local function PropBreak( ply, ent )
	if ( totalProps == 500 ) then return end
	
	if ( !ValidEntity( ply ) ) then return end
	local weap = ply:GetActiveWeapon()
	if ( !ValidEntity( weap ) ) then return end
	
	if ( weap:GetClass() == "weapon_zm_improvised" ) then
		totalProps = math.Clamp( totalProps + 1, 0, 500 )
		CCachievements.Update( "Smash!", totalProps / 500, totalProps .. "/500" )
		CCachievements.SetValue( "Smash!", "total", totalProps )
	end
end
hook.Add( "PropBreak", "achievements.Smash", PropBreak )

CCachievements.Register( "Smash!", "Break 500 props with the crowbar.", "achievements/smash", totalProps / 500, totalProps .. "/500" )