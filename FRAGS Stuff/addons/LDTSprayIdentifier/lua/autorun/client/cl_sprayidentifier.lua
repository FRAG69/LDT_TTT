surface.CreateFont("SprayFont", 
{
	font = "Tahoma",
	size = 18,
	weight = 400
});

hook.Add("HUDPaint", "SPRAY_Paint the HUD", function()
	for k, v in pairs(player.GetAll()) do
		if(v != LocalPlayer()) then
			local EyeTrace = LocalPlayer():GetEyeTrace();
			local TraceHit = EyeTrace.HitPos;
			local TraceEntity = EyeTrace.Entity;
		
			local spraypos = v:GetNetworkedVector("spray_pos");
			if(spraypos != nil) then
				if(TraceHit:DistToSqr(spraypos) < 1296 and EyeTrace.HitWorld and LocalPlayer():GetPos():DistToSqr(spraypos) < 20736) then
					if(TraceEntity != nil) then	
						local pos = spraypos:ToScreen();
					
						surface.SetFont("SprayFont");
						surface.SetTextColor(Color(255, 255, 255, 255));
						surface.SetTextPos(pos.x-115, pos.y-225);
						surface.DrawText(v:Nick() .. "'s spray");
					end
				end
			end
		end
	end
end);