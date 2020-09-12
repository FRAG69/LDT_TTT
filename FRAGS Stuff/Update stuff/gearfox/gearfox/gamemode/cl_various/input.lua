local B = {}
local A = {}

function input.IsMouseInBox( x , y , w , h )
	local mx, my = gui.MousePos()
	if (mx > x and mx < x+w) and (my > y and my < y+h) then return true
	else return false end
end

function input.KeyPress(KEY,ID)
	ID = ID or ""
	if (input.IsKeyDown(KEY)) then
		if (!A[KEY..ID]) then A[KEY..ID] = true return true
		else return false end
	elseif (A[KEY..ID]) then A[KEY..ID] = false end
end

function input.MousePress(MOUSE,ID)
	ID = ID or ""
	if (input.IsMouseDown(MOUSE)) then
		if (!B[MOUSE..ID]) then B[MOUSE..ID] = true return true
		else return false end
	elseif (B[MOUSE..ID]) then B[MOUSE..ID] = false end
end
