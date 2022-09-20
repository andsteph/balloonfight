-- balloon

balloon = {

    new = function(self, x, y)

        local o = {
            anchor_x = x,
            x = x,
            y = y,
            sine = 0,

            draw = function(self)
                spr(62, self.x, self.y)
            end,

            update = function(self)
                self.y -= 1
                self.sine += 0.01
                self.x = self.anchor_x + sin(self.sine) * 5
                self.body = { y = self.y, x = self.x, width = 8, height = 8 }
            end
        }

        return o

    end

}
