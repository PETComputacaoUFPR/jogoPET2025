local Audio = {}

Audio.sounds = {}

function Audio.load()
    Audio.sounds.blip = love.audio.newSource('assets/sounds/blip.mp3', 'static')
    Audio.sounds.music = love.audio.newSource('assets/sounds/smw_bonus.mp3', 'stream')
    Audio.sounds.music:setLooping(true)
end

function Audio.playMusic()
    if Audio.sounds.music then
        Audio.sounds.music:play()
    end
end

function Audio.stopMusic()
    if Audio.sounds.music then
        Audio.sounds.music:stop()
    end
end

function Audio.playBlip()
    if Audio.sounds.blip then
        Audio.sounds.blip:play()
    end
end

return Audio