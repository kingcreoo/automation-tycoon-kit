-- // Settings Panel

local Settings = {}

Settings.DefaultData = {
	["Version"] = Settings.Version,
	["LeaveTime"] = nil,
	["Credits"] = 100,
	["Rebirths"] = 0,
	["Tycoon"] = {
		[1] = 0,
		[2] = 0,
		[3] = 0
	}
}

-- Types {
--		"Decoration" - decorations
--		"Monetary" - things that earn money
--		"Defense" - active defenses
--		"Amenity" - vehicles & weapons
--}

Settings.Tycoon = {
	[1] = {
		["Name"] = "Item1",
		["Price"] = 100,
		["Currency"] = "Credits",
		["Dependency"] = nil,
		["Type"] = "Decoration",
		["Animation"] = nil,
		["Rebirths"] = 0
	},
	[2] = {
		["Name"] = "Item2",
		["Price"] = 200,
		["Currency"] = "Credits",
		["Dependency"] = 1,
		["Type"] = "Decoration",
		["Animation"] = nil,
		["Rebirths"] = 0
	},
	[3] = {
		["Name"] = "Item3",
		["Price"] = 300,
		["Currency"] = "Credits",
		["Dependency"] = 2,
		["Type"] = "Decoration",
		["Animation"] = nil,
		["Rebirths"] = 0
	}
}

Settings.Version = 1

return Settings