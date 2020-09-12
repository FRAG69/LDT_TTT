include('shared.lua')

function ENT:Draw()
	self.Entity:DrawModel() 
end

local function ReceiveTripWarn(um)
   local idx = um:ReadShort()
   local armed = um:ReadBool()

   if armed then
      local pos = um:ReadVector()

      RADAR.bombs[idx] = {pos=pos, t=nil}
   else
      RADAR.bombs[idx] = nil
   end

   RADAR.bombs_count = table.Count(RADAR.bombs)
end
usermessage.Hook("trip_warn", ReceiveTripWarn)