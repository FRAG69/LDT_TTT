
local totalAmmo = CCachievements.GetValue( "The ultimate Scavanger", "total", 0 )
local function HUDAmmoPickedUp( class, amount )
	if ( totalAmmo == 500 ) then return end
	totalAmmo = math.min( totalAmmo + amount, 500 )
	CCachievements.Update( "The ultimate Scavanger", totalAmmo / 500, totalAmmo .. "/500" )
	CCachievements.SetValue( "The ultimate Scavanger", "total", totalAmmo )
end
hook.Add( "HUDAmmoPickedUp", "achievements.RobTheArmy", HUDAmmoPickedUp )

CCachievements.Register( "The ultimate Scavanger", "Find 500 more bullets then you normally would without the perk.", "achievements/scavenger", totalAmmo / 500, totalAmmo .. "/500" )