
/*
   __     ___  ______                     _        _             _        
  / /    /   \/__  __|_ __ ___   _   _   /_\    __| | _ __ ___  (_) _ __  
 / /    / /\ /  / /  | '_ ` _ \ | | | | //_\\  / _` || '_ ` _ \ | || '_ \ 
/ /___ / /_//  / /   | | | | | || |_| |/  _  \| (_| || | | | | || || | | |
\____//___,'   \/    |_| |_| |_| \__, |\_/ \_/ \__,_||_| |_| |_||_||_| |_|
                                 |___/                                    

	LDTmyAdmin - fucking incomplete version
	Property of the Let's Do This community
	Made by psycix
*/

/*==========================================================
	Ban system
==========================================================*/

if !sql.TableExists("lma_bans") then
	print([[No lma_bans SQL table found!]])
	query = "CREATE TABLE lma_bans (steamID varchar(255), endtime int, reason varchar(255), source varchar(255))"
	result = sql.Query(query)
	if (sql.TableExists("lma_bans")) then
		print([[lma_bans SQL table created!]])
	else
		print([[Error creating lma_bans SQL table!]])
		print( sql.LastError( result ))
	end
else
	print([['lma_bans' SQL table found!]])
end

function LMA_BanID(id, time, reason, sourcenick)
	local endtime = 0
	
	if time > 0 then
		endtime = os.time() + time
	end

	LMA_UnbanID(id)
	
	local query = "INSERT INTO lma_bans VALUES(%s, %s, %s, %s)"
	local qstr = string.format(query, SQLStr(id), endtime, SQLStr(reason), SQLStr(sourcenick))
	local result = sql.Query(qstr)
	
	local pl = LMA_GetPlayerBySteamID(id)
	if pl then
		if time == 0 then
			local kickstring = string.format("You have been banned from this server permanently for the following reason: - %s - For more information on bans see www.LDT-clan.com", reason)
			pl:Kick(kickstring)
		else
			local kickstring = string.format("You have been banned by %s for %s minutes for the following reason: - %s - The ban will expire on %s server time. For more information on bans see www.LDT-clan.com", sourcenick, math.ceil(time/60), reason, os.date("%c", (os.time() + time)))
			pl:Kick(kickstring)
		end
	end
end

function LMA_UnbanID(id)
	local query = "DELETE FROM lma_bans WHERE steamID = %s"
	local qstr = string.format(query, SQLStr(id))
	sql.Query(qstr)
end

function LMA_IsBanned(id)
	local query = "SELECT * FROM lma_bans WHERE steamID = %s AND (endtime > %s OR endtime = 0)"
	local qstr = string.format(query, SQLStr(id), os.time())
	local result = sql.Query(qstr)
	
	if result and result[1] then
		return result[1]
	else
		local query = "DELETE FROM lma_bans WHERE steamID = %s"
		local qstr = string.format(query, SQLStr(id), os.time())
		sql.Query(qstr)
		return false
	end
end

function LMA_Drop(userid, reason)
    game.ConsoleCommand(string.format("kickid %d %s\n",userid,reason:gsub('|\n','')))
end

gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "AnnounceConnection", function( data )
	local banresults = LMA_IsBanned(data.networkid)
	if banresults then
		if banresults.endtime == 0 then
			LMA_Drop(data.userid, string.format("You are permanently banned from this server for the following reason: - %s - For more information on bans see www.LDT-clan.com", banresults.reason))
		else
			LMA_Drop(data.userid, string.format("You are banned from this server for %s more minutes for the following reason: - %s - The ban will expire on %s server time. For more information on bans see www.LDT-clan.com", math.ceil((os.time()-banresults.endtime)/-60), banresults.reason, os.date("%c", banresults.endtime)))
		end
	end
end )