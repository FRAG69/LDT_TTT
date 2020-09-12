
// *************************************
// * ACHIEVEMENTS Module - by thomasfn *
// *************************************

// V1.0.0
// (G) = Global
// (S) = Shared
// (SV) = Serverside
// (CL) = Clientside

// Require stuff
require( "datastream" )
require( "glon" )

// Achievement enums
ACHIEVEMENT_ONEOFF = 1
ACHIEVEMENT_PROGRESS = 2

// Define the module
module( "achievements", package.seeall )

// VARIABLES
local debugmode = false
local categories = {
	[ "#all" ] = {},
	[ "#gamemode" ] = {},
	[ "#misc" ] = {}
}

local bases = {}
local BASE = {
	Type = ACHIEVEMENT_ONEOFF,
	Description = "Base achievement.",
	Image = "gui/silkicons/page",
	Target = 0
}

// ----------------------------------------------------------------------------------------------------------------
// (G)(S) msg: Prints an achievements related message to console
// ----------------------------------------------------------------------------------------------------------------
local function msg( text, dbg )
	if (!dbg || debugmode) then
		Msg( "ACHIEVEMENTS: " .. text .. "\n" )
	end
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(S) EnableDebugMode: Enables/disables debug mode
// ----------------------------------------------------------------------------------------------------------------
function EnableDebugMode( b )
	debugmode = b
	if (b) then msg( "Debug mode enabled!" ) else msg( "Debug mode disabled!" ) end
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(S) CreateCategory: Creates a new category in which to define achievements
// ----------------------------------------------------------------------------------------------------------------
function CreateCategory( catname )
	categories[ catname ] = {}
	msg( "Registered category '" .. catname .. "'!" )
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(S) GetCategoryList: Returns the category list
// ----------------------------------------------------------------------------------------------------------------
function GetCategoryList()
	return categories
end

// ----------------------------------------------------------------------------------------------------------------
// (S) TransformCatName: Returns the 'nice' name of a category
// ----------------------------------------------------------------------------------------------------------------
local function TransformCatName( catname )
	if (catname == "#all") then return "All" end
	if (catname == "#gamemode") then return _G.GAMEMODE.Name or "Gamemode" end
	if (catname == "#misc") then return "Uncategorised" end
	return catname
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(SV) LoadData: Loads the player's datafile
// ----------------------------------------------------------------------------------------------------------------
function LoadData( ply )
	if (CLIENT) then return end
	ply:LoadAData()
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(SV) SaveData: Saves the player's datafile
// ----------------------------------------------------------------------------------------------------------------
function SaveData( ply )
	if (CLIENT) then return end
	ply:SaveAData()
end

// ----------------------------------------------------------------------------------------------------------------
// (SV) GetProgress: Returns the current progress of an achievement
// ----------------------------------------------------------------------------------------------------------------
local function GetProgress( aname, ply )
	local base = bases[ aname ]
	if (!base) then return 0 end
	if (!base.GetProgress) then return 0 end
	base.Data = ply:GetAData()
	local prog = base:GetProgress( ply ) or 0
	base.Data = nil
	return prog
end

// ----------------------------------------------------------------------------------------------------------------
// (S) GetBase: Returns the achievement class
// ----------------------------------------------------------------------------------------------------------------
local function GetBase( bs )
	return bases[ bs or "" ] or BASE
end

// ----------------------------------------------------------------------------------------------------------------
// (SV) RequestAchievements: Sends the achievement data to the client
// ----------------------------------------------------------------------------------------------------------------
local function RequestAchievements( ply )
	local dat = {}
	for catname, alist in pairs( categories ) do
		dat[ catname ] = {}
		for _, aname in pairs( alist ) do
			dat[ catname ][ aname ] = GetProgress( aname, ply )
		end
	end
	datastream.StreamToClients( ply, "ach_data", dat )
end
if (SERVER) then concommand.Add( "ach_get", RequestAchievements ) end

function AchMenu( ply )
    umsg.Start( "RequestAchievements", ply ) 
    umsg.End()
end 
hook.Add("ShowSpare2", "AchHook", RequestAchievements)

// ----------------------------------------------------------------------------------------------------------------
// (G)(S) Register: Registers a new achievement (on the client, the last 2 parameters are not used)
// ----------------------------------------------------------------------------------------------------------------
function Register( category, name, tbl, base )
	if (!categories[ category ]) then
		msg( "Failed to register achievement '" .. name .. "'! (Invalid category)" )
		return
	end
	local o = {}
	table.Merge( o, GetBase( base ) )
	table.Merge( o, tbl )
	o.Name = name
	o.Category = category
	o.Base = base
	if (SERVER) then
		if (o.Init) then o:Init() end
	end
	bases[ name ] = o
	table.insert( categories[ category ], name )
	table.insert( categories[ "#all" ], name )
	msg( "Registered achievement '" .. name .. "'!" )
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(SV) Call: Calls a function on all achievements
// ----------------------------------------------------------------------------------------------------------------
function Call( ply, hookname, ... )
	if (CLIENT) then return end
	for aname, bs in pairs( bases ) do
		if (bs:CanUse( ply )) then
			if (bs[ hookname ]) then bs[ hookname ]( bs, ply, ... ) end
		end
	end
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(SV) CustomCall: Calls a custom hook function on all achievements
// ----------------------------------------------------------------------------------------------------------------
function CustomCall( hookname, ... )
	if (CLIENT) then return end
	for aname, bs in pairs( bases ) do
		if (bs[ hookname ]) then bs[ hookname ]( bs, ... ) end
	end
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(SV) Award: Gives the player the achievement, regardless of current progress/state
// ----------------------------------------------------------------------------------------------------------------
function Award( ply, aname )
	if (CLIENT) then return end
	local dat = ply:GetAData()
	local bs = bases[ aname or "" ]
	if (!bs) then return end
	bs.Data = dat
	bs:SetProgress( ply, 100 )
	bs.Data = nil
end

// ----------------------------------------------------------------------------------------------------------------
// (G)(SV) AddCustomHook: Adds a custom hook to the system
// ----------------------------------------------------------------------------------------------------------------
function AddCustomHook( hookname )
	if (CLIENT) then return end
	hook.Add( hookname, "ACH_" .. hookname, function( ... )
		CustomCall( hookname, ... )
	end )
end

if (SERVER) then

	// ----------------------------------------------------------------------------------------------------------------
	// (G)(SV) META: Extension of the player meta table
	// ----------------------------------------------------------------------------------------------------------------
	local meta = _R.Player
	function meta:GetADataFilename()
		return "achievements/" .. string.Replace( self:SteamID(), ":", "" ) .. ".txt"
	end
	function meta:LoadAData()
		local fn = self:GetADataFilename()
		local dat = {}
		if (file.Exists( fn )) then
			local b, res = pcall( glon.decode, file.Read(fname, true) )
			if (b && (type( res ) == "table")) then
				table.Merge( dat, res )
				msg( "Loaded player data! (" .. self:Nick() .. ")", true )
			else
				ErrorNoHalt( "ACH: Corrupt or invalid save data file! (" .. self:Nick() .. ")\n" )
			end
		end
		self.A_DATA = dat
	end
	function meta:SaveAData()
		local fn = self:GetADataFilename()
		local dat = self:GetAData()
		local b, res = pcall( glon.encode, dat )
		if (b && (type( res ) == "string")) then
			file.Write( fname, res )
			Msg( "Saved player data! (" .. self:Nick() .. ")\n" )
		else
			ErrorNoHalt( "ACH: Failed to write player data file! (" .. self:Nick() .. ")\n" )
		end
	end
	function meta:GetAData()
		if (!self.A_DATA) then self:LoadAData() end
		return self.A_DATA
	end

	// ----------------------------------------------------------------------------------------------------------------
	// ach_testgive: Gives the player the achievement (DEBUGGING COMMAND)
	// ----------------------------------------------------------------------------------------------------------------
	concommand.Add( "ach_testgive", function( pl, com, args )
		if (!pl:IsSuperAdmin()) then return end
		if (!debugmode) then return end
		Award( pl, table.concat( args, " " ) )
	end )
	
	// ----------------------------------------------------------------------------------------------------------------
	// ach_saveall: Saves everyone's achievement progress (DEBUGGING COMMAND)
	// ----------------------------------------------------------------------------------------------------------------
	concommand.Add( "ach_saveall", function( pl, com, args )
		if (!pl:IsSuperAdmin()) then return end
		if (!debugmode) then return end
		for _, ply in pairs( player.GetAll() ) do
			ply:SaveAData()
		end
	end )
	
	// ----------------------------------------------------------------------------------------------------------------
	// ach_loadall: Saves everyone's achievement progress (DEBUGGING COMMAND)
	// ----------------------------------------------------------------------------------------------------------------
	concommand.Add( "ach_loadall", function( pl, com, args )
		if (!pl:IsSuperAdmin()) then return end
		if (!debugmode) then return end
		for _, ply in pairs( player.GetAll() ) do
			ply:LoadAData()
		end
	end )
	
	// ----------------------------------------------------------------------------------------------------------------
	// Hook in all gamemode hooks to the achievement hooks
	// ----------------------------------------------------------------------------------------------------------------
	hook.Add( "PlayerSpawn", "ACH_PlayerSpawn", function( pl ) Call( pl, "OnSpawn" ) end )
	hook.Add( "PlayerDeath", "ACH_PlayerDeath", function( pl ) Call( pl, "OnDeath" ) end )
	hook.Add( "OnNPCKilled", "ACH_NPCKilled", function( victim, killer, wep )
		if (killer:IsValid() && killer:IsPlayer()) then
			Call( killer, "OnKilledNPC", victim )
		end
	end )
	hook.Add( "PlayerHurt", "ACH_PlayerHurt", function( pl, attacker, dmg )
		Call( pl, "OnTakeDamage", attacker, dmg )
		if (attacker:IsPlayer()) then
			Call( attacker, "OnDealDamage", pl, dmg )
		end
	end )
	hook.Add( "Move", "ACH_PlayerMove", function( pl ) Call( pl, "OnMove" ) end )

	// ----------------------------------------------------------------------------------------------------------------
	// Define the base achievment class
	// ----------------------------------------------------------------------------------------------------------------
	function BASE:CanUse( ply )
		return self:GetProgress( ply ) < 100
	end

	function BASE:SetProgress( ply, perc )
		local cprog = self:GetProgress( ply )
		if (cprog >= 100) then return end
		if (perc >= 100) then self:Earnt( ply ) end
		ply:GetAData()[ self.Name ] = perc
		ply:SaveAData()
	end
	function BASE:GetProgress( ply )
		return ply:GetAData()[ self.Name ] or 0
	end
	function BASE:AwardPoint( ply, pt )
		pt = pt or 1
		local t = self.Target
		if ((!t) || (t == 0)) then return end
		local pts = (self:GetProgress( ply ) / 100) * t
		self:SetProgress( ply, ((pts+pt)/t)*100 )
	end
	function BASE:Earnt( ply )
		umsg.Start( "ach_earnt", ply )
			umsg.String( self.Name )
		umsg.End()
		PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has earnt the achievement '" .. self.Name .. "'!" )
	end
	function BASE:Award( ply )
		self:SetProgress( ply, 100 )
	end

end

if (CLIENT) then

	local acol = Color( 180, 240, 0 )
	local white = Color( 255, 255, 255 )
	local win, gained, CAT
	local showachieved = true

	// ----------------------------------------------------------------------------------------------------------------
	//  BuildCategory: Fills the gui with the achievements inside the category
	// ----------------------------------------------------------------------------------------------------------------
	local function BuildCategory( aspace, progbar, proglbl, cat, showach )
		cat = cat or CAT
		CAT = cat
		aspace:Clear()
		local cnt = 0
		for name, prog in SortedPairs( cat ) do
			local bs = bases[ name ]
			if (bs) then
				if ((prog < 100) || showach) then
					local a = vgui.Create( "ACH_Box" )
					a:Setup( name, prog )
					aspace:AddItem( a )
				end
				if (prog >= 100) then cnt = cnt + 1 end
			end
		end
		local tot = table.Count( cat )
		local pc = (cnt / tot)*100
		progbar.PROG = pc
		local txt = "Personal Achievements Earned: " .. tostring( cnt ) .. " of " .. tostring( tot )
		if (tot > 0) then txt = txt .. " (" .. tostring( math.Round( pc ) ) .. "%)" end
		proglbl:SetText( txt )
	end
	
	// ----------------------------------------------------------------------------------------------------------------
	//  BuildWindow: Builds the achievements window
	// ----------------------------------------------------------------------------------------------------------------
	local function BuildWindow( data )
		if (win) then
			win:Remove()
			win = nil
		end
		
		win = vgui.Create( "DFrame" )
		win:SetPos( ScrW()*0.1, ScrH()*0.2 )
		win:SetSize( ScrW()*0.8, ScrH()*0.6 )
		win:SetTitle( "LDT Achievements V2" )
		win:SetDraggable( true )
		win:ShowCloseButton( true )
		
		local sel = vgui.Create( "DMultiChoice", win )
		sel:SetPos( 5, 30 )
		sel:SetSize( win:GetWide()-10, 20 )
		sel:SetEditable( false )
		local fc = true
		for catname, alist in pairs( categories ) do
			local text = TransformCatName( catname ) .. " (" .. tostring( #alist ) .. ")"
			sel:AddChoice( text, { catname, data[ catname ] or {} } )
			if (fc) then
				sel:ChooseOption( text, 1 )
				fc = false
			end
		end
		
		local proglbl = vgui.Create( "DLabel", win )
		proglbl:SetPos( 5, 55 )
		proglbl:SetSize( win:GetWide()-10, 20 )
		
		local showach = vgui.Create( "DCheckBoxLabel", win )
		showach:SetText( "Show Achieved" )
		showach:SetValue( showachieved )
		showach:SizeToContents()
		showach:SetPos( win:GetWide()-showach:GetWide()-5, 55 )
		
		local progbar = vgui.Create( "DPanel", win )
		progbar:SetPos( 5, 75 )
		progbar:SetSize( win:GetWide()-10, 20 )
		progbar.PROG = 0
		progbar.COL = acol
		progbar.BGCOL = Color( 70, 70, 70 )
		function progbar:Paint()
			surface.SetDrawColor( self.BGCOL )
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
			surface.SetDrawColor( self.COL )
			surface.DrawRect( 0, 0, self:GetWide() * self.PROG * 0.01, self:GetTall() )
		end
		
		local aspace = vgui.Create( "DPanelList", win )
		aspace:SetPos( 5, 100 )
		aspace:SetSize( win:GetWide()-10, win:GetTall()-105 )
		aspace:SetSpacing( 5 )
		aspace:SetPadding( 5 )
		aspace:EnableVerticalScrollbar( true )
		
		function sel:OnSelect( index, value, dat )
			BuildCategory( aspace, progbar, proglbl, dat[2], showach:GetChecked() )
		end
		
		function showach:OnChange()
			BuildCategory( aspace, progbar, proglbl, nil, showach:GetChecked() )
			showachieved = showach:GetChecked()
		end
		
		win:MakePopup()
		
		BuildCategory( aspace, progbar, proglbl, data[ "#all" ], showach:GetChecked() )
	end

	// ----------------------------------------------------------------------------------------------------------------
	//  DataRecieved: Forwards achievement stats to the gui
	// ----------------------------------------------------------------------------------------------------------------
	local function DataRecieved( id, handler, encoded, decoded )
		if (debugmode) then PrintTable( decoded ) end
		BuildWindow( decoded )
	end
	datastream.Hook( "ach_data", DataRecieved )
	
	// ----------------------------------------------------------------------------------------------------------------
	//  AchGained: Creates the achievement gained popup upon server notification
	// ----------------------------------------------------------------------------------------------------------------
	local function AchGained( um )
		if (gained) then
			gained:Remove()
			gained = nil
		end
		gained = vgui.Create( "ACH_Gained" )
		gained:Setup( um:ReadString() )
	end
	usermessage.Hook( "ach_earnt", AchGained )

	local black = Color( 0, 0, 0 )
	
	// ----------------------------------------------------------------------------------------------------------------
	// (VGUI) DLabel2: A label with an option to change font
	// ----------------------------------------------------------------------------------------------------------------
	local PANEL = {}
	function PANEL:SetText( txt )
		self.TEXT = txt
	end
	function PANEL:SetColor( col )
		self.COL = col
	end
	function PANEL:SetFont( fnt )
		self.FONT = fnt
	end
	function PANEL:Paint()
		self.TEXT = self.TEXT or "Label"
		self.COL = self.COL or black
		self.FONT = self.FONT or "default"
		draw.SimpleText( self.TEXT, self.FONT, 0, 0, self.COL, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	function PANEL:SizeToContents()
		surface.SetFont( self.FONT or "default" )
		local tw, th = surface.GetTextSize( self.TEXT or "Label" )
		self:SetSize( tw, th )
	end
	vgui.Register( "DLabel2", PANEL, "PANEL" )

	// ----------------------------------------------------------------------------------------------------------------
	// (VGUI) ACH_Box: A row showing achievement status
	// ----------------------------------------------------------------------------------------------------------------
	local PANEL = {}
	PANEL.ForceHeight = 65
	function PANEL:Setup( aname, prog )
		local bs = bases[ aname ]
		if (!bs) then return end
		local img = vgui.Create( "DImage", self )
		img:SetImage( bs.Image )
		self.IMG = img
		local ttl = vgui.Create( "DLabel2", self )
		ttl:SetText( bs.Name )
		ttl:SetFont( "ScoreboardSub" )
		self.TITLE = ttl
		local desc = vgui.Create( "DLabel", self )
		desc:SetText( bs.Description )
		self.DESC = desc
		local pro = vgui.Create( "DLabel", self )
		self.PRO = pro
		if (bs.Type == ACHIEVEMENT_PROGRESS) then			
			local probar = vgui.Create( "DPanel", self )
			function probar:Paint()
				local perc = (self.PERC or 0)/100
				surface.SetDrawColor( white )
				local w = self:GetWide()
				local h = self:GetTall()
				surface.DrawLine( 0, 0, w-1, 0 )
				surface.DrawLine( 0, h-1, w-1, h-1 )
				surface.DrawLine( 0, 0, 0, h-1 )
				surface.DrawLine( w-1, 0, w-1, h-1 )
				surface.DrawRect( 0, 0, w*perc, h )
			end
			self.PROBAR = probar
		end
		if (prog >= 100) then
			self.BGCOL = Color( 128, 128, 128 )
			self.TITLE:SetColor( acol )
			self.DESC:SetColor( Color( 255, 255, 255 ) )			
			self.PRO:SetColor( Color( 255, 255, 255 ) )
			if (bs.Type == ACHIEVEMENT_PROGRESS) then
				local t = tostring( bs.Target or prog )
				self.PRO:SetText( t .. " of " .. t )
				self.PROBAR.PERC = 100
			else
				self.PRO:SetText( "ATTAINED" )
			end
		else
			self.BGCOL = Color( 60, 60, 60 )
			self.TITLE:SetColor( acol )
			self.DESC:SetColor( Color( 255, 255, 255 ) )
			self.PRO:SetColor( Color( 255, 255, 255 ) )
			if (bs.Type == ACHIEVEMENT_PROGRESS) then
				self.PRO:SetText( tostring( (prog/100)*(bs.Target or 100) ) .. " of " .. tostring( bs.Target or 100 ) )
				self.PROBAR.PERC = prog
			else
				self.PRO:SetText( "Unattained" )
			end
		end
		self.TYPE = bs.Type or ACHIEVEMENT_PROGRESS
		self.PROG = prog or 0
	end
	function PANEL:PerformLayout()
		self:SetTall( self.ForceHeight )
		self.IMG:SetPos( 5, 5 )
		self.IMG:SetSize( self.ForceHeight-10, self.ForceHeight-10 )
		self.TITLE:SetPos( self.ForceHeight, 5 )
		self.TITLE:SizeToContents()
		self.DESC:SetPos( self.ForceHeight, 25 )
		self.DESC:SizeToContents()
		if (self.TYPE == ACHIEVEMENT_ONEOFF) then
			self.PRO:SetPos( self.ForceHeight, 40 )
			self.PRO:SizeToContents()
		else
			self.PRO:SizeToContents()
			self.PRO:SetPos( self:GetWide() - self.PRO:GetWide() - 5, 40 )
			if (self.PROBAR) then
				self.PROBAR:SetPos( self.ForceHeight, 40 )
				self.PROBAR:SetSize( self:GetWide() - self.PRO:GetWide() - 10 - self.ForceHeight, 20 )
			end
		end
	end
	function PANEL:Paint()
		local w = self:GetWide()
		local h = self:GetTall()
		draw.RoundedBox( 6, 0, 0, w, h, self.BGCOL )
	end
	vgui.Register( "ACH_Box", PANEL, "PANEL" )
	
	// ----------------------------------------------------------------------------------------------------------------
	// (VGUI) ACH_Gained: A small popup that shows when an achievement has been unlocked
	// ----------------------------------------------------------------------------------------------------------------
	local PANEL = {}
	PANEL.W = 0.25
	PANEL.H = 0.12
	PANEL.BG = Color( 20, 20, 20 )
	PANEL.BOR = Color( 80, 80, 80 )
	PANEL.TXTCOL_A = Color( 255, 255, 255 )
	PANEL.TXTCOL_B = Color( 180, 240, 0 )
	function PANEL:Setup( aname )
		local bs = bases[ aname ]
		if (!bs) then
			self:Remove()
			gained = nil
			return
		end
		self.NAME = bs.Name
		self.State = 0
		self.StTime = 1
		self.StEnd = CurTime()+self.StTime
		self.StStart = CurTime()
		self.A = 0
	end
	function PANEL:Paint()
		if (self.State == 0) then self.A = math.Clamp( 255 - (255 * ((self.StEnd-CurTime())/self.StTime)), 0, 255 ) end
		if (self.State == 1) then self.A = 255 end
		if (self.State == 2) then self.A = math.Clamp( 255 * ((self.StEnd-CurTime())/self.StTime), 0, 255 ) end
		surface.SetDrawColor( self.BG.r, self.BG.g, self.BG.b, self.A )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		surface.SetDrawColor( self.BOR.r, self.BOR.g, self.BOR.b, self.A )
		surface.DrawLine( 0, 0, self:GetWide(), 0 )
		surface.DrawLine( 0, 0, 0, self:GetTall() )
		self.TXTCOL_A.a = self.A
		self.TXTCOL_B.a = self.A
		draw.SimpleText( self.NAME or "", "ScoreboardSub", self:GetWide()*0.5, 5, self.TXTCOL_B, 1, TEXT_ALIGN_TOP )
		draw.SimpleText( "Achievement Unlocked", "ScoreboardText", self:GetWide()*0.5, self:GetTall()*0.5, self.TXTCOL_A, 1, TEXT_ALIGN_TOP )
		if (CurTime() >= self.StEnd) then
			self.State = self.State + 1
			self.StStart = CurTime()
			if (self.State == 1) then self.StTime = 4 end
			if (self.State == 2) then self.StTime = 1 end
			if (self.State == 3) then
				self:Remove()
				gained = nil
				return
			end
			self.StEnd = CurTime() + self.StTime
		end
	end
	function PANEL:PerformLayout()
		self:SetSize( self.W*ScrW(), self.H*ScrH() )
		self:SetPos( ScrW()-(self.W*ScrW()), ScrH()-(self.H*ScrH()) )
	end
	vgui.Register( "ACH_Gained", PANEL, "PANEL" )

end
