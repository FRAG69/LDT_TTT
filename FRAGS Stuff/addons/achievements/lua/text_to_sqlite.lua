print( "Converting unofficial achievements to SQLite..." )

local convert = {
	[ "ls_suffocation.txt" ] = "suffocation.txt",
	[ "thatsnotatoilet.txt" ] = "thatnotatoilet.txt"
}

local values = {
	[ "Meeting The Locals" ] = "list",
	[ "Server Browser" ] = "list",
	[ "Tourist" ] = "list"
}

local oldreg = CCachievements.Register
for _, filename in pairs( file.FindInLua( "achievements/*.lua" ) ) do
	local datafile = string.Replace( filename, ".lua", ".txt" )
	datafile = convert[ datafile ] or datafile
	if ( file.Exists( "achievements/" .. datafile ) ) then
		local value = file.Read( "achievements/" .. datafile )
		function CCachievements.Register( name )
			CCachievements.SetValue( name, values[ name ] or "total", value )
		end
		include( "achievements/" .. filename )
	end
end
CCachievements.Register = oldreg


CCachievements.SaveValues()

print( "Convert Completed!" )