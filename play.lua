-- play mode

play = {

    init = function(self)
        ticks = 0
        bgstars:init()
        player:reset()
        enemies:init()
        bubbles:init()
        scores:init()
        level:get()
        self.finish_count = 0
        _update = self.update
        _draw = self.draw
    end,

    draw = function()
        cls(bgcolor)
        collisions:update()
        fish:draw()
        bgstars:draw()
        level:draw_bg()
        osd:draw()
        splashes:draw()
        enemies:draw()
        player:draw()
        level:draw_fg()
        bubbles:draw()
        scores:draw()
        debug:draw()
    end,

    update = function()
        ticks = ticks + 1
        input:update()
        splashes:update()
        bubbles:update()
        bgstars:update()
        enemies:update()
        fish:update()
        player:update()
        scores:update()
        debug:update()
    end

}
