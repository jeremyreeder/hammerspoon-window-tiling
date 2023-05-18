-- welcome
hs.alert.show('Hammerspoon')

-- reload
hs.hotkey.bind({'cmd', 'ctrl'}, 'r', hs.reload)

-- fill screen by default
hs.window.filter.default:subscribe(hs.window.filter.windowCreated, function() hs.window.focusedWindow():movetoUnit({0, 0, 1, 1}) end)

-- fill screen
hs.hotkey.bind({'cmd','ctrl'}, 'space', function() hs.window.focusedWindow():moveToUnit({0, 0, 1, 1}) end)

-- fill left or right half of screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'h', function() hs.window.focusedWindow():moveToUnit({0, 0, 0.5, 1}) end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', function() hs.window.focusedWindow():moveToUnit({0.5, 0, 0.5, 1}) end)

-- fill top or bottom half of screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'k', function() hs.window.focusedWindow():moveToUnit({0, 0, 1, 0.5}) end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'j', function() hs.window.focusedWindow():moveToUnit({0, 0.5, 1, 0.5}) end)

-- move window to another screen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:moveOneScreenNorth(False, True)
	window:screen():setMain()
	window:raise()
	window:focus()
	window:moveToUnit({0, 0, 1, 1})
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:moveOneScreenSouth(False, True)
	window:screen():setMain()
	window:raise()
	window:focus()
	window:moveToUnit({0, 0, 1, 1})
end)

-- navigate windows directionally
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

-- focus the most recently focused of the current application's other windows
hs.hotkey.bind({'option'}, 'tab', function() hs.window.focusedWindow():application():allWindows()[2]:focus() end)

-- cycle focus through the current application's windows
hs.hotkey.bind({'option', 'shift'}, 'tab', function()
	local windows = hs.window.focusedWindow():application():allWindows()
	windows[#windows]:focus()
end)

-- launch a web browser
hs.hotkey.bind({'cmd'}, '/', function() hs.execute('open https://duckduckgo.com') end)
