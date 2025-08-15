local Interaction = {}

Interaction.gates = {
    andGate = {},
    andGateExtra = {},
    orGate = {}
}

Interaction.gateTextures = {}

Interaction.gateDestinations = {
    {x = 747, y = 682},
    {x = 745, y = 676},
    {x = 745, y = 874},
    {x = 965, y = 768}
}

Interaction.chairs = {
    {x = 64, y = 896},
    {x = 1766, y = 1489}
}

Interaction.levelStates = {
    level1 = true,
    level2 = true
}

function Interaction.load()
    Interaction.gateTextures.andGate = love.graphics.newImage('assets/images/textures/andlogic.png')
    Interaction.gateTextures.orGate = love.graphics.newImage('assets/images/textures/orlogic.png')
end

function Interaction.update(dt)
    local Player = require("core.player")
    for _, gate in pairs(Interaction.gates) do
        if gate.beingCarried then
            gate.x, gate.y = Player.data.x, Player.data.y
        end
    end
end

function Interaction.draw()
    local MapManager = require("core.map_manager")
    if MapManager.currentMap == "level1" then
        love.graphics.draw(Interaction.gateTextures.andGate, Interaction.gates.andGate.x, Interaction.gates.andGate.y)
    elseif MapManager.currentMap == "level2" then
        love.graphics.draw(Interaction.gateTextures.andGate, Interaction.gates.andGate.x, Interaction.gates.andGate.y)
        love.graphics.draw(Interaction.gateTextures.andGate, Interaction.gates.andGateExtra.x, Interaction.gates.andGateExtra.y)
        love.graphics.draw(Interaction.gateTextures.orGate, Interaction.gates.orGate.x, Interaction.gates.orGate.y)
    end
end

function Interaction.isNearGate(gate)
    local Player = require("core.player")
    if not gate or not gate.x then return false end
    return math.abs(Player.data.x - gate.x) < 100 and math.abs(Player.data.y - gate.y) < 100
end

function Interaction.isNearInteractionObject()
    local Player = require("core.player")
    for i, chair in ipairs(Interaction.chairs) do
        if math.abs(Player.data.x - chair.x) < 95 and math.abs(Player.data.y - chair.y) < 95 then
            if (i == 1 and Interaction.levelStates.level1) or (i == 2 and Interaction.levelStates.level2) then
                return true, i
            end
        end
    end
    return false
end

function Interaction.isGateAtCorrectPosition(gate, destination)
    local tolerance = 40
    return math.abs(gate.x - destination.x) < tolerance and math.abs(gate.y - destination.y) < tolerance
end

function Interaction.checkGatePositions()
    local MapManager = require("core.map_manager")
    local Player = require("core.player")
    local GameState = require("core.game_state")

    local function completeLevel(levelName)
        Interaction.levelStates[levelName] = false
        GameState.changeGameState("running")
        MapManager.switchToMap("mainMap")
        Player.restorePosition()
    end

    if MapManager.currentMap == "level1" then
        if Interaction.isGateAtCorrectPosition(Interaction.gates.andGate, Interaction.gateDestinations[1]) then
            completeLevel("level1")
        end
    elseif MapManager.currentMap == "level2" then
        if Interaction.isGateAtCorrectPosition(Interaction.gates.andGate, Interaction.gateDestinations[2]) and
           Interaction.isGateAtCorrectPosition(Interaction.gates.andGateExtra, Interaction.gateDestinations[3]) and
           Interaction.isGateAtCorrectPosition(Interaction.gates.orGate, Interaction.gateDestinations[4]) then
            completeLevel("level2")
        end
    end
end

function Interaction.handleKeyPress()
    local MapManager = require("core.map_manager")
    local Player = require("core.player")
    local NPC = require("core.npc")

    if NPC.isNear() then
        NPC.nextDialogue()
        return
    end

    local isNear, chairIndex = Interaction.isNearInteractionObject()
    if isNear then
        Player.savePosition()
        if chairIndex == 1 then
            MapManager.switchToMap("level1")
            Interaction.gates.andGate = { x = 100, y = 100, beingCarried = false }
        elseif chairIndex == 2 then
            MapManager.switchToMap("level2")
            Interaction.gates.andGate = { x = 100, y = 100, beingCarried = false }
            Interaction.gates.andGateExtra = { x = 150, y = 100, beingCarried = false }
            Interaction.gates.orGate = { x = 200, y = 100, beingCarried = false }
        end
        return
    end

    if MapManager.currentMap == "level1" then
        if Interaction.isNearGate(Interaction.gates.andGate) then
            Interaction.gates.andGate.beingCarried = not Interaction.gates.andGate.beingCarried
        end
    elseif MapManager.currentMap == "level2" then
        if Interaction.isNearGate(Interaction.gates.andGate) then
            Interaction.gates.andGate.beingCarried = not Interaction.gates.andGate.beingCarried
        end
        if Interaction.isNearGate(Interaction.gates.andGateExtra) then
            Interaction.gates.andGateExtra.beingCarried = not Interaction.gates.andGateExtra.beingCarried
        end
        if Interaction.isNearGate(Interaction.gates.orGate) then
            Interaction.gates.orGate.beingCarried = not Interaction.gates.orGate.beingCarried
        end
    end
    Interaction.checkGatePositions()
end

return Interaction