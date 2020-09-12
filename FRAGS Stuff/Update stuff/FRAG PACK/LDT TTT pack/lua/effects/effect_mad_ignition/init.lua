local tMats = {}
tMats.Glow1 = Material("sprites/light_glow02")
tMats.Glow2 = Material("sprites/flare1")

for _, mat in pairs(tMats) do

	mat:SetMaterialInt("$spriterendermode", 9)
	mat:SetMaterialInt("$ignorez", 1)
	mat:SetMaterialInt("$illumfactor", 8)
end

local SmokeParticleUpdate = function(particle)

	if particle:GetStartAlpha() == 0 and particle:GetLifeTime() >= 0.5 * particle:GetDieTime() then
		particle:SetStartAlpha(particle:GetEndAlpha())
		particle:SetEndAlpha(0)
		particle:SetNextThink(-1)
	else
		particle:SetNextThink(CurTime() + 0.1)
	end

	return particle
end

function EFFECT:Init(data)

	self.Scale = data:GetScale()
	self.ScaleSlow = math.sqrt(self.Scale)
	self.ScaleSlowest = math.sqrt(self.ScaleSlow)
	self.Normal = data:GetNormal()
	self.RightAngle = self.Normal:Angle():Right():Angle()
	self.Position = data:GetOrigin() - 12 * self.Normal
	self.Position2 = self.Position

	local CurrentTime = CurTime()
	self.Duration = 0.5 * self.Scale 
	self.KillTime = CurrentTime + self.Duration
	self.GlowAlpha = 200
	self.GlowSize = 100 * self.Scale
	self.FlashAlpha = 100
	self.FlashSize = 0

	local emitter = ParticleEmitter(self.Position)

	// fire ball
	for i = 1, math.ceil(self.Scale) do
			
		local velocity = Vector(1,1,1)
		local particle = emitter:Add("effects/fire_cloud"..math.random(1, 2), self.Position)

		particle:SetVelocity(velocity)
		particle:SetGravity(VectorRand() * math.Rand(200, 400) + Vector(0, 0, math.Rand(500, 700)))
		particle:SetAirResistance(250)
		particle:SetDieTime(math.Rand(0.7, 1.1) * self.Scale)
		particle:SetStartAlpha(math.Rand(230, 250))
		particle:SetStartSize(math.Rand(10, 20) * self.ScaleSlow)
		particle:SetEndSize(math.Rand(15, 25) * self.ScaleSlow)
		particle:SetRoll(math.Rand(150, 180))
		particle:SetRollDelta(0.6 * math.random(-1, 1))
		particle:SetColor(255, 255, 255)
	end

	emitter:Finish()

end
