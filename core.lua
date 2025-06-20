-- By D4KiR
local AddonName, StreamerMode = ...
-- CONFIG
SM_CHARNAME = "RENAMEME"
-- CONFIG
local tab_text = {"PlayerName", "TargetFrameTextureFrameName", "FocusFrameTextureFrameName", "TargetFrameToTTextureFrameName", "FocusFrameToTTextureFrameName", "CharacterFrameTitleText", "CharacterNameText", "TargetFrame.TargetFrameContent.TargetFrameContentMain.Name", "FocusFrame.TargetFrameContent.TargetFrameContentMain.Name", "TargetFrameToT.Name", "FocusFrameToT.Name", "MacroFrameTab2.Text", "MacroToolkitFrameTab2.Text",}
-- Addons
local tab_names = {}
local tab_classes = {}
function STMOSetText(self, text)
	if self.sm_settext then return end
	self.sm_settext = true
	local pn, re = UnitName("player")
	local msg = text or self:GetText() or ""
	if msg and msg:find(pn) or self == PlayerName then
		msg = string.gsub(msg, pn, SM_CHARNAME)
		if text then
			msg = string.gsub(msg, text, SM_CHARNAME)
		end

		if re then
			msg = string.gsub(msg, re, "")
			msg = string.gsub(msg, "-", "")
		end

		self:SetText(msg)
	else
		local petn, petre = UnitName("pet")
		if petn and msg and msg:find(petn) then
			msg = string.gsub(msg, petn, string.format(UNITNAME_TITLE_MINION, SM_CHARNAME))
			if petre then
				msg = string.gsub(msg, petre, "")
				msg = string.gsub(msg, "-", "")
			end

			self:SetText(msg)
		else
			if IsInRaid() then
				for i = 1, 40 do
					local name, realm = UnitName("raid" .. i)
					if name or tab_names["raid" .. i] then
						tab_names["raid" .. i] = name or tab_names["raid" .. i]
						name = name or tab_names["raid" .. i]
						local class, _ = UnitClass("raid" .. i)
						tab_classes["raid" .. i] = class or tab_classes["raid" .. i]
						class = tab_classes["raid" .. i]
						local mmsg = text or self:GetText() or ""
						if name and class and mmsg and mmsg:find(name) then
							mmsg = string.gsub(mmsg, name, class .. " " .. i)
							if realm then
								mmsg = string.gsub(mmsg, realm, "")
								mmsg = string.gsub(mmsg, "-", "")
							end

							self:SetText(mmsg)
						end
					end
				end
			else
				for i = 1, 4 do
					local name, realm = UnitName("party" .. i)
					if name or tab_names["party" .. i] then
						tab_names["party" .. i] = name or tab_names["party" .. i]
						name = name or tab_names["party" .. i]
						local class, _ = UnitClass("party" .. i)
						tab_classes["party" .. i] = class or tab_classes["party" .. i]
						class = tab_classes["party" .. i]
						local mmsg = text or self:GetText() or ""
						if name and class and mmsg and mmsg:find(name) then
							mmsg = string.gsub(mmsg, name, class .. " " .. i)
							if realm then
								mmsg = string.gsub(mmsg, realm, "")
								mmsg = string.gsub(mmsg, "-", "")
							end

							self:SetText(mmsg)
						end
					end
				end
			end
		end
	end

	self.sm_settext = false
end

local injects = {}
function StreamerMode:InjectText(element)
	if element then
		if element.sm_hooked == nil then
			element.sm_hooked = true
			hooksecurefunc(
				element,
				"SetText",
				function(sel, text)
					text = text or ""
					STMOSetText(sel, text)
					if _detalhes then
						-- DETAILS
						_detalhes:SetNickname(SM_CHARNAME)
					end
				end
			)
		end

		element:SetText(StreamerMode:GetText(element))
		if not tContains(injects, element) then
			tinsert(injects, element)
		end
	else
		StreamerMode:MSG("|cffff0000" .. "ELEMENT INVALID: |r" .. tostring(element))
	end
end

local function STMOUpdateNames()
	for i, tf in pairs(tab_text) do
		local spl = {string.split(".", tf)}
		local element = nil
		for id, v in pairs(spl) do
			if id == 1 then
				element = _G[v]
			elseif element then
				element = element[v]
			end
		end

		if element then
			StreamerMode:InjectText(element)
		end
	end

	for i, element in pairs(injects) do
		if element then
			StreamerMode:InjectText(element)
		end
	end
end

local inited = false
local function Init()
	if inited == false then
		inited = true
		STMOTABPC = STMOTABPC or {}
		STMOTABPC["charname"] = STMOTABPC["charname"] or "RENAMEME"
		SM_CHARNAME = STMOTABPC["charname"]
		StreamerMode:SetVersion(132150, "1.1.7")
		StreamerMode:SetAddonOutput("StreamerMode", 132150)
		StreamerMode:CreateMinimapButton(
			{
				["name"] = "StreamerMode",
				["icon"] = 132150,
				["var"] = mmbtn,
				["dbtab"] = STMOTABPC,
				["vTT"] = {{"|T132150:16:16:0:0|t S|cff3FC7EBtreamer|rM|cff3FC7EBode|r by |cff3FC7EBD4KiR", "v|cff3FC7EB" .. StreamerMode:GetVersion()}, {StreamerMode:Trans("LID_LEFTCLICK"), StreamerMode:Trans("LID_OPENSETTINGS")}, {StreamerMode:Trans("LID_RIGHTCLICK"), StreamerMode:Trans("LID_HIDEMINIMAPBUTTON")}},
				["funcL"] = function()
					StreamerMode:ToggleSettings()
				end,
				["funcR"] = function()
					StreamerMode:SV(STMOTABPC, "SHOWMINIMAPBUTTON", false)
					StreamerMode:HideMMBtn("StreamerMode")
					StreamerMode:MSG("Minimap Button is now hidden.")
				end,
				["dbkey"] = "SHOWMINIMAPBUTTON"
			}
		)

		STMOTABPC["COUNTSETTINGS"] = STMOTABPC["COUNTSETTINGS"] or 0
		STMOTABPC["COUNTSETTINGS"] = STMOTABPC["COUNTSETTINGS"] + 1
		if STMOTABPC["COUNTSETTINGS"] < 10 then
			StreamerMode:MSG("LOADED -> /sm")
		end

		StreamerMode:InitSettings()
		STMOUpdateNames()
		if STMOUpdateGuildInfos then
			STMOUpdateGuildInfos()
		end
	end
end

local frame = CreateFrame("FRAME", "NameChangeScripts")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
frame:RegisterEvent("INSPECT_READY")
frame:RegisterEvent("ADDON_LOADED")
local function eventHandler(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local isInitialLogin, isReloadingUi = ...
		if isInitialLogin or isReloadingUi then
			Init()
		end
	elseif event == "INSPECT_READY" then
		local element = _G["InspectFrameTitleText"]
		if element then
			StreamerMode:InjectText(element)
		end
	elseif event == "ADDON_LOADED" then
		local addonName = ...
		if not addonName then return end
		if addonName == "Blizzard_Communities" then
			local element = _G["CommunitiesFrame"]
			if element then
				element = element["GuildMemberDetailFrame"]
				if element then
					element = element["Name"]
					if element then
						StreamerMode:InjectText(element)
					end
				end
			end
		end

		if addonName == "Blizzard_MacroUI" then
			STMOUpdateNames()
		end

		if addonName == AddonName then
			Init()
		end
	end

	for i = 1, 4 do
		local element = _G["PartyMemberFrame" .. i .. "Name"]
		if element then
			local name = UnitName("party" .. i)
			if name then
				StreamerMode:InjectText(element)
			end
		end
	end

	for i = 1, 40 do
		local element = _G["CombatRaidFrame" .. i .. "Name"]
		if element then
			local name = UnitName("raid" .. i)
			if name then
				StreamerMode:InjectText(element)
			end
		end
	end
end

local function Rename(msg, hide)
	STMOTABPC = STMOTABPC or {}
	local args = {string.split(" ", msg)}
	if hide or SM_CHARNAME ~= args[1] then
		if args[1] then
			if hide then
				SM_CHARNAME = ""
			else
				STMOTABPC["charname"] = args[1]
				SM_CHARNAME = STMOTABPC["charname"]
			end

			StreamerMode:MSG("|cff00ff00Renamed Character to: |r" .. args[1])
			STMOUpdateNames()
		else
			StreamerMode:MSG("[RENAME] Missing Name")
		end
	end

	return true
end

local sm_settings = nil
function StreamerMode:ToggleSettings()
	if sm_settings then
		if sm_settings:IsShown() then
			sm_settings:Hide()
		else
			sm_settings:Show()
		end
	end
end

function StreamerMode:InitSettings()
	if STMOTABPC["HIDECHARACTERNAME"] == nil then
		STMOTABPC["HIDECHARACTERNAME"] = false
	end

	sm_settings = StreamerMode:CreateFrame(
		{
			["name"] = "StreamerMode",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = format("S|cff3FC7EBtreamer|rM|cff3FC7EBode|r |T132150:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t v|cff3FC7EB%s", StreamerMode:GetVersion())
		}
	)

	local x = 15
	local y = 10
	StreamerMode:SetAppendX(x)
	StreamerMode:SetAppendY(y)
	StreamerMode:SetAppendParent(sm_settings)
	StreamerMode:SetAppendTab(STMOTABPC)
	StreamerMode:AppendCategory("GENERAL")
	StreamerMode:AppendCheckbox(
		"SHOWMINIMAPBUTTON",
		StreamerMode:GetWoWBuild() ~= "RETAIL",
		function()
			if StreamerMode:GV(STMOTABPC, "SHOWMINIMAPBUTTON", StreamerMode:GetWoWBuild() ~= "RETAIL") then
				StreamerMode:ShowMMBtn("StreamerMode")
			else
				StreamerMode:HideMMBtn("StreamerMode")
			end
		end
	)

	StreamerMode:AppendCheckbox(
		"HIDECHARACTERNAME",
		false,
		function(sel, val)
			if val then
				sm_settings.renameeb:Hide()
				Rename("", true)
			else
				sm_settings.renameeb:Show()
				Rename(STMOTABPC["charname"])
			end
		end
	)

	_, sm_settings.renameeb = StreamerMode:AppendEditbox(
		"charname",
		"RENAMEME",
		function(sel, val)
			Rename(val)
		end, x + 10
	)

	if STMOTABPC["HIDECHARACTERNAME"] then
		sm_settings.renameeb:Hide()
	else
		sm_settings.renameeb:Show()
	end
end

local function Slash()
	STMOTABPC = STMOTABPC or {}
	StreamerMode:ToggleSettings()

	return false
end

frame:SetScript("OnEvent", eventHandler)
StreamerMode:AddSlash("sm", Slash)
StreamerMode:AddSlash("streamermode", Slash)
hooksecurefunc(
	FriendsFrameBattlenetFrame.Tag,
	"SetText",
	function(self, text)
		if self.sm_settext then return end
		self.sm_settext = true
		if text then
			self:SetText("########")
		end

		self.sm_settext = false
	end
)
