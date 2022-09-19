body = {
    new = function(self, x, y, width, height)
        local o = {
            x = x,
            y = y,
            width = width,
            height = height
        }
        return o
    end
}

kinematic_body = {
    new = function(self, x, y, width, height)
        local o = body:new(x, y, width, height)
        o.kind = 'kinematic_body'
        function o:update()
            self.y += world.gravity
        end
        function o:apply_force(x, y)
            self.x += x
            self.y += y

        end
        add(world.kinematic_bodies, o)
    end
}

static_body = {
    new = function(self, x, y, width, height)
    
    end
}

world = {
    gravity = 0.1,
    static_bodies = {},
    kinematic_bodies = {}
}