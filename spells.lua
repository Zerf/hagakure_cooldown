if not HCoold then return false end
local L = HCoold:GetLocale()

local spells = { -- spells that we can track by system
	{ -- для отладки Шок небес
		spellID = 25914, -- ID спелла
		class = "PALADIN", -- класс, которому принадлежит спелл
		CD = 6, -- кулдаун в секундах у спела
		specs = { 1 },
		succ = "SPELL_HEAL", -- тип ивента, который означает удачное применение спелла
		type = 1,  --[[ тип спелла: 
				1 - аура на -дамаг (купол, мастер аур и тд) 
				2 - аое хил (гимн пристов, транквил) 
				3 - на ману (иннеры, гимн на ману, мана тайд) 
				4 - личный кд (айс блок, шв, бабл, отражение) 
				5 - точечный кд (пс, крылья, придание сил)
				6 - кд на +дамаг (варовский -армор, бл)
				7 - возрождения (друид, шаман, дк, лок)
			]]
		cast_time = 0, -- время действия спелла
		quality = 3, -- качество спелла при сортировке 1/nil - плохое 2 - хорошее 3 - лучшее
	},
------ type == 1  аура на -дамаг +хил
	{ -- мастер аура
		spellID = 31821,
		class = "PALADIN", 
		succ = "SPELL_CAST_SUCCESS", --"SPELL_AURA_APPLIED",
		specs = { 1 },
		CD = 120,
		type = 1,
		cast_time = 6,
		quality = 1,
	},
	{ -- божественный защитник
		spellID = 70940,
		CD = 180,
		specs = { 2 },
		succ = "SPELL_CAST_SUCCESS",
		class = "PALADIN",
		type = 1,
		quality = 3,
		cast_time = 6,
	},
	{ -- ободрящий клич 
		spellID = 97462,
		CD = 180,
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		class = "WARRIOR",
		type = 1,
		quality = 1,
		cast_time = 10,
	},
	{ -- купол прист
		spellID = 62618,
		class = "PRIEST", 
		succ = "SPELL_CAST_SUCCESS", --"SPELL_AURA_APPLIED",
		specs = { 1 },
		CD = 180,
		type = 1,
		cast_time = 10,
		quality = 3,
	},
	{ -- тотем шаман
		spellID = 98008,
		class = "SHAMAN", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 3 },
		CD = 180,
		type = 1,
		cast_time = 6,
		quality = 3,
	},
	{ -- +хил дк
		spellID = 55233,
		class = "DEATHKNIGHT", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 1 },
		CD = 60,
		type = 1,
		cast_time = 10,
		quality = 2,
	},
	{ -- +хил дру ферал
		spellID = 22842,
		class = "DRUID", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 2 },
		CD = 180,
		type = 1,
		cast_time = 20,
		quality = 3,
	},
	{ -- купол анхоли дк
		spellID = 51052,
		class = "DEATHKNIGHT", 
		succ = "SPELL_CAST_SUCCESS",
		specs = { 3 },
		CD = 120,
		type = 1,
		cast_time = 10,
		quality = 2,
	},


------ type == 2 аое хил
	{ -- божественный гимн
		spellID = 64843,
		succ = "SPELL_CAST_SUCCESS",
		CD = 480,
		specs = { 1, 3 },
		class = "PRIEST",
		type = 2,
		cast_time = 8,
	}, 
	{ -- божественный гимн holy
		spellID = 64843,
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		specs = { 2 },
		class = "PRIEST",
		type = 2,
		quality = 3,
		cast_time = 8,
	}, -- [8]
	{ -- спокойствие дру feral
		spellID = 740,
		succ = "SPELL_CAST_SUCCESS",
		CD = 480,
		specs = { 2 },
		class = "DRUID",
		type = 2,
		quality = 1,
		cast_time = 8,
	},
	{ -- спокойствие дру balance
		spellID = 740,
		succ = "SPELL_CAST_SUCCESS",
		CD = 480,
		specs = { 1 },
		class = "DRUID",
		type = 2,
		quality = 2,
		cast_time = 8,
	},
	{ -- спокойствие дру restor
		spellID = 740,
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		specs = { 3 },
		class = "DRUID",
		type = 2,
		quality = 3,
		cast_time = 8,
	},


------ type == 3 на ману
	{ -- гимн надежды
		spellID = 64901, -- 64904 - проки на ману
		succ = "SPELL_CAST_SUCCESS",
		CD = 360,
		specs = { 0 },
		class = "PRIEST",
		type = 3,
		quality = 3, 
		cast_time = 8,
	},
	{ -- озарение
		spellID = 29166,
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		specs = { 1, 3 },
		class = "DRUID",
		type = 3,
		quality = 2, 
		cast_time = 10,
	},
	{ -- озарение feral
		spellID = 29166,
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		specs = { 2 },
		class = "DRUID",
		type = 3,
		quality = 1, 
		cast_time = 10,
	},
	{ -- мана тайд
		spellID = 16190,
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		specs = { 3 },
		class = "SHAMAN",
		type = 3,
		quality = 3, 
		cast_time = 12,
	},


------ type == 4  личный кд <---------------
	{ -- Сдерживание 
		spellID = 19263,
		class = "HUNTER",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		type = 4,
		quality = 3,
		cast_time = 5,
	}, 
	{ -- слияние с тьмой
		spellID = 47585,
		class = "PRIEST",
		specs = { 3 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		type = 4,
		quality = 3,
		cast_time = 6,
	}, 
	{ -- шв у прот пала пала
		spellID = 86150, -- 86698
		class = "PALADIN",
		specs = { 2 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		type = 4,
		cast_time = 12,
	},
	{ -- ревностный защитник
		spellID = 31850,
		class = "PALADIN",
		specs = { 2 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		type = 4,
		quality = 2,
		cast_time = 10,
	},
	{ -- шв у прот пала вара
		spellID = 871,
		class = "WARRIOR",
		specs = { 3 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		type = 4,
		cast_time = 12,
	},
	{ -- плащ теней рога
		spellID = 31224,
		class = "ROGUE",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		type = 4,
		cast_time = 5,
	},
	{ -- леденая глыба маг
		spellID = 45438,
		class = "MAGE",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 300,
		type = 4,
		cast_time = 10,
	},
	{ -- прижиание файер маг
		spellID = 87023,
		class = "MAGE",
		specs = { 2 },
		succ = "SPELL_AURA_APPLIED",
		CD = 60,
		type = 4,
		cast_time = 0,
	},
	{ -- бабл
		spellID = 642,
		class = "PALADIN",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 300,
		type = 4,
		cast_time = 8,
	},


------ type == 5   точечный кд
	{ -- крылья 
		spellID = 47788,
		class = "PRIEST",
		specs = { 2 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		type = 5,
		quality = 3,
		cast_time = 10,
	},
	{ -- пска 
		spellID = 33206,
		class = "PRIEST",
		specs = { 1 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 180,
		type = 5,
		quality = 3,
		cast_time = 8,
	},
	{ -- сакрифайс от не прота 
		spellID = 6940,
		class = "PALADIN",
		specs = { 1, 3 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		type = 5,
		cast_time = 12,
	},
	{ -- сакрифайс от прота 
		spellID = 6940,
		class = "PALADIN",
		specs = { 2 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 120,
		type = 5,
		quality = 2,
		cast_time = 12,
	},
	{ -- фридом
		spellID = 1044,
		class = "PALADIN",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 25,
		type = 5,
		quality = 1,
		cast_time = 6,
	},
	{ -- боп
		spellID = 1022,
		class = "PALADIN",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 300,
		type = 5,
		quality = 2,
		cast_time = 10,
	},
	{ -- лох
		spellID = 633,
		class = "PALADIN",
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		CD = 600,
		type = 5,
		quality = 2,
		cast_time = 0,
	},


------ type == 6  кд на +дамаг 
	{ -- Сокрушительный бросок	
		spellID = 64382,
		CD = 300,
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		class = "WARRIOR",
		type = 6,
		quality = 2,
		cast_time = 10,
	},
	{ -- шаман бл
		spellID = 2825,  -- за аликов 32182
		CD = 300,
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		class = "SHAMAN",
		type = 6,
		quality = 3,
		cast_time = 40,
	},
	{ -- маг бл
		spellID = 80353,
		CD = 300,
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		class = "MAGE",
		type = 6,
		quality = 3,
		cast_time = 40,
	},
	{ -- хантер бл ??????????????????????
		spellID = 90355,
		CD = 360,
		specs = { 0 },
		succ = "SPELL_CAST_SUCCESS",
		class = "HUNTER",
		type = 6,
		quality = 3,
		cast_time = 40,
	},


------ type == 7  возрождения
	{ -- возрождение Дру 
		spellID = 20484,
		succ = "SPELL_CAST_START", -- SPELL_RESURRECT
		specs = { 0 },
		CD = 600,
		class = "DRUID",
		type = 7,
		quality = 3,
	},
	{ -- возрождение ДК 
		spellID = 61999,
		succ = "SPELL_CAST_SUCCESS", 
		specs = { 0 },
		CD = 600,
		class = "DEATHKNIGHT",
		type = 7,
		quality = 2,
	},
	{ -- перерождение шам ???????????????????
		spellID = 20608,
		succ = "SPELL_CAST_SUCCESS", 
		specs = { 0 },
		CD = 1800,
		class = "SHAMAN",
		type = 7,
		quality = 1,
	},
	{ -- воскрешение камнем души
		spellID = 20707,
		succ = "SPELL_CAST_START", 
		specs = { 0 },
		CD = 900,
		class = "WARLOCK",
		type = 7,
		quality = 1,
	},


------ type == 8  станы
}

local spec_spells = { -- uniq for spec spell that can be used to determine spec of player
	{ -- паладин 1 holy 2 prot 3 retri
		class = "PALADIN",
		specs = {
			[1] = { -- holy
				[1] = { -- частица
					id = 53563,
				},
				[2] = { -- шок небес
					id = 25914,
				},
				[4] = { -- свет зари
					id = 85222,
				},
				[5] = { -- мастер аур
					id = 31821,
				},
				[6] = { -- божественное одобрение
					id = 31842,
				},
				[7] = { -- озаряющее исцеление
					id = 86273,
				},
				[8] = { -- прилив света
					id = 53576,
				},
			},
			[2] = { -- prot
				[1] = { -- щит мстителя
					id = 31935,
				},
				[2] = { -- отмщение ??
					id = 0,
				},
				[3] = { -- мудрое правосудие?
					id = 31930,
				},
				[4] = { -- молот праведника 
					id = 53595,
				},
				[5] = { -- щит праведника
					id = 53600,
				},
				[6] = { -- щит небес
					id = 20925,
				},
				[7] = { -- божественный защитник
					id = 70940,
				},
				[8] = { -- ревностный защитник
					id = 31850,
				},
			},
			[3] = { -- retri
				[1] = { -- божественный замысел
					id = 90174,
				},
				[2] = { -- вердикт храмовника
					id = 85256,
				},
				[3] = { -- могущественное правосудие
					id = 89906,
				},
				[4] = { -- божественная буря
					id = 53385,
				},
				[6] = { -- фанатизм
					id = 85696,
				},
				[7] = { -- искусство войны
					id = 59578,
				},
				[8] = { -- дознание
					id = 84963,
				},
			},
		},
	},
	{ -- прист 1 disc 2 holy 3 shadow
		class = "PRIEST",
		specs = {
			[1] = { -- disc
				[1] = { -- исповедь
					id = 47750,
				},
				[2] = { -- слово силы: барьер
					id = 62618,
				},
				[3] = { -- божественное покровительство
					id = 47515,
				},
				[4] = { -- подавление боли
					id = 33206,
				},
				[5] = { -- внутреннее сосредоточение
					id = 89485,
				},
				[6] = { -- лишнее время
					id = 52797,
				},
				[7] = { -- придание сил
					id = 10060,
				},
				[8] = { -- вознесение
					id = 47537,
				},
				[9] = { -- милость
					id = 47517,
				},
				[10] = { -- искусность?
					id = -1,
				},
				[11] = { -- искупление вины
					id = 81751,
				},
			},
			[2] = { -- holy 
				[1] = { -- слово света воздояние
					id = 88625,
				},
				[2] = { -- круг исцеления
					id = 34861,
				},
				[3] = { -- оберегающий дух
					id = 47788,
				},
				[4] = { -- колодец света
					id = 724,
				},
				[5] = { -- чакра
					id = 14751,
				},
				[6] = { -- отблеск света
					id = 77489,
				},
				[7] = { -- чакра: святилище
					id = 81206,
				},
				[8] = { -- слово света: святилище
					id = 88686,
				},
				[9] = { -- чакра: безмятежность
					id = 81208,
				},
				[10] = { -- слово света: безмятежность
					id = 88684,
				},
				[11] = { -- дух воздаяния
					id = 27827,
				},
				[12] = { -- прозорливость
					id = 63735,
				},
				[13] = { -- тело и душа
					id = 65081,
				},
				[14] = { -- чакра: воздаяние
					id = 81209,
				},
			},
			[3] = { -- shadow
				[1] = { -- пытка разума
					id = 15407,
				},
				[2] = { -- облик тьмы
					id = 15473,
				},
				[3] = { -- прикосновение вампира
					id = 34914,
				},
				[4] = { -- сферы тьмы
					id = 77487,
				},
				[5] = { -- слияние с тьмой
					id = 47585,
				},
				[6] = { -- объятия вампира
					id = 15290,
				},
				[7] = { -- сумеречный призрак
					id = 87426,
				},
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
				{id = 16188,}, -- природная стремительность
				{id = 77796,}, -- внезапное озарение ???
				{id = 82988,}, -- Теллурические токи ???
				{id = 16190,}, -- тотем прилива манны
				{id = 98008,}, -- тотем духовной связи
				{id = 61295,}, -- быстрина
				{id = 379,}, -- щит земли
				{id = 105284,}, -- стойкость предков
				{id = 51945,}, -- жизнь земли
			},
		},
	},
	{ -- друид 1 balance 2 feral 3 resto
		class = "DRUID",
		specs = {
			[1] = {
				{id = 78674,}, -- звездный поток
				{id = 24858,}, -- облик лунного совуха
				{id = 33831,}, -- сила природы
				{id = 81283,}, -- микоз
				{id = 48505,}, -- звездопад
				{id = 61391,}, -- тайфун
				{id = 93400,}, -- падающие звезды
			},
			[2] = {
				{id = 33876,}, -- увечье
				{id = 50334,}, -- берсерк
				{id = 61336,}, -- инстинкт выживания
				{id = 24932,}, -- вожак стаи
				{id = 80313,}, -- смять
			},
			[3] = {
				{id = 33891,}, -- древо жизни
				{id = 48438,}, -- буйный рост
				{id = 17116,}, -- природная стремительность
				{id = 81262,}, -- период цветения
				{id = 18562,}, -- быстрое восстановление
			},
		},
	},
	{ -- маг 1 arcan 2 fire 3 frost
		class = "MAGE",
		specs = {
			[1] = {
				{id = 44425,}, -- чародейский обстрел
				{id = 12043,}, -- величие разума
				{id = 82930,}, -- чародейская тактика
				{id = 31589,}, -- замедление
				{id = 31585,}, -- улучшенный самоцвет маны
				{id = 12042,}, -- мощь тайной магии
				{id = 54646,}, -- магическая концентрация
				{id = 44395,}, -- колдовское поглощение
			},
			[2] = {
				{id = 92315,}, -- огненая глыба
				{id = 11113,}, -- взрывная волна
				{id = 87023,}, -- прижигание
				{id = 48108,}, -- путь огня
				{id = 11129,}, -- возгорание
				{id = 31661,}, -- дыхание дракона
				{id = 44457,}, -- живая бомба
				{id = 22959,}, -- критическая масса
				{id = 83582,}, -- пироман
			},
			[3] = {
				{id = 57669,}, -- восполнение
				{id = 44544,}, -- ледяные пальцы
				{id = 57761,}, -- заморозка мозгов
				{id = 92283,}, -- сфера ледяного огня
				{id = 31687,}, -- пет
				{id = 12472,}, -- стылая кровь
				{id = 11958,}, -- холодная хватка
				{id = 11426,}, -- ледяная преграда
				{id = 44572,}, -- Глубокая заморозка
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
				{id = 55050,}, -- удар в сердце
				{id = 77535,}, -- щит крови
				{id = 49222,}, -- костяной щит
				{id = 53138,}, -- сила поганища ?????????????????
				{id = 50463,}, -- Удар закаленным в крови клинком
				{id = 50452,}, -- кровавый паразит
				{id = 48792,}, -- незыблемость льда?
				{id = 48982,}, -- захват рун?
				{id = 55233,}, -- кровь вампира
				{id = 96171,}, -- воля мертвых
				{id = 81162,}, -- воля мертвых
				{id = 81256,}, -- танцующее руническое оружие
				{id = 49028,}, -- танцующее руническое оружие
			},
			[2] = {
				{id = 49184,}, -- воющий ветер
				{id = 49143,}, -- ледяной удар
				{id = 51271,}, -- ледяной столп
				{id = 49203,}, -- ненасытная стужа
				{id = 51124,}, -- машина для убийств
				{id = 59052,}, -- морозная дымка
				{id = 55610,}, -- цепкие ледяный когти
				{id = 81326,}, -- ослабление костей
				{id = 66196,}, -- угроза тассариана?????
				{id = 66198,}, -- угроза тассариана?????
				{id = 66216,}, -- угроза тассариана?????
			},
			[3] = {
				{id = 49206,}, -- призыв горгули +
				{id = 49016,}, -- нечистивое бешенство+
				{id = 63560,}, -- темное превращение+
				{id = 51052,}, -- зона антимагии+ 2м 10 сек
				{id = 55090,}, -- удар плети
				{id = 91342,}, -- вливание тьмы 
				{id = 50536,}, -- нечистивая порча??
				{id = 81340,}, -- неумолимый рок
				{id = 0,}, -- разносчик черной чумы?
			},
		},
	},
	{ -- воин 1 arms, 2 fury 3 prot
		class = "WARRIOR",
		specs = {
			[1] = {
				{id = 12723,}, -- Размащистые удары
				{id = 60503,}, -- Вкус крови
				{id = 85730,}, -- Смертельное спокойствие
				{id = 0,}, -- Умелый мощный удар
				{id = 92576,}, -- Кровавое бешенство
				{id = 52437,}, -- Внезапная смерть
				{id = 65156,}, -- Неудержимость
				{id = 84586,}, -- Избиение
				{id = 0,}, -- Погром?
				{id = 0,}, -- Низвержение
				{id = 46924,}, -- Вихрь клинков
				{id = 12294,}, -- Смертельный удар
				{id = 0,}, -- Удача в бою
				{id = 0,}, -- Управление злостью
			},
			[2] = {
				{id = 23881,}, -- кровожадность
				{id = 12292,}, -- жажда смерти
				{id = 14202,}, -- Исступление?  
				{id = 12968,}, -- Шквал
				{id = 85288,}, -- Яростный выпад
				{id = 0,}, -- Бой насмерть 81913
				{id = 29801,}, -- Буйство
				{id = 0,}, -- Неистовство героя  60970
				{id = 85739,}, -- Кровавый фарш
				{id = 0,}, -- Яростные атаки 46910
				{id = 46916,}, -- Прилив крови
			},
			[3] = {
				{id = 12976,}, -- Ни шагу назад
				{id = 12809,}, -- Оглушающий удар
				{id = 57516,}, -- Иступление? 
				{id = 20243,}, -- Сокрушение
				{id = 50720,}, -- Бдительность
				{id = 87096,}, -- Громовой раскат
				{id = 50227,}, -- Щит и меч
				{id = 46968,}, -- Ударная волна
				{id = 0,}, -- Отмщение ???
				{id = 23922,}, -- Мощный удар щитом
				{id = 84620,}, -- Дисциплина защитника
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
		local spname = select(1, GetSpellInfo(i.spellID))
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

























