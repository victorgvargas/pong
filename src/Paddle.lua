Paddle = Class{}

function Paddle:init(id, x, y, width, height)
    self.id = id
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else 
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end