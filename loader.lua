-- [[ Yokid Hub - Multi-Script Loader ]]
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId

-- เปลี่ยน Yoyox1 ให้ตรงกับชื่อผู้ใช้ GitHub ของคุณ
local BASE_URL = "https://raw.githubusercontent.com/Yoyox1/yokid-hub/main/scripts/"

local GameScripts = {
    -- [PlaceId] = "games/auto_throw.lua", -- ใส่ Place ID ของเกมที่นี่ในอนาคต
}

local function LoadScript(path)
    local url = BASE_URL .. path
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and content then
        local run, err = loadstring(content)
        if run then run() else warn("Syntax Error: " .. tostring(err)) end
    else
        warn("Failed to load script from: " .. url)
    end
end

-- โหลดสคริปต์ตามเกม หรือถ้าไม่มีให้โหลด Universal
if GameScripts[PlaceId] then
    LoadScript(GameScripts[PlaceId])
else
    print("[Yokid Hub] Loading main script...")
    -- ในอนาคตจะเชื่อมต่อไปที่ main_gui.lua หรือ universal.lua
end
