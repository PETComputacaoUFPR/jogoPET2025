local love = require "love"
math.randomseed(os.time())

-- Modulos principais
local GameState = require("core.game_state")
local Player = require("core.player")
local NPC = require("core.npc")
local Schoolbus = require("core.schoolbus")
local Interaction = require("core.interaction")
local MapManager = require("core.map_manager")
local Audio = require("core.audio")
local Buttons = require("core.button")
local Utils = require("core.utils")

-- Bibliotecas externas
local wf = require 'libraries/windfield'
local camera = require 'libraries/camera'

local world
local cam

--[[ Começo de uma das 3 funções principais: love.load()
Essa função é responsável por carregar tudo que será exibido no jogo, não só
design, mas suas bibliotecas de manipulação de câmera, animação do personagem,
mapas, fontes, colliders, sons e diferentes estados --]]
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    world = wf.newWorld(0, 0)
    cam = camera()

    -- Carrega todos os modulos
    Audio.load()
    MapManager.load(world)
    Player.load(world)
    NPC.load()
    Schoolbus.load()
    Interaction.load()
    Buttons.load(cam)
    Utils.load()

    Audio.playMusic()
end

--[[ Essa é a segunda função principal: love.update()
Ela é responsável por tudo que ocorre no momento em que estamos jogando o jogo,
sempre atualizando (fazendo update) com base nas ações do personagem. Por exemplo:
quando clicamos para mover o personagem nas setas, quando movemos as portas lógicas,
câmera acompanhando o personagem enquanto se move, são todas ações gerenciadas por essa função --]]
function love.update(dt)
    if GameState.is("running") then
        world:update(dt)
        Player.update(dt)
        NPC.update(dt)
        Schoolbus.update(dt)
        Interaction.update(dt)
    end

    -- Logica da camera
    local target = Schoolbus.isIntroActive() and not Schoolbus.isPlayerDropped() and Schoolbus.data or Player.data
    cam:lookAt(target.x, target.y)

    -- Limites da camera
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local mapW, mapH = MapManager.getMapDimensions()
    cam.x = math.max(w/2, math.min(cam.x, mapW - w/2))
    cam.y = math.max(h/2, math.min(cam.y, mapH - h/2))
end

--[[ Essa é a última função principal: love.draw().
Enquanto na função love.load() nós carregamos tudo que vamos utilizar no jogo,
nessa função, nós "desenhamos" o que propriamente aparecerá no mapa, em cada nível ou
a partir de cada ação do personagem. Por exemplo, se nós completamos o nível 1 e o personagem
não precisa voltar mais lá, nós não vamos desenhar mais o nível 1. Outro exemplo seria ao entrar
no nível 1, os desenhos do mapa principal precisarão se apagar por um momento e só os do mapa do
nível 1 serem exibidos --]]
function love.draw()
    cam:attach()
    MapManager.draw()
    cam:detach()

    Buttons.draw()
    Utils.drawCursor()
end

function love.keypressed(key)
    if key == 'escape' then
        if GameState.is("paused") then GameState.changeGameState("running")
        elseif GameState.is("running") then GameState.changeGameState("paused")
        end
    end

    if GameState.is("running") and key == 'e' then
        Interaction.handleKeyPress()
    end

    if key == 'p' then Utils.printPlayerPosition() end
    if key == 'z' then Audio.stopMusic() end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        Buttons.handleMousePress(x, y)
    end
end