include("sh_specdm.lua")

local table = table
local surface = surface
local draw = draw
local math = math
local string = string

local bg_colors = {
   background_main = Color(0, 0, 10, 200),

   noround = Color(100,100,100,200),
   traitor = Color(200, 25, 25, 200),
   innocent = Color(25, 200, 25, 200),
   detective = Color(25, 25, 200, 200)
};

local health_colors = {
   border = COLOR_WHITE,
   background = Color(100, 25, 25, 222),
   fill = Color(200, 50, 50, 250)
};

local ammo_colors = {
   border = COLOR_WHITE,
   background = Color(20, 20, 5, 222),
   fill = Color(205, 155, 0, 255)
};

-- Modified RoundedBox
local Tex_Corner8 = surface.GetTextureID( "gui/corner8" )
local function RoundedMeter( bs, x, y, w, h, color)
   surface.SetDrawColor(clr(color))

   surface.DrawRect( x+bs, y, w-bs*2, h )
   surface.DrawRect( x, y+bs, bs, h-bs*2 )

   surface.SetTexture( Tex_Corner8 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + bs/2, bs, bs, 0 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + h -bs/2, bs, bs, 90 )

   if w > 14 then
      surface.DrawRect( x+w-bs, y+bs, bs, h-bs*2 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + bs/2, bs, bs, 270 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + h - bs/2, bs, bs, 180 )
   else
      surface.DrawRect( x + math.max(w-bs, bs), y, bs/2, h )
   end

end

-- Paints a graphical meter bar
local function PaintBar(x, y, w, h, colors, value)
   -- Background
   -- slightly enlarged to make a subtle border
   draw.RoundedBox(8, x-1, y-1, w+2, h+2, colors.background)

   -- Fill
   local width = w * math.Clamp(value, 0, 1)

   if width > 0 then
      RoundedMeter(8, x, y, width, h, colors.fill)
   end
end

-- Returns player's ammo information
local function GetAmmo(ply)
   local weap = ply:GetActiveWeapon()
   if not weap or not ply:Alive() then return -1 end

   local ammo_inv = weap:Ammo1() or 0
   local ammo_clip = weap:Clip1() or 0
   local ammo_max = weap.Primary.ClipSize or 0

   return ammo_clip, ammo_max, ammo_inv
end

local function DrawBg(x, y, width, height, client)
	local th = 30
	local tw = 170
	y = y - th
	height = height + th
	draw.RoundedBox(8, x, y, width, height, bg_colors.background_main)
	local col = bg_colors.innocent
	if LocalPlayer():IsGhost() then
	elseif GAMEMODE.round_state != ROUND_ACTIVE then
		col = bg_colors.noround
	elseif LocalPlayer():GetTraitor() then
		col = bg_colors.traitor
	elseif LocalPlayer():GetDetective() then
		col = bg_colors.detective
	end
	draw.RoundedBox(8, x, y, tw, th, col)
end

local dr = draw
local function ShadowedText(text, font, x, y, color, xalign, yalign)
	dr.SimpleText(text, font, x+2, y+2, COLOR_BLACK, xalign, yalign)
	dr.SimpleText(text, font, x, y, color, xalign, yalign)
end

hook.Add("Initialize", "ESInitialize", function()
	if (ESConfig.HookHud) then
		local GetTranslation = LANG.GetTranslation
		local GetPTranslation = LANG.GetParamTranslation
		local GetLang = LANG.GetUnsafeLanguageTable
		local interp = string.Interp
		local ttt_health_label = GetConVar("ttt_health_label")
		local margin = 10

		local roundstate_string = {
		   [ROUND_WAIT]   = "round_wait",
		   [ROUND_PREP]   = "round_prep",
		   [ROUND_ACTIVE] = "round_active",
		   [ROUND_POST]   = "round_post"
		};

		local OriginalDrawHUD = GAMEMODE.HUDPaint
		function GAMEMODE:HUDPaint()
			if LocalPlayer():IsGhost() then
				TIPS.Hide()
				--WSWITCH:Enable()
				
				local client = LocalPlayer()

				self:HUDDrawTargetID()

				MSTACK:Draw(client)

				RADAR:Draw(client)
				TBHUD:Draw(client)
				WSWITCH:Draw(client)

				VOICE.Draw(client)
				DISGUISE.Draw(client)

				self:HUDDrawPickupHistory()

				local L = GetLang()

			   local width = 250
			   local height = 90

			   local x = margin
			   local y = ScrH() - margin - height

			   DrawBg(x, y, width, height, client)

			   local bar_height = 25
			   local bar_width = width - (margin*2)

			   -- Draw health
			   local health = math.max(0, client:Health())
			   local health_y = y + margin

			   PaintBar(x + margin, health_y, bar_width, bar_height, health_colors, health/100)

			   ShadowedText(tostring(health), "HealthAmmo", bar_width, health_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

			   if ttt_health_label:GetBool() then
			      local health_status = util.HealthToString(health)
			      draw.SimpleText(L[health_status], "TabLarge", x + margin*2, health_y + bar_height/2, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			   end

			   -- Draw ammo
			   if client:GetActiveWeapon().Primary then
			      local ammo_clip, ammo_max, ammo_inv = GetAmmo(client)
			      if ammo_clip != -1 then
			         local ammo_y = health_y + bar_height + margin
			         PaintBar(x+margin, ammo_y, bar_width, bar_height, ammo_colors, ammo_clip/ammo_max)
			         local text = string.format("%i + %02i", ammo_clip, ammo_inv)

			         ShadowedText(text, "HealthAmmo", bar_width, ammo_y, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
			      end
			   end

			   -- Draw traitor state
			   local round_state = GAMEMODE.round_state

			   local traitor_y = y - 30
			   local text = nil
			   if round_state == ROUND_ACTIVE then
			      text = L[ client:GetRoleStringRaw() ]
			   else
			      text = L[ roundstate_string[round_state] ]
			   end

			   if (client:IsGhost()) then
			   	  text = ESConfig.HUDName
			   end

			   ShadowedText(text, "TraitorState", x + margin + 73, traitor_y, COLOR_WHITE, TEXT_ALIGN_CENTER)

			   -- Draw round time
			   local is_haste = HasteMode() and round_state == ROUND_ACTIVE
			   local is_traitor = client:IsActiveTraitor()

			   local endtime = GetGlobalFloat("ttt_round_end", 0) - CurTime()

			   local text
			   local font = "TimeLeft"
			   local color = COLOR_WHITE
			   local rx = x + margin + 170
			   local ry = traitor_y + 3

			   -- Time displays differently depending on whether haste mode is on,
			   -- whether the player is traitor or not, and whether it is overtime.
			   if is_haste then
			      local hastetime = GetGlobalFloat("ttt_haste_end", 0) - CurTime()
			      if hastetime < 0 then
			         if (not is_traitor) or (math.ceil(CurTime()) % 7 <= 2) then
			            -- innocent or blinking "overtime"
			            text = L.overtime
			            font = "Trebuchet18"

			            -- need to hack the position a little because of the font switch
			            ry = ry + 5
			            rx = rx - 3
			         else
			            -- traitor and not blinking "overtime" right now, so standard endtime display
			            text  = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
			            color = COLOR_RED
			         end
			      else
			         -- still in starting period
			         local t = hastetime
			         if is_traitor and math.ceil(CurTime()) % 6 < 2 then
			            t = endtime
			            color = COLOR_RED
			         end
			         text = util.SimpleTime(math.max(0, t), "%02i:%02i")
			      end
			   else
			      -- bog standard time when haste mode is off (or round not active)
			      text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
			   end

			   ShadowedText(text, font, rx, ry, color)

			   if is_haste then
			      dr.SimpleText(L.hastemode, "TabLarge", x + margin + 165, traitor_y - 8)
			   end
				return
			end
			return OriginalDrawHUD(self)
		end
	end


	local OriginalHUDDrawTargetID = GAMEMODE.HUDDrawTargetID
	function GAMEMODE:HUDDrawTargetID()
		local trace = LocalPlayer():GetEyeTrace(MASK_SHOT)
		local ent = trace.Entity

		if IsValid(ent) and ent:IsPlayer() and ent:IsGhost() and not LocalPlayer():IsGhost() then
			return
		else
			OriginalHUDDrawTargetID(self)
		end
	end
	
	function GAMEMODE:PlayerBindPress(ply, bind, pressed)
      if not IsValid(ply) then return end

      if bind == "invnext" and pressed then
         if ply:IsSpec() and not ply:IsGhost() then
            TIPS.Next()
         else
            WSWITCH:SelectNext()
         end
         return true
      elseif bind == "invprev" and pressed then
         if ply:IsSpec() and not ply:IsGhost() then
            TIPS.Prev()
         else
            WSWITCH:SelectPrev()
         end
         return true
      elseif bind == "+attack" then
         if WSWITCH.Show then
            if not pressed then
               WSWITCH:ConfirmSelection()
            end
            return true
         end
      elseif bind == "+sprint" then
         ply.traitor_gvoice = false
         RunConsoleCommand("tvog", "0")
         return true
      elseif bind == "+use" and pressed then
         if ply:IsSpec() and not ply:IsGhost() then
            RunConsoleCommand("ttt_spec_use")
            return true
         elseif TBHUD:PlayerIsFocused() and not ply:IsGhost()  then
            return TBHUD:UseFocused()
         end
      elseif string.sub(bind, 1, 4) == "slot" and pressed then
         local idx = tonumber(string.sub(bind, 5, -1)) or 1
         if RADIO.Show then
            RADIO:SendCommand(idx)
         else
            WSWITCH:SelectSlot(idx)
         end
         return true
      elseif string.find(bind, "zoom") and pressed then
         RADIO:ShowRadioCommands(not RADIO.Show)
         return true
      elseif bind == "+voicerecord" then
         if not VOICE.CanSpeak() and not ply:IsGhost() then
            return true
         end
      elseif bind == "gm_showteam" and pressed and ply:IsSpec() then
         local m = VOICE.CycleMuteState()
         RunConsoleCommand("ttt_mute_team", m)
         return true
      elseif bind == "+duck" and pressed and (ply:IsSpec() and not ply:IsGhost()) then
         if not IsValid(ply:GetObserverTarget()) then
            if self.ForcedMouse then
               gui.EnableScreenClicker(false)
               self.ForcedMouse = false
            else
               gui.EnableScreenClicker(true)
               self.ForcedMouse = true
            end
         end
      elseif bind == "messagemode" and pressed and ply:IsSpec() and not ply:IsGhost()  then
         if self.round_state == ROUND_ACTIVE and DetectiveMode()then
            LANG.Msg("spec_teamchat_hint")
            return true
         end
      elseif bind == "noclip" and pressed and not ply:IsGhost() then
         if not GetConVar("sv_cheats"):GetBool() then
            RunConsoleCommand("ttt_equipswitch")
            return true
         end
      elseif (bind == "gmod_undo" or bind == "undo") and pressed and not ply:IsGhost() then
         RunConsoleCommand("ttt_dropammo")
         return true
      end
   end
end)