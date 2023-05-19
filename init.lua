-- welcome
hs.alert.show('Hammerspoon')

-- fill screen by default
hs.window.filter.default:subscribe(hs.window.filter.windowCreated, function() hs.window.focusedWindow():moveToUnit({0, 0, 1, 1}) end)

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
hs.hotkey.bind({'option'}, 'tab', function() hs.window.focusedWindow():application():allWindows()[2]:focus() end)

-- hotkey to cycle thru the app's windows
hs.hotkey.bind({'option', 'shift'}, 'tab', function()
	local windows = hs.window.focusedWindow():application():allWindows()
	windows[#windows]:focus()
end)

-- hotkey to launch a web browser
hs.hotkey.bind({'cmd', 'ctrl'}, '/', function() hs.execute('open https://duckduckgo.com') end)

-- hotkey to launch Finder
hs.hotkey.bind({'cmd', 'ctrl'}, 'Return', function() hs.execute('open --reveal ~/Documents') end)
