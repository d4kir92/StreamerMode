-- Nameplates
local _, StreamerMode = ...
local function SMGetConvar(name)
	return tonumber(GetCVar(name))
end

local f = CreateFrame("FRAME")
f:SetScript(
	"OnUpdate",
	function()
		if not InCombatLockdown() and SMGetConvar("UnitNameOwn") ~= 0 then
			SetCVar("UnitNameOwn", 0)
		end
	end
)

hooksecurefunc(
	"CompactUnitFrame_UpdateName",
	function(frame)
		if frame and ShouldShowName(frame) and StreamerMode:GetText(frame.name) and UnitIsPlayer(frame.unit) then
			StreamerMode:InjectText(frame.name)
		end
	end
)
