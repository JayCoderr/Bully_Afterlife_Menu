_G.__3DTexts = {}

local unpack = unpack

-- ===== Noclip Script (Full Free-Float) with DSL timing =====
local noclipActive = false
local speed = 10.0
local flyVerticalSpeed = 0.2
local hoverPos = nil
local prevCtrl = false

-- Menu toggle function
function Noclip()
    noclipActive = not noclipActive
    if noclipActive then
        local x, y, z = PlayerGetPosXYZ()
        hoverPos = {x=x, y=y, z=z}
        iprintln("Noclip: ON & Ctrl toggle on/off\nRMB togo forward\nShift+Space to go up/down\nMenu must be closed!")
    else
        hoverPos = nil
        iprintln("Noclip: OFF")
    end
end
-- VehicleSetPosSimple(vehicle, x, y, z)
--VehicleSetEntityFlag(gJV_Bike, 41, true)
--LT_GroupFunction(defaultCarGroup, VehicleSetCruiseSpeed, "id", "speed")
--LT_GroupFunction(groupName, VehicleSetCruiseSpeed, "id", "speed")
--VehicleSetCruiseSpeed(car, 0)
--VehicleSetCruiseSpeed(car, 25)
--VehicleGetPosXYZ(car)

local hoverPosZ = nil

function _G.NoclipTick()
    local Player = PlayerGetPed()
    if not Player then return end

    local X, Y, Z = PlayerGetPosXYZ()
    local _, _, Yaw = CameraGetRotation()
    local DT = GetFrameTime()
    Yaw = Yaw - math.pi

    -- CTRL toggle
    local ctrlDown = IsKeyPressed("DIK_LCONTROL") or IsKeyPressed("DIK_RCONTROL")
    if ctrlDown and not prevCtrl then
        noclipActive = not noclipActive
        iprintln("Noclip Active: " .. (noclipActive and "ON" or "OFF"))

        if noclipActive then
            -- Store current Z as hover position
            hoverPosZ = Z

            WorldCollision(Player, false, true, false)
            PedSetActionNode(Player, "/Global/Null", "Act/Globals.act")
            PedSetNoDamageNextFall(Player, true)
        else
            WorldCollision(Player, true, false, true)
            hoverPosZ = nil
        end
    end
    prevCtrl = ctrlDown

    if not noclipActive then return end

    -- Forward/back movement only when mouse pressed
    if IsMousePressed(0) then
        X = X - math.sin(Yaw) * speed * DT
        Y = Y + math.cos(Yaw) * speed * DT
    end

    -- Vertical movement independent of mouse
    if hoverPosZ then Z = hoverPosZ end

    if IsKeyPressed("DIK_SPACE") then
        Z = Z + flyVerticalSpeed
    elseif IsKeyPressed("DIK_LSHIFT") or IsKeyPressed("DIK_RSHIFT") then
        Z = Z - flyVerticalSpeed
    end

    -- Apply position
    PlayerSetPosSimple(X, Y, Z)
    PlayerFaceHeadingNow(math.deg(Yaw))

    -- Update hover Z for next frame
    hoverPosZ = Z
end

local superRunActive = false
local prevShift = false
local speedMultiplier = 1.0
local prevX, prevY = nil, nil
local speedIncrement = 0.05

function SuperRun()
    superRunActive = not superRunActive
    if superRunActive then
        local x, y, z = PlayerGetPosXYZ()
        hoverPos = {x=x, y=y, z=z}
        iprintln("SuperRun: ON & Ctrl toggle on/off\nalt boost forward\nMenu must be closed!")
    else
        hoverPos = nil
        iprintln("SuperRun: OFF")
    end
end

function _G.SuperRunTick(maxSpeedMultiplier)
    local Player = PlayerGetPed()
    if not Player then return end

    local X, Y, Z = PlayerGetPosXYZ()
    local _, _, Yaw = CameraGetRotation()
    local DT = GetFrameTime()
    Yaw = Yaw - math.pi

    -- --- SHIFT toggles super-run ON/OFF ---
    local shiftDown = IsKeyPressed("DIK_LSHIFT") or IsKeyPressed("DIK_RSHIFT")
    if shiftDown and not prevShift then
        superRunActive = not superRunActive
        if superRunActive then
            iprintln("SuperRun Active: ON")
            prevX, prevY = X, Y
        else
            iprintln("SuperRun Active: OFF")
            speedMultiplier = 1.0
        end
    end
    prevShift = shiftDown

    if not superRunActive then return end

    -- --- Only increase speed and move if ALT is held AND player is already moving ---
    local altDown = IsKeyPressed("DIK_LALT") or IsKeyPressed("DIK_RALT")
    if altDown then
        local movingX = prevX ~= nil and math.abs(X - prevX) > 0.001
        local movingY = prevY ~= nil and math.abs(Y - prevY) > 0.001

        if movingX or movingY then
            -- Increase multiplier gradually
            speedMultiplier = math.min(speedMultiplier + speedIncrement * DT * 60, maxSpeedMultiplier)

            -- Apply movement in camera forward direction
            local moveSpeed = 50.0 * DT * speedMultiplier
            X = X - math.sin(Yaw) * moveSpeed
            Y = Y + math.cos(Yaw) * moveSpeed

            PlayerSetPosSimple(X, Y, Z)
            PlayerFaceHeadingNow(math.deg(Yaw))
        end
    end

    -- Store previous positions for next frame
    prevX, prevY = X, Y
end

local superJumpActive = false
local prevRightAlt = false
local jumpMultiplier = 1.0
local prevZ = nil
local jumpIncrement = 0.05

function _G.SuperJumpTick(maxJumpMultiplier)
    local Player = PlayerGetPed()
    if not Player then return end

    local X, Y, Z = PlayerGetPosXYZ()
    local DT = GetFrameTime()

    -- --- Right Alt toggles super-jump ON/OFF ---
    local rightAltDown = IsKeyPressed("DIK_RALT")
    if rightAltDown and not prevRightAlt then
        superJumpActive = not superJumpActive
        if superJumpActive then
            iprintln("SuperJump Active: ON")
            prevZ = Z
        else
            iprintln("SuperJump Active: OFF")
            jumpMultiplier = 1.0
        end
    end
    prevRightAlt = rightAltDown

    if not superJumpActive then return end

    -- --- Only increase jump height if Space is pressed and Z is already increasing ---
    if IsKeyPressed("DIK_SPACE") then
	GiveMaxHealth()
        local movingZ = prevZ ~= nil and Z > prevZ + 0.001

        if movingZ then
            -- Increase jump/fly multiplier gradually
            jumpMultiplier = math.min(jumpMultiplier + jumpIncrement * DT * 60, maxJumpMultiplier)

            -- Apply Z increase
            Z = Z + 50.0 * DT * jumpMultiplier
            PlayerSetPosSimple(X, Y, Z)
        end
    end

    -- Store previous Z for next frame
    prevZ = Z
end

function GiveMaxHealth()
	local playerHealth = PlayerGetHealth()
	local playerMax = PedGetMaxHealth(gPlayer)

	playerHealth = playerHealth + 9999
	if playerMax <= playerHealth then
		PlayerSetHealth(playerMax)
	else
		PlayerSetHealth(playerHealth)
	end 
end

function TeaBagBitches()
	PedSetActionNode(gPlayer, "/Global/Player/JumpActions/Jump/Falling/Fall/Falling/Fall_No_Damage", "act/player.act")
end

function PrintAnimationBeingUsed()
	hashedAction = PedGetActionNodeData(gPlayer)
	iprintln(tostring(hashedAction))
	--PedGetActionNodeData(gPlayer)
	--PedGetActionNodeData(gPlayer)
end

function PlayerGetPed()
    return gPlayer
end

function WorldCollision(Player, wallCollide, groundCollide, gravityForce)
    local CollideWithWall = 43
    PedSetFlag(Player, CollideWithWall, wallCollide) -- false is no wall collide/true is wall collide
    PedSetUsesCollisionScripted(Player, groundCollide) -- ground collider false ground has collider true no collider
    PedSetEffectedByGravity(Player, gravityForce) -- Force to ground
end

function _G.iprintlnOrigin()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	iprintln("peds xyz: "..x1.." "..y1.." "..z1)
end

function _G.TP_10_north()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	PedSetPosXYZ(gPlayer, x1+10, y1, z1)
end

function _G.TP_10_south()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	PedSetPosXYZ(gPlayer, x1-10, y1, z1)
end

function _G.TP_10_west()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	PedSetPosXYZ(gPlayer, x1, y1+10, z1)
end

function _G.TP_10_east()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	PedSetPosXYZ(gPlayer, x1, y1-10, z1)
end

function _G.TP_10_up()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	PedSetPosXYZ(gPlayer, x1, y1, z1+10)
end

function _G.TP_10_down()
local x1, y1, z1 = PedGetPosXYZ(gPlayer) 
	PedSetPosXYZ(gPlayer, x1, y1, z1-10)
end

function _G.AddMoney(amount)
    -- If amount is a table, extract the first element
    if type(amount) == "table" then
        amount = amount[1]
    end

    amount = tonumber(amount) or 0

    local current = PedGetMoney(gPlayer)
	local x,y,z = PedGetPosXYZ(gPlayer) 
    local new = current + amount

    if new < 0 then new = 0 end
		
	EffectCreate("MagicSpell", x, y, z)
    
	PedSetMoney(gPlayer, new)
    iprintln("Money: " .. new)
end

function _G.SetScrollbarColor(rgba)
    if type(rgba) ~= "table" then
        error("SetScrollbarColor expects a table")
    end

    -- manually validate 4 entries
    local r = rgba[1]
    local g = rgba[2]
    local b = rgba[3]
    local a = rgba[4]

    if r == nil or g == nil or b == nil or a == nil then
        error("SetScrollbarColor expects {r, g, b, a}")
    end

    _G.defaultScrollerColor = { r, g, b, a }
end

-- Global debug print function using DrawText + DrawRectangle
function _G.iprintln(arg1, arg2, arg3, arg4)
    local text
    if type(arg1) == "table" and arg1.alive then
        text = arg2
    else
        text = arg1
    end
    if type(text) == "table" then text = text[1] end
    _G.__debugPrintText = tostring(text or "")
    _G.__debugPrintTimer = 100
end
-- example _3diprintln("You reached the spot!", nil, nil, nil, {x=100, y=200, z=300, r=3})
-- example 2 _3diprintln("Stand exactly here!", nil, nil, nil, {x=10, y=50, z=5})

-- register a 3D text point
-- make sure the global table exists
_G.__3DTexts = _G.__3DTexts or {}

-- register a new persistent 3D text point
function _G._3diprintln(text, _, _, _, pos)
    if type(pos) ~= "table" or not pos.x or not pos.y or not pos.z then
        return
    end

    local radius = pos.r
    if radius == nil then radius = 2 end

    local t = { x = pos.x, y = pos.y, z = pos.z, r = radius, text = tostring(text) }

    -- manually insert at the end
    _G.__3DTexts[table.getn(_G.__3DTexts) + 1] = t
end

-- tick thread to check player proximity and display text
CreateThread(function()
    while true do
        Wait(0)

        local px, py, pz = PedGetPosXYZ(gPlayer)
        local t, dx, dy, dz, distSq
        local count = table.getn(_G.__3DTexts)

        for i = 1, count do
            t = _G.__3DTexts[i]

            dx = px - t.x
            dy = py - t.y
            dz = pz - t.z
            distSq = dx*dx + dy*dy + dz*dz

            if distSq <= t.r * t.r then
                _G.__debugPrintText = t.text
                _G.__debugPrintTimer = 100
            end
        end
    end
end)


--- used to find buttons when i didn't know what they were

function GetAllKeysPressed(ignoreKeys)
    local keysPressed = {}
    ignoreKeys = ignoreKeys or {}

    local function shouldIgnore(key)
        for _, ig in ipairs(ignoreKeys) do
            if key == ig then return true end
        end
        return false
    end

    -- Check keyboard keys (1–255)
    for key = 1, 255 do
        if IsKeyPressed(key) and not shouldIgnore(key) then
            iprintln("Key code pressed: " .. key)
            table.insert(keysPressed, key)
        end
    end

    -- Check buttons (if your API uses same range, adjust as needed)
    for button = 1, 255 do  -- example button range
        if IsButtonPressed(button, 0) and not shouldIgnore(button) then
            iprintln("Button code pressed: " .. button)
            table.insert(keysPressed, button)
        end
    end	
    return keysPressed
end

local sleepBypass = false
local sleepHandler = nil  -- will store the handler object

function ToggleSleepBypass()
    sleepBypass = not sleepBypass

    if sleepBypass then
        -- ENABLE: register the handler
        sleepHandler = RegisterLocalEventHandler("PlayerSleepCheck", function()
            return true  -- cancels sleep check
        end)
        print("Sleep bypass: ON")
    else
        -- DISABLE: remove handler if it exists
        if sleepHandler then
            sleepHandler:Remove()
            sleepHandler = nil
        end
        print("Sleep bypass: OFF")
    end
end	
function GiveSelfWeapon(menu, weaponIndex, ammoAmount, weaponGiveEffect)
    if type(weaponIndex) == "table" then
        weaponIndex = weaponIndex[1]
    end
    weaponIndex = tonumber(weaponIndex) or 0
    ammoAmount = tonumber(ammoAmount) or 0

	local x,y,z = PedGetPosXYZ()			
	if weaponGiveEffect then
		EffectCreate(weaponGiveEffect, x, y, z) -- Confetti
    end

    local weaponStr = tostring(weaponIndex)
    if weaponIndex >= 299 and weaponIndex <= 444 then
        PedSetWeapon(PlayerGetPed(), weaponIndex, ammoAmount)
        PrintOutput("player was given weapon #" .. weaponStr)
    else
        PrintError("invalid weapon index: " .. weaponStr)
    end
end

_G.spawnedVehicles = {}
_G.SetVehicleBig = false
local spawnedVehiclesCount = 0

function SpawnCar(menu, modelId, pedNeedsWarp, maxVehicles, OwnerVehicle, SetVehicleBig, sizex, sizey, sizez)
    local _, _, yaw = CameraGetRotation()
    yaw = yaw    
    local headingDeg = math.deg(yaw)
    --PlayerFaceHeadingNow(headingDeg)
	Wait(0)
    if spawnedVehiclesCount >= maxVehicles then
        local oldVehicle = spawnedVehicles[1]

        if oldVehicle then
            if PedIsInVehicle(gPlayer, oldVehicle) then
                KickPedOutOfVehicle()
                Wait(0)
            end
			VehicleDelete(oldVehicle)
        end
        for i = 1, spawnedVehiclesCount - 1 do
            spawnedVehicles[i] = spawnedVehicles[i + 1]
        end

        spawnedVehicles[spawnedVehiclesCount] = nil
        spawnedVehiclesCount = spawnedVehiclesCount - 1
    end
    local distance = 10.0
    local camX, camY, camZ, fx, fy, fz = CameraGetXYZ(distance)
    local vehicle = VehicleCreateXYZ(modelId, fx, fy, fz)
	if OwnerVehicle then
		VehicleSetOwner(vehicle, gPlayer)
		PedEnterVehicle(gPlayer, vehicle)
		VehicleSetStatic(vehicle, true)
		PedPutOnBike(gPlayer, vehicle)
		PlayerPutOnBike(vehicle)
	end	
    if pedNeedsWarp then
        if PedIsInAnyVehicle(gPlayer) then
            iprintln("u can't do that in a vehicle")
            KickPedOutOfVehicle()
            Wait(2)
            vehicle = VehicleCreateXYZ(modelId, fx, fy, fz)
            PedWarpIntoCar(gPlayer, vehicle)
        else
            PedWarpIntoCar(gPlayer, vehicle)
        end
    end
    spawnedVehiclesCount = spawnedVehiclesCount + 1
    spawnedVehicles[spawnedVehiclesCount] = vehicle
	if SetVehicleBig then
		VehicleSetScale(vehicle, sizex,sizey,sizez)
	end
end

function VehicleSetScale(vehicle, scalex, scaley, scalez)
    local pitch, roll, yaw = VehicleGetRotation(vehicle)
    local rot = RotationMatrix(pitch, roll, yaw)

    local scale = mat3()
    scale[1][1] = scalex
    scale[2][2] = scaley
    scale[3][3] = scalez
    
	local final = rot * scale
    VehicleSetMatrix(vehicle, final)
end

-- global storage for the current ped scale toggle
_setPedScale = nil
_setPedSizeActive = false
_setPedScaleMsg = ""  -- store the message for printing
_ScalePedWas = false    -- tracks previous state

-- menu call: sets toggle + desired scale + message
function SetPedScale(menu, sizex, sizey, sizez, typeScaleMsg)
    _setPedSizeActive = not _setPedSizeActive
    _setPedScale = {x = sizex or 1.2, y = sizey or 1.2, z = sizez or 1.2} -- default 1.2
    _setPedScaleMsg = typeScaleMsg or "Ped Scale"
end

-- helper: applies scale
local function ApplyPedScale(ped)
    if not _setPedScale then return end
    local m = mat3()
    m[1][1] = _setPedScale.x
    m[2][2] = _setPedScale.y
    m[3][3] = _setPedScale.z
    PedSetMatrix(ped, PedGetMatrix(ped) * m)
end

-- register for the player
RegisterLocalEventHandler("PedUpdateMatrix", function(ped)
    if ped ~= gPlayer then return end

    -- print only on state change
    if _setPedSizeActive and not _ScalePedWas then
        iprintln(_setPedScaleMsg .. " Activated")
        _ScalePedWas = true
    elseif not _setPedSizeActive and _ScalePedWas then
        iprintln(_setPedScaleMsg .. " Deactivated")
        _ScalePedWas = false
    end

    -- apply scale when active
    if _setPedSizeActive then
        ApplyPedScale(ped)
    end
end)

function KickPedOutOfVehicle()
	PedExitVehicle(gPlayer)
    PedDetachFromVehicle(gPlayer)
    PlayerDetachFromVehicle(gPlayer)
end

--VehicleSetAccelerationMult(CopCar, 2)
local vehNoclip = false
local vehNoclipThread = nil

local vehSpeed = 20.0
local vehVerticalSpeed = 10.0


function ToggleVehicleNoclip(menu)
    vehNoclip = not vehNoclip

    if vehNoclip then
        iprintln("Vehicle Noclip: ON")
        StartVehicleNoclipThread()
		VehicleSetStatus(spawnedVehicles[1], 4)
		VehicleSetEntityFlag(spawnedVehicles[1], 0, false)
    else
        iprintln("Vehicle Noclip: OFF")
		VehicleSetStatus(spawnedVehicles[1], 0)
		VehicleSetEntityFlag(spawnedVehicles[1], 0, true)
    end
end

local vehHoverZ = nil

function StartVehicleNoclipThread()
    if vehNoclipThread then return end

    vehNoclipThread = CreateThread(function()
        while vehNoclip do
            if veh then		
                local x, y, z = VehicleGetPosXYZ(veh)
                local _, _, yaw = CameraGetRotation()
                local dt = GetFrameTime()

                yaw = yaw - math.pi

                -- Initialize hover Z once
                if not vehHoverZ then
                    vehHoverZ = z
                end

                -- Start from hover height
                z = vehHoverZ

                -- FORWARD/BACK (mouse)
                if IsMousePressed(0) then
                    x = x - math.sin(yaw) * vehSpeed * dt
                    y = y + math.cos(yaw) * vehSpeed * dt
				end

                -- VERTICAL — FIXED
                if IsKeyPressed("DIK_SPACE") then
                    vehHoverZ = vehHoverZ + vehVerticalSpeed * dt
                elseif IsKeyPressed("DIK_LSHIFT") or IsKeyPressed("DIK_RSHIFT") then
                    vehHoverZ = vehHoverZ - vehVerticalSpeed * dt
                end

                -- Use updated hoverZ
                z = vehHoverZ

                -- Apply position
                VehicleSetPosSimple(veh, x, y, z)
				--VehicleMoveToXYZ(veh, x, y, z)
				--iprintln("VehicleWheelsOnGround = " .. tostring(VehicleWheelsOnGround))

                -- Face yaw
                VehicleFaceHeading(veh, math.deg(yaw))
				if SetVehicleBig then
					VehicleSetScale(spawnedVehicles[1], 3, 3, 3)
				end	
            end

            Wait(0)
        end
        vehNoclipThread = nil
        vehHoverZ = nil
    end)
end

function SetPlayerGrade(menu, classid, classgrade, message)
	PlayerSetGrade(classid, classgrade)
	iprintln(message)
end

-- helper to safely increment/decrement grades
function GradeChange(menu, classId, delta, message)
    -- gGrade might be nil, default to 0
    local grade = gGrade or 0
    SetPlayerGrade(menu, classId, grade + delta, message)
end

-- Separate debug text rendering thread
CreateThread(function()
    while true do
        if _G.__debugPrintTimer and _G.__debugPrintTimer > 0 then
            local msg = tostring(_G.__debugPrintText or "")

            -- count lines WITHOUT #, gmatch, or indexing
            local lineCount = 5
            local i = 1

            while true do
                local ch = string.sub(msg, i, i)
                if ch == "" then
                    break
                end
                if ch == "\n" then
                    lineCount = lineCount + 1
                end
                i = i + 1
            end

            local baseHeight = 0.05
            local lineHeight = 0.025
            local bgHeight = baseHeight + (lineCount - 1) * lineHeight

            DrawTexture(
                _G.menuBaseIprintlnPng,
                0,
                0.14,
                0.31,
                bgHeight,
                255, 255, 255, 255
            )

            SetTextColor(255, 255, 255, 255)
            SetTextPosition(0.17, 0.2)
            DrawText(msg, 60, 60, 0, 255, 255, 255, 255)

            _G.__debugPrintTimer = _G.__debugPrintTimer - 1
        end
        Wait(0)
    end
end)


