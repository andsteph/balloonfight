aspeed = 0.1
aspeed_max = 3
gspeed = 0.1
gspeed_max = 2
slide_delay = 1

player = {
    anim = 1,
    ball_anim = 1,
    popped = 0,
    lastb4 = false,
    animations = {
        flapping = animation:new('flapping', { 4, 6, 4, 8 }, 3, true),
        standing = animation:new('standing', { 34, 36, 34, 38 }, 30, true),
        running = animation:new('running', { 40, 42, 40, 44 }, 3, true),
        falling = animation:new('falling', { 10, 12, 14, 12 }, 3, true),
    },
    state = 'grounded',
    vel = { x = 0, y = 0 },
    lives = 2,
    score = 0,
    slide_timer = 0,
    body = { x = 0, y = 0, width = 8, height = 16 },
    ball_body = { x = 0, y = 0, width = 8, height = 8 },
    foot_body = { x = 0, y = 0, width = 8, height = 8 },
    direction = right,
    last_direction = right,
    balloons = 2,

    init = function(self)
        self.balloons = 2
        self.direction = right
        self.last_direction = right
        self.score = 0
        self.lives = 2
        self:reset()
    end,

    reset = function(self)
        self.balloons = 2
        self.x = 0
        self.y = 104
        self.vel.x = 0
        self.vel.y = 0
        self.state = 'grounded'
    end,

    draw = function(self)
        local flip_x = false
        local sprite = self.sprite
        if self.balloons == 2 then
            sprite = sprite + 62
        end
        if self.direction == right then
            flip_x = true
        end
        spr(sprite, self.x, self.y, 2, 2, flip_x)
    end,

    die = function(self)
        if self.lives < 1 then
            over:init()
        else
            self.lives -= 1
            self:reset()
        end
    end,

    pop = function(self)
        self.balloons -= 1
        self.popped = pop_delay
        if self.balloons < 1 then
            self.vel.y -= 1
            self.state = 'falling'
        end
    end,

    update_physics = function(self)
        local test_body = {}
        test_body.width = self.body.width
        test_body.height = self.body.height
        test_body.x = self.body.x
        test_body.y = self.body.y
        test_body.y += self.vel.y
        local v_coll = collisions:check_level(test_body)
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
        local h_coll = collisions:check_level(test_body)
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
        self.last_direction = self.direction
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
        if input.x == 0 then
            self.sprite = self.animations.standing:get()
            if self.vel.x > gspeed then
                self.vel.x -= gspeed
            elseif self.vel.x < -gspeed then
                self.vel.x += gspeed
            end
        else
            self.vel.x += input.x * gspeed
            self.vel.x = mid(-gspeed_max, self.vel.x, gspeed_max)
            self.sprite = self.animations.running:get()
        end
    end,

    update_flying = function(self)
        self:update_input()
        if input.b4 or input.b5 then
            self.vel.x += input.x * aspeed
            self.vel.x = mid(-aspeed_max, self.vel.x, aspeed_max)
            self.sprite = self.animations.flapping:get()
        else
            self.sprite = self.animations.flapping:get(1)
        end
    end,

    update_caught = function(self)
        self.vel.x = 0
        self.vel.y = fish.speed
        if self.y > 110 then
            self:die()
            fish.catch = false
        end
    end,

    update_falling = function(self)
        self.vel.x = 0
        self.y += self.vel.y
        self.sprite = self.animations.falling:get()
        if self.y > 255 then
            self:die()
        end
    end,

    update = function(self)
        self.vel.y += gravity
        if self.balloons < 1 then
            self.state = 'falling'
        end
        if self.state == 'grounded' then
            self:update_grounded()
        elseif self.state == 'flying' then
            self:update_flying()
        elseif self.state == 'caught' then
            self:update_caught()
        elseif self.state == 'falling' then
            self:update_falling()
        end
        self:update_physics()
        self.y += self.vel.y
        self.x += self.vel.x
        wrap(self)
        self:update_body()
        if self.popped > 0 then
            self.popped -= 1
        end
    end,
}
