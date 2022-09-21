-- splash

splash = {

  new = function(self, x)

    local o = {
      x = x,
      y = 116,
      animation = animation:new('animation', { 32, 33, 48, 49 }, 4, false),
      sprite = 32,

      draw = function(self)
        spr(self.sprite, self.x, self.y)
      end,

      update = function(self)
        self.sprite = self.animation:get()
      end,

    }

    add(splashes, o)

  end,
}
