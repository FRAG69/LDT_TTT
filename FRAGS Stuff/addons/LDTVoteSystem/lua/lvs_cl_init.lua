
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
local mapcandidates = {}
local maps = {}
local votes = {}
for i=1,6 do
	votes[i] = 0
end
local vote

/*-------------------------------------------------------------------------------------------------------------------------
	Update maps and start vote
-------------------------------------------------------------------------------------------------------------------------*/
usermessage.Hook( "LDT_startvote", function( um )
	for i = 1, 6 do
		maps[i] = um:ReadString()
	end
	
	votestarttime = CurTime()
	hook.Add("HUDPaint","DrawVotes",LVS_DrawVotingGui)
	gui.EnableScreenClicker( true )
	
	
	//Also override the scoreboard hiding function so that our cursor doesn't disappear if hitting TAB by accident.
	function GAMEMODE:ScoreboardHide()
	   self.ShowScoreboard = false

	   gui.EnableScreenClicker(true)

	   if sboard_panel then
		  sboard_panel:SetVisible(false)
	   end
	end
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Update votes
-------------------------------------------------------------------------------------------------------------------------*/
usermessage.Hook( "LDT_Vote", function( um )
	for i = 1, 6 do
		votes[i] = um:ReadChar()
	end
end )

/*-------------------------------------------------------------------------------------------------------------------------
	Draw vote menu
-------------------------------------------------------------------------------------------------------------------------*/
surface.CreateFont ("coolvetica", 32, 400, true, false, "VotingTitle")
surface.CreateFont ("coolvetica", 24, 400, true, false, "VotingOthers")

function LVS_DrawVotingGui()
	local dr = {} //Drawing coordinates n stuff.
	dr.w = 400	//The size of the window is a fixed number.
	dr.h = 275
	dr.x = 10
	dr.y = (ScrH()-dr.h)*0.5
	
	draw.RoundedBox( 6, dr.x-2, dr.y-2, dr.w+4, dr.h+4, Color(233,152,37) ) //Draw slightly larger square for border.
	draw.RoundedBox( 6, dr.x, dr.y, dr.w, dr.h, Color(50,50,50) )
	
	dr.x = dr.x + 25 //Shift our "drawing positions"
	dr.y = dr.y + 25
	
	//Title
	if !vote then
		draw.SimpleText("Vote for a map:", "VotingTitle", dr.x, dr.y, Color(255,255,255), 0, 11)
	else
		draw.SimpleText("Voted!", "VotingTitle", dr.x, dr.y, Color(255,255,255), 0, 11)
	end
	
	dr.y = dr.y + 50 //Shift our "drawing position"
	
	//Check if someone clicks on something or where the mouse cursor is hovering
	local MouseIsDown = input.IsMouseDown(MOUSE_LEFT)
	local MouseX, MouseY = gui.MousePos()
	
	if vote then
		draw.RoundedBox( 4, dr.x, dr.y+(25*(vote-1)), dr.w-50, 25, Color(233,152,37) ) //Make a box to indicate we voted on this.
	end
	
	//local tex = surface.GetTextureID("maps/noicon")
	local tex = surface.GetTextureID("maps/"..#votes[i], "maps/noicon")
	
	if MouseX > dr.x and MouseX < dr.x+dr.w then //Are we within the window? (x-wise)
		for i=1, #maps do
			if MouseY >= dr.y+(25*(i-1)) and MouseY < dr.y+(25*i) then
				surface.SetTexture(tex)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawTexturedRect(dr.x , dr.y, 64, 64)

			end
		end
	end
	
	if MouseX > dr.x and MouseX < dr.x+dr.w then //Are we within the window? (x-wise)
		for i=1, #maps do
			if MouseY >= dr.y+(25*(i-1)) and MouseY < dr.y+(25*i) then //Is the cursor on this map?
				if !vote or vote != i then
					draw.RoundedBox( 4, dr.x, dr.y+(25*(i-1)), dr.w-50, 25, Color(100,100,100) ) //Make a box to indicate we're hovering on this map.
				end
				if MouseIsDown then //If we detect a click...
					RunConsoleCommand("LDT_Vote",i)	//THEN VOTE FOR IT! :D
					vote = i
					gui.EnableScreenClicker(false)
				end
			end
		end
	end

	//Draw mapnames to vote on!
	for k,v in pairs(maps) do
		local color = Color(255,255,255)
		//if vote == k then color = Color(50,50,50) end
		draw.SimpleText(v.." ("..votes[k]..")","VotingOthers", dr.x, dr.y+12, color, 0, 1)
		dr.y = dr.y + 25
	end	
	
	//Draw progress bar!
	dr.y = dr.y + 10
	draw.RoundedBox( 4, dr.x, dr.y, dr.w-50, 15, Color(100,100,100) ) //Border
	draw.RoundedBox( 4, dr.x+2, dr.y+2, dr.w-50-4, 15-4, Color(200,200,200) ) //Background
	local howlong = (CurTime()-votestarttime)
	local relative = (howlong/30)
	local barscaler = math.Clamp(relative, 0, 1)
	draw.RoundedBox( 4, dr.x+2, dr.y+2, (dr.w-50-4)*barscaler, 15-4, Color(233,152,37) ) //The bar itself.
	
end
