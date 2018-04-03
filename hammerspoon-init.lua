local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
      hs.timer.usleep(1000)
      hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()      
   end
end

local function keyCodeSet(keys)
   return function()
      for i, keyEvent in ipairs(keys) do
         keyEvent()
      end
   end
end

local function remapKey(modifiers, key, keyCode)
   hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

remapKey('alt', '^', keyCode('n', {'alt'}))
remapKey('alt', 'ü', keyCode('5', {'alt'}))
remapKey('alt', '¨', keyCode('6', {'alt'}))
remapKey('alt', 'ä', keyCode('8', {'alt'}))
remapKey('alt', '$', keyCode('9', {'alt'}))

-- For debug
local function showKeyPress(tapEvent)
    local charactor = hs.keycodes.map[tapEvent:getKeyCode()]
    hs.alert.show(charactor, 1.5)
end

local keyTap = hs.eventtap.new(
  {hs.eventtap.event.types.keyDown},
  showKeyPress
)

k = hs.hotkey.modal.new({"cmd", "shift", "ctrl"}, 'P')
function k:entered()
  hs.alert.show("Enabling Keypress Show Mode", 1.5)
  keyTap:start()
end
function k:exited()
  hs.alert.show("Disabling Keypress Show Mode", 1.5)
end
k:bind({"cmd", "shift", "ctrl"}, 'P', function()
    keyTap:stop()
    k:exit()
end)
