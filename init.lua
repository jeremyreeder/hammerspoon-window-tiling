-- welcome
hs.alert.show('Hammerspoon')

-- reload
hs.hotkey.bind({'cmd', 'ctrl'}, 'r', hs.reload)

-- fill screen by default
hs.window.filter.default:subscribe(hs.window.filter.windowCreated, function() hs.window.focusedWindow():setFullScreen() end)

-- fill screen
hs.hotkey.bind({'cmd','ctrl'}, 'space', function() hs.window.focusedWindow():toggleFullScreen() end)

-- fill left or right half of screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'h', function()
	local window = hs.window.focusedWindow()
	if window:isFullScreen() then
		window:toggleFullScreen()
	end
	window:moveToUnit({0, 0, 0.5, 1})
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', function()
	local window = hs.window.focusedWindow()
	if window:isFullScreen() then
		window:toggleFullScreen()
	end
	window:moveToUnit({0.5, 0, 0.5, 1})
end)

-- fill top or bottom half of screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'k', function()
	local window = hs.window.focusedWindow()
	if window:isFullScreen() then
		window:toggleFullScreen()
	end
	window:moveToUnit({0, 0, 1, 0.5})
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'j', function()
	local window = hs.window.focusedWindow()
	if window:isFullScreen() then
		window:toggleFullScreen()
	end
	window:moveToUnit({0, 0.5, 1, 0.5})
end)

-- move window to another screen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'k', function()
	local window = hs.window.focusedWindow()
	local wasFullScreen = window:isFullScreen()
	if wasFullScreen then
		window:toggleFullScreen()
	end
	window:moveOneScreenNorth(False, True)
	window:screen():setMain()
	window:moveToUnit({0, 0, 1, 1})
	window:raise()
	window:setFullScreen()
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'j', function()
	local window = hs.window.focusedWindow()
	local wasFullScreen = window:isFullScreen()
	if wasFullScreen then
		window:toggleFullScreen()
	end
	window:moveOneScreenSouth(False, True)
	window:screen():setMain()
	window:moveToUnit({0, 0, 1, 1})
	window:raise()
	window:setFullScreen()
	window:focus()
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
hs.hotkey.bind({'option'}, 'tab', function()
	local window1 = hs.window.focusedWindow()
	local window2 = window1:application():allWindows()[2]
	local wasFullScreen = window1:isFullScreen()
	if wasFullScreen then window1:toggleFullScreen() end
	window2:focus()
	if wasFullScreen then window2.setFullScreen() end
end)

-- cycle focus through the current application's windows
hs.hotkey.bind({'option', 'shift'}, 'tab', function()
	local window1 = hs.window.focusedWindow()
	local windows = window1:application():allWindows()
	local windowX = windows[#windows]
	local wasFullScreen = window1:isFullScreen()
	if wasFullScreen then window1:toggleFullScreen() end
	windowX:focus()
	if wasFullScreen then windowX.setFullScreen() end
end)

-- launch a web browser
hs.hotkey.bind({'cmd'}, '/', function() hs.execute('open https://duckduckgo.com') end)
