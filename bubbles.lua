-- bubbles

bubbles = {
    poptime = 2,
    sprs = { 72, 73, 74 },

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
            if collision(bubble.body, player.body) and bubble.pop == -1 then
                scores:new(bubble.x, bubble.y, 'bubble')
                bubble.pop = self.poptime
            elseif bubble.y < -8 or bubble.pop == 0 then
                del(self, bubble)
            end
        end
    end,

    new = function(self, x)

        local bubble = {

            anim = 1,
            anchor_x = x + 4,
            sine = 0,
            x = x,
            y = 143,
            pop = -1,

            draw = function(self)
                local sprite = bubbles.sprs[self.anim]
                if self.pop > 0 then
                    sprite = bubbles.sprs[3]
                end
                spr(sprite, self.x, self.y)
            end,

            update = function(self)
                if ticks % 30 == 0 then
                    self.anim += 1
                    if self.anim > 2 then
                        self.anim = 1
                    end
                end
                if self.pop > 0 then
                    self.pop -= 1
                end
                self.y -= 0.5
                self.sine += 0.01
                self.x = self.anchor_x + sin(self.sine) * 5
                self.body = {
                    y = self.y,
                    x = self.x,
                    width = 8,
                    height = 8
                }
            end

        }

        add(self, bubble)

    end

}
