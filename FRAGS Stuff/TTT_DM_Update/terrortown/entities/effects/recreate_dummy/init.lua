
local backup_mdl = Model("models/player/phoenix.mdl")

function EFFECT:Init(data)
   self.Corpse = data:GetEntity()

	if corpseBones != nil then
		self.Bones = corpseBones
		corpseBones = nil
	end
   
   self:SetPos(data:GetOrigin())

     local att = data:GetAttachment()
   local ang = data:GetAngles()

   ang.r = 0
   ang.p = 0
   if att != 3 then
	self:SetAngles(ang)
	self.Sequence = data:GetColor()
	self.Cycle    = data:GetScale()
   end

   self:SetRenderBounds(Vector(-18, -18, 0), Vector(18, 18, 64))

   self.Duration = data:GetRadius() or 0
   self.EndTime  = CurTime() + self.Duration

   self.FadeTime = 2

   self.FadeIn   = CurTime() + self.FadeTime
   self.FadeOut  = self.EndTime - self.FadeTime
   
	if att == 2 then
		self.Alpha = 0.7
	else
		  self.Alpha = 1
	end

	local col
	if att == 0 then
		col = Color(0,117,242)
	elseif att == 1 then
		col = Color(255,25,25)
	else
		col = Color(240,212,5)
	end
   self:SetColor(col)
   
   if IsValid(self.Corpse) and att != 3 then
      local mdl = self.Corpse:GetModel()
      mdl = util.IsValidModel(mdl) and mdl or backup_mdl

      self.Dummy = ClientsideModel(mdl, RENDERGROUP_TRANSLUCENT)
      if not self.Dummy then return end
      self.Dummy:SetPos(data:GetOrigin())
      self.Dummy:SetAngles(ang)
      self.Dummy:AddEffects(EF_NODRAW)

	  if att != 3 then
		  self.Dummy:SetSequence(self.Sequence)
		  self.Dummy:SetCycle(self.Cycle)

		  local pose = data:GetStart()
		  self.Dummy:SetPoseParameter("aim_yaw", pose.x)
		  self.Dummy:SetPoseParameter("aim_pitch", pose.y)
		  self.Dummy:SetPoseParameter("move_yaw", pose.z)
	  end
   else
      self.Dummy = nil
   end
end

function EFFECT:Think()
   if self.EndTime < CurTime() then
      SafeRemoveEntity(self.Dummy)
      return false
   end

   return IsValid(self.Dummy)
end

function EFFECT:Render()
   render.SuppressEngineLighting( true )
   local col = self:GetColor()
   render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
   render.SetBlend( self.Alpha )

   if self.Dummy then
      self.Dummy:DrawModel()
   end

   render.SetBlend(1)
   render.SetColorModulation(1, 1, 1)
   render.SuppressEngineLighting(false)
end

