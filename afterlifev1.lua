LoadScript("loadLogic.lua")
LoadScript("proj_afterlife/utilities/menu.lua")
LoadScript("proj_afterlife/utilities/hud_helpers.lua")
LoadScript("proj_afterlife/utilities_func/functions.lua")
local currentMenu
-- Define submenu names in a list
local submenuNames = {
	"Project Afterlife v1",
	"Main Mods",
	"Peds Menu",
	"Set Jimmy's Outfit",
	"AI Peds Menu",
	"Spawn Menu",
	"Status Menu",
	"Money Menu",
	"Weapons Menu",
	"Fun Mods",
	"Self Msg",
	"Clone Menu",
	"Guard Menu",
	"Teleport Menu",
	"Weather Menu",
	"World Menu",
	"Forge Menu",
	"Visions Menu",
	"Sounds Menu",
	"Themes Menu",
	"Scrollbar Editor",
	"All Peds Menu"
}

_G.menuDesign = "menu_background"
-- Table to hold all submenus
local submenus = {}

function _G.SetupMenu()
    MenuControls()
	AllowAreaTransitions(true)
    if not menuOpen then
        NoclipTick()
		SuperRunTick(0.2)
		SuperJumpTick(0.4)
    end
    Afterlifev1Menu()
end

local menuOpen = false

function MenuControls()
    if IsKeyPressed("F1") then
        repeat Wait(0) until not IsKeyPressed("F1")

        if menuOpen then
            -- Close menu
            if currentMenu then
                currentMenu.alive = false
                currentMenu = nil
            end
            menuOpen = false

        else
            -- Open menu
            SetMenuDesign(_G.menuDesign, false)

            -- CRITICAL: assign returned menu
            currentMenu = CreateMenuStructure(submenuNames[1])

            menuOpen = true
        end
    end
end

function CreateMenuStructure(menuName)
    local menu = MenuTitle(menuName)

    -- Create submenus
    for _, name in ipairs(submenuNames) do
        local sm = CreateSubMenu(name)
        sm.name = name
        sm.parentMenu = menu
        submenus[name] = sm
    end

    currentMenu = menu
    menu.alive = true

    return menu
end

function Afterlifev1Menu()
    if currentMenu and currentMenu.alive then
        MenuOption(currentMenu, "Main Menu", MainMods, submenus["Main Mods"])
        MenuOption(currentMenu, "Peds Menu", PedsMenu, submenus["Peds Menu"]) 
		MenuOption(currentMenu, "Clothing Menu", CMenu, submenus["Set Jimmy's Outfit"]) 
        MenuOption(currentMenu, "AI Peds Menu", AIPedsMenu, submenus["AI Peds Menu"]) 
        MenuOption(currentMenu, "Spawn Menu", SpawnMenu, submenus["Spawn Menu"]) 
        MenuOption(currentMenu, "Status Menu", SkillzMenu, submenus["Status Menu"]) 
        MenuOption(currentMenu, "Money Menu", MoneyMenu, submenus["Money Menu"])
        MenuOption(currentMenu, "Weapons Menu", WeaponsMenu, submenus["Weapons Menu"]) 
        MenuOption(currentMenu, "Fun Mods", FunMods, submenus["Fun Mods"]) 
        MenuOption(currentMenu, "Self Msg", SelfMsgMenu, submenus["Self Msg"])
        MenuOption(currentMenu, "Clone Menu", CloneMenu, submenus["Clone Menu"]) 
        MenuOption(currentMenu, "Teleport Menu", TPMenu, submenus["Teleport Menu"])
        MenuOption(currentMenu, "World Menu", WorldMenu, submenus["World Menu"]) 
        MenuOption(currentMenu, "Forge Menu", ForgeMenu, submenus["Forge Menu"]) 
        MenuOption(currentMenu, "Visions Menu", VisionsMenu, submenus["Visions Menu"])
        MenuOption(currentMenu, "Sounds Menu", SoundsMenu, submenus["Sounds Menu"]) 
        MenuOption(currentMenu, "Themes Menu", ThemesMenu, submenus["Themes Menu"]) 
		MenuOption(currentMenu, "Scrollbar Editor", ScrollbarEditor, submenus["Scrollbar Editor"]) 
        MenuOption(currentMenu, "All Peds Menu", AllPedsMenu, submenus["All Peds Menu"]) 
        redraw(currentMenu)
	end		
end

function MainMods(menu)
    currentMenu = menu
	MainModsX = submenus["Main Mods"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(MainModsX, "Flymode", Noclip)
        MenuOption(MainModsX, "Godmode", Noclip)
        MenuOption(MainModsX, "Demi-God", Noclip) -- add option for instant lock picking, should also add a never in trouble toggle
		MenuOption(MainModsX, "Infinite Sprint", PlayerInfiniteSprint, true)
		MenuOption(MainModsX, "Run Fast", SuperRun, 0.5)
        MenuOption(MainModsX, "Peds Ignore", Noclip)
        MenuOption(MainModsX, "Promod", Noclip) -- you can increase fov and possibly throw a shader on screen
        MenuOption(MainModsX, "Invisible", Noclip)
        MenuOption(MainModsX, "Wallhack", Noclip) -- i did see a isnear so u can do this
        MenuOption(MainModsX, "Unlmited Ammo", Noclip)
        MenuOption(MainModsX, "Bypass Sleep", ToggleSleepBypass) -- original was random vision should still add this back.
        MenuOption(MainModsX, "Human Torch", Noclip) -- see if we can set a effect on a ped
		MenuOption(MainModsX, "Force Ped Action", Noclip)
		MenuOption(MainModsX, "Drunkmode", Noclip) -- you legit just roll camera
		MenuOption(MainModsX, "Flashing Player", Noclip) -- just makes players invisible state toggle in a loop
		MenuOption(MainModsX, "Confetti-mode", Noclip)
		MenuOption(MainModsX, "Double Jump", Noclip)
		MenuOption(MainModsX, "Rotate Ped", Noclip)
		MenuOption(MainModsX, "No wall colliders", Noclip)
		MenuOption(MainModsX, "Box head", Noclip) -- try to attach a object or prop to the player/ see if we can attach a box or something like that to the head of the ped
		MenuOption(MainModsX, "Kamikaze Students", Noclip) -- if we can spawn props can we controll where they spawn??? and move them to a position after spawning them
		MenuOption(MainModsX, "Terminator", Noclip) -- honestly doesn't have to be terminator but is good place holder for idea
		MenuOption(MainModsX, "Spawn Bounce Pad", Noclip) -- gotta try to understand the look at bs math
		MenuOption(MainModsX, "Jetpack", Noclip) -- i don't really think this is possible
		MenuOption(MainModsX, "Custom Crosshairs", Noclip) -- i don't really think this is possible
		MenuOption(MainModsX, "DoHeart", Noclip) -- just use drawText
		MenuOption(MainModsX, "Health bar", Noclip) -- healthbar not really needed tho....
		MenuOption(MainModsX, "Forcefield", Noclip) -- push a ped away from your x,y,z 
		MenuOption(MainModsX, "Money Gun", Noclip) -- money gun, choose a item/pickup the user must have to give them money.
		MenuOption(MainModsX, "Matrix Mode", Noclip) -- I saw u can speed the simulation up or down so i think this is possible and add a vision on top of it
		MenuOption(MainModsX, "Slow-mo Gun", Noclip) -- only slows simulation 
		MenuOption(MainModsX, "Mod Peds Fov", Noclip) -- i seen a function for this
		MenuOption(MainModsX, "Teleport To lookat xyz", Noclip) -- this can be hard because the math doesn't have a mf lookat function no return for what your looking at makes everything more complicated
		MenuOption(MainModsX, "ZoidBerg Gif", Noclip)
		MenuOption(MainModsX, "Revive/Kill Self", Noclip) -- seen a function for this
		MenuOption(MainModsX, "Hide Gamehud", Noclip)
		MenuOption(MainModsX, "Rapid Slingshot", Noclip) -- maybe possible make it so slingshot is a machine gun.
		MenuOption(MainModsX, "Norecoil", Noclip) --norecoil if it's a thing?
		MenuOption(MainModsX, "Random Debug Test", Noclip) -- a function for random debug test
        MenuOption(MainModsX, "Back", function() CreateMenuStructure(submenuNames[1]) end)
        if left(MainModsX) then CreateMenuStructure(submenuNames[1]) end
        redraw(MainModsX)
        Wait(0)
    end
    Wait(50)	
end



function PlayerInfiniteSprint(InfSpeed)
	PedSetInfiniteSprint(gPlayer, infSpeed)
end

function PlayerBig()
{
	currentMenu = menu
	SetPedScale(menu, 2, 2, 2, "Player Super Size Activated!")
}

function PlayerSmall()
{
	currentMenu = menu
	SetPedScale(menu, 0.2, 0.2, 0.2, "Player Normal Activated!")
}

function PlayerNormal()
{
	currentMenu = menu
	SetPedScale(menu, 1, 1, 1, "Player Normal Activated!")
}

function PedsMenu(menu)
    currentMenu = menu
	PedMenu = submenus["Peds Menu"]
    while currentMenu == menu and currentMenu.alive do
        
        MenuOption(PedMenu, "Toggle 3rd/1st Person", Noclip)
        MenuOption(PedMenu, "Toggle Camera Active", Noclip)
        MenuOption(PedMenu, "Animations Menu", Noclip)
        MenuOption(PedMenu, "Play as ped 1", Noclip)
        MenuOption(PedMenu, "Play as ped 2", Noclip)
        MenuOption(PedMenu, "Play as ped 3", Noclip)
        MenuOption(PedMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
        if left(PedMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(PedMenu)
        Wait(0)
    end
    Wait(50)
end

function CMenu(menu)
    currentMenu = menu
	Outfits = submenus["Set Jimmy's Outfit"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(Outfits, "Set Jimmy's Outfit", Noclip)
        MenuOption(Outfits, "outfit 1", Noclip)
        MenuOption(Outfits, "outfit 2", Noclip)
        MenuOption(Outfits, "outfit 3", Noclip)
        MenuOption(Outfits, "outfit 4", Noclip)
        MenuOption(Outfits, "outfit 5", Noclip)
        MenuOption(Outfits, "outfit 6", Noclip)
        MenuOption(Outfits, "outfit 7", Noclip)
        MenuOption(Outfits, "outfit 8", Noclip)
        MenuOption(Outfits, "outfit 9", Noclip)
		MenuOption(Outfits, "Back", function() CreateMenuStructure(submenuNames[1]) end)
        if left(Outfits) then CreateMenuStructure(submenuNames[1]) end
        redraw(Outfits)
        Wait(0)
    end
    Wait(50)
end

function AIPedsMenu(menu)
    currentMenu = menu
	AIPeds = submenus["AI Peds Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(AIPeds, "Change All to jimmy", Noclip)
        MenuOption(AIPeds, "Change All to Russle", Noclip)
        MenuOption(AIPeds, "Change All to Nerd1", Noclip)
        MenuOption(AIPeds, "Change All to Nerd2", Noclip)
        MenuOption(AIPeds, "Change All to Nerd3", Noclip)
        MenuOption(AIPeds, "Change All to Nerd4", Noclip)
        MenuOption(AIPeds, "Change All to Teacher", Noclip)
        MenuOption(AIPeds, "Change All to random", Noclip)
        MenuOption(AIPeds, "Change All to a prop", Noclip)
        MenuOption(AIPeds, "Change All to a car?", Noclip)
		MenuOption(AIPeds, "Change All Clothing", Noclip)
		MenuOption(AIPeds, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(AIPeds) then CreateMenuStructure(submenuNames[1]) end
        redraw(AIPeds)
        Wait(0)
    end
	Wait(50)	
end

function SpawnMenu(menu)
    currentMenu = menu
	Spawns = submenus["Spawn Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(Spawns, "Peds To Spawn", Noclip)
        MenuOption(Spawns, "Props To Spawn", Noclip)
        MenuOption(Spawns, "Weapons To Spawn", Noclip)
        MenuOption(Spawns, "Objects To Spawn", Noclip)
        MenuOption(Spawns, "Guards To Spawn", Noclip)
        MenuOption(Spawns, "Animals To Spawn", Noclip)
		-- SpawnCar(menu, modelId, pedNeedsWarp, maxVehicles, OwnerVehicle, SetVehicleBig, sizex, sizey, sizez)
        MenuOption(Spawns, "Vehicles To Spawn", SpawnCar, 289, true, 1, true, false, 1, 1, 1)
		MenuOption(Spawns, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(Spawns) then CreateMenuStructure(submenuNames[1]) end
        redraw(Spawns)
        Wait(0)
    end
	Wait(50)	
end

function SkillzMenu(menu)
    currentMenu = menu
	StatMenu = submenus["Status Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(StatMenu, "+ Chemistry Stat", Noclip)
        MenuOption(StatMenu, "- Chemistry Stat", Noclip)
        MenuOption(StatMenu, "+ Art Stat", Noclip)
        MenuOption(StatMenu, "- Art Stat", Noclip)
        MenuOption(StatMenu, "+ Shop Stat", Noclip)
        MenuOption(StatMenu, "- Shop Stat", Noclip)
        MenuOption(StatMenu, "+ Biology Stat", Noclip)
        MenuOption(StatMenu, "- Biology Stat", Noclip)
        MenuOption(StatMenu, "+ Geography Stat", Noclip)
        MenuOption(StatMenu, "- Geography Stat", Noclip)
		MenuOption(StatMenu, "+ English Stat", Noclip)
		MenuOption(StatMenu, "- English Stat", Noclip)
		MenuOption(StatMenu, "+ Gym Stat", Noclip)
		MenuOption(StatMenu, "- Gym Stat", Noclip)
		MenuOption(StatMenu, "+ Photography Stat", Noclip)
		MenuOption(StatMenu, "- Photography Stat", Noclip)
		MenuOption(StatMenu, "+ Music Stat", Noclip)
		MenuOption(StatMenu, "- Music Stat", Noclip)
		MenuOption(StatMenu, "+ Math Stat", Noclip)
		MenuOption(StatMenu, "- Math Stat", Noclip)
		MenuOption(StatMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(StatMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(StatMenu)
        Wait(0)
    end
	Wait(50)	
end

function MoneyMenu(menu)
    currentMenu = menu
	MoneyMenu = submenus["Money Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(MoneyMenu, "Give +10$", AddMoney, 1000)
        MenuOption(MoneyMenu, "Give +100$", AddMoney, 10000)
        MenuOption(MoneyMenu, "Give +1000$", AddMoney, 100000)
        MenuOption(MoneyMenu, "Give +10000$", AddMoney, 1000000)
        MenuOption(MoneyMenu, "Give +100000$", AddMoney, 10000000)
        MenuOption(MoneyMenu, "Give +1000000$", AddMoney, 10000000)
        MenuOption(MoneyMenu, "Take -1000000$", AddMoney, -10000000)
        MenuOption(MoneyMenu, "Take -10000$", AddMoney, -1000000)
        MenuOption(MoneyMenu, "Take -1000$", AddMoney, -100000)
        MenuOption(MoneyMenu, "Take -100$", AddMoney, -10000)
		MenuOption(MoneyMenu, "Take -10$", AddMoney, -1000)
		MenuOption(MoneyMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(MoneyMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(MoneyMenu)
        Wait(0)
    end
	Wait(50)	
end

function WeaponsMenu(menu)
    currentMenu = menu
	WeapMenu = submenus["Weapons Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
		MenuOption(WeapMenu, "Change Projectile", GiveSelfWeapon, 299, 1, "Chem_Accident")	
        MenuOption(WeapMenu, "Give Yard-stick", GiveSelfWeapon, 299, 1, "Chem_Accident")
        MenuOption(WeapMenu, "Give Baseball Bat", GiveSelfWeapon, 300, 1)
        MenuOption(WeapMenu, "Give Cherrybomb", GiveSelfWeapon, 301, 1, "Chem_Accident")
        MenuOption(WeapMenu, "Give Baseball", GiveSelfWeapon, 302, 1, "BoilerSteam")
		MenuOption(WeapMenu, "Give Slingshot", GiveSelfWeapon, 303, 1, "RaceBeam")
        MenuOption(WeapMenu, "Give Marble", GiveSelfWeapon, 304, 1, "FireworksWinner")
        MenuOption(WeapMenu, "Give Brocket Launcher 1", GiveSelfWeapon, 305, 1, "BottleRocketExplosion")
        MenuOption(WeapMenu, "Give Supersling", GiveSelfWeapon, 306, 1, "Confetti")
        MenuOption(WeapMenu, "Give Brocket Launcher 2", GiveSelfWeapon, 307, 1, "BottleRocketExplosion")
		MenuOption(WeapMenu, "Give Brocket Launcher 3", GiveSelfWeapon, 308, 1, "BottleRocketExplosion")
        MenuOption(WeapMenu, "Give StinkBomb", GiveSelfWeapon, 309, 1, "Chem_Accident")		
        MenuOption(WeapMenu, "Give Apple", GiveSelfWeapon, 310, 1, "MudImpact")
		MenuOption(WeapMenu, "Give Brick", GiveSelfWeapon, 311, 1, "Confetti")
		MenuOption(WeapMenu, "Give EggProj", GiveSelfWeapon, 312, 1, "Confetti")
		MenuOption(WeapMenu, "Give Snowball", GiveSelfWeapon, 313, 1, "SnowPoof")
		MenuOption(WeapMenu, "Give Yard-stick 2", GiveSelfWeapon, 299, 1, "Confetti")
		MenuOption(WeapMenu, "Give Lid", GiveSelfWeapon, 315, 1, "Confetti")		
		MenuOption(WeapMenu, "Give Potato", GiveSelfWeapon, 316, 1, "Confetti")
		MenuOption(WeapMenu, "Give Broken Bat", GiveSelfWeapon, 317, 1, "Confetti")	
		MenuOption(WeapMenu, "Give Newsroll", GiveSelfWeapon, 320, 1, "AcidPool")
		MenuOption(WeapMenu, "Give Spraycan", GiveSelfWeapon, 321, 1, "WeedMelee")
		MenuOption(WeapMenu, "Give SuperMarble", GiveSelfWeapon, 322, 1, "WeedKiller")
		MenuOption(WeapMenu, "Give 2x4", GiveSelfWeapon, 323, 1, "WeaponSmash")
		MenuOption(WeapMenu, "Give Sledgehammer", GiveSelfWeapon, 324, 1, "WB_Splash")
		MenuOption(WeapMenu, "Give RBandBall", GiveSelfWeapon, 325, 1, "WBWet")
		MenuOption(WeapMenu, "Give fireexting", GiveSelfWeapon, 326, 1, "WaterSpray")
		MenuOption(WeapMenu, "Give BagBottle", GiveSelfWeapon, 327, 1, "WaterShower")
		MenuOption(WeapMenu, "Give Camera", GiveSelfWeapon, 328, 1, "WaterFountainDirty")
		MenuOption(WeapMenu, "Give Soccerball^", GiveSelfWeapon, 329, 1, "WaterFaucet")
		MenuOption(WeapMenu, "Give Snowball 2", GiveSelfWeapon, 330, 1, "waterfallmistSM")
		MenuOption(WeapMenu, "Give Wftball", GiveSelfWeapon, 331, 1, "waterfallmistSM")
		MenuOption(WeapMenu, "Give Mallet", GiveSelfWeapon, 332, 1, "RaceWaypoint")	
		MenuOption(WeapMenu, "Give Frisbee", GiveSelfWeapon, 335, 1, "BUMP01")
		MenuOption(WeapMenu, "Give Broken Cricket", GiveSelfWeapon, 336, 1, "waterfallmist") -- lets add a fart mod where the player gets like a jump boost from farting
		MenuOption(WeapMenu, "Give Chemical", GiveSelfWeapon, 337, 1, "WaterCaustics") -- i should see if we can play a video in during game? 0x9F470C
		MenuOption(WeapMenu, "Give Glass Plate", GiveSelfWeapon, 338, 1, "WaterCausticsParent")
		MenuOption(WeapMenu, "Give Cigarette", GiveSelfWeapon, 339, 1, "WallSmash") -- maybe add another argument for playing an animation on weapon spawn
		MenuOption(WeapMenu, "Give Pompom", GiveSelfWeapon, 341, 1, "VaseImpact")
		MenuOption(WeapMenu, "Give Full-ass-pipe", GiveSelfWeapon, 342, 1, "TVFlickerLight")
		MenuOption(WeapMenu, "Give Grabage Pick", GiveSelfWeapon, 343, 1, "TreadWater2")
		MenuOption(WeapMenu, "Give Plantvase 0", GiveSelfWeapon, 345, 1, "StepShallowWater")
		MenuOption(WeapMenu, "Give Deadrat", GiveSelfWeapon, 346, 1, "ToiletExplode")
		MenuOption(WeapMenu, "Give Cafa Tray", GiveSelfWeapon, 348, 1, "TrashBinShove")
		MenuOption(WeapMenu, "Give BagMrbls", GiveSelfWeapon, 349, 1, "TorchImpact")
		MenuOption(WeapMenu, "Give Flask", GiveSelfWeapon, 350, 1, "TorchFlame")
		MenuOption(WeapMenu, "Give chem_stir", GiveSelfWeapon, 351, 1, "ThrusterSmall")
		MenuOption(WeapMenu, "Give Eyedrop", GiveSelfWeapon, 352, 1, "TacksThrown")
		MenuOption(WeapMenu, "Give Plantvase 1", GiveSelfWeapon, 353, 1, "SwimRipplesStrong")
		MenuOption(WeapMenu, "Give Plantvase 2", GiveSelfWeapon, 354, 1, "SwimRipples")
		MenuOption(WeapMenu, "Give Dec Plate", GiveSelfWeapon, 355, 1, "StinkLockerOpen")
		MenuOption(WeapMenu, "Give Plantvase 3", GiveSelfWeapon, 356, 1, "StinkLockerClosed")		
		MenuOption(WeapMenu, "Give Cricket 2", GiveSelfWeapon, 357, 1, "StinkBomb")	
		MenuOption(WeapMenu, "Give Banana", GiveSelfWeapon, 358, 1, "steam_pipe")	
		MenuOption(WeapMenu, "Give Flowerbund", GiveSelfWeapon, 359, 1, "Confetti")	
		MenuOption(WeapMenu, "Give Psheild", GiveSelfWeapon, 360, 1, "Confetti")	
		MenuOption(WeapMenu, "Give Teddy bear", GiveSelfWeapon, 363, 1, "Confetti")	
		MenuOption(WeapMenu, "Give Snow Shwl/Freeze", GiveSelfWeapon, 364, 1, "Confetti")		
		MenuOption(WeapMenu, "Give Kick me Sign", GiveSelfWeapon, 372, 1, "Confetti")		
		MenuOption(WeapMenu, "Give J Broom", GiveSelfWeapon, 377, 1, "Confetti")	
		MenuOption(WeapMenu, "Give Ani Footy", GiveSelfWeapon, 378, 1, "Confetti")		
		MenuOption(WeapMenu, "Give Basketball", GiveSelfWeapon, 381, 1, "Confetti")	
		MenuOption(WeapMenu, "Give waterballoon", GiveSelfWeapon, 383, 1, "Confetti")	
		MenuOption(WeapMenu, "Give wtr pipe D", GiveSelfWeapon, 384, 1, "Confetti")
		MenuOption(WeapMenu, "Give Trophy", GiveSelfWeapon, 385, 1, "Confetti")
		MenuOption(WeapMenu, "Give Ch Shield A", GiveSelfWeapon, 387, 1, "Confetti")
		MenuOption(WeapMenu, "Give Ch Shield B", GiveSelfWeapon, 388, 1, "Confetti")
		MenuOption(WeapMenu, "Give Ch Shield C", GiveSelfWeapon, 389, 1, "Confetti")
		MenuOption(WeapMenu, "Give WHatVase", GiveSelfWeapon, 390, 1, "Confetti")
		MenuOption(WeapMenu, "Give BBGun/Freeze", GiveSelfWeapon, 391, 1, "Confetti")
		MenuOption(WeapMenu, "Give Itching Powder", GiveSelfWeapon, 394, 1, "Confetti")
		MenuOption(WeapMenu, "Give P Gun", GiveSelfWeapon, 395, 1, "Confetti")
		MenuOption(WeapMenu, "Give Super Brocket", GiveSelfWeapon, 396, 1, "BottleRocketExplosion")
		MenuOption(WeapMenu, "Give Fountain", GiveSelfWeapon, 397, 1, "Confetti")
		MenuOption(WeapMenu, "Give Poobag", GiveSelfWeapon, 399, 1, "Confetti")
		MenuOption(WeapMenu, "Give WFt Bomb", GiveSelfWeapon, 400, 1, "Confetti")
		MenuOption(WeapMenu, "Give Wtr Pipe c", GiveSelfWeapon, 401, 1, "Confetti")
		MenuOption(WeapMenu, "Give Wtr Pipe b", GiveSelfWeapon, 402, 1, "Confetti")
		MenuOption(WeapMenu, "Give TP Roll", GiveSelfWeapon, 403, 1, "Confetti")
		MenuOption(WeapMenu, "Give Umbrella", GiveSelfWeapon, 404, 1, "Confetti")
		MenuOption(WeapMenu, "Give NerdBooks", GiveSelfWeapon, 405, 1, "Confetti")
		MenuOption(WeapMenu, "Give Devil Fork", GiveSelfWeapon, 409, 1, "Confetti")
		MenuOption(WeapMenu, "Give Pinky Wand", GiveSelfWeapon, 410, 1, "Confetti")
		MenuOption(WeapMenu, "Give SS Whip", GiveSelfWeapon, 411, 1, "Confetti")
		MenuOption(WeapMenu, "Give Bolt Cutters", GiveSelfWeapon, 412, 1, "Confetti")
		MenuOption(WeapMenu, "Give Nerd Books B", GiveSelfWeapon, 413, 1, "Confetti")
		MenuOption(WeapMenu, "Give Nerd Books C", GiveSelfWeapon, 414, 1, "Confetti")
		MenuOption(WeapMenu, "Give Nerd Books D", GiveSelfWeapon, 415, 1, "Confetti")
		MenuOption(WeapMenu, "Give Nerd Books E", GiveSelfWeapon, 416, 1, "Confetti")
		MenuOption(WeapMenu, "Give Detonator", GiveSelfWeapon, 417, 1, "Confetti")
		MenuOption(WeapMenu, "Give Leadpipe", GiveSelfWeapon, 418, 1, "Confetti")
		MenuOption(WeapMenu, "Give Flashlight", GiveSelfWeapon, 420, 1, "Confetti") 
		MenuOption(WeapMenu, "Give J Broom DMG", GiveSelfWeapon, 422, 1, "Confetti")
		MenuOption(WeapMenu, "Give Gas can", GiveSelfWeapon, 425, 1, "Confetti")
		MenuOption(WeapMenu, "Give Dig Cam", GiveSelfWeapon, 426, 1, "Confetti")
		MenuOption(WeapMenu, "Give Diary", GiveSelfWeapon, 432, 1, "Confetti")
		MenuOption(WeapMenu, "Give Stwins Bad", GiveSelfWeapon, 433, 1, "Confetti") -- looks like something cod would call a default weapon or a test weapon
		MenuOption(WeapMenu, "Give 2x4 Dmg", GiveSelfWeapon, 435, 1, "Confetti")
		MenuOption(WeapMenu, "Give SK8 Board", GiveSelfWeapon, 437, 1, "Confetti")
		MenuOption(WeapMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(WeapMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(WeapMenu)
        Wait(0)
    end
	Wait(50)	
end

function FunMods(menu)
    currentMenu = menu
	funModsM = submenus["Fun Mods"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(funModsM, "Force Restart", Noclip)
        MenuOption(funModsM, "Force End", Noclip)
        MenuOption(funModsM, "Force Quit", Noclip)
        MenuOption(funModsM, "Super Jump", Noclip)
        MenuOption(funModsM, "Lower Gravity?", Noclip) --- ummmmmmmmmmmmmmm this one a bit odd and i don't even think it's possible
        MenuOption(funModsM, "Super Speed", Noclip)
        MenuOption(funModsM, "Remove Blocking Barriers", Noclip)
        MenuOption(funModsM, "Fast Simulation", Noclip)
        MenuOption(funModsM, "Slow Simulation", Noclip)
        MenuOption(funModsM, "Normal Simulation", Noclip)		
        MenuOption(funModsM, "Fog?", Noclip)
		MenuOption(funModsM, "Rain Peds From Sky", Noclip)
		MenuOption(funModsM, "Revive/Kill", Noclip)		
		MenuOption(funModsM, "Anti-Pause", Noclip) -- always throw in a fuck with yeah funtion, basically trolling....
		MenuOption(funModsM, "Custom Knockout Text", Noclip) -- death text
		MenuOption(funModsM, "Custom Ped Kill Text", Noclip) -- kill text
		MenuOption(funModsM, "Punch Distance", Noclip) -- auto aim?
		MenuOption(funModsM, "Floating Bodies", Noclip) -- force all peds to randomly float up.... when they knockout.... is possible...
		MenuOption(funModsM, "No Camping School Bullies", Noclip)
		MenuOption(funModsM, "Ped BJ for jummy", Noclip)
		MenuOption(funModsM, "Tether Ped to jummy", Noclip)
		MenuOption(funModsM, "Kill all peds", Noclip)
		MenuOption(funModsM, "Earthquake", Noclip) -- is possible/but i don't know if i wanna make this as somethings that should be simple just are not on this game.
		MenuOption(funModsM, "Auto Dropshot", Noclip)
		MenuOption(funModsM, "Flyable UFO", Noclip) -- find a prop we can use or try to import one then tether jimmy to it
		MenuOption(funModsM, "Fake Carepackage", Noclip) -- spawn a crate, then add a trigger if possible with random items that spawn in create
		MenuOption(funModsM, "Fake Virus", Noclip) 
		MenuOption(funModsM, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(funModsM) then CreateMenuStructure(submenuNames[1]) end
        redraw(funModsM)
        Wait(0)
    end
	Wait(50)	
end

function SelfMsgMenu(menu)
    currentMenu = menu
	MsgMenu = submenus["Self Msg"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(MsgMenu, "Check My yt out", iprintln, "Jaycoder") -- shold switch this to a real draw text, but iprintln works for now
        MenuOption(MsgMenu, "Check My insta out", iprintln, "Jaycoderr")
        MenuOption(MsgMenu, "Yo, What up hoe", iprintln, "Playing with your cheeks")
        MenuOption(MsgMenu, "1+2", iprintln, "= Me & You")
        MenuOption(MsgMenu, "I eat ass", iprintln, "I eat ass bitchhhh")
        MenuOption(MsgMenu, "[{}] pussy squirt", iprintln, "[{}] ~ ~ ~ ~")
        MenuOption(MsgMenu, "8====>", iprintln, "nothing like a goth chick and 8========>") -- i'mma go kill myself now.
        MenuOption(MsgMenu, "LMAO", iprintln, "BRUHHHHH")
        MenuOption(MsgMenu, "Dont click me", iprintln, "I told you not too, you now have aids") -- gunna add a function to kill player for no reason after clicking this
        MenuOption(MsgMenu, "BO3 WAS A GOOD COD", iprintln, "prove me wrong...")
		MenuOption(MsgMenu, "Smoke Weed Everyday", iprintln, "SMOKE WEED EVERYDAY")	
		MenuOption(MsgMenu, "Gargle my balls", iprintln, "Gargle these balls in the depth of your throat!!! hoe")	
		MenuOption(MsgMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(MsgMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(MsgMenu)
        Wait(0)
    end
	Wait(50)	
end

function CloneMenu(menu)
    currentMenu = menu
	Clones = submenus["Clone Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(Clones, "Clone Jimmy", Noclip)
        MenuOption(Clones, "Make clone follow", Noclip)
        MenuOption(Clones, "Move clone forward", Noclip)
        MenuOption(Clones, "Move Clone backwards", Noclip)
        MenuOption(Clones, "Move Clone left", Noclip)
        MenuOption(Clones, "Move Clone right", Noclip)
        MenuOption(Clones, "Change Clone Model", Noclip)
        MenuOption(Clones, "Kill/Revive Clone", Noclip)
        MenuOption(Clones, "Give Clone Weapon", Noclip)
		MenuOption(Clones, "Delete Clone", Noclip)
        MenuOption(Clones, "Clone Say", iprintln, "GO FUCK YOURSELF, and let me stand here.")
		MenuOption(Clones, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(Clones) then CreateMenuStructure(submenuNames[1]) end
        redraw(Clones)
        Wait(0)
    end
	Wait(50)	
end

function TPMenu(menu)
    currentMenu = menu
	TPMenu = submenus["Teleport Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(TPMenu, "Print Origin", iprintlnOrigin)
        MenuOption(TPMenu, "TP 10.ft North", TP_10_north)
        MenuOption(TPMenu, "TP 10.ft South", TP_10_south)
        MenuOption(TPMenu, "TP 10.ft West", TP_10_west)
        MenuOption(TPMenu, "TP 10.ft left", TP_10_left)
        MenuOption(TPMenu, "TP 10.ft Up", TP_10_up)
        MenuOption(TPMenu, "TP 10.ft Down", TP_10_down)
        MenuOption(TPMenu, "POI1", Noclip)
        MenuOption(TPMenu, "POI2", Noclip)
        MenuOption(TPMenu, "POI3", Noclip)
		MenuOption(TPMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(TPMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(TPMenu)
        Wait(0)
    end
	Wait(50)	
end

function WeatherMenu(menu)
    currentMenu = menu
	WeatherMenu = submenus["Teleport Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(WeatherMenu, "Sunny", Noclip)
        MenuOption(WeatherMenu, "Snowy", Noclip)
        MenuOption(WeatherMenu, "Cloudy", Noclip)
        MenuOption(WeatherMenu, "Stormy", Noclip)
        MenuOption(WeatherMenu, "Raining", Noclip)
        MenuOption(WeatherMenu, "Clear", Noclip)
        MenuOption(WeatherMenu, "Foggy", Noclip)
        MenuOption(WeatherMenu, "Alien", Noclip)
        MenuOption(WeatherMenu, "Trippy", Noclip)
        MenuOption(WeatherMenu, "Sun too close", Noclip)
		MenuOption(WeatherMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(WeatherMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(WeatherMenu)
        Wait(0)
    end
	Wait(50)	
end

function WorldMenu(menu)
    currentMenu = menu
	WorldMenu = submenus["World Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(WorldMenu, "Weather", Noclip)
        MenuOption(WorldMenu, "Time Of Day", Noclip)
        MenuOption(WorldMenu, "Rain Type", Noclip)
        MenuOption(WorldMenu, "Shadows", Noclip)
        MenuOption(WorldMenu, "Ped Count", Noclip)
        MenuOption(WorldMenu, "Vehicle Count", Noclip)
        MenuOption(WorldMenu, "Sun Color", Noclip)
        MenuOption(WorldMenu, "Ground Color", Noclip)
        MenuOption(WorldMenu, "Skydome Test", Noclip)
        MenuOption(WorldMenu, "Change all Vehicles", Noclip)
		MenuOption(WorldMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(WorldMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(WorldMenu)
        Wait(0)
    end
	Wait(50)	
end

function ForgeMenu(menu)
    currentMenu = menu
	forgeMenuX = submenus["Forge Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(forgeMenuX, "Toggle Simple Forge", Noclip)
        MenuOption(forgeMenuX, "Toggle Advance Forge", Noclip)
		MenuOption(forgeMenuX, "Toggle TestCube", Noclip)
		MenuOption(forgeMenuX, "Toggle TestSphere", Noclip)
        MenuOption(forgeMenuX, "Create wall", Noclip)
        MenuOption(forgeMenuX, "Create floor", Noclip)
        MenuOption(forgeMenuX, "Create ceiling", Noclip)
        MenuOption(forgeMenuX, "Create Room", Noclip)
        MenuOption(forgeMenuX, "Create Skybase", Noclip)
        MenuOption(forgeMenuX, "Create Stairs", Noclip)
        MenuOption(forgeMenuX, "Create Elevator", Noclip)
        MenuOption(forgeMenuX, "Create Zipline", Noclip)
		MenuOption(forgeMenuX, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(forgeMenuX) then CreateMenuStructure(submenuNames[1]) end
        redraw(forgeMenuX)
        Wait(0)
    end
	Wait(50)	
end

function VisionsMenu(menu)
    currentMenu = menu
	VisiMenu = submenus["Visions Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(VisiMenu, "Red tint", Noclip)
        MenuOption(VisiMenu, "white tint", Noclip)
        MenuOption(VisiMenu, "green tint", Noclip)
        MenuOption(VisiMenu, "pink tint", Noclip)
        MenuOption(VisiMenu, "black tint", Noclip)
        MenuOption(VisiMenu, "blue tint", Noclip)
        MenuOption(VisiMenu, "white tint", Noclip)
        MenuOption(VisiMenu, "Acid/Lsd", Noclip)
        MenuOption(VisiMenu, "Poison Gif Sheet", Noclip)
        MenuOption(VisiMenu, "Water Gif Sheet", Noclip)
		MenuOption(VisiMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(VisiMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(VisiMenu)
        Wait(0)
    end
	Wait(50)	
end

function SoundsMenu(menu)
    currentMenu = menu
	Sounds = submenus["Sounds Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(Sounds, "Sound test 0", Noclip)
        MenuOption(Sounds, "Sound test 1", Noclip)
        MenuOption(Sounds, "Sound test 2", Noclip)
        MenuOption(Sounds, "Sound test 3", Noclip)
        MenuOption(Sounds, "Sound test 4", Noclip)
        MenuOption(Sounds, "Sound test 5", Noclip)
        MenuOption(Sounds, "Sound test 6", Noclip)
        MenuOption(Sounds, "Sound test 7", Noclip)
        MenuOption(Sounds, "Sound test 8", Noclip)
        MenuOption(Sounds, "Sound test 9", Noclip)
		MenuOption(Sounds, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(Sounds) then CreateMenuStructure(submenuNames[1]) end
        redraw(Sounds)
        Wait(0)
    end
	Wait(50)	
end

function ThemesMenu(menu)
    currentMenu = menu
	ThemeMenu = submenus["Themes Menu"]
    while currentMenu == menu and currentMenu.alive do
        -- Add options
        MenuOption(ThemeMenu, "Original Design", SetMenuDesign, "menu_background", false)
        MenuOption(ThemeMenu, "Menu Design 1", StartMenuGif, "dog_", 4, 150)
        MenuOption(ThemeMenu, "Menu Design 2", SetMenuDesign, "whatrutalkingabout", false)
        MenuOption(ThemeMenu, "Menu Design 3", SetMenuDesign, "whatrutalkwingabout", false)
        MenuOption(ThemeMenu, "Menu Design 4", SetMenuDesign, "whatrutalkingabout", false)
        MenuOption(ThemeMenu, "Menu Design 5", SetMenuDesign, "whatrutalkingabout", false)
        MenuOption(ThemeMenu, "Menu Design 6", SetMenuDesign, "whatrutalkingabout", false)
        MenuOption(ThemeMenu, "Menu Design 7", SetMenuDesign, "whatrutalkingabout", false)
        MenuOption(ThemeMenu, "Menu Design 8", SetMenuDesign, "whatrutalkingabout", false)
        MenuOption(ThemeMenu, "Menu Design 9", SetMenuDesign, "whatrutalkingabout", false)
		MenuOption(ThemeMenu, "Back", function() CreateMenuStructure(submenuNames[1]) end)
		if left(ThemeMenu) then CreateMenuStructure(submenuNames[1]) end
        redraw(ThemeMenu)
        Wait(0)
    end
	Wait(50)	
end

function ScrollbarEditor(menu)
    currentMenu = menu
    ScrollEdit = submenus["Scrollbar Editor"]

    while currentMenu == menu and currentMenu.alive do
        -- Add color options using closures to pass the colorName correctly
        MenuOption(ScrollEdit, "Maroon", function() SetScrollColor(160,0,25,255, "Maroon") end)
        MenuOption(ScrollEdit, "Red", function() SetScrollColor(255,0,0,255, "Red") end)
        MenuOption(ScrollEdit, "DarkRed", function() SetScrollColor(139,0,0,255, "DarkRed") end)
        MenuOption(ScrollEdit, "LightCoral", function() SetScrollColor(240,128,128,255, "LightCoral") end)
        MenuOption(ScrollEdit, "Pink", function() SetScrollColor(255,192,203,255, "Pink") end)
        MenuOption(ScrollEdit, "HotPink", function() SetScrollColor(255,105,180,255, "HotPink") end)
        MenuOption(ScrollEdit, "DeepPink", function() SetScrollColor(255,20,147,255,"DeepPink") end)
        MenuOption(ScrollEdit, "Orange", function() SetScrollColor(255,165,0,255, "Orange") end)
        MenuOption(ScrollEdit, "DarkOrange", function() SetScrollColor(255,140,0,255, "DarkOrange") end)
        MenuOption(ScrollEdit, "Coral", function() SetScrollColor(255,127,80,255,"Coral") end)
        MenuOption(ScrollEdit, "Yellow", function() SetScrollColor(255,255,0,255,"Yellow") end)
        MenuOption(ScrollEdit, "Gold", function() SetScrollColor(255,215,0,255,"Gold") end)
        MenuOption(ScrollEdit, "LightYellow", function() SetScrollColor(255,255,224,255,"LightYellow") end)
        MenuOption(ScrollEdit, "Green", function() SetScrollColor(0,128,0,255,"Green") end)
        MenuOption(ScrollEdit, "Lime", function() SetScrollColor(0,255,0,255,"Lime") end)
        MenuOption(ScrollEdit, "LimeGreen", function() SetScrollColor(50,205,50,255,"LimeGreen") end)
        MenuOption(ScrollEdit, "DarkGreen", function() SetScrollColor(0,100,0,255,"DarkGreen") end)
        MenuOption(ScrollEdit, "Blue", function() SetScrollColor(0,0,255,255,"Blue") end)
        MenuOption(ScrollEdit, "DarkBlue", function() SetScrollColor(0,0,139,255,"DarkBlue") end)
        MenuOption(ScrollEdit, "LightBlue", function() SetScrollColor(173,216,230,255,"LightBlue") end)
        MenuOption(ScrollEdit, "Cyan", function() SetScrollColor(0,255,255,255,"Cyan") end)
        MenuOption(ScrollEdit, "Teal", function() SetScrollColor(0,128,128,255,"Teal") end)
        MenuOption(ScrollEdit, "Purple", function() SetScrollColor(128,0,128,255,"Purple") end)
        MenuOption(ScrollEdit, "Magenta", function() SetScrollColor(255,0,255,255,"Magenta") end)
        MenuOption(ScrollEdit, "Violet", function() SetScrollColor(238,130,238,255,"Violet") end)
        MenuOption(ScrollEdit, "Indigo", function() SetScrollColor(75,0,130,255,"Indigo") end)
        MenuOption(ScrollEdit, "Brown", function() SetScrollColor(165,42,42,255,"Brown") end)
        MenuOption(ScrollEdit, "SaddleBrown", function() SetScrollColor(139,69,19,255,"SaddleBrown") end)
        MenuOption(ScrollEdit, "Tan", function() SetScrollColor(210,180,140,255,"Tan") end)
        MenuOption(ScrollEdit, "Beige", function() SetScrollColor(245,245,220,255,"Beige") end)
        MenuOption(ScrollEdit, "Gray", function() SetScrollColor(128,128,128,255,"Gray") end)
        MenuOption(ScrollEdit, "DarkGray", function() SetScrollColor(64,64,64,255,"DarkGray") end)
        MenuOption(ScrollEdit, "LightGray", function() SetScrollColor(211,211,211,255,"LightGray") end)
        MenuOption(ScrollEdit, "Black", function() SetScrollColor(0,0,0,255,"Black") end)
        MenuOption(ScrollEdit, "White", function() SetScrollColor(255,255,255,255,"White") end)

        -- Back button
        MenuOption(ScrollEdit, "Back", function() CreateMenuStructure(submenuNames[1]) end)

        if left(ScrollEdit) then CreateMenuStructure(submenuNames[1]) end
        redraw(ScrollEdit)
        Wait(0)
    end
    Wait(50)
end

function SetScrollColor(r,g,b,a,colorName)
    _G.defualtScrollerColor = {r,g,b,a}  -- fixed typo
    iprintln("Scrollbar Set To: " .. colorName)
end

function AllPedsMenu(menu)
    currentMenu = menu
	AllPeds = submenus["All Peds Menu"]
    while currentMenu == menu and currentMenu.alive do
        MenuOption(AllPeds, "Give TrumpStimulus", Noclip)
        MenuOption(AllPeds, "All Peds Are Jimmy", Noclip)
        MenuOption(AllPeds, "All Peds TP to me", Noclip)
        MenuOption(AllPeds, "All Peds TP to neverland", Noclip)
        MenuOption(AllPeds, "All Peds TP to space", Noclip)
        MenuOption(AllPeds, "All Peds Clothing", Noclip)
        MenuOption(AllPeds, "Knockout All Peds", Noclip)
        MenuOption(AllPeds, "All Peds Are Teachers", Noclip)
        MenuOption(AllPeds, "All Peds Are Bulldogs", Noclip)
        MenuOption(AllPeds, "All Peds Are Extra Angry", Noclip)
		MenuOption(AllPeds, "Back", CreateMenuStructure, submenuNames[1])
		if left(AllPeds) then CreateMenuStructure(submenuNames[1]) end
        redraw(AllPeds)
        Wait(0)
    end
	Wait(50)	
end