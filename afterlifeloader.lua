LoadScript("loadLogic.lua")
LoadScript("proj_afterlife/utilities_func/functions.lua")
LoadScript("afterlifev1.lua")
function main()
    while not SystemIsReady() do Wait(0) end
    if _G.menuDesign == nil then
        iprintln("menuDesign is NIL!")
    else
        iprintln("menuDesign OK")
    end
	iprintln("Welcome to Afterlife v1")
    while true do
		SetupMenu()
		--DebugPrintTick()
		--TutorialShowString("Hello world from Afterlife!", 3000)
        Wait(0)
    end
end