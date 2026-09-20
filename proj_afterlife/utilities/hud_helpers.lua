-- GIF menu background
function StartMenuGif(arg1, arg2, arg3)
    local menuDesign, totalGifCount, delay

    -- if first arg is a menu object, shift args
    if type(arg1) == "table" and arg1.alive then
        menuDesign = arg2
        totalGifCount = arg3
        delay = 200
    else
        menuDesign = arg1
        totalGifCount = arg2
        delay = arg3 or 200
    end

    menuDesign = tostring(menuDesign)

    -- cancel previous GIF loop
    if _G.menuGifRunning then
        _G.menuGifRunning = false
        Wait(50)
    end

    _G.menuDesign = menuDesign
    _G.menuIndex = 1
    _G.menuTotal = totalGifCount
    _G.menuGifRunning = true

    CreateThread(function()
        while _G.menuGifRunning do
            local filename = "proj_afterlife/utilities/images/" .. menuDesign .. _G.menuIndex .. ".png"
            _G.menuBasePng = CreateTexture(filename)

            _G.menuIndex = _G.menuIndex + 1
            if _G.menuIndex > totalGifCount then
                _G.menuIndex = 1
            end

            Wait(delay)
        end
    end)
end

-- Static menu background
function SetMenuDesign(arg1, arg2)
    local menuDesign, IsSilentApply

    if type(arg1) == "table" and arg1.alive then
        menuDesign = arg2
        IsSilentApply = false
    else
        menuDesign = arg1
        IsSilentApply = arg2 or false
    end

    menuDesign = tostring(menuDesign)

    -- stop GIF
    _G.menuGifRunning = false
    _G.menuIndex = nil
    _G.menuTotal = nil

    _G.menuDesign = menuDesign
    _G.menuBasePng = CreateTexture("proj_afterlife/utilities/images/" .. menuDesign .. ".png")

    if IsSilentApply then
        iprintln("Menu background set to: " .. menuDesign)
    end
end
