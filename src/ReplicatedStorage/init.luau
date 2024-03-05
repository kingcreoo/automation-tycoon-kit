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
--		"Economy" - things that earn money
--		"Defense" - active defenses
--		"Amenity" - vehicles & weapons
--}

-- CPS = Cash Per Second

Settings.Tycoon = {
	[1] = {
		-- BASICS
		["Name"] = "Item1",
		["Price"] = 100,
		["Currency"] = "Credits",
		["Dependency"] = nil,
		["Type"] = "Economy",
		["Animation"] = nil,
		["Rebirths"] = 0,
		-- ECONOMY
		["CPS"] = 10
		-- DEFENSE
		-- AMENITY
	},
	[2] = {
		-- BASICS
		["Name"] = "Item2",
		["Price"] = 200,
		["Currency"] = "Credits",
		["Dependency"] = 1,
		["Type"] = "Economy",
		["Animation"] = nil,
		["Rebirths"] = 0,
		-- ECONOMY
		["CPS"] = 10
		-- DEFENSE
		-- AMENITY
	},
	[3] = {
		-- BASICS
		["Name"] = "Item3",
		["Price"] = 300,
		["Currency"] = "Credits",
		["Dependency"] = 1,
		["Type"] = "Decoration",
		["Animation"] = nil,
		["Rebirths"] = 0,
		-- ECONOMY
		["CPS"] = nil
		-- DEFENSE
		-- AMENITY
	}
}

Settings.Version = 1

return Settings