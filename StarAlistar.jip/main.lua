local version = "0.1"


local common = module.load("avada_lib", "common")
local tSelector = module.load("avada_lib", "targetSelector")
local orb = module.internal("orb/main")
local gpred = module.internal("pred/main")
local dlib = module.load("avada_lib", "damageLib")
local draw = module.load("avada_lib", "draw")

local redPred = {delay = 2.5, radius = 550, speed = math.huge, boundingRadiusMod = 0, range = 5500}
local enemy = common.GetEnemyHeroes()

local menu = menuconfig("Alistar", "Star Guardian Alistar")
	menu:header("head", "Star Guardian Alistar")
	dts = tSelector(menu, 1100, 2)
	dts:addToMenu()
	menu:menu("combo", "Alistar Settings")
		menu.combo:boolean("q", "Use Q", true)
		menu.combo:boolean("w", "Use W", true)
		menu.combo:boolean("e", "Use E", true)
		menu.combo:boolean("r", "Use R", true)
		
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
		local ally = common.GetAllyHeroes()
		for i, allies in ipairs(ally) do
			menu.combo.mikz:boolean(allies.charName, "Mikeals Ally? "..allies.charName, true)
			menu.combo.mikz[allies.charName]:set('value', true)
		end
		menu.combo.mikz:boolean("AMK", "Auto Mikael's", true)
		
	menu.combo:menu("RED", "Redemption Settings")
		menu.combo.RED:boolean("Ron", "Use Redemption?", true)
		menu.combo.RED:slider("RSL", "Use Redemption HP% ", 45, 0, 100, 1)
	menu.combo:menu("Locket", "Locket Settings")
		menu.combo.Locket:boolean("lockA", "Use Locket?", true)
		menu.combo.Locket:slider("locksli", "Use Locket HP% ", 25, 0 , 100, 1)
		menu.combo.Locket:slider("lockslic", "Use locket ally count: ", 1, 1, 5, 1)
		
	menu:header("version", "Version: 0.1")
	menu:header("author", "Author: Cindy")
	
local function combo()
	
	local target = dts.target
	
	if target and menu.combo.w:get() and common.CanUseSpell(1) and common.CanUseSpell(0) and common.IsValidTarget(target) and common.GetDistance(player, target) > 365 and common.GetDistance(player, target) < 650 then
		game.cast('obj', 1, target)
	end
	if target and menu.combo.q:get() and common.CanUseSpell(0) and common.IsValidTarget(target) and common.GetDistance(target, player) < 365 then
		game.cast('obj', 0, player)
	end
	if target and menu.combo.e:get() and common.IsValidTarget(target) and common.GetDistance(target, player) < 275 then
		game.cast('obj', 2, player)
	end
end

local function AutoUlt()

	if common.CanUseSpell(3) and not player.isDead and menu.combo.r:get() and (menu.combo.ults.AntCC.stun:get() and common.HasBuffType(player, 5)) or (menu.combo.ults.AntCC.root:get() and common.HasBuffType(player, 11)) or (menu.combo.ults.AntCC.silcen:get() and common.HasBuffType(player, 7)) or (menu.combo.ults.AntCC.taunt:get() and common.HasBuffType(player, 8)) or (menu.combo.ults.AntCC.sup:get() and common.HasBuffType(player, 24)) or (menu.combo.ults.AntCC.sleep:get() and common.HasBuffType(player, 18)) or (menu.combo.ults.AntCC.charm:get() and common.HasBuffType(player, 22)) or (menu.combo.ults.AntCC.fear:get() and common.HasBuffType(player, 28)) or (menu.combo.ults.AntCC.knock and common.HasBuffType(player, 29)) and #common.GetEnemyHeroesInRange(800, player) >= menu.combo.ults.Rcount:get() and common.GetPercentHealth(player) < menu.combo.ults.Rhp:get() then
		game.cast('obj', 3, player)
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


function on_tick()

	if orb.combat.is_active() then
		combo()
	end
	if menu.combo.RED.Ron:get() then
		Redemption()
	end
	if menu.combo.mikz.AMK:get() then 
		Mikaels()
	end
	if menu.combo.Locket.lockA:get() then
		locketofSolari()
	end
end


callback.add(enum.callback.tick, function() on_tick() end)

return {}