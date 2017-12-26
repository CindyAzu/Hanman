return {
	["scriptType"] = "Champion",
	["scriptName"] = "FreeloSoraka",
	["moduleName"] = "FreeloSoraka",
	["entryPoint"] = "main.lua",
	["loadToCoreMenu"] = function()
		return player.charName == "Soraka"
	end
}