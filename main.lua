WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT= 234

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'


require 'Ball'
require 'Paddle'

function love.load()
    love.window.setTitle('Pong')

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf',12)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    player1Score = 0
    player2Score = 0

    player1 = Paddle(5, 20, 5   , 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 5 ,5)
    



    gameState = 'start'


    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = false,
    }) 
    
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
    --     fullscreen = false,
    --     vsync = true,
    --     resizable= false   
    -- })
end     


function love.update(dt)
    
    if gameState == 'play' then 

        if ball.x <= 0 then
            player2Score = player2Score + 1
            ball:reset()
            gameState = 'start'
        end

        if ball.x >= VIRTUAL_WIDTH then
            player1Score = player1Score +1
            ball:reset()
            gameState = 'start'
        end

        if ball:collides(player1) then
            ball.dx = -ball.dx
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx
        end

        if ball.y <= 0 then
            ball.dy = -ball.dy
            ball.y = 0
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.dy = -ball.dy
            ball.y = VIRTUAL_HEIGHT - 4
        end

        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end

        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0 
        end

        ball:update(dt)
        player1:update(dt)
        player2:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()

    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then
            gameState = 'play'
        end              
    end
end


function love.draw()
    push: apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    ball:render()

    player1:render()
    player2:render()  

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
    
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf("Hello Start State Pong !", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Hello Play State Pong !", 0, 20, VIRTUAL_WIDTH, 'center')
    end


    displayFPS()

    push:apply('end')     
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1,1,1,1)
end