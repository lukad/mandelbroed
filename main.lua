local WIDTH, HEIGHT = love.graphics.getDimensions()
local shader
local palettes = {}
local palette_names = {"palette.png"}
local scale = 1
local center = {0.79574045120594, 0.184822245514133}
local iter = 400
local palette_index = 1

function love.load()
  shader = love.graphics.newShader("shader.glsl")
  for i = 1, #palette_names do
    palettes[i] = love.graphics.newImage(palette_names[i])
  end

  shader:send("palette", palettes[palette_index])
end

function love.draw()
  love.graphics.clear()

  shader:send("center", center)
  shader:send("scale", scale)
  shader:send("iter", iter)
  shader:send("width", WIDTH)
  shader:send("height", HEIGHT)

  love.graphics.setShader(shader)
  love.graphics.setColor(0, 0.5, 0)
  love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
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
end
