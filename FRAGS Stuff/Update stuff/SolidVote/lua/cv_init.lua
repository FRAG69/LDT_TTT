/*-------------------------------------------------------------------------------------------------------------------------
	Serverside main script
-------------------------------------------------------------------------------------------------------------------------*/

// Info
local voteQuestion = ""
local voteEnd = 0
local lastVote = -1000
local voteCallback = function(voteRes)
end

// Vote running?
local function isVoteRunning()
	return voteEnd > CurTime()
end

// Count votes
local function votesYes( )
	local c = 0
	for _, v in pairs(player.GetAll()) do
		if v:GetNWBool( "cv_Voted", false ) and v:GetNWBool( "cv_Vote", false ) then
			c = c + 1
		end
	end
	
	return c
end

local function votesNo( )
	local c = 0
	for _, v in pairs(player.GetAll()) do
		if v:GetNWBool( "cv_Voted", false ) and !v:GetNWBool( "cv_Vote", false ) then
			c = c + 1
		end
	end
	
	return c
end

// Useful functions
local function findPlayer( nick )
	for _, v in pairs(player.GetAll()) do
		if string.find( string.lower(v:Nick()), string.lower(nick) ) or string.lower(v:Nick()) == string.lower(nick) then
			return v
		end
	end
end

local function PrintAll( msg )
	for _, v in pairs(player.GetAll()) do
		v:ChatPrint( "[SolidVote] " .. msg )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	This handles the results of the vote
-------------------------------------------------------------------------------------------------------------------------*/

local function resetVoteVars( )
	for _, v in pairs(player.GetAll()) do
		v:SetNWBool( "cv_Voted", false )
	end
end

local function voteFinish( )
	// End the vote completely
	voteEnd = 0
	timer.Remove( "tmVoteEnd" )
	
	// Handle off the result
	local mes, time = voteCallback( votesYes() > votesNo() )
	if !mes then mes = "Yes votes must exceed No votes." end
	if !time then time = 5 end
	
	// Notify players
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start( "cv_FinishVote", rp )
		umsg.Long( time )
		umsg.String( mes )
		umsg.Bool( votesYes() > votesNo() )
	umsg.End()
	
	// Reset variables
	resetVoteVars()
end

/*-------------------------------------------------------------------------------------------------------------------------
	Handle votes
-------------------------------------------------------------------------------------------------------------------------*/

local function playerVote( ply, com, args )
	if isVoteRunning() and !ply:GetNWBool( "cv_Voted", false ) and tonumber(args[1]) then
		local vote = tonumber(args[1])
		
		ply:SetNWBool( "cv_Vote", vote > 0 )
		ply:SetNWBool( "cv_Voted", true )
		Msg( ply:Nick() .. " voted " .. tostring(vote > 0) .. "!\n" )
		
		// If everyone voted, we can finish the vote
		if votesYes() + votesNo() == #player.GetAll() then
			timer.Remove( "tmVoteEnd" )
			timer.Create( "tmVoteEnd", 5, 1, voteFinish )
		end
		
		// Play vote sound
		for _, v in pairs(player.GetAll()) do
			v:ConCommand( "play common/bugreporter_succeeded.wav" )
		end
	end
end
concommand.Add( "cv_Vote", playerVote )

/*-------------------------------------------------------------------------------------------------------------------------
	Vote setup function
-------------------------------------------------------------------------------------------------------------------------*/

function setupVote( ply, question, votetime )
	if CurTime() - lastVote < VOTE_DELAY and !ply:IsAdmin() then
		ply:ChatPrint( "[SolidVote] Only one vote can be started every " .. VOTE_DELAY .. " seconds!" )
	elseif voteEnd < CurTime() then
		resetVoteVars()
		
		voteQuestion = question
		voteEnd = CurTime() + votetime
		lastVote = CurTime()
		
		// Send vote to players
		local rp = RecipientFilter()
		rp:AddAllPlayers()
		
		umsg.Start( "cv_SetupVote", rp )
			umsg.String( voteQuestion )
			umsg.Long( votetime )
		umsg.End()
		
		// Set a timer to deal with the results when the vote is over
		timer.Create( "tmVoteEnd", votetime, 1, voteFinish )
	else
		ply:ChatPrint( "[SolidVote] There's still a vote running!" )
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Vote creation frontend
-------------------------------------------------------------------------------------------------------------------------*/

local function cleanupMap( res )
	if res then
		timer.Simple( 5, function()
			game.CleanUpMap()
		end )
		
		return "Cleaning up the map..."
	end
end

local playerToKick = NULL
local function kickPlayer( res )
	if res then
		if playerToKick.Nick then
			timer.Simple( 5, function()
				local ip = playerToKick:IPAddress()
				playerToKick:Kick( "Kicked by vote. You'll have to wait for " .. VOTE_KICK_BANTIME .. " minutes." )
				RunConsoleCommand( "addip", VOTE_KICK_BANTIME, ip )
			end )
			
			return "Kicking player " .. playerToKick:Nick() .. "..."
		end
	end
end

local playerToBan = NULL
local function banPlayer( res )
	if res then
		if playerToBan.Nick then
			timer.Simple( 5, function()
				local ip = playerToBan:IPAddress()
				playerToBan:Kick( "Banned by vote for " .. VOTE_BAN_TIME .. " minutes." )
				RunConsoleCommand( "addip", VOTE_BAN_TIME, ip )
			end )
			
			return "Banning player " .. playerToBan:Nick() .. "..."
		end
	end
end

local function switchNoclip( res )
	if res then
		if server_settings.Int( "sbox_noclip", 0 ) > 0 then
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_noclip", 0 )
				for _, v in pairs(player.GetAll()) do v:SetMoveType( MOVETYPE_WALK ) end
			end )
		else
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_noclip", 1 )
			end )
		end
		
		return "Switching noclip..."
	end
end

local function switchGodmode( res )
	if res then
		if server_settings.Int( "sbox_godmode", 0 ) > 0 then
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_godmode", 0 )
			end )
		else
			timer.Simple( 5, function()
				RunConsoleCommand( "sbox_godmode", 1 )
			end )
		end
		
		return "Switching godmode..."
	end
end

local function regVote( res )
	if res then
		return "Yes has won the vote!"
	end
end

local function playerSay( ply, msg )
	if msg == "votecleanup" then
		if !VOTE_CLEAN then
			ply:ChatPrint( "[SolidVote] Cleanup votes have been disabled!" )
			return ""
		end
		
		voteCallback = cleanupMap
		setupVote( ply, "Cleanup the map?", 30 )
		
		return ""
	elseif msg == "votenoclip" then
		if !VOTE_NOCLIP then
			ply:ChatPrint( "[SolidVote] Noclip votes have been disabled!" )
			return ""
		end
		
		voteCallback = switchNoclip
		setupVote( ply, "Switch noclip?", 30 )
		
		return ""
	elseif msg == "votegod" then
		if !VOTE_GODMODE then
			ply:ChatPrint( "[SolidVote] Godmode votes have been disabled!" )
			return ""
		end
		
		voteCallback = switchGodmode
		setupVote( ply, "Switch godmode?", 30 )
		
		return ""
	elseif string.find( msg, " " ) then
		local args = string.Explode( " ", msg )
		
		if args[1] == "votekick" then
			if !VOTE_KICK then
				ply:ChatPrint( "[SolidVote] Kick votes have been disabled!" )
				return ""
			end
			
			local pl = findPlayer( args[2] )
			if pl then
				playerToKick = pl
				voteCallback = kickPlayer
				setupVote( ply, "Kick player " .. pl:Nick() .. "?", 30 )
			else
				ply:ChatPrint( "Player not found!" )
			end
			
			return ""
		elseif args[1] == "voteban" then
			if !VOTE_BAN then
				ply:ChatPrint( "[SolidVote] Ban votes have been disabled!" )
				return ""
			end
			
			local pl = findPlayer( args[2] )
			if pl then
				playerToBan = pl
				voteCallback = banPlayer
				setupVote( ply, "Ban player " .. pl:Nick() .. " for " .. VOTE_BAN_TIME .. " minutes?", 30 )
			else
				ply:ChatPrint( "Player not found!" )
			end
			
			return ""
		elseif args[1] == "vote" then
			if !VOTE_CUSTOM then
				ply:ChatPrint( "[SolidVote] Custom votes have been disabled!" )
				return ""
			end
			
			if ply:IsAdmin() then
				voteCallback = regVote
				local q = string.sub( msg, string.find( msg, "vote" ) + 5 )
				
				if string.len(q) > 30 then
					ply:ChatPrint( "[SolidVote] Your vote can't be longer than 30 characters!" )
				else
					setupVote( ply, q, 35 )
				end
				
				return ""
			end
		end
	end
end
hook.Add( "PlayerSay", "PlayerWantVote", playerSay )

/*-------------------------------------------------------------------------------------------------------------------------
	Vote help
-------------------------------------------------------------------------------------------------------------------------*/

if VOTE_AD_ENABLED then
	timer.Create( "tmVoteHelp", VOTE_AD_TIME, 0, function()
		PrintAll( VOTE_AD_MESSAGE )
	end )
end