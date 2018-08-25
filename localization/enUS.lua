local addon_name = "hagakure_cooldowns"
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(addon_name, "enUS",true,true)
if not L then return false end

L["Hagakure cooldowns"] = "Hagakure cooldowns"

L["lock frames"] = "Lock"
L["desc lock frames"] = "block anchor frames for drag"
L["unlock frames"]="Release"
L["desc unlock frames"]="release anchor frames for drag"
L["run config"]="Settings"
L["desc run config"]="launch addon settings"
L["spells"]="Spells"
L["desc spells"]="List of spells by categories that are tracked by the system"
L["redraw"]="Redraw"
L["desc redraw"]="Redraw using new spell table"
L["show/hide all"]="Hide/show"
L["desc show/hide all"]="Hide (show) all frames from tracked cooldowns"

L["|cffff0000Hagakure cooldowns, greet %s! run /hcd"] = "|cffff0000Addon Hagakure cooldowns successfully loaded, %s!|r Launch |cff00ffff/hcd|r for addon settings."

L["class %s specs %s"]="|cff00ff00%s|r |cffff0000%s|r"

L["No spell found"] = "|cffff0000Spell is not found!|r"
L["Spell name %s class %s specs %s"]="Спелл |cff00ffff%s|r |cff00ff00%s|r |cffff0000%s|r"
 
 do -- types of spells
	L["turn all off"] = "track nothing"
	L["desc turn all off"] = "Turn off tracking of all spells in this group"
	L["turn all on"] = "track all"
	L["desc turn all on"] = "Turn on tracking of all spells in this group"
	
	L["type1"]="-damage +heal"
	L["desc type1"]="Spells, which casts on all raiders, increasing +heal on targets, or reduce incoming damage"
	L["header1"] = "Setting up for the frame with the cooldowns on -damage +heal"
	L["type width1"]="Width"
	L["desc type width1"]="The width of the frame with the cooldowns on -damage +heal"
	L["sort method1"] = "Sorting"
	L["desc sort method1"] = "Sorting of the frame with the cooldowns on -damage +heal"
	L["enable1"] = "Display"
	L["desc enable1"] = "Display frame with the cooldowns on -damage +heal"
	
	L["type2"]="AoE heal"
	L["desc type2"]="Mass healing spells"
	L["header2"] = "Setting up for the frame with the cooldowns on AoE heal"
	L["type width2"]="Width"
	L["desc type width2"]="The width of the frame with the cooldowns on AoE heal"
	L["sort method2"] = "Sorting"
	L["desc sort method2"] = "Sorting of the frame with the cooldowns on AoE heal"
	L["enable2"] = "Display"
	L["desc enable2"] = "Display frame with the cooldowns on AoE heal"
	
	L["type3"]="for mana"
	L["desc type3"]="Spells increasing mana of raid / raider"
	L["header3"] = "Setting up for the frame with the cooldowns on mana"
	L["type width3"]="Width"
	L["desc type width3"]="The width of the frame with the cooldowns on mana"
	L["sort method3"] = "Sorting"
	L["desc sort method3"] = "Sorting of the frame with the cooldowns on mana"
	L["enable3"] = "Display"
	L["desc enable3"] = "Display frame with the cooldowns on mana"
	
	L["type4"]="self cd"
	L["desc type4"]="Spells which reduce incoming damage to player"
	L["header4"] = "Setting up for the frame with the self cooldowns"
	L["type width4"]="Width"
	L["desc type width4"]="The width of the frame with the self cooldowns"
	L["sort method4"] = "Sorting"
	L["desc sort method4"] = "Sorting of the frame with the self cooldowns"
	L["enable4"] = "Display"
	L["desc enable4"] = "Display frame with the self cooldowns"
	
	L["type5"]="target cd"
	L["desc type5"]="Spells, which can be used at another player."
	L["header5"] = "Setting up for the frame with the target cooldowns"
	L["type width5"]="Width"
	L["desc type width5"]="The width of the frame with the direct cooldowns"
	L["sort method5"] = "Sorting"
	L["desc sort method5"] = "Sorting of the frame with the direct cooldowns"
	L["enable5"] = "Display"
	L["desc enable5"] = "Display frame with the direct cooldowns"

	L["type6"]="cd for +damage"
	L["desc type6"]="Spells that increase raid dps"
	L["header6"] = "Setting up for the frame with the cooldowns on +damage"
	L["type width6"]="Width"
	L["desc type width6"]="The width of the frame with the on +damage"
	L["sort method6"] = "Sorting"
	L["desc sort method6"] = "Sorting of the frame with the cooldowns on +damage"
	L["enable6"] = "Display"
	L["desc enable6"] = "Display frame with the cooldowns on +damage"
	
	L["type7"]="rebirth"
	L["desc type7"]="Spells, which rebirth dead allies"
	L["header7"] = "Setting up for the frame with the cooldowns on rebirth"
	L["type width7"]="Width"
	L["desc type width7"]="The width of the frame with the cooldowns on rebirth"
	L["sort method7"] = "Sorting"
	L["desc sort method7"] = "Sorting of the frame with the cooldowns on rebirth"
	L["enable7"] = "Display"
	L["desc enable7"] = "Display frame with the cooldowns on rebirth"
	
	L["type8"]="mix"
	L["desc type8"]="Spells, that can be usefull"
	L["header8"] = "Setting up for the frame with mix cooldowns"
	L["type width8"]="Width"
	L["desc type width8"]="The width of the frame with mix cooldowns"
	L["sort method8"] = "Sorting"
	L["desc sort method8"] = "Sorting of the frame with mix cooldowns"
	L["enable8"] = "Display"
	L["desc enable8"] = "Display frame with mix cooldowns"

	L["type9"]="control"
	L["desc type9"]="Spells, that limit enemy action"
	L["header9"] = "Setting up for the frame with control spells"
	L["type width9"]="Width"
	L["desc type width9"]="The width of the frame with control spells"
	L["sort method9"] = "Sorting"
	L["desc sort method9"] = "Sorting of the frame with control spells"
	L["enable9"] = "Display"
	L["desc enable9"] = "Display frame with control spells"

	L["type10"]="personal +damage"
	L["desc type10"]="Spells, that increase damage/healing of player"
	L["header10"] = "Setting up for the frame with personal +damage"
	L["type width10"]="Width"
	L["desc type width10"]="The width of the frame with personal +damage"
	L["sort method10"] = "Sorting"
	L["desc sort method10"] = "Sorting of the frame with personal +damage"
	L["enable10"] = "Display"
	L["desc enable10"] = "Display frame with personal +damage"
end

do -- description of fort methods
	L["from top to bottom"] = "From top to bottom"
	L["from left to right"] = "From left to right"
	L["from right to left"] = "From right to left"
	L["from bottom to top"] = "From bottom to top"
end

do -- spec list
	L["PALADIN"]="paladin"
	L["PALADIN0"]="all specs"
	L["PALADIN1"]="holy spec"
	L["PALADIN2"]="protection spec"
	L["PALADIN3"]="retribution spec"
	L["PALADIN1, 3"]="holy and retribution specs"
	L["PALADIN2, 3"]="protection and retribution specs"
	L["PALADIN1, 2"]="holy and protection specs"

	L["WARRIOR"]="warrior"
	L["WARRIOR0"]="all specs"
	L["WARRIOR1"]="all specs"
	L["WARRIOR2"]="all specs"
	L["WARRIOR3"]="protection spec"
	L["WARRIOR1, 2"]="arms, fury specs"
	L["WARRIOR1, 3"]="arms, protection specs"
	L["WARRIOR2, 3"]="fury, protection specs"

	L["PRIEST"]="priest"
	L["PRIEST0"]="all specs"
	L["PRIEST1"]="discipline spec"
	L["PRIEST2"]="holy spec"
	L["PRIEST3"]="shadow spec"
	L["PRIEST1, 3"]="disciplin and shadow specs"
	L["PRIEST1, 2"]="disciplin and holy specs"
	L["PRIEST2, 3"]="holy and shadow specs"

	L["SHAMAN"]="shaman"
	L["SHAMAN0"]="all specs"
	L["SHAMAN1"]="elemental spec"
	L["SHAMAN2"]="enhancement spec"
	L["SHAMAN3"]="restoration spec"
	L["SHAMAN1, 3"]="elemental and restoration specs"
	L["SHAMAN2, 3"]="enhancement and restoration specs"
	L["SHAMAN1, 2"]="elemental and enhancement specs"

	L["DEATHKNIGHT"]="death knight"
	L["DEATHKNIGHT0"]="all specs"
	L["DEATHKNIGHT1"]="blood spec"
	L["DEATHKNIGHT1"]="frost spec"
	L["DEATHKNIGHT3"]="unholy spec"
	L["DEATHKNIGHT1, 3"]="blood and unholy specs"
	L["DEATHKNIGHT2, 3"]="frost and unholy specs"
	L["DEATHKNIGHT1, 2"]="blood and frost specs"

	L["DRUID"]="druid"
	L["DRUID0"]="all specs"
	L["DRUID1"]="balance spec"
	L["DRUID2"]="feral spec"
	L["DRUID3"]="restoration spec"
	L["DRUID1, 3"]="balance and restoration specs"
	L["DRUID2, 3"]="feral and restoration specs"
	L["DRUID1, 2"]="balance and feral specs"

	L["HUNTER"]="hunter"
	L["HUNTER0"]="all specs"
	L["HUNTER1"]="beast mastery spec"
	L["HUNTER2"]="marksmanship spec"
	L["HUNTER3"]="survival spec"
	L["HUNTER2, 3"]="marksmanship and survival specs"
	L["HUNTER1, 3"]="beast mastery and survival specs"
	L["HUNTER1, 2"]="beast mastery and marksmanship specs"

	L["ROGUE"]="rogue"
	L["ROGUE0"]="all specs"
	L["ROGUE1"]="assassination spec"
	L["ROGUE2"]="combat spec"
	L["ROGUE3"]="subtlety spec"
	L["ROGUE1, 3"]="assassination and subtlety specs"
	L["ROGUE2, 3"]="combat and subtlety specs"
	L["ROGUE1, 2"]="assassination and combat specs"

	L["MAGE"]="mage"
	L["MAGE0"]="all specs"
	L["MAGE2"]="arcan spec"
	L["MAGE2"]="fire spec"
	L["MAGE3"]="frost spec"
	L["MAGE1, 3"]="arcan and frost specs"
	L["MAGE2, 3"]="fire and frost specs"
	L["MAGE1, 2"]="arcan and fire specs"

	L["WARLOCK"]="warlock"
	L["WARLOCK0"]="all specs"
	L["WARLOCK1"]="affliction spec"
	L["WARLOCK2"]="demonology spec"
	L["WARLOCK3"]="destruction spec"
	L["WARLOCK1, 3"]="affliction and destruction specs"
	L["WARLOCK2, 3"]="demonology and destruction specs"
	L["WARLOCK1, 2"]="affliction and demonology specs"
end

do -- font+color config
	L["color setup"] = "Color settings"
	L["font name"] = "Font"
	L["desc font name"] = "The font used for drawing frame"
	L["font size"] = "Size"
	L["desc font size"] = "The size of the font used when drawing frames"
	L["icon size"] = "Ion"
	L["desc icon size"] = "Size of usual spell's icon"
	
	L["exl spell color"] = "Perfect"
	L["desc exl spell color"] = "The color which used for perfect cooldowns"
	L["good spell color"] = "Good"
	L["desc good spell color"] = "The color which used for good cooldowns"
	L["bad spell color"] = "Bad"
	L["desc bad spell color"] = "The color which used for bad cooldowns"
	L["off spell color"] = "Offline"
	L["desc off spell color"] = "The color which used for cooldowns of offline players" 
	L["dead spell color"] = "Dead"
	L["desc dead spell color"] = "The color which used for cooldowns of dead players"
	L["cd spell color"] = "On cooldown"
	L["desc cd spell color"] = "The color which used for timer which show recovery of spells"
end

do -- active spells frame
	L["active spell frame"] = "Active spells"
	L["active spells"] = "Config for frame, that contains currently casting spells"
	L["actspell width"] = "width"
	L["desc actspell width"] = "Width of icon currently casting spell"
	L["actspell sort method"] = "Sorting"
	L["actspell desc sort method"] = "Sorting of the frame with currently casting spells"
	L["actspell enable"] = "enable"
	L["actspell desc enable"] = "Enable frame with currently casting spells"
	L["ac names enable"] = "Show names"
	L["desc ac names enable"] = "Show names when drawing active spells"
	
	L["ac cancel by click"] = "Cancel by click"
	L["desc ac cancel by click"] = "Disable drawing spell in active spell's frame by clicking on it."
end

do -- Expert settings
	L["test mod"] = "Test mode"
	L["desc test mod"] = "Turn on/off test mode."
	L["expert"] = "Expert"
	L["desc expert"] = "Configure additional settings."
	L["track groups"]="Groups"
	L["desc track groups"]="Track CDs only members of first this groups"
	
	L["fast timer"]="Fast tick"
	L["desc fast timer"]="Time between ticks of timer, when some spell's cd is going to end (min value is 1/11 from AceTimer)"
	L["slow timer"]="Slow tick"
	L["desc slow timer"]="Time between check CD in normal mod"
	L["min time"]="threshold"
	L["desc min time"]="The threshold of CD to run"
	
	L["announce CDs"]="Announcing end of CDs"
	
	L["ann rw"] = "Raid warning"
	L["desc ann rw"] = "After cooldown is ready announce through raid warning."
	L["ann raid"] = "Raid"
	L["desc ann raid"] = "After cooldown is ready announce through raid channel."
	L["ann say"] = "Say"
	L["desc ann say"] = "After cooldown is ready announce through /say."
	L["ann yell"] = "Yell"
	L["desc ann yell"] = "After cooldown is ready announce through /yell."
	L["ann self"] = "Chat"
	L["desc ann self"] = "After cooldown is ready announce own chat."
	L["ann only rl"] = "Only when assist"
	L["desc ann only rl"] = "Announce spell CDs in public channels (/rw /raid /yell /say) only with assist or RL status."
	L["ann party"] = "Group"
	L["desc ann party"] = "After cooldown is ready announce through party channel."
	
	L["announce CDs start"] = "Announce spell CD start"
	L["ann self start"] = "announce start"
	L["desc ann self start"] = "Announce spell CD start to own chat."

	L["addon announce"] = "Alert through raid addons"
	L["ann DBM"] = "DBM"
	L["desc ann DBM"] = "Allert about CD's end through DBM"
	L["ann DXE"] = "DXE"
	L["desc ann DXE"] = "Allert about CD's end through DXE"
	L["ann BigWigs"] = "BigWigs"
	L["desc ann BigWigs"] = "Allert about CD's end through BigWigs"
	
	L["Spell %s of %s is ready!"] = "Spell %s of %s is ready!"
	L["%s casted %s."] = "%s casted %s."
end

do -- manual configuration section
	L["Manual spell settings"] = "Manual spell settings"
	L["Personal spells"] = "Manual settings"
	L["desc presonal spells"] = "Create new/modify existing spells for exact player"
	L["Add spell"] = "Add"
	
	L["Enter player name"] = "Enter the name of the player\nyou want to configure spell"
	L["Enter CD of spell in sec"] = "Enter CD of spell\nin seconds"
	L["Enter id of spell"] = "Enter ID of spell\n(it can be found at wowhead.com \nand other similar sites)"
	L["Add new spell options for current player."] = "Add new settings for a particular player's cooldown."
	L["Enter casting time of spell"] = "Enter the duration of the spell\nif a spell hangs a positive effect\nwhich lasts for some time,\nthis time, you can specify here."
	L["Enter trigger event from combat log"] = "Enter the event from the combat log\nwhich triggers the cooldown of spell"
	L["Enter quality of spell"] = "Enter the quality of the spell\nthis parameter for sorting\nwill put a spell above the other."
	
	L["Configuration for %s spell"] = "Configuration of spell %s"
	L["Delete"] = "Delete"
	L["Deleted"] = "Deleted"
	L["You realy want to delete spell %s?"] = "Confirm delete spell %s."
	
	L["Spell %s(id=%d, type=%s, quality=%d, specs=%s) for player %s has CD %d sec cast time %.1f and trigger from %s."] = 
		"Spell %s (id=%d, type=\"%s\", quality=%d, specs=\"%s\") for player |cffff0000%s|r has a recovery time |cffff0000%d|r seconds (duration %.1f sec) triggers from %s event."
	
	L["Track spell"] = "Track spell"
	
	L["Spec list by class"] = "Death Knight 1 - blood 2 - frost 3 - unholy\nDruid 1 - balance 2 - feral 3 - restoration\n" ..
		"Hunter 1 - beast mastery 2 - marksmanship 3 - survival\nMage 1 - arcane 2 - fire 3 - frost\n" ..
		"Paladin 1 - holy 2 - protection 3 - retribution\nPriest 1 - discipline 2 - holy 3 - shadow magic\n" ..
		"Rogue 1 - assassination 2 - combat 3 - subtlety\nShaman 1 - elemental combat 2 - enchancement 3 - restoration\n" ..
		"Warlock 1 - affliction 2 - demonology 3 - destruction\nWarrior 1 - arms 2 - fury 3 - protection\n|cffff00000 - suitable for all specializations|r"
	L["Cooldown successfully added!"] = "Spell is added successfully!"
	L["You should enter spell id, player name and cooldown of spell."] = "|cffff0000You must specify the ID spell, player's name and spell's cooldown!|r"
	L["Cooldown successfulle deleted!"] = "Spell successfully removed!"
	L["Don't forget to redraw layout to aply settings."] = "Do not forget to redraw the container for the changes to take effect."
end

do -- Bar's settings
	L["Bar settings"] = "Bar settings"
	L["bars enable"] = "enable bars"
	L["desc bars enable"] = "Enable bars when drawing spells CD"
	L["bar background enable"] = "enable background"
	L["desc bar background enable"] = "Enable background when drawing spells"
	
	L["bar bg color"] = "background color"
	L["desc bar bg color"] = "Color that will be user for background"
	L["bar casting spell color"] = "color of casting spell"
	L["desc bar casting spell color"] = "Color for bars that will be used for drawing spell, that currently is casting"
	L["bar cd spell color"] = "color of CD"
	L["desc bar cd spell color"] = "Color for bars that will be used for drawing spell, that currently on cooldown"
	L["bar texture"] = "bar texture"
	L["desc bar texture"] = "Texture that will be used for drawing bars and background"
end








