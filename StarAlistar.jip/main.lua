local version = "0.2"


local common = module.load("avada_lib", "common")
local tSelector = module.load("avada_lib", "targetSelector")
local orb = module.internal("orb/main")
local gpred = module.internal("pred/main")
local dlib = module.load("avada_lib", "damageLib")
local draw = module.load("avada_lib", "draw")

local redPred = {delay = 2.5, radius = 550, speed = math.huge, boundingRadiusMod = 0, range = 5500}
local enemy = common.GetEnemyHeroes()

local interruptableSpells = {
	["anivia"] = {
		{menuslot = "R", slot = 3, spellname = "glacialstorm", channelduration = 6},
	},
	["caitlyn"] = {
		{menuslot = "R", slot = 3, spellname = "caitlynaceinthehole", channelduration = 1},
	},
	["ezreal"] = {
		{menuslot = "R", slot = 3, spellname = "ezrealtrueshotbarrage", channelduration = 1},
	},
	["fiddlesticks"] = {
		{menuslot = "W", slot = 1, spellname = "drain", channelduration = 5},
		{menuslot = "R", slot = 3, spellname = "crowstorm", channelduration = 1.5},
	},
	["gragas"] = {
		{menuslot = "W", slot = 1, spellname = "gragasw", channelduration = 0.75},
	},
	["janna"] = {
		{menuslot = "R", slot = 3, spellname = "reapthewhirlwind", channelduration = 3},
	},
	["karthus"] = {
		{menuslot = "R", slot = 3, spellname = "karthusfallenone", channelduration = 3},
	}, --IsValidTarget will prevent from casting @ karthus while he's zombie
	["katarina"] = {
		{menuslot = "R", slot = 3, spellname = "katarinar", channelduration = 2.5},
	},
	["lucian"] = {
		{menuslot = "R", slot = 3, spellname = "lucianr", channelduration = 2},
	},
	["lux"] = {
		{menuslot = "R", slot = 3, spellname = "luxmalicecannon", channelduration = 0.5},
	},
	["malzahar"] = {
		{menuslot = "R", slot = 3, spellname = "malzaharr", channelduration = 2.5},
	},
	["masteryi"] = {
		{menuslot = "W", slot = 1, spellname = "meditate", channelduration = 4},
	},
	["missfortune"] = {
		{menuslot = "R", slot = 3, spellname = "missfortunebullettime", channelduration = 3},
	},
	["nunu"] = {
		{menuslot = "R", slot = 3, spellname = "absolutezero", channelduration = 3},
	},
	--excluding Orn's Forge Channel since it can be cancelled just by attacking him
	["pantheon"] = {
		{menuslot = "R", slot = 3, spellname = "pantheonrjump", channelduration = 2},
	},
	["shen"] = {
		{menuslot = "R", slot = 3, spellname = "shenr", channelduration = 3},
	},
	["twistedfate"] = {
		{menuslot = "R", slot = 3, spellname = "gate", channelduration = 1.5},
	},
	["varus"] = {
		{menuslot = "Q", slot = 0, spellname = "varusq", channelduration = 4},
	},
	["warwick"] = {
		{menuslot = "R", slot = 3, spellname = "warwickr", channelduration = 1.5},
	},
	["xerath"] = {
		{menuslot = "R", slot = 3, spellname = "xerathlocusofpower2", channelduration = 3},
	}
}

local menu = menuconfig("Alistar", "Star Guardian Alistar")
	menu:header("head", "Star Guardian Alistar")
	dts = tSelector(menu, 1100, 2)
	dts:addToMenu()
	menu:menu("combo", "Alistar Settings")
		menu.combo:boolean("q", "Use Q", true)
		menu.combo:boolean("w", "Use W", true)
		menu.combo:boolean("e", "Use E", true)
		menu.combo:boolean("r", "Use R", true)
	
	menu.combo:menu("Gap", "Gapcloser Settings")
		menu.combo.Gap:boolean("GapA", "Use W against Gapcloser?", true)
		menu.combo:boolean("interrupt", "Use W to Interrupt Casts", true)
	menu.combo:menu("interruptmenu", "Interrupt Settings")
	menu.combo.interruptmenu:header("lol", "Interrupt Settings")
for i=1, #common.GetEnemyHeroes() do
	local enemy = common.GetEnemyHeroes()[i]
	local name = string.lower(enemy.charName)
	if enemy and interruptableSpells[name] then
		for v=1, #interruptableSpells[name] do
			local spell = interruptableSpells[name][v]
			menu.combo.interruptmenu:boolean(string.format(tostring(enemy.charName) .. tostring(spell.menuslot)), "Interrupt " .. tostring(enemy.charName) .. " " .. tostring(spell.menuslot), true)
        end
	end
end		
	menu.combo:menu("ults", "R Settings")
		menu.combo.ults:slider("Rcount", "Use R on Enemy count: ", 1, 1, 5, 1)
		menu.combo.ults:slider("Rhp", "Use R on HP% ", 35, 0 , 100, 1)
		menu.combo.ults:menu("AntCC", "CC Settings")
			menu.combo.ults.AntCC:boolean("silcenR", "Silence: ", false)
			menu.combo.ults.AntCC:boolean("supR", "Suppression: ", true)
			menu.combo.ults.AntCC:boolean("rootR", "Root: ", true)
			menu.combo.ults.AntCC:boolean("tauntR", "Taunt: ", true)
			menu.combo.ults.AntCC:boolean("sleepR", "Sleep:", true)
			menu.combo.ults.AntCC:boolean("stunR", "Stun: ", true)
			menu.combo.ults.AntCC:boolean("blindR", "Blind: ", false)
			menu.combo.ults.AntCC:boolean("fearR", "Fear: ", true)
			menu.combo.ults.AntCC:boolean("charmR", "Charm: ", true)
			menu.combo.ults.AntCC:boolean("knockR", "Knockback/Knockup: Recommended off", false)
		
	menu.combo:header("drHed", "Draw Settings")
		menu.combo:menu("drawz", "Draw Settings")
			menu.combo.drawz:boolean("q", "Draw Q Range", true)
			menu.combo.drawz:boolean("w", "Draw W Range", true)
			menu.combo.drawz:boolean("e", "Draw E Range", true)
		
	menu:header("version", "Version: 0.2")
	menu:header("author", "Author: Cindy")
	
local function combo()
	
	local target = dts.target
	
	if target and menu.combo.w:get() and common.CanUseSpell(1) and common.CanUseSpell(0) and common.IsValidTarget(target) and common.GetDistance(player, target) > 365 and common.GetDistance(player, target) < 650 then
		game.cast('obj', 1, target)
	end
	if target and menu.combo.q:get() and common.CanUseSpell(0) and common.IsValidTarget(target) and common.GetDistance(target, player) < 365 then
		game.cast('obj', 0, player)
	end
	if target and menu.combo.e:get() and common.IsValidTarget(target) and common.GetDistance(target, player) < 350 then
		game.cast('obj', 2, player)
	end
end

local function AutoUlt()

	if common.CanUseSpell(3) and not player.isDead and menu.combo.r:get() and #common.GetEnemyHeroesInRange(800, player) >= menu.combo.ults.Rcount:get() and common.GetPercentHealth(player) < menu.combo.ults.Rhp:get() then
		if menu.combo.ults.AntCC.stunR:get() and common.HasBuffType(player, 5) or (menu.combo.ults.AntCC.rootR:get() and common.HasBuffType(player, 11)) or (menu.combo.ults.AntCC.silcenR:get() and common.HasBuffType(player, 7)) or (menu.combo.ults.AntCC.tauntR:get() and common.HasBuffType(player, 8)) or (menu.combo.ults.AntCC.supR:get() and common.HasBuffType(player, 24)) or (menu.combo.ults.AntCC.sleepR:get() and common.HasBuffType(player, 18)) or (menu.combo.ults.AntCC.charmR:get() and common.HasBuffType(player, 22)) or (menu.combo.ults.AntCC.fearR:get() and common.HasBuffType(player, 28)) or (menu.combo.ults.AntCC.knockR:get() and common.HasBuffType(player, 29)) then
		game.cast('obj', 3, player)
		end
	end
end


local function WGapcloser()
	if common.CanUseSpell(2) and menu.combo.Gap.GapA:get() then
		for i=0, objmanager.enemies_n-1 do
	    	local dasher = objmanager.enemies[i]
	    	if dasher and common.IsValidTarget(dasher) and dasher.path.isDashing and dasher.path.active then
	          	game.cast('obj', 1, dasher)
	  		end
		end
	end
end

local function AutoInterrupt(spell) -- Thank you Dew for this <3
	if menu.misc.interrupt:get() and common.CanUseSpell(1) then
		if spell.owner.type == enum.type.hero and spell.owner.team == enum.team.enemy then
			local enemyName = string.lower(spell.owner.charName)
			if interruptableSpells[enemyName] then
				for i = 1, #interruptableSpells[enemyName] do
					local spellCheck = interruptableSpells[enemyName][i]
					if menu.combo.interruptmenu[spell.owner.charName .. spellCheck.menuslot]:get() and string.lower(spell.name) == spellCheck.spellname then
						if avadaCommon.GetDistance(spell.owner, player) < 650 and common.IsValidTarget(spell.owner) and common.CanUseSpell(1) then
							game.cast('obj', 1, spell.owner)
						end
					end
				end
			end
		end
	end
end

function on_draw()
	if menu.combo.drawz.q:get() then
		glx.world.circle(player.pos, 365, 1, draw.color.red, 50)
	end
	if menu.combo.drawz.e:get() then
		glx.world.circle(player.pos, 350, 1, draw.color.deep_sky_blue, 50)
	end	
	if menu.combo.drawz.w:get() then
		glx.world.circle(player.pos, 650, 3, draw.color.red, 50)
	end
end


function on_tick()
	if menu.combo.Gap.GapA:get() then
	WGapcloser()
	end
	if orb.combat.is_active() then
		combo()
	end
	if menu.combo.r:get() then
		AutoUlt()
	end
end

callback.add(enum.callback.draw, function() on_draw() end)
callback.add(enum.callback.tick, function() on_tick() end)

return {}