-- CHAT THINGS

local sm_chat_visible = true

-- Hide Chat
ChatFrame1HideChat = CreateFrame( "Button", ChatFrame1, UIParent )
ChatFrame1HideChat:SetFrameStrata( "LOW" )
ChatFrame1HideChat:SetSize( 32, 32 )
ChatFrame1HideChat:SetPoint( "TOPRIGHT", ChatFrame1, "BOTTOMLEFT", -10, -10 )
ChatFrame1HideChat:HookScript( "OnUpdate", function( self )
	self:SetScale( UIParent:GetScale() )
end )
ChatFrame1HideChat:SetNormalTexture( "Interface\\AddOns\\StreamerMode\\media\\visibility" )
local br = 0.0
ChatFrame1HideChat:GetNormalTexture():SetTexCoord( -br, 1 + br, -br, 1 + br )

local function SMUpdateActiveChatWindows()
	for i = 1, 20 do
		local tab = _G["ChatFrame" .. i .. "Tab"]
		if tab and tab:IsShown() then
			hooksecurefunc( tab, "Show", function( self )
				if sm_chat_visible then
				else
					self:Hide()
				end
			end )
			tab.active = true
		end
	end
end
hooksecurefunc( ChatFrame1, "Show", function( self )
	if sm_chat_visible then
	else
		self:Hide()
	end
end )
--[[hooksecurefunc( ChatFrame1EditBox, "Show", function( self )
	if sm_chat_visible then
	else
		self:Hide()
	end
end )]]
SMUpdateActiveChatWindows()

ChatFrame1HideChat.show = sm_chat_visible
ChatFrame1HideChat:SetScript( "OnClick", function( self, state )
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
		ChatFrame1HideChat:SetNormalTexture( "Interface\\AddOns\\StreamerMode\\media\\visibility" )
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
		ChatFrame1HideChat:SetNormalTexture( "Interface\\AddOns\\StreamerMode\\media\\visibility_off" )
	end
end )

-- CHAT
function SMReplaceCharname( pn, msg, reppn )
	local s, e = strlower( msg ):find( strlower( pn ) )
	if s then
		local b = string.sub( msg, 1, s - 1 )
		local a = string.sub( msg, e + 1 )
		return SMReplaceCharname( pn, b .. reppn .. a, reppn )
	else
		return msg
	end
end

local function myChatFilter(self, event, msg, author, ...)
	local pn = UnitName( "player" )
	if strlower( msg ):find( strlower( pn ) ) then
		msg = SMReplaceCharname( pn, msg, SM_CHARNAME )
		return false, msg, SM_CHARNAME, ...
	end
	if author:find(pn) then
		return false, msg, SM_CHARNAME, ...
	end

	for i = 1, 4 do
		local name = UnitName( "party" .. i )
		local class = UnitClass( "party" .. i )
		if name then
			if strlower( msg ):find( strlower( name ) ) then
				msg = SMReplaceCharname( name, msg, class )
				return false, msg, class, ...
			end
			if author:find(name) then
				return false, msg, class, ...
			end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ITEM_LOOTED", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_SKILL", myChatFilter)

ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_XP_GAIN", myChatFilter)

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

f:SetScript( "OnEvent", function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)
	SetCVar( "chatBubbles", 0 )
end )
