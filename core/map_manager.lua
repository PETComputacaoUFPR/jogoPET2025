local MapManager = {}

MapManager.maps = {}
MapManager.currentMap = "mainMap"
MapManager.walls = {}
local world = nil

function MapManager.load(physicsWorld)
    local sti = require 'libraries/sti'
    world = physicsWorld
    MapManager.maps.mainMap = sti('maps/testMap.lua')
    MapManager.maps.menu = sti('maps/menu.lua')
    MapManager.maps.level1 = sti('maps/level1.lua')
    MapManager.maps.level2 = sti('maps/level2.lua')
    MapManager.loadMapCollisions(MapManager.maps.mainMap)
end

function MapManager.draw()
    local GameState = require("core.game_state")
    local Player = require("core.player")
    local NPC = require("core.npc")
    local Schoolbus = require("core.schoolbus")
    local Interaction = require("core.interaction")

    if GameState.is("menu") then
        local map = MapManager.maps.menu
        map:drawLayer(map.layers["default"])
        map:drawLayer(map.layers["trees"])
        return
    end

    local map = MapManager.maps[MapManager.currentMap]
    if not map then return end

    map:drawLayer(map.layers["Ground"])
    if map.layers["Trees"] then map:drawLayer(map.layers["Trees"]) end
    if map.layers["letters"] then map:drawLayer(map.layers["letters"]) end

    Schoolbus.draw()
    Player.draw()
    NPC.draw()
    Interaction.draw()
end

function MapManager.clearColliders()
    for _, wall in ipairs(MapManager.walls) do
        wall:destroy()
    end
    MapManager.walls = {}
end

function MapManager.loadMapCollisions(map)
    if map and map.layers and map.layers["Walls"] then
        for _, obj in ipairs(map.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(MapManager.walls, wall)
        end
    end
end

function MapManager.switchToMap(mapName)
    MapManager.currentMap = mapName
    MapManager.clearColliders()
    MapManager.loadMapCollisions(MapManager.maps[mapName])
end

function MapManager.getMapDimensions()
    local map = MapManager.maps[MapManager.currentMap]
    if not map then return 0, 0 end
    return map.width * map.tilewidth, map.height * map.tileheight
end

return MapManager