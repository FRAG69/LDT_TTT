local PANEL = {}

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2

	self.lblTitle:Remove()
	
	self.Label = vgui.Create( "DLabel" , self )
	self.Label:SetText( "User Browser" )
	self.Label:SetFont( "Trebuchet18" )
	self.Label:SetTextColor( MAIN_WHITECOLOR )
	
	self.HTML = vgui.Create( "HTML" , self )
	self.HTML:OpenURL( "www.google.com" )
	
	self.HTML.StatusChanged 		= function( s , str ) self.Status = str end
	self.HTML.PageTitleChanged 		= function( s , title ) self.Label:SetText(title) end
	self.HTML.FinishedURL			= function( s , url ) self.URLBar:SetText(url) end
	
	self.Status = "Ready."
	
	
	
	self.BackB = vgui.Create( "MBButton" , self )
	self.BackB:SetText("<")
	self.BackB:EnableHoverSound(false)
	self.BackB.DoClick = function() self.HTML:HTMLBack() end
	
	self.RefreshB = vgui.Create( "MBButton" , self )
	self.RefreshB:SetText("Refresh")
	self.RefreshB:EnableHoverSound(false)
	self.RefreshB.DoClick = function() self.HTML:Refresh() end
	
	self.ForwardB = vgui.Create( "MBButton" , self )
	self.ForwardB:SetText(">")
	self.ForwardB:EnableHoverSound(false)
	self.ForwardB.DoClick = function() self.HTML:HTMLForward() end
	
	self.URLBar = vgui.Create( "DTextEntry" , self )
	self.URLBar:SetText("www.google.com")
	self.URLBar.OnEnter = function(s) self.HTML:OpenURL(s:GetValue()) end

	
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:OnClose()
end

function PANEL:OpenURL(url)
	self.HTML:OpenURL(url)
end

function PANEL:SetTitle( name )
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:SetTextColor( col )
	self.Label:SetTextColor( col )
end

function PANEL:SetTextFont( font )
	self.Label:SetFont( font )
end

function PANEL:Paint()
	DrawBoxy( 0 , 0 , self:GetWide() , self:GetTall() , self.bgcol )
	DrawLine( 0 , 20 , self:GetWide() , 20 , self.fgcol )
	
	DrawText( self.Status , "Trebuchet18" , 5 , self:GetTall()-20 , MAIN_WHITECOLOR )
	
	return true
end
	
function PANEL:PerformLayout()
	self.Label:SetPos(2,1)
	self.Label:SizeToContents()
	
	self.btnClose:SetPos(self:GetWide()-20,0)
	self.btnClose:SetSize(20,20)
	
	self.HTML:SetPos(1,42)
	self.HTML:SetSize(self:GetWide()-2,self:GetTall()-64)
	
	self.BackB:SetPos(10,22)
	self.BackB:SetSize(20,20)
	
	self.RefreshB:SetPos(60,22)
	self.RefreshB:SetSize(80,20)
	
	self.ForwardB:SetPos(35,22)
	self.ForwardB:SetSize(20,20)
	
	self.URLBar:SetPos(145,22)
	self.URLBar:SetSize(self:GetWide()-150,20)
end
 
vgui.Register( "MBUserBrowser", PANEL , "DFrame" )