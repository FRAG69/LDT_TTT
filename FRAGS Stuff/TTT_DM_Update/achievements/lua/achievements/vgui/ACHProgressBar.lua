--=============================================================================--
--  ___  ___   _   _   _    __   _   ___ ___ __ __
-- |_ _|| __| / \ | \_/ |  / _| / \ | o \ o \\ V /
--  | | | _| | o || \_/ | ( |_n| o ||   /   / \ / 
--  |_| |___||_n_||_| |_|  \__/|_n_||_|\\_|\\ |_|  2009
--										 
--=============================================================================--

local PANEL = {}

AccessorFunc( PANEL, "m_iMin", 	"Min" )
AccessorFunc( PANEL, "m_iMax", 	"Max" )
AccessorFunc( PANEL, "m_iValue", 	"Value" )
AccessorFunc( PANEL, "m_Color", 	"Color" )

if ( system.IsOSX() ) then

surface.CreateFont( "DermaDefault11",
{
	font		= "Helvetica",
	size		= 11,
	antialias	= false,
	weight		= 500
})

else

surface.CreateFont( "DermaDefault11",
{
	font		= "Tahoma",
	size		= 11,
	antialias	= true,
	weight		= 500
})

end

--[[---------------------------------------------------------
	Init
-----------------------------------------------------------]]
function PANEL:Init()
	
	self.Label = vgui.Create( "DLabel", self )
	self.Label:SetFont( "DermaDefault11" )
	self.Label:SetColor( Color( 0, 0, 0 ) )
	
	self:SetMin( 0 )
	self:SetMax( 1000 )
	self:SetValue( 253 )
	self:SetColor( Color( 50, 205, 255, 255 ) )
	
end

function PANEL:LabelAsPecentage()
	self.m_bLabelAsPercentage = true
	self:UpdateText()
end

function PANEL:SetMin( i )
	self.m_iMin = i
	self:UpdateText()
end

function PANEL:SetMax( i )
	self.m_iMax = i
	self:UpdateText()
end

function PANEL:SetValue( i )
	self.m_iValue = i
	self:UpdateText()
end

function PANEL:UpdateText()
	
	if ( !self.m_iMax ) then return end
	if ( !self.m_iMin ) then return end
	if ( !self.m_iValue ) then return end
	
	local fDelta = 0;
	
	if ( self.m_iMax-self.m_iMin != 0 ) then
		fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
	end
	
	if ( self.m_bLabelAsPercentage ) then
		self.Label:SetText( Format( "%.2f%%", fDelta * 100 ) )
		return
	end
	
	if ( self.m_iMin == 0 ) then
	
		self.Label:SetText( Format( "%i / %i", self.m_iValue, self.m_iMax ) )
	
	else
	
		-- Todo..
	
	end
	
end


--[[---------------------------------------------------------
	PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	--self.Label:CopyBounds( self )
	self.Label:SizeToContents()
	self.Label:AlignRight( 5 )
	self.Label:CenterVertical()

end

function PANEL:Paint()

	local fDelta = 0;
	
	if ( self.m_iMax-self.m_iMin != 0 ) then
		fDelta = ( self.m_iValue - self.m_iMin ) / (self.m_iMax-self.m_iMin)
	end
	
	local Width = self:GetWide()

	surface.SetDrawColor( 0, 0, 0, 170 )
	surface.DrawRect( 0, 0, Width, self:GetTall() )
	
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a * 0.5 )
	surface.DrawRect( 1, 1, Width - 2, self:GetTall() - 2 )
	surface.SetDrawColor( self.m_Color.r, self.m_Color.g, self.m_Color.b, self.m_Color.a )
	surface.DrawRect( 1, 1, Width * fDelta - 2, self:GetTall() - 2 )

end

vgui.Register( "ACHProgressBar", PANEL, "DPanel" )