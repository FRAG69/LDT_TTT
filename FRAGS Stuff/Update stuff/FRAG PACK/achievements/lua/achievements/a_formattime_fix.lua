function CCachievements.FormatTime( time, format )
	local gah = { { "h", 3600 }, { "m", 60 }, { "s", 1 } }
	for _, t in pairs( gah ) do
		local amount = math.floor( time / t[ 2 ] )
		format = string.Replace( format, t[ 1 ], string.rep( "0", 2 - string.len( amount ) ) .. amount )
		time = time % t[ 2 ]
	end
	return format
end