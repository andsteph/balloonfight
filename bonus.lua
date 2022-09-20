-- bonus mode

bonus = {

    balloons = {},
    balloon_max = 20,
    delay = 30,
    pipes = {
        { col = 2, row = 13 },
        { col = 5, row = 12 },
        { col = 10, row = 14 },
        { col = 13, row = 13 }
    },

    init = function(self)
        self.timer = 0
        self.counter = 0
        self.collected = 0
        bgstars:init()
        level:get(0)
        player:reset()
        _update = self.update
        _draw = self.draw
    end,

    draw = function()
        self = bonus
        cls(bgcolor)
        bgstars:draw()
        for ball in all(self.balloons) do
            ball:draw()
        end
        level:draw_bg()
        level:draw_fg()
        osd:draw()
        player:draw()
        debug:draw()
    end,

    new_balloon = function(self)
        local n = flr(rnd(4)) + 1
        local pipe = self.pipes[n]
        local x = pipe.col * 8
        local y = pipe.row * 8
        add(self.balloons, balloon:new(x, y))
        self.counter += 1
    end,

    update = function()
        self = bonus
        ticks = ticks + 1
        self.timer += 1
        if self.timer > self.delay then
            if self.counter >
                self.balloon_max then
                if count(self.balloons) == 0 then
                    tally:init()
                end
            else
                self:new_balloon()
            end
            self.timer = 0
        end
        bgstars:update()
        for ball in all(self.balloons) do
            ball:update()
            if ball.y < -8 then
                del(self.balloons, ball)
            end
            if collision(player.body,
                ball.body) then
                self.collected += 1
                del(self.balloons, ball)
            end
        end
        input:update()
        player:update()
        debug:update()
    end

}
