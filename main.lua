local addon_name = "hagakure_cooldowns"
local debug_ = false

HCoold = LibStub("AceAddon-3.0"):NewAddon(addon_name,"AceEvent-3.0","AceTimer-3.0")
HCoold.name = addon_name

function HCoold:GetLocale()
	local L  = LibStub("AceLocale-3.0"):GetLocale(HCoold.name,true)
	if not L then
		L = {}
		setmetatable(L,{
			__index =  function (table_,key)
				return key
			end,
		})
	end
	return L
end
local L = HCoold:GetLocale()

local conf = {
	group = {
		h = 20,
	},
	spell = {
		w = 150,
	},
	icon = {
		w = 16,
		h = 16,
	},
	text = {
		w = 130,
	},
	types = {
		[1] = {
			top = 700,
			left = 228,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[2] = {
			top = 700,
			left = 334,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[3] = {
			top = 700,
			left = 440,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[4] = {
			top = 700,
			left = 549,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[5] = {
			top = 700,
			left = 659,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[6] = {
			top = 700,
			left = 773,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[7] = {
			top = 700,
			left = 878,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = true,
		},
		[8] = {
			top = 700,
			left = 989,
			point = "BOTTOMLEFT",
			w = 120,
			sm = 1,
			enable = false,
		},
	},
	timer_delay = 1,
	timer_uncombat_delay = 15,
	color = {
		active = "|cffff0000",
		cd = "|caaaaaaaa",
		supergood = "|cffff00ff",
		good = "|cff00ff00",
		bad = "|cff00ffff",
		offline = "|ca0000000",
		dead = "|ca0b0b0ff",
	},
}

HCoold.sort_methods = {
	[1] = {
		desc = L["from top to bottom"],
		point1 = "TOPLEFT",
		point2 = "BOTTOMLEFT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "TOPLEFT",
	},
	[2] = {
		desc = L["from left to right"],
		point1 = "TOPLEFT",
		point2 = "TOPRIGHT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "TOPLEFT",
	},
	[3] = {
		desc = L["from right to left"],
		point1 = "TOPRIGHT",
		point2 = "TOPLEFT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "TOPLEFT",
	},
	[4] = {
		desc = L["from bottom to top"],
		point1 = "BOTTOMLEFT",
		point2 = "TOPLEFT",
		fpoint1 = "TOPLEFT",
		fpoint2 = "BOTTOMLEFT",
	},
}

function HCoold:IsTrackSpell(spellID)
	for _,v in pairs(self.spells) do if v.spellID == spellID then return v end end
	return false
end

do -- addon initialize section
	function HCoold:Printf(inp, ...)
		if debug_ then DEFAULT_CHAT_FRAME:AddMessage(string.format(inp, ...)) end
	end

	function HCoold:Print(...)
		if debug_ then DEFAULT_CHAT_FRAME:AddMessage(...) end
	end

	function HCoold:OnInitialize()
		local defaults = {
			profile = conf,
		}
		self.db = LibStub("AceDB-3.0"):New("hagakure_cooldownsDB", defaults)
	end

	function HCoold:OnEnable()
		--self:Printf(L["|cffff0000Hagakure cooldowns, greet %s! run /hcd"],UnitName("player"))
		LibStub("AceConsole-3.0"):Printf(L["|cffff0000Hagakure cooldowns, greet %s! run /hcd"],UnitName("player"))
		
		self:RegisterEvent("RAID_INSTANCE_WELCOME","ChangedZone") -- change zone
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED","CombatLog") -- COMBAT_LOG_EVENT_UNFILTERED  COMBAT_LOG_EVENT -- combat log event handler
		self:RegisterEvent("PLAYER_REGEN_DISABLED","EnterCombat") -- enter combat
		self:RegisterEvent("PLAYER_REGEN_ENABLED","LeaveCombat") -- leave combat
		-- self:RegisterEvent("RAID_ROSTER_UPDATE","RaidRosterUpdate") 
		self:RegisterEvent("PARTY_MEMBERS_CHANGED","RaidRosterUpdate") 
		--self:RegisterEvent("PARTY_MEMBER_DISABLE","RaidRosterUpdate") -- не пашет
		--self:RegisterEvent("PARTY_MEMBER_ENABLE","RaidRosterUpdate")
		
		self:RenewPlayersList(true) -- making array with player's specs
		
		self.db.profile.trackSpells = self.db.profile.trackSpells or {}
		
		self:MakeSpellList() -- making spells for tracking from setup
		self:MakeSpellGroups() -- making frames for align spells
		self:GenerateOptions() -- generate addon options and registering command /hc
	end

	function HCoold:WIPE()
		for _,i in next, self.types do
			i:Hide()
		end
		self:MakeSpellList()
		self:MakeSpellGroups()
		self:CheckPlayersCDs()
	end
end

function HCoold:RaidRosterUpdate()
	--self:Printf("here!")
	self:CheckPlayersCDs()
end

function HCoold:RenewPlayersList(first)
	self.db.faction.players = self.db.faction.players or {}
	for i=1, GetNumRaidMembers() do
		local name = select(1,GetRaidRosterInfo(i))
		if not self.db.faction.players[name] then self.db.faction.players[name]=0 end
	end
	if not first then self:CheckPlayersCDs() end
end

function HCoold:ChangedZone(...)
	local _,name, ttl = ...
	self:Printf("You entered %s.",name)
end

function HCoold:CombatLog(...)
	--[[
		... :
			2 - timestamp
			3 - event
			6 - sourceName
			10 - destName
				SPELL:
					13 - spellID
					14 - spellName
					15 - spellSchool
				_AURA_APPLIED
				_AURA_REMOVED
					16 - auraType  // BUFF DEBUFF
				_HEAL
				_CAST_START
				_CAST_SUCCESS
				_MISS
				_RESURRECT
				UNIT_DIED
	]]

	local inp = {...}
	local event = inp[3]

	if string.find(event,"UNIT_DIED") then
		-- self:Printf("died %s %s %s %s %s %s",inp[10])
		self:KillUnit(inp[10])
		return true
	end
	
	if not self:IsInRaid(inp[6]) then return false end

	-- self:Printf("%s %s %s %s", inp[2], inp[3], inp[6], inp [10])
	if string.find(event,"SPELL") then 
		local spellID, spellName = inp[13], inp[14]
		self:RenewSpec(inp[13],inp[6])
		--self:Printf("%s %s %s",event, spellID, spellName)
		local spell = self:IsTrackSpell(spellID)
		if spell then
			if spell.succ and spell.succ ~= event then 
				-- self:Printf("we deslined %s %s",event,spellName)
				return false 
			end 
			-- self:Printf("We are looking %s %d. Player %s %s ",spellName,spellID,inp[6],event)
			-- у нас есть спелл, который мы отслеживаем, 
			-- при этом его каст прошел, те надо запустить кд 
			self:StartCD(inp[6],spell)
		end
		return true
	end
end

function HCoold:KillUnit(name)
	self:Printf("killing %s",name)
	if self:IsInCombat() then self.combat_spec[name]=nil end
	self:RenewStatus()
end

function HCoold:IsInRaid(player)
	for i = 1, GetNumRaidMembers() do
		local name, _, subgroup = GetRaidRosterInfo(i)
			if name == player and subgroup <= 5 then return true end
	end
	return false
end

do -- секция с вход/выход из боя
	local combat = false
	function HCoold:EnterCombat()
		self:Printf("enter combat")
		combat = true
		self.combat_spec = {}
	end

	function HCoold:LeaveCombat()
		self:Printf("leave combat")
		combat = false
	end

	function HCoold:IsInCombat()
		return combat
	end
end

local uncombat_spec = {} -- array that prevent checking spec out of combat more often then conf.timer_uncombat_delay
function HCoold:RenewSpec(...)
	local spellID, name = ...
	if self:IsInCombat() and self.combat_spec[name] then return false end
	if uncombat_spec[name] then return false end
	local spec = self:GetSpecBySpell(spellID)
	if spec == 0 then return false end
	self.db.faction.players[name]=spec
	if self:IsInCombat() then self.combat_spec[name]=spec
	else
		uncombat_spec[name] = spec
		self:ScheduleTimer(function() uncombat_spec[name] = nil end,self.db.profile.timer_uncombat_delay)
	end
	self:CheckPlayersCDs()
end

function HCoold:CheckPlayersCDs() -- check players cd and add/delete spells if needed
	local raid = self:GetRaidList()
	--[[
		raid = {
			{
				name = <player name>
				CDs = {
					[i] = spell, -- формат исходного спелла
				},
			},
		}
	]]
	-- сначала проверяем какие спеллы надо добавить и делаем это
	for _,member in next, raid do
		for _,spell in next, member.CDs do
			local spell_cont = self:GetSpell(member.name,spell.spellID)
			if not spell_cont then self:AddSpell(member.name,spell) end
		end
	end
	
	-- теперь надо проверить какие спеллы надо удалить и сделать это
	self:DeleteSpells()
	
	-- обновляем фреймы
	self:RenewStatus()
end

function HCoold:StartTimer() -- run timer for updating frames
	self:RenewStatus()
	if HCoold.timer then return nil end
	self.timer = self:ScheduleRepeatingTimer("TimerActions",self.db.profile.timer_delay)
end

function HCoold:TimerActions()
	local find = true
	for _,i in next, self.trackCDs do
		i:Update()
	end
	for k = # self.trackCDs, 1, -1 do 
		if self.trackCDs[k]:GetState() == 1 then table.remove(self.trackCDs,k) end 
	end
	if # self.trackCDs == 0 then
		-- self:Print("cancel timer")
		self:CancelTimer(self.timer,true)
		self.timer = nil
	end
end

do -- save/restor cds between sessions
	function HCoold:SaveSessionCDs(curr)
		local out={
			id = curr.id,
			player = curr.player,
			state_cd_end = curr.state_cd_end,
		}
		if not self.db.faction.LSCDs then self.db.faction.LSCDs = {} end
		table.insert(self.db.faction.LSCDs, out)
	end
	
	function HCoold:GetLastSesstionCD(id,player)
		if not self.db.faction.LSCDs then return -1 end
		local out = -1
		for _,j in next, self.db.faction.LSCDs do
			if j.id == id and j.player == player then out = j.state_cd_end end
		end
		if self:GetDiff(out) < 0 then out = -1 end
		-- self:Printf("getting cd %s %s %s",out,id, player)
		return out 
	end
end















