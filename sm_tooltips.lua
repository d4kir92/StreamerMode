-- Tooltips

local test = {
	"GameTooltipTextLeft1",
	"GameTooltipTextLeft2",
	"GameTooltipTextLeft3",
	"GameTooltipTextLeft4",
	"GameTooltipTextRight1",
	"GameTooltipTextRight2",
	"GameTooltipTextRight3",
	"GameTooltipTextRight4",
}
function SMTooltipThink()
	for i, v in pairs( test ) do
		local tex = _G[v]
		if tex then
			local msg = tex:GetText()
			if msg then
				STMOSetText( tex, msg )
			end
		end
	end
	C_Timer.After( 0.05, SMTooltipThink )
end
C_Timer.After( 0, SMTooltipThink )

local f = CreateFrame( "FRAME" )
f:SetScript( "OnUpdate", function()
	if DropDownList1Button1NormalText:GetText() then
		STMOSetText( DropDownList1Button1NormalText, DropDownList1Button1NormalText:GetText() )
	end
end )
