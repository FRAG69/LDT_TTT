if MAPSLOADED then
	--return
end
MAPSLOADED = true

/*
	Map and Gamemode setup
*/

/*
	Insert your maps below.
	Format: 
	Notes: You only neeed the name parameter, all others are optional!
	Mapvote:AddMap{
		name = "Name of the map here",
		
		maxplayers = Maximum number of players on the server for the map to show up in a vote,
		minplayers = Minimum number of players on the server for the map to show up in a vote,
		label = "Name to show instead of the mapname", 
		gamemodes = { 
			--If you use the gamemode vote you can use this to override the
			--Gamemodes that this map should show up for. Usually this is done
			--automatically by the mappattern defined for the gamemodes, use this only
			--to override the default.
			"Gamemode1",
			"Gamemode2",
		}
	}
	
	If you want the gamemodes to have icons:
		1) put the gamemode icon as LDTmyvote\materials\gmicons\<gamemodename>.png as 24x24px png

	For map icons please follow this guide: 
	 	Map images are now loaded from the web to avoid extra downloads on the server.
		This makes sure that only the map images needed for a vote are loaded and is very
		useful for servers that use many maps. The map images are hosted on the cloudflare 
		CDN(Content Distribution Network) to ensure high availability and excellent speed
		for players independantly of where they connect from.
		
		If you have any icons that are missing, send them as 256x256px png to funk.valentin@gmail.com
		For the slideshow feature the naming should be as follows:
			1. Image: mapname.png
			2. Image: mapname(1).png
			3. Image: mapname(2).png 
			and so on
			example: de_dust.png, de_dust(1).png...
*/

	MAPVOTE:AddMap{
		name = "ttt_67thway_v3",
		label = "67th Way",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_amsterville_final2",
		label = "Amsterville V2",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_arctic_complex",
		label = "Artic Complex",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_bank_b3",
		labal = "Bank",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_borders_b20",
		labal = "Borders",
	}

	MAPVOTE:AddMap{
		name = "ttt_camel_v1",
		labal = "Camel",
	}

	MAPVOTE:AddMap{
		name = "ttt_canyon_a4",
		labal = "Canyon",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_cloverfield_b4",
		labal = "Cloverfield",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_clue_pak",
		labal = "Clue Pak",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_cluedo_b5_improved1",
		labal = "Cluedo",
	}

	MAPVOTE:AddMap{
		name = "ttt_concentration_b2",
		labal = "Concentration",
	}

	MAPVOTE:AddMap{
		name = "ttt_cruise",
		labal = "Cruise",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_crummycradle_a4",
		labal = "Crummy Cradle",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_de_hairyhouse_b1",
		labal = "Hairy House",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_de_highhouse",
		labal = "High House",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_digdown_b1",
		labal = "Dig Down",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_district_a5",
		labal = "District",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_erebus_r2",
		labal = "Erebus",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_ez_darktransit_b2",
		labal = "Dark Transit",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_ferrostruct_a1",
		labal = "Ferrostruct",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_forest_final",
		labal = "Forest",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_fuuk_jail_final2",
		labal = "Fuuk Jail",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_gunkanjima_v2",
		labal = "Gunkanjima",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_ldt_ghosttown",
		labal = "LDT Ghost Town",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_ldt_nuclear_v4",
		labal = "LDT Nuclear",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_ldt_oilrig_v5",
		labal = "LDT Oilrig",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_ldt_storage_facility_v4",
		labal = "LDT Storage Facility",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_mc_SkyIslands",
		labal = "Sky Islands",
	}

	MAPVOTE:AddMap{
		name = "ttt_office_b1",
		labal = "TTT Office",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_parkhouse",
		labal = "Parkhouse",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_rooftops_a2",
		labal = "Rooftops",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_roy_the_ship",
		labal = "Roy The Ship",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_scarisland_b1",
		labal = "Scar Island",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_smugglersbay",
		labal = "Smugglers Bay",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_surreal",
		labal = "Surreal",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_thething_b3fix",
		labal = "The Thing",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_underground_v1",
		labal = "Underground",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_whitehouse_b2",
		labal = "White House",
	}
	
	MAPVOTE:AddMap{
		name = "ttt_wintermansion_beta2",
		labal = "Winter Mansion",
	}

/*
	End of map list
*/