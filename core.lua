-- By D4KiR
-- CONFIG
SM_CHARNAME = "RENAMEME"
-- CONFIG
local function STMOMsg(msg)
	print("|cff3FC7EB[|T132150:16:16:0:0|t |r|cffffff00S|r|cff3FC7EBtreamer|r|cffffff00M|r|cff3FC7EBode]|r " .. msg)
end

local tab_text = {"PlayerName", "TargetFrameTextureFrameName", "FocusFrameTextureFrameName", "TargetFrameToTTextureFrameName", "FocusFrameToTTextureFrameName", "CharacterFrameTitleText", "CharacterNameText", "TargetFrame.TargetFrameContent.TargetFrameContentMain.Name", "FocusFrame.TargetFrameContent.TargetFrameContentMain.Name", "TargetFrameToT.Name", "FocusFrameToT.Name", "MacroFrameTab2.Text", "MacroToolkitFrameTab2.Text",}
-- Addons
local tab_names = {}
local tab_classes = {}
function STMOSetText(self, text)
	if self.sm_settext then return end
	self.sm_settext = true
	local pn, re = UnitName("player")
	local msg = text or self:GetText() or ""
	if msg and msg:find(pn) then
		msg = string.gsub(msg, pn, SM_CHARNAME)
		if re then
			msg = string.gsub(msg, re, "")
			msg = string.gsub(msg, "-", "")
		end

		self:SetText(msg)
	end

	local petn, petre = UnitName("pet")
	if petn and msg and msg:find(petn) then
		msg = string.gsub(msg, petn, string.format(UNITNAME_TITLE_MINION, SM_CHARNAME))
		if petre then
			msg = string.gsub(msg, petre, "")
			msg = string.gsub(msg, "-", "")
		end

		self:SetText(msg)
	end

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
				mmsg = string.gsub(mmsg, name, class)
				if realm then
					mmsg = string.gsub(mmsg, realm, "")
					mmsg = string.gsub(mmsg, "-", "")
				end

				self:SetText(mmsg)
			end
		end
	end

	self.sm_settext = false
end

local function STMOInjectFake(element)
	if element then
		if element.sm_hooked == nil then
			element.sm_hooked = true
			hooksecurefunc(
				element,
				"SetText",
				function(self, text)
					STMOSetText(self, text)
					if _detalhes then
						_detalhes:SetNickname(SM_CHARNAME)
					end
				end
			)
		end

		element:SetText(element:GetText())
	else
		STMOMsg("|cffff0000" .. "ELEMENT INVALID: |r" .. tostring(element))
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
			STMOInjectFake(element)
		end
	end
end

local frame = CreateFrame("FRAME", "NameChangeScripts")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
frame:RegisterEvent("INSPECT_READY")
frame:RegisterEvent("ADDON_LOADED")
local setup = false
local function eventHandler(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local isInitialLogin, isReloadingUi = ...
		if (isInitialLogin or isReloadingUi) and not setup then
			setup = true
			STMOTABPC = STMOTABPC or {}
			STMOTABPC["charname"] = STMOTABPC["charname"] or "RENAMEME"
			SM_CHARNAME = STMOTABPC["charname"]
			STMOMsg("LOADED -> /sm")
			STMOUpdateNames()
			if STMOUpdateGuildInfos then
				STMOUpdateGuildInfos()
			end
		end
	elseif event == "INSPECT_READY" then
		local element = _G["InspectFrameTitleText"]
		if element then
			STMOInjectFake(element)
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
						STMOInjectFake(element)
					end
				end
			end
		end

		if addonName == "Blizzard_MacroUI" then
			STMOUpdateNames()
		end
	end

	for i = 1, 4 do
		local element = _G["PartyMemberFrame" .. i .. "Name"]
		if element then
			local name = UnitName("party" .. i)
			if name then
				STMOInjectFake(element, name)
			end
		end
	end

	for i = 1, 40 do
		local element = _G["CombatRaidFrame" .. i .. "Name"]
		if element then
			local name = UnitName("raid" .. i)
			if name then
				STMOInjectFake(element, name)
			end
		end
	end
end

frame:SetScript("OnEvent", eventHandler)
SLASH_STREAMERMODE1 = "/sm"
SlashCmdList["STREAMERMODE"] = function(msg)
	STMOTABPC = STMOTABPC or {}
	local args = {string.split(" ", msg)}
	if args[1] then
		args[1] = strlower(args[1])
		if strlower(args[1]) == "rename" then
			local hide = false
			if args[2] == nil then
				args[2] = ""
				STMOMsg("[RENAME] HIDING NAME")
				hide = true
			end

			if args[2] then
				STMOTABPC["charname"] = args[2]
				SM_CHARNAME = STMOTABPC["charname"]
				if not hide then
					STMOMsg("|cff00ff00Renamed Character to: |r" .. args[2])
				end

				STMOUpdateNames()
			else
				STMOMsg("[RENAME] Missing Name")
			end

			return true
		end
	end

	STMOMsg("----------------------------------------")
	STMOMsg("HELP:")
	STMOMsg("/sm rename NAME - Renames the current Character")
	STMOMsg("----------------------------------------")

	return false
end

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
