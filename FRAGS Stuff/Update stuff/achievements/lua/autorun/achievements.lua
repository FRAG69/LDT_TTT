// KEEP THIS UPDATED.
// This was part of a version set up but got ditched
// Why have I not taken it out yet?


/*
Msg([[

#############################################################
##            LDT Achievements System by FRAG              ##
##                  Successfuly Started                    ##
#############################################################

]])

*/

//ONLY update the version number to reset everyone's achievements!
local VERSION = 2

local SERVER_ENABLED = true
if ( SERVER && SERVER_ENABLED ) then
	// Send the main files to the client.
	AddCSLuaFile( "achievements.lua" )
	AddCSLuaFile( "client/usermessage_hook.lua" )
	AddCSLuaFile( "client/cl_notify.lua" )
	
	// Send the achievement files to the client.
	for _, achievement in pairs( file.FindInLua( "achievements/*.lua" ) ) do
		AddCSLuaFile( "achievements/" .. achievement )
	end
	
	// Add materials and sounds to resource.
	for _, mat in pairs( file.Find( "../materials/achievements/*" ) ) do
		resource.AddFile( "materials/achievements/" .. mat )
	end
	for _, sound in pairs( file.Find( "../sound/achievements/*" ) ) do
		resource.AddFile( "sound/achievements/" .. sound )
	end
	
	return
end
if ( SERVER ) then return end

local options
local function Options()
	if ( options ) then
		options:Remove()
	end
	
	options = vgui.Create( "DFrame" )
		options:SetWide( 200 )
		options:SetTitle( "Options" )
		options:MakePopup()
	
	local y = 30
	
	// #########################
	// Key choice.
	// #########################
	local choosekey = vgui.Create( "DMultiChoice", options )
		choosekey:SetPos( 75, y )
		choosekey:SetWide( 110 )
		choosekey:SetTooltip( "The key that will open the achievements window.\nIf an invalid key is entered, it will default to F4." )
		choosekey:AddChoice( "F7" )
		choosekey:AddChoice( "F8" )
		choosekey:AddChoice( "F10" )
		choosekey:AddChoice( "F11" )
		choosekey:AddChoice( "F12" )
		choosekey:AddChoice( "G" )
		choosekey:AddChoice( "H" )
		choosekey:AddChoice( "B" )
	
		// H4X! Makes anything typed turn upper case.
		local te = choosekey.TextEntry
		te.OriginalKeyCodeTyped = te.OnKeyCodeTyped
		function te:OnKeyCodeTyped( val )
			self:OriginalKeyCodeTyped( val )
			timer.Simple( 0, function()
				self:SetValue( string.upper( self:GetValue() ) )
			end )
		end
		choosekey:SetConVar( "achievements_opentype" )
	
	choosekeyLabel = vgui.Create( "DLabel", options )
		choosekeyLabel:SetPos( 15, y )
		choosekeyLabel:SetSize( 55, choosekey:GetTall() )
		choosekeyLabel:SetText( "Open with:" )
	
	y = y + choosekey:GetTall() + 5
	
	// #########################
	// Chat message.
	// #########################
	local chatmessageLabel = vgui.Create( "DLabel", options )
		chatmessageLabel:SetPos( 15, y )
		chatmessageLabel:SetText( "Chat message:" )
		chatmessageLabel:SetWide( 170 )
	y = y + chatmessageLabel:GetTall()
		
	local chatmessage = vgui.Create( "DTextEntry", options )
		chatmessage:SetPos( 15, y )
		chatmessage:SetWide( 170 )
		chatmessage:SetConVar( "achievements_chatmessage_fix" )
		chatmessage:SetTooltip( "The message to broadcast when an achievement is gained.\n%achievement% will be replaced with the achievements name.\nLeave blank for no message." )
	y = y + chatmessage:GetTall() + 10
	
	// #########################
	// Effect.
	// #########################
	local effect = vgui.Create( "DCheckBoxLabel", options )
		effect:SetPos( 15, y )
		effect:SetWide( 170 )
		effect:SetText( "Confetti effect" )
		effect:SetConVar( "achievements_effect" )
	y = y + effect:GetTall() + 5
	
	// #########################
	// Autosave.
	// #########################
	local autosave = vgui.Create( "DCheckBoxLabel", options )
		autosave:SetPos( 15, y )
		autosave:SetWide( 170 )
		autosave:SetText( "Autosave" )
		autosave:SetConVar( "achievements_autosave" )
	y = y + autosave:GetTall() + 5

	// #########################
	// Close button.
	// #########################
	y = y + 5
	local close = vgui.Create( "DButton", options )
		close:SetPos( 15, y )
		close:SetWide( 170 )
		close:SetText( "Close" )
		close.DoClick = function() options:Remove() end
	y = y + close:GetTall() + 5
		
	// Make the window the right size, and in the right place.
	y = y + 5
	options:SetTall( y )
	options:Center()
end

include( "client/usermessage_hook.lua" )

surface.CreateFont( "Default", 12, 700, false, false, "Default12B" )
surface.CreateFont( "Default", 13, 700, false, false, "Default13B" )
surface.CreateFont( "Default", 14, 700, true, false, "Default14BA" )

// ##################################################
// Unlocked Popup
// ##################################################

local PANEL = {}
function PANEL:Init()
	self.Offset = 0
	self.Direction = 1
	self.Speed = 3
	self.Slot = 1
	self.Text = ""
	
	surface.PlaySound( Sound( "achievements/achievement_earned.mp3" ) )
end
function PANEL:SetAchievement( text, image )
	self.Text = text
	self.Image = image or "achievements/generic"
	
	self.Material = Material( self.Image )
	if ( !self.Material ) then self.Image = nil end
end
function PANEL:SetSlot( slot )
	self.Slot = slot
end
function PANEL:Think()
	self.Offset = math.Clamp( self.Offset + ( self.Direction * FrameTime() * self.Speed ), 0, 1 )
	self:InvalidateLayout()
	
	if ( self.Direction == 1 && self.Offset == 1 ) then
		self.Direction = 0
		self.Down = CurTime() + 5
	end
	if ( self.Down != nil && CurTime() > self.Down ) then
		self.Direction = -1
		self.Down = nil
	end
	if ( self.Offset == 0 ) then
		self.Removed = true
	end
end
function PANEL:PerformLayout()
	local w, h = 240, 94
	
	self:SetSize( w, h )
	self:SetPos( ScrW() - w, ScrH() - ( h * self.Offset * self.Slot ) )
end

function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	local a = self.Offset * 255
	
	surface.SetDrawColor( 47, 49, 45, a )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( 104, 106, 101, a )
	surface.DrawOutlinedRect( 0, 0, w, h )
	
	surface.SetDrawColor( 255, 255, 255, a )
	
	if ( self.Image ) then
		surface.SetMaterial( self.Material )
		surface.DrawTexturedRect( 14, 14, 64, 64 )
		
		surface.SetDrawColor( 70, 70, 70, a )
		surface.DrawOutlinedRect( 13, 13, 66, 66 )
	end
	
	draw.DrawText( "Achievement Unlocked!", "Default12B", 88, 30, Color( 255, 255, 255, a ), TEXT_ALIGN_LEFT )
	draw.DrawText( self.Text, "Default12B", 88, 46, Color( 216, 222, 211, a ), TEXT_ALIGN_LEFT )
	
end
vgui.Register( "rt_achievement_popup", PANEL )

// ##################################################
// Progress bar
// ##################################################

local function ToValues( col )
	if ( !col ) then return 255, 255, 255, 255 end
	return col.r, col.g, col.b, col.a
end

local PANEL = {}
function PANEL:Init()
	self.Percent = 0
	self.Foreground = Color( 255, 255, 255 )
end
function PANEL:SetColour( fore )
	self.Fore = fore
end
function PANEL:SetPercent( percent )
	while ( percent > 1 ) do percent = percent / 100 end
	self.Percent = percent
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	surface.SetDrawColor( 62, 62, 62, 255 )
	surface.DrawRect( 0, 0, w, h )
	
	surface.SetDrawColor( self.Fore.r, self.Fore.g, self.Fore.b, self.Fore.a )
	surface.DrawRect( 0, 0, w * self.Percent, h )
end
vgui.Register( "rt_achievement_progress", PANEL )

// ##################################################
// Total progress bar
// ##################################################

local PANEL = {}
function PANEL:Init()
	self.Text = "0/0"
	self.Percent = 100
	
	self.Bar = vgui.Create( "rt_achievement_progress", self )
		self.Bar:SetColour( Color( 158, 195, 79 ) )
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	self.Bar:SetPos( 8, h - 25 )
	self.Bar:SetSize( w - 16, 16 )
end
function PANEL:SetEarned( earned, total )	
	self.Text = earned .. "/" .. total
	
	if ( total > 0 ) then
		self.Percent = math.floor( ( earned / total ) * 100 )
	else
		self.Percent = 0
	end
	
	self.Bar:SetPercent( self.Percent / 100 )
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	surface.SetDrawColor( 26, 26, 26, 255 )
	surface.DrawRect( 0, 0, w, h )
	
	draw.SimpleText( "Achievements Earned:", "Default13B", 8, 7, Color( 217, 217, 217 ) ) 
	draw.SimpleText( self.Text .. " ( " .. self.Percent .. "% )", "Default13B", w - 10, 7, Color( 217, 217, 217 ), TEXT_ALIGN_RIGHT ) 
end
vgui.Register( "rt_achievement_progress_total", PANEL )

// ##################################################
// Achievement Info
// ##################################################
local PANEL = {}
function PANEL:Init()
	self.Name, self.Description, self.Image, self.Percent, self.PercentText = "", "", "", 1, ""
	
	self.LName = vgui.Create( "DLabel", self )
		self.LName:SetFont( "Default14BA" )
		self.LName:SetTextColor( Color( 158, 195, 79 ) )
		self.LName:SetPos( 71, 5 )
		
	self.LDesc = vgui.Create( "DLabel", self )
		self.LDesc:SetFont( "Default13B" )
		self.LDesc:SetTextColor( Color( 217, 217, 217 ) )
		self.LDesc:SetPos( 72, 22 )
	
	self.LPercent = vgui.Create( "DLabel", self )
		self.LPercent:SetFont( "Default13B" )
		self.LPercent:SetTextColor( Color( 210, 210, 210 ) )
	
	self.Bar = vgui.Create( "rt_achievement_progress", self )
	self.Bar:SetColour( Color( 201, 185, 149 ) )
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	self.Bar:SetPos( 70, h - 22 )
	self.Bar:SetSize( w - 200, 12 )
	
	self.LName:SetSize( w, 15 )
	self.LDesc:SetSize( w, 15 )
	
	self.LPercent:SetSize( w, 15 )
	self.LPercent:SetPos( self.Bar.X + self.Bar:GetWide() + 10, h - 24 )
end
function PANEL:Setup( name, desc, image, percent, percentText )
	self.Name, self.Description, self.Image, self.Percent, self.PercentText = name, desc, image or "", percent, percentText or ""
	self.Percent = math.Clamp( self.Percent, 0, 1 )
	
	self.LName:SetText( name )
	self.LDesc:SetText( desc )
	self.LPercent:SetText( percentText or "" )
	
	if ( self.Image != "" ) then
		self.Material = Material( self.Image )
	else
		self.Material = nil
	end
	
	self.Bar:SetVisible( percentText != "" )
	self.Bar:SetPercent( self.Percent )
end
function PANEL:Paint()
	local w, h = self:GetWide(), self:GetTall()
	
	if ( self.Percent == 1 ) then
		draw.RoundedBox( 4, 0, 0, w, h, Color( 78, 78, 78 ) )
	else
		draw.RoundedBox( 4, 0, 0, w, h, Color( 56, 56, 56 ) )
	end
	
	if ( !self.Material ) then return end
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.Material )
	surface.DrawTexturedRect( 4, 4, 56, 56 )
end
vgui.Register( "rt_achievement_info", PANEL )

// ##################################################
// Main Window
// ##################################################

local PANEL = {}
function PANEL:Init()
	self:SetTitle( "Achievement's by [LDT] FRAG" )
	self:MakePopup()
	self:SetVisible( false )
	self:SetDeleteOnClose( false )
	
	self.Bar = vgui.Create( "rt_achievement_progress_total", self )
	self.List = vgui.Create( "DPanelList", self )
	self.List:EnableVerticalScrollbar()
	self.List:SetPadding( 4 )
	self.List:SetSpacing( 4 )
	
	self.CloseB = vgui.Create( "DButton", self )
	self.CloseB:SetText( "Close" )
	self.CloseB.DoClick = function() self:SetVisible( false ) end
	
	self.Options = vgui.Create( "DButton", self )
	self.Options:SetText( "Options" )
	self.Options.DoClick = function() Options( self ) end
	
	self:SetSize( math.floor( ScrW() * 0.6 ), math.floor( ScrH() * 0.6 ) )
	self:Center()
	
	self.CCAchievements = {}
end
function PANEL:PerformLayout()
	local w, h = self:GetWide(), self:GetTall()
	
	self.Bar:SetPos( 15, 40 )
	self.Bar:SetSize( w - 30, 50 )
	
	self.List:SetPos( 15, 100 )
	self.List:SetSize( w - 30, h - 140 )
	
	self.Options:SetPos( 15, h - 34 )
	self.Options:SetSize( 70, 24 )
	
	self.CloseB:SetPos( w - 85, h - 34 )
	self.CloseB:SetSize( 70, 24 )
	
	for _, ach in pairs( self.CCAchievements or {} ) do
		ach.Panel:SetSize( self.List:GetWide() - 18, 64 )
	end
	self.List:InvalidateLayout()
	
	self.BaseClass.PerformLayout( self )
end
function PANEL:CCSortAchievements()
	local tab = {}
	for name, _ in pairs( self.CCAchievements ) do
		tab[ #tab + 1 ] = name
	end
	table.sort( tab )
	
	self.List:Clear()
	for _, name in pairs( tab ) do
		local info = self.CCAchievements[ name ]
		if ( info && info.Panel ) then
			self.List:AddItem( info.Panel )
		end
	end
	self:InvalidateLayout()
end
function PANEL:CCSetupAchievement( name, desc, image, percent, percentText )
	percent = math.Clamp( percent, 0, 1 )
	
	local panel
	if ( self.CCAchievements[ name ] == nil ) then
		panel = vgui.Create( "rt_achievement_info", self )
			self.List:AddItem( panel )
		self:InvalidateLayout()
	else
		panel = self.CCAchievements[ name ].Panel
	end
	self.CCAchievements[ name ] = { Desc = desc, Image = image, Percent = percent, Panel = panel, Unlocked = percent == 1 }
	
	self:CCUpdateAchievement( name, percent, percentText )
end
function PANEL:CCUpdateAchievement( name, percent, percentText )
	if ( self.CCAchievements[ name ] == nil ) then return false end
	
	local ach = self.CCAchievements[ name ]
	ach.Percent = percent
	ach.Panel:Setup( name, ach.Desc, ach.Image, percent, percentText )
	
	if ( !ach.Unlocked && percent >= 1 ) then
		local ply = LocalPlayer()
		
		if not ply.NewAchEarned then
			ply.NewAchEarned = {}
		end
		table.insert(ply.NewAchEarned, {name,ach} )
		
		RunConsoleCommand("achivements_achieved", tostring(name))
		
		//Can't open two datastreams with one name, hax way around
		if not ply.AchNum or ply.AchNum > 10 then
			ply.AchNum = 1
		end
		datastream.StreamToServer("AchivementsAchData_" .. tostring(ply.AchNum), {ply,name})
		ply.AchNum = ply.AchNum+1
		
		ach.Unlocked = true
	end
	
	local total = 0
	for _, ach in pairs( self.CCAchievements ) do
		if ( ach.Percent == 1 ) then total = total + 1 end
	end
	self.Bar:SetEarned( total, table.Count( self.CCAchievements ) )
	
	self.CCTotalAchievements = table.Count( self.CCAchievements )
end
vgui.Register( "rt_achievements", PANEL, "DFrame" )


// ##################################################
// END OF VGUI
// ##################################################

local function Initialize()
	local menu = vgui.Create( "rt_achievements" )

	CCachievements = {}
	function CCachievements.Register( name, desc, image, percent, percentText )
		menu:CCSetupAchievement( name, desc, image, percent, percentText )
	end
	function CCachievements.GetNumber()
		return ( menu.CCTotalAchievements or 0 )
	end
	function CCachievements.IsGamemode( name )
		local gm = gmod.GetGamemode()
		if ( !gm ) then gm = GAMEMODE end
		
		if ( string.find( gm.Name or "", name ) ) then
			return true
		end
		
		return false
	end
	
	CreateConVar( "achievements_chatmessage_fix", "I have earned the '%achievement%' achievement!", FCVAR_ARCHIVE )
	--CreateConVar( "achievements_chatmessage_fix", "evs ach '%achievement%'", FCVAR_ARCHIVE )
	CreateConVar( "achievements_effect", 1, FCVAR_ARCHIVE )
	function CCachievements.Update( name, percent, percentText )
		menu:CCUpdateAchievement( name, percent, percentText )
	end
	function CCachievements.Sort()
		menu:CCSortAchievements()
	end
	function CCachievements.FormatTime( time, format )
		local gah = { { "h", 3600 }, { "m", 60 }, { "s", 1 } }
		for _, t in pairs( gah ) do
			local amount = math.floor( time / t[ 2 ] )
			format = string.Replace( format, t[ 1 ], string.rep( "0", 2 - string.len( amount ) ) .. amount )
			time = time % t[ 2 ]
		end
		return format
	end
	
	// Create the table for saving values in.
	if ( !sql.TableExists( "CCachievements" ) ) then
		sql.Query( "CREATE TABLE IF NOT EXISTS CCachievements ( infoid TEXT NOT NULL PRIMARY KEY, value TEXT );" )
	end
	
	CCachievements.Loaded = {}
	CCachievements.ToSave = {}
	function CCachievements.SetValue( achievement, name, value )
		if ( !CCachievements.FinishedLoading ) then return end
		local name = achievement .. "." .. name
		
		CCachievements.Loaded[ name ] = value
		CCachievements.ToSave[ name ] = value
	end
	function CCachievements.GetValue( achievement, name, default )		
		local name = achievement .. "." .. name
		
		if ( CCachievements.Loaded[ name ] == nil ) then
			local val = sql.QueryValue( "SELECT value FROM CCachievements WHERE infoid = " .. SQLStr( name ) )
			if ( val == nil ) then
				val = default
			elseif ( tonumber( val ) != nil ) then
				val = tonumber( val )
			end
		
			CCachievements.Loaded[ name ] = val
			return val
		else
			return CCachievements.Loaded[ name ]
		end
	end
	
	CreateConVar( "achievements_autosave", 1 )
	function CCachievements.SaveValues( autosave )
		if ( autosave == true ) then
			if ( GetConVarNumber( "achievements_autosave" ) <= 0 ) then return end
		end
		
		print( "[LDT ACHIEVEMENTS] Saving achievements..." )
		sql.Begin()
		for name, value in pairs( CCachievements.ToSave ) do
			sql.Query( "DELETE FROM CCachievements WHERE infoid = " .. SQLStr( name ) )
			sql.Query( "INSERT INTO CCachievements ( infoid, value ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( value ) .. " )" )
		end
		sql.Commit()
	end
	concommand.Add( "achievements_save", CCachievements.SaveValues )
	timer.Create( "achievements.SaveValues", 300, 0, CCachievements.SaveValues, true )
	hook.Add( "ShutDown", "Achievements.SaveValues", CCachievements.SaveValues )
	
	local chatOpen = false
	hook.Add( "StartChat", "Achievements.StartChat", function() chatOpen = true end )
	hook.Add( "FinishChat", "Achievements.FinishChat", function() chatOpen = false end )
	
	// F9 bind. WILL BE SCRAPPED ON PS INTERGRATION
	CreateConVar( "achievements_opentype", "F9", FCVAR_ARCHIVE )
	local function CheckKeys()
		if ( menu:IsVisible() ) then return end
		
		// If the chat's open we don't want anything triggering when we type.
		if ( chatOpen ) then
			if ( CCachievements.KEY && ( CCachievements.KEY < KEY_F1 || CCachievements.KEY > KEY_F12 ) ) then return end
		end
		
		RunString( "CCachievements.KEY = KEY_" .. string.upper( GetConVarString( "achievements_opentype" ) ) )
		if ( input.IsKeyDown( CCachievements.KEY or KEY_F7 ) ) then
			RunConsoleCommand( "CCachievements" )
			return
		end
	end
	timer.Create( "Achievements.CheckKeys", 0.1, 0, CheckKeys )
	
	CreateConVar( "achievements_updatenag", 1, FCVAR_ARCHIVE )
	local checkedForUpdate = false
	local function ShowMenu()
		if ( !checkedForUpdate && GetConVarNumber( "achievements_updatenag" ) > 0 ) then
			// Check if it's time to nag about version again...
			local day = os.date( "%j" )
			local lastNagged = file.Read( "achievements/updatenag.txt" ) or ""
			if ( lastNagged != day ) then
				file.Write( "achievements/updatenag.txt", day )
			end
			checkedForUpdate = true
		end
		
		menu:InvalidateLayout()
		menu:SetVisible( true )
	end
	concommand.Add( "CCachievements", ShowMenu )
	
	local function Reload()
		CCachievements.SaveValues()
		if ( menu ) then menu:Remove() end
		
		print( "[LDT ACHIEVEMENTS]Reloading achievements..." )
		include( "autorun/achievements.lua" )
	end
	concommand.Add( "achievements_reload", Reload )
	
	local key
	local function Reset( _, _, args )
		if ( !key ) then
			key = ""
			for _ = 1, 6 do
				key = key .. string.char( math.random( 97, 122 ) )
			end
			print( "Are you sure?\nEnter 'achievements_reset " .. key .. "' to confirm." )
		elseif ( ( args[ 1 ] or "" ) == key ) then
			print( "[LDT ACHIEVEMENTS]Resetting achievements..." )
			sql.Query( "DROP TABLE CCachievements" )
			sql.Query( "INSERT INTO CCachievements ( infoid, value ) VALUES ( " .. SQLStr( "LDTAchVer" ) .. ", " .. SQLStr( VERSION ) .. " )" )
			Reload()
			key = nil
		else
			print( "Incorrect key. Please try again." )
			key = nil
		end
	end
	concommand.Add( "achievements_reset", Reset )
	
	local function CheckVersion()
		local ply = LocalPlayer()
		local PrevVer = sql.QueryValue( "SELECT value FROM CCachievements WHERE infoid = " .. SQLStr( "LDTAchVer" ) )
		
		if ( (PrevVer == nil) or ( tonumber(PrevVer) < VERSION) ) then
			print("[LDT ACHIEVEMENTS] Previous Version is INVALID! ( Version: "..tostring(PrevVer).." )")
			
			timer.Simple(0,function()
				sql.Query( "DROP TABLE CCachievements" )
				Reload()
				
				sql.Begin()
				  sql.Query( "DELETE FROM CCachievements WHERE infoid = " .. SQLStr( "LDTAchVer" ) )
				  sql.Query( "INSERT INTO CCachievements ( infoid, value ) VALUES ( " .. SQLStr( "LDTAchVer" ) .. ", " .. SQLStr( VERSION ) .. " )" )
				sql.Commit()
				end)
		else
			print("[LDT ACHIEVEMENTS] Previous Version is valid. ( Version: "..tostring(PrevVer).." )")
		end
	end
	concommand.Add( "achievements_checkversion", CheckVersion )
	
	local function DelVersion()
		sql.Query( "DELETE FROM CCachievements WHERE infoid = " .. SQLStr( "LDTAchVer" ) )
	end
	//Uncomment for testing purposes:
	//concommand.Add( "delversion", DelVersion )
	
	if ( !file.Exists( "achievements/convertedtosqlite.txt" ) ) then
		include( "text_to_sqlite.lua" )
		file.Write( "achievements/convertedtosqlite.txt", "1" )
	end
	
	// Include all the achievement files.
	local files = file.FindInLua( "achievements/*.lua" )
	table.sort( files ) // We do this so they stay in the same order.
	
	print( "[LDT ACHIEVEMENTS]Loading achievements..." )
	
	local delay, n = 0.05, 0
	for i, ach in ipairs( files ) do
		timer.Simple( i * delay, include, "achievements/" .. ach ) 
		n = i
	end
	timer.Simple( n * delay, function()
		print( "Completed " .. CCachievements.GetNumber() .. " LDT achievements loaded!" )
		CCachievements.Sort()
		CCachievements.FinishedLoading = true
	end )
	
end
hook.Add( "Initialize", "Achievements.Initialize", Initialize )

// We've already loaded before.
if ( CCachievements ) then Initialize() end

timer.Simple(1,function() RunConsoleCommand("achievements_checkversion") end)

function Achievements_PopUp()
	local ply = LocalPlayer()
	
	if not ply.NewAchEarned then return end
	
	for _,ach in pairs(ply.NewAchEarned) do
		local popup = vgui.Create( "rt_achievement_popup" )
			popup:SetAchievement( ach[1], ach[2].Image )
	end
	ply.NewAchEarned = nil
end