local _, StreamerMode = ...
-- CHAT THINGS
local sm_chat_visible = true
-- Hide Chat
ChatFrame1HideChat = CreateFrame("Button", ChatFrame1, UIParent)
ChatFrame1HideChat:SetFrameStrata("LOW")
ChatFrame1HideChat:SetSize(32, 32)
ChatFrame1HideChat:SetPoint("TOPRIGHT", ChatFrame1, "BOTTOMLEFT", -10, -10)
ChatFrame1HideChat:HookScript(
	"OnUpdate",
	function(self)
		self:SetScale(UIParent:GetScale())
	end
)

ChatFrame1HideChat:SetNormalTexture("Interface\\AddOns\\StreamerMode\\media\\visibility")
local br = 0.0
ChatFrame1HideChat:GetNormalTexture():SetTexCoord(-br, 1 + br, -br, 1 + br)
local function SMUpdateActiveChatWindows()
	for i = 1, 20 do
		local tab = _G["ChatFrame" .. i .. "Tab"]
		if tab and tab:IsShown() then
			hooksecurefunc(
				tab,
				"Show",
				function(self)
					if not sm_chat_visible then
						self:Hide()
					end
				end
			)

			tab.active = true
		end
	end
end

hooksecurefunc(
	ChatFrame1,
	"Show",
	function(self)
		if not sm_chat_visible then
			self:Hide()
		end
	end
)

SMUpdateActiveChatWindows()
ChatFrame1HideChat.show = sm_chat_visible
ChatFrame1HideChat:SetScript(
	"OnClick",
	function(self, state)
		self.show = not self.show
		if self.show then
			sm_chat_visible = true
			for i = 1, 20 do
				local tab = _G["ChatFrame" .. i .. "Tab"]
				if tab and tab.active then
					tab:Show()
				end
			end

			SMUpdateActiveChatWindows()
			ChatFrame1:Show()
			--ChatFrame1EditBox:Show()
			ChatFrame1HideChat:SetNormalTexture("Interface\\AddOns\\StreamerMode\\media\\visibility")
		else
			sm_chat_visible = false
			for i = 1, 10 do
				local tab = _G["ChatFrame" .. i .. "Tab"]
				if tab.active then
					tab:Hide()
				end
			end

			ChatFrame1:Hide()
			--ChatFrame1EditBox:Hide()
			ChatFrame1HideChat:SetNormalTexture("Interface\\AddOns\\StreamerMode\\media\\visibility_off")
		end
	end
)

-- CHAT
function StreamerMode:ReplaceCharname(msg, pn, reppn, from)
	if msg == nil then return msg end
	if msg == reppn then return msg end
	local s, e = strlower(msg):find(strlower(pn))
	if s then
		local b = string.sub(msg, 1, s - 1)
		local a = string.sub(msg, e + 1)
		if b and a then
			return StreamerMode:ReplaceCharname(b .. reppn .. a, pn, reppn, from)
		elseif b then
			return StreamerMode:ReplaceCharname(b .. reppn, pn, reppn, from)
		elseif a then
			return StreamerMode:ReplaceCharname(reppn .. a, pn, reppn, from)
		else
			return msg
		end
	else
		return msg
	end
end

local function myChatFilter(self, event, msg, author, ...)
	local pn = UnitName("player")
	if strlower(msg):find(strlower(pn)) then
		msg = StreamerMode:ReplaceCharname(msg, pn, SM_CHARNAME, "CHAT1")

		return false, msg, SM_CHARNAME, ...
	end

	if author:find(pn) then return false, msg, SM_CHARNAME, ... end
	for i = 1, 4 do
		local name, _ = UnitName("party" .. i)
		local class = UnitClass("party" .. i)
		if name then
			if strlower(msg):find(strlower(name)) then
				msg = StreamerMode:ReplaceCharname(msg, name, class, "CHAT2")

				return false, msg, class, ...
			end

			if author:find(name) then return false, msg, class, ... end
		end
	end
end

for name, val in pairs(_G) do
	if name and type(name) == "string" and strfind(name, "CHAT_MSG_", 1, true) then
		ChatFrame_AddMessageEventFilter(name, myChatFilter)
	end
end

-- CHAT BUBBLES
local events = {
	CHAT_MSG_SAY = "chatBubbles",
	CHAT_MSG_YELL = "chatBubbles",
	CHAT_MSG_PARTY = "chatBubblesParty",
	CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
	CHAT_MSG_MONSTER_SAY = "chatBubbles",
	CHAT_MSG_MONSTER_YELL = "chatBubbles",
	CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
}

local f = CreateFrame("Frame")
for event, cvar in pairs(events) do
	f:RegisterEvent(event)
end

f:SetScript("OnEvent", function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid) end) --SetCVar( "chatBubbles", 0 )
-- QUESTS
if QuestInfoObjectivesText then
	hooksecurefunc(
		QuestInfoObjectivesText,
		"SetText",
		function(self, text)
			if self.smsettext then return end
			self.smsettext = true
			local pn = UnitName("player")
			if text then
				self:SetText(StreamerMode:ReplaceCharname(text, pn, SM_CHARNAME, "QuestInfo"))
			end

			self.smsettext = false
		end
	)
end

if QuestInfoDescriptionText then
	hooksecurefunc(
		QuestInfoDescriptionText,
		"SetText",
		function(self, text)
			if self.smsettext then return end
			self.smsettext = true
			local pn = UnitName("player")
			if text then
				self:SetText(StreamerMode:ReplaceCharname(text, pn, SM_CHARNAME, "Desc"))
			end

			self.smsettext = false
		end
	)
end
