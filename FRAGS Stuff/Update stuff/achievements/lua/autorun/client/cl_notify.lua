function ACH_Notify( ... )
	local arg = { ... }
	
	args = {}
	for _, v in ipairs( arg ) do
		if ( type( v ) == "string" or type( v ) == "table" ) then table.insert( args, v ) end
	end
	
	chat.AddText( unpack( args ) )
end
	
usermessage.Hook( "ACH_Notification", function( um )
	local argc = um:ReadShort()
	local args = {}
	for i = 1, argc / 2, 1 do
		table.insert( args, Color( um:ReadShort(), um:ReadShort(), um:ReadShort(), um:ReadShort() ) )
		table.insert( args, um:ReadString() )
	end
	
	chat.AddText( unpack( args ) )
end )