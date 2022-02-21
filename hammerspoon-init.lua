local shift = hs.keycodes.map.shift
local alt = hs.keycodes.map.alt

local function keyCode(key, modifiers)
   modifiers = modifiers or {}
   return function()
      for _, mod in ipairs(modifiers) do
         hs.eventtap.event.newKeyEvent(mod, true):post()
      end
      hs.eventtap.event.newKeyEvent(string.lower(key), true):post()
      hs.eventtap.event.newKeyEvent(string.lower(key), false):post()
      for _, mod in ipairs(modifiers) do
         hs.eventtap.event.newKeyEvent(mod, false):post()
      end
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
remapKey({}, '§', keyCode('<', {}))
remapKey({'shift'}, '§', keyCode('<', {'shift'}))
remapKey({'alt'}, '§', keyCode('7', {'alt', 'shift'}))

hs.hotkey.bind({"cmd", "shift"}, "L", function()
  hs.caffeinate.lockScreen()
end)

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
