local addon_name, a = ...
mea_database = mea_database or {}

--[[---------------------------------------------------------------------------
	§ Definitions, references
---------------------------------------------------------------------------]]--

local debug = false

local _
local C_ContainerGetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local C_ContainerGetContainerItemID = _G.C_Container.GetContainerItemID
local C_ContainerUseContainerItem = _G.C_Container.UseContainerItem
local C_TimerAfter = C_Timer.After

-- See https://wowpedia.fandom.com/wiki/BagID
-- Bags: Should be continuous from bag 0 to reagent bag (5) - as of wow 10.1
local BAG_FIRST = BACKPACK_CONTAINER
local BAG_LAST = BACKPACK_CONTAINER + NUM_BAG_SLOTS + 1
-- Bank: Not continuous: -3 for reagent bank, -1 for bank container, then 6 to 12 - as of wow 10.1
local BANK_REA = REAGENTBANK_CONTAINER
local BANK_CONTAINER = BANK_CONTAINER
local BANK_FIRST = NUM_TOTAL_EQUIPPED_BAG_SLOTS + 1
local BANK_LAST = NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS

local C_MEA = '\124cff2196f3'
local C_KW = '\124cnORANGE_FONT_COLOR:'
local C_EMPH = '\124cnYELLOW_FONT_COLOR:'
local MSG_PREFIX = C_MEA .. "Move 'em All\124r:"

local DELAY_GB = 0.6
local is_mac = IsMacClient()
local pimf, count, wait, delay, to_reabank

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

local function mea_modifier_down()
	return modifiers[a.db.modifier]()
end

local function mea_button_pressed()
	local btn = GetMouseButtonClicked()
	return btn == buttons[a.db.button]
end

local function mea_modifier_rea_down()
	return modifiers[a.db.modifier_rea]()
end

local valid_targets = {
	[8] = true, -- Bank
	[17] = true, -- Mail
	[10] = true, -- Guild bank
	[5] = true, -- Merchant
	[1] = true, -- Trade
	[26] = true, -- Void Storage
}

local function debugprint(...)
	if debug then print(MSG_PREFIX, 'Debug:', ...) end
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
			a.db.modifier_rea = a.db.modifier_rea or (is_mac and 'option' or 'alt')
			a.db.delay_normal = a.db.delay_normal or nil
			a.db.delay_guildbank = a.db.delay_guildbank or DELAY_GB
		end
	elseif event == 'PLAYER_INTERACTION_MANAGER_FRAME_SHOW' then
		pimf = ...
	else
		pimf = nil
	end
end)


--[[---------------------------------------------------------------------------
	§ Main
---------------------------------------------------------------------------]]--

local function use_items(bag, item)
	for slot = 1, C_ContainerGetContainerNumSlots(bag) do
		if not valid_targets[pimf] then return end
		local bag_item = C_ContainerGetContainerItemID(bag, slot)
		if bag_item == item then
-- 			debugprint('Count:', count, 'Bag:', bag, 'Slot:', slot)
			if delay then
				wait = delay * count
				C_TimerAfter(wait, function()
					C_ContainerUseContainerItem(bag, slot, nil, to_reabank)
				end)
			else
				C_ContainerUseContainerItem(bag, slot, nil, to_reabank)
			end
			count = count + 1
		end
	end
end

hooksecurefunc('HandleModifiedItemClick', function(link, itemLocation)
-- 	if mea_button_pressed() and (mea_modifier_down() or pimf == 8 and mea_modifier_rea_down()) then
	if mea_button_pressed() and mea_modifier_down() then -- Probably better, to avoid conflicts
		debugprint 'Button and modifier conditionals passed.'
		if itemLocation and itemLocation:IsBagAndSlot() and valid_targets[pimf] then
			debugprint 'itemLocation and target frame validation passed.'
-- 			debugprint(tf6.tprint(itemLocation))
			local bag_id = itemLocation.bagID
			local slot_id = itemLocation.slotIndex
			local clicked_item = C_ContainerGetContainerItemID(bag_id, slot_id)
			if clicked_item then
				count, wait = 0, 0
				delay = pimf == 10 and max(a.db.delay_guildbank, a.db.delay_normal or 0) or a.db.delay_normal
				debugprint('At work now. Active delay:', delay)
				if bag_id >= BAG_FIRST and bag_id <= BAG_LAST then -- From bags
					to_reabank = (pimf == 8 and (mea_modifier_rea_down() or ReagentBankFrame:IsShown()))
					for bag = BAG_FIRST, BAG_LAST do
						use_items(bag, clicked_item)
					end
				else -- From bank
					use_items(BANK_CONTAINER, clicked_item)
					use_items(BANK_REA, clicked_item)
					for bag = BANK_FIRST, BANK_LAST do
						use_items(bag, clicked_item)
					end
				end
				print(MSG_PREFIX, 'Probably moved', count .. 'x', link .. '.')
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
/mea rea shift	command, shift, option, control, alt	Reagent Bag modifier
/mea all 0.6  	float > 0 and <= 1                  	Generic delay
/mea gb 0.6   	float > 0 and <= 1                  	Guild bank delay (only used if greater than generic delay)
]]

local function cap(str) return (str:gsub('^%l', strupper)) end

SLASH_MOVEEMALL1 = '/moveemall'
SLASH_MOVEEMALL2 = '/mea'
SlashCmdList['MOVEEMALL'] = function(msg)
	local mt = {}
	for v in string.gmatch(msg, "[^ ]+") do
		tinsert(mt, v)
	end
	if buttons[mt[1]] then
		a.db.button = mt[1]
		print(MSG_PREFIX, 'Mouse button set to', C_KW .. cap(a.db.button), '\124rbutton.')
	elseif modifiers[mt[1]] then
		a.db.modifier = mt[1]
		print(MSG_PREFIX, 'Modifier key set to', C_KW .. cap(a.db.modifier), '\124rkey.')
	elseif mt[1] == 'rea' and modifiers[mt[2]] then
		a.db.modifier_rea = mt[2]
		print(MSG_PREFIX, 'Reagent bank modifier key set to', C_KW .. cap(a.db.modifier_rea), '\124rkey.')
	elseif tonumber(mt[2]) then
		local d = tonumber(mt[2]) -- Delay
		if mt[1] == 'all' then -- Delay for all targets
			a.db.delay_normal = (d > 0 and d <= 1) and d or nil
			print(MSG_PREFIX, 'Delay for all targets set to ' .. (a.db.delay_normal or 'none (no timer used)') .. '.')
			if a.db.delay_normal then
				print(MSG_PREFIX, C_EMPH .. 'You have set a delay for ' .. C_KW .. 'all\124r targets. Please note that a delay should only be needed for the guild bank! \nIf you have set the delay by accident, please disable it again (' .. C_KW .. '/mea all 0\124r). To set the guild bank delay, use ' .. C_KW .. 'gb\124r (for example ' .. C_KW .. '/mea gb 0.5\124r). Default for the guild bank is ' .. C_KW.. DELAY_GB ..'s\124r.')
			end
		elseif mt[1] == 'gb' then -- Delay for guild bank
			a.db.delay_guildbank = (d > 0 and d <= 1) and d or nil
			print(MSG_PREFIX, 'Delay for guild bank set to ' .. (a.db.delay_guildbank or 'none (no timer used)') .. '.')
		end
	elseif mt[1] == 'debug' then
		debug = not debug
		print(MSG_PREFIX, 'Debug mode '.. (debug and 'enabled' or 'disabled') .. '.')
	elseif #mt == 0 then
		print(MSG_PREFIX, 'Current settings: Mouse button: '.. C_KW .. cap(a.db.button) .. ' \124r| Modifier key: ' .. C_KW .. cap(a.db.modifier).. ' \124r| Reagent bank modifier key: ' .. C_KW .. cap(a.db.modifier_rea) .. ' \124r| Delay: ' .. C_EMPH .. (a.db.delay_normal and a.db.delay_normal .. 's' or 'none') .. ' \124r| Delay for guild bank: ' .. C_EMPH .. (a.db.delay_guildbank and a.db.delay_guildbank .. 's' or 'none')
		.. '\n\124rYou can freely customize mouse button and modifier keys. Type ' .. C_KW .. '/mea help\124r to learn how.'
		)
	elseif mt[1] == 'help' then
		print(MSG_PREFIX,
			'You can customize mouse button and modifier keys with these key words:' .. C_KW
		.. '\nleft\124r, ' .. C_KW .. 'right\124r | ' .. C_KW .. 'shift\124r, ' .. (is_mac and C_KW .. 'command\124r, ' or '') .. C_KW .. 'control\124r, ' .. C_KW .. (is_mac and 'option\124r.' or 'alt\124r.')
		.. '\nExample: ' .. C_KW .. '/mea right\124r and ' .. C_KW .. '/mea shift\124r --> Shift-right-click.'
		.. '\nDefaults are Command-right for macOS and Shift-right for Windows.'
		.. '\nCaution: The Reagent Bank modifier key is currently set to '.. C_KW .. cap(a.db.modifier_rea) .. '. \124rAvoid setting your main modifier to the same key, or change the Reagent Bank modifier key with ' .. C_KW .. '/mea rea\124r (e.g. ' .. C_KW .. '/mea rea control\124r).'
		)
		print(MSG_PREFIX,
			'--> The ' .. C_EMPH .. 'Reagent Bank modifier key\124r is ' .. C_EMPH .. 'needed\124r to send items to the Reagent Bank, ' .. C_EMPH .. 'if\124r you are using a bag addon that replaces the Blizz Reagent Bank frame with its own. \nBut it is also useful for the standard bag, as it allows you to send items to the Reagent Bank without actually switching to the frame.'
		)
	else
		print(MSG_PREFIX, 'That was not a valid input. Type', C_KW .. '/mea\124r for help.')
	end
end




--[[ License ===================================================================

	Copyright © 2023 Thomas Floeren

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
