return {
	["scriptType"] = "Champion",
	["scriptName"] = "StarAlistar",
	["moduleName"] = "StarAlistar",
	["entryPoint"] = "main.lua",
	["loadToCoreMenu"] = function()
		return player.charName == "Alistar"
	end
}