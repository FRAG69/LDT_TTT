--[[
	MySQL Data Provider
	~ Handsome Matt
]]--

--[[
	Implements:
		function PROVIDER:Initialize()
		
		function PROVIDER:GetPlayerAchievements( ply, callback )
		function PROVIDER:GetPlayerAchievement( ply, achievement, callback )
		
		function PROVIDER:SetPlayerAchievement( ply, achievement, achievementData )
]]--

if not PROVIDER then return end -- silly autorefresh

local database
local achievementsTable

--- Initialize our data provider.
function PROVIDER:Initialize( settings )
	require( "mysqloo" )

	self.Settings = settings
	
	achievementsTable = string.format( "%sachievements", settings["TablePrefix"] or "" )

	database = mysqloo.connect( settings["Host"], settings["User"], settings["Pass"], settings["DBName"], settings["Port"] )
	
	function database:onConnected()
		MsgC( Color( 0, 255, 0 ), "[MySQL] Database has connected!\n" )
		
		database:query( string.format( [[
			CREATE TABLE IF NOT EXISTS %s (
				steamID64 BIGINT NOT NULL,
				achievement VARCHAR(40) NOT NULL,
				value INTEGER DEFAULT 0,
				completed NUMERIC DEFAULT FALSE,
				completedOn INT,
				PRIMARY KEY (steamID64, achievement)
			);
		]], achievementsTable ) ):start()
	end

	function database:onConnectionFailed( err )
		MsgC( Color( 255, 0, 0 ), "[MySQL] Connection to database failed!\n" )
		MsgC( Color( 255, 0, 0 ), " > Error: ", err .. "\n")
	end
	
	database:connect()
end

--- Get a table of a player's titles.
function PROVIDER:GetPlayerAchievements( ply, callback )
	if not IsValid( ply ) then return end
	
	local query = string.format( "SELECT achievement, value, completed, completedOn FROM %s WHERE steamID64=%s",
		achievementsTable,
		ply:SteamID64()
	)
	
	local dataRequest = database:query( query )
	function dataRequest:onSuccess( data )
		local returnData = {}
		
		for k, v in pairs(data or {}) do
			local achvData = {}
			achvData["Value"] = v.value
			achvData["Completed"] = tostring(v.completed) == "1"
			achvData["CompletedOn"] = tonumber(v.completedOn)
			returnData[v.achievement] = achvData
		end
		
		callback( returnData )
	end
	
	dataRequest:start()
end

--- Get a specific achievement by id.
function PROVIDER:GetPlayerAchievement( ply, achievement, callback )
	if not IsValid( ply ) then return end
	
	local query = string.format( "SELECT Value, completed, completedOn FROM %s WHERE steamID64=%s AND achievement=%s", 
		achievementsTable,
		ply:SteamID64(),
		sql.SQLStr( achievement )
	)
	
	local dataRequest = database:query( query )
	function dataRequest:onSuccess( data )
		local returnData = {}
		returnData["Value"] = data.value
		returnData["Completed"] = tostring(data.completed) == "1"
		returnData["CompletedOn"] = tonumber(data.completedOn)
		callback( returnData )
	end
	
	dataRequest:start()
end

--- Set achievement data on a player.
function PROVIDER:SetPlayerAchievement( ply, achievement, achievementData )	
	if not IsValid( ply ) then return end

	local query = string.format( "REPLACE INTO %s VALUES(%s, %s, %s, %s, %s)",
		achievementsTable,
		ply:SteamID64(),
		sql.SQLStr(achievement),
		achievementData["Value"],
		achievementData["Completed"] and "1" or "0",
		achievementData["CompletedOn"] or "NULL"
	)
	
	database:query( query ):start()
end
