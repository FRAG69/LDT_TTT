util.AddNetworkString( "AchievementData" )
util.AddNetworkString( "AchvUnlocked" )

local PlayerAchvData = {}

function achievements.GetPlayerAchievementData( ply, id )
	local tbl = PlayerAchvData[ ply:SteamID64() ]	
	if not id then return tbl or {} end
	
	return tbl and tbl[ id ] or {
		Value = 0,
		Completed = false,
		CompletedOn = 0
	}
end

function achievements.SetPlayerAchievementData( ply, id, data, savenow )
	local tbl = PlayerAchvData[ ply:SteamID64() ]
	if not tbl then return end
	
	tbl[ id ] = data
	if savenow then achievements.DataProvider:SetPlayerAchievement( ply, id, data ) end
	
	net.Start( "AchievementData" )
		net.WriteInt( 1, 16 )
		net.WriteString( id )
		net.WriteInt( data.Value, 31 )
		net.WriteBit( data.Completed )
		if data.Completed then
			net.WriteInt( data.CompletedOn, 32 )
		end
	net.Send( ply )
end

function achievements.SavePlayerData( ply )
	local achvData = PlayerAchvData[ ply:SteamID64() ]
	if not achvData then return end
	
	print( "Saving player data:", ply:Nick() )
	
	for k, v in pairs( achvData ) do
		achievements.DataProvider:SetPlayerAchievement( ply, k, v ) -- should we really be doing this
	end
end

hook.Add( "PlayerInitialSpawn", "GetAData", function( ply )
	ply.SID64 = ply:SteamID64() -- this becomes nil on fucking disconnect???
	
	PlayerAchvData[ ply:SteamID64() ] = {}
	achievements.DataProvider:GetPlayerAchievements( ply, function( data )
		data = data or {}
		PlayerAchvData[ ply:SteamID64() ] = data
		
		net.Start( "AchievementData" )
			net.WriteInt( table.Count( data ), 16 )
			for k, v in pairs(data) do
				net.WriteString( k )
				net.WriteInt( v.Value, 31 )
				net.WriteBit( v.Completed )
				if v.Completed then
					net.WriteInt( v.CompletedOn, 32 )
				end
			end
		net.Send( ply )
	end	)
	
end )

-- not called in all cases
hook.Add( "PlayerDisconnected", "SaveAData", function( ply )
	achievements.SavePlayerData( ply )
	PlayerAchvData[ ply.SID64 ] = nil
end )

hook.Add( "ShutDown", "SaveAData", function()
	for k, ply in pairs(player.GetAll()) do
		achievements.SavePlayerData( ply )
		PlayerAchvData[ ply.SID64 ] = nil
	end
end)