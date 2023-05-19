-- welcome
hs.alert.show('Hammerspoon.')

-- fill screen by default
hs.window.filter.default:subscribe(
	hs.window.filter.windowCreated,
	function()
		local window = hs.window.focusedWindow()
		if window:isStandard() then
			window:moveToUnit({0, 0, 1, 1})
		end
	end
)

-- hotkey to reload
hs.hotkey.bind({'cmd', 'ctrl'}, 'r', hs.reload)

-- hotkey to fill screen
hs.hotkey.bind({'cmd','ctrl'}, 'space', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0, 1, 1})
end)

-- hotkeys to fill half of screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'h', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0, 0.5, 1})
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0.5, 1, 0.5})
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0, 1, 0.5})
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0.5, 0, 0.5, 1})
end)

-- hotkeys to move window to another screen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'h', function()
	local window = hs.window.focusedWindow()
	window:moveOneScreenWest(false, true)
	window:screen():setMain()
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:moveOneScreenSouth(false, true)
	window:screen():setMain()
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:moveOneScreenNorth(false, true)
	window:screen():setMain()
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'l', function()
	local window = hs.window.focusedWindow()
	window:moveOneScreenEast(false, true)
	window:screen():setMain()
	window:focus()
end)

-- hotkeys to navigate windows directionally
hs.hotkey.bind({'option'}, 'h', function()
	local window = hs.window.focusedWindow()
	window:focusWindowWest(window:application():allWindows())
end)
hs.hotkey.bind({'option'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:focusWindowSouth(window:application():allWindows())
end)
hs.hotkey.bind({'option'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:focusWindowNorth(window:application():allWindows())
end)
hs.hotkey.bind({'option'}, 'l', function()
	local window = hs.window.focusedWindow()
	window:focusWindowEast(window:application():allWindows())
end)

-- hotkey to focus the app's prior window
hs.hotkey.bind({'option'}, 'tab', function()
	local app = hs.window.focusedWindow():application()
	local windows = app:allWindows()
	if #windows >= 2 then
		local window = windows[2]
		window:focus()
		if #windows >= 4 then
			hs.alert.show('Prior of ' .. #windows .. ' ' .. app:name() .. ' windows.\n\nFor 3rd & beyond, use ⌥⇧⇥.', window:screen(), 0.8)
		elseif #windows >= 3 then
			hs.alert.show('Prior of ' .. #windows .. ' ' .. app:name() .. ' windows.\n\nFor 3rd window, use ⌥⇧⇥.', window:screen(), 0.8)
		else
			hs.alert.show('Prior of ' .. #windows .. ' ' .. app:name() .. ' windows.', 0.5)
		end
	else
		hs.alert.show(app:name() .. ' has no prior window.')
	end
end)

-- hotkey to cycle thru the app's windows
hs.hotkey.bind({'option', 'shift'}, 'tab', function()
	local app = hs.window.focusedWindow():application()
	local windows = app:allWindows()
	if #windows >= 2 then
		windows[#windows]:focus()
		if #windows > 2 then
			hs.alert.show('')
		else
			hs.alert.show('Next of ' .. #windows .. ' ' .. app:name() .. ' windows.', 0.5)
		end
	else
		hs.alert.show(app:name() .. ' has no other windows.')
	end
end)

-- hotkey to launch a web browser
hs.hotkey.bind({'cmd', 'ctrl'}, '/', function()
	hs.execute('open https://duckduckgo.com')
	hs.alert.show('Browser', 0.4)
end)

-- hotkey to launch Finder
hs.hotkey.bind({'cmd', 'ctrl'}, 'Return', function()
	hs.execute('open --reveal ~/Documents')
	hs.alert.show('Finder', 0.4)
end)
