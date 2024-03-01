-- Server main script
-- Written by Creoo / cyberstoicism on 2/29/24

-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

-- Modules

local Framework = require(script:WaitForChild("Framework"))
local Data = require(script:WaitForChild("Data"))

-- Variables

-- Functions

-- Remotes

-- Events

Players.PlayerAdded:Connect(function(Player: Player)
    Framework.Join(Player)
end)

Players.PlayerRemoving:Connect(function(Player: Player)
    Framework.Leave(Player)
end)