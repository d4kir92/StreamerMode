-- Scoreboards

--LoadAddOn("Blizzard_PVPMatch")

if PVPCellNameMixin then
	hooksecurefunc( PVPCellNameMixin, "Populate", function( self, rowData, dataIndex )
		local name = rowData.name;
		local element = self.text;
		if element.sm_hooked == nil then
			element.sm_hooked = true
			hooksecurefunc( element, "SetText", function( self, text )
				if text then
					STMOSetText( self, text )
				end
			end )
		end
		element:SetText( name )
	end )
else
	--STMOMsg( "PVPCellNameMixin not found!" )
end
--PVPMatchResults:Show()
