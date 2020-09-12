
function math.IsFloat(num)
	if (math.floor(num) != math.ceil(num)) then return true end
	return false
end

function math.AngleNormalize(ang)
	return Angle(math.NormalizeAngle(ang.p),math.NormalizeAngle(ang.y),math.NormalizeAngle(ang.r))
end