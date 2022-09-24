-- bubble

pop_time = 15

bubble = {

  new = function(self, x)

    local o = {
      animation = animation:new('animation', { 72, 73 }, 30, true),
      pop_sprite = 74,
      anchor_x = x + 4,
      sine = 0,
      x = x,
      y = 143,
      popped = false,
      popped_count = 0,
      body = { x = x, y = 120, width = 8, height = 8 },

      draw = function(self)
        spr(self.sprite, self.x, self.y)
      end,

      pop = function(self)
        debug.message = 'pop'
        if self.popped == false then
          scores:new(self.x, self.y, 500)
          self.popped = true
          self.popped_count = pop_time
          sfx(0)
        end
      end,

      update_body = function(self)
        self.body.x = self.x
        self.body.y = self.y
      end,

      update = function(self)
        if self.popped then
          self.sprite = 74
          self.popped_count -= 1
        else
          self.sprite = self.animation:get()
        end
        self.y -= 0.5
        self.sine += 0.01
        self.x = self.anchor_x + sin(self.sine) * 5
        self:update_body()
      end
    }

    add(bubbles, o)

  end,

}
