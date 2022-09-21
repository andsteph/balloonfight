-- bubbles

bubbles = {

    init = function(self)
        for bubble in all(self) do
            del(self, bubble)
        end
    end,

    draw = function(self)
        for bubble in all(self) do
            bubble:draw()
        end
    end,

    update = function(self)
        for bubble in all(self) do
            bubble:update()
            if bubble.y < -8 or bubble.pop == 0 then
                del(self, bubble)
            end
        end
    end,

}
