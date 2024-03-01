-- Tycoon: manages the tycoon model
-- Written by Creoo / cyberstoicism on 2/29/24

-- Define module
local Tycoon = {}

-- Services

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

-- Modules

local Settings = require(ReplicatedStorage:WaitForChild("Settings"))
local Data = require(ServerScriptService:WaitForChild("Server"):WaitForChild("Data"))

-- Variables

local Locations = {
    [1] = {["CFrame"] = CFrame.new(25,.5,0), ["Occupied"] = false},
    [2] = {["CFrame"] = CFrame.new(-25,.5,0), ["Occupied"] = false},
}

local TycoonTemplate = ReplicatedStorage:WaitForChild("TycoonTemplate")
local TycoonsFolder = workspace:WaitForChild("Tycoons")

-- Functions

function Tycoon.Listen(Player: Player, PlayerTycoon: Model)

end

function Tycoon.Add(Player: Player)
    local PlayerTycoon: Model = TycoonTemplate:Clone()
    PlayerTycoon.Name = Player.Name
    PlayerTycoon.Parent = TycoonsFolder

    local SelectedLocation
    for Number, Info in pairs(Locations) do
        if Info["Occupied"] then continue end

        SelectedLocation = Number
    end

    Locations[SelectedLocation]["Occupied"] = true
    PlayerTycoon:SetPrimaryPartCFrame(Locations[SelectedLocation]["CFrame"])
    PlayerTycoon:SetAttribute("Location", SelectedLocation)

    return PlayerTycoon
end

local function ItemSetup(ID, Owned, Player: Player, PlayerData: table, PlayerTycoon: Model)
    if Owned == 1 then
        PlayerTycoon:WaitForChild("Buttons"):WaitForChild(ID):Destroy()
    elseif Owned == 0 then
        if PlayerData["Tycoon"][Settings.Tycoon[ID]["Dependency"]] == 0 then
            -- player does not own dependency, set item & button to invisible
            
            for _, Part in pairs(PlayerTycoon:WaitForChild("Buttons"):WaitForChild(ID):WaitForChild("Build"):GetChildren()) do
                Part.Transparency = 1
                Part.CanCollide = false
            end

            for _, Part in pairs(PlayerTycoon:WaitForChild("Items"):WaitForChild(ID):WaitForChild("Build"):GetChildren()) do
                Part.Transparency = 1
                Part.CanCollide = false
            end
        elseif PlayerData["Tycoon"][Settings.Tycoon[ID]["Dependency"]] == 1 or Settings.Tycoon[ID]["Dependency"] == nil then
            -- player does own dependency(or there is no dependency), set item to invisble but keep button visible

            for _, Part in pairs(PlayerTycoon:WaitForChild("Items"):WaitForChild(ID):WaitForChild("Build"):GetChildren()) do
                Part.Transparency = 1
                Part.CanCollide = false
            end
        end
    end
end

function Tycoon.Load(Player: Player, PlayerData: table, PlayerTycoon: Model)
    for ID, Owned in pairs(PlayerData["Tycoon"]) do -- for each item in the tycoon, run a setup function (see function above)
        ItemSetup(ID, Owned, Player, PlayerData, PlayerTycoon)
    end
end

function Tycoon.Remove(Player: Player)
    local PlayerTycoon = TycoonsFolder:WaitForChild(Player.Name)

    -- save player's tycoon data here.

    PlayerTycoon:Destroy()
    Locations[PlayerTycoon:GetAttribute("Location")]["Occupied"] = false
end

-- Remotes

-- Events

-- Return module
return Tycoon