---IGNORE THIS
MAPVOTE = {} --config
KMapVote = {} --logic
MAPVOTE.maps = {}
function MAPVOTE:AddMap( map )
	table.insert( self.maps, map )
	if MAPVOTE.Debug then
		print( "[MapVote] Map " .. map.name .. " added" )
	end
end

MAPVOTE.votePowers = {}
function MAPVOTE:SetVotePower( group, power )
	self.votePowers[group] = power
end
--END IGNORE

/*
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	Update Notes 2.0:
	
	- MySQL:
		MySQL is now optional for map rating, you can set it up in the following config file:
		LibK/lua/libk/sv_libk_config.lua
		MySQL gives a slightly better performance and allows you to access map ratings 
		from a web script.
		
		By default SQLite(sv.db) is used for saving ratings and playcounts.
		
	- Map Locations:
		To add maps to the vote go to sh_mapvote_maps.lua in the same folder as 
		this file. You can find detailed instructions there.
		
	- Colors:
		Colors moved to skins now, to change them go to 
		KMapVote/lua/mapvote/client/cl_dermaskin.lua
		You will find the color variables at the top of the file, very similar to how it was
		before. If you have any trouble porting your color scheme contact me on Steam.
		
		If you're experienced in lua you can put copy the file into the lua/mapvote/client folder
		and change the skin name at the bottom. This name can then be used in MAPVOTE.DermaSkin
		If you have a specific look in mind get in touch, the new skinning system makes custom
		skins much easier to make and thus much more affordable.
		
	-Map Images
		Map images are now loaded from the web to avoid extra downloads on the server.
		This makes sure that only the map images needed for a vote are loaded and is very
		useful for servers that use many maps. The map images are hosted on the cloudflare 
		CDN(Content Distribution Network) to ensure high availability and excellent speed
		for players independantly of where they connect from.
		
		If you have any icons that are missing, send them as 256x256px png to funk.valentin@gmail.com
		For the slideshow feature the naming should be as follows:
			1. Image: mapname.png
			2. Image: mapname(1).png
			3. Image: mapname(2).png 
			and so on
			example: de_dust.png, de_dust(1).png...
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
*/

/*
	Gamemode Vote Settings
*/
--Enable the vote of a gamemode prior to map vote
MAPVOTE.VoteForGamemode = false

--Gamemodes that are available to vote for:
MAPVOTE.VoteGamemodes = {
	"terrortown"
}


/*
	GUI Configuration
*/
--Color configuration moved to cl_dermaskin.lua 
--Go to KMapVote2/lua/mapvote/client/cl_dermaskin.lua to change Colors

--Enable or Disable the poping sound when players change their vote
MAPVOTE.EnableVoteSound = true

--If you want the sound to only play when the local player changes his vote, but not when others do, set this to true
MAPVOTE.SoundLocalVoteOnly = false

--Volume of the sound, number between 0 and 1, where 1 is 100% and 0 is 0%
MAPVOTE.SoundVolume = 0.7

--Give the sound a different tone for different players. neat little effect
MAPVOTE.PitchSound = true

--Skin to use. Try KMapVoteDefault for the default skin or KMapVoteFS for the fullscreen skin
--contact me on coderhire or steam if you need a custom skin
MAPVOTE.DermaSkin = "KMapVoteFS"

--Allow players to close the vote window during a vote. This has to be supported by the skin(currently the fullscreen skin supports this).
MAPVOTE.AllowClose = true

--Enable or Disable the logo.
MAPVOTE.UseLogo = true

--You should rename your logo and update this path to prevent
--players from other players with this addon to show the wrong logo
--This is the path to the logo without the materials/ prefix.
MAPVOTE.LogoPath = "VGUI/LDTBanner.png"

--If you dont understand or cant figure out the settings below, send me your logo as pm on coderhire, 
--and how you image it to look and i'll set it up for you!

--Set this to logo width/logo height, it's used for the auto resizing of the logo on fullscreen skins
MAPVOTE.LogoAspect = 1920 / 641

--Set this to the minimun/maximum width you want your logo to have. Height is automatically determined
MAPVOTE.LogoMinWidth = 128 
MAPVOTE.LogoMaxWidth = 1200
MAPVOTE.LogoScreenScale = 1/2 --Use 1/6 of the screen size for the logo size

/*
	RTV - Rock the Vote Settings
*/
--Enable RTV
MAPVOTE.RockTheVote = true

--Enable RTV Cooldown timer, after a failed RTV wait this amount of minutes before allowing another one.
--Set to false to disable
MAPVOTE.RTVCooldown = 5

--Time in minutes that a map is required to run after a vote until a RTV can be started(also applies for extension).
--Set to false to disable
MAPVOTE.RTVInitialCooldown = 5

--If this fraction is reached, the vote will start
--e.g MAPVOTE.RTVRequiredFraction = 1 / 2 Vote will need half the server to RTV
MAPVOTE.RTVRequiredFraction = 1/2

--Time the RTV waits for above fraction to be reached
MAPVOTE.RTVPreVoteTime = 60

--Should vote powers also apply for RTV votes?
--This means that if a player with votepower 2 says !rtv their vote counts as two
MAPVOTE.RTVUserVotePower = false

--Make the map change after the current ttt round is finished
--Requires MAPVOTE.UseTerrortown = true
MAPVOTE.RTVWaitUntilTTTRoundEnd = true


/*
	General Settings
*/
--Enable Debug prints. If you experience any errors leave this on, it will help isolating the cause
MAPVOTE.Debug = true

--Enable checking for maps before vote
MAPVOTE.CheckMaps = true

--Amount of votings that have to pass until a map that won a vote shows up next.
--Prevents players voting for the same map over and over again. Set to false to disable.
MAPVOTE.MapCooldown = 3

--Automatically start a vote after the specified amount of time(in minutes), set to false to disable
--Example: MAPVOTE.TimeBetweenVotes = 10
--This would start a Vote every 10 minutes
MAPVOTE.TimeBetweenVotes = false

--Amount of time(in seconds) that the winning map/gamemode flashes after 
MAPVOTE.PostVoteTime = 3

--Time that players have to choose a new map in s
MAPVOTE.VoteTime = 30

--Allow voting to keep the current map
MAPVOTE.AllowExtension = true

--Allow closing the mapvote window(if skin supports it)
MAPVOTE.AllowExit = true

--Number of maps to display per vote
--9 + Extension = 10
MAPVOTE.MapsPerVote = 9

--Enable the use of admin plugins for vote powers and RTV.
--Currently ulx, evolve and exsto are supported
MAPVOTE.AdminPlugin = "ldt"

--Enable the Map Ratings System
MAPVOTE.EnableRatings = true

--Show the next vote timer on the top of the screen(HUD)
MAPVOTE.ShowHUDHint = true


/*
	Gamemode Integration Settings
*/

--If true the mapvote script will come up once TTT wants to switch the
--map(time/round limit reached)
MAPVOTE.UseTerrortown = true

--If set to true the mapvote will replace the Deathrun vote(for MrGash/Gmod-Deahtrun)
--This will disable the builtin deathrun RTV and use KMapvote RTV instead(settings above)!
MAPVOTE.SetDeathrunReplacement = true

--Set to true to enable overwriting the fretta mapvote(will trigger KMapVote instead)
MAPVOTE.SetFrettaReplacement = true

/*
	Admin Settings and vote powers
*/

--Groups allowed to override the map choice
--by clicking on the Force button
MAPVOTE.AllowOverrideGroups = {
	"Admin", 
}

/*
	usergroup -> Vote power map.
	Used to set the votepower of certain groups.
	Default votepower of a user is 1, votepowers of all votes are added up
	during a mapvote, the map with the highest score of wins.
*/
MAPVOTE:SetVotePower( "Guest", 1 )
MAPVOTE:SetVotePower( "Regular", 1 )
MAPVOTE:SetVotePower( "Trusted", 1 )
MAPVOTE:SetVotePower( "Moderator", 1 )
MAPVOTE:SetVotePower( "Donator", 2 )
MAPVOTE:SetVotePower( "Admin", 2 )
	
	
/*
	Do not edit below this line
*/
function table.shuffle( t )
        math.randomseed( os.time( ) )
        assert( t, "table.shuffle() expected a table, got nil" )
        local iterations = #t
        local j
        for i = iterations, 2, -1 do
			j = math.random( i )
			t[i], t[j] = t[j], t[i]
        end
end

local Player = FindMetaTable( "Player" )
function Player:GetVotePower( )
	local ply = self
	local playerVotePower = 1
	if MAPVOTE.AdminPlugin == "evolve" then
		if MAPVOTE.votePowers[ply:EV_GetRank()] then
			playerVotePower = MAPVOTE.votePowers[ply:EV_GetRank()]
		end
	elseif MAPVOTE.AdminPlugin == "ulx" then
		if MAPVOTE.votePowers[ply:GetUserGroup()] then
			playerVotePower = MAPVOTE.votePowers[ply:GetUserGroup()]
		end
	elseif MAPVOTE.AdminPlugin == "exsto" then
		if MAPVOTE.votePowers[ply:GetRank()] then
			playerVotePower = MAPVOTE.votePowers[ply:GetRank()]
		end
	elseif MAPVOTE.AdminPlugin == "ldt" then
		if MAPVOTE.votePowers[ply:LMA_IsRank(0)] then
			playerVotePower = MAPVOTE.votePowers[ply:LMA_IsRank(0)]
		end
	end
	return playerVotePower
end

function Player:CanOverride( )
	if MAPVOTE.AdminPlugin == "evolve" then
		if table.HasValue( MAPVOTE.AllowOverrideGroups, self:EV_GetRank() ) then
			return true
		end
	elseif MAPVOTE.AdminPlugin == "ulx" then
		if table.HasValue( MAPVOTE.AllowOverrideGroups, self:GetUserGroup() ) then
			return true
		end
	elseif MAPVOTE.AdminPlugin == "exsto" then
		if table.HasValue( MAPVOTE.AllowOverrideGroups, self:GetRank() ) then
			return true
		end
	elseif MAPVOTE.AdminPlugin == "ldt" then
		if table.HasValue( MAPVOTE.AllowOverrideGroups, self:LMA_IsRank(0) ) then
			return true
		end
	end
	return playerVotePower
end