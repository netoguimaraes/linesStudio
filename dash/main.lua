lume = require "lume"

time = 0
game_over = false
width = 720
height = 1280
half_height = height / 2
half_width = width / 2
lateral_size = width / 8

player = {}
player["x"] = half_width 
player["y"] = 900
player["radius"] = 30

function get_enemy_boundaries()
  return lume.random(20, width - 20)
end

function create_enemy()
  enemy = {}
  enemy["y"] = 0
  enemy["radius"] = 20
  enemy["speed"] = lume.random(5, 20)
  enemy["x"] = get_enemy_boundaries()
  enemy["sides"] = lume.random(5, 20)
  return enemy
end

function bootstrap()
  enemies = {}
  time = 0
  player["y"] = 900
  table.insert(enemies, create_enemy())
  love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function love.load()
  love.window.setMode(width, height)
  bootstrap()
end

function player_drawer()
  love.graphics.setColor(0, 0, 0, 1)
  x_cord = player["x"]
  love.graphics.circle("fill", x_cord, player["y"], player["radius"])
end

function update_enemies(dt)
  local enemiesAlive = 1
  if (time > 2) then
    enemiesAlive = math.ceil(time / 2)
    print(time, enemiesAlive)

    if (table.getn(enemies) < enemiesAlive) then
      table.insert(enemies, create_enemy())
    end
  end

  for i=1,#enemies do
    enemyXPoint = enemies[i]['x']
    playerXPoint = player['x']
    enemyYPoint = enemies[i]['y']
    playerYPoint = player['y']

    distanceFromPlayer = lume.distance(enemyXPoint, enemyYPoint, playerXPoint, playerYPoint)

    if (distanceFromPlayer < (enemies[i]['radius'] + player['radius'])) then
      game_over = true
    end
    
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
  love.graphics.setColor(lume.random(), lume.random(), lume.random(), 1)
  for i=1,#enemies do
    love.graphics.circle("fill", enemies[i]["x"], enemies[i]["y"], enemies[i]["radius"], enemies[i]["sides"])
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
end

function love.update(dt)
  controls()
  if (not game_over) then
    time = time + dt
    update_enemies(dt)
  end
end

function love.draw()
  if (game_over) then
    love.graphics.print("game over. press any key", half_width - 80, half_height)
  else
    player_drawer()
    enemies_drawer()
  end
end

function love.keypressed(key, scancode, isrepeat)
  if (game_over) then
    game_over = false
    bootstrap()
  end
end