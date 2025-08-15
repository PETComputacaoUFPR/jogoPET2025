local Utils = {}

Utils.cursorImage = nil
Utils.balloonImage = nil
Utils.fonts = {}

function Utils.load()
    Utils.cursorImage = love.graphics.newImage('assets/images/cursor/cursor1.png')
    Utils.balloonImage = love.graphics.newImage('assets/images/textures/balloon_whitebackground.png')
    Utils.fonts.button = love.graphics.newFont('assets/fonts/8-bit-pusab.ttf', 16) -- Adicionado: Fonte para botões
    Utils.fonts.small = love.graphics.newFont('assets/fonts/8-bit-pusab.ttf', 10)
    Utils.fonts.smaller = love.graphics.newFont('assets/fonts/8-bit-pusab.ttf', 8)
end

function Utils.drawCursor()
    local x, y = love.mouse.getPosition()
    if Utils.cursorImage then
        love.graphics.draw(Utils.cursorImage, x, y)
    end
end

function Utils.drawPauseOverlay()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function Utils.drawNPCDialogue(text)
    local NPC = require("core.npc")
    local x, y = NPC.data.x, NPC.data.y
    
    if Utils.balloonImage then
        love.graphics.draw(Utils.balloonImage, x - 100, y - 100)
    end
    
    love.graphics.setFont(Utils.fonts.smaller)
    love.graphics.printf(text, x - 80, y - 80, 150, "center")
    love.graphics.setColor(1, 1, 1, 1)
end

function Utils.printPlayerPosition()
    local Player = require("core.player")
    print(string.format("Player Position: x=%.2f, y=%.2f", Player.data.x, Player.data.y))
end

return Utils