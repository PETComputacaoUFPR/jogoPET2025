local Buttons = {}

-- Esta é uma função construtora local para criar um unico objeto botão
-- Só é utilizada neste arquivo
local function createButton(text, func, func_param, width, height)
    return {
        width = width or 100,
        height = height or 100,
        func = func or function() print("Esse botão ainda não tem uma função!") end,
        func_param = func_param,
        text = text or "Sem texto",
        button_x = 0,
        button_y = 0,
        text_x = 0,
        text_y = 0,

        checkPressed = function(self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
                if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then -- Corrigido: 'heigth' para 'height'
                    if self.func_param then
                        self.func(self.func_param)
                    else
                        self.func()
                    end
                end
            end
        end,

        draw = function(self, button_x, button_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y
            
            -- Desenha o retângulo do botão
            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)

            -- Desenha o texto
            love.graphics.setColor(0, 0, 0)

            -- Pega as fontes disponíveis no módulo de utilidades
            local Utils = require("core.utils")
            local default_font = Utils.fonts.button
            local small_font = Utils.fonts.small -- A fonte menor para quando o texto não couber

            local active_font = default_font

            -- Verifica se o texto é largo demais para o botão com a fonte padrão
            -- O "- 10" adiciona uma pequena margem de segurança nas laterais
            if default_font:getWidth(self.text) > self.width - 10 then
                active_font = small_font
            end

            -- Define a fonte escolhida (padrão ou pequena) como a ativa
            love.graphics.setFont(active_font)

            -- Calcula a posição Y para centralizar o texto verticalmente com a fonte ativa
            local fontHeight = active_font:getHeight()
            local text_y = self.button_y + (self.height - fontHeight) / 2

            -- Usa printf para desenhar o texto centralizado horizontalmente
            love.graphics.printf(self.text, self.button_x, text_y, self.width, "center")

            -- Reseta a cor para branco
            love.graphics.setColor(1, 1, 1)
        end
    }
end

-- Tabela que salva todas as intancias do botão para o jogo
Buttons.menuButtons = {}
Buttons.pauseButtons = {}

-- Esta funções cria todos os botões que o jogo precisa
function Buttons.load(cam)
    local GameState = require("core.game_state")
    local Audio = require("core.audio")

    -- Cria os botões do menu usando a função construtora local
    Buttons.menuButtons.play = createButton("Jogar", function()
        GameState.startNewGame()
        Audio.playBlip()
    end, nil, 200, 50)

    Buttons.menuButtons.settings = createButton("Ajustes", function()
        print("Ajustes clicado")
    end, nil, 200, 50)

    Buttons.menuButtons.exit = createButton("Sair", function()
        love.event.quit()
    end, nil, 200, 50)

    -- Cria os botões de pausa
    Buttons.pauseButtons.resume = createButton("Retornar", function()
        GameState.changeGameState("running")
    end, nil, 200, 50)

    Buttons.pauseButtons.exitMenu = createButton("Sair para o Menu", function()
        GameState.changeGameState("menu")
        -- Reseta a posição da camera
        if cam then
            local w, h = love.graphics.getWidth(), love.graphics.getHeight()
            cam:lookAt(w / 2, h / 2)
        end
    end, nil, 200, 50)
end

-- Esta função desenha os botões corretos baseada no estado do jogo
function Buttons.draw()
    local GameState = require("core.game_state")
    local Utils = require("core.utils")

    -- Define a fonte para todos os botões que serão desenhados
    if Utils.fonts and Utils.fonts.button then
        love.graphics.setFont(Utils.fonts.button)
    end

    if GameState.is("menu") then
        Buttons.menuButtons.play:draw(300, 200)
        Buttons.menuButtons.settings:draw(300, 300)
        Buttons.menuButtons.exit:draw(300, 400)
    elseif GameState.is("paused") then
        Utils.drawPauseOverlay()
        Buttons.pauseButtons.resume:draw(300, 200)
        Buttons.pauseButtons.exitMenu:draw(300, 300)
    end
end

-- This function handles clicks for the correct set of buttons
function Buttons.handleMousePress(x, y)
    local GameState = require("core.game_state")
    local buttonsToCheck = {}

    if GameState.is("menu") then
        buttonsToCheck = Buttons.menuButtons
    elseif GameState.is("paused") then
        buttonsToCheck = Buttons.pauseButtons
    end

    for _, b in pairs(buttonsToCheck) do
        b:checkPressed(x, y, 0)
    end
end

-- Retorna a tabela de botões principais, que contem todas as funções de gerenciamento
return Buttons