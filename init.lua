local i3j={}
i3j.__index = i3j

-- metadata
i3j.name = 'i3j'
i3j.version = '0.3'
i3j.author = 'Jeremy Reeder <jeremy.reeder@pm.me>'
i3j.homepage = 'https://github.com/jeremyreeder/i3j'
i3j.license = 'BSD - https://opensource.org/licenses/BSD'

-- welcome
hs.alert.show('Hammerspoon')

-- track focus
i3j.lastWindow = nil
function i3j:showApplicationName(window)
	if window ~= i3j.lastWindow then
		hs.alert.show(window:application():name(), window:screen(), 0.4)
		i3j.lastWindow = window
	end
end
function i3j:moveMouseNear(window)
	local mouseLocation = hs.geometry(hs.mouse.absolutePosition())
	local maxDistance = 100
	local mouseVicinity = hs.geometry.rect(
		mouseLocation.x - maxDistance,
		mouseLocation.y - maxDistance,
		2 * maxDistance,
		2 * maxDistance
	)
	local frame = window:frame()
	if mouseVicinity:intersect(frame).area == 0 then
		hs.mouse.absolutePosition(frame.center)
	end
end
function i3j:start()
	hs.window.highlight.ui.frameWidth = 6
	hs.window.highlight.ui.frameColor = {0.7, 0, 0, 1}
	hs.window.highlight.ui.overlay = true
	hs.window.highlight.ui.overlayColor = {0, 0, 0, 0.15}
	hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window)
		if window == hs.window.focusedWindow() then
			i3j:moveMouseNear(window)
			i3j:showApplicationName(window)
		end
	end)
	hs.window.filter.default:subscribe(
		{
			hs.window.filter.windowFocused,
			hs.window.filter.windowMoved,
			hs.window.filter.windowResized,
			hs.window.filter.windowFullScreened,
			hs.window.filter.windowUnFullScreened,
		},
		function()
			-- restarting the highlight on these events fixes a bug where the highlight sometimes disappears
			hs.window.highlight.start()
		end
	)
	hs.window.highlight.start()
end
--hs.timer.doEvery(5, function() hs.window.highlight.start() end)
function i3j:stop()
	hs.window.filter.default:unsubscribeAll()
	hs.window.highlight.stop()
end

-- fill screen by default
i3j.wholeScreen = {0, 0, 1, 1}
function i3j:fillScreen(window)
	if window:isStandard()
		and window:title() ~= ''
		and window:title() ~= 'Copy'
	then window:moveToUnit(i3j.wholeScreen) end
end
hs.window.filter.default:subscribe(
	hs.window.filter.windowCreated,
	function(window) i3j:fillScreen(window) end
)

-- hotkey to reload
hs.hotkey.bind({'cmd', 'ctrl'}, 'r', hs.reload)
hs.hotkey.bind({'cmd', 'ctrl'}, 'w', function()
	local window = hs.window.focusedWindow()
	hs.alert.show(window:application():name() .. ' : ' .. window:title())
end)

-- hotkey to fill screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'space', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	i3j:fillScreen(window)
	hs.alert.show('Fill SCREEN', 0.4)
end)

-- hotkeys to fill half of screen
i3j.westHalf = {0, 0, 0.5, 1}
i3j.eastHalf = {0.5, 0, 0.5, 1}
i3j.southHalf = {0, 0.5, 1, 0.5}
i3j.northHalf = {0, 0, 1, 0.5}
function i3j:fillHalf(window, half, otherHalf)
	window:setFullScreen(false)
	window:moveToUnit(half)
	local otherWindows = window:otherWindowsSameScreen()
	if #otherWindows > 0 and otherWindows[1]:isStandard() then otherWindows[1]:moveToUnit(otherHalf) end
	hs.alert.show('Fill HALF', 0.3)
end
hs.hotkey.bind({'cmd', 'ctrl'}, 'h', function()
	i3j:fillHalf(hs.window.focusedWindow(), i3j.westHalf, i3j.eastHalf)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'j', function()
	i3j:fillHalf(hs.window.focusedWindow(), i3j.southHalf, i3j.northHalf)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'k', function()
	i3j:fillHalf(hs.window.focusedWindow(), i3j.northHalf, i3j.southHalf)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', function()
	i3j:fillHalf(hs.window.focusedWindow(), i3j.eastHalf, i3j.westHalf)
end)

-- hotkeys to move window to another screen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'h', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenWest(false, true)
	i3j:fillScreen(window)
	hs.alert.show('Move WEST', 0.3)
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenSouth(false, true)
	i3j:fillScreen(window)
	hs.alert.show('Move SOUTH', 0.3)
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenNorth(false, true)
	i3j:fillScreen(window)
	hs.alert.show('Move NORTH', 0.3)
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'l', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenEast(false, true)
	i3j:fillScreen(window)
	hs.alert.show('Move EAST', 0.3)
	window:focus()
end)

-- hotkeys to navigate windows directionally
hs.hotkey.bind({'option'}, 'h', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus WEST', 0.3)
	window:focusWindowWest(window:otherWindowsSameScreen(), true, true)
end)
hs.hotkey.bind({'option'}, 'j', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus SOUTH', 0.3)
	window:focusWindowSouth(window:otherWindowsSameScreen(), true, true)
end)
hs.hotkey.bind({'option'}, 'k', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus NORTH', 0.3)
	window:focusWindowNorth(window:otherWindowsSameScreen(), true, true)
end)
hs.hotkey.bind({'option'}, 'l', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus EAST', 0.3)
	window:focusWindowEast(window:otherWindowsSameScreen(), true, true)
end)

-- hotkeys to cycle focus through all windows of the current app
hs.hotkey.bind({'option'}, 'tab', function()
	local app = hs.window.focusedWindow():application()
	filter = hs.window.filter.new(false):setAppFilter(app:name(), {focused=false}):setSortOrder(hs.window.filter.sortByFocused)
	local windows = filter:getWindows()
	if #windows >= 1 then
		windows[1]:focus()
	else
		hs.alert.show('No other ' .. app:name() .. ' window')
	end
end)
hs.hotkey.bind({'option', 'shift'}, 'tab', function()
	local app = hs.window.focusedWindow():application()
	filter = hs.window.filter.new(false):setAppFilter(app:name(), {focused=false}):setSortOrder(hs.window.filter.sortByFocusedLast)
	local windows = filter:getWindows()
	if #windows >= 1 then
		windows[1]:focus()
	else
		hs.alert.show('No other ' .. app:name() .. ' window')
	end
end)

-- hotkey to launch a web browser
hs.hotkey.bind({'cmd', 'ctrl'}, '/', function()
	hs.execute('open https://duckduckgo.com')
end)

-- hotkey to launch Finder
hs.hotkey.bind({'cmd', 'ctrl'}, 'Return', function()
	hs.execute('open --reveal ~/Documents')
end)

return i3j
