VIEW = {}

VIEW.ParentFrame = nil
VIEW.TabList = nil
VIEW.Categories = {}

surface.CreateFont( "fontclose", { font = "Cabin", size = 14, weight = 500 } )

surface.CreateFont( "boxtitlef", {
 font = "Calibri",
 size = 19,
 weight = 600,
 antialias = true
} )

surface.CreateFont( "boxmainf", {
 font = "Calibri",
 size = 16,
 weight = 200,
 antialias = true
} )

surface.CreateFont( "jobmainf", {
 font = "Myriad Pro",
 size = 13,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

local textOpen = false

function VIEW:Init( settings )
	local frame = vgui.Create("DFrame")
	frame:SetSize(640, 462)
	frame:SetSizable(true) -- bet you weren't expecting that eh, EH, EHH
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( "" )
	frame:DockPadding( 0, 31, 0, 0 )
	frame:ShowCloseButton( false )

	frame.Paint = function( self, w, h )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		
		draw.RoundedBox( 0, 0, 0, w, h, Color( 250, 250, 250, 255 ) )
		
		-- Color( 62, 67, 77 )
		draw.RoundedBox( 0, 0, 0, w, 31, Color( 44, 62, 80 ) )
		
		draw.SimpleText( tostring(settings["WindowTitle"]), "boxtitlef", 8, 5, Color( 255, 255, 255, 255 ) )
		
	end
	
	local cl = frame.btnClose
	cl:SetVisible( true ) -- you almost got it garry, nice try.
	cl:SetText( "X" )
	cl:SetFont( "fontclose" )
	cl:SetTextColor( Color( 255, 255, 255, 255 ) )
	cl.Paint = function( self, w, h )
		local kcol = self.hover and Color( 255, 150, 150 ) or Color( 175, 100, 100 )
		draw.RoundedBox( 0, 4, 4, w-8, h-8, kcol )
	end
	cl.OnCursorEntered = function( self ) self.hover = true end
	cl.OnCursorExited = function( self ) self.hover = false end
	
	local tabList = vgui.Create("DPropertySheet", frame)
	tabList:Dock(FILL)
	tabList.Paint = function(s, w, h)
		surface.SetDrawColor(80, 80, 80, 255)
		surface.DrawRect(0, 0, w, 22)
	end
	tabList:SetPadding(0)
	tabList.tabScroller:SetOverlap(0)
	
	self.ParentFrame = frame
	self.TabList = tabList
end

function VIEW:CreateCategoryTab()
	local aaPnl = vgui.Create("DPanel")
	aaPnl:DockPadding(4, 4, 4, 4)
	aaPnl.Paint = function(s, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 250, 250, 250, 255 ) )
	end
	
	local topPnl = vgui.Create( "DPanel", aaPnl )
	topPnl:SetTall( 24 )
	topPnl:Dock(TOP)
	topPnl:SetDrawBackground( false )
	topPnl:DockPadding(4, 0, 4, 4)
	
	local progBar = vgui.Create( "ACHProgressBar", topPnl )
	progBar:Dock(FILL)
	progBar:DockMargin(0, 0, 0, 0)
	progBar.Paint = function(self, w, h)
		local fDelta = 0
		
		if ( self.m_iMax - self.m_iMin != 0 ) then
			fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
		end
		
		draw.RoundedBox( 4, 0, 0, w, h, Color(44, 62, 80, 255) )
		if fDelta != 0 then
			draw.RoundedBox( 4, 0, 0, w * fDelta, h, Color(52, 73, 94, 255) )
		end
	end
	progBar.Label:SetColor( Color( 250, 250, 250 ) )
	
	local scrollPnl = vgui.Create( "DScrollPanel", aaPnl )
	scrollPnl:Dock(FILL)
	local pnl = vgui.Create('DListLayout')
	pnl:Dock(FILL)
	scrollPnl:AddItem(pnl)
	
	aaPnl.ProgBar = progBar
	aaPnl.Content = pnl

	return aaPnl
end

function VIEW:CreateAchievement( parent, data )
	local pnl = vgui.Create("DPanel", parent)
	pnl:SetTall(64 + 8)
	pnl:DockMargin(0, 0, 4, 4)
	pnl:DockPadding(4, 4, 4, 4)
	
	pnl.PaintOver = function(p, w, h)
		if ( data.Completed ) then
			local str = os.date( "Completed %b %d, %Y %I:%M%p", tonumber( data.CompletedOn ) )
			draw.SimpleText( str, "DermaDefault", w-6, 6, Color(80, 80, 80), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
			return
		end
		
		--surface.SetDrawColor(0, 0, 0, 80)
		--surface.DrawRect(0, 0, w, h)
	end
	
	pnl:SetAlpha( data.Completed and 255 or 200 )
	
	local imgicon = vgui.Create("DImage", pnl)
	imgicon:Dock(LEFT)
	imgicon:SetWide(64)
	imgicon:SetImage(data.Icon)
	imgicon:DockMargin(0, 0, 4, 0)
	function imgicon:Paint(w, h) -- vinh fix this.
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		self:PaintAt( 0, 0, w, h )
		render.PopFilterMag()
		render.PopFilterMin()
	end
	
	local function CreateLabel(text, font, color)
		local lbl = vgui.Create("DLabel", pnl)
		lbl:SetText( text )
		lbl:SetFont( font )
		lbl:SetColor( color )
		lbl:SizeToContents()
		return lbl
	end
	
	local lblname = CreateLabel( data.Name, "DermaDefaultBold", Color( 0, 0, 0 ) )
	local lbldesc = CreateLabel( data.Description, "DermaDefault", Color( 60, 60, 60 ) )
	
	lblname:Dock(TOP);	lbldesc:Dock(TOP)
	lblname:DockMargin(4, 4, 0, 0)
	lbldesc:DockMargin(4, 4, 0, 0)
	
	local progress
	if ( data.Type == ACHIEVEMENT_PROGRESS ) then
		progress = vgui.Create("ACHProgressBar", pnl)
		progress:SetTall(16)
		progress:Dock(BOTTOM)
		progress:SetMax(data.Target)
		progress:SetValue(data.Value)
	elseif ( data.Type == ACHIEVEMENT_ONEOFF ) then
		progress = 0 -- vgui.Create("somethingelse", pnl)
	end

	local rewardBtn
	if ( data.Rewards ) then
		rewardBtn = vgui.Create("DImageButton", pnl)
		rewardBtn:SetImage("gui/achievements/gift.png")
		rewardBtn:SetSize(32, 32)
		rewardBtn:SetDisabled(data.Completed)
		local rewardTooltip
		rewardBtn.OnCursorEntered = function(p)
			rewardTooltip = self:CreateRewardTooltip(rewardBtn, data.Rewards)
		end
		rewardBtn.OnCursorExited = function(p)
			if not IsValid(rewardTooltip) then return end
			rewardTooltip:Remove()
		end
	end

	-- almost got the entire thing done with docks, ALMOST, gg garry.
	pnl.PerformLayout = function(p)
		if not rewardBtn then return end
		rewardBtn:SetPos(p:GetWide() - 32, 0)
	end
	
	return pnl
end

function VIEW:CreateRewardTooltip(target, rewards)
	local pnl = vgui.Create("DPanel")
	pnl:SetSize(#rewards * 64 + 4, 64 + 4)
	pnl:SetDrawOnTop( true )

	function pnl:PositionTooltip()
		if not IsValid( self.TargetPanel ) then return self:Remove() end
		self:PerformLayout()
		local x, y = input.GetCursorPos()
		local w, h = self:GetSize()
		y = y - h - 12
		if ( y < 2 ) then y = 2 end
		self:SetPos( math.Clamp( x - w * 0.5, 0, ScrW( ) - self:GetWide( ) ), math.Clamp( y, 0, ScrH( ) - self:GetTall( ) ) )
	end

	function pnl:Paint( w, h )
		self:PositionTooltip()
		draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40, 255))
	end

	pnl.TargetPanel = target
	pnl:PositionTooltip()

	for k, reward in pairs(rewards) do
		local rewardPnl = vgui.Create("DPanel", pnl)
		rewardPnl:SetSize(64, 64)
		rewardPnl:SetPos(2+(k-1)*64, 2)
		rewardPnl:DockPadding(4, 4, 4, 4)
		rewardPnl:SetDrawBackground(false)
		rewardPnl.Paint = function(p, w, h)
			draw.RoundedBox(2, 2, 2, w-4, h-4, Color(80, 80, 80, 255))
		end

		if reward["ps_points"] then
			local rewardText = vgui.Create("DLabel", rewardPnl)
			rewardText:SetText(reward["ps_points"].."\nPoints")
			rewardText:SetFont("Default")
			rewardText:SizeToContents()
			rewardText:Dock(FILL)
			rewardText:SetContentAlignment(5)
		elseif reward["ps_item"] then -- TODO: change this to an actual icon
			local rewardText = vgui.Create("DLabel", rewardPnl)
			rewardText:SetText(reward["ps_item"])
			rewardText:SetFont("Default")
			rewardText:SizeToContents()
			rewardText:Dock(FILL)
			rewardText:SetContentAlignment(5)
		end
	end

	return pnl
end

function VIEW:AddCategory( name, material, progress, max )
	self.Categories[name] = self.TabList:AddSheet( tostring(name), self:CreateCategoryTab(), tostring(material) )
	
	local progPanel = self.Categories[name].Panel.ProgBar
	progPanel:SetValue(progress)
	progPanel:SetMax(max)
	
	self.Categories[name].Panel:SetPos( 0, 22 )
	
	local tab = self.Categories[name].Tab
	tab.Paint = function(s, w, h)
		if ( self.TabList:GetActiveTab() == tab ) then
			surface.SetDrawColor(40, 40, 40, 255)
		else
			surface.SetDrawColor(80, 80, 80, 255)
		end

		surface.DrawRect(0, 0, w, h)
	end
	
	tab.ApplySchemeSettings = function(self)
		local ExtraInset = 12 + self.Image:GetWide()

		local Active = self:GetPropertySheet():GetActiveTab() == self

		self:SetTextInset( ExtraInset, 2 )
		local w, h = self:GetContentSize()
		self:SetSize( w + 10, 22 )

		DLabel.ApplySchemeSettings( self )
	end
	
	tab.DoClick = function(self)
		-- surface.PlaySound( "" ) -- couldn't find a good sound :c
		self:GetPropertySheet():SetActiveTab( self )
	end
	
	tab:SetFont("boxmainf")
end

function VIEW:AddAchievement( data )
	local cat = self.Categories[data.Category].Panel
	self:CreateAchievement( cat.Content, data )
end