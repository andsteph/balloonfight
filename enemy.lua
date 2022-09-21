-- enemy

local enemy = {
  
  new = function(self, x, y)

    local dir = randdir()
    
    local o = {
      x = x,
      y = y,
      dir = dir,
      pump = 1,
      pop_timer = 0,
      ball_body = { x = x, y = y, width = 8, height = 8 },
      foot_body = { x = x, y = y + 8, width = 8, height = 8 },
      body = { x = x, y = y, width = 8, height = 16 },
      vel = { x = 0, y = 0 },
      animations = {
        balloon = animation:new( 'balloon', {226, 227, 242}, inflate_time, true ),
        pumping = animation:new( 'pumping', {192, 194}, 5, true ),
        flapping = animation:new( 'flapping', {196, 198, 200, 198}, 3, true ),
        falling = animation:new( 'falling', {202, 204, 206}, 5, false ),
      },
      turncount = 0,
      state = 'pumping',

      animate = function(self)
        if self.state == 'pumping' then
          self.sprite = self.animations.pumping:get()
        elseif self.state == 'flying' then
          if self.vel.y > 0 then
            self.sprite = self.animations.flapping:get(1)
          else
            self.sprite = self.animations.flapping:get()
          end          
        elseif self.state == 'falling' then
          self.sprite = self.animations.falling:get()
        elseif self.state == 'caught' then

        elseif self.state == 'dead' then
          self.sprite = 224
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
          if self.state == 'flying' then
            self.vel.y = -self.vel.y
          else
            self.vel.x = 0
            self.vel.y = 0
            self.state = 'pumping'
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

      draw = function(self)
        if self.state == 'pumping' then
          local sprite = self.animations.balloon:get()
          spr(sprite, self.x - 4, self.y + 10)
        end
        local flip_x = false
        if self.dir == right and self.balloon then
          flip_x = true
        end
        spr(self.sprite, self.x, self.y, 2, 2, flip_x)
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

      update_pumping = function(self)
        if ticks % inflate_time == 0 then
          if self.pump < 3 then
            self.pump += 1
          else
            self.vel.x = dir * rnd() + 0.25
            self.vel.y = -1 * rnd() + 0.25
            self.state = 'flying'
            self.pump = 1
          end
        end
        if collision(self.body, player.body) then
          scores:new(self.x, self.y, 750)
          self.state = 'dead'
        end
      end,

      update_flying = function(self)
        if self.vel.x < 1 and self.vel.x > -1 then
          self.vel.x *= 1.1
        end
        if self.vel.x < 0 then
          self.dir = left
        elseif self.vel.x > 0 then
          self.dir = right
        end
        if collision(self.body, player.foot_body) then
          player.vel.y = -1
          player.vel.x = -player.vel.x / 2
          self.vel.y = float
          self.pop_timer = pop_delay
          self.state = 'falling'
        elseif collision(self.body, player.body) then
          player.vel.x = -player.vel.x / 2
          self.vel.x = -self.vel.x / 2
        end
        self:collision_level()
        self:collision_enemies()
      end,

      update_falling = function(self)
        if self.pop_timer > 0 then
          self.pop_timer -= 1
        else
          if collision(self.ball_body, player.foot_body) then
            scores:new(self.x, self.y, 750)
            player.vel.y = -1
            player.vel.x = -player.vel.x / 2
            self.state = 'dead'
          end
        end
        self:collision_level()
        self:collision_enemies()
      end,

      update_caught = function(self)
        self.x = fish.x
        self.y = fish.y
        if not fish.active then
          self.dead = true
        end
      end,

      update_dead = function(self)
        if self.y > 127 then
          if not self.offscreen then
            bubble:new(self.x)
            splash:new(self.x)
          end
          self.offscreen = true
        else
          self.y += 2
        end
      end,

      update = function(self)
        if self.state == 'pumping' then
          self:update_pumping()
        elseif self.state == 'flying' then
          self:update_flying()
        elseif self.state == 'falling' then
          self:update_falling()
        elseif self.state == 'caught' then
          self:update_caught()
        elseif self.state == 'dead' then
          self:update_dead()
        end
        self.y += self.vel.y
        self.x += self.vel.x
        wrap(self)
        self:update_body()
        self:animate()
      end,
    }

    add(enemies, o)

  end
}
