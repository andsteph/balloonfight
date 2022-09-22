-- balloon

balloon = {

    new = function(self, x, y)

        local o = {
            anchor_x = x,
            x = x,
            y = y,
            sine = 0,
            body = { y = 0, x = 0, width = 8, height = 8 },

            draw = function(self)
                spr(62, self.x, self.y)
            end,

            update = function(self)
                self.y -= 1
                self.sine += 0.01
                self.x = self.anchor_x + sin(self.sine) * 5
                self.body.x = self.x
                self.body.y = self.y
            end
        }

        add(balloons, o)

    end

}
