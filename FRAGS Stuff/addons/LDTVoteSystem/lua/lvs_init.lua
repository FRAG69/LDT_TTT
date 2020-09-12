/*
|	 _     ______ _____   _   _       _                      _                  
|	| |    |  _  \_   _| | | | |     | |                    | |                 
|	| |    | | | | | |   | | | | ___ | |_  ___ ___ _   _ ___| |_  ___ _ __ ___  
|	| |    | | | | | |   | | | |/ _ \| __|/ _ | __| | | / __| __|/ _ \ '_ ` _ \ 
|	| |____| |/ /  | |   \ \_/ / (_) | |_|  __|__ \ |_| \__ \ |_|  __/ | | | | |
|	\_____/|___/   \_/    \___/ \___/ \__|\___|___/\__, |___/\__|\___|_| |_| |_|
|	                                                __/ |                       
|	                                               |___/     
By Frag and psycix
*/
/*-------------------------------------------------------------------------------------------------------------------------
	Setup
-------------------------------------------------------------------------------------------------------------------------*/
CreateConVar("LVS_maxrounds", 7, FCVAR_NOTIFY)

local allmaps = {}
local mapsinvote = {}
local votes = {}
local we_are_voting = false
local roundsplayed = 0
util.AddNetworkString( "LDT_startvote" )

//Fill allmaps table
//for k,v in pairs(file.Find("maps/*.bsp", "GAME")) do
for k,v in pairs(file.Find("maps/*.bsp", "GAME")) do
	local str = string.lower(v)
	if string.Left(str, 3) == "ttt_" then
		table.insert(allmaps, string.Left(v, (string.len(v)-4)) )
	end
end

//Pick 6 maps (TODO: Lock maps out or pick maps based on how much they are played, and !nominate.)
for i = 1, 6 do
	local randomnumber = math.random( #allmaps )
	local searchingformap = true
	
	while searchingformap do
		if table.HasValue(mapsinvote, allmaps[randomnumber]) then //Is it a duplicate? Then pick a new number and loop again!
			randomnumber = math.random( #allmaps )
		else
			table.insert( mapsinvote, allmaps[randomnumber] ) //Its not a duplicate, so insert it and stop looping.
			searchingformap = false
		end
	end
end

local function UpdateCVars(cvar, prevv, newv)
	RunConsoleCommand("ttt_round_limit", newv + 1)
end

cvars.AddChangeCallback("LVS_maxrounds", UpdateCVars)

/*
for i=0, table.count(allmaps) do
    allmaps[i].pic = string.gsub( allmaps[i], ".bsp", ".png" )
end
*/

/*-------------------------------------------------------------------------------------------------------------------------
	Count the rounds!
-------------------------------------------------------------------------------------------------------------------------*/
function RoundsPlayed()
	roundsplayed = roundsplayed + 1
	if roundsplayed == GetConVarNumber("LVS_maxrounds") then 
		LVS_Startvote() 
	end
end

hook.Add("TTTEndRound", "RoundsPlayed", RoundsPlayed)	

game.ConsoleCommand("ttt_round_limit " .. GetConVarNumber("LVS_maxrounds") + 1 .. "\n")



/*-------------------------------------------------------------------------------------------------------------------------
	Start
-------------------------------------------------------------------------------------------------------------------------*/
function LVS_Startvote()
	net.Start( "LDT_startvote" )
		for i = 1, 6 do
			net.WriteString( mapsinvote[i] )
		end
	net.Broadcast()
	
	we_are_voting = true

	timer.Simple(30, LVS_Endvote)
end

function LVS_Endvote()		
	local highest = -1
	local selectedmaps = {}
	
	for i = 1, 6 do
		if ( ( votes[i] or 0 ) > highest ) then
			selectedmaps = { i }
			highest = votes[i] or 0
		elseif ( ( votes[i] or 0 ) == highest ) then
			table.insert( selectedmaps, i )
		end
	end

	local changetomap = mapsinvote[ table.Random( selectedmaps ) ]
	RunConsoleCommand( "changelevel", changetomap, "terrortown" ) --Change this for each server
end

/*-------------------------------------------------------------------------------------------------------------------------
	Console command to vote
-------------------------------------------------------------------------------------------------------------------------*/
concommand.Add( "LDT_Vote", function( ply, com, args )
	if ( !mapsinvote[ tonumber( args[1] ) ] ) then return end
	local vote = tonumber( args[1] )
	
	if ( ply.LDT_Vote ) then
		votes[ply.LDT_Vote] = votes[ply.LDT_Vote] - 1
	end
	ply.LDT_Vote = vote
	
	if ( !votes[vote] ) then votes[vote] = 0 end
	votes[vote] = votes[vote] + 1
	
	net.Start( "LDT_Vote" )
		for i = 1, 6 do
			if ( votes[i] ) then
				umsg.Char( votes[i] )
			else
				umsg.Char( 0 )
			end
		end
	umsg.End()
end )

/*-------------------------------------------------------------------------------------------------------------------------
	RTV chathook
-------------------------------------------------------------------------------------------------------------------------*/
hook.Add( "PlayerSay", "ChatVotemap", function( ply, text, team )
	if string.lower(text) == "!rtv" or string.lower(text) == "!votemap" then
		LVS_Chat_RTV(ply)
		return ""
	end
end )

function LVS_Chat_RTV(ply)
	if !ply.LDTRTV then
		ply.LDTRTV = true
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint(ply:Nick().." has rocked the vote by typing !rtv") //TODO: Make it look fancy instead of chatprint.
			//evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has rocked the vote by typing ", evolve.colors.red, " !rtv " )
		end
	else
		ply:ChatPrint("You already RTV-ed!")
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	TTTroundend -> Check our own maptimer and count RTV's
-------------------------------------------------------------------------------------------------------------------------*/
function LVS_Checkforswitch()
	local LDTRTVs = 0
	for k,v in pairs(player.GetAll()) do
		if v.LDTRTV then
			LDTRTVs = LDTRTVs + 1
		end
	end
	
	if (LDTRTVs>=(#player.GetAll()/2)) then
		LVS_Startvote()
	end
end

hook.Add( "TTTEndRound", "LVS_Checkforswitch", LVS_Checkforswitch)

/*-------------------------------------------------------------------------------------------------------------------------
	Delay the round start if the vote has started.
-------------------------------------------------------------------------------------------------------------------------*/
hook.Add( "TTTDelayRoundStartForVote", "Dont_start_if_in_vote", function()
	if we_are_voting then
		return true
	end
end)

/*-------------------------------------------------------------------------------------------------------------------------
	Fuck up fretta! :D
-------------------------------------------------------------------------------------------------------------------------*/
hook.Add( "Initialize", "Initialize_fuck_up_fretta", function()
function GAMEMODE:StartFrettaVote()   
	LVS_Startvote()
end
function GAMEMODE:StartGamemodeVote() 
print("Blocked frettagamemodevote")
 end
function GAMEMODE:StartContinueVote() 
print("Blocked frettacontinuevote")
end 
function GAMEMODE:StartMapVote() 
print("Blocked frettamapvote")
end 

function GAMEMODE:VoteForChange(pl) //Change button will run our !rtv.
	LVS_Chat_RTV(pl)
end

end )




