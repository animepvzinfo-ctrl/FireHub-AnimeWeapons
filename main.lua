local success, Starlight = pcall(function()
    return loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
end)
if not success or not Starlight then return end

local Window = Starlight:CreateWindow({
    Name = "FireHub",
    Subtitle = "The Best",
    LoadingEnabled = true,
    LoadingTitle = "FireHub",
    LoadingSubtitle = "Carregando script...",
    KeySystem = true,
    KeySettings = {
        Title = "FireHub",
        Subtitle = "Sistema de Key",
        Key = "DypzDev",
        SaveKey = true,
        FileName = "FireHubKey"
    }
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local autoOpen = false
local openDelay = 100
local autoClick = false
local clickDelay = 50
local autoRank = false
local rankDelay = 500
local autoLeave = false
local leaveWave = 10
local jaExecutou = false

local function doAutoOpen()
    pcall(function()
        local args = { "Gacha Multi" }
        ReplicatedStorage.Reply.Reliable:FireServer(unpack(args))
    end)
end

local function doAutoClick()
    pcall(function()
        local args = { "Hit" }
        ReplicatedStorage.Reply.Unreliable:FireServer(unpack(args))
    end)
end

local function doAutoRank()
    pcall(function()
        local args = { "RankUp" }
        ReplicatedStorage.Reply.Reliable:FireServer(unpack(args))
    end)
end

local function getWaveAtual()
    local playerGui = player:WaitForChild("PlayerGui")
    local success, waveAmount = pcall(function()
        return playerGui.Screen.Hud.gamemode.Raid.wave.amount
    end)
    if success and waveAmount then
        return tonumber(waveAmount.Text)
    end
    return nil
end

local function deixarRaid()
    Starlight:Notify({
        Title = "Auto Leave",
        Description = "Saindo da raid na wave " .. leaveWave,
        Duration = 2
    })
    local args = { "Zone Teleport", { "Dungeon" } }
    ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Reliable"):FireServer(unpack(args))
    wait(2)
    local argsEntrar = { "Join Gamemode", { "Raid:1" } }
    ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Reliable"):FireServer(unpack(args))
end

local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10734950309"
})

local ClickToggle = MainTab:CreateToggle({
    Name = "Auto Click",
    Default = false,
    Callback = function(v) autoClick = v end
})

local ClickDelaySlider = MainTab:CreateSlider({
    Name = "Click Delay (ms)",
    Min = 1,
    Max = 200,
    Default = clickDelay,
    Increment = 1,
    Callback = function(v) clickDelay = v end
})

local RankToggle = MainTab:CreateToggle({
    Name = "Auto Rank",
    Default = false,
    Callback = function(v) autoRank = v end
})

task.spawn(function()
    while true do
        task.wait(clickDelay / 1000)
        if autoClick then doAutoClick() end
    end
end)

task.spawn(function()
    while true do
        task.wait(rankDelay / 1000)
        if autoRank then doAutoRank() end
    end
end)

local StarTab = Window:CreateTab({
    Name = "Star",
    Icon = "rbxassetid://10723434711"
})

local AutoOpenToggle = StarTab:CreateToggle({
    Name = "Auto Multi",
    Default = false,
    Callback = function(v) autoOpen = v end
})

local DelaySlider = StarTab:CreateSlider({
    Name = "Multi Delay (ms)",
    Min = 1,
    Max = 1000,
    Default = openDelay,
    Increment = 1,
    Callback = function(v) openDelay = v end
})

task.spawn(function()
    while true do
        task.wait(openDelay / 1000)
        if autoOpen then doAutoOpen() end
    end
end)

local RaidTab = Window:CreateTab({
    Name = "Raid",
    Icon = "rbxassetid://10747373176"
})

local AutoLeaveToggle = RaidTab:CreateToggle({
    Name = "Auto Leave",
    Default = false,
    Callback = function(v)
        autoLeave = v
        if v then
            Starlight:Notify({
                Title = "Auto Leave",
                Description = "Ativado! Vai sair na wave " .. leaveWave,
                Duration = 3
            })
        end
    end
})

local LeaveWaveSlider = RaidTab:CreateSlider({
    Name = "Wave para Sair",
    Min = 1,
    Max = 50,
    Default = leaveWave,
    Increment = 1,
    Callback = function(v) leaveWave = v end
})

local WaveLabel = RaidTab:CreateLabel({
    Text = "Wave atual: --"
})

task.spawn(function()
    while true do
        task.wait(1)
        if autoLeave then
            local waveAtual = getWaveAtual()
            if waveAtual then
                WaveLabel:Set("Wave atual: " .. waveAtual)
                if waveAtual >= leaveWave and not jaExecutou then
                    deixarRaid()
                    jaExecutou = true
                    task.wait(10)
                    jaExecutou = false
                end
            else
                WaveLabel:Set("Wave atual: Não encontrada")
            end
        end
    end
end)

local EquipTab = Window:CreateTab({
    Name = "Equip",
    Icon = "rbxassetid://10723407389"
})

local fruitList = {
    ["Dmg (Legendary)"] = "5",
    ["Power (Mythical)"] = "6",
    ["Dmg (Secret)"] = "7"
}

local EquipDropdown = EquipTab:CreateDropdown({
    Name = "Select Fruit",
    Options = { "Dmg (Legendary)", "Power (Mythical)", "Dmg (Secret)" },
    Default = "Dmg (Legendary)",
    Callback = function(selected)
        local id = fruitList[selected]
        if not id then return end
        local args = { "Vault Equip", { id, "Fruits" } }
        ReplicatedStorage:WaitForChild("Reply"):WaitForChild("Reliable"):FireServer(unpack(args))
        Starlight:Notify({
            Title = "Equip",
            Description = "Equipado: " .. selected,
            Duration = 2
        })
    end
})
