if not HCoold then return false end
local AceConfig = LibStub("AceConfigDialog-3.0")
local L = HCoold:GetLocale()

function HCoold:GenerateOptions()
	local options = {
		type = "group",
		get = getProfileOption,
		set = setProfileOptionAndClearCache,
		args = {
			lock = {
				type = "execute",
				name = L["lock frames"],
				desc = L["desc lock frames"],
				order = 1,
				func = function () self:LockFrames() end,
			},
			unlock = {
				type = "execute",
				name = L["unlock frames"],
				desc = L["desc unlock frames"],
				order = 2,
				func = function () self:UnlockFrames() end,
			},
			wipe = {
				type = "execute",
				name = L["redraw"],
				desc = L["desc redraw"],
				cmdHidden = true,
				order = 3,
				confirm = true,
				func = function () self:WIPE() end,
			},
			config = {
				type = "execute",
				guiHidden = true,
				name = L["run config"],
				desc = L["desc run config"],
				order = 4,
				func = function ()
					AceConfig:SetDefaultSize(700,700)
					AceConfig:Open(self.name)
				end,
			},
			hide = {
				type = "execute",
				name = L["show/hide all"],
				desc = L["desc show/hide all"],
				order = 5,
				func = function ()
					local show = false
					for _, i in next, self.types do if i:Enable() then show = true end end
					for _, i in next, self.types do 
						i:Enable(not show)
						self.db.profile.types[i.type].enable = not show
					end
				end,
			},
			spells = {
				type = "group",
				cmdHidden = true,
				name = L["spells"],
				desc = L["desc spells"],
				order = 5,
				args = HCoold:GenerateSpellList()
			},
		},
	}
	options.args.profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(HCoold.db)
	options.args.profiles.order = -1
	options.args.profiles.cmdHidden = true
	options.args.profiles.disabled = false
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable(self.name, options, "hcd")
	AceConfig:AddToBlizOptions(self.name,L["Hagakure cooldowns"])
end






































