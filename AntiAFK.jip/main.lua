local version = "0.7"

local common = module.load("avada_lib", "common")
local tSelector = module.load("avada_lib", "targetSelector")
local orb = module.internal("orb/main")
local gpred = module.internal("pred/main")
local dlib = module.load("avada_lib", "damageLib")


local menu = menuconfig("Soraka", "AntiAFK") -- UNDER CONSTRUCTION

menu:header("head", "AntiAFK")
menu:menu("AntiAFK", "AntiAFK")
menu.AntiAFK:boolean("TL", "Toggle AFK", true)
	
menu:header("version", "Version: 0.1")
menu:header("author", "Author: Cindy")

local function anti()
	if menu.AntiAFK.TL:get() then
	
	game.issue('move', vec3(game.mousePos.x, game.mousePos.y, game.mousePos.z))
	
	end
end

function on_tick()
	
	if menu.AntiAFK.TL:get() then
	anti()
	end
	

end

callback.add(enum.callback.tick, function() on_tick() end)

return {}