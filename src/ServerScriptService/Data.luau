-- Data: manages player data (ofc lol)
-- Written by Creoo / cyberstoicism on 2/29/24

-- Define module
local Data = {}

-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local DataStoreService = game:GetService("DataStoreService")

-- Modules

local Settings = require(ReplicatedStorage:WaitForChild("Settings"))

-- Variables

local DataStore = DataStoreService:GetDataStore("DATA_STORE")
local DataBase = {}
local Saves = {}

-- Local Functions

local function DeepCopy(Table)
    local Copy = {}

    for k, v in pairs(Table) do
        if type(v) == table then
            DeepCopy(v)
        else
            Copy[k] = v
        end
    end

    return Copy
end

local function UpdateLeaderstats(Player: Player, PlayerData: table)
    for _, Stat in pairs(Player:WaitForChild("leaderstats"):GetChildren()) do
        Stat.Value = PlayerData[Stat.Name]
    end
end

-- Module Functions

function Data.NewPlayer(Player: Player)
    local PlayerData = DeepCopy(Settings.DefaultData)
    Data.Set(Player, PlayerData)

    return PlayerData
end

function Data.Set(Player: Player, PlayerData: table)
    DataBase[Player.Name] = PlayerData -- first of all set the player's data within this module

    UpdateLeaderstats(Player, PlayerData) -- update the player's leaderstats

    -- leaderstats stuff will go here (if we do it)

    local TimeOfTransaction = os.time()
    local ToSave

    if not Saves[Player.Name] then
        ToSave = true
    else
        if Saves[Player.Name] - TimeOfTransaction > 60 then
            ToSave = true
        end
    end

    if not ToSave then return end

    Saves[Player.Name] = TimeOfTransaction

    local SUCCESS, ERROR_MESSAGE = pcall(function()
        DataStore:SetAsync("Player_" .. Players:GetUserIdFromNameAsync(Player.Name), PlayerData) -- set the player's data
    end)

    if not SUCCESS then
        warn(ERROR_MESSAGE)
    end
end

function Data.Get(Player: Player)
    return DataBase[Player.Name]
end

function Data.Remove(Player: Player)
    local PlayerData = Data.Get(Player)
    PlayerData["Version"] = Settings.Version -- set player version & leavetime before they exit the server
    PlayerData["LeaveTime"] = os.time()
    DataBase[Player.Name] = nil

    local SUCCESS, ERROR_MESSAGE = pcall(function()
        DataStore:SetAsync("Player_" .. Players:GetUserIdFromNameAsync(Player.Name), PlayerData) -- set the player's data
    end)

    if not SUCCESS then
        warn(ERROR_MESSAGE)
    end

    return PlayerData -- just in case
end

-- Remotes

-- Events

-- Return module
return Data