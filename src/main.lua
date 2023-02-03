push = require 'push'

Class = require 'class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle("PONG")
    
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)
    
    love.graphics.setFont(smallFont)
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    
    player1 = Paddle(1, 10, 30, 5, 20)
    player2 = Paddle(2, VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = 'start'
end

function love.update(dt)
    if gameState == 'play' then
        if ball:collides(player1) then
            ball = updateBallOnCollision(ball, player1)
        end

        if ball:collides(player2) then
            ball = updateBallOnCollision(ball, player2)
        end

        ball = detectXBoundaryCollision(ball)

        ball:update(dt)
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else 
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key=='enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'

            ball:reset()
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    displayFPS()

    if gameState == 'start' then
        love.graphics.printf('Start', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Play', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    player1:render()
    player2:render()

    ball:render()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function updateBallOnCollision(ball, player)
    newBall = ball

    newBall.dx = -ball.dx * 1.03
    newBall.x = player.id == 1 and player.x + 5 or player.x - 4

    newBall.dy = ball.dy < 0 and -math.random(10, 150) or math.random(10, 150)

    return newBall
end

function detectXBoundaryCollision(ball)
    newBall = ball

    if newBall.y <= 0 then
        newBall.y = 0
        newBall.dy = -newBall.dy
    end

    if newBall.y >= VIRTUAL_HEIGHT - 4 then
        newBall.y = VIRTUAL_HEIGHT - 4
        newBall.dy = -newBall.dy
    end

    return newBall
end