local PANEL = {}

function PANEL:Init()
    self:SetSize(800, 600)
    self:Center()
    self:MakePopup()

    self:DockPadding( 5, 32 + 5, 5, 5 )
    self:SetTitle( "" )
    self:ShowCloseButton( true )
 
    self.LeftContainer = vgui.Create("DPanel", self)
    self.LeftContainer:Dock(LEFT)
    self.LeftContainer:DockMargin(0, 0, 8, 0)
    self.LeftContainer:DockPadding(0, 32, 0, 0)
    self.LeftContainer:SetWide(192)
    self.LeftContainer.Paint = function(pnl, w, h)
        local col = achievements.GetColorScheme()

        draw.RoundedBox( 4, 0, 0, w, h, Color(223, 229, 231) )
        draw.RoundedBoxEx( 4, 0, 0, w, 32 , col["FrameHeader"], true, true )

        draw.SimpleText( "Categories", "boxmainf", w/2, 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end

    local nodeButtons = {}

    for k, v in pairs(achievements.GetCategories()) do
        local node = self.LeftContainer:Add("DButton")
        node:Dock(TOP)

        node.Paint = function(panel, w, h)
            local col = achievements.GetColorScheme()

            if ( panel:GetToggle() ) then
                surface.SetDrawColor(col["ListHeader"])
                surface.DrawRect(0, 0, w, h)
            elseif ( panel.Hovered ) then
                surface.SetDrawColor(0, 0, 0, 40)
                surface.DrawRect(0, 0, w, h)
            end

            draw.SimpleText(panel:GetText(), "boxmainf", w/2, h/2, Color(40, 40, 40, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        node:SetTall(32)
        node:SetText(v.Name)
        node:SetTextColor(Color(0, 0, 0, 0))

        node.DoClick = function(btn)
            for _, v in pairs(nodeButtons) do
                v:SetToggle(false)
            end

            if btn:GetToggle() then
               btn:SetToggle(false)
            else
               btn:SetToggle(true)
            end

            self:LoadAchievements(k)
        end

        table.insert(nodeButtons, node)
    end

    self.ContentContainer = vgui.Create("DScrollPanel", self)
    self.ContentContainer:Dock(FILL)

    --for k, v in pairs(achievements.GetCategories()["All"]) do
    --    local node = content:Add("DButton")
    --    node:SetText(v)
    --end
end

function PANEL:LoadAchievements(cat)
    cat = achievements.GetCategories()[cat]
    if not cat then return end

    local content = self.ContentContainer
    for k, v in pairs(cat) do
        local node = vgui.Create("DButton")
        node:Dock(TOP)
        node:SetText(v)
        content:AddItem(node)
    end
end

function PANEL:Paint(w, h)
    local col = achievements.GetColorScheme()
    draw.RoundedBox( 4, 0, 0, w, h, Color(236, 240, 241) )
    draw.RoundedBoxEx( 4, 0, 0, w, 32 , col["FrameHeader"], true, true )
    
    draw.SimpleText( achievements.FrameTitle, "boxtitlef", 12, 6, Color( 255, 255, 255, 255 ) )
end

vgui.Register("AchievementsFrame", PANEL, "DFrame")