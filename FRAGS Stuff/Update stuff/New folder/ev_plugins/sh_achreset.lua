
/*------------------------------------------------------------------------------------------------
	Achievement Reset
------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Ach Reset"
PLUGIN.Description = "Reset's Achievement's"
PLUGIN.Author = "FRAG"
PLUGIN.ChatCommand = "ar"
PLUGIN.Usage = "[players] [1/0]"
PLUGIN.Privileges = { "Ach Reset" }

function PLUGIN:Call( ply, args )
    if ( ply:EV_HasPrivilege( "Ach Reset" ) ) then

else
	evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
end
	
end

evolve:RegisterPlugin( PLUGIN )