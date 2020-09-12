surface.CreateFont("Default12B", {
    font = "Default",
    size = 12,
    weight = 700,
    antialias = false
})

surface.CreateFont("Default13B", {
    font = "Default",
    size = 13,
    weight = 700,
    antialias = false
})

surface.CreateFont("Default14BA", {
    font = "Default",
    size = 14,
    weight = 700,
    antialias = true
})

local gradient = Material( "gui/gradient_down" )

local PANEL = {}

function PANEL:Init()
    self.Offset = 0
    self.Direction = 1
    self.Speed = 3
    self.Slot = 1
    self.Text = ""
end

function PANEL:SetAchievement( text, image )
    self.Text = text
    self.Image = image or "achievements/generic.png"
    
    self.Material = Material( self.Image, "unlitgeneric" )
    if ( !self.Material ) then self.Image = nil end
end

function PANEL:SetSlot( slot )
    self.Slot = slot
end

function PANEL:Think()
    self.Offset = math.Clamp( self.Offset + ( self.Direction * FrameTime() * self.Speed ), 0, 1 )
    self:InvalidateLayout()
    
    if ( self.Direction == 1 && self.Offset == 1 ) then
        self.Direction = 0
        self.Down = CurTime() + 5
    end
    if ( self.Down != nil && CurTime() > self.Down ) then
        self.Direction = -1
        self.Down = nil
    end
    if ( self.Offset == 0 ) then
        self.Removed = true
    end
end
function PANEL:PerformLayout()
    local w, h = 240, 94
    
    self:SetSize( w, h )
    self:SetPos( ScrW() - w, ScrH() - ( h * self.Offset * self.Slot ) )
end

function PANEL:Paint()
    local w, h = self:GetWide(), self:GetTall()
    local a = self.Offset * 255
    
    --surface.SetDrawColor( 23, 22, 20, a )
    surface.SetDrawColor( 23, 22, 20, a )
    surface.DrawRect( 0, 0, w, h )

    surface.SetMaterial( gradient )
    surface.SetDrawColor( 255, 255, 255, a/32 )
    surface.DrawTexturedRect( 0, 0, w, h)

    surface.SetDrawColor( 26, 26, 26, a )
    surface.DrawOutlinedRect( 0, 0, w+1, h+1 )
    
    surface.SetDrawColor( 255, 255, 255, a )
    
    if ( self.Image ) then
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )

        surface.SetMaterial( self.Material )
        surface.DrawTexturedRect( 14, 14, 64, 64 )
		
		render.PopFilterMag()
		render.PopFilterMin()
    end
    
    draw.DrawText( "Achievement Unlocked!", "Default12B", 88, 30, Color( 255, 255, 255, a ), TEXT_ALIGN_LEFT )
    draw.DrawText( self.Text, "Default12B", 88, 50, Color( 180, 180, 180, a ), TEXT_ALIGN_LEFT )
    
end

vgui.Register("AchievementsNotify", PANEL)