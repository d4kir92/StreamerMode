-- Guild

function STMOUpdateGuildInfos()
	if CommunitiesFrame then
		if CommunitiesFrameScrollChild then
			local glist = { CommunitiesFrameScrollChild:GetChildren() }

			local count = 0
			for i, v in pairs( glist ) do
				count = count + 1
				if v["NameFrame"].Name.sm_hooked == nil then
					v["NameFrame"].Name.sm_hooked = true
					hooksecurefunc( v["NameFrame"].Name, "SetText", function( self, text )
						STMOSetText( self, text )
					end )
				end
				v["NameFrame"].Name:SetText( v["NameFrame"].Name:GetText() )
			end
			C_Timer.After( 0.1, STMOUpdateGuildInfos )
		else
			C_Timer.After( 0.3, STMOUpdateGuildInfos )
		end
	else
		C_Timer.After( 0.5, STMOUpdateGuildInfos )
	end
end
