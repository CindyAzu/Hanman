local version = "1.0"

local common = module.load("avada_lib", "common")
local orb = module.internal("orb/main")
local gpred = module.internal("pred/main")


local menu = menuconfig("WardTrick", "WardTrick")

menu:menu("WT", "WardTrick")
menu.WT:boolean("TL", "Toggle WardTrick in Combo", true)
	
menu:header("version", "Version: 1.0")
menu:header("author", "Author: Cindy")



local function WardTarget(range)
    for i = 0, objmanager.enemies_n - 1 do
        local enemy = objmanager.enemies[i]
        if common.IsValidTarget(enemy) and common.GetDistance(player, enemy) < range then
            return enemy
        end
    end
end



local function losevision(target)
	local target = WardTarget(700)
	if orb.combat.is_active() and not target.isVisible and common.GetDistance(player, target) < 600 and #common.GetEnemyHeroesInRange(600) >= 1 then
		for i = 6, 12 do
			local item = player:spellslot(i).name
			if item and item == "TrinketTotemLvl1" or item == "ItemGhostWard" or item == "JammerDevice" or item == "TrinketOrbLvl3" and player:spellslot(i).state == 0 then
				print(tostring(target))
				game.cast("pos", i, vec3(player.pos:lerp(target, 1.1)))
				break
			end
		end
	end	
end

function on_tick()

end
callback.add(enum.callback.recv.losevision, function() losevision(target) end)
callback.add(enum.callback.tick, function() on_tick() end)



return {}