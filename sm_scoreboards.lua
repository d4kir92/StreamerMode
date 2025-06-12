-- Scoreboards
--LoadAddOn("Blizzard_PVPMatch")
function SMPVPScoreboard()
	if PVPCellNameMixin then
		hooksecurefunc(
			PVPCellNameMixin,
			"Populate",
			function(self, rowData, dataIndex)
				local element = self.text
				if element.sm_hooked == nil then
					element.sm_hooked = true
					hooksecurefunc(
						element,
						"SetText",
						function(sel, text)
							if text then
								STMOSetText(sel, text)
							else
								STMOSetText(sel, sel.oldtext or "")
							end

							sel.oldtext = text or ""
						end
					)
				end

				element:SetText(element:GetText())
			end
		)
	end
end

SMPVPScoreboard()
--PVPMatchResults:Show()
