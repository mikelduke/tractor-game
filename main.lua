debug = false

screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

mousedown = false

tractor = {
    image = love.graphics.newImage('assets/TRAKTOR.png'),
    scaleX = 1,
    scaleY = 1,
    x = -100,
    y = -100,
    dx = 0,
    dy = 0
}

hay = {
    image = love.graphics.newImage('assets/hay.png')
}

dirt = {
    image = love.graphics.newImage('assets/dirt1.png')
}

cutPath = {
    width = tractor.image:getWidth() * tractor.scaleX * .8,
    height = tractor.image:getHeight() * tractor.scaleY * .6,
}

function love.load(arg)
    love.mouse.setVisible(false)
    setScale()

    world = love.physics.newWorld(0, 0)

    -- createPlayer()

    reset()
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
end

function love.draw(dt)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(dirtCanvas)
    love.graphics.draw(hayCanvas)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(tractor.image, 
            tractor.x, 
            tractor.y, 
            0,
            tractor.orientation, -- scalex or -scalex
            tractor.scaleY,
            tractor.image:getWidth() * tractor.scaleX / 2,
            tractor.image:getHeight() * tractor.scaleY / 2)

    if debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("DT: " .. tostring(love.timer.getDelta()), 10, 10)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 20)
    end
end

function setScale()
    local width, height = love.graphics.getDimensions()
    sx = width / 1920
    sy = height / 1080
    tractor.scaleX = tractor.scaleX * sx
    tractor.scaleY = tractor.scaleY * sy
end


function reset()
    hayCanvas = love.graphics.newCanvas(love.graphics.getWidth(),
                                love.graphics.getHeight())
    love.graphics.setCanvas(hayCanvas)

    love.graphics.setBackgroundColor(0,1,0)
    love.graphics.setColor(1, 1, 1)

    for y = 0, screenHeight, hay.image:getHeight() do
        for x = 0, screenWidth, hay.image:getWidth() do
            love.graphics.draw(hay.image, x, y)
        end
    end

    dirtCanvas = love.graphics.newCanvas(love.graphics.getWidth(),
                                love.graphics.getHeight())
    love.graphics.setCanvas(dirtCanvas)

    love.graphics.setBackgroundColor(0,1,0)
    love.graphics.setColor(1, 1, 1)

    for y = 0, screenHeight, dirt.image:getHeight() do
        for x = 0, screenWidth, dirt.image:getWidth() do
            love.graphics.draw(dirt.image, x, y)
        end
    end

    love.graphics.setCanvas()
end

-- touch and mouse

function love.mousepressed(x, y, button, istouch, presses)
    mousedown = true
end

function love.mousemoved(x, y, dx, dy, istouch)
    if mousedown then
        love.touchmoved("m", x, y, dx, dy)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    mousedown = false
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    -- love.mousepressed(x,y)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    moveTractor(x, y, dx, dy)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    -- love.mousereleased(x, y)

end


-- keyboard

function love.keypressed(key, scancode, isrepeat)
    if key == 'd' and not isrepeat then 
        debug = not debug 
        love.mouse.setVisible(debug)
    end

    if key == 'escape' then
        love.event.push('quit')
    elseif key == 'r' then
        reset()
    end
end

function moveTractor(x, y, dx, dy)
    tractor.x = x
    tractor.y = y
    tractor.dx = dx
    tractor.dy = dy
    tractor.orientation = tractor.scaleX * math.sign(tractor.dx) * -1
    if tractor.orientation == 0 then 
        tractor.orientation = tractor.scaleX
    end

    love.graphics.setCanvas(hayCanvas)
    
    -- tractor path
    love.graphics.setColor(1,1,1)
    local cutx = x - 2
    local cuty = y + 16
    local dirtQuad = love.graphics.newQuad(cutx - cutPath.width / 2, cuty - cutPath.height / 2, cutPath.width, cutPath.height, dirtCanvas:getDimensions())
    love.graphics.draw(dirtCanvas, dirtQuad, cutx - cutPath.width / 2, cuty - cutPath.height / 2)

    love.graphics.setCanvas()
end

function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end
