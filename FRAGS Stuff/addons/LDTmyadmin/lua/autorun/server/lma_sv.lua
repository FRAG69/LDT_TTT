
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
	Send stuff to client and include
==========================================================*/
AddCSLuaFile( "autorun/client/lma_cl.lua" )
AddCSLuaFile( "lma_sh.lua" )
include("lma_sh.lua")
include("lma_sv_plugins.lua")
include("lma_sv_bans.lua")
resource.AddFile("materials/LMA/LDTmyAdmin.png")
 
--==========================================================
--	SQL initialization
--==========================================================

require("tmysql4")

function LMA_connect()
	LMA_DB, err = tmysql.initialize( "127.0.0.1", "LMA_usr", "xfCgbxlcVePLPMxpgFwgsxiLakphkA", "ldt_my_admin", 1337 )
	 
	if LMA_DB then
		print([[==========================================================
           LDT MyAdmin connected to the database
==========================================================]])
	elseif err then
		print( "[TMySQL] Error connecting to GMOD database!\n" )
		print( "[TMySQL] Error: " .. err .. "\n" )
	end
end

if LMA_DB then

else
    LMA_connect()
end


function LMA_query( sql, callback )
	if LMA_DB then
		LMA_DB:Query( sql, callback, QUERY_FLAG_ASSOC )
	else
		print("No DB connections! Reconnecting to DB...")
		LMA_connect()
		timer.Simple( 1, LMA_query( sql, callback ))
	end
end

function SQL_Filter(str)
	
	str = str:gsub( [[\]], [[\\]] )
	str = str:gsub( [[']], [[\']] )
	
	return [[']]..str..[[']]
end

--==========================================================
--	Playerjoin/playerinitialspawn/playerconnect/playerauth
--==========================================================

local LMA_session_increment = 0

function LMA_PlayerInitialSpawn(pl)
	pl:SetNWInt("LMA_session", LMA_session_increment)
	LMA_session_increment = LMA_session_increment + 1
	
	local SID = SQL_Filter(pl:SteamID())
	local NAME = SQL_Filter(pl:Nick())
	local IP = SQL_Filter(pl:IPAddress())
	
	local q = ("CALL `dev` ("..SID..", "..NAME..", "..IP..")")
	
	local callback = function (data, status, err) 
		if status == QUERY_SUCCESS then
			for _,row in pairs(data) do
				PrintTable(row)
				LMA_LoadPlayer(row["steamID"], tonumber(row["rank"]), row["donator"], row["oldname"])
			end
		else
			ErrorNoHalt( error )
		end
	end
	
	LMA_query( q, callback )
end
hook.Add( "PlayerInitialSpawn", "LMA_PlayerInitialSpawn", LMA_PlayerInitialSpawn)

function LMA_LoadPlayer(steamID, rank, donator, lastAlias)
	local pl = LMA_GetPlayerBySteamID(steamID)

	if pl then
		
		if rank < 0 then
			pl:Kick("Globally banned.")
		end
		
		if (lastAlias and lastAlias != "" and (pl:Nick() != lastAlias)) then
			LMA_Broadcast("Welcome "..pl:Nick()..", you last joined as: "..lastAlias)
		else
			LMA_Broadcast("Welcome "..pl:Nick())
		end
		
		pl:SetNWInt("LDT_rank", rank)
		
		LMA_SendMessage(pl, "Your rank is: "..LDT_ranknames[rank])
		
	end
	
end

--==========================================================
--	Messaging
--==========================================================

util.AddNetworkString( "LMA_chatmsg" )

function LMA_SendMessage(pl, str)
net.Start( "LMA_chatmsg" )
	net.WriteString( str )
net.Send( pl )
end

function LMA_Broadcast(str)
net.Start( "LMA_chatmsg" )
	net.WriteString( str )
net.Broadcast()
print("[LDTmyAdmin] "..str)
end

/*==========================================================
	Command running
==========================================================*/

function LMA_Command(str, source)
	local firstchar = string.Left(str,1)
	
	if ((firstchar == "!") || (firstchar == "/")) then //&& (string.len(str) > 3)
		local args = string.Explode(" ", str)
		local cmd = string.lower(string.sub(args[1], 2))
		if LMA_Commands[cmd] then			
			if LMA_CanRun(source, LMA_Commands[cmd]["rank"]) then //tabletest?
				if tostring(args[2]) then
					local target = false
					if (firstchar == "!") then
						target = LMA_GetPlayerByName(args[2])
					else //if (firstchar == "/") then
						target = LMA_GetPlayerBySession(args[2])
					end
					if target then					
						if (source != target) || LMA_Commands[cmd]["self"] then							
							if (source:GetNWInt("LDT_rank") > target:GetNWInt("LDT_rank")) || LMA_Commands[cmd]["higherrank"] || (source == target)  then
								
								LMA_Commands[cmd]["func"](source, args, target)
								
							else
								--Cant target higher rank
								LMA_FeedbackMessage(source, "Can only target a lower rank.")
							end						
						else
							--Cant target self
							LMA_FeedbackMessage(source, "Can't target yourself!")
						end					
					else
						--No unique player can be found with [...]
						LMA_FeedbackMessage(source, "No unique player found.")
					end
				else
					--No player entered
					LMA_FeedbackMessage(source, "Please enter the player parameters.")
				end
			else
				--not high enough rank!
				LMA_FeedbackMessage(source, "You are not authorized to run this command.")
			end			
		else
			--Command not found
			//LMA_FeedbackMessage(source, "Command not found.")
			return false
		end	
		--Firstchar string handled
		return true
	elseif (firstchar == "@") then	
		local args = string.Explode(" ", str)
		local cmd = string.lower(string.sub(args[1], 2))
		if LMA_NonPlayerCommands[cmd] then
			if LMA_CanRun(source, LMA_NonPlayerCommands[cmd]["rank"]) then
				LMA_NonPlayerCommands[cmd]["func"](source, args)
			else
				--not high enough rank!
				LMA_FeedbackMessage(source, "You are not authorized to run this command.")
			end
		else
			--Command not found
			LMA_FeedbackMessage(source, "Command not found.")
		end
		return true
	else
		--Not a command
		return false
	end
	return false
end

function LMA_CanRun(inp, req)

	if !inp then return false end
	
	if inp:IsPlayer() then 
		return inp:LMA_IsRank(req)
	else
		if inp:EntIndex() == 0 then 
			return true
		end
	end

	return false
end

function LMA_FeedbackMessage(source, msg)
	if source then
		if source:IsPlayer() then
			LMA_SendMessage(source, msg)
		else
			print("[LDT] MyAdmin "..msg)
		end		
	end
end


function LMA_PlayerSay(pl, str, teamchat )
	if LMA_Command(str, pl) then
		return false // return "" ?
	end
end
hook.Add( "PlayerSay", "LMA_PlayerSay", LMA_PlayerSay)





print([[==========================================================
           LDT MyAdmin Has Loaded Completely!!!
==========================================================]])
