local i3j={}
i3j.__index = i3j

-- metadata
i3j.name = 'i3j'
i3j.version = '0.2'
i3j.author = 'Jeremy Reeder <jeremy.reeder@pm.me>'
i3j.homepage = 'https://github.com/jeremyreeder/i3j'
i3j.license = 'BSD - https://opensource.org/licenses/BSD'

-- welcome
hs.alert.show('Hammerspoon')

-- track focus
i3j.lastBorder = nil
function i3j:deleteBorder()
	if i3j.lastBorder then
		i3j.lastBorder:delete()
		i3j.lastBorder = nil
	end
end
function i3j:drawBorder(window)
	i3j:deleteBorder()
	local screens = hs.screen.allScreens()
	if #screens > 1 or window:isFullScreen() == false then
		local border = hs.canvas.new(window:frame())
		border:appendElements({
			type = 'rectangle',
			action = 'stroke',
			strokeWidth = 6,
			strokeColor = {red = 0.7, blue = 0, green = 0, alpha = 1},
			withShadow = true,
			shadow = {blurRadius = 9, color = {alpha = 1 / 3}, offset = {h = 0, w = 0}}
		})
		i3j.lastBorder = border
		border:show()
	end
end
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
		hs.mouse.setAbsolutePosition(frame.center)
	end
end
function i3j:start()
	hs.window.filter.default:subscribe(
		{hs.window.filter.windowFocused, hs.window.filter.windowMoved, hs.window.filter.windowResized},
		function(window)
			i3j:drawBorder(window)
			i3j:moveMouseNear(window)
			i3j:showApplicationName(window)
		end
	)
	hs.window.filter.default:subscribe(hs.window.filter.windowDestroyed, function() i3j:deleteBorder() end)
end
function i3j:stop()
	hs.window.filter.default:unsubscribeAll()
	i3j:deleteBorder()
end

-- fill screen by default
function i3j:fillScreen(window)
	if window:isStandard() then window:moveToUnit({0, 0, 1, 1}) end
end
hs.window.filter.default:subscribe(
	{hs.window.filter.windowCreated, hs.window.filter.windowOnScreen},
	function(window) i3j:fillScreen(window) end
)

-- hotkey to reload
hs.hotkey.bind({'cmd', 'ctrl'}, 'r', hs.reload)

-- hotkey to fill screen
hs.hotkey.bind({'cmd','ctrl'}, 'space', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	fillScreen(window)
	hs.alert.show('Fill SCREEN', 0.4)
end)

-- hotkeys to fill half of screen
hs.hotkey.bind({'cmd', 'ctrl'}, 'h', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0, 0.5, 1})
	hs.alert.show('Fill WEST', 0.3)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0.5, 1, 0.5})
	hs.alert.show('Fill SOUTH', 0.3)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0, 0, 1, 0.5})
	hs.alert.show('Fill NORTH', 0.3)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'l', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveToUnit({0.5, 0, 0.5, 1})
	hs.alert.show('Fill EAST', 0.3)
end)

-- hotkeys to move window to another screen
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'h', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenWest(false, true)
	hs.alert.show('Move WEST', 0.3)
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'j', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenSouth(false, true)
	hs.alert.show('Move SOUTH', 0.3)
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'k', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenNorth(false, true)
	hs.alert.show('Move NORTH', 0.3)
	window:focus()
end)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'l', function()
	local window = hs.window.focusedWindow()
	window:setFullScreen(false)
	window:moveOneScreenEast(false, true)
	hs.alert.show('Move EAST', 0.3)
	window:focus()
end)

-- hotkeys to navigate windows directionally
hs.hotkey.bind({'option'}, 'h', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus WEST', 0.3)
	window:focusWindowWest(window:application():allWindows())
end)
hs.hotkey.bind({'option'}, 'j', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus SOUTH', 0.3)
	window:focusWindowSouth(window:application():allWindows())
end)
hs.hotkey.bind({'option'}, 'k', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus NORTH', 0.3)
	window:focusWindowNorth(window:application():allWindows())
end)
hs.hotkey.bind({'option'}, 'l', function()
	local window = hs.window.focusedWindow()
	hs.alert.show('Focus EAST', 0.3)
	window:focusWindowEast(window:application():allWindows())
end)

-- hotkey to focus the app's prior window
hs.hotkey.bind({'option'}, 'tab', function()
	local app = hs.window.focusedWindow():application()
	local windows = app:allWindows()
	if #windows >= 2 then
		windows[2]:focus()
	else
		hs.alert.show('No prior ' .. app:name() .. ' window')
	end
end)

-- hotkey to cycle thru the app's windows
hs.hotkey.bind({'option', 'shift'}, 'tab', function()
	local app = hs.window.focusedWindow():application()
	local windows = app:allWindows()
	if #windows >= 2 then
		windows[#windows]:focus()
	else
		hs.alert.show('No next ' .. app:name() .. ' window')
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
