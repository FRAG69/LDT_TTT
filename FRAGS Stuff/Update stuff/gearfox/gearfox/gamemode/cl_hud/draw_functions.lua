
local Grad = surface.GetTextureID("gui/gradient")
	
function DrawBoxy(x,y,w,h,color)
	draw.RoundedBox( 8, x, y, w, h, color )
end

function DrawText(text,font,x,y,color,bCentered)
	draw.SimpleText( text, font, x, y, color, bCentered or 0, bCentered or 0 )
end

function DrawRect(x,y,w,h,color)
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawRect( x, y, w, h )
end

function DrawOutlinedRect(x,y,w,h,color)
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawOutlinedRect( x, y, w, h )
end

function DrawLeftGradient(x,y,w,h,color)
	DrawTexturedRect(x,y,w,h,color,Grad)
end

function DrawTexturedRect(x,y,w,h,color,texture)
	surface.SetTexture( texture )
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawTexturedRect( x, y, w, h )
end

function DrawTexturedRectRotated(x,y,w,h,color,texture,rot)
	surface.SetTexture( texture )
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawTexturedRectRotated( x, y, w, h, rot )
end

function DrawLine(x,y,x2,y2,color)
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawLine( x, y, x2, y2 )
end