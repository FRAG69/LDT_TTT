
local FAKEMSG = {}
FAKEMSG.__index = FAKEMSG

function FAKEMSG:Init()
	self.Read = 0
	self.Stored = {}
end
function FAKEMSG:ReadValue( readtype )
	if ( !self.Message ) then return end
	
	if ( self.Read < #self.Stored ) then
		self.Read = self.Read + 1
		return self.Stored[ self.Read ]
	end
	
	local ok, value = pcall( self.Message[ "Read" .. readtype ], self.Message )
	if ( ok ) then
		return value
	end
end
function FAKEMSG:Reset( values )
	if ( !values ) then return end
	self.Read = 0
	for k, v in pairs( values ) do
		self.Stored[ k ] = v
	end
end
function FAKEMSG:SetMessage( msg ) self.Message = msg end

local types = { "Angle", "Bool", "Char", "Entity", "Float", "Long", "Short", "String", "Vector", "VectorNormal" }
for _, readtype in pairs( types ) do
	FAKEMSG[ "Read" .. readtype ] = function( self ) return self:ReadValue( readtype ) end
end

local function FakeMsg( msg )
	local fakemsg = {}
	setmetatable( fakemsg, FAKEMSG )
	
	fakemsg:Init()
	fakemsg:SetMessage( msg )
	
	return fakemsg
end

// Hooks!
usermessage.Hooks = usermessage.Hooks or {}

usermessage.OriginalIncomingMessage = usermessage.OriginalIncomingMessage or usermessage.IncomingMessage
function usermessage.IncomingMessage( name, msg )
	local fakemsg = FakeMsg( msg )
	for unique, func in pairs( usermessage.Hooks[ name ] or {} ) do
		local returns = { func( fakemsg ) }
		fakemsg:Reset( returns )
	end
	usermessage.OriginalIncomingMessage( name, fakemsg )
end
function usermessage.AddHook( name, unique, func )
	usermessage.Hooks[ name ] = usermessage.Hooks[ name ] or {}
	usermessage.Hooks[ name ][ unique ] = func
end
