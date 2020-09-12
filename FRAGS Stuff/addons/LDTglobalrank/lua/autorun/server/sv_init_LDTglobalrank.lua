/*MySQL Hostname : mysqleu1.fragnet.net
       MySQL Port: 3306
       Database Name: 1627_clientdb
       Database User: 1627
       Database Password: 20018687
*/   
AddCSLuaFile( "autorun/client/cl_init_LDTglobalrank.lua" )
require("tmysql")

tmysql.initialize("mysqleu1.fragnet.net", "1627", "20018687", "1627_clientdb", 3306, 1, 1)

	 
hook.Add( "PlayerInitialSpawn", "LDTgRankInitspwn", function( pl )
	timer.Simple(10, LDTgrankCheck(pl))
end)

function LDTgrankCheck(pl)
	local servrank = pl:EV_GetRank()
			
	local Table = tmysql.query("SELECT `rank` FROM `global_ranks` WHERE `steamID`='"..pl:SteamID().."'", 
	function(tbl, sta, err)

		local wehaveatbl = false
		
		if tbl then
			if tbl[1] then
				if tbl[1][1] then
					wehaveatbl = true
				end
			end
		end		
		
		umsg.Start( "LDTgranking" , pl)		
		if wehaveatbl then			
			local dbrank = tbl[1][1]
			if dbrank == "banned" then
				pl:Kick("Database says: Global ban! Goodbye!")
			elseif servrank == dbrank or (dbrank == "custom" and servrank != "guest") then
				umsg.Short(1)
				umsg.String(servrank)
			elseif dbrank == "admin" or dbrank == "custom" then // or dbrank == "customrank"
				umsg.Short(2)
				umsg.String(dbrank)
			else
				umsg.Short(0)
				umsg.String("dbrank")
				pl:EV_SetRank(dbrank)
				timer.Simple(5, LDTgrankCheck(pl))
			end
		else
			pl:ChatPrint("Rank on database: none")
			if servrank == "guest" then
				umsg.Short(3)
				umsg.String("guest")				
			else
				umsg.Short(0)
				umsg.String("guest")
				pl:EV_SetRank("guest")
				timer.Simple(5, LDTgrankCheck(pl))
			end
		end
		umsg.End()
	
	end)
end

function LDTgRankplayer( pl, cmd, arg )
local steamid = arg[1]
local rank = arg[2]

	if  !pl then
		
		local result = tmysql.query("SELECT * FROM `global_ranks` WHERE 'SteamID'='"..steamid.."'")
		if (result) then
			local result2 = tmysql.query("UPDATE `global_ranks` SET rank='"..rank.."' WHERE steamID='"..steamid.."'")
		else
			local result2 = tmysql.query("INSERT INTO `global_ranks` VALUES ('"..steamid.."', '"..rank.."')")
		end
		
	elseif pl:IsAdmin() then
		
		local result = tmysql.query("SELECT * FROM `global_ranks` WHERE 'SteamID'='"..steamid.."'")
		if (result) then
			local result2 = tmysql.query("UPDATE `global_ranks` SET rank='"..rank.."' WHERE steamID='"..steamid.."'")
		else
			local result2 = tmysql.query("INSERT INTO `global_ranks` VALUES ('"..steamid.."', '"..rank.."')")
		end
	
	else
		
		pl:Kick("TRYINGTOHAX?")
		
	end
	
end
concommand.Add( "LDTgRankplayer", LDTgRankplayer)
