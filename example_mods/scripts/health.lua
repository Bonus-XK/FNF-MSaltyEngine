function onCreatePost()
    makeLuaSprite('Health', 'healthbar-sn')
    setObjectCamera('Health', 'hud')
    addLuaSprite('Health', true)
    setObjectOrder('Health',getObjectOrder('healthBar') + 1)
    scaleObject('Health',1,1)
    setProperty('healthBar.visible', true)
end

function onUpdatePost(elapsed)
    setProperty('Health.x', getProperty('healthBar.x') - 14)
    setProperty('Health.y', getProperty('healthBar.y') - 28)
end