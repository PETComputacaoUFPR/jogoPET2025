local NPC = {}

NPC.data = {
    x = 1000,
    y = 200,
    spriteSheet = nil,
    grid = nil,
    animation = nil,
    dialogue = {
        "Bem-vindo, aluno! Para entrar na UFPR, voce precisa passar por um teste.",
        "Resolva os desafios de logica digital em cada sala para provar seu valor.",
        "Interaja com as cadeiras para acessar os niveis. Boa sorte!",
    },
    currentDialogueIndex = 1,
    showDialogue = false,
    dialogueTimer = 0,
}

function NPC.load()
    local anim8 = require 'libraries/anim8'
    NPC.data.spriteSheet = love.graphics.newImage('assets/sprites/player-sheet2.png')
    NPC.data.grid = anim8.newGrid(12, 18, NPC.data.spriteSheet:getWidth(), NPC.data.spriteSheet:getHeight())
    NPC.data.animation = anim8.newAnimation(NPC.data.grid('2-2', 1), 1) -- Parado
end

function NPC.update(dt)
    if NPC.data.showDialogue then
        NPC.data.dialogueTimer = NPC.data.dialogueTimer + dt
        if NPC.data.dialogueTimer > 5 then -- Mensagem some depois de 5 segundos
            NPC.data.showDialogue = false
        end
    end
end

function NPC.draw()
    local Utils = require("core.utils")
    NPC.data.animation:draw(NPC.data.spriteSheet, NPC.data.x, NPC.data.y, nil, 5, nil, 6, 9)
    if NPC.data.showDialogue then
        Utils.drawNPCDialogue(NPC.data.dialogue[NPC.data.currentDialogueIndex])
    end
end

function NPC.isNear()
    local Player = require("core.player")
    return math.abs(Player.data.x - NPC.data.x) < 100 and math.abs(Player.data.y - NPC.data.y) < 100
end

function NPC.nextDialogue()
    NPC.data.showDialogue = true
    NPC.data.dialogueTimer = 0
    NPC.data.currentDialogueIndex = NPC.data.currentDialogueIndex + 1
    if NPC.data.currentDialogueIndex > #NPC.data.dialogue then
        NPC.data.currentDialogueIndex = 1
    end
end

return NPC