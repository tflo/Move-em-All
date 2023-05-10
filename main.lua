local addon_name, a = ...
mea_database = mea_database or {}

--[[---------------------------------------------------------------------------
	Variables
---------------------------------------------------------------------------]]--

local C_ContainerGetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local C_ContainerGetContainerItemID = _G.C_Container.GetContainerItemID
local C_ContainerUseContainerItem = _G.C_Container.UseContainerItem

-- Bags: Should be continuous from bag 0 to reagent bag (5) - as of wow 10.1
local BAG_FIRST = BACKPACK_CONTAINER
local BAG_LAST = BACKPACK_CONTAINER + NUM_BAG_SLOTS + 1
-- Bank: Not continuous, -1 for bank container, then 6 to 12 - as of wow 10.1
local BANK_CONTAINER = BANK_CONTAINER
local BANK_FIRST = NUM_TOTAL_EQUIPPED_BAG_SLOTS + 1
local BANK_LAST = NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS

local C_MEA = '\124cff2196f3'
local C_EMPH = '\124cnORANGE_FONT_COLOR:'
local MSG_PREFIX = C_MEA .. "Move 'em All\124r:"

local is_mac = IsMacClient()
local pimf, count

local modifiers = {
	['Command'] = IsMetaKeyDown,
	['Shift'] = IsShiftKeyDown,
	['Option'] = IsAltKeyDown,
	['Control'] = IsControlKeyDown,
	['Alt'] = IsAltKeyDown,
}

local buttons = {
	['Left'] = 'LeftButton',
	['Right'] = 'RightButton',
}

local function required_modifier_down()
	return modifiers[a.db.modifier]()
end

local function required_button_clicked()
	local btn = GetMouseButtonClicked()
	return btn == buttons[a.db.button]
end

local valid_targets = {
	[8] = true, -- Bank
	[17] = true, -- Mail
	[10] = false, -- Guild bank
	[5] = true, -- Merchant
	[1] = true, -- Trade
}


--[[---------------------------------------------------------------------------
	Events
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
			a.db.button = a.db.button or 'Right'
			a.db.modifier = a.db.modifier or (is_mac and 'Command' or 'Shift')
		end
	elseif event == 'PLAYER_INTERACTION_MANAGER_FRAME_SHOW' then
		pimf = ...
	else
		pimf = nil
	end
end)


--[[---------------------------------------------------------------------------
	Main
---------------------------------------------------------------------------]]--

local function use_items(bag, item)
	for slot = 1, C_ContainerGetContainerNumSlots(bag) do
		if not valid_targets[pimf] then return end
		local bag_item = C_ContainerGetContainerItemID(bag, slot)
		if bag_item == item then
			C_ContainerUseContainerItem(bag, slot)
			count = count + 1
		end
	end
end


hooksecurefunc('HandleModifiedItemClick', function(link, itemLocation)
	if required_modifier_down() and required_button_clicked() then
		if itemLocation and itemLocation:IsBagAndSlot() and valid_targets[pimf] then
			local bag_id = itemLocation.bagID
			local slot_id = itemLocation.slotIndex
			local clicked_item = C_ContainerGetContainerItemID(bag_id, slot_id)
			if clicked_item then
				count = 0
				if bag_id >= BAG_FIRST and bag_id <= BAG_LAST then
					for bag = BAG_FIRST, BAG_LAST do
						use_items(bag, clicked_item)
					end
				else -- Bank
					use_items(BANK_CONTAINER, clicked_item)
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
	UI
---------------------------------------------------------------------------]]--

local function cap(str) return (str:gsub('^%l', string.upper)) end

SLASH_MOVEEMALL1 = '/moveemall'
SLASH_MOVEEMALL2 = '/mea'
SlashCmdList['MOVEEMALL'] = function(msg)
	local Msg = msg:gsub('^%l', string.upper)
	if buttons[Msg] then
		a.db.button = Msg
		print(MSG_PREFIX, 'Mouse button set to', C_EMPH .. Msg, '\124rbutton.')
	elseif modifiers[Msg] then
		a.db.modifier = Msg
		print(MSG_PREFIX, 'Modifier key set to', C_EMPH .. Msg, '\124rkey.')
	elseif msg == '' then
		print(MSG_PREFIX, 'Current settings: Mouse button:', C_EMPH .. a.db.button, '\124r| Modifier key:', C_EMPH .. a.db.modifier, '\n\124rYou can set mouse button and modifier key with these key words:', C_EMPH .. '\nleft\124r,', C_EMPH .. 'right\124r |', C_EMPH .. 'shift\124r,', (is_mac and C_EMPH .. 'command\124r,' or ''), C_EMPH .. 'control\124r,', C_EMPH .. (is_mac and 'option\124r.' or 'alt\124r.'), '\nExample:', C_EMPH .. '/mea right\124r and', C_EMPH .. '/mea shift\124r --> Shift-right-click. \nDefaults are Command-right for macOS and Shift-right for Windows.')
	else
		print(MSG_PREFIX, 'That was not a valid input. Type', C_EMPH .. '/mea\124r for help.')
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
