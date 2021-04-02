debug = false

screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

mousedown = false

world = nil
objects = {}

tractor = {
    img = nil,
    touchid = nil,
    scaleX = 1,
    scaleY = 1,
    width = 0,
    height = 0,
}

images = {
    tractor = love.graphics.newImage('assets/TRAKTOR.png'),
    hay = love.graphics.newImage('assets/hay.png'),
    dirt = love.graphics.newImage('assets/dirt1.png')
}

cutPath = {
    width = images.tractor:getWidth() * tractor.scaleX * .8,
    height = images.tractor:getHeight() * tractor.scaleY * .6,
}

function love.load(arg)
    love.mouse.setVisible(false)
    setScale()

    world = love.physics.newWorld(0, 0)

    createTractor()

    reset()
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    world:update(dt)
end

function love.draw(dt)
    updateTractorPath()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(dirtCanvas)
    love.graphics.draw(hayCanvas)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(tractor.img, 
            tractor.body:getX(), 
            tractor.body:getY(), 
            0,
            tractor.orientation, -- scalex or -scalex
            1,
            tractor.width / 2,
            tractor.height / 2)

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
    tractor.width = images.tractor:getWidth() * tractor.scaleX
    tractor.height = images.tractor:getHeight() * tractor.scaleY
end


function reset()
    hayCanvas = love.graphics.newCanvas(love.graphics.getWidth(),
                                love.graphics.getHeight())
    love.graphics.setCanvas(hayCanvas)

    love.graphics.setBackgroundColor(0,1,0)
    love.graphics.setColor(1, 1, 1)

    for y = 0, screenHeight, images.hay:getHeight() do
        for x = 0, screenWidth, images.hay:getWidth() do
            love.graphics.draw(images.hay, x, y)
        end
    end

    dirtCanvas = love.graphics.newCanvas(love.graphics.getWidth(),
                                love.graphics.getHeight())
    love.graphics.setCanvas(dirtCanvas)

    love.graphics.setBackgroundColor(0,1,0)
    love.graphics.setColor(1, 1, 1)

    for y = 0, screenHeight, images.dirt:getHeight() do
        for x = 0, screenWidth, images.dirt:getWidth() do
            love.graphics.draw(images.dirt, x, y)
        end
    end

    love.graphics.setCanvas()
end

-- touch and mouse

function love.mousepressed(x, y, button, istouch, presses)
    mousedown = true
    love.touchpressed("m", x, y)
end

function love.mousemoved(x, y, dx, dy, istouch)
    if mousedown then
        love.touchmoved("m", x, y, dx, dy)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    mousedown = false
    love.touchreleased("m", x, y)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    if (tractor.touchid == nil) then
        tractor.touchid = id
        tractor.joint:setTarget(x, y)
    end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    if (tractor.touchid == id) then
        tractor.joint:setTarget(x, y)
    end
    orientTractor(x, y, dx, dy)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if (tractor.touchid == id) then
        tractor.touchid = nil
    end
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

function orientTractor(x, y, dx, dy)
    tractor.orientation = math.sign(dx) * -1
    if tractor.orientation == 0 then 
        tractor.orientation = -1
    end
end

function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

function createTractor()
    tractor.img = scale(images.tractor, tractor.scaleX, tractor.scaleY)
    
    tractor.body = love.physics.newBody(world, love.mouse.getX(), love.mouse.getY(), "dynamic")
    tractor.shape = love.physics.newRectangleShape(tractor.width, tractor.height)
    tractor.fixture = love.physics.newFixture(tractor.body, tractor.shape)
    tractor.joint = love.physics.newMouseJoint(tractor.body, love.mouse.getPosition())

    table.insert(objects, tractor)
end

function scale(img, ratioX, ratioY)
    local c = love.graphics.newCanvas(img:getWidth() * ratioX,
                                      img:getHeight() * ratioY)
    love.graphics.setCanvas(c)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(img, 0, 0, 0, ratioX, ratioY)
    love.graphics.setCanvas()

    return c
end

function calcAngle(o1, o2)
    return -math.atan2(o1.body:getX() - o2.body:getX(),
                       o1.body:getY() - o2.body:getY())
end

function updateTractorPath()
    love.graphics.setCanvas(hayCanvas)
    love.graphics.setColor(1,1,1)
    local cutx = tractor.body:getX() - 2
    local cuty = tractor.body:getY() + 16
    local dirtQuad = love.graphics.newQuad(cutx - cutPath.width / 2, cuty - cutPath.height / 2, cutPath.width, cutPath.height, dirtCanvas:getDimensions())
    love.graphics.draw(dirtCanvas, dirtQuad, cutx - cutPath.width / 2, cuty - cutPath.height / 2)
    love.graphics.setCanvas()
end
