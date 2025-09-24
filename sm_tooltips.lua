local _, StreamerMode = ...
-- Tooltips
function SMGTThink()
	for i, tex in pairs({GameTooltip:GetRegions()}) do
		if tex.GetText and tex then
			local msg = tex:GetText()
			local name = UnitName("player")
			if msg and msg:find(name) then
				StreamerMode:SetText(tex, msg)
			end
		end
	end
end

if GameTooltip.AddDoubleLine then
	hooksecurefunc(
		GameTooltip,
		"AddDoubleLine",
		function()
			SMGTThink()
		end
	)
end

if GameTooltip.AddLine then
	hooksecurefunc(
		GameTooltip,
		"AddLine",
		function()
			SMGTThink()
		end
	)
end

if GameTooltip.AppendText then
	hooksecurefunc(
		GameTooltip,
		"AppendText",
		function()
			SMGTThink()
		end
	)
end

if GameTooltip.SetText then
	hooksecurefunc(
		GameTooltip,
		"SetText",
		function()
			SMGTThink()
		end
	)
end

local f = CreateFrame("FRAME")
f:SetScript(
	"OnUpdate",
	function()
		local text = DropDownList1Button1NormalText:GetText()
		if text and f.text ~= text then
			f.text = text
			StreamerMode:SetText(DropDownList1Button1NormalText, text)
		end
	end
)
