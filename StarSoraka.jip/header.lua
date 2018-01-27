return {
	["scriptType"] = "Champion",
	["scriptName"] = "StarSoraka",
	["moduleName"] = "StarSoraka",
	["entryPoint"] = "main.lua",
	["loadToCoreMenu"] = function()
		return player.charName == "Soraka"
	end
}