-- finish mode ----------------
finish = {

    init = function(self)
        self.timer = 60
        _update = self.update
        _draw = self.draw
    end,

    draw = function()
        cls(bgcolor)
        bgstars:draw()
        fish:draw()
        level:draw_bg()
        osd:draw()
        enemies:draw()
        level:draw_fg()
        bubbles:draw()
        player:draw()
    end,

    update = function()
        self = finish
        self.timer -= 1
        if self.timer < 0 then
            for enemy in all(enemies) do
                del(enemies, enemy)
            end
            level.current += 1
            if level.current % 4 == 0 then
                bonus:init()
            else
                play:init()
            end
        end
    end

}
