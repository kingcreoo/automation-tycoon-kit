-- // Settings Panel

local Settings = {}

Settings.DefaultData = {
	["Version"] = Settings.Version,
	["LeaveTime"] = nil,
	["Cash"] = 100,
	["Tycoon"] = {
		[1] = 0,
		[2] = 0,
		[3] = 0
	}
}

Settings.Tycoon = {
	[1] = {
		["Name"] = "Item1",
		["Price"] = 100,
		["Dependency"] = nil
	},
	[2] = {
		["Name"] = "Item2",
		["Price"] = 200,
		["Dependency"] = 1
	},
	[3] = {
		["Name"] = "Item3",
		["Price"] = 300,
		["Dependency"] = 2
	}
}

Settings.Version = 1

return Settings