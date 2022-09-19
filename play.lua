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
        if ticks > 1 then
            fish:draw()
            bgstars:draw()
            level:draw_bg()
            osd:draw()
            splashes:draw()
            level:draw_fg()
            enemies:draw()
            player:draw()
            bubbles:draw()
            scores:draw()
            debug:draw()
        end
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
