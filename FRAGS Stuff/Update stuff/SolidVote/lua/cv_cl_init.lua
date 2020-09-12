/*-------------------------------------------------------------------------------------------------------------------------
	Clientside main script
-------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------------------------------------
	Voting window
-------------------------------------------------------------------------------------------------------------------------*/

// Constants
local windowWidth = 320
local windowHeight = 225
local windowLeft = 30
local windowTop = ScrH() / 2 - windowHeight / 2
local reswindowTop = ScrH() / 2 - 50
local windowIndent = 10

local texCheck = surface.GetTextureID( "vote/check" )
local texCross = surface.GetTextureID( "vote/cross" )
local texCheckLarge = surface.GetTextureID( "vote/checkLarge" )
local texCrossLarge = surface.GetTextureID( "vote/crossLarge" )

// Info
local voteQuestion = ""
local voteEnd = 0
local voteResEnd = 0
local voteResMessage = ""
local voteResResult = false

// Fonts
surface.CreateFont( "Arial", 22, 600, true, false, "VoteTitle" )
surface.CreateFont( "Arial", 30, 400, true, false, "VoteResult" )
surface.CreateFont( "Arial", 17, 500, true, false, "VoteQuestion" )
surface.CreateFont( "Arial", 20, 400, true, false, "VoteResultMsg" )

// Vote 'Yes'
local function voteYes( )
	RunConsoleCommand( "cv_Vote", 1 )
end

// Vote 'No'
local function voteNo( )
	RunConsoleCommand( "cv_Vote", 0 )
end

// Vote running?
local function isVoteRunning ()
	return voteEnd > CurTime()
end

// Vote result display?
local function isVoteResultShown( )
	return voteResEnd > CurTime()
end

// Draw voting window
local function drawVoteWindow( )
	if isVoteRunning() then
		// Alter the height to fit the vote boxes
		windowHeight = math.ceil( #player.GetAll() / 9 ) * 34 + 171
		local windowTop = ScrH() / 2 - windowHeight / 2
		
		// Draw background
		draw.RoundedBox( 6, windowLeft, windowTop, windowWidth, windowHeight, Color( 0, 0, 0, 255 ) )
		
		// VOTE title
		draw.SimpleText( "VOTE:", "VoteTitle", windowLeft + windowIndent, windowTop + windowIndent, Color( 129, 129, 129 ) )
		
		// Voting question
		draw.SimpleText( voteQuestion, "VoteQuestion", windowLeft + windowIndent, windowTop + windowIndent + 25, Color( 255, 255, 255 ) )
		
		// Draw voting help
		surface.SetDrawColor( 129, 129, 129, 255 )
		surface.DrawLine( windowLeft + windowIndent, windowTop + windowIndent + 70, windowLeft + windowWidth - windowIndent, windowTop + windowIndent + 70 )
		
			surface.SetDrawColor( 62, 86, 102, 255 )
			surface.DrawRect( windowLeft + windowIndent, windowTop + windowIndent + 76, windowWidth - windowIndent * 2, 25 )
			draw.SimpleText( "Press F11 to vote YES", "VoteQuestion", windowLeft + windowWidth / 2, windowTop + windowIndent + 89, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Press F12 to vote NO", "VoteQuestion", windowLeft + windowWidth / 2, windowTop + windowIndent + 114, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		surface.SetDrawColor( 129, 129, 129, 255 )
		surface.DrawLine( windowLeft + windowIndent, windowTop + windowIndent + 132, windowLeft + windowWidth - windowIndent, windowTop + windowIndent + 132 )
		
		// Draw votes themselves
		draw.SimpleText( "Current vote count:", "VoteQuestion", windowLeft + windowIndent, windowTop + windowIndent + 137, Color( 129, 129, 129 ) )
		
		local players = player.GetAll()
		local rows = math.ceil( #players / 9 )
		local cols = 0
		local pid = 1
		
		for row = 0, rows - 1 do
			if row < rows - 1 or #players % 9 == 0 then cols = 9 else cols = #players % 9 end
			for col = 0, cols - 1 do
				surface.SetDrawColor( 129, 129, 129, 255 )
				surface.DrawOutlinedRect( windowLeft + windowIndent + (col * 34), windowTop + windowIndent + 159 + (row * 34), 25, 25 )
				
				// Put a mark if this user has voted YES or a cross if NO
				local ply = players[pid]
				if ply:GetNWBool( "cv_Voted", false ) then
					if ply:GetNWBool( "cv_Vote", false ) then
						surface.SetTexture( texCheck )
					else
						surface.SetTexture( texCross )
					end
					
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawTexturedRect( windowLeft + windowIndent + (col * 34) + 4, windowTop + windowIndent + 159 + (row * 34) + 3, 18, 18 )
				end
				
				pid = pid + 1
			end
		end
	elseif isVoteResultShown() then
		// Draw box
		surface.SetFont( "VoteResultMsg" )
		local wWidth = surface.GetTextSize( voteResMessage ) + 40
		if wWidth < windowWidth then wWidth = windowWidth end
		draw.RoundedBox( 6, windowLeft, reswindowTop, wWidth, 100, Color( 0, 0, 0, 255 ) )
		
		// Draw icon and text based on the result
		local ResColor = nil
		local ResText = nil
		
		if voteResResult then
			surface.SetTexture( texCheckLarge )
			ResColor = Color( 255, 255, 255, 255 )
			ResText = "VOTE PASSED!"
		else
			surface.SetTexture( texCrossLarge )
			ResColor = Color( 206, 2, 0, 255 )
			ResText = "VOTE FAILED."
		end
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( windowLeft + 20, reswindowTop + 20, 32, 32 )
		draw.SimpleText( ResText, "VoteResult", windowLeft + 20 + 32 + 13, reswindowTop + 20 + 16, ResColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		// Draw extra message
		draw.SimpleText( voteResMessage, "VoteResultMsg", windowLeft + 20, reswindowTop + 20 + 32 + 8, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
end
hook.Add( "HUDPaint", "DrawVoteWindow", drawVoteWindow )

/*-------------------------------------------------------------------------------------------------------------------------
	Handle input for voting
-------------------------------------------------------------------------------------------------------------------------*/

local lastPress = 0
local function KeyThink( )
	if CurTime() > lastPress + 1 and isVoteRunning() then
		if input.IsKeyDown( KEY_F11 ) then
			voteYes()
			lastPress = CurTime()
		elseif input.IsKeyDown( KEY_F12 ) then
			voteNo()
			lastPress = CurTime()
		end
	end
end
hook.Add( "Think", "KeyInput", KeyThink )

/*-------------------------------------------------------------------------------------------------------------------------
	Setup votes received from the server
-------------------------------------------------------------------------------------------------------------------------*/

local function setupVote( um )
	voteQuestion = um:ReadString()
	voteEnd = CurTime() + um:ReadLong()
end
usermessage.Hook( "cv_SetupVote", setupVote )

local function clearVote( um )
	voteResEnd = CurTime() + um:ReadLong()
	voteResMessage = um:ReadString()
	voteResResult = um:ReadBool()
	
	voteQuestion = ""
	voteEnd = 0
end
usermessage.Hook( "cv_FinishVote", clearVote )