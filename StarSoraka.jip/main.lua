local version = "1.41"

local common = module.load("avada_lib", "common")
local tSelector = module.load("avada_lib", "targetSelector")
local orb = module.internal("orb/main")
local gpred = module.internal("pred/main")
local dlib = module.load("avada_lib", "damageLib")
local draw = module.load("avada_lib", "draw")

local enemy = common.GetEnemyHeroes()

local ePred = {delay = 0.1, radius = 300, speed = math.huge, boundingRadiusMod = 0, range = 925}
local redPred = {delay = 2.5, radius = 550, speed = math.huge, boundingRadiusMod = 0, range = 5500}

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
	["xerath"] = {
		{menuslot = "R", slot = 3, spellname = "xerathlocusofpower2", channelduration = 3},
	}
}


local menu = menuconfig("Soraka", "Star Guardian Soraka") -- UNDER CONSTRUCTION


menu:header("head", "Star Guardian Soraka")
dts = tSelector(menu, 1100, 2)
dts:addToMenu()
menu:menu("combo", "Soraka Settings")
	menu.combo:boolean("q", "Use Q", true)
	menu.combo:boolean("w", "Use W", true)
	menu.combo:boolean("e", "Use E", false)
	menu.combo:boolean("r", "Use R", true)
	menu.combo:boolean("QK", "Don't killsteal with Q?", false)
	
menu.combo:header("headers", "Heal Settings")
	menu.combo:menu("hea", "Heal Settings")
		menu.combo.hea:slider("ahp", "HP% To R Ally: ", 10, 0, 100, 1)
		menu.combo.hea:slider("ahps", "HP% To R Self: ", 10, 0, 100, 1)
		menu.combo.hea:slider("healW", "HP% W Ally: ", 85, 0, 100, 1)
		menu.combo.hea:boolean("ults", "Use R Self?", true)
		menu.combo.hea:boolean("ultsA", "Use R Ally?", true)
		
	
	
menu.combo:header("xd", "R and W Ally Selection")
	menu.combo:menu("x", "R Ally Selection")	--ty coozbie for this
		local ally = common.GetAllyHeroes()
		for i, allies in ipairs(ally) do
			menu.combo.x:boolean(allies.charName, "R Ally? "..allies.charName, true) 
		end
	menu.combo:menu("wconf", "W Ally selection")
		for i, allies in ipairs(ally) do
			menu.combo.wconf:boolean(allies.charName, "W Ally? "..allies.charName, true) 
		end
		
menu.combo:header("xd", "Misc Settings")

	menu.combo:menu("mikaBF", "Mikeals Buff Settings")
			menu.combo.mikaBF:boolean("silcen", "Silence: ", false)
			menu.combo.mikaBF:boolean("sup", "Suppression: ", true)
			menu.combo.mikaBF:boolean("root", "Root: ", true)
			menu.combo.mikaBF:boolean("taunt", "Taunt: ", true)
			menu.combo.mikaBF:boolean("sleep", "Sleep:", true)
			menu.combo.mikaBF:boolean("stun", "Stun: ", true)
			menu.combo.mikaBF:boolean("blind", "Blind: ", false)
			menu.combo.mikaBF:boolean("fear", "Fear: ", true)
			menu.combo.mikaBF:boolean("charm", "Charm: ", true)
			menu.combo.mikaBF:boolean("knock", "Knockback/Knockup: Recommended off", false)
			
			
	menu.combo:menu("mikz", "Mikeals Ally Selection")
		for i, allies in ipairs(ally) do
			menu.combo.mikz:boolean(allies.charName, "Mikeals Ally? "..allies.charName, true)
		end
		menu.combo.mikz:boolean("AMK", "Auto Mikael's", true)
	menu.combo:menu("RED", "Redemption Settings")
		menu.combo.RED:boolean("Ron", "Use Redemption?", true)
		menu.combo.RED:slider("RSL", "Use Redemption HP% ", 45, 0, 100, 1)
	menu.combo:menu("Locket", "Locket Settings")
		menu.combo.Locket:boolean("lockA", "Use Locket?", true)
		menu.combo.Locket:slider("locksli", "Use Locket HP% ", 25, 0 , 100, 1)
		menu.combo.Locket:slider("lockslic", "Use locket ally count: ", 1, 1, 4, 1)
	
	menu.combo:menu("interruptM", "Interrupt Settings")
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

menu.combo:header("drHed", "Draw Settings")
menu.combo:menu("drawz", "Draw Settings")
	menu.combo.drawz:boolean("q", "Draw Q Range", true)
	menu.combo.drawz:boolean("w", "Draw W Range", true)
	menu.combo.drawz:boolean("e", "Draw R Range", true)
	
menu:header("version", "Version: 1.41")
menu:header("author", "Author: Cindy")


local function findWTarget()
    local FNTarget = common.GetAllyHeroesInRange(600)
    local currentLowestTarget = nil
    for i = 1, #FNTarget do
        local friend1 = FNTarget[i]
        if friend1 and not friend1.isDead and common.CanUseSpell(1) and common.GetPercentHealth(friend1) < menu.combo.hea.healW:get() then  
            currentLowestTarget = friend1
            for k = 1, #FNTarget do
                local friend2 = FNTarget[k]
                if friend2 and friend2 ~= friend1 and not friend2.isDead and common.GetPercentHealth(friend2) < menu.combo.hea.healW:get() then  
                    if common.GetPercentHealth(friend2) < common.GetPercentHealth(currentLowestTarget) then
                        currentLowestTarget = friend2
                    end
                end
            end
        end
    end    

    return currentLowestTarget
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
	if seg and seg.startPos:dist(seg.endPos) < 925 then
	game.cast("pos", 2, vec3(enemy.x, game.mousePos.y, enemy.z))		
	end
end


local function Combo()
	local ally = common.GetAllyHeroes()
	local Wtarget = findWTarget()
	local target = dts.target
	for i, allies in ipairs(ally) do
		if Wtarget and common.CanUseSpell(1) and menu.combo.w:get() and common.GetPercentHealth(Wtarget) < menu.combo.hea.healW:get() and menu.combo.wconf[allies.charName]:get() then
			print("Wtarget = " .. tostring(Wtarget))
			print("Casting Astral Infusion")
			game.cast("obj", 1, Wtarget)
		end
	end
	if target and common.CanUseSpell(2) and selector.is_valid(target) and menu.combo.e:get() then
		print("Qtarget = " .. tostring(target))
		print("Silencing Target")
		Silence(target)
	end
	if target and common.CanUseSpell(0) and selector.is_valid(target) and menu.combo.q:get() then
		if menu.combo.QK:get() and common.GetPercentHealth(target) < 6 and common.GetDistance(Wtarget, target) < 500 then
		glx.screen.text("Im a good boi", 10, player.x, player.y, draw.color.orange_red) --update
		else
		print("Qtarget = " .. tostring(target))
		print("Calling Starfall")
		Starfall(target)
		end
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


function CountEnemyHeroNearMe(range)
	local range, count = range*range, 0 
	for i = 0, objmanager.enemies_n - 1 do
		if player.pos:distSqr(objmanager.enemies[i].pos) < range then 
	 		count = count + 1 
	 	end 
	end 
	return count 
end

local function autoUltSelf()

	if common.CanUseSpell(3) and not player.isDead and CountEnemyHeroNearMe(700) >= 1 and menu.combo.r:get() and menu.combo.hea.ults:get() and common.GetPercentHealth(player) <= menu.combo.hea.ahps:get() then
		game.cast("obj", 3, player)
	end
end


local function Mikaels() --do print/opt
    local mikafriend = common.GetAllyHeroesInRange(700)
    for _, allies in ipairs(mikafriend) do
        if allies and not allies.isDead and menu.combo.mikz[allies.charName]:get() and common.GetDistance(allies, player) < 700 and #common.GetEnemyHeroesInRange(1000, allies) >= 1 then
			if (menu.combo.mikaBF.stun:get() and common.HasBuffType(allies, 5)) or (menu.combo.mikaBF.root:get() and common.HasBuffType(allies, 11)) or (menu.combo.mikaBF.silcen:get() and common.HasBuffType(allies, 7)) or (menu.combo.mikaBF.taunt:get() and common.HasBuffType(allies, 8)) or (menu.combo.mikaBF.sup:get() and common.HasBuffType(allies, 24)) or (menu.combo.mikaBF.sleep:get() and common.HasBuffType(allies, 18)) or (menu.combo.mikaBF.charm:get() and common.HasBuffType(allies, 22)) or (menu.combo.mikaBF.fear:get() and common.HasBuffType(allies, 28)) or (menu.combo.mikaBF.knock and common.HasBuffType(allies, 29)) then
				for i = 6, 11 do
					local item = player:spellslot(i).name
					if item == "MorellosBane" or item == "ItemMorellosBane" and player:spellslot(i).state == 0 then
						common.DelayAction(function() game.cast("obj", i, allies) end, 0.2)
					end	
				end	
            end
        end   
	end	
end

local function locketofSolari()
	local locketFriend = common.GetAllyHeroesInRange(800)
	for i=1, #locketFriend do
		local LF = locketFriend[i]
		if LF and not LF.isDead and menu.combo.Locket.lockA:get() and common.GetPercentHealth(LF) < menu.combo.Locket.locksli:get() and #common.GetEnemyHeroesInRange(900, LF) >= 1 and #common.GetAllyHeroesInRange(600) >= menu.combo.Locket.lockslic:get() then
			for i = 6, 11 do
				local item = player:spellslot(i).name
				if item == "IronStylus" or item == "ItemIronStylus" and player:spellslot(i).state == 0 then
					game.cast("obj", i, player)
				end
			end
		end
	end
end
	
local function Redemption()

local RedFriend = common.GetAllyHeroesInRange(5500)
	for i=1, #RedFriend do
		local RF = RedFriend[i]
		if RF and not RF.isDead and menu.combo.RED.Ron:get() and common.GetPercentHealth(RF) < menu.combo.RED.RSL:get() and #common.GetEnemyHeroesInRange(700, RF) >= 1 then
			for i = 6, 11 do
				local item = player:spellslot(i).name
				if item == "Redemption" or item == "ItemRedemption" and player:spellslot(i).state == 0 then
					local seg = gpred.circular.get_prediction(redPred, RF)
					if seg and seg.startPos:dist(seg.endPos) < 5500 then
						game.cast("pos", i, vec3(seg.endPos.x, game.mousePos.y, seg.endPos.y))		
					end
				end
			end
		end
	end
end

local function AutoUlt()
	local Happie = common.GetAllyHeroes()
	for _, allies in ipairs(Happie) do
		if common.CanUseSpell(3) and not allies.isDead and not player.isDead and menu.combo.hea.ultsA:get() and menu.combo.x[allies.charName]:get() and menu.combo.r:get() and common.GetPercentHealth(allies) <= menu.combo.hea.ahp:get() then
			if #common.GetEnemyHeroesInRange(700, allies) >= 1 then
				game.cast("obj", 3, player)
			end	
		end
	end
end


function on_draw()
	if menu.combo.drawz.q:get() then
		glx.world.circle(player.pos, 800, 1, draw.color.orange_red, 50)
	end
	if menu.combo.drawz.e:get() then
		glx.world.circle(player.pos, 890, 1, draw.color.deep_sky_blue, 50)
	end	
	if menu.combo.drawz.w:get() then
		glx.world.circle(player.pos, 550, 3, draw.color.forest_green, 50)
	end
end



function on_tick()
	
	if menu.combo.Locket.lockA:get() then
		locketofSolari()
	end
	
	if menu.combo.RED.Ron:get() then
		Redemption()
	end
	
	if menu.combo.mikz.AMK:get() then 
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
callback.add(enum.callback.draw, function() on_draw() end)

return {}