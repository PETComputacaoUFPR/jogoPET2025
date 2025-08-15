local Schoolbus = {}

Schoolbus.data = {
    x = -200,
    y = 250,
    state = "idle", -- Pode estar "arriving", "waiting", "leaving"
    waitTimer = 0,
    texture = nil,
}
-- Essas flags controlam a sequencia da intro
-- These flags control the intro sequence
Schoolbus.intro = {
    active = false,
    playerVisible = false,
    playerDropped = false,
}

function Schoolbus.load()
    Schoolbus.data.texture = love.graphics.newImage('assets/images/textures/school_bus.png')
end

function Schoolbus.update(dt)
    if not Schoolbus.intro.active then 
        return 
    end

    if Schoolbus.data.state == "arriving" then
        Schoolbus.data.x = Schoolbus.data.x + 200 * dt
        if Schoolbus.data.x >= 250 then
            Schoolbus.data.x = 250
            Schoolbus.data.state = "waiting"
            Schoolbus.intro.playerDropped = true
            Schoolbus.intro.playerVisible = true
            -- Position the player when they get off the bus
            local Player = require("core.player")
            Player.setPosition(300, 300) 
        end
    elseif Schoolbus.data.state == "waiting" then
        Schoolbus.data.waitTimer = Schoolbus.data.waitTimer + dt
        if Schoolbus.data.waitTimer > 2 then
            Schoolbus.data.state = "leaving"
        end
    elseif Schoolbus.data.state == "leaving" then
        Schoolbus.data.x = Schoolbus.data.x + 200 * dt
        if Schoolbus.data.x > love.graphics.getWidth() + 200 then
            Schoolbus.intro.active = false
            Schoolbus.data.state = "idle"
        end
    end
end

function Schoolbus.draw()
    if Schoolbus.intro.active then
        love.graphics.draw(Schoolbus.data.texture, Schoolbus.data.x, Schoolbus.data.y)
    end
end

-- This function is called from game_state.lua to start the intro
function Schoolbus.startIntro()
    Schoolbus.intro.active = true
    Schoolbus.intro.playerVisible = false
    Schoolbus.intro.playerDropped = false
    Schoolbus.data.state = "arriving"
    Schoolbus.data.x = -200
    Schoolbus.data.waitTimer = 0
end

-- Helper functions for other modules to check the intro status
function Schoolbus.isIntroActive()
    return Schoolbus.intro.active
end

function Schoolbus.isPlayerVisible()
    -- The player should only be visible if the intro is not active,
    -- or if the intro is active AND the player has been dropped off.
    return not Schoolbus.intro.active or Schoolbus.intro.playerVisible
end

function Schoolbus.isPlayerDropped()
    return Schoolbus.intro.playerDropped
end

return Schoolbus