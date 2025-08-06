local addon_name, a = ...
mea_database = mea_database or {}

-- TODO:
-- Since recently (May 2025) I noticed that I have to keep the mouse button pressed for 0.5s or so.
-- Unclear when this started, and if it depends on Baganator, on server lag, on a change introduced with 11.1.5,
-- if it's a Mac issue, or if it's my mouse, or whatever.
-- Removing `mea_button_pressed()` from the main conditional (so only testing for the modifier key) doesn't change anything.


-- 11.2: https://warcraft.wiki.gg/wiki/Patch_11.2.0/API_changes

--[[---------------------------------------------------------------------------
	§ Definitions, references
---------------------------------------------------------------------------]]--

local debug = false

local _
local C_ContainerGetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local C_ContainerGetContainerItemID = _G.C_Container.GetContainerItemID
local C_ContainerUseContainerItem = _G.C_Container.UseContainerItem
local C_TimerAfter = C_Timer.After

-- https://warcraft.wiki.gg/wiki/BagID
-- https://www.townlong-yak.com/framexml/55824/go/Blizzard_APIDocumentationGenerated/BagIndexConstantsDocumentation.lua#16
-- Bags: Should be contiguous from backpack (0) to reagent bag (5), but for correctness we treat them individually
local idx_bags_container = BACKPACK_CONTAINER
local idx_bags_rea = BACKPACK_CONTAINER + NUM_BAG_SLOTS + 1
local idx_bags_first = BACKPACK_CONTAINER + 1
local idx_bags_last = BACKPACK_CONTAINER + NUM_BAG_SLOTS
-- Bank OLD: Not contiguous: -3 for reagent bank, -1 for bank container, then 6 to 12
-- Bank 11.2: Not contiguous: Characterbanktab -2, CharacterBankTabs 6 to 11
local idx_charbank_first = BACKPACK_CONTAINER + ITEM_INVENTORY_BANK_BAG_OFFSET + 1
local idx_charbank_last = BACKPACK_CONTAINER + ITEM_INVENTORY_BANK_BAG_OFFSET + Constants.InventoryConstants.NumCharacterBankSlots
-- Account Bank: Contiguous from 13 to 17
local idx_accountbank_first = BACKPACK_CONTAINER + ITEM_INVENTORY_BANK_BAG_OFFSET + Constants.InventoryConstants.NumCharacterBankSlots + 1
local idx_accountbank_last = BACKPACK_CONTAINER + ITEM_INVENTORY_BANK_BAG_OFFSET + Constants.InventoryConstants.NumCharacterBankSlots + Constants.InventoryConstants.NumAccountBankSlots

local C_MEA = '\124cff2196f3'
local C_KW = '\124cnORANGE_FONT_COLOR:'
local C_EMPH = '\124cnYELLOW_FONT_COLOR:'
local C_DEBUG = '\124cFFFF2F92'
local MSG_PREFIX = C_MEA .. "Move 'em All\124r:"

local DELAY_GB_DEFAULT = 0.6
local is_mac = IsMacClient()
local pimf, aborting_msg_sent, count, wait, delay

local modifiers = {
	['command'] = IsMetaKeyDown,
	['shift'] = IsShiftKeyDown,
	['option'] = IsAltKeyDown,
	['control'] = IsControlKeyDown,
	['alt'] = IsAltKeyDown,
}

local buttons = {
	['left'] = 'LeftButton',
	['right'] = 'RightButton',
}

local function debugprint(...)
	if debug then print(MSG_PREFIX, C_DEBUG..'Debug:', ...) end
end


local function mea_modifier_down()
	return modifiers[a.db.modifier]()
end

local function mea_button_pressed()
	local btn = GetMouseButtonClicked()
	return btn == buttons[a.db.button]
end


-- https://github.com/Ketho/BlizzardInterfaceResources/blob/mainline/Resources/LuaEnum.lua

local PIMF_BANK = Enum.PlayerInteractionType.Banker -- 8
local PIMF_MAIL = Enum.PlayerInteractionType.MailInfo -- 17
local PIMF_GUILDBANK = Enum.PlayerInteractionType.GuildBanker -- 10
local PIMF_MERCHANT = Enum.PlayerInteractionType.Merchant -- 5
local PIMF_TRADE = Enum.PlayerInteractionType.TradePartner -- 1

local valid_targets = {
	[PIMF_BANK] = true, -- Bank
-- 	[PIMF_MAIL] = true, -- Mail; better to have an extra check, see `safe_to_run` func
	[PIMF_GUILDBANK] = true, -- Guild bank
	[PIMF_MERCHANT] = true, -- Merchant
	[PIMF_TRADE] = true, -- Trade
}

local function safe_to_run()
-- 	debugprint('PIMF:', pimf)
	if valid_targets[pimf] then return true end
	if pimf == PIMF_MAIL then
		if a.db.disable_mail_safety or SendMailMailButton:IsVisible() then
			return true
		end
	end
	if not aborting_msg_sent then
		print(MSG_PREFIX, 'No valid destination to move items to, aborting transfer!')
		aborting_msg_sent = true
	end
	return false
end


--[[---------------------------------------------------------------------------
	§ Events
---------------------------------------------------------------------------]]--

local ef = CreateFrame 'Frame'
ef:RegisterEvent 'ADDON_LOADED'
ef:RegisterEvent 'PLAYER_INTERACTION_MANAGER_FRAME_SHOW'
ef:RegisterEvent 'PLAYER_INTERACTION_MANAGER_FRAME_HIDE'

ef:SetScript('OnEvent', function(self, event, ...)
	if event == 'ADDON_LOADED' then
		if ... == addon_name then
			ef:UnregisterEvent 'ADDON_LOADED'
			a.db = mea_database
			a.db.button = a.db.button or 'right'
			a.db.modifier = a.db.modifier or (is_mac and 'command' or 'shift')
			a.db.delay_normal = a.db.delay_normal or nil
			a.db.disable_mail_safety = a.db.disable_mail_safety or nil
			-- Will also reset to default if the user had set it to none. This is good, because as of now guild bank
			-- transfers will not work without any delay.
			a.db.delay_guildbank = a.db.delay_guildbank or DELAY_GB_DEFAULT
		end
	elseif event == 'PLAYER_INTERACTION_MANAGER_FRAME_SHOW' then
		pimf = ...
	else
		pimf = nil
	end
	debugprint('PIMF:', pimf)
end)


--[[---------------------------------------------------------------------------
	§ Main
---------------------------------------------------------------------------]]--

local function use_items(bag, item, to_banktype)
	for slot = 1, C_ContainerGetContainerNumSlots(bag) do
		if not safe_to_run() then return end
		local bag_item = C_ContainerGetContainerItemID(bag, slot)
		if bag_item == item then
-- 			debugprint('Count:', count, 'Bag:', bag, 'Slot:', slot)
			if delay then
				wait = delay * count
				C_TimerAfter(wait, function()
					-- We *have* to check here again, since target frame can be closed while there are still timers in the  queue.
					if not safe_to_run() then return end
					C_ContainerUseContainerItem(bag, slot, nil, to_banktype)
				end)
			else
				C_ContainerUseContainerItem(bag, slot, nil, to_banktype)
			end
			count = count + 1
		end
	end
end


local function from_bags(bagid)
	return bagid >= idx_bags_first and bagid <= idx_bags_last or bagid == idx_bags_container or bagid == idx_bags_rea
end

local function from_char_bank(bagid)
	return bagid >= idx_charbank_first and bagid <= idx_charbank_last
end

local function from_account_bank(bagid)
	return bagid >= idx_accountbank_first and bagid <= idx_accountbank_last
end

-- bankType: 0 = character; 1 = guild; 2 = account
-- Does not work with guild bank, and GuildBankFrame doesn't know GetActiveBankType.
local function dest_banktype()
	if BankFrame and BankFrame:GetActiveBankType() == 2 then
		return 2
	end
	return 0
end


-- https://warcraft.wiki.gg/wiki/ItemLocationMixin
-- https://github.com/search?q=repo%3Atomrus88%2FBlizzardInterfaceCode%20HandleModifiedItemClick&type=code
-- https://github.com/tomrus88/BlizzardInterfaceCode/blob/b48960a18c973f40f0d04a8e5021270733cfb38b/Interface/AddOns/Blizzard_ItemButton/Mainline/ItemButtonTemplate.lua#L380

hooksecurefunc('HandleModifiedItemClick', function(link, itemLocation)
	if mea_button_pressed() and mea_modifier_down() then
		debugprint 'Button and modifier conditionals passed.'
		aborting_msg_sent = nil
		-- XXX: Baganator account bank does not give itemLocation
		if itemLocation and itemLocation:IsBagAndSlot() and safe_to_run() then
-- 			debugprint(DevTools_Dump(itemLocation))
			local bag_id = itemLocation.bagID
			local slot_id = itemLocation.slotIndex
			debugprint('`itemLocation` and `safe_to_run` passed; Bag ID:', bag_id, '; Slot ID:', slot_id, '; Link:', link)
			local clicked_item = C_ContainerGetContainerItemID(bag_id, slot_id)
			if clicked_item then
				count, wait = 0, 0
				delay = pimf == PIMF_GUILDBANK and max(a.db.delay_guildbank or 0, a.db.delay_normal or 0) or a.db.delay_normal
				debugprint('At work now. Active delay:', delay)
				if from_bags(bag_id) then
					-- No idea if bankType 1 for guildbank has any effect
					local banktype = pimf == PIMF_BANK and dest_banktype() or pimf == PIMF_GUILDBANK and 1 or nil
					use_items(idx_bags_container, clicked_item, banktype)
					use_items(idx_bags_rea, clicked_item, banktype)
					for bag = idx_bags_first, idx_bags_last do
						use_items(bag, clicked_item, banktype)
					end
				elseif from_char_bank(bag_id) then
					for bag = idx_charbank_first, idx_charbank_last do
						use_items(bag, clicked_item)
					end
				elseif from_account_bank(bag_id) then
					for bag = idx_accountbank_first, idx_accountbank_last do
						use_items(bag, clicked_item)
					end
				end
				print(MSG_PREFIX, delay and 'Trying to move' or 'Probably moved', count .. 'x', link .. '.')
			end
		end
	end
end)


--[[---------------------------------------------------------------------------
	§ UI
---------------------------------------------------------------------------]]--

--[[ Commands:
Example       	Possible variants                   	Function
/mea left     	left, right                         	Mouse btn
/mea shift    	command, shift, option, control, alt	Modifier
/mea all 0.6  	float > 0 and <= 1                  	Generic delay
/mea gb 0.6   	float > 0 and <= 1                  	Guild bank delay (only used if greater than generic delay)
]]


SLASH_MOVEEMALL1 = '/moveemall'
SLASH_MOVEEMALL2 = '/mea'
SlashCmdList['MOVEEMALL'] = function(msg)
	local mt = {}
	for v in msg:gmatch '[^ ]+' do
		tinsert(mt, v)
	end

	local function cap(str) return (str:gsub('^%l', strupper)) end
	local function wants_help(str) return str:match('help') or str == 'h' or str == '-h' end

	if buttons[mt[1]] then
		a.db.button = mt[1]
		print(MSG_PREFIX, 'Mouse button set to', C_KW .. cap(a.db.button), '\124rbutton.')
	elseif modifiers[mt[1]] then
		a.db.modifier = mt[1]
		print(MSG_PREFIX, 'Modifier key set to', C_KW .. cap(a.db.modifier), '\124rkey.')
	elseif tonumber(mt[2]) and mt[1] == 'all!' then -- Delay global
		local d = tonumber(mt[2])
		a.db.delay_normal = (d > 0 and d <= 1) and d or nil
		print(MSG_PREFIX, 'Global delay (all targets except guild bank) set to ' .. (a.db.delay_normal or 'none (no timer used)') .. '.')
		if a.db.delay_normal then
			print(MSG_PREFIX, C_EMPH .. 'You have set a global delay for ' .. C_KW .. 'all\124r targets. Please note that a delay should only be needed for the guild bank! \nIf you have set the global delay by accident, please disable it again (' .. C_KW .. '/mea all! 0\124r). To set the guild bank delay, use ' .. C_KW .. 'gb\124r (for example ' .. C_KW .. '/mea gb 0.5\124r). Default delay for the guild bank is ' .. C_KW.. DELAY_GB_DEFAULT ..'s\124r.')
		end
	elseif tonumber(mt[2]) and mt[1] == 'gb' then -- Delay for guild bank
		local d = tonumber(mt[2])
		a.db.delay_guildbank = (d > 0 and d <= 1) and d or nil
		print(MSG_PREFIX, 'Delay for guild bank set to ' .. (a.db.delay_guildbank or 'none (no timer used)') .. '.')
	elseif mt[1] == 'togglemailsafety' then
		a.db.disable_mail_safety = not a.db.disable_mail_safety
		print(MSG_PREFIX, 'Mail safety '.. (a.db.disable_mail_safety and 'disabled' or 'enabled') .. '.')
	elseif mt[1] == 'debug' then
		debug = not debug
		print(MSG_PREFIX, 'Debug mode '.. (debug and 'enabled' or 'disabled') .. '.')
	elseif #mt == 0 then
		print(MSG_PREFIX, 'Current settings: Mouse button: '.. C_KW .. cap(a.db.button) .. ' \124r| Modifier key: ' .. C_KW .. cap(a.db.modifier).. ' \124r| Delay: ' .. C_EMPH .. (a.db.delay_normal and a.db.delay_normal .. 's' or 'none') .. ' \124r| Delay for guild bank: ' .. C_EMPH .. (a.db.delay_guildbank and a.db.delay_guildbank .. 's' or 'none') .. ' \124r| Mail safety: ' .. C_EMPH .. (a.db.disable_mail_safety and 'off' or 'on') .. '\n\124rYou can freely customize mouse button and modifier keys. Type ' .. C_KW .. '/mea help\124r to learn how.'
		)
	elseif wants_help(mt[1]) and #mt == 1 then
		print(MSG_PREFIX,
			'You can customize ' .. C_EMPH .. 'mouse button\124r and ' .. C_EMPH .. 'modifier keys\124r with these key words:' .. C_KW
		.. '\nleft\124r, ' .. C_KW .. 'right\124r | ' .. C_KW .. 'shift\124r, ' .. (is_mac and C_KW .. 'command\124r, ' or '') .. C_KW .. 'control\124r, ' .. C_KW .. (is_mac and 'option\124r.' or 'alt\124r.')
		.. '\nExample: ' .. C_KW .. '/mea right\124r and ' .. C_KW .. '/mea shift\124r --> Shift-right-click.'
		.. '\nDefaults are Command-right for macOS and Shift-right for Windows.'
		)
		print(MSG_PREFIX,
			'Type ' .. C_KW .. '/mea help delay\124r for help on changing the guild bank delay and the global delay.'
		)
	elseif wants_help(mt[1]) and mt[2] == 'delay' then
		print(MSG_PREFIX,
			C_EMPH .. 'Guild bank delay:\124r Mass transfers to the guild bank need to be throttled. The default delay is ' .. C_EMPH .. DELAY_GB_DEFAULT .. 's\124r. You can change the delay with ' .. C_KW .. '/mea gb <delay>\124r, for example ' .. C_KW .. '/mea gb 0.45\124r sets the delay to 0.45 seconds. Allowed values are ' .. C_EMPH .. '> 0\124r and ' .. C_EMPH .. '<= 1\124r. Any number outside the allowed range will disable the delay (not recommended!).'
		)
		print(MSG_PREFIX,
			C_EMPH .. 'Global delay:\124r Analogous to the guild bank delay, you can set a global delay with ' .. C_KW .. '/mea all! <delay>\124r. The global delay is disabled by default, and ' .. C_EMPH .. 'you should not set one!\124r You may want to try it only if you are experiencing significant server lag that is affecting the smooth operation of MEA. (Note: If the global delay is longer than the guild bank delay, it will override the guild bank delay.)'
		)
	else
		print(MSG_PREFIX, 'That was not a valid input. Type', C_KW .. '/mea h\124r for help.')
	end
end




--[[ License ===================================================================

	Copyright © 2023-2025 Thomas Floeren

	This file is part of Move'em All.

	Move'em All is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by the
	Free Software Foundation, either version 3 of the License, or (at your
	option) any later version.

	Move'em All is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
	more details.

	You should have received a copy of the GNU General Public License along with
	Move'em All. If not, see <https://www.gnu.org/licenses/>.

==============================================================================]]
