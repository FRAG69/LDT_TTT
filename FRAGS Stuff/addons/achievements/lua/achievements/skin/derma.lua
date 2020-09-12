VIEW = {}

VIEW.ParentFrame = nil
VIEW.TabList = nil
VIEW.Categories = {}

function VIEW:Init( settings )
	local frame = vgui.Create("DFrame")
	frame:SetSize(640, 462)
	frame:SetSizable(true) -- bet you weren't expecting that eh, EH, EHH
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( tostring(settings["WindowTitle"]) )
	
	local tabList = vgui.Create("DPropertySheet", frame)
	tabList:Dock(FILL)
	
	self.ParentFrame = frame
	self.TabList = tabList
end

function VIEW:CreateCategoryTab()
	local aaPnl = vgui.Create("DPanel")
	aaPnl:DockPadding(8, 8, 8, 8)
	
	local topPnl = vgui.Create( "DPanel", aaPnl )
	topPnl:SetTall( 24 )
	topPnl:Dock(TOP)
	topPnl:SetDrawBackground( false )
	topPnl:DockPadding(4, 0, 4, 4)
	
	local progBar = vgui.Create( "ACHProgressBar", topPnl )
	progBar:Dock(FILL)
	progBar:DockMargin(0, 0, 0, 0)
	
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
	if ( data.Rewards and #data.Rewards > 0 ) then
		rewardBtn = vgui.Create("DImageButton", pnl)
		rewardBtn:SetImage("icon16/award_star_gold_1.png")
		rewardBtn:Dock(RIGHT)
		rewardBtn:DockMargin(8, 8, 8, 8)
		rewardBtn:SetSize(16, 16)
	end
	
	return pnl
end

function VIEW:CreateRewardTooltip()

end

function VIEW:AddCategory( name, material, progress, max )
	self.Categories[name] = self.TabList:AddSheet( tostring(name), self:CreateCategoryTab(), tostring(material) )
	
	local progPanel = self.Categories[name].Panel.ProgBar
	progPanel:SetValue(progress)
	progPanel:SetMax(max)
end

function VIEW:AddAchievement( data )
	local cat = self.Categories[data.Category].Panel
	self:CreateAchievement( cat.Content, data )
end