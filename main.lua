debug = true
mousedown = false

cutsize = {
    width = 60,
    height = 40
}

tractor = {
    image = love.graphics.newImage('assets/TRAKTOR.png'),
    scaleX = .4,
    scaleY = .4,
    x = -100,
    y = -100,
    dx = 0,
    dy = 0
}

function love.load(arg)
    reset()
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
end

function love.draw(dt)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(c)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(tractor.image, tractor.x, tractor.y, 
            0,
            tractor.orientation, tractor.scaleY, 
            tractor.image:getWidth() * tractor.scaleX, tractor.image:getHeight() * tractor.scaleY)

    if debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("DT: " .. tostring(love.timer.getDelta()), 10, 10)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 20)
    end
end

function reset()
    c = love.graphics.newCanvas(love.graphics.getWidth(),
                                love.graphics.getHeight())
    love.graphics.setBackgroundColor(0,1,0)
end

-- touch and mouse

function love.mousepressed(x, y, button, istouch, presses)
    mousedown = true
end

function love.mousemoved(x, y, dx, dy, istouch)
    if mousedown then
        moveTractor(x, y, dx, dy)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    mousedown = false
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    love.mousepressed(x,y)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    love.mousemoved(x, y, dx, dy)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    love.mousereleased(x, y)
end


-- keyboard

function love.keypressed(key, scancode, isrepeat)
    if key == 'd' and not isrepeat then debug = not debug end

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

    love.graphics.setCanvas(c)
    
    -- tractor path
    love.graphics.setColor(0, 0, 0)
    local cutx = x - 2
    local cuty = y + 16
    love.graphics.rectangle("fill", cutx - cutsize.width / 2, cuty - cutsize.height / 2, cutsize.width, cutsize.height)

    love.graphics.setCanvas()
end

function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end