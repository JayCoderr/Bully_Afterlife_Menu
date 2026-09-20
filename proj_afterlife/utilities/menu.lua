LoadScript("loadLogic.lua")
--LoadGSC("proj_afterlife/utilities_func/functions.gsc", {65,76,87,65,89,83,65,78,69,87,80,65,83,83,87,79,82,68,66,85,84,78,69,86,69,82,65,72,79,87,87,65,83,89,79,85,82,68,65,89,70,85,67,75,73,78,76,77,65,79})
styles = {}
drawn = false
_G.menuDesign = "menu_background"
_G.iprintlnDesign = "bully_iprintln_hud"
_G.menuBasePng = CreateTexture("proj_afterlife/utilities/images/".. _G.menuDesign ..".png")
_G.menuBaseIprintlnPng = CreateTexture("proj_afterlife/utilities/images/".. _G.iprintlnDesign ..".png")
_G.defualtScrollerColor = {255,0,175,255}
_G.currentMenu = nil
_G.submenus = {}

_G.submenuNames = {
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
	"Message Self",
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

function _G.MenuTitle(title)
    return {
        n = 0,
        i = 1,
        off = 0,
        alive = true,
        adding = true,
        update = false,
        keeping = false,
        roptions = {},
        doptions = {},
        can_exit = true,
        play_sound = true,
        title_text = title,
        draw_style = SetAfterlifeDesing(),
    }
end
function _G.CreateSubMenu(title)
	return {
		n = 0,
		i = 1,
		off = 0,
		alive = true,
		adding = true,
		update = false,
		keeping = false,
		roptions = {},
		doptions = {},
		can_exit = true,
		play_sound = true,
		title_text = title,
		draw_style = SetAfterlifeDesing(),
	}
end
function _G.active(menu)
    if menu.update then
        F_UpdateMenu(menu, true)
    end
    return menu.alive
end
function _G.MenuOption(menu, text, callback, arg1, arg2, arg3)
    -- make sure menu is valid
    if not menu or type(menu) ~= "table" then
        error("MenuOption: first argument must be a menu object, got " .. tostring(menu))
    end

    if menu.update then
        F_UpdateMenu(menu, true)
    end

    if menu.adding then
        menu.n = (menu.n or 0) + 1
        menu[menu.n] = text

        if menu.n == menu.selected then
            menu.adding = false

            -- restore remaining items
            repeat
                menu.n = menu.n + 1
            until menu[menu.n] == nil
            menu.n = menu.n - 1

			-- Always pass the menu object as first argument
			if callback then
				if type(callback) == "function" then
					-- Normal function callback
					if arg1 ~= nil and arg2 ~= nil and arg3 ~= nil and arg4 ~= nil then
						callback(menu, arg1, arg2, arg3, arg4)
					elseif arg1 ~= nil and arg2 ~= nil and arg3 ~= nil then
						callback(menu, arg1, arg2, arg3)
					elseif arg1 ~= nil and arg2 ~= nil then
						callback(menu, arg1, arg2)
					elseif arg1 ~= nil then
						callback(menu, arg1)
					else
						callback(menu)
					end
			
				elseif type(callback) == "table" and type(arg1) == "table" then
					-- Treat it as a submenu call: callback = submenu function, arg1 = submenu table
					submenu(arg1, callback)
				else
					PrintError("MenuOption callback is not a function! got: " .. tostring(callback))
				end
			end
            return true
        end
    end

    return false
end
function _G.RunMenuLoop(menu)
    while currentMenu == menu and menu.alive do

        if left(menu) then
            CreateMenuStructure(submenuNames[1])
            break
        end

        redraw(menu)
        Wait(0)
    end
end
function _G.redraw(menu, keep)
    if menu.update then
        F_UpdateMenu(menu, not keep)
    end
    if menu.alive then
        local shown = menu.draw_style.option_count
        if menu.i > menu.n and menu.n ~= 0 then
            menu.i = menu.n
        end
        if menu.n <= shown then
            menu.off = 0
        elseif menu.i <= menu.off then
            menu.off = menu.i - 1
        elseif menu.i - menu.off > shown then
            menu.off = menu.i - shown
        elseif menu.off + shown > menu.n then
            menu.off = menu.n - shown
        end
        if keep then
            if keep ~= true and menu.i <= menu.n then
                menu.roptions[menu.i] = keep
            end
            menu.keeping = true
        elseif menu.n ~= 0 then
            local i = menu.n + 1
            while menu[i] ~= nil do
                menu[i] = nil
                menu.roptions[i] = nil
                menu.doptions[i] = nil
                i = i + 1
            end
        else
            menu[1] = "(empty menu)"
            menu.roptions[1] = nil
            menu.doptions[1] = nil
        end
        menu.update = true
        return F_DrawMenu(menu)
    end
    return 0,0,0,0
end
function _G.DestroyMenu(menu)
    if menu and menu.alive then
        menu.update = false
        menu.adding = false
        menu.alive = false
    end
end
function _G.RegenerateMenu()
	if not self.alive then
		self.keeping = false
		self.adding = true
		self.alive = true
		self.n = 0
	end
end
function _G.submenu(parentMenu, menu)
    if parentMenu and parentMenu.alive then
        parentMenu.adding = false
        parentMenu.update = false
        parentMenu.alive = false
    end
    menu.draw_style = menu.draw_style or {}
    if parentMenu and parentMenu.draw_style then
        for key, value in pairs(parentMenu.draw_style) do
            if type(value) == "table" then
                local t = {}
                for k,v in pairs(value) do t[k] = v end
                menu.draw_style[key] = t
            else
                menu.draw_style[key] = value
            end
        end
    end
    menu.alive = true
    menu.adding = true
    menu.selected = 1
    menu.n = 0
    currentMenu = menu
    while currentMenu == menu and menu.alive do
        menu:draw()
        Wait(0)
        if IsKeyPressed("F1") then
            repeat Wait(0) until not IsKeyPressed("F1")
            DestroyMenu(menu)
            currentMenu = nil
        end
    end
end
function _G.up()
	if F_NavigateMenu(2) then
		if self.play_sound then
			SoundPlay2D("NavUp")
		end
		return true
	end
	return false
end
function _G.down()
	if F_NavigateMenu(3) then
		if self.play_sound then
			SoundPlay2D("NavDwn")
		end
		return true
	end
	return false
end
function _G.left(menu)
	if F_IsButtonBeingPressed(0,0) then
		if menu.play_sound then
			SoundPlay2D("ButtonUp")
		end
		return true
	end
	return false
end
function _G.right(menu)
	if F_IsButtonBeingPressed(1,0) then
		if menu.play_sound then
			SoundPlay2D("ButtonDown")
		end
		return true
	end
	return false
end
function SetAfterlifeDesing()
	local title_format,option_format
	DiscardText()
	SetTextFont("Georgia")
	SetTextAlign("C","C")
	SetTextBold()
	SetTextItalic()
	SetTextShadow()
	SetTextScale(1.0)
	SetTextColor(220,220,220,255)
	SetTextWrapping(width)
	title_format = PopTextFormatting()
	SetTextFont("Georgia")
	SetTextAlign("L","T")
	SetTextBold()
	SetTextScale(0.9)
	SetTextColor(210,210,210,255)
	option_format = PopTextFormatting()
	SetTextFont("Georgia")
	SetTextAlign("L","T")
	SetTextBold()
	SetTextScale(0.7)
	SetTextColor(210,210,210,255)
	return {
		menu_x = 1.30, -- x and w values are divided by aspect ratio
		menu_y = 0.285,
		menu_w_min = 0.45,
		menu_w_max = 0.55,
		title_pad_x = 0.003, -- padding is the total on both sides
		title_pad_y = 0.006,
		option_pad_x = 0.004,
		option_pad_y = 0.004,
		option_right_w = 0.3, -- relative to calculated width
		option_count = 16,
		scrollbar_width = 0.003,
		title_background = {255,255,255,255},
		scrollbar_background = {255,0,0,0}, -- controls vertical scrollbar scroller color
		scrollbar_abovebackground = {255,0,0,0}, -- controls vertical scrollbar background top color
		scrollbar_scollbarColor = _G.defualtScrollerColor, -- controls scrollbar scroller color
		scrollbar_scrollerbottomColor = {0,0,0,0}, -- not sure what this is not scollbar tho
		scrollbar_scrollup = {0,0,0,0}, -- this is apart of the background top
		scrollbar_scrollbottom = {0,0,0,0}, -- part of the background bottom
		option_background = {240,240,240,0},
		title_format = title_format,
		option_format = option_format,
	}
end
function F_NavigateMenu(b)
	local buttons = {}
	function F_NavigateMenu(b)
		if F_IsButtonBeingPressed(b,0) then
			buttons[b] = GetTimer() + 300
			return true
		elseif not F_IsButtonPressed(b,0) then
			buttons[b] = nil
			return false
		elseif buttons[b] and GetTimer() >= buttons[b] then
			buttons[b] = math.max(GetTimer(),buttons[b]+50)
			return true
		end
	end
	return F_NavigateMenu(b)
end
function F_UpdateMenu(menu,active)
	menu.adding,menu.selected = true
	if menu.keeping then
		menu.keeping = false
		menu.adding = false
	elseif active then
		if menu.can_exit and F_IsButtonBeingPressed(0,0) then
			if menu.play_sound then
				SoundPlay2D("ButtonUp")
			end
			DestroyMenu()
		elseif menu.n ~= 0 and F_IsButtonBeingPressed(1,0) then
			if menu.play_sound then
				SoundPlay2D("ButtonDown")
			end
			menu.selected = menu.i
		elseif menu.n > 1 then
			if F_NavigateMenu(2,0) then
				if menu.play_sound then
					SoundPlay2D("NavUp")
				end
				menu.i = menu.i - 1
				if menu.i < 1 then
					menu.i = menu.n
				end
			elseif F_NavigateMenu(3,0) then
				if menu.play_sound then
					SoundPlay2D("NavDwn")
				end
				menu.i = menu.i + 1
				if menu.i > menu.n then
					menu.i = 1
				end
			end
		end
		menu.n = 0
	end
	menu.update = false
end
function F_DrawMenu(menu,extx,exty)
	local MenuWidthResize = 0.08
	local ar,style = GetDisplayAspectRatio(),menu.draw_style
	local shown = math.min(math.max(1,menu.n),style.option_count)
	local x, y, width, height = style.menu_x/ar, style.menu_y, style.menu_w_min/ar - MenuWidthResize, 0
	local selecty = y
	local w,h,bgbottom
	
	if extx then 
		x,y = extx,exty
	elseif menu.extensions then
		for _,ext in ipairs(menu.extensions) do
			x,y = F_DrawMenu(ext,x,y)
		end
	end
	SetTextFormatting(style.option_format)
	SetTextWrapping(style.menu_w_max/ar)
	for i = 1,shown do 
		width = math.max(width,MeasureText(menu[menu.off+i])+style.option_pad_x/ar)
	end
	if menu.title_text ~= nil then
		SetTextFormatting(style.title_format)
		w,h = MeasureText(menu.title_text)
		h = h + style.title_pad_y
		width = math.max(width,w+style.title_pad_x/ar)
		if menu.n > shown then	
			DrawTexture(_G.menuBasePng,0.7,0.14,0.29,0.85,255,255,255,255) -- well i put the background here as anywhere else cause it to lag for no reason, or dropframes
		else
			DrawTexture(_G.menuBasePng,0.7,0.14,0.29,0.85,255,255,255,255)	-- positive goes up, negative goes down	
		end
		SetTextPosition(x+width*0.5,y+h*0.5)
		DrawText(menu.title_text)
		y = y + h
	end
	for i = 1,shown do
		local rtext = menu.roptions[menu.off+i]
		SetTextFormatting(style.option_format)
		if rtext ~= nil then
			SetTextAlign("R","T")
			SetTextClipping(width*style.option_right_w)
			w,h = MeasureText(rtext)
			SetTextWrapping(width-style.option_pad_x/ar-w)
		else
			SetTextWrapping(width-style.option_pad_x/ar)
		end
		w,h = MeasureText(menu[menu.off+i])
		h = h + style.option_pad_y
		if menu.off + i == menu.i and menu.n ~= 0 then
			DrawRectangle(x,y,width,height,0,0,0,style.scrollbar_scrollup[4]) -- when you scroll up hudbar color
			DrawRectangle(x,y+height,width,h,unpack(style.scrollbar_scollbarColor)) -- middle
			bgbottom = height + h
			selecty = y + height
		end
		height = height + h
	end
	if bgbottom then
		DrawRectangle(x,y+bgbottom,width,height-bgbottom,0,0,0,style.scrollbar_scrollbottom[4]) -- bottom
	else
		DrawRectangle(x,y,width,height,0,0,0,style.scrollbar_abovebackground[4]) -- full backdrop if none were drawn for selection
	end
	if menu.n > shown then -- draw scrollbar
		local r = menu.off / (menu.n - shown)
		w = style.scrollbar_width / ar
		h = height * (shown / menu.n)
		DrawRectangle(x+width,y,w,(height-h)*r,0,0,0,style.scrollbar_abovebackground[4]) -- above bar
		DrawRectangle(x+width,y+(height-h)*r,w,h,unpack(style.scrollbar_background)) -- scroll bar
		DrawRectangle(x+width,y+height*r+h*(1-r),w,(height-h)*(1-r),0,0,0,style.scrollbar_scrollerbottomColor[4]) -- below bar
	end
	DiscardText()
	height = 0
	for i = 1,shown do -- draw menu options
		local rtext = menu.roptions[menu.off+i]
		SetTextFormatting(style.option_format)
		if rtext ~= nil then
			SetTextAlign("R","T")
			SetTextClipping(width*style.option_right_w)
			SetTextPosition(x+width-(style.option_pad_x/ar)*0.5,y+height+style.option_pad_y*0.5)
			if menu.off + i == menu.i and menu.n ~= 0 then
				SetTextColor(255,255,255,255)
			end
			w,h = DrawText(rtext)
			SetTextFormatting(style.option_format)
			SetTextWrapping(width-style.option_pad_x/ar-w)
		else
			SetTextWrapping(width-style.option_pad_x/ar)
		end
		SetTextPosition(x+(style.option_pad_x/ar)*0.5,y+height+style.option_pad_y*0.5)
		if menu.off + i == menu.i and menu.n ~= 0 then
			SetTextColor(255,255,255,255)
		end
		w,h = DrawText(menu[menu.off+i])
		height = height + h + style.option_pad_y
	end
	drawn = true
	if not extx then
		local bx,by = style.menu_x/ar,style.menu_y
		return bx,by,(x+width)-bx,(y+height)-by
	end
	return x+width,selecty
end
buttons = {}
locked = false
RegisterLocalEventHandler("ControllerUpdating",function(controller)
	if drawn and controller == 0 then
		for b = 0,3 do
			if IsButtonPressed(b,0) then
				buttons[b] = buttons[b] == nil
			else
				buttons[b] = nil
			end
			SetButtonPressed(b,0,false)
		end
	end
end)
RegisterLocalEventHandler("ControllersUpdated",function()
	locked = drawn
	drawn = false
end)
function F_IsButtonPressed(b,c)
	if locked and c == 0 then
		return buttons[b] ~= nil
	end
	return IsButtonPressed(b,c)
end
function F_IsButtonBeingPressed(b,c)
	if locked and c == 0 then
		return buttons[b]
	end
	return IsButtonBeingPressed(b,c)
end
