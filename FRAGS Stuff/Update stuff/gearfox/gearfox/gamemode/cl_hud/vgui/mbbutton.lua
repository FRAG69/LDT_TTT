local PANEL = {}

function PANEL:Init()
	self.Hover		= false
	self.Pressed 	= false
	self.Text 		= "No-Title Button"
	self.ClickSound	= "buttons/lightswitch2.wav"
	self.ClickEnable = true
	
	self.HoverSound = "common/bugreporter_succeeded.wav"
	self.HoverEnable = false
	
	
	self:SetText("")
	self.SetText = function(s,txt) self.Text = txt end
end

function PANEL:OnCursorEntered()
	self.Hover = true 
	if (self.HoverEnable) then surface.PlaySound(self.HoverSound) end 
end

function PANEL:EnableHoverSound(bool)
	self.HoverEnable = bool
end

function PANEL:SetHoverSound(sound)
	self.HoverSound = sound
end

function PANEL:EnableClickSound(bool)
	self.ClickEnable = bool
end

function PANEL:SetClickSound(sound)
	self.ClickSound = sound
end

function PANEL:OnMousePressed()
	self.Pressed = true
	self:MouseCapture( true )
end

function PANEL:OnMouseReleased()
	if (self.Pressed) then surface.PlaySound(self.ClickSound) self:DoClick() end
	
	self.Pressed = false
	self:MouseCapture( false )
end

function PANEL:OnCursorExited() 
	self.Hover = false 
end

function PANEL:Paint()
	if (self.Pressed) 	then 	DrawBoxy( 0 , 0 , self:GetWide() , self:GetTall() , MAIN_GREENCOLOR ) 
	elseif (self.Hover) then 	DrawBoxy( 0 , 0 , self:GetWide() , self:GetTall() , MAIN_COLOR2 )
	else 						DrawBoxy( 0 , 0 , self:GetWide() , self:GetTall() , MAIN_COLORD ) end
	
	DrawText( self.Text, "Trebuchet18", self:GetWide()/2, self:GetTall()/2, MAIN_TEXTCOLOR, 1 )
end
	
function PANEL:PerformLayout()
end
 
vgui.Register( "MBButton", PANEL , "Button" )