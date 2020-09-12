// Send the files to clients
//AddCSLuaFile( "autorun/lvs_autorun.lua" )
AddCSLuaFile( "lvs_cl_init.lua" )

// Load the file according to the Lua state
if ( SERVER ) then
	include( "lvs_init.lua" )
elseif ( CLIENT ) then
	include( "lvs_cl_init.lua" )
end