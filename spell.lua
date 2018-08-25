if not HCoold then return false end

local sp = {}
local fc = {}

------ metatable for spells
sp.data = {
	__eq = function (a1,a2)
		local res = false
		if a1.player == a2.player and a1.id == a2.id then res = true end
		return res
	end,
}

function sp.empty()
	local out = {
		id = 1, -- id of spell
		player = "noname", -- player name
		state = 1, -- spell state  1 - ready 2 - casting 3 - cd
		state_casting_end = -1, -- end of casting spell
		state_cd_end = -1, -- time when end cd
		color = "|cff00ff00", -- color of spell when drawing
		type = 1, -- type of spell  1 - bad 2 - good 3 - super good 4 - dead 5 - offline 6 - casting 7 - cd

		cont = nil,
	}	
	
	do -- function section
		function out:GetState()
			return self.state
		end
			
		function out:SetState(state)
			self.state = state
		end
		
		function out:RunParentSetPoint()
			self.cont.frame:SetHeight(math.max(self.cont.font:GetHeight(),self.cont.icon:GetHeight()))
			if self.parent then 
				self.parent:SortSpells()
			end
		end
		
		function out:SetParent(parent)
			if getmetatable(parent) ~= fc.data then
				error"Wrong metatable for SetParent()"
				return false
			end
			self.parent = parent
		end
		
		function out:SetPoint(frame, point1, point2)
			self.cont.frame:ClearAllPoints()
			if frame == nil then error"Nil spell metatable" end
			if getmetatable(frame) == sp.data then
				point1 = point1 or "TOPLEFT"
				point2 = point2 or "BOTTOMLEFT"
				self.cont.frame:SetPoint(point1, frame.cont.frame, point2)
				return true
			end
			if getmetatable(frame) == fc.data then
				point1 = point1 or "TOPLEFT"
				point2 = point2 or "TOPLEFT"
				self.cont.frame:SetPoint(point1, frame.cont, point2)
				return true
			end
			error"not spell/container metatable!"
		end
		
		function out:IsSpell(id,player)
			if id == self.id and player == self.player then return true
			else return false end
		end
		
		function out:SetWidth(width)
			width = width or HCoold.db.profile.spell.w
			self.cont.font:SetWidth(width - HCoold.db.profile.icon.w)
			self.cont.frame:SetWidth(self.cont.font:GetWidth() + self.cont.icon:GetWidth())
			self.cont.frame:SetHeight(math.max(self.cont.font:GetHeight(),self.cont.icon:GetHeight()))
		end
		
		function out:Hide()
			self.cont.icon:Hide()
			self.cont.font:Hide()
			self.cont.frame:Hide()
		end
		
		function out:Show()
			self.cont.icon:Show()
			self.cont.font:Show()
		end
	end
		
	do -- function sections
		function out:UpdateState()
			if HCoold:GetDiff(self.state_casting_end) > 0 then 
				self.state = 2
			elseif HCoold:GetDiff(self.state_cd_end) > 0 then 
				self.state = 3
				self.state_casting_end = -1
			else 
				self.state = 1 
				self.state_casting_end = -1
				self.state_cd_end = -1
			end
		end
		
		function out:StartCD()
			local spec = HCoold:GetSpec(self.player)
			local spell = HCoold:GetSpellBySpec(self.id,spec.spec)
			if not spell then return false end
			self.state_cd_end = HCoold:GetEndTime(spell.CD)
			if spell.cast_time then 
				self.state_casting_end = HCoold:GetEndTime(spell.cast_time)
			end
			self:Update()
			if self.parent then
				self.parent:AddCDTrack(self)
			end
		end
			
		function out:Update()
			self:UpdateState()
			local t = select(2,HCoold:GetColor(self.id,self.player))
			local diff = nil
			if t < 4 then
				if self.state == 2 then 
					t = 6 
					diff = HCoold:GetTextDiff(self.state_casting_end)
				end
				if self.state == 3 then 
					t = 7 
					diff = HCoold:GetTextDiff(self.state_cd_end)
				end
			end
			diff = diff or ""
			self.cont.font:SetText(string.format("%s%s %s|r",diff,HCoold:GetColorByQuality(t),self.player,t,self.state))
			if t ~= self.type then
				self.type = t
				self:RunParentSetPoint(self)
			end
		end
	end
		
	return out
end

function sp.create_cont(id,color,name,cont)
	--local texture_name = "HagakureSpellTexture" .. out.id
	local icon = cont:CreateTexture(nil, "OVERLAY")
	local icon_ = select(3, GetSpellInfo(id))
	icon:SetWidth(HCoold.db.profile.icon.w)
	icon:SetHeight(HCoold.db.profile.icon.h)
	-- icon:SetPoint("TOPLEFT")
	icon:SetTexture(icon_)

	-- text_name = "HagakureSpell" .. sp_id .. name
	local font = cont:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall") -- container for spell info
	font:SetText(string.format("%s%s|r",color,name))
	font:SetWidth(HCoold.db.profile.spell.w)
	font:SetPoint("LEFT",icon,"RIGHT")
	font:SetJustifyH("LEFT")
	font:SetJustifyV("TOP")
	
	local frame = CreateFrame("Frame",nil,cont) -- frame for aligns
	frame:SetWidth(HCoold.db.profile.spell.w + HCoold.db.profile.icon.w)
	frame:SetHeight(HCoold.db.profile.icon.h)--math.max(HCoold.db.profile.icon.h or font:GetHeight()))
	icon:SetPoint("TOPLEFT",frame,"TOPLEFT")
	
	--[[
	frame:SetBackdrop({
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
	})
	-- ]]
	
	local out = {
		icon = icon,
		font = font,
		frame = frame,
	}
	
	return out
end

function sp.new(sp_id,name,cont)
	cont = cont or UIParent
	local t = sp.empty()
	setmetatable(t, sp.data)
	t.state_cd_end = HCoold:GetLastSesstionCD(sp_id,name)
	
	t.id = sp_id -- id of spell
	t.player = name -- player name
	t.color, t.type = HCoold:GetColor(sp_id,name) -- color of spell when drawing + type of spell

	t.cont = sp.create_cont(sp_id,t.color,name,cont)
	
	return t
end

------- metatable for container for spells
fc.data = {}

function fc.new(t)
	local f = {}
	setmetatable(f,fc.data)
	
	f.type = t -- type of cd
	
	do -- frame for anchor
		f.width = HCoold.db.profile.types[t].w or 100
		f.height = HCoold.db.profile.group.h
		f.status = {
			top = 0,
			left = 0,
			point = "BOTTOMLEFT",
		}
		
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:SetWidth(f.width)
		frame:SetHeight(f.height)
		frame:SetPoint("BOTTOMLEFT")
		frame:Hide()
		frame:EnableMouse()
		frame:SetClampedToScreen(true)
		frame:SetMovable(true)
		frame:SetScript("OnMouseDown",function() frame:StartMoving() end )
		frame:SetScript("OnMouseUp",function() 
			frame:StopMovingOrSizing() 
			f.status.top = frame:GetTop()
			f.status.left = frame:GetLeft()
			--HCoold:Printf("%d %d %s",f.status.top, f.status.left,type(frame:GetTop()))
			f.SavePoint("BOTTOMLEFT",frame:GetLeft(),frame:GetTop())
		end)
		
		--[[
		local t = frame:CreateTexture(nil,"OVERLAY")
		t:SetPoint("TOPLEFT",frame,"TOPLEFT")
		t:SetPoint("BOTTOMRIGHT",frame,"BOTTOMRIGHT")
		t:SetTexture("Interface\\AddOns\\hagakure\\second\\Button-Highlight")
		t:SetGradient("HORIZONTAL",1,0,0,0,0,0)
		frame.texture = t
		--]]
		
		-- [[
		frame:SetBackdrop({
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
		})
		--frame:SetBackdropColor(1,0,0,1)
		--]]
		
		f.cont = frame -- frame anchor for align
	end
	
	f.spells = {} -- table, that contains spells with type of container
	f.trackCD = {} -- table, that contains links to spells that are CDs
	f.sort_method = HCoold.db.profile.types[t].sm or 1 -- method of sorting spells
	f.enable = true -- enable/disable type of spells

	do -- function section
		f.SavePoint = nil
		
		function f:AddSpell(spell) -- add spell in spell list
			if getmetatable(spell) ~= sp.data then error"Not a spell metatable!"; return false end
			table.insert(self.spells, spell)
			spell:SetParent(self)
			spell:SetWidth(self.width)
			self:SortSpells()
			-- and now we need to check if spell is on CD, if it's so, then we need to add it to cd list and run timer
			spell:Update()
			if spell.state > 1 then self:AddCDTrack(spell) end
			if not f.enable then spell:Hide() end
		end
		
		function f:SetWidth(width)
			self.width = width
			self.cont:SetWidth(width)
			for _, i in next, self.spells do i:SetWidth(self.width) end
		end
		
		function f:SetSortMethod(i)
			self.sort_method = i
			HCoold.db.profile.types[self.type].sm = i
			self:SortSpells()
		end
		
		function f:Update() -- full update of container with spells
			for _,i in next, self.spells do i:Update() end
		end
		
		function f:SortSpells() -- realign spells on screen
			if # f.spells == 0 then return false end
			table.sort(self.spells,function (a1,a2)
					-- sort table with spells by spell type
					-- 1 - bad 2 - good 3 - supergood 4 - dead 5 - offline 6 - casting 7 - cooldown
					local t1,t2 = a1.type, a2.type
					if t1 == 3 then t1 = -1 end
					if t2 == 3 then t2 = -1 end
					if t2 == 1 then t2 = 2.5 end
					if t1 == 1 then t1 = 2.5 end
					if t1 == 4 or t1 == 5 then t1 = t1 + 4 end
					if t1 == 6 then t1 = -3 end
					if t2 == 4 or t2 == 5 then t2 = t2 + 4 end
					if t2 == 6 then t2 = -3 end
					if t1 < t2 then return true end
					if t1 == t2 then return a1.player<a2.player end
					return false
				end)
			-- now first one points to frame, and then others
			local sm = HCoold.sort_methods[self.sort_method]
			self.spells[1]:SetPoint(self,sm.fpoint1,sm.fpoint2)
			for i = 2, # self.spells do
				self.spells[i]:SetPoint(self.spells[i-1],sm.point1,sm.point2)
			end
		end
	
		function f:SetPoint(x,y,point) -- setpoint of align frame
			point = point or "BOTTOMLEFT"
			x = x or 0
			y = y or 0
			self.status.top = y
			self.status.left = x
			self.status.point = point
			self.cont:SetPoint(point,x,y)
			if self.SavePoint then
				self.SavePoint(point,x,y)
			end
		end
		
		function f:SetFuncSavePoint(func)
			self.SavePoint = func
		end
		
		function f:AddCDTrack(spell) -- add spell in array for traking cd
			table.insert(self.trackCD,spell)
			HCoold:StartTimer()
		end
		
		function f:Hide()
			self.cont:Hide()
			for _, i in next, self.spells do i:Hide() end
		end
		
		function f:Show()
			for _, i in next, self.spells do i:Show() end
		end
		
		function f:SetTrackCDs(arr) -- set parent's array, that contains spells with cd
			self.trackCD = arr
		end
		
		function f:Enable(state)
			if state == nil then return self.enable end
			self.enable = state
			if self.enable then self:Show()
			else self:Hide() end
		end
		
		function f:IsCD()
			return # self.trackCD > 0
		end
	end
	
	return f
end

function HCoold:MakeSpellGroups() -- make groups for spells
	local t = {}
	local types = {}
	self.trackCDs = {}
	for _,i in next, self.spells do t[i.type]=true end
	for k in next, t do 
		local ss = fc.new(k)
		ss:SetFuncSavePoint(function(...)
			local point,left,top = ...
			self.db.profile.types[k].left,self.db.profile.types[k].top,self.db.profile.types[k].point = left, top, point
		end)
		-- self:Printf("%s %s %s",self.db.profile.types[k].left,self.db.profile.types[k].top,self.db.profile.types[k].point)
		ss:SetPoint(self.db.profile.types[k].left,self.db.profile.types[k].top,self.db.profile.types[k].point)
		ss:SetTrackCDs(self.trackCDs)
		ss:Enable(self.db.profile.types[k].enable)
		types[k] = ss
	end
	self.types = types
end

function HCoold:AddSpell(...) -- add spell if player change spec or change groups etc...
	--[[
		... = 
			name = player's name
			spell = link to spell from spells.lua that we need to add
	]]
	local name, spell = ...

	local sp = sp.new(spell.spellID,name)
	self.types[spell.type]:AddSpell(sp)
end





























