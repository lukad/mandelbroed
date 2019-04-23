local width, height = love.graphics.getDimensions()
local shader
local palettes = {}
local palette_names = {"palette.png", "palette02.png", "palette03.png"}
local scale = 1
local center = { 0.79574045120594, 0.184822245514133}
local iter = 400
local palette_index = 3
local dragging = {
  active = false,
  x = 0,
  y = 0
}
local scrollv = 0

function love.load()
  shader = love.graphics.newShader("shader.glsl")
  for i = 1, #palette_names do
    palettes[i] = love.graphics.newImage(palette_names[i])
  end

  shader:send("palette", palettes[palette_index])
end

function love.resize(w, h)
  width, height = w, h
end

function love.draw()
  love.graphics.clear()

  shader:send("center", center)
  shader:send("scale", scale)
  shader:send("iter", iter)
  shader:send("width", width)
  shader:send("height", height)

  love.graphics.setShader(shader)
  love.graphics.setColor(0, 0.5, 0)
  love.graphics.rectangle("fill", 0, 0, width, height)
  love.graphics.setShader()
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    center[2] = center[2] + dt * scale
  elseif love.keyboard.isDown("down") then
    center[2] = center[2] - dt * scale
  end

  if love.keyboard.isDown("left") then
    center[1] = center[1] + dt * scale
  elseif love.keyboard.isDown("right") then
    center[1] = center[1] - dt * scale
  end

  if love.keyboard.isDown("space") then
    scale = scale - dt * scale
  elseif love.keyboard.isDown("lshift") then
    scale = scale + dt * scale
  end

  if dragging.active then
    local mx, my = love.mouse.getPosition()
    local dx = dragging.x - mx
    local dy = dragging.y - my
    center[1] = center[1] - dx * scale * 0.001
    center[2] = center[2] - dy * scale * 0.001
    dragging.x = mx
    dragging.y = my
  end

  scale = scale - scrollv * dt * scale
  scrollv = scrollv - scrollv * math.min(dt * 10, 1)

  if (scrollv > 0 and scrollv < 0.1) or (scrollv < 0 and scrollv > -0.1) then
    scrollv = 0
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    dragging.x = x
    dragging.y = y
    dragging.active = true
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    dragging.active = false
  end
end

function love.wheelmoved(dx, dy)
  scrollv = scrollv + dy
end
