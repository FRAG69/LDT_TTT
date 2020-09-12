

hook.Add("Initialize","GearFoxInit",function()
	self = GM or GAMEMODE
	
	if (self.UseMawBlockCHud) then
		self:AddBlockCHud("CHudWeaponSelection")
		self:AddBlockCHud("CHudHealth")
		self:AddBlockCHud("CHudBattery")
		self:AddBlockCHud("CHudDamageIndicator")
	end
end)

hook.Add("HUDPaint","GearFoxDrawNotes",function()
	HUDDrawNotes()
end)