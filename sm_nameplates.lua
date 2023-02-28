-- Nameplates

local function SMGetConvar( name )
	return tonumber( GetCVar( name ) )
end

local f = CreateFrame( "FRAME" )
f:SetScript( "OnUpdate", function()
	if not InCombatLockdown() then
		if SMGetConvar( "UnitNameOwn" ) ~= 0 then
			SetCVar( "UnitNameOwn", 0 )
		end
		if SMGetConvar( "UnitNameFriendlyPlayerName" ) ~= 0 then
			--SetCVar( "UnitNameFriendlyPlayerName", 0 )
		end
		if SMGetConvar( "UnitNameFriendlyMinionName" ) ~= 0 then
			--SetCVar( "UnitNameFriendlyMinionName", 0 )
		end
		if SMGetConvar( "UnitNameNonCombatCreatureName" ) ~= 0 then
			--SetCVar( "UnitNameNonCombatCreatureName", 0 )
		end
	end
end )

hooksecurefunc( "CompactUnitFrame_UpdateName", function(frame)
	if ShouldShowName(frame) then
		if frame.name.sm_hooked == nil and UnitIsPlayer(frame.unit) then
			frame.name.sm_hooked = true

			hooksecurefunc( frame.name, "SetAlpha", function( self, a )
				if self.setalpha then return end
				self.setalpha = true
				self:SetAlpha(0)
				self.setalpha = true
			end )
		end
		local pn = UnitName( "player" )
		if frame.name:GetText() and strfind( frame.name:GetText(), SM_CHARNAME, 1, true ) then
			frame.name:SetText( SMReplaceCharname( frame.name:GetText(), pn, SM_CHARNAME ) )
		end
		if UnitIsPlayer(frame.unit) then
			frame.name:SetAlpha(0)
		end
	end
end )
