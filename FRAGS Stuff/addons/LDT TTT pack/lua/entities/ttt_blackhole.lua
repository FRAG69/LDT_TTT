
AddCSLuaFile()

ENT.Type = "anim"

AccessorFunc( ENT, "spawner", "Spawner", FORCE_ENTITY )
function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Radius")
end

if SERVER then

	-- CONFIGURATION! These should be edited with rcon or server.cfg instead of directly here.

	local bh_attractplys = CreateConVar("ttt_blackhole_attractplys", "1", FCVAR_ARCHIVE)
	local bh_attractents = CreateConVar("ttt_blackhole_attractents", "1", FCVAR_ARCHIVE)

	local bh_entforcemul = CreateConVar("ttt_blackhole_entattractforce", "1", FCVAR_ARCHIVE)
	local bh_plyforcemul = CreateConVar("ttt_blackhole_plyattractforce", "1", FCVAR_ARCHIVE)

	local bh_perfmode = CreateConVar("ttt_blackhole_perfmode", "0", FCVAR_ARCHIVE)

	-- The radius from which we should attract entities at start. (is ten times smaller than same distance in hammer units)
	local bh_startradius = CreateConVar("ttt_blackhole_startradius", "50", FCVAR_ARCHIVE)

	-- How long should the black hole be alive. (can be extended with ttt_blachole_incrlifepereat)
	local bh_startlife = CreateConVar("ttt_blackhole_startlife", "10", FCVAR_ARCHIVE)

	-- The maximum radius we can achieve. If you want to limit good value could be 100-150
	local bh_radlimit = CreateConVar("ttt_blackhole_limitradius", "0", FCVAR_ARCHIVE)

	-- Should we "eat" entities when they get too close?
	local bh_eatents = CreateConVar("ttt_blackhole_eatentities", "1", FCVAR_ARCHIVE)

	-- By how many seconds should we extend black hole's lifetime every time we eat an entity
	local bh_incrlife = CreateConVar("ttt_blackhole_incrlifepereat", "0.2", FCVAR_ARCHIVE)

	-- How much should we damage players that are too close
	local bh_plydmg = CreateConVar("ttt_blackhole_playerdmg", "1", FCVAR_ARCHIVE)

	-- A list of entities we shouldn't attract
	local bh_blacklist = {
		"ttt_blackhole"
	}

	local bh_loop = Sound("ambient/machines/transformer_loop.wav")

	resource.AddFile("materials/sprites/bh-glow.vmt")
	resource.AddFile("materials/sprites/bh-smoothglow.vmt")

	function ENT:Initialize()
		self:SetModel("models/combine_helicopter/helicopter_bomb01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)

		self:SetTrigger(true)
		local phy = self:GetPhysicsObject()
		if phy:IsValid() then
			phy:EnableGravity(false)
			phy:SetMass(1000)
		end
		self:DrawShadow(false)

		self:SetRadius(bh_startradius:GetFloat())
		self.DieAt = CurTime() + bh_startlife:GetFloat()

		self.Sound = CreateSound(self, bh_loop)
		self.Sound:ChangeVolume(math.Clamp(self:GetRadius() / 100, 0, 1), 0)
		self.Sound:SetSoundLevel(85)
		self.Sound:Play()
	end

	function ENT:OnRemove()
		self.Sound:Stop()
	end

	function ENT:IncrRadius(by)
		if bh_radlimit:GetInt() == 0 or bh_radlimit:GetInt() < self:GetRadius() then
			self:SetRadius(self:GetRadius() + by)
			self.Sound:ChangeVolume(math.Clamp(self:GetRadius() / 100, 0, 1), 0)
			self.Sound:ChangePitch(math.min(self:GetRadius()*2, 255), 0)
		end
	end

	local ents = ents

	local eatsounds = {
		"ambient/materials/door_hit1.wav",
		"ambient/materials/metal_groan.wav"
	}

	function ENT:IsGoodEnt(ent)

		if not bh_attractents:GetBool() then return false end
		if table.HasValue(bh_blacklist, ent:GetClass()) then return false end
		if ent:GetMoveType() == MOVETYPE_NONE then return false end

		if bh_perfmode:GetBool() then

			local theirpos = ent:NearestPoint(self:GetPos())

			--debugoverlay.Line(self:GetPos(), theirpos)
			if not self:VisibleVec(theirpos) then
				return false
			end

		end
		return true
	end

	function ENT:Think()

		if self.DieAt < CurTime() then
			self:Remove()
			return
		end

		local pos = self:GetPos()

		local valve_radius = self:GetRadius() * 10

		for _, ent in pairs(ents.FindInSphere(pos, valve_radius)) do
			local phys = ent:GetPhysicsObject()

			local posdiff = -(ent:GetPos() - pos)
			local dist = posdiff:Length()
			posdiff:Normalize()

			if ent:IsPlayer() then
				
				if ent:Alive() and ent:Team() ~= TEAM_SPEC and bh_attractplys:GetBool() then
					if dist < self:GetRadius() and bh_plydmg:GetFloat() > 0 then
						ent:TakeDamage(bh_plydmg:GetFloat(), self:GetSpawner())
						self:IncrRadius(0.2)
						ent:EmitSound("ambient/energy/zap8.wav")
					else
						local force = posdiff * ( ( valve_radius - dist ) / 20 ) * bh_plyforcemul:GetFloat()
						ent:SetVelocity(force)
					end
				end

			elseif phys:IsValid() and not ent.WYOZIBHDontEat and self:IsGoodEnt(ent, phys) then

				if dist < self:GetRadius() * 0.75 and bh_eatents:GetBool() then

					local effectdata = EffectData()
					effectdata:SetStart( ent:GetPos() )
					effectdata:SetOrigin( self:GetPos() ) -- end pos
					effectdata:SetEntity( ent )
					util.Effect( "blackhole_eatent", effectdata )	

					ent.WYOZIBHDontEat = true
					self:EmitSound(table.Random(eatsounds))

					timer.Simple(0.5, function()
						if ent:IsValid() then
							ent:Remove()
						end
					end)

					self:IncrRadius(1.5)
					self.DieAt = self.DieAt + bh_incrlife:GetFloat()

				else
					if ent:GetClass() == "prop_physics" then
						ent:SetOwner(self:GetSpawner())
					end
					local force = posdiff * ( ( valve_radius - dist ) / (bh_perfmode:GetBool() and 7 or 10) ) * math.max(phys:GetMass(), 1) * bh_entforcemul:GetFloat()
					phys:ApplyForceCenter(force)
				end
			end
		end

		self:NextThink(CurTime() + 0.1)
		return true
	end
end

if CLIENT then

	local bh_screeneff = CreateClientConVar("ttt_blackhole_screenfx", "1", FCVAR_ARCHIVE)

	local mat_refract = Material("effects/strider_pinch_dudv")
	local mat_glow = Material("sprites/bh-glow")
	local mat_sglow = Material("sprites/bh-smoothglow")

	function ENT:Initialize()
		mat_refract:SetFloat("$refractamount", 0.1)
		mat_refract:SetInt("$forcerefract", 1)
		mat_refract:SetInt("$nofog", 1)

		self.NextGravParticle = CurTime() + 0.1
	end

	function ENT:Think()
		if CurTime() > self.NextGravParticle then
			local pos = self:GetPos()
			local em = ParticleEmitter(pos, false)
			
			local pos_offset = VectorRand() * self:GetRadius()
			local particle = em:Add("sprites/bh-smoothglow", pos + pos_offset)
			if particle then
				particle:SetLifeTime(0)
				particle:SetDieTime(0.5)
				particle:SetVelocity(pos_offset * -0.1)
				particle:SetGravity(pos_offset * -4)
				particle:SetStartSize(0)
				particle:SetEndSize(1 + math.random())
				particle:SetStartAlpha(200)
				particle:SetEndAlpha(255)

				local rnd = math.random(0, 127)
				particle:SetColor(rnd, rnd, rnd, 255)
			end
			self.NextGravParticle = CurTime() + 0.1
		end
	end

	function ENT:Draw()
		local pos = self:GetPos()
		local curtime_sin = math.sin(CurTime())

		cam.IgnoreZ(true)

		do

			local radius = self:GetRadius()

			-- Update refract texture to current FBO?
			render.UpdateRefractTexture()

			-- Draw the refract effect
			mat_refract:SetFloat("$refractamount", 0.03 + curtime_sin * 0.03)
			render.SetMaterial(mat_refract)
			render.DrawSprite(pos, radius * 2, radius * 2, COLOR_WHITE)

			-- Draw the gradient
			render.SetMaterial(mat_sglow)
			render.DrawSprite(pos, radius * 3 - curtime_sin * 10, radius * 3 - curtime_sin * 10, COLOR_BLACK)
			mat_glow:SetFloat("$rotMul", -15.0)

			-- Draw the rotating inner part of the black hole
			render.SetMaterial(mat_glow)
			local sz = radius * 1.2 + 8 * curtime_sin
			render.DrawSprite(pos, sz, sz, COLOR_WHITE)
			mat_glow:SetFloat("$rotMul",18.0)

		end

		cam.IgnoreZ(false)
	end

	local matMaterial	= Material( "pp/texturize" )

	matMaterial:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

	local mat_overlay = Material("pp/texturize/pattern1.png")
	local mat_overlay2 = Material("vgui/zoom")

	local function DrawBHOverlay(alpha)

		render.UpdateScreenEffectTexture()

		if alpha >= 0.9 then
			local scale = 1

			matMaterial:SetFloat( "$scalex", (ScrW() / 64) * scale )
			matMaterial:SetFloat( "$scaley", (ScrH() / 64 / 8) * scale )
			matMaterial:SetTexture( "$basetexture", mat_overlay:GetTexture( "$basetexture" ) )

			render.SetMaterial( matMaterial )
			render.DrawScreenQuad()
		elseif alpha >= 0.2 then
			mat_overlay2:SetFloat("$envmap",	0)
			mat_overlay2:SetFloat("$envmaptint",	0)
			mat_overlay2:SetFloat("$refractamount", 0.1)
			mat_overlay2:SetFloat("$alpha", math.min(alpha*2, 1))
			mat_overlay2:SetInt("$ignorez", 1)

			render.SetMaterial( mat_overlay2 )
			render.DrawScreenQuad()
		end

	end

	hook.Add("RenderScreenspaceEffects", "WYOZIBlackHoleScreenEffects", function()
		if not bh_screeneff:GetBool() then return end
		local bhs = ents.FindByClass("ttt_blackhole")
		local sent, sdist, i
		for i=1,#bhs do
			local dist = bhs[i]:GetPos():Distance(LocalPlayer():GetPos())
			if not sdist or dist < sdist then
				sdist = dist
				sent = bhs[i]
			end
		end
		if not sent then return end
		local strength = 1 - sdist / (sent:GetRadius()*10)
		if strength <= 0 then return end
		DrawBHOverlay(strength or 0.5)
	end)

end