if not HCoold then return false end
local L = HCoold:GetLocale()

local spells = { -- spells that we can track by system
	{ -- vampiric blood
		spellID = 55233,
		class = "DEATHKNIGHT", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 1 },
		CD = 60,
		type = 4, -- self cd
		cast_time = 10,
		quality = 3,
	},
	{ -- icebound fort
		spellID = 48792,
		class = "DEATHKNIGHT", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 1 },
		CD = 120,
		type = 4, -- self cd
		cast_time = 12,
		quality = 3,
	},
	{ -- divine protection
		spellID = 498,
		class = "PALADIN", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 2 },
		CD = 120,
		type = 4, -- self cd
		cast_time = 12,
		quality = 3,
	},
	{ -- barkskin
		spellID = 22812,
		class = "DRUID", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 2 },
		CD = 60,
		type = 4, -- self cd
		cast_time = 12,
		quality = 3,
	},
	{ -- survival inst
		spellID = 61336,
		class = "DRUID", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 2 },
		CD = 180,
		type = 4, -- self cd
		cast_time = 20,
		quality = 3,
	},
	{ -- hand of sacrifice
		spellID = 6940,
		class = "PALADIN", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 120,
		type = 5, -- another player
		cast_time = 12,
		quality = 2,
	},
	{ -- Divine Sacrifice/Guardian
		spellID = 64205,
		class = "PALADIN", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 120,
		type = 1, -- raid aura
		cast_time = 10,
		quality = 1,
	},
	{ -- aura mastery
		spellID = 31821,
		class = "PALADIN", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 1, 3 },
		CD = 120,
		type = 1, -- raid aura
		cast_time = 6,
		quality = 3,
	},
	{ -- Pain Suppression
		spellID = 33206,
		class = "PRIEST", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 1 },
		CD = 180,
		type = 5, -- another player
		cast_time = 8,
		quality = 3,
	},
	{ -- guardian spirit
		spellID = 47788,
		class = "PRIEST", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 2 },
		CD = 180,
		type = 5, -- another player
		cast_time = 10,
		quality = 3,
	},
	{ -- divine hymn
		spellID = 64843,
		class = "PRIEST", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 480,
		type = 2, -- mana
		cast_time = 8,
		quality = 2,
	},
	{ -- hymn of hope
		spellID = 64901,
		class = "PRIEST", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 360,
		type = 3, -- mana
		cast_time = 8,
		quality = 2,
	},
	{ -- Rebirth
		spellID = 48477,
		class = "DRUID", 
		succ = "SPELL_RESURRECT",
		specs = { 0 },
		CD = 600,
		type = 7, -- combat rez
		cast_time = 1,
		quality = 2,
	},
	{ -- Innervate
		spellID = 29166,
		class = "DRUID", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 180,
		type = 3, -- mana
		cast_time = 1,
		quality = 2,
	},
	{ -- Tranqulity
		spellID = 48447,
		class = "DRUID", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 480,
		type = 2, -- aoe heal
		cast_time = 8,
		quality = 2,
	},
	{ -- death wish
		spellID = 12292,
		class = "WARRIOR", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 0 },
		CD = 180,
		type = 6, -- self dps cd
		cast_time = 30,
		quality = 2,
	},
	


------ type == 8  станы
}

local spec_spells = { -- uniq for spec spell that can be used to determine spec of player
	{ -- паладин 1 holy 2 prot 3 retri
		class = "PALADIN",
		specs = {
			[1] = {
				{id = 53563,}, -- beacon 
			},
			[2] = {
				{id = 53595,}, -- hammer of righteous
			},
			[3] = {
				{id = 35395,}, -- crusader strike
			},
		},
	},
	{ -- прист 1 disc 2 holy 3 shadow
		class = "PRIEST",
		specs = {
			[1] = {
				{id = 52985,}, -- pennance 
			},
			[2] = {
				{id = 48089,}, -- circle of healing
			},
			[3] = {
				{id = 15286,}, -- vampiric embrace
			},
		},
	},
	{ -- варлок  ------- нет крутых кд привязанных к спеку
		class = "WARLOCK",
		specs = {
			[1] = {
				{id = 0,}, -- 
			},
			[2] = {
				{id = 0,}, -- 
			},
			[3] = {
				{id = 0,}, -- 
			},
		},
	},
	{ -- хантер ------- нет крутых кд привязанных к спеку
		class = "HUNTER",
		specs = {
			[1] = {
				{id = 0,}, -- 
			},
			[2] = {
				{id = 0,}, -- 
			},
			[3] = {
				{id = 0,}, -- 
			},
		},
	},
	{ -- шаман 1 elem 2 ench 3 restor
		class = "SHAMAN",
		specs = {
			[1] = {
				{id = 0,}, -- 
			},
			[2] = {
				{id = 0,}, -- 
			},
			[3] = {
				{id = 0,}, -- 
			},
		},
	},
	{ -- друид 1 balance 2 feral 3 resto
		class = "DRUID",
		specs = {
			[1] = {
				{id = 24858,}, -- moonkin
			},
			[2] = {
				{id = 9634,}, -- dire bear form
			},
			[3] = {
				{id = 33891,}, -- tree of life
			},
		},
	},
	{ -- маг 1 arcan 2 fire 3 frost
		class = "MAGE",
		specs = {
			[1] = {
				{id = 0,}, -- 
			},
			[2] = {
				{id = 0,}, -- 
			},
			[3] = {
				{id = 0,}, -- 
			},
		},
	},
	{ -- рога  ------- нет крутых кд привязанных к спеку???
		class = "ROGUE",
		specs = {
			[1] = {
				{id = 0,}, -- 
			},
			[2] = {
				{id = 0,}, -- 
			},
			[3] = {
				{id = 0,}, -- 
			},
		},
	},
	{ -- дк 1 blood 2 frost 3 unholy
		class = "DEATHKNIGHT",
		specs = {
			[1] = {
				{id = 55233,}, -- vampiric blood
			},
			[2] = {
				{id = 51411,}, -- howling blast
			},
			[3] = {
				{id = 55271,}, -- scourge strike
			},
		},
	},
	{ -- воин 1 arms, 2 fury 3 prot
		class = "WARRIOR",
		specs = {
			[1] = {
				{id = 0,}, -- 
			},
			[2] = {
				{id = 0,}, -- 
			},
			[3] = {
				{id = 0,}, -- 
			},
		},
	},
}

function HCoold:MakeSpellList() -- in future - making self.spells that contains spells, that will be tracking by system by user configuration
	self.spells = {}
	for _,i in next, spells do
		local out = tostring(i.spellID)
		for _,j in next, i.specs do
			out = string.format("%s.%d",out,j)
		end
		if self.db.profile.trackSpells[out] == nil then self.db.profile.trackSpells[out] = true end
		if self.db.profile.trackSpells[out] then table.insert(self.spells,i) end
	end
	--self.spells = spells
end

function HCoold:GetSpellBySpec(id,spec) -- return link to spell by spec and id
	for _,i in next, self.spells do
		if i.spellID == id then
			for _,j in next, i.specs do
				if j == spec or j == 0 then return i end
			end
		end
	end
	return nil
end

function HCoold:GetSpecBySpell(spellID) -- return spec of class if it used this spell (check if spell is spec uniq)
	for _,i in next, spec_spells do
		for spec,j in next, i.specs do
			for _,p in next, j do
				if p.id == spellID then return spec end
			end
		end
	end
	return 0
end

function HCoold:GenerateSpellList()
	local out = {}
	--[[
	{ -- для отладки Шок небес
		spellID = 25914, -- ID спелла
		class = "PALADIN", -- класс, которому принадлежит спелл
		CD = 6, -- кулдаун в секундах у спела
		specs = { 1 },
		succ = "SPELL_HEAL", -- тип ивента, который означает удачное применение спелла
		type = 1,  -- тип спелла: 
				1 - аура на -дамаг (купол, мастер аур и тд) 
				2 - аое хил (гимн пристов, транквил) 
				3 - на ману (иннеры, гимн на ману, мана тайд) 
				4 - личный кд (айс блок, шв, бабл, отражение) 
				5 - точечный кд (пс, крылья, придание сил)
				6 - кд на +дамаг (варовский -армор, бл)
				7 - возрождения (друид, шаман, дк, лок)
			
		cast_time = 0, -- время действия спелла
		quality = 3, -- качество спелла при сортировке 1/nil - плохое 2 - хорошее 3 - лучшее
	},
	]]
	local order = 1
	local t_ = {}
	for _, i in next, spells do
		local t = tostring(i.type)
		if not out[t] then
			out[t] = {
				type = "group",
				cmdHidden = true,
				name = L["type"..t],
				desc = L["desc type"..t],
				order = i.type+30,
				args = {},
			}
			t_[t] = true
		end
		--print(i.spellID)
		local spname = select(1, GetSpellInfo(i.spellID))
		--print(spname)
		local specs = ""
		local tmp = ""
		for _, j in next, i.specs do 
			specs = string.format("%s%s%s",specs,tmp,j)
			tmp = ", "
		end
		local desc = string.format(L["Spell name %s class %s specs %s"],spname,L[i.class],L[i.class .. specs])
		local tt = tostring(i.spellID)
		for _,j in next, i.specs do
			tt = string.format("%s.%d",tt,j)
		end
		local s = {
			type = "toggle",
			name = spname,
			desc = desc,
			set = function(tmp,key)
				self.db.profile.trackSpells[tt] = key
			end,
			get = function() 
				return self.db.profile.trackSpells[tt]
			end,
			order = order,
		}
		out[t].args[tostring(order)] = s
		order = order+1
	end
	
	for i in next, t_ do
		local k = tonumber(i) or 1
		--self:Printf("%s %s %s","width" .. i,k,self.db.profile.types[k].w)
		out["header" .. i] = {
			type = "header",
			cmdHidden = true,
			name = L["header" .. i],
			order = k * 10 + 1
		}
		out["width" .. i] = {
			type = "input",
			cmdHidden = true,
			name = L["type width"..i],
			desc = L["desc type width"..i],
			order = k * 10 + 2,
			width = "half",
			set = function(a1,val)
				val = tonumber(val) or 100
				self.db.profile.types[k].w = val
				if self.types[k] then self.types[k]:SetWidth(val) end
			end,
			get = function()
				return tostring(self.db.profile.types[k].w)
			end,
		}
		
		local sm = {}
		for i,j in next, self.sort_methods do sm[i] = j.desc end
		out["sort" .. i] = {
			type = "select",
			-- width = "half",
			name = L["sort method" .. i],
			desc = L["desc sort method" .. i],
			order = k * 10 + 3,
			cmdHidden = true,
			values = sm,
			get = function() 
				return self.db.profile.types[k].sm 
			end,
			set = function(tmp, val) 
				self.db.profile.types[k].sm = val
				if self.types[k] then self.types[k]:SetSortMethod(val) end
			end,
		}
		
		out["enable" .. i] = {
			type = "toggle",
			name = L["enable" .. i],
			desc = L["desc enable" .. i],
			order = k*10 + 4,
			cmdHidden = true,
			set = function(t, val)
				self.db.profile.types[k].enable = val
				if self.types[k] then self.types[k]:Enable(val) end
			end,
			get = function() return self.db.profile.types[k].enable end,
		}
	end
	
	return out
end

























