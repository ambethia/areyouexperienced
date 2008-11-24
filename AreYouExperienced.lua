local f = CreateFrame("frame", "AreYouExperienced")
local peeps = {}
local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("AreYouExperienced", {
  icon = "Interface\\Icons\\INV_Misc_PocketWatch_02",
  text = "Are You Experienced?"
})

f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(self, event, ...)
  if self[event] then
    return self[event](self, event, ...)
  end
end)

function dataobj:OnTooltipShow()
  self:AddDoubleLine("Player", "Level")
  for player, xp in pairs(peeps) do
    self:AddDoubleLine(player, xp);
  end
end

function f:PLAYER_LOGIN()
  self:RegisterEvent("PLAYER_XP_UPDATE")
  self:RegisterEvent("CHAT_MSG_ADDON")
  self:PLAYER_XP_UPDATE()

  self:UnregisterEvent("PLAYER_LOGIN")
  self.PLAYER_LOGIN = nil
end

function f:PLAYER_XP_UPDATE()
  local xpp = string.format("%d.%d", UnitLevel("player"), UnitXP("player")/UnitXPMax("player")*100)
  SendAddonMessage("AreYouExperienced", xpp, "RAID") -- falls back to party
  if (IsInGuild()) then SendAddonMessage("AreYouExperienced", xpp, "GUILD") end
end

function f:CHAT_MSG_ADDON(prefix, message, type, sender)
  if prefix == "AreYouExperienced" then peeps[sender] = message end
end
