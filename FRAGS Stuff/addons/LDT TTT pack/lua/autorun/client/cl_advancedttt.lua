hook.Add("HUDPaint", "WyoziAdvTTTHUD", function()
	local margin = 10
	local client = LocalPlayer()

	if not client:Alive() or client:Team() == TEAM_SPEC then return end

	local width = 250
	local height = 90

	local x = margin
	local y = ScrH() - margin - height

	local bar_height = 9
	local bar_width = width - (margin*2)

	local health = math.max(0, client:Health())
	local health_y = y + height - bar_height - 5

	draw.RoundedBox(4, x + margin, health_y, bar_width, bar_height, Color(25, 100, 25, 222))
	draw.RoundedBox(4, x + margin, health_y, bar_width * math.max(client:GetNWFloat("w_stamina", 0), 0.02), bar_height, Color(50, 200, 50, 250))
end)