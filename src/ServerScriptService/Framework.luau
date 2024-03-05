-- Framework: manages player joins/leaves & server items
-- Written by Creoo / cyberstoicism on 2/29/24

-- Define module
local Framework = {}

-- Services

local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Modules

local Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))
local Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local Tycoon = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Tycoon"))

-- Variables

local DataStore = DataStoreService:GetDataStore("DATA_STORE")

-- Local Functions

local function DeepReconcile(Table0 --[[Default data]], Table1 --[[Player's data]])
    for k, v in pairs(Table0) do
        if not Table1[k] then continue end

        if type(v) == table then
            DeepReconcile(Table0[k], Table1[k])
        else
            if Table1[k] then 
                Table0[k] = Table1[k] 
            end
        end
    end

    return Table0
end

local function PlayerSetup(Player: Player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Parent = Player
    leaderstats.Name = "leaderstats"

    local Credits = Instance.new("IntValue")
    Credits.Parent = leaderstats
    Credits.Name = "Credits"

    local Rebirths = Instance.new("IntValue")
    Rebirths.Parent = leaderstats
    Rebirths.Name = "Rebirths"
end

-- Module Functions

function Framework.Join(Player: Player)
    -- part 0, move character & setup player
    local Character = Player.Character or Player.CharacterAdded:Wait()
    PlayerSetup(Player)

    -- part 1, data

    local PlayerData = DataStore:GetAsync("Player_" .. Players:GetUserIdFromNameAsync(Player.Name))
    if not PlayerData then
        print(Player.Name .. " is a new player")
        PlayerData = Data.NewPlayer(Player)
    else
        if PlayerData["Version"] ~=  Settings.Version then
            PlayerData = DeepReconcile(Settings.DefaultData, PlayerData)
        end
    end

    Data.Set(Player, PlayerData)

    -- part 2, tycoon

    local PlayerTycoon = Tycoon.Add(Player)
    Tycoon.Load(Player, PlayerData, PlayerTycoon)
    Tycoon.Listen(Player, PlayerTycoon)

    coroutine.wrap(function()
        Tycoon.Economy(Player, PlayerTycoon)
    end)()

    -- part 3, finish up

    Character:SetPrimaryPartCFrame(PlayerTycoon:WaitForChild("Teleport").CFrame)
end

function Framework.Leave(Player: Player)
    -- part 1 save & remove player's data
    Data.Remove(Player)

    -- part 2 cleanup player's tycoon
    Tycoon.Remove(Player)
end

-- Remotes

-- Events

-- Return module
return Framework