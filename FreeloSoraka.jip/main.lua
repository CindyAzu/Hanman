local version = "0.6"

local common = module.load("avada_lib", "common")
local tSelector = module.load("avada_lib", "targetSelector")
local orb = module.internal("orb/main")
local gpred = module.internal("pred/main")
local dlib = module.load("avada_lib", "damageLib")


local enemy = common.GetEnemyHeroes()

local ePred = {delay = 0.1, radius = 300, speed = math.huge, boundingRadiusMod = 0, range = 925}

local QDelays = {0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1, 1, 1, 1}
local QRange = {50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 915}

local function QPredictionSetup(target)
	local QPred = {}
	local distance = common.GetDistance(target, player)
	local delayVal = 0.25
	for i=1, #QRange do
		local hold = QRange[i]
		if i > 1 and distance >= hold then
			delayVal = QDelays[i]
		end
	end
	QPred = {radius = 235, delay = delayVal, speed = math.huge, boundingRadiusMod = 0}
	return QPred
end

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

local menu = menuconfig("Soraka", "Freelo Soraka") -- UNDER CONSTRUCTION
dts = tSelector(menu, 1100, 2)
dts:addToMenu()

menu:header("head", "Freelo Soraka")
menu:menu("combo", "Combo Settings")
	menu.combo:boolean("q", "Use Q", true)
	menu.combo:boolean("w", "Use W", true)
	menu.combo:boolean("e", "Use E", true)
	menu.combo:boolean("r", "Use R", true)
	
menu.combo:header("xd", "Misc Settings")
	menu.combo:menu("MK", "Mikael's Settings. Soon.TM")
		menu.combo.MK:boolean("AMK", "Auto Mikael's", true)	
	menu.combo:menu("interruptM", "Interrupt Settings")
	menu.combo.interruptM:boolean("inter", "Auto Interrupt with E?", true)
menu.combo.interruptM:header("Interpgg", "Interrupt Author: Dewblackio2")
for i=1, #common.GetEnemyHeroes() do
	local enemy = common.GetEnemyHeroes()[i]
	local name = string.lower(enemy.charName)
	if enemy and interruptableSpells[name] then
		for v=1, #interruptableSpells[name] do
			local spell = interruptableSpells[name][v]
			menu.combo.interruptM:boolean(string.format(tostring(enemy.charName) .. tostring(spell.menuslot)), "Interrupt " .. tostring(enemy.charName) .. " " .. tostring(spell.menuslot), true)
		end
	end
end
menu.combo:header("xd", "Ult Auto")
	menu.combo:menu("x", "Ally Selection And Auto Ult")
	menu.combo.x:boolean("ults", "Use Ulti Self?", true)
		local ally = common.GetAllyHeroes()
		for i, allies in ipairs(ally) do
			menu.combo.x:boolean(allies.charName, "Ult HP%: "..allies.charName, true) 
		end
		menu.combo.x:slider("ahp", "HP% To Heal Ally", 10, 0, 100, 1)
		menu.combo.x:slider("ahps", "HP% To Ult Self", 10, 0, 100, 1)
menu:header("version", "Version: 0.5")
menu:header("author", "Author: Cindy")


local function findWTarget()
	local FNTarget = common.GetAllyHeroes()
	for i=1, #FNTarget do
		local friend = FNTarget[i]
		if friend and common.GetDistance(friend, player) <= 700 and not friend.isDead and common.GetPercentHealth(friend) <= 70 then
		return friend
		end
	end
	return nil
end


local function Starfall(enemy)
	local target = dts.target
	local predict = QPredictionSetup(enemy)
	print(tostring(predict))
	local seg = gpred.circular.get_prediction(predict, target)
	if seg and seg.startPos:dist(seg.endPos) < 900 then
		game.cast("pos", 0, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))		
	end
end

local function Silence(enemy)
	local target = dts.target
	local seg = gpred.circular.get_prediction(ePred, target)
	if seg and seg.startPos:dist(seg.endPos) < 900 then
	game.cast("pos", 2, vec3(enemy.x, game.mousePos.y, enemy.z))		
	end
end


local function Combo()
	print("combo function reached")
	
	local Wtarget = findWTarget()
	local target = dts.target
	
	--[[if Rtarget and common.CanUseSpell(3) and menu.combo.r:get() and common.GetPercentHealth(Rtarget) < 15 then
		print("Rtarget = " .. tostring(Rtarget))
		print("Casting Wish")
		game.cast("obj", 3, player)
	end
	]]
	
	if Wtarget and common.CanUseSpell(1) and menu.combo.w:get() and common.GetPercentHealth(Wtarget) < 85 then
		print("Wtarget = " .. tostring(Wtarget))
		print("Casting Astral Infusion")
		game.cast("obj", 1, Wtarget)
	end
	if target and common.CanUseSpell(2) and selector.is_valid(target) and menu.combo.e:get() then
		print("Qtarget = " .. tostring(target))
		print("Silencing Target")
		Silence(target)
	end
	if target and common.CanUseSpell(0) and selector.is_valid(target) and menu.combo.q:get() then
		print("Qtarget = " .. tostring(target))
		print("Calling Starfall")
		Starfall(target)
	end
end

local function AInterupt(spell)
	if common.CanUseSpell(2) then
		if spell.owner.type == enum.type.hero and spell.owner.team == enum.team.enemy then
			local enemyName = string.lower(spell.owner.charName)
			if interruptableSpells[enemyName] then
				for i = 1, #interruptableSpells[enemyName] do
					local spellCheck = interruptableSpells[enemyName][i]
					if string.lower(spell.name) == spellCheck.spellname then
						if common.GetDistance(spell.owner, player) < 925 and common.IsValidTarget(spell.owner) and common.CanUseSpell(2) then
							game.cast('pos', 2, vec3(spell.owner.x, game.mousePos.y, spell.owner.z))
						end
					end
				end
			end
		end
	end
end


local function CountAllyNearMe(range)
	local range, count = range*range, 0 
	
	for i = 0, objmanager.allies_n - 1 do
		if player.pos:distSqr(objmanager.allies[i].pos) < range then 
	 		count = count + 1 
	 	end 
	end 
	return count 
end

local function autoUltSelf()

	if common.CanUseSpell(3) and CountAllyNearMe(700) >= 1 and menu.combo.r:get() and menu.combo.x.ults:get() and common.GetPercentHealth(player) <= menu.combo.x.ahps:get() then
		game.cast("obj", 3, player)
	end
end
	
local function Mikaels()
    local mikafriend = common.GetAllyHeroes()
    for i=1, #mikafriend do
        local MikaAlly = mikafriend[i]
        if MikaAlly and not MikaAlly.isDead and common.GetDistance(MikaAlly, player) < 700 and (common.HasBuffType(MikaAlly, 5) or common.HasBuffType(MikaAlly, 11)) or (common.HasBuffType(MikaAlly, 8) or common.HasBuffType(MikaAlly, 21)) or (common.HasBuffType(MikaAlly, 18) or common.HasBuffType(MikaAlly, 22)) or (common.HasBuffType(MikaAlly, 11) or common.HasBuffType(MikaAlly, 24)) then
            for i = 6, 11 do
                local item = player:spellslot(i).name
                if item == "MorellosBane" and player:spellslot(i).state == 0 then
                    game.cast("obj", i, MikaAlly)
                end
            end
        end
    end
end

local function AutoUlt() -- add print
	local Happie = common.GetAllyHeroes()
	for _, allies in ipairs(Happie) do
		if menu.combo.x[allies.charName]:get() and common.GetPercentHealth(allies) <= menu.combo.x.ahp:get() then
			game.cast("obj", 3, player)
		end
	end
end

function on_tick()

	if menu.combo.MK.AMK:get() then 
		Mikaels()
	end
	
	if orb.combat.is_active() then
		Combo()
	end

	if menu.combo.r:get() then 
		autoUltSelf()
		AutoUlt()
	end
end

callback.add(enum.callback.recv.spell, function(spell) AInterupt(spell) end)
callback.add(enum.callback.tick, function() on_tick() end)

return {}