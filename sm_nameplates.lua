-- Nameplates
local _, StreamerMode = ...
local function SMGetConvar(name)
	return tonumber(GetCVar(name))
end

local f = CreateFrame("FRAME")
f:SetScript(
	"OnUpdate",
	function()
		if not InCombatLockdown() then
			if SMGetConvar("UnitNameOwn") ~= 0 then
				SetCVar("UnitNameOwn", 0)
				StreamerMode:MSG("Set UnitNameOwn to 0: Addons cant hide those names")
			end

			if SMGetConvar("UnitNameFriendlyPlayerName") ~= 0 then
				SetCVar("UnitNameFriendlyPlayerName", 0)
				StreamerMode:MSG("Set UnitNameFriendlyPlayerName to 0: Addons cant hide those names")
			end

			if SMGetConvar("UnitNameFriendlyMinionName") ~= 0 then
				SetCVar("UnitNameFriendlyMinionName", 0)
				StreamerMode:MSG("Set UnitNameFriendlyMinionName to 0: Addons cant hide those names")
			end

			if SMGetConvar("UnitNameNonCombatCreatureName") ~= 0 then
				SetCVar("UnitNameNonCombatCreatureName", 0)
				StreamerMode:MSG("Set UnitNameNonCombatCreatureName to 0: Addons cant hide those names")
			end

			if SMGetConvar("UnitNameEnemyPlayerName") ~= 0 then
				SetCVar("UnitNameEnemyPlayerName", 0)
				StreamerMode:MSG("Set UnitNameEnemyPlayerName to 0: Addons cant hide those names")
			end
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
