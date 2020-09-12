require( "mysqloo" )


/*--------------------------------------------------------------------*
	This requires MySQLoo. You can fetch the module on Facepunch
	
	You can get it here: 
	"http://www.facepunch.com/threads/241247-gm_MySQL-Lua-DLL-Module-v1.8"
*/--------------------------------------------------------------------*


if (!mysqloo) then Msg("--- MySQL functions disabled. MySQLoo Module not found! ---\n") return end

mysql = {}

local pl 			= FindMetaTable("Player")
local Retries		= 0


function mysql:Start(Host,User,Pass,Database)
	local db = mysqloo.connect(Host,User,Pass,Database)
	function db.onConnectionFailed(self,er) Msg( "Connection failed: "..er.."\n" ) end
	function db.onConnected(self) Msg( "Connection has been established.\n" ) end
	return db
end
	
function mysql:Query(DAT,DB)
	db = db or DB or nil
	if (!db) then Msg( "Database does not exist. Call mysql:Start()\n" ) return end
	if (db:status() == mysqloo.DATABASE_NOT_CONNECTED) then 
		if (Retries < 4) then
			Msg( "Reconnecting...\n" ) 
			db:connect() 
			timer.Simple(5,self.Query,self,DAT,DB)
			
			 Retries = Retries+1
		else Retries = 0 end
		return
	end

	local DATABASE = db:query(DAT)
	if (DATABASE) then
		DATABASE:start()
		function DATABASE.onError(s,er) Msg( er.."\n" ) end
		function DATABASE.onFailure(s,er) Msg( er.."\n" ) end
	end
	return DATABASE
end


function pl:LoadMySQL()
end

function pl:UpdateMySQL(Silent)
end
