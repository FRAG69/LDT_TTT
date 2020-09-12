local PANEL = {}

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2

	self.lblTitle:Remove()
	
	self.Label = vgui.Create( "DLabel" , self )
	self.Label:SetText( "No-Title Frame" )
	self.Label:SetFont( "Trebuchet18" )
	self.Label:SetTextColor( MAIN_WHITECOLOR )
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:OnClose()
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
	
	return true
end
	
function PANEL:PerformLayout()
	self.Label:SetPos(2,1)
	self.Label:SizeToContents()
	
	self.btnClose:SetPos(self:GetWide()-20,0)
	self.btnClose:SetSize(20,20)
end
 
vgui.Register( "MBFrame", PANEL , "DFrame" )