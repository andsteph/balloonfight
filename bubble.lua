-- bubble

bubble = {

  new = function(self, x)

    local o = {
      animation = animation:new('animation', { 72, 73 }, 30, true),
      pop_sprite = 74,
      anchor_x = x + 4,
      sine = 0,
      x = x,
      y = 143,
      pop = -1,
      pop_time = 2,
      body = { x = x, y = y, width = 8, height = 8 },

      draw = function(self)
        spr(self.sprite, self.x, self.y)
      end,

      update = function(self)
        if self.pop > 0 then
          self.pop -= 1
          self.sprite = 74
        else
          self.sprite = self.animation:get()
        end
        self.y -= 0.5
        self.sine += 0.01
        self.x = self.anchor_x + sin(self.sine) * 5
        self.body.x = self.x
        self.body.y = self.y
        if collision(self.body, player.body) and self.pop == -1 then
          scores:new(self.x, self.y, 'bubble')
          self.pop = self.pop_time
        end
      end
    }

    add(bubbles, o)

  end,

}
