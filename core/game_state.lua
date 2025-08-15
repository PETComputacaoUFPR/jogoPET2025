local GameState = {}

GameState.game = {
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false,
    },
}

function GameState.changeGameState(state)
    GameState.game.state["menu"] = state == "menu"
    GameState.game.state["ended"] = state == "ended"
    GameState.game.state["running"] = state == "running"
    GameState.game.state["paused"] = state == "paused"
end

function GameState.startNewGame()
    local Schoolbus = require("core.schoolbus")
    GameState.changeGameState("running")
    Schoolbus.startIntro()
end

function GameState.is(state)
    return GameState.game.state[state]
end

return GameState