if SERVER then
	--Whether or not the weapons should spawn with full ammo, otherwise they'll only have one clip (default: true)
	WEAPONSELECTION_FULLAMMO = false
	
	--REQUESTED - What groups spawn with full ammo? Any others will spawn with one clip (default: {} meaning anyone!)
	WEAPONSELECTION_FULLAMMO_GROUPS = {}
else
	--What key opens the weapon selection menu (default: KEY_F5)
	WEAPONSELECTION_KEY = KEY_F6
	
	--Header font
	surface.CreateFont("SelectionHeader",
								{font = "Roboto",
								size = 15,
								weight = 700,
								shadow = true})
					
	--Current weapon font
	surface.CreateFont("SelectionCurrent",
								{font = "Roboto-Light",
								size = 12,
								shadow = true})
							
	--Message to show on categories the user doesn't have access to (default: "Please donate to access!")
	WEAPONSELECTION_DISABLED_MSG = "Please donate to access!"
	
	--Group disabled font
	surface.CreateFont("SelectionDisabled",
								{font = "Roboto",
								size = 14,
								weight = 700,
								shadow = true})
								
	--Weapon disabled font
	surface.CreateFont("SelectionDisabled2",
							{font = "Roboto",
							size = 16,
							weight = 700,
							shadow = true})
end

--Primary weapons
--Restrict specific weapons to groups by editing the {}, same as below
WEAPONSELECTION_PRIMARIES = 
	{ weapon_zm_mac10 = {},
		weapon_zm_rifle = {},
		weapon_zm_sledge = {}}
		
--Who can select to spawn with a primary? (default: { "vip", "donator", "admin", "superadmin", "owner" })
WEAPONSELECTION_PRIMARIES_GROUPS = { "vip", "donator", "admin", "superadmin", "owner" }

--Should the primary weapon group be two rows tall? (default: false)
WEAPONSELECTION_PRIMARIES_2ROWS = false
	
--Secondary weapons
WEAPONSELECTION_SECONDARIES = 
	{ weapon_zm_pistol = {},
		weapon_ttt_glock = {} }
		
--Who can select to spawn with a secondary? (default: {} meaning anyone!)
WEAPONSELECTION_SECONDARIES_GROUPS = { "vip", "donator", "admin", "superadmin", "owner" }

--Grenades
WEAPONSELECTION_GRENADES =
	{ weapon_ttt_smokegrenade = {} }
	   
--Who can select to spawn with a grenade? (default: { "vip", "donator", "admin", "superadmin", "owner" })
WEAPONSELECTION_GRENADES_GROUPS = { "vip", "donator", "admin", "superadmin", "owner" }