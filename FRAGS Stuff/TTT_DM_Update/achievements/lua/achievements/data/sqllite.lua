--[[
	SQLLite Data Provider
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

local achievementsTable

--- Initialize our data provider.
function PROVIDER:Initialize( settings )
	self.Settings = settings
	
	achievementsTable = string.format( "%sachievements", settings["TablePrefix"] or "" )

	if not sql.TableExists( achievementsTable ) then
		sql.Query( string.format( [[
			CREATE TABLE %s (
				steamID64 INTEGER NOT NULL,
				achievement STRING NOT NULL,
				value INTEGER DEFAULT 0,
				completed NUMERIC DEFAULT FALSE,
				completedOn DATE,
				PRIMARY KEY (steamID64, achievement)
			);
		]], achievementsTable ) )
		
		ErrorNoHalt( string.format( "[ACHV] Table %q not found. Created.\n", achievementsTable ) )
	end
end

--- Get a table of a player's titles.
function PROVIDER:GetPlayerAchievements( ply, callback )
	if not IsValid( ply ) then return end
	
	local query = string.format( "SELECT achievement, value, completed, completedOn FROM %s WHERE steamID64=%s",
		achievementsTable,
		ply:SteamID64()
	)
	
	local data = sql.Query( query )
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

--- Get a specific achievement by id.
function PROVIDER:GetPlayerAchievement( ply, achievement, callback )
	if not IsValid( ply ) then return end
	
	local query = string.format( "SELECT Value, completed, completedOn FROM %s WHERE steamID64=%s AND achievement=%s", 
		achievementsTable,
		ply:SteamID64(),
		sql.SQLStr( achievement )
	)
	
	local data = sql.Query( query )	
	if not data then return end
	
	local returnData = {}
	returnData["Value"] = data.value
	returnData["Completed"] = tostring(data.completed) == "1"
	returnData["CompletedOn"] = tonumber(data.completedOn)
	callback( returnData )
end

--- Set achievement data on a player.
function PROVIDER:SetPlayerAchievement( ply, achievement, achievementData )	
	if not IsValid( ply ) then return end

	local query = string.format( "INSERT OR REPLACE INTO %s VALUES(%s, %s, %s, %s, %s)",
		achievementsTable,
		ply:SteamID64(),
		sql.SQLStr(achievement),
		achievementData["Value"],
		achievementData["Completed"] and "1" or "0",
		achievementData["CompletedOn"] or "NULL"
	)
	
	sql.Query( query )
end