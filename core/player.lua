local Player = {}

Player.data = {
    radius = 20,
    x = 30,
    y = 30,
    speed = 300,
    collider = nil,
    spriteSheet = nil,
    grid = nil,
    animations = {},
    anim = nil,
    previousX = 0,
    previousY = 0
}

function Player.load(world)
    local anim8 = require 'libraries/anim8'
    Player.data.spriteSheet = love.graphics.newImage('assets/sprites/player-sheet.png')
    Player.data.grid = anim8.newGrid(12, 18, Player.data.spriteSheet:getWidth(), Player.data.spriteSheet:getHeight())

    Player.data.animations.down = anim8.newAnimation(Player.data.grid('1-4', 1), 0.1)
    Player.data.animations.left = anim8.newAnimation(Player.data.grid('1-4', 2), 0.1)
    Player.data.animations.right = anim8.newAnimation(Player.data.grid('1-4', 3), 0.1)
    Player.data.animations.up = anim8.newAnimation(Player.data.grid('1-4', 4), 0.1)
    Player.data.anim = Player.data.animations.down

    Player.data.collider = world:newBSGRectangleCollider(400, 250, 50, 80, 10)
    Player.data.collider:setFixedRotation(true)
end

function Player.update(dt)
    local GameState = require("core.game_state")
    local Schoolbus = require("core.schoolbus")

    if not GameState.is("running") or Schoolbus.isIntroActive() then
        return
    end

    Player.data.anim:update(dt)
    local isMoving = false
    local vx, vy = 0, 0

    if love.keyboard.isDown("right") then
        vx = Player.data.speed
        Player.data.anim = Player.data.animations.right
        isMoving = true
    elseif love.keyboard.isDown("left") then
        vx = -Player.data.speed
        Player.data.anim = Player.data.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        vy = Player.data.speed
        Player.data.anim = Player.data.animations.down
        isMoving = true
    elseif love.keyboard.isDown("up") then
        vy = -Player.data.speed
        Player.data.anim = Player.data.animations.up
        isMoving = true
    end

    Player.data.collider:setLinearVelocity(vx, vy)
    Player.data.x, Player.data.y = Player.data.collider:getPosition()

    if not isMoving then
        Player.data.anim:gotoFrame(2)
    end
end

function Player.draw()
    local Schoolbus = require("core.schoolbus")
    if not Schoolbus.isPlayerVisible() then 
        return 
    end
    Player.data.anim:draw(Player.data.spriteSheet, Player.data.x, Player.data.y, nil, 5, nil, 6, 9)
end

function Player.setPosition(x, y)
    Player.data.x, Player.data.y = x, y
    if Player.data.collider then
        Player.data.collider:setPosition(x, y)
    end
end

function Player.savePosition()
    Player.data.previousX, Player.data.previousY = Player.data.x, Player.data.y
end

function Player.restorePosition()
    Player.setPosition(Player.data.previousX, Player.data.previousY)
end

return Player