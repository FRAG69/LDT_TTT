local PANEL = {}

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2

	self.lblTitle:Remove()
	
	self.Label = vgui.Create( "DLabel" , self )
	self.Label:SetText( "No-Title Frame" )
	self.Label:SetFont( "Trebuchet18" )
	self.Label:SetTextColor( MAIN_WHITECOLOR )
	
	self.HTML = vgui.Create( "HTML" , self )
	self.HTML:OpenURL("www.google.com")
	self.HTML.StatusChanged = function( s , str ) self.Status = str end
	
	self.Status = "Ready."
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:OnClose()
end

function PANEL:OpenURL(url)
	self.HTML:OpenURL(url)
end

function PANEL:SetTitle( name )
	self.Label:SetText(name)
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
	
	self.HTML:SetPos(1,22)
	self.HTML:SetSize(self:GetWide()-2,self:GetTall()-44)
end
 
vgui.Register( "MBBrowser", PANEL , "DFrame" )