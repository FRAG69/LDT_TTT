local PANEL = {}
local GDow  = surface.GetTextureID("gui/gradient_up")

function PANEL:Init()
	self.bgcol		= MAIN_COLOR
	self.fgcol		= MAIN_COLOR2

	self.lblTitle:Remove()
	self.btnClose:Remove()
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:ShowCloseButton( false )
	self:SetDraggable( false )
	self:SetSizable( false )
	self:ShowCloseButton( false )
	
	self.TabsBut  = {}
	self.Tabs     = {}
	self.TabSel   = ""
	self.VertTabs = false
	
	self.Slide	  = 0
end

function PANEL:OnClose()
end

function PANEL:SetVerticalTabs( bool )
	self.VertTabs = bool
end

function PANEL:SetTitle( name )
end

function PANEL:SetFGColor( col )
	self.fgcol = col
end

function PANEL:SetBGColor( col )
	self.bgcol = col
end

function PANEL:AddTab(Text)
	local A = vgui.Create("MBFrame",self)
	A:SetTitle("")
	A:SetDraggable( false )
	A:SetSizable( false )
	A:ShowCloseButton( false )
	A:SetVisible(false)
	A:SetPos(0,20)
	A:SetSize(self:GetWide(),self:GetTall()-25)
	A.Paint = function() DrawRect(0,0,A:GetWide(),A:GetTall(),self.bgcol) end

	local D = vgui.Create("MBButton",self)
	D:SetText(Text)
	D.T	= #self.TabsBut*1
	
	if (D.T < 1) then A:SetVisible(true) self.TabSel = D.T end
	
	D.Paint = function() 
		if (self.TabSel == D.T) then DrawRect(0,0,D:GetWide(),D:GetTall(),self.bgcol)
		else 
			DrawRect(0,0,D:GetWide(),D:GetTall(),self.fgcol)
			DrawTexturedRect(0,0,D:GetWide(),D:GetTall(),self.bgcol,GDow)
		end
		
		DrawText( D.Text, "Trebuchet18", D:GetWide()/2, D:GetTall()/2, MAIN_TEXTCOLOR, 1 )
	end
	
	D.DoClick = function()
		for k,v in pairs(self.Tabs) do 
			v:SetVisible(false)
		end
		
		self.Tabs[D.T]:SetVisible(true)
		self.TabSel = D.T
	end
	
	table.insert(self.TabsBut,D)
	self.Tabs[D.T] = A
	
	return self.Tabs[D.T]
end
		

function PANEL:Paint()
	return true
end

function PANEL:Think()
	local Num = #self.TabsBut
	local W   = self:GetWide()
	local SW  = 100*Num
	local X,Y = self:GetPos()
	
	if (SW > self:GetWide()) then 
		if (input.IsMouseInBox(X,Y,20,20) and self.Slide > 0) then 
			self.Slide = self.Slide-1
			
			for k,v in pairs(self.TabsBut) do 
				local x,y = v:GetPos()
				v:SetPos(x+1,y)
			end
			
		elseif (input.IsMouseInBox(X+W-20,Y,20,20) and self.Slide < SW-W) then 
			self.Slide = self.Slide+1
			
			for k,v in pairs(self.TabsBut) do 
				local x,y = v:GetPos()
				v:SetPos(x-1,y)
				
			end
		end
	end
end
	
function PANEL:PerformLayout()
	for k,v in pairs(self.TabsBut) do
		v:SetPos(100*(k-1),0)
		v:SetSize(97,20)
	end

	if (self.Tabs[self.TabSel]) then
		self.Tabs[self.TabSel]:SetPos(0,20)
		self.Tabs[self.TabSel]:SetSize(self:GetWide(),self:GetTall()-25)
	end
end
 
vgui.Register( "MBTab", PANEL , "DFrame" )