-- game over

over = {

    init = function(self)
        _draw = self.draw
        _update = self.update
    end,

    draw = function()
        cls(bgcolor)
        bgstars:draw()
        level:draw_bg()
        level:draw_fg()
        enemies:draw()
        print('game over', 0, 0)
    end,

    update = function()
        if btnp(4) or btnp(5) then
            menu:init()
        end
    end

}
