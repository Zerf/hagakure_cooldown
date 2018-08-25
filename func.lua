if not HCoold then return false end

local backdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "", --"Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = false,
	tileSize = 32,
	edgeSize = 0,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

function HCoold:GetRaidList() --+ get list of raid members with it's cd's
	local out = {}
	for i = 1, GetNumRaidMembers() do
		local name = GetRaidRosterInfo(i) -- , _, subgroup, _, _, class, _, online, isDead
		if self:IsInRaid(name) then table.insert(out,{
			name = name,
			CDs = self:GetCDs(self:GetSpec(i))
		}) end
	end

	return out
end

function HCoold:GetSpec(inc) --+ get player's spec
	local out = {}
	if not tonumber(inc) then 
		for i = 1, GetNumRaidMembers() do
			if select(1,GetRaidRosterInfo(i)) == inc then
				inc = i
			end
		end
	end
	if not tonumber(inc) then return out end
	
	out.name, out.class = select(1,GetRaidRosterInfo(inc)), select(6,GetRaidRosterInfo(inc))
	out.spec = self.db.faction.players[out.name] or 0
	return out
end

function HCoold:GetCDs(inp) --+ get cd's for current class+spec
	local out = {}
	
	for _,v in next, self.spells do
		if v.class == inp.class then
			local succ = false
			for _,k in next, v.specs do if k == inp.spec or k == 0 then succ = true end end
			if succ then table.insert(out,v) end
		end
	end
	
	return out
end

function HCoold:DeleteSpells() --+ delete spells if player change spec etc...
	local raid = self:GetRaidList()
	
	for _, i in next, self.types do
		-- for each type of spells
		for k = # i.spells, 1, -1 do
			local j = i.spells[k]
			-- for each spell check, if it's in CDs of raid
			local find = false
			for _,p in next, raid do
				if p.name == j.player then
					for _,s in next, p.CDs do
						if s.spellID == j.id then find = true end
					end
				end
			end
			if not find then
				j:Hide()
				table.remove(i.spells,k)
			end
		end
		i:SortSpells()
	end
end

do --+ frame renew actions
	function HCoold:RenewStatus() --+ renew status of frames
		-- for each raid cd's type run own Update() function
		for _, i in next, self.types do i:Update() end
	end

	function HCoold:StartCD(...) --+ start cd for player's spell
		--[[
			... = 
				player
				spell
		]]
		local player, spell = ...
		
		local curr = self:GetSpell(player, spell.spellID)
		if curr == nil then return false end
		curr:StartCD()
		self:SaveSessionCDs(curr)
	end
end

do --+ actions with time
	function HCoold:GetEndTime(delay) -- return timestamp+delay
		return time() + delay
	end

	function HCoold:GetDiff(end_time) -- return time - end_time
		return difftime(end_time, time())
	end

	function HCoold:GetTextDiff(end_time) -- return time - end_time in "mm:ss" format
		local diff = self:GetDiff(end_time)
		if diff < 60 then return string.format("%d",diff) end
		if diff > 60 then
			local min_=tonumber(string.format("%.0f", diff/60))
			local sec=diff-min_*60
			if sec<0 then sec=sec+60; min_=min_-1 end
			if sec<10 then sec = "0" .. sec end
			return string.format("%d:%s",min_,sec)
		end
	end

	function HCoold:GetColor(...) -- return color, quality of spell
		--[[
			1 - supergood
			2 - good
			3 - bad
			4 - dead
			5 - offline
			6 - casting
			7 - cooldown
		]]
		local spellID, player = ...
		local quality = nil
		for i = 1, GetNumRaidMembers() do if select(1,GetRaidRosterInfo(i)) == player then
			local isDead = select(9,GetRaidRosterInfo(i))
			local online = select(8,GetRaidRosterInfo(i))
			if not online then quality = 5 end
			if isDead then quality = 4 end
		end end
		
		local spec = HCoold:GetSpec(player)
		local spell = HCoold:GetSpellBySpec(spellID,spec.spec)
		if spell then 
			quality = quality or spell.quality 
		end
		
		quality = quality or 1
		local color = HCoold:GetColorByQuality(quality)
		
		return color, quality
	end

	function HCoold:GetColorByQuality(q) -- return color by quality of color
		local color = ""
		if q == 1 then color = self.db.profile.color.bad
		elseif q == 2 then color = self.db.profile.color.good
		elseif q == 3 then color = self.db.profile.color.supergood
		elseif q == 4 then color = self.db.profile.color.dead
		elseif q == 5 then color = self.db.profile.color.offline
		elseif q == 6 then color = self.db.profile.color.active
		elseif q == 7 then color = self.db.profile.color.cd
		end
		return color
	end
end

function HCoold:GetSpell(...) --+ get frame of spell by id and player name
	local player, spellID = ...
	for _,v in next, self.types do -- for each type of cd 
		for _,i in next, v.spells do -- for each spell run spell:IsSpell
			if i:IsSpell(spellID,player) then
				return i
			end
		end
	end
	
	return nil
end

do -- lock/unlock frames
	function HCoold:UnlockFrames()
		for _,i in next, self.types do i.cont:Show() end
	end
	
	function HCoold:LockFrames()
		for _,i in next, self.types do i.cont:Hide() end
	end
end




























