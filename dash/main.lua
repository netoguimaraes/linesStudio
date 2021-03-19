lume = require "lume"
HC = require 'hardoncollider'

width = 720
height = 1280
half_height = height / 2
half_width = width / 2
score = 0
lateral_size = width / 8

player = {}
player["x"] = half_width 
player["y"] = 900
player["radius"] = 30
player["collider"] = HC.circle(player["x"], player["y"], player["radius"])

Collider = {}

-- this is called when two shapes collide
function on_collision(dt, shape_a, shape_b, mtv_x, mtv_y)
  text[#text+1] = string.format("Colliding. mtv = (%s,%s)", 
                                  mtv_x, mtv_y)
end

-- this is called when two shapes stop colliding
function collision_stop(dt, shape_a, shape_b)
  text[#text+1] = "Stopped colliding"
end

function get_enemy_boundaries()
  return lume.random(lateral_size, (width - lateral_size))
end

enemies = {}
defaultEnemy = {}
defaultEnemy["x"] = get_enemy_boundaries()
defaultEnemy["y"] = 0
defaultEnemy["radius"] = 20
defaultEnemy["speed"] = 10 
defaultEnemy["collider"] = HC.circle(defaultEnemy["x"], defaultEnemy["y"], defaultEnemy["radius"])

table.insert(enemies, defaultEnemy)

function love.load()
  love.window.setMode(width, height)
end

function player_drawer()
  love.graphics.setColor(1, 1, 1, 1)
  x_cord = player["x"] - 50
  love.graphics.circle("fill", x_cord, player["y"], player["radius"])
  player["collider"] = HC.circle(x_cord, player["y"], player["radius"])
end

function way_drawer()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print(lume.round(score * 100), 0, 100)
  love.graphics.line(lateral_size, 0, lateral_size, height)
  love.graphics.line(width - lateral_size, 0, (width - lateral_size), height)
  love.graphics.line(width - lateral_size, 0, (width - lateral_size), height)
end

function update_enemies()
  for i=1,#enemies do
    speed = enemies[i]["speed"]
    if enemies[i]["y"] < height then
      enemies[i]["y"] = enemies[i]["y"] + speed
    else
      enemies[i]["y"] = 0
      enemies[i]["x"] = get_enemy_boundaries()
    end
  end
end

function enemies_drawer()
  for i=1,#enemies do
    love.graphics.setColor(0.5, 0, 0, 1)
    love.graphics.circle("fill", enemies[i]["x"], enemies[i]["y"], enemies[i]["radius"])
    enemies[i]["collider"] = HC.circle(enemies[i]["x"], enemies[i]["y"], enemies[i]["radius"])
  end
end

function move_right()
  current_position = player["x"]
  if current_position < (width) then
    player["x"] = current_position + 10
  end
end

function move_left()
  current_position = player["x"]
  if current_position > 100 then
    player["x"] = current_position - 10
  end
end

function move_up()
  current_position = player["y"]
  if current_position > 0 then
    player["y"] = current_position - 10
  end
end

function move_down()
  current_position = player["y"]
  if current_position < (height - 300) then
    player["y"] = player["y"] + 10
  end
end

function controls()
  collisions = HC.collisions(player["collider"])
  for other, separating_vector in pairs(collisions) do
    print(other, separating_vector)
  end

  if love.keyboard.isDown("d") then
    move_right()
  end

  if love.keyboard.isDown("a") then
    move_left()
  end

  if love.keyboard.isDown("w") then
    move_up()
  end

  if love.keyboard.isDown("s") then
    move_down()
  end

  if love.mouse.isDown(1) then
    x = love.mouse.getX()
    y = love.mouse.getY()
    player["y"] = y
    player["x"] = x + player["radius"]
  end
end

function love.update(dt)
  controls()
  update_enemies()

  if player["x"] < (lateral_size * 2 - 10) or player["x"] > (width - lateral_size) then
    score = score - (dt * 2)
  else
    score = score + dt
  end
end

function love.draw()
  way_drawer()
  player_drawer()
  enemies_drawer()
end
