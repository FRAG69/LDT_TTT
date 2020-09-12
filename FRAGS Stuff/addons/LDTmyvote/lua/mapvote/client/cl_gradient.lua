local GRADIENT_HORIZONTAL, GRADIENT_VERTICAL = 0, 1
function draw.LinearGradientHSV( x, y, w, h, from, to, dir )
	local hsvFrom = {ColorToHSV( from )}
	local hsvTo = {ColorToHSV( to )}
	local diff = {hsvTo[1] - hsvFrom[1], hsvTo[2] - hsvFrom[2], hsvTo[3] - hsvFrom[3]}
	for i = 0, h, 0.1 do
		local r, g, b = HSVToColor( hsvFrom[1] + ( i / h ) * diff[1], hsvFrom[2] + ( i / h ) * diff[2], hsvFrom[3] + ( i / h ) * diff[3] )
		surface.SetDrawColor( r, g, b )
		if dir == GRADIENT_VERTICAL then
			surface.DrawRect( x, i, w, h )
		else
			surface.DrawRect( i, y, w, h )
		end
	end
end


function draw.LinearGradient( x, y, w, h, from, to, dir )
	for i = 0, h, 0.1 do
		local r, g, b = Lerp( i / h, from.r, to.r ), Lerp( i/h, from.g, to.g ), Lerp( i/h, from.b, to.b )
		surface.SetDrawColor( r, g, b )
		if dir == GRADIENT_VERTICAL then
			surface.DrawRect( x, i, w, h )
		else
			surface.DrawRect( i, y, w, h )
		end
	end
end

local function createGradientTexture( strName, w, h, color_start, color_end, dir )
	local rt = GetRenderTarget( strName, w, h, false )
	local oldRT = render.GetRenderTarget( )
	local oldW, oldH = ScrW(), ScrH( )
	render.SetRenderTarget( rt )
		render.SetViewPort( 0, 0, w, h )
		render.Clear( 0, 0, 0, 255, true )
		cam.Start2D( )
			draw.LinearGradient( 0, 0, w, h, color_start, color_end, dir )
		cam.End2D( )
	render.SetRenderTarget( oldRt )
	render.SetViewPort( 0, 0, oldW, oldH )
	return rt
end

local function createGradientMaterial( strName, w, h, color_start, color_end, dir )
	local rt = GetRenderTarget( strName, w, h, false )
	local params = { }
	local rt = createGradientTexture( strName, w, h, color_start, color_end, dir )
	local mat = CreateMaterial( strName, "UnlitGeneric" )
	mat:SetTexture( "$basetexture", rt )
	return mat
end

local function drawGradientBar( mat, x, y, w, h )
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial( mat )
	surface.DrawTexturedRectUV( x, y, w, h, 0, 0, w, 1 )
end

local materials = {}
function GradientBox( id, x, y, w, h, from, to, dir, pulse )
	dir = dir or GRADIENT_VERTICAL
	pulse = pulse or false
	if not materials[id] then
		if not GAMEMODE.CanRender then
			return
		end
		print( "Creating" )
		if dir == GRADIENT_VERTICAL then
			materials[id] = createGradientMaterial( id, 1, h, from, to, dir )
		else
			materials[id] = createGradientMaterial( id, w, 1, from, to, dir )
		end
	end
	if pulse then
		local matrix = materials[id]:GetString( "$color" )
		matrix = Vector( ( math.sin( CurTime( ) / 2 ) + 1 ) / 6 + 1/6, ( math.sin( CurTime( ) / 2 ) + 1 ) / 6 + 1/6, 1 )
		materials[id]:SetVector( "$color", matrix )
	end
	
	surface.SetMaterial( materials[id] )
	surface.SetDrawColor( 255, 255, 255, 255 )
	if dir == GRADIENT_VERTICAL then
		surface.DrawTexturedRectUV( x, y, w, h, 0, 0, w, 1 )
	else
		surface.DrawTexturedRectUV( x, y, w, h, 0, 0, 1, h )
	end
end

local str = math.random( 0, 1000 )
hook.Add( "HUDPaint", "TestMaterial", function( ) 
	GAMEMODE.CanRender = true
end )
