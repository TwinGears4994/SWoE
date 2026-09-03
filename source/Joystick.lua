--[[
Brian T.Wilcox
twingears@gmail.com
Need to list all joysticks switches to program it
start and stop programming OR start and self trim the ending - 4-10 second window maybe

Changing primary gamepad to #1 'Logitech F310 Gamepad (XInput)
"030000006d0400001dc2000014400000,Logitech F310 Gamepad (XInput),
a               :b0,
b               :b1, --left dpad shape changer
back            :b6,
dpdown          :h0.4,
dpleft          :h0.8,
dpright         :h0.2,
dpup            :h0.1,
guide           :b8,
leftshoulder    :b4,
leftstick       :b9,
lefttrigger     :a2,
leftx           :a0,
lefty           :a1,
rightshoulder   :b5,
rightstick      :b10,
righttrigger    :a5,
rightx          :a3,
righty          :a4,
start           :b7,
x               :b2,
y               :b3,
    platform:Linux,platform:Linux"
--success = love.joystick.setGamepadMapping( guid, button, inputtype, inputindex, hatdir )
elseif button == "lefttrigger" then
elseif button == "righttrigger" then
]]

local joysticks = love.joystick.getJoysticks()
joystick = joysticks[1]
-- *** WORK ON GAMEPAD CONTROLLER D-PAD DATA CHANGES *** - need to isolate the two dirrerent joysticks on controller...
function love.gamepadpressed( joystick, button )
  --local dt = love.timer.getDelta()
  lastbutton = button
  if button == "guide" then
    goESC()
  elseif button == "dpup" then --"y" then   --DPad & fishing hook, fishing for button? Lefttop button so answer is = "leftstick" that has to more 
    goUp()
  elseif button == "dpdown" then -- or "a" then -- "leftshoulder" then --didn't work
    goDown()
  elseif button == "dpleft" then --or "leftstick" then -- or "x" then --"b" then
    goLeft()
  elseif button == "dpright" then --or "rightstick" then --or "b" then --a 1st test moved, 2nd guess = "b6" then; "rightstick" NNEDS A TRY
    goRight()
  elseif button == "y" then
    goUp()
  elseif button == "a" then
    goDown()
  elseif button == "x" then
    goLeft()
  elseif button == "b" then
    goRight()
  end
end