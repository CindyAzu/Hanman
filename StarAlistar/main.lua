
local version = "0.4"


local avada_lib = module.lib('avada_lib')
if not avada_lib then
    console.set_color(12)
    print("You need to have Avada Lib in your community_libs folder to run \'Star Alistar\'!")
    print("You can find it here:")
    console.set_color(11)
    print("https://gitlab.soontm.net/get_clear_zip.php?fn=Avada_Lib")
    console.set_color(15)
    return
elseif avada_lib.version < 1 then
    console.set_color(12)
    print("Your need to have Avada Lib updated to run \'Star Alistar\'!")
    print("You can find it here:")
    console.set_color(11)
    print("https://gitlab.soontm.net/get_clear_zip.php?fn=Avada_Lib")
    console.set_color(15)
    return
end

local common = avada_lib.common
local tSelector = avada_lib.targetSelector
local dmglib = avada_lib.damageLib

local orb = module.internal("orb")
local gpred = module.internal("pred")

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
	}, --common.IsValidTargetTarget will prevent from casting @ karthus while he's zombie
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

local menu = menu("StarAlistar", "Star Guardian Alistar")

	dts = tSelector(menu, 1100, 2)
	dts:addToMenu()
	
	menu:menu("combo", "Alistar Settings")
		menu.combo:boolean("q", "Use Q", true)
		menu.combo:boolean("w", "Use W", true)
		menu.combo:boolean("e", "Use E", true)
		menu.combo:boolean("r", "Use R", true)
		menu.combo:keybind("IT", "Insec on KEY:", 'T')
	
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
			menu.combo.drawz:boolean("e", "Draw E and Insec Range", true)
		
	menu:header("version", "Version: 0.3")
	menu:header("author", "Author: Cindy")
	
local cleanseSlot = nil -- ty cooz for lightweight method of check instead of for loop
if player:spellSlot(4).name == "SummonerFlash" then
	flashSlot = 4
elseif player:spellSlot(5).name == "SummonerFlash" then
	flashSlot = 5
end
	
local function combo()

	local target = dts.target
	
	if target and menu.combo.w:get() and common.IsValidTarget(target) and player:spellSlot(1).state==0 and player:spellSlot(0).state==0 and player.pos2D:dist(target.pos2D) > 365 and player.pos2D:dist(target.pos2D) < 650 then
		player:castSpell('obj', 1, target)
	end
	if target and menu.combo.q:get() and common.IsValidTarget(target) and player:spellSlot(0).state==0 and player.pos2D:dist(target.pos2D) < 365 then
		player:castSpell('self', 0)
	end
	if target and menu.combo.e:get() and not player.isDead and common.IsValidTarget(target) and player.pos2D:dist(target.pos2D) < 365 then
		player:castSpell('self', 2)
	end
end

local function AutoUlt()

	if player:spellSlot(3).state==0 and not player.isDead and menu.combo.r:get() and #common.GetEnemyHeroesInRange(800, player) >= menu.combo.ults.Rcount:get() and common.GetPercentHealth(player) < menu.combo.ults.Rhp:get() then
		if menu.combo.ults.AntCC.stunR:get() and player.buff.type['5'] or (menu.combo.ults.AntCC.rootR:get() and player.buff.type['11']) or (menu.combo.ults.AntCC.silcenR:get() and player.buff.type['7']) or (menu.combo.ults.AntCC.tauntR:get() and player.buff.type['8']) or (menu.combo.ults.AntCC.supR:get() and player.buff.type['24']) or (menu.combo.ults.AntCC.sleepR:get() and player.buff.type['18']) or (menu.combo.ults.AntCC.charmR:get() and player.buff.type['22']) or (menu.combo.ults.AntCC.fearR:get() and player.buff.type['28']) or (menu.combo.ults.AntCC.knockR:get() and player.buff.type['29']) then
		player:castSpell('self', 3)
		end
	end
end

local function Insec()
	local target = dts.target
	if menu.combo.IT:get() then
		player:move(game.mousePos)
		if target  and common.IsValidTarget(target) and player.pos2D:dist(target.pos2D) < 390 and player:spellSlot(1).state == 0 then
			player:castSpell("pos", flashSlot, vec3(player.pos:lerp(target.pos, 1.1)))
			orb.core.set_server_pause()
			player:castSpell("obj", 1, target)
		end
	end
end


local function WGapcloser()
	if player:spellSlot(2).state==0 and menu.combo.Gap.GapA:get() then
		for i=0, objManager.enemies_n - 1 do
	    	local dasher = objManager.enemies[i]
			if dasher.type == TYPE_HERO and dasher.team == TEAM_ENEMY then
				if dasher and common.IsValidTarget(dasher) and dasher.path.isActive and dasher.path.isDashing and player.pos:dist(dasher.path.point[1]) < 650 then
					if player.pos2D:dist(dasher.path.point2D[1]) < player.pos2D:dist(dasher.path.point2D[0]) then
						print("working")
						player:castSpell('obj', 1, dasher)
					end
				end
			end
		end
	end
end

local function AutoInterrupt(spell) -- Thank you Dew for this <3
	if menu.combo.interrupt:get() and player:spellSlot(1).state==0 then
		if spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY then
			local enemyName = string.lower(spell.owner.charName)
			if interruptableSpells[enemyName] then
				for i = 1, #interruptableSpells[enemyName] do
					local spellCheck = interruptableSpells[enemyName][i]
					if menu.combo.interruptmenu[spell.owner.charName .. spellCheck.menuslot]:get() and string.lower(spell.name) == spellCheck.spellname then
						if player.pos2D:dist(spell.owner.pos2D) < 650 and common.IsValidTarget(spell.owner) and player:spellSlot(1).state==0 then
							player:castSpell('obj', 1, spell.owner)
						end
					end
				end
			end
		end
	end
end

function on_draw()

	local wtspplayer = graphics.world_to_screen(player.pos)
	if menu.combo.drawz.q:get() then
		graphics.draw_circle(player.pos, 365, 1, 0xffff0000, 50)
	end
	if menu.combo.drawz.e:get() then
		graphics.draw_circle(player.pos, 350, 3, 0xffff0000, 50)
	end	
	if menu.combo.drawz.w:get() then
		graphics.draw_circle(player.pos, 650, 1, 0xffff0000, 50)
	end
	if game.time <= 15 then
	graphics.draw_text_2D("Turn of spell evade with W if you want AntiGap", 20, (wtspplayer.x - 200), (wtspplayer.y +60), graphics.argb(255, 255, 0, 255))
	end
end





function on_tick()
	Insec()
	
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

cb.add(cb.spell, AutoInterrupt)
cb.add(cb.tick, on_tick)
cb.add(cb.draw, on_draw)

return {}