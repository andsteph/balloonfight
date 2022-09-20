player = {
    anim = 1,
    ball_anim = 1,
    popped = 0,
    lastb4 = false,
    animations = {
        flapping = animation:new('flapping', { 4, 6, 4, 8 }, 3, true),
        standing = animation:new('standing', { 34, 36, 34, 38 }, 30, true),
        running = animation:new('running', { 40, 42, 40, 44 }, 3, true),
        dying = animation:new('dying', { 10, 12, 14, 12 }, 3, true),
    },
    state = 'grounded',
    vel = { x = 0, y = 0 },
    lives = 2,
    score = 0,

    init = function(self)
        self.balloons = 2
        self.direction = right
        self.score = 0
        self.lives = 2
        self:reset()
    end,

    reset = function(self)
        self.balloons = 2
        self.x = 0
        self.y = 104
        self.vel = { x = 0, y = 0 }
        self.body = { x = 0, y = 0, width = 8, height = 16 }
        self.ball_body = { x = 0, y = 0, width = 8, height = 8 }
        self.foot_body = { x = 0, y = 0, width = 8, height = 8 }
    end,

    animate = function(self)
        if self.balloons < 1 then
            self.sprite = self.animations.dying:get()
        else
            if self.state == 'grounded' then
                self.sprite = self.animations.standing:get()
                if input.x ~= 0 then
                    self.sprite = self.animations.running:get()
                end
            elseif input.b4 or input.b5 then
                self.sprite = self.animations.flapping:get()
            else
                self.sprite = self.animations.flapping:get(1)
            end
            if self.balloons == 2 then
                self.sprite = self.sprite + 62
            end
        end
    end,

    draw = function(self)
        local flip_x = false
        if self.direction == right then
            flip_x = true
        end
        spr(self.sprite, self.x, self.y, 2, 2, flip_x)
        debug:draw_body(self.body, 10)
        debug:draw_body(self.ball_body, 12)
        debug:draw_body(self.foot_body, 8)
    end,

    pop = function(self)
        if self.popped <= 0 then
            self.balloons -= 1
            self.popped = pop_delay
        end
    end,

    update_physics = function(self)
        local test_body = {}
        test_body.width = self.body.width
        test_body.height = self.body.height
        test_body.x = self.body.x
        test_body.y = self.body.y
        test_body.y += self.vel.y
        local v_coll = level:collision(test_body)
        if v_coll then
            if self.vel.y < 0 then
                self.vel.y = bounce(self.vel.y)
            elseif self.vel.y > 0 then
                self.state = 'grounded'
                self.vel.y = 0
                self.y = v_coll.y - 16
            end
        else
            self.state = 'flying'
        end
        if self.y < 0 and
            self.vel.y < 0 then
            self.vel.y = abs(self.vel.y) / 2
        end
        test_body.x = self.body.x
        test_body.y = self.body.y
        test_body.x += self.vel.x
        local h_coll = level:collision(test_body)
        if h_coll then
            self.vel.x = 0
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

    update_input = function(self)
        if input.x < 0 then
            self.direction = left
        elseif input.x > 0 then
            self.direction = right
        end
        if not self.lastb4 and input.b4 then
            self.vel.y -= force * 2
        elseif input.b5 then
            self.vel.y -= force
        end

    end,

    update_grounded = function(self)
        self:update_input()
        if input.x ~= 0 then
            self.vel.x += input.x * gspeed
            self.vel.x = mid(-gspeed_max, self.vel.x, gspeed_max)
        end
    end,

    update_flying = function(self)
        self:update_input()
        if input.b4 or input.b5 then
            self.vel.x += input.x * aspeed
            self.vel.x = mid(-aspeed_max, self.vel.x, aspeed_max)
        end
    end,

    update_caught = function(self)
        self.x = fish.x
        self.y = fish.y
    end,

    update_dead = function(self)
        self.y += self.vel.y
        if self.y > 255 then
            if self.lives < 1 then
                over:init()
            else
                self.lives -= 1
                self:init()
            end
        end
    end,

    update = function(self)
        self.vel.y += gravity
        if self.balloons < 1 then
            self.state = 'dead'
        end
        if self.state == 'grounded' then
            self:update_grounded()
        elseif self.state == 'flying' then
            self:update_flying()
        elseif self.state == 'caught' then
            self:update_caught()
        elseif self.state == 'dead' then
            self:update_dead()
        end
        self:update_physics()
        self.y += self.vel.y
        self.x += self.vel.x
        wrap(self)
        self:update_body()
        self:animate()
        if self.popped > 0 then
            self.popped -= 1
        end
    end,
}
