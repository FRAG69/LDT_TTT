achievements.DataProviders = {}

local function LoadDataProviders()
	print( achievements.Path .. "/data/*" )
	local files, _ = file.Find( achievements.Path .. "/data/*", "LUA" )

	for _, filename in pairs( files ) do
		PROVIDER = {}
		PROVIDER.__index = {}

		PROVIDER.ID = string.gsub( filename, ".lua", "" )

		include( "data/" .. filename )

		achievements.DataProviders[PROVIDER.ID] = PROVIDER
		PROVIDER = nil
	end
end

LoadDataProviders()

local dataprovider = string.lower( achievements.Config["DataProvider"] or "SQLLite" )
if not achievements.DataProviders[ dataprovider ] then
	error( string.format( "[ACHV] %q is an unknown data provider.", dataprovider ) )
end

achievements.DataProvider = achievements.DataProviders[ dataprovider ]
achievements.DataProvider:Initialize( achievements.Config["DataProviderSettings"] )