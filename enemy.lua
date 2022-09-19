-- enemy

inflate_time = 30

local enemy = {
  
  new = function(self, x, y)

    local dir = randdir()
    
    local o = {
      x = x,
      y = y,
      caught = false,
      dir = dir,
      pump = 1,
      balloon = false,
      bumped = 0,
      grounded = true,
      popped = 0,
      timer = 0,
      dead = false,
      safe = 100,
      anim = {
        move = 1,
        para = 1,
        pump = 1
      },
      ball_body = {
        x = x,
        y = y,
        width = 8,
        height = 8
      },
      foot_body = {
        x = x,
        y = y + 8,
        width = 8,
        height = 8
      },
      body = {
        x = x,
        y = y,
        width = 8,
        height = 16
      },
      vel = {
        x = dir * rnd() + 0.25,
        y = -1 * rnd() + 0.25
      },
      sprite = 72,
      --[[
      sprites = {
        ball = { 226, 227, 242 },
        dead = 224,
        fall = { 202, 204, 206 },
        flying = { 196, 198, 200, 198 },
        pump = { 192, 194 },
      },
      ]]
      animations = {
        balloon = animation:new( 'balloon', {226, 227, 242}, inflate_time, true ),
        pumping = animation:new( 'pumping', {192, 194}, 5, true ),
        flapping = animation:new( 'flapping', {196, 198, 200, 198}, 3, true ),
        falling = animation:new( 'falling', {202, 204, 206}, 5, false ),
      },
      turncount = 0,

      animate = function(self)
        if self.dead then
          self.sprite = 224
        elseif self.grounded then
          self.sprite = self.animations.pumping:get()
        elseif self.balloon then
          if self.vel.y > 0 then
            self.sprite = self.animations.flapping:get(1)
          else
            self.sprite = self.animations.flapping:get()
          end
        else
          self.sprite = self.animations.falling:get()
        end
      end,

      collision_enemies = function(self)
        for enemy in all(enemies) do
          if self ~= enemy and collision(self.body, enemy.body) and self.turncount == 0 then
            self.vel.x = -self.vel.x
            self.turncount = enemies.turntime
          end
        end
      end,

      collision_fish = function(self)
        if collision(self, fish) then
          self.caught = true
        end
      end,

      collision_level = function(self)
        if self.y < 0 then
          self.vel.y = abs(self.vel.y)
        elseif not self.balloon and
            self.y > 120 then
          self.vel.y = -abs(self.vel.y)
        end
        local test_body = {}
        test_body.width = self.body.width
        test_body.height = self.body.height
        test_body.x = self.body.x
        test_body.y = self.body.y
        test_body.y += self.vel.y
        local v_coll = level:collision(test_body)
        if v_coll then
          if self.balloon then
            self.vel.y = -self.vel.y
          else
            self.grounded = true
          end
        end
        test_body.x = self.body.x
        test_body.y = self.body.y
        test_body.x += self.vel.x
        local h_coll = level:collision(test_body)
        if h_coll then
          self.vel.x = -self.vel.x
          self.turncount = enemies.turntime
        end
      end,

      collision_player = function(self)
        if collision(self.ball_body, player.foot_body) then
          if self.safe < 1 then
            scores:new(self.x, self.y, 'air')
            self:pop()
            player.vel.y = -1
            player.vel.x = -player.vel.x / 2
            self.safe = 10
          end
        elseif collision(self.foot_body, player.ball_body) and self.balloon then
          player:pop()
          self.vel.y = -1
          self.vel.x = -self.vel.x / 2
        elseif collision(self.body, player.body) then
          player.vel.x = -player.vel.x / 2
          self.vel.x = -self.vel.x / 2
        end
      end,

      draw = function(self)
        if self.grounded and not self.dead then
          local sprite = self.animations.balloon:get()
          spr(sprite, self.x - 4, self.y + 10)
        end
        local flip_x = false
        if self.dir == right and self.balloon then
          flip_x = true
        end
        spr(self.sprite, self.x, self.y, 2, 2, flip_x)
        debug:draw_body(self.body, 10)
        debug:draw_body(self.ball_body, 12)
        debug:draw_body(self.foot_body, 8)
      end,

      move = function(self)
        if self.vel.x < 1 and self.vel.x > -1 then
          self.vel.x *= 1.1
        end
        self.y += self.vel.y
        self.x += self.vel.x
        if self.vel.x < 0 then
          self.dir = left
        elseif self.vel.x > 0 then
          self.dir = right
        end
      end,

      pop = function(self)
        if self.popped == 0 then
          if self.balloon then
            self.balloon = false
            self.anim.para = 1
            self.vel.y = 0.5
            self.popped = pop_delay
          else
            self.dead = true
          end
        end
      end,

      update_body = function(self)
        self.body.x = self.x + 3
        if self.direction == right then
          self.body.x += 1
        end
        self.body.y = self.y
        self.ball_body.x = self.body.x
        self.ball_body.y = self.body.y
        self.foot_body.x = self.body.x
        self.foot_body.y = self.body.y + 8
      end,

      update = function(self)
        if self.safe > 0 then
          self.safe -= 1
        end
        if self.turncount > 0 then
          self.turncount -= 1
        end
        if self.caught then
          self.x = fish.x
          self.y = fish.y
          if not fish.active then
            self.dead = true
          end
        elseif self.dead then
          if self.y > 127 then
            if not self.offscreen then
              bubbles:new(self.x)
              splashes:new(self.x)
            end
            self.offscreen = true
          else
            self.y += 2
          end
        elseif self.grounded then
          if not self.balloon then
            if ticks % inflate_time == 0 then
              if self.pump < 3 then
                self.pump += 1
              else
                self.grounded = false
                self.balloon = true
                self.pump = 1
              end
            end
          end
          if collision(self.body, player.body) then
            scores:new(self.x, self.y, 'ground')
            self.dead = true
          end
        else
          self:collision_level()
          self:collision_enemies()
          self:collision_player()
          self:move()
          wrap(self)
        end
        self:update_body()
        self:animate()
        if self.popped > 0 then
          self.popped -= 1
        end
      end,
    }

    add(enemies, o)

  end
}
