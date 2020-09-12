local PANEL = {}

function PANEL:Init()
	self.fgcol = MAIN_COLORD
	self.Limit = 100
	
	self:SetPadding( 1 )
	self:SetSpacing( 1 )
	self:SetAutoSize(false)
	self:EnableHorizontal( false )
	self:EnableVerticalScrollbar( true )
	self.VBar.Paint = function(s) end
	self.VBar.btnGrip.Paint = function(s) DrawBoxy( 0 , 0 , s:GetWide() , s:GetTall() , self.fgcol ) end
	self.VBar.btnDown.Paint = function(s) DrawBoxy( 0 , 0 , s:GetWide() , s:GetTall() , self.fgcol ) end
	self.VBar.btnUp.Paint 	= function(s) DrawBoxy( 0 , 0 , s:GetWide() , s:GetTall() , self.fgcol ) end
end

function PANEL:SetVScroll(num)
	self.VBar:SetScroll(num)
end

function PANEL:AddVScroll(num)
	self.VBar:AddScroll(num)
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetLimit(l)
	self.Limit = l
end

function PANEL:RemoveItem( item )
	for k, v in pairs( self.Items ) do
		if ( v == item ) then
			table.remove(self.Items,k)
			v:Remove()
		
			self:InvalidateLayout()
			break
		end
	end
end

function PANEL:Think()
	local It = self:GetItems()
	if (#It > self.Limit) then self:RemoveItem(It[#It-self.Limit]) end
end

function PANEL:Paint()
end

vgui.Register( "MBPanelList", PANEL , "DPanelList" )