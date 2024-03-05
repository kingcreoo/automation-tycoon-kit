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

local ToCollect = {}

-- Local Functions

local function ItemSetup(ID, Owned, Player: Player, PlayerData: table, PlayerTycoon: Model, startUp: boolean)
    if Owned == 1 and startUp then
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

-- Module Functions

function Tycoon.DevProductPurchase()

end

function Tycoon.Purchase(Button: Model, Player: Player, PlayerTycoon: Model)
    local PlayerData = Data.Get(Player)

    -- Check 0: Does player already own this item? Does player not own the dependency for this item?
    if PlayerData["Tycoon"][tonumber(Button.Name)] == 1 or Settings.Tycoon[tonumber(Button.Name)]["Dependency"] and PlayerData["Tycoon"][Settings.Tycoon[tonumber(Button.Name)]["Dependency"]] == 0 then
        -- player already owns this item or does not own the depdency for this item
        warn("player already owns this item or does not own the depdency for this item")
        return
    end

    -- Check 1: Does player have enough rebirths to purchase this item?
    if PlayerData["Rebirths"] < Settings.Tycoon[tonumber(Button.Name)]["Rebirths"] then
        -- player does not have enough rebirths to purchase this item
        warn("player does not have enough rebirths to purchase this item")
        return
    end

    -- Check 2: Does player have enough currency to purchase this item?
    if PlayerData[Settings.Tycoon[tonumber(Button.Name)]["Currency"]] < Settings.Tycoon[tonumber(Button.Name)]["Price"] then
        -- player does not have credits/rebirth tokens to purchase this item
        warn("player does not have credits/rebirth tokens to purchase this item")
        return
    end

    -- Player has passed all checks.
    PlayerData[Settings.Tycoon[tonumber(Button.Name)]["Currency"]] -= Settings.Tycoon[tonumber(Button.Name)]["Price"] -- Remove player's credits/rebirth tokens
    PlayerData["Tycoon"][tonumber(Button.Name)] = 1 -- Award player the item in their data

    Data.Set(Player, PlayerData) -- Set player data
    print(PlayerData)

    for _, Part in pairs(PlayerTycoon:WaitForChild("Items"):WaitForChild(Button.Name):WaitForChild("Preview"):GetChildren()) do -- destroy the preview
        Part:Destroy()
    end

    for _, Part in pairs(PlayerTycoon:WaitForChild("Items"):WaitForChild(Button.Name):WaitForChild("Build"):GetChildren()) do -- activate build parts
        Part.Transparency = 0
        Part.CanCollide = true
    end

    Button:Destroy() -- destroy button

    for ID, Owned in pairs(PlayerData["Tycoon"]) do -- for each item in the tycoon, run a setup function (see function above)
        ItemSetup(ID, Owned, Player, PlayerData, PlayerTycoon)
    end
end

function Tycoon.Listen(Player: Player, PlayerTycoon: Model)
    for _, Button: Model in pairs(PlayerTycoon:WaitForChild("Buttons"):GetChildren()) do
        local Touch = Button:WaitForChild("Touch")
        local DEBOUNCE = false

        Touch.Touched:Connect(function(hit)
            if hit.Parent.Name ~= Player.Name or not hit.Parent:FindFirstChild("Humanoid") or DEBOUNCE then
                return
            end

            DEBOUNCE = true

            if Settings.Tycoon[tonumber(Button.Name)]["Currency"] == "DevProduct" then -- this is a robux purchase
                Tycoon.DevProductPurchase()

                return
            end

            -- this is a standard purchase

            Tycoon.Purchase(Button, Player, PlayerTycoon)

            task.wait(1)

            DEBOUNCE = false
        end)
    end

    PlayerTycoon:WaitForChild("Collector"):WaitForChild("Touch").Touched:Connect(function(hit)
        if hit.Parent.Name ~= Player.Name and not hit.Parent:FindFirstChild("Humanoid") then
            return
        end

        Tycoon.Collect(Player, PlayerTycoon)
    end)
end

function Tycoon.Economy(Player: Player, PlayerTycoon: Model)
    while true do
        task.wait(2)

        for ID, Owned in pairs(Data.Get(Player)["Tycoon"]) do
            if Settings.Tycoon[ID]["Type"] == "Economy" and Owned == 1 then
                ToCollect[Player.Name] += (Settings.Tycoon[ID]["CPS"])
            end
        end
    end
end

function Tycoon.Collect(Player: Player, PlayerTycoon: Model)
    local PlayerData = Data.Get(Player)
    PlayerData["Credits"] += ToCollect[Player.Name]
    ToCollect[Player.Name] = 0

    Data.Set(Player, PlayerData)

    -- animation here
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

    ToCollect[Player.Name] = 0

    return PlayerTycoon
end

function Tycoon.Load(Player: Player, PlayerData: table, PlayerTycoon: Model)
    for ID, Owned in pairs(PlayerData["Tycoon"]) do -- for each item in the tycoon, run a setup function (see itemsetup function above)
        ItemSetup(ID, Owned, Player, PlayerData, PlayerTycoon, true)
    end
end

function Tycoon.Remove(Player: Player)
    local PlayerTycoon = TycoonsFolder:WaitForChild(Player.Name)

    ToCollect[Player.Name] = nil

    -- save player's tycoon data here.

    PlayerTycoon:Destroy()
    Locations[PlayerTycoon:GetAttribute("Location")]["Occupied"] = false
end

-- Remotes

-- Events

-- Return module
return Tycoon