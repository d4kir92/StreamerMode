-- Scoreboards

--LoadAddOn("Blizzard_PVPMatch")
function SMPVPScoreboard()
	if PVPCellNameMixin then
		hooksecurefunc( PVPCellNameMixin, "Populate", function( self, rowData, dataIndex )
			local name = rowData.name;
			local element = self.text;
			if element.sm_hooked == nil then
				element.sm_hooked = true
				hooksecurefunc( element, "SetText", function( self, text )
					if text then
						STMOSetText( self, text )
					else
						STMOSetText( self, self.oldtext or "" )
					end
					self.oldtext = text or ""
				end )
			end
			element:SetText( element:GetText() )
		end )
	else
		--STMOMsg( "PVPCellNameMixin not found!" )
	end
end
SMPVPScoreboard()
--PVPMatchResults:Show()
